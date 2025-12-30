report 50002 "Employee Yearly Grade Increase"
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
            var
                DefaultPercentage: Decimal;
                ApproalsalPercentage: Decimal;
            begin
                Employee.SetCurrentKey("Employment Date");

                if RunOnceInYear then begin
                    Employee.Reset;
                    if EmployeeNo <> '' then
                        Employee.SetRange("No.", EmployeeNo);
                    Employee.SetRange("Employment Type", Employee."Employment Type"::Permanent);
                    Employee.SetRange(Status, Employee.Status::Active);
                    if Employee.FindSet then
                        repeat
                            DefaultPercentage := 0;
                            ApproalsalPercentage := 0;
                            LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level");

                            NextLevelWiseAttributes.Reset;
                            NextLevelWiseAttributes.SetCurrentKey(Grade);
                            NextLevelWiseAttributes.SetRange("Level Code", Employee."Salary Level");
                            NextLevelWiseAttributes.SetFilter(Grade, '>%1', LevelWiseAttributes.Grade);
                            if NextLevelWiseAttributes.FindFirst then begin
                                UpdateServiceHistory(EnglishNepaliDate."English Date", 'Auto Grade increment once in year', NextLevelWiseAttributes."Level Code", NextLevelWiseAttributes."Grade Code");
                                OnIncreaseGradeOnbeforeSetGradePercentage(Employee, DefaultPercentage, ApproalsalPercentage);
                                CreateGradeEntry(Employee."No.", NextLevelWiseAttributes."Level Code", NextLevelWiseAttributes."Grade Code", DefaultPercentage, ApproalsalPercentage);
                                Employee.Validate("Salary Grade", NextLevelWiseAttributes."Grade Code");
                                Employee.Modify(true);
                            end;
                        until Employee.Next = 0;
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

        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Date", WorkDate);
        EnglishNepaliDate.FindFirst;

        RunOnceInYear := (EnglishNepaliDate."Nepali Day" = 1) and (EnglishNepaliDate."Nepali Month" = EnglishNepaliDate."Nepali Month"::Baisakh);
        RunOnceInYear := true;  //for sometime
                                // RunOnceInMonth := EnglishNepaliDate."Nepali Day" = 1;
    end;

    var
        LevelWiseAttributes: Record "Level Wise Attributes";
        HRSetup: Record "Human Resources Setup";
        EnglishNepaliDate: Record "English-Nepali Date";
        RunOnceInYear: Boolean;
        Employee: Record Employee;
        NextLevelWiseAttributes: Record "Level Wise Attributes";
        EmployeeServiceHistory: Record "Employee Service History";
        EmployeeNo: Code[20];

    local procedure UpdateServiceHistory(EffectiveDate: Date; RemarksTxt: Text; Newlevel: Code[20]; NewGrade: Code[20])
    begin
        Clear(EmployeeServiceHistory);
        EmployeeServiceHistory.Init;
        EmployeeServiceHistory.Validate("Employee No.", Employee."No.");
        EmployeeServiceHistory."Service Event" := EmployeeServiceHistory."Service Event"::"Grade Increment";

        EmployeeServiceHistory.Validate("Salary Level (To)", Newlevel);
        EmployeeServiceHistory.Validate("Salary Grade (To)", NewGrade);
        EmployeeServiceHistory.Validate("Effective Date", EffectiveDate);
        EmployeeServiceHistory.Validate(Remarks, RemarksTxt + Format(EnglishNepaliDate."Nepali Date"));
        EmployeeServiceHistory."Created by" := UserId;
        EmployeeServiceHistory."Created DateTime" := CurrentDateTime;

        EmployeeServiceHistory."Deputation Code (From)" := '';
        EmployeeServiceHistory."Deputation On(From)" := EmployeeServiceHistory."Deputation On(From)"::" ";
        EmployeeServiceHistory."Deputation Value (From)" := '';

        EmployeeServiceHistory.Insert(true);
    end;

    local procedure CreateGradeEntry(EmployeeNo: Code[20]; NewLevel: Code[20]; NewGrade: Code[20]; DefaultPercentage: Decimal; AppraisalPercentage: Decimal)
    var
        GradeEntry: Record "Grade Entry";
    begin
        GradeEntry.Init();
        GradeEntry.Validate("Employee No.", EmployeeNo);
        GradeEntry.Validate("Salary Level", NewLevel);
        GradeEntry.Validate(Grade, NewGrade);
        GradeEntry.Validate("Default Grade Percentage", DefaultPercentage);
        GradeEntry.Validate("Appraisal Grade Percentage", AppraisalPercentage);
        GradeEntry.Insert(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnIncreaseGradeOnbeforeSetGradePercentage(var Employee: Record Employee; var DefaultGradePercentage: Decimal; var AppraisalGradePercentage: Decimal)
    begin
    end;
}
