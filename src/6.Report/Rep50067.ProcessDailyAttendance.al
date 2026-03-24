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
                    if Date."Period Start" > Today then
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
                    Employee.Status::Active:
                        begin
                            if Employee."Employment Type" = Employee."Employment Type"::Contract then
                                if (Employee."Contract Expiry Date" <> 0D) and (Employee."Contract Expiry Date" < ToDate) then
                                    ToDateActual := Employee."Contract Expiry Date" - 1;
                            if Employee."Employment Type" in [Employee."Employment Type"::Probation, Employee."Employment Type"::Temporary, Employee."Employment Type"::Outsource] then
                                if (Employee."Trainee/Probation End date" <> 0D) and (Employee."Trainee/Probation End date" < ToDate) then
                                    ToDateActual := Employee."Trainee/Probation End date" - 1;
                            if Employee."Resignation Date" <> 0D then
                                if Employee."Resignation Date" < ToDate then
                                    ToDateActual := Employee."Resignation Date" - 1;
                        end;
                end;

                if FromDateActual > ToDateActual then
                    CurrReport.Skip();

                if AttSetup."Different Emp. ID for Device" then
                    CheckAndUpdateEmployeeInLog();
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
                    field(EmailIds; EmailIds)
                    {
                        Caption = 'Email Id';
                        ApplicationArea = All;
                    }
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
            FromDate := Today - 1;
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
        AttSetup: Record "Attendance Setup";
        FromDateActual: Date;
        ToDateActual: Date;
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
        shiftmgt: Codeunit "Shift Assignment Mgt";
        RegularShiftCode: Code[20];
    begin
        RegularShiftCode := shiftmgt.ReturnEmployeeWorkShift(Employee."No.", Date."Period Start");
        InsertEmpAttendance(Employee."No.", Date."Period Start", shiftmgt.ReturnEmployeeWorkShift(Employee."No.", Date."Period Start"));
        UpdateEmpAttendanceAsTransferFromServiceHistory();
    end;
    
    local procedure InsertEmpAttendance(EmpCode: Text; PostingDate: Date; WorkShift: Text)
    var
        EmpVar: Record Employee;
        EngNep: Record "English-Nepali Date";
    begin
        if not EmpAttendance.Get(EmpCode, PostingDate, WorkShift) then begin
            Clear(EmpAttendance);
            EmpAttendance.Init;
            EmpAttendance.Validate("Employee No.", Employee."No.");
            EmpAttendance.Validate("Attendance Date", Date."Period Start");
            EmpAttendance.Validate("Employee working Shift", WorkShift);
            EmpAttendance."Employee Name" := Employee.FullName();
            EmpAttendance."Attendance Date (B.S)" := EngNep.GetNepaliDate(Date."Period Start");
            EmpAttendance.Week := Enum::Week.FromInteger(Enum::Week.Ordinals.Get(Enum::Week.Names.indexof(Date."Period Name")));//  Date."Period Name";
            EmpAttendance.Validate("Attendance Date", Date."Period Start");
            EmpAttendance.Insert(true);

            EmpVar.Get(EmpCode);
            EmpAttendance.CopyFromEmployee(EmpVar);
            EmpAttendance.Modify();
        end;
    end;

    local procedure UpdateEmpAttendanceAsTransferFromServiceHistory()
    var
        ServiceHistory: Record "Employee Service History";
    begin
        ServiceHistory.SetLoadFields("Province Code (To)", "Province Description (To)", "Branch Code (To)", "Branch Description (To)", "Department Code (To)", "Department Description (To)", "Unit Code (To)", "Extension Description (To)");
        ServiceHistory.SetRange("Employee No.", Employee."No.");
        ServiceHistory.SetRange("Service Event", ServiceHistory."Service Event"::Transfer);
        ServiceHistory.SetFilter("Effective Date", '<=%1', Date."Period Start");
        if ServiceHistory.FindLast() then begin
            EmpAttendance."Deputation On" := ServiceHistory."Deputation On (To)";
            EmpAttendance."Deputation On Code" := ServiceHistory."Deputation Code (To)";
            EmpAttendance."Province Code" := ServiceHistory."Province Code (To)";
            EmpAttendance."Province Name" := ServiceHistory."Province Description (To)";
            EmpAttendance."Branch Code" := ServiceHistory."Branch Code (To)";
            EmpAttendance."Branch Name" := ServiceHistory."Branch Description (To)";
            EmpAttendance."Department Code" := ServiceHistory."Department Code (To)";
            EmpAttendance."Department Name" := ServiceHistory."Department Description (To)";
            EmpAttendance."Unit Code" := ServiceHistory."Unit Code (To)";
            EmpAttendance."Extension Counter" := ServiceHistory."Extension Description (To)";
            EmpAttendance."Functional Title" := ServiceHistory."Functional Title (To)";
            EmpAttendance."Functional Title Desc" := ServiceHistory."Functional Title Desc. (To)";
            EmpAttendance.Modify();
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
                if (Employee."Resignation Date" = 0D) or (Employee."Resignation Date" > FromDate) then
                    exit(true)
                else
                    exit(false);
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

    procedure CheckAndUpdateEmployeeInLog()
    var
        AttendanceLog: Record "Attendance Log";
    begin
        if Employee."Employee Attendance ID" = '' then
            exit;
        AttendanceLog.SetRange("Machine Emp. Code", Employee."Employee Attendance ID");
        AttendanceLog.SetRange(Date, FromDateActual, ToDateActual);
        if AttendanceLog.FindSet() then
            AttendanceLog.ModifyAll("Employee ID", Employee."No.");
    end;
}
