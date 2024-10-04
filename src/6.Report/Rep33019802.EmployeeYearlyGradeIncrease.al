report 33019802 "Employee Yearly Grade Increase"
{
    Caption = 'Employee Yearly Grade Increment';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                Employee.SetCurrentKey("Employment Date");

                if RunOnceInYear then begin
                    Employee.Reset;
                    if EmployeeNo <> '' then
                        Employee.SetRange("No.", EmployeeNo);
                    Employee.SetRange("Employment Type", Employee."Employment Type"::Permanent);
                    Employee.SetRange(Status, Employee.Status::Active);
                    Employee.SetFilter("Employment Date", '<%1&<>%2', HRSetup."Employment Before (Grade Incre", 0D);
                    if Employee.FindSet then
                        repeat
                            LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level");

                            NextLevelWiseAttributes.Reset;
                            NextLevelWiseAttributes.SetCurrentKey(Grade);
                            NextLevelWiseAttributes.SetRange("Level Code", Employee."Salary Level");
                            NextLevelWiseAttributes.SetFilter(Grade, '>%1', LevelWiseAttributes.Grade);
                            if NextLevelWiseAttributes.FindFirst then begin
                                UpdateServiceHistory(EnglishNepaliDate."English Date", 'Auto Grade increment by HRMS on ');
                                Employee.Validate("Salary Grade", NextLevelWiseAttributes."Grade Code");
                                Employee.Modify(true);
                            end;
                        until Employee.Next = 0;
                end;

                if RunOnceInMonth then begin
                    EnglishNepaliDate2.Reset;
                    EnglishNepaliDate2.SetRange("English Date", WorkDate);
                    EnglishNepaliDate2.FindFirst;

                    EnglishNepaliDate.Reset;
                    EnglishNepaliDate.SetRange("Nepali Day", EnglishNepaliDate2."Nepali Day");
                    EnglishNepaliDate.SetRange("Nepali Month", EnglishNepaliDate2."Nepali Month");
                    EnglishNepaliDate.SetFilter("English Year", '<=%1', Date2DMY(WorkDate, 3));
                    EnglishNepaliDate.SetFilter("English Date", '>=%1', HRSetup."Employment Before (Grade Incre");
                    if EnglishNepaliDate.FindFirst then
                        repeat
                            Employee.Reset;
                            if EmployeeNo <> '' then
                                Employee.SetRange("No.", EmployeeNo);
                            Employee.SetRange("Employment Type", Employee."Employment Type"::Permanent);
                            Employee.SetRange(Status, Employee.Status::Active);
                            Employee.SetFilter("Employment Date", '>=%1', HRSetup."Employment Before (Grade Incre");
                            Employee.SetRange("Confirmation Date", EnglishNepaliDate."English Date");
                            if Employee.FindSet then
                                repeat
                                    LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level");
                                    NextLevelWiseAttributes.Reset;
                                    NextLevelWiseAttributes.SetCurrentKey(Grade);
                                    NextLevelWiseAttributes.SetRange("Level Code", Employee."Salary Level");
                                    NextLevelWiseAttributes.SetFilter(Grade, '>%1', LevelWiseAttributes.Grade);
                                    if NextLevelWiseAttributes.FindFirst then begin
                                        EnglishNepaliDate1.Reset;
                                        EnglishNepaliDate1.SetRange("Nepali Day", 1);
                                        EnglishNepaliDate1.SetRange("Nepali Month", EnglishNepaliDate."Nepali Month");
                                        EnglishNepaliDate1.SetFilter("Nepali Year", '>%1', EnglishNepaliDate."Nepali Year");
                                        EnglishNepaliDate1.FindFirst;
                                        UpdateServiceHistory(EnglishNepaliDate1."English Date", 'Auto Grade increment by HRMS on ');
                                        Employee.Validate("Salary Grade", NextLevelWiseAttributes."Grade Code");
                                        Employee.Modify(true);
                                    end;
                                until Employee.Next = 0;
                        until EnglishNepaliDate.Next = 0;

                    EnglishNepaliDate.Reset;
                    if EnglishNepaliDate2."Nepali Month" = EnglishNepaliDate2."Nepali Month"::Baisakh then
                        EnglishNepaliDate.SetRange("Nepali Month", EnglishNepaliDate2."Nepali Month"::Chaitra)
                    else
                        EnglishNepaliDate.SetRange("Nepali Month", EnglishNepaliDate2."Nepali Month" - 1);
                    EnglishNepaliDate.SetFilter("English Year", '<=%1', Date2DMY(WorkDate, 3));
                    EnglishNepaliDate.SetFilter("English Date", '>=%1', HRSetup."Employment Before (Grade Incre");
                    if EnglishNepaliDate.FindFirst then
                        repeat
                            Employee.Reset;
                            if EmployeeNo <> '' then
                                Employee.SetRange("No.", EmployeeNo);
                            Employee.SetRange("Employment Type", Employee."Employment Type"::Permanent);
                            Employee.SetRange(Status, Employee.Status::Active);
                            Employee.SetFilter("Employment Date", '>=%1', HRSetup."Employment Before (Grade Incre");
                            Employee.SetRange("Confirmation Date", EnglishNepaliDate."English Date");
                            if Employee.FindSet then
                                repeat
                                    LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level");
                                    NextLevelWiseAttributes.Reset;
                                    NextLevelWiseAttributes.SetCurrentKey(Grade);
                                    NextLevelWiseAttributes.SetRange("Level Code", Employee."Salary Level");
                                    NextLevelWiseAttributes.SetFilter(Grade, '>%1', LevelWiseAttributes.Grade);
                                    if NextLevelWiseAttributes.FindFirst then begin
                                        EnglishNepaliDate1.Reset;
                                        EnglishNepaliDate1.SetRange("Nepali Day", 1);
                                        EnglishNepaliDate1.SetRange("Nepali Month", EnglishNepaliDate2."Nepali Month");
                                        EnglishNepaliDate1.SetFilter("Nepali Year", '>%1', EnglishNepaliDate."Nepali Year");
                                        EnglishNepaliDate1.FindFirst;
                                        UpdateServiceHistory(EnglishNepaliDate1."English Date", 'Auto Grade increment by HRMS on ');
                                        Employee.Validate("Salary Grade", NextLevelWiseAttributes."Grade Code");
                                        Employee.Modify(true);
                                    end;
                                until Employee.Next = 0;
                        until EnglishNepaliDate.Next = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Updated');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(EmployeeNo; EmployeeNo)
                {
                    Caption = 'Employee No.';
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        HRSetup.Get;
        HRSetup.TestField("Employment Before (Grade Incre");

        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Date", WorkDate);
        EnglishNepaliDate.FindFirst;

        RunOnceInYear := (EnglishNepaliDate."Nepali Day" = 1) and (EnglishNepaliDate."Nepali Month" = EnglishNepaliDate."Nepali Month"::Baisakh);

        RunOnceInMonth := EnglishNepaliDate."Nepali Day" = 1;
    end;

    var
        LevelWiseAttributes: Record "Level Wise Attributes";
        HRSetup: Record "Human Resources Setup";
        EnglishNepaliDate: Record "English-Nepali Date";
        RunOnceInYear: Boolean;
        Employee: Record Employee;
        NextLevelWiseAttributes: Record "Level Wise Attributes";
        EmployeeServiceHistory: Record "Employee Service History";
        EnglishNepaliDate1: Record "English-Nepali Date";
        EmployeeNo: Code[20];
        EnglishNepaliDate2: Record "English-Nepali Date";
        RunOnceInMonth: Boolean;

    local procedure UpdateServiceHistory(EffectiveDate: Date; RemarksTxt: Text)
    begin
        Clear(EmployeeServiceHistory);
        EmployeeServiceHistory.Init;
        EmployeeServiceHistory.Validate("Employee No.", Employee."No.");
        EmployeeServiceHistory."Service Event" := EmployeeServiceHistory."Service Event"::"Grade Increment";
        EmployeeServiceHistory.Validate("Functional Title (From)", Employee."Functional Title");
        EmployeeServiceHistory.Validate("Deputation On(From)", Employee."Deputation on");
        EmployeeServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
        EmployeeServiceHistory.Validate("Deputation Code (From)", Employee."Deputation On Code");
        EmployeeServiceHistory.Validate("Deputation Code (To)", Employee."Deputation On Code");
        EmployeeServiceHistory.Validate("Salary Level (From)", Employee."Salary Level");
        EmployeeServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
        EmployeeServiceHistory.Validate("Salary Grade (From)", Employee."Salary Grade");
        EmployeeServiceHistory.Validate("Salary Grade (To)", NextLevelWiseAttributes."Grade Code");
        EmployeeServiceHistory.Validate("Effective Date", EffectiveDate);
        EmployeeServiceHistory.Validate(Remarks, RemarksTxt + Format(EnglishNepaliDate."Nepali Date"));
        EmployeeServiceHistory."Created by" := UserId;
        EmployeeServiceHistory."Created DateTime" := CurrentDateTime;
        EmployeeServiceHistory.Insert(true);
    end;
}
