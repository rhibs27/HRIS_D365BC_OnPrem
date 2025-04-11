report 50136 "Re-instiate HR Transfer"
{
    // //Min 1.3 --- Added ServiceHistory."Service Event"::"Back From Deputation" Parameter instead of ServiceHistory."Service Event"::"Transfer".

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Date; Date)
        {
            dataitem(Employee; Employee)
            {
                DataItemTableView = where(Status = const(Active));
                RequestFilterFields = "No.", "Employment Type", Status;

                trigger OnAfterGetRecord()
                begin
                    ReinstateTranferedEmployee;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Employment Date", '<=%1', InitialDate);
                    SetRange(Status, Employee.Status::Active); //Min 8.26.2022
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(InitialDate);
                InitialDate := "Period Start";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Period Start", FromDate, ToDate);
                SetRange("Period Type", "Period Type"::Date);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("From Date"; FromDate)
                {
                    ToolTip = 'Specifies the value of the FromDate field.';
                    ApplicationArea = All;
                }
                field("To Date"; ToDate)
                {
                    ToolTip = 'Specifies the value of the ToDate field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        Message('Success');
    end;

    trigger OnPreReport()
    begin
        if FromDate = 0D then
            FromDate := Today - 1;
        if ToDate = 0D then
            ToDate := Today - 1;

        if FromDate > ToDate then
            Error('From Date %1 must be less than to date %2.', FromDate, ToDate);

        UserSetup.Get(UserId);
        if not UserSetup."Run Back Date Daily Attend." then
            if FromDate < Today - 1 then
                Error('You are not eligible to run back date daily attendance.');

        if (FromDate > Today) or (ToDate > Today) then //Min
            Error('Cannot run attendance of future date. Please check the date.');
    end;

    var
        InitialDate: Date;
        HRMgt: Codeunit "HR Mgt.";
        FromDate: Date;
        ToDate: Date;
        EmployeeActivity: Record "Employee Activity";
        UserSetup: Record "User Setup";
        EmployeeServiceHistory: Record "Employee Service History";

    local procedure ReinstateTranferedEmployee()
    var
        ServiceHistory: Record "Employee Service History";
        ServiceCode: Code[20];
        EmpActivity: Record "Employee Activity";
        PreviousServiceHistory: Record "Employee Service History";
    begin
        EmployeeActivity.Reset;
        EmployeeActivity.SetRange("Employee No.", Employee."No.");
        EmployeeActivity.SetFilter("Transfer Category", '%1|%2', EmployeeActivity."Transfer Category"::"Temporary", EmployeeActivity."Transfer Category"::Officiating);
        EmployeeActivity.SetFilter(Type, '%1|%2', EmployeeActivity.Type::"HR Transfer", EmployeeActivity.Type::"Employee Transfer");
        EmployeeActivity.SetFilter("Approval Status", '%1|%2', EmployeeActivity."Approval Status"::Approved, EmployeeActivity."Approval Status"::Acknowledged); //Min -- added Filter Approved option instead of Acknowledge.
        EmployeeActivity.SetRange("End Date", InitialDate, InitialDate);
        if EmployeeActivity.FindFirst then begin
            EmployeeServiceHistory.Reset;
            EmployeeServiceHistory.SetRange("Service Event", EmployeeServiceHistory."Service Event"::"Back From Deputation");
            EmployeeServiceHistory.SetRange("Employee No.", EmployeeActivity."Employee No.");
            EmployeeServiceHistory.SetRange("Document No.", EmployeeActivity."No.");
            if not EmployeeServiceHistory.FindFirst then begin //Min 9.26.2022
                if EmployeeActivity."Approval Status" = EmployeeActivity."Approval Status"::Acknowledged then begin
                    EmpActivity.Reset;
                    EmpActivity.SetRange("Employee No.", Employee."No.");
                    EmpActivity.SetRange("Transfer Category", EmpActivity."Transfer Category"::General);
                    EmpActivity.SetFilter(Type, '%1|%2', EmpActivity.Type::"HR Transfer", EmpActivity.Type::"Employee Transfer");
                    EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Acknowledged);
                    EmpActivity.SetFilter("Acknowledged Date", '>%1', EmployeeActivity."Acknowledged Date");
                    if EmpActivity.FindFirst then
                        exit;
                end;
                ServiceCode := HRMgt.AddToServiceHistory(Employee."No.", ServiceHistory."Service Event"::"Back From Deputation", 'Reinstating Transfer', InitialDate); //Min 1.3
                Employee.Validate("Functional Title", EmployeeActivity."Functional Title");
                Employee.Validate("Deputation on", EmployeeActivity."Deputation On");
                case Employee."Deputation on" of
                    Employee."Deputation on"::Branch:
                        Employee.Validate("Global Dimension 1 Code", EmployeeActivity."Shortcut Dimension 1 Code");
                    Employee."Deputation on"::Province:
                        Employee.Validate("Province Code", EmployeeActivity."Province Code");
                    // Employee."Deputation on"::"Sub Province":
                    //     Employee.Validate("Sub Province Code", EmployeeActivity."Sub Province Code");
                    Employee."Deputation on"::Unit:
                        Employee.Validate("Unit Code", EmployeeActivity."Unit Code");
                    Employee."Deputation on"::"Extension Counter":
                        Employee.Validate("Extension Counter Code", EmployeeActivity."Extension Counter Code");
                    Employee."Deputation on"::Department:
                        Employee.Validate("Department Code", EmployeeActivity.Department);
                end;
                Employee.Modify;
                if ServiceHistory.Get(ServiceCode) then begin
                    ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
                    ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
                    ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
                    ServiceHistory.Validate("Deputation Code (To)", HRMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                    ServiceHistory.Validate("Deputation Value (To)", HRMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                    ServiceHistory.Validate("Document No.", EmployeeActivity."No."); //Min 9.26.2022
                    PreviousServiceHistory.Reset;
                    PreviousServiceHistory.SetRange("Employee No.", Employee."No.");
                    PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceCode);
                    PreviousServiceHistory.SetCurrentKey("Effective Date");
                    if PreviousServiceHistory.FindLast then begin
                        ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
                    end;
                    ServiceHistory.Modify;
                end;
            end;
        end;
    end;
}
