report 50067 "Process Daily Attendance"
{
    ApplicationArea = All;
    Caption = 'Process Daily Attendance';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Employee; Employee)
        {

            RequestFilterFields = "No.", "Date Filter";

            dataitem(Date; Date)
            {
                DataItemTableView = sorting("Period Type", "Period Start");
                dataitem(EmpAttendance; "Employee Attendance & Activity")
                {
                    DataItemTableView = sorting("Employee No.", "Attendance Date");
                    column(Employee_No_; "Employee No.") { }
                    column(Attendance_Date; "Attendance Date") { }
                    column(LastError; LastError) { }
                    trigger OnPreDataItem()
                    begin
                        SetRange("Employee No.", Employee."No.");
                        SetRange("Attendance Date", Date."Period Start");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        Commit();
                        ProcessDailyAttendance.GetSyncProcessBoolean(FromSyncProcess);
                        if not ProcessDailyAttendance.Run(EmpAttendance) then
                            PrepareEmailArray();
                    end;
                }
                trigger OnPreDataItem()
                begin
                    SetRange("Period Type", Date."Period Type"::Date);
                    SetRange("Period Start", FromDateActual, ToDateActual);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Employee."Employment Date" > Date."Period Start" then
                        CurrReport.Skip();
                    InitEmpAttendance();
                end;
            }
            trigger OnPreDataItem()
            begin
                if not JobQueueActive then begin
                    ProgressWindow.Open(Text000);
                    TotalCount := Employee.Count;
                end;

            end;

            trigger OnAfterGetRecord()
            begin
                if not IsValidEmployee() then
                    CurrReport.Skip();
                if "Employment Date" = 0D then
                    CurrReport.Skip;

                FromDateActual := FromDate;
                ToDateActual := ToDate;
                case Employee.Status of
                    Employee.Status::Terminated:
                        if (Employee."Termination Date" <> 0D) and (Employee."Termination Date" < ToDate) then
                            ToDateActual := Employee."Termination Date" - 1;
                    Employee.Status::Inactive:
                        if (Employee."Inactive Date" <> 0D) and (Employee."Inactive Date" < ToDate) then
                            ToDateActual := Employee."Inactive Date" - 1;
                // Employee.Status::Active:
                //     if (Employee."Force Retirement Date" <> 0D) and (Employee."Force Retirement Date" < ToDate) then
                //         ToDateActual := Employee."Force Retirement Date" - 1;
                end;

                if Employee."Employment Type" = Employee."Employment Type"::Contract then
                    if (Employee."Contract Expiry Date" <> 0D) and (Employee."Contract Expiry Date" < ToDate) then
                        ToDateActual := Employee."Contract Expiry Date";

                if FromDateActual > ToDateActual then
                    CurrReport.Skip();

                if not JobQueueActive then begin
                    IntCount += 1;
                    ProgressWindow.Update(1, Employee."No.");
                    ProgressWindow.Update(2, Format(Round(IntCount / TotalCount * 100, 0.01, '=')) + ' %');
                end;
            end;

            trigger OnPostDataItem()
            begin
                if not JobQueueActive then
                    ProgressWindow.Close;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    // field(SyncBiometricAtt; SyncBiometricAtt)
                    // {
                    //     Caption = 'Sync Biometric Attendance Before Processing';
                    //     ApplicationArea = All;
                    // }
                    // field(EmailIds; EmailIds)
                    // {
                    //     Caption = 'Email Id';
                    //     ApplicationArea = All;
                    // }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        GetSetup();
        if Employee.GetFilter("Date Filter") <> '' then begin
            FromDate := Employee.GetRangeMin("Date Filter");
            ToDate := Employee.GetRangeMax("Date Filter");
        end else begin
            FromDate := Today - 3;
            ToDate := Today;
        end;
    end;

    trigger OnPostReport()
    begin
        SendEmail();
    end;

    var
        Text000: TextConst ENU = 'Employee No.: #1############### \Processing #2###############';
        FromDate: Date;
        ToDate: Date;
        ProgressWindow: Dialog;
        IntCount: Integer;
        EmpWorkShift: Record "Employee Work Shift";
        AttSetup: Record "Attendance Setup";
        FromDateActual: Date;
        ToDateActual: Date;
        SyncBiometricAtt: Boolean;
        TotalCount: Integer;
        LastError: Text;
        EmailIds: Text;
        ProcessDailyAttendance: Codeunit "Process Daily Attendance";
        EmailText: Text;
        EMailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailArray: JsonArray;
        FromSyncProcess: Boolean;

    procedure GetSetup()
    begin
        AttSetup.Get;
        AttSetup.TestField("Base Calender");
    end;

    local procedure PrepareEmailArray()
    var
        JObject: JsonObject;
    begin
        JObject.Add('Date', Format(EmpAttendance."Attendance Date"));
        JObject.Add('Employee No.', Employee."No.");
        JObject.Add('Employee Name', Employee."Full Name");
        JObject.Add('Error', GetLastErrorText());
        EmailArray.Add(JObject);
    end;

    procedure InitEmpAttendance()
    var
        ShiftLine: Record "Shift Line";
    begin
        ShiftLine.SetLoadFields("Employee No", "Roster Date", "Approval Status", "Substitute Type", "Employee Work Shift");
        ShiftLine.SetRange("Roster Date", Date."Period Start");
        ShiftLine.SetRange("Employee No", Employee."No.");
        ShiftLine.SetRange("Approval Status", ShiftLine."Approval Status"::Approved);
        ShiftLine.Setfilter("Substitute Type", '%1|%2', ShiftLine."Substitute Type"::" ", ShiftLine."Substitute Type"::"Added as Substitute");
        if ShiftLine.FindSet() then
            repeat
                InsertEmpAttendance(ShiftLine."Employee No", ShiftLine."Roster Date", ShiftLine."Employee Work Shift", true);
            until ShiftLine.Next() = 0
        else
            InsertEmpAttendance(Employee."No.", Date."Period Start", Employee."Employee Work Shift", false);

        UpdateEmpAttendanceAsTransfer();
    end;

    local procedure InsertEmpAttendance(EmpCode: Text; PostingDate: Date; WorkShift: Text; IsRoster: Boolean)
    var
        EmpVar: Record Employee;
    begin
        if not EmpAttendance.Get(EmpCode, PostingDate, WorkShift) then begin
            Clear(EmpAttendance);
            EmpAttendance.Init;
            EmpAttendance.Validate("Employee No.", Employee."No.");
            EmpAttendance.Validate("Attendance Date", Date."Period Start");
            EmpAttendance.Validate("Employee working Shift", WorkShift);
            EmpAttendance."Employee Name" := Employee.FullName();
            EmpAttendance.Week := Enum::Week.FromInteger(Enum::Week.Ordinals.Get(Enum::Week.Names.indexof(Date."Period Name")));//  Date."Period Name";
            EmpAttendance.Validate("Attendance Date", Date."Period Start");
            EmpAttendance.Insert(true);

            EmpVar.Get(EmpCode);
            EmpAttendance.CopyFromEmployee(EmpVar);
            EmpAttendance.Modify();
        end;
    end;

    local procedure UpdateEmpAttendanceAsTransfer()
    var
        EmployeeTransfer: Record "Employee Transfer";
    begin
        EmployeeTransfer.SetLoadFields("Employee No.", Type, "Approval Status", "End Date", "Province Code", "From Branch", Department, "Unit Code", "Extension Counter Code");
        EmployeeTransfer.SetRange("Employee No.", Employee."No.");
        EmployeeTransfer.SetRange("Approval Status", EmployeeTransfer."Approval Status"::Approved);
        // EmployeeTransfer.SetFilter(Type, '%1|%2', EmployeeTransfer.Type::"HR Transfer", EmployeeTransfer.Type::"Employee Transfer");
        EmployeeTransfer.SetFilter("End Date", '>%1', Date."Period Start");
        if EmployeeTransfer.FindFirst() then begin
            EmpAttendance."Province Code" := EmployeeTransfer."Province Code";
            EmpAttendance."Province Name" := EmployeeTransfer."Province Name";
            EmpAttendance."Branch Code" := EmployeeTransfer."From Branch";
            EmpAttendance."Branch Name" := EmployeeTransfer."Branch Name";
            EmpAttendance."Department Code" := EmployeeTransfer.Department;
            EmpAttendance."Department Name" := EmployeeTransfer."Department Name";
            EmpAttendance."Unit Code" := EmployeeTransfer."Unit Code";
            EmpAttendance."Extension Counter" := EmployeeTransfer."Extension Counter Code";
        end;
    end;

    procedure JobQueueActive(): Boolean
    begin
        exit(not GuiAllowed);
    end;

    procedure IsValidEmployee(): Boolean
    begin
        if (FromDate <> 0D) and (ToDate <> 0D) then
            if Employee."Employment Date" > ToDate then
                exit(false);

        if (Employee."Employment Type" = Employee."Employment Type"::Contract) and (Employee."Contract Expiry Date" <> 0D) then
            if Employee."Contract Expiry Date" < FromDate then
                exit(false);

        case Employee.Status of
            Employee.Status::Active:
                exit(true);
            Employee.Status::Inactive:

                if Employee."Inactive Date" > FromDate then
                    exit(true)
                else
                    exit(false);
            Employee.Status::Terminated:

                if (Employee."Termination Date" <> 0D) and (Employee."Termination Date" > FromDate) then
                    exit(true)
                else
                    exit(false);
        end;
    end;

    procedure SendEmail()
    var
        Subject: Label 'Process Daily Attendance Error';
        LineJToken: JsonToken;
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        if EmailIds = '' then
            exit;

        if EmailArray.Count = 0 then
            exit;

        EmailText := '<table border="1">';
        EmailText += '<tr>';
        EmailText += StrSubstNo('<td>%1</td>', 'Date');
        EmailText += StrSubstNo('<td>%1</td>', 'Employee No.');
        EmailText += StrSubstNo('<td>%1</td>', 'Employee Name');
        EmailText += StrSubstNo('<td>%1</td>', 'Error');
        EmailText += '<br>';
        EmailText += '</tr>';

        foreach LineJToken in EmailArray do begin
            JObject := LineJToken.AsObject();
            EmailText += '<tr>';
            JObject.Get('Date', JToken);
            EmailText += StrSubstNo('<td>%1</td>', JToken.AsValue().AsText());
            JObject.Get('Employee No.', JToken);
            EmailText += StrSubstNo('<td>%1</td>', JToken.AsValue().AsText());
            JObject.Get('Employee Name', JToken);
            EmailText += StrSubstNo('<td>%1</td>', JToken.AsValue().AsText());
            JObject.Get('Error', JToken);
            EmailText += StrSubstNo('<td>%1</td>', JToken.AsValue().AsText());
            EmailText += '</tr>';
        end;
        EmailText += '</table>';

        EMailMessage.Create(EmailIds, Subject, EmailText, true);
        if Email.Send(EMailMessage) then;
    end;

    procedure GetEmailIds(VarEmailId: Text; VarFromProcess: Boolean)
    begin
        EmailIds := VarEmailId;
        FromSyncProcess := VarFromProcess;
    end;
}
