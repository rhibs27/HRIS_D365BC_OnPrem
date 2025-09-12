table 50021 "Level Wise Attributes"
{
    //field 2 to 40 can be configured for payroll. so do not add any non-payroll field in that range 
    DrillDownPageId = "Posted Employee Activities";
    LookupPageId = "Posted Employee Activities";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Grade Code"; Code[20])
        {
            TableRelation = "Salary Grade";
        }
        field(2; "Level Code"; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(3; Grade; Decimal)
        {
            Editable = false;
        }
        field(4; "Standard Basic Salary"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTotalBasicSalary(Rec);
            end;
        }
        field(5; "Total Basic Salary"; Decimal)
        {
            Description = ' Gross Salary  ( Basic Salary + Grade)';
            Editable = false;
        }
        field(6; Allowance; Decimal)
        {
            Description = 'Fixed Amount of Allowence given to each staff';
        }
        field(7; "Employee Maintenence Allowance"; Decimal)
        {

        }
        field(8; "Transportation Allowance"; Decimal)
        {

        }
        field(9; "Vehicle Maintenence Allowance"; Decimal)
        {

        }
        field(11; "Relocation Allowance"; Decimal)
        {
            Description = '1 month Basic Salary( Basic + Grade)';
        }
        field(12; "Outstation Allowance"; Decimal)
        {
            Description = '25% of Total Basic salary';
        }
        field(13; "Friday Counter Allowance"; Decimal) { }
        field(15; "Facilitator Allowance"; Decimal) { }
        field(16; "Officiating Allowance"; Decimal)
        {
            Description = 'Gross Salary of One Step Higher Post';
        }
        field(17; "Additional Time Allowance"; Decimal)
        {
            Description = '0.75% of Basic Salary (Basic + Salary)';
        }
        field(18; "Staff Vehicle Allowance"; Decimal) { }
        field(21; "Communication Reim. Allowence"; Decimal) { }
        field(22; "Dashain Remuneration"; Decimal)
        {
            Description = 'Total Basic Salary';
        }
        field(23; "Risk Allowance"; Decimal)
        {
            Description = '8% of Total Basic Salary (Basic + grade)';
        }
        field(24; "LFA Allowance"; Decimal)
        {
            Description = '1 month Total Salary (Basic+Grade)';
        }
        field(25; "Night Shift Allowance"; Decimal) { }
        field(100; "Starting Point"; Decimal) { }
        field(101; "Annual Income Inc. Grade"; Decimal)
        {
            trigger OnValidate()
            begin
                TestField("Starting Point");
                Validate("Standard Basic Salary", "Starting Point" + "Annual Income Inc. Grade");
            end;
        }
        field(102; "Total Income Inc. Grade"; Decimal) { }
        field(103; "TA Out of Pocket"; Decimal) { }
        field(104; "Club Membership"; Decimal)
        {
            Description = 'Actual Cost or 15000 whichever is lower';
        }
        field(109; "TA Lodging"; Decimal)
        {
            Description = 'Travel Allowence on fooding per day';
        }
        field(110; "TA Fooding"; Decimal)
        {
            Description = 'Travel Allowence on Lodging per day';
        }

    }

    keys
    {
        key(Key1; "Grade Code", "Level Code") { }
        key(Key2; "Level Code") { }
    }

    fieldgroups { }

    trigger OnModify()
    begin
        CalculateTotalBasicSalary(Rec);
    end;

    trigger OnRename()
    begin
        Error(Text000);
    end;

    var
        Text000: Label 'Rename not allowed. Please delete and create new line.';

    procedure CalculateTotalBasicSalary(var GradeWiseAttributes: Record "Level Wise Attributes")
    var
        PGSetup: Record "Payroll General Setup";
        StepValue: Decimal;
    begin
        PGSetup.Get;
        if (GradeWiseAttributes."Level Code" <> '') and (GradeWiseAttributes."Grade Code" <> '') then begin
            StepValue := 0;
            if PGSetup."Per Step Salary Percentage" <> 0 then begin
                if Evaluate(StepValue, GradeWiseAttributes."Grade Code") then begin
                    GradeWiseAttributes.Grade := GradeWiseAttributes."Standard Basic Salary" * PGSetup."Per Step Salary Percentage" / 100 * StepValue;
                end;
            end;
            GradeWiseAttributes."Total Basic Salary" := GradeWiseAttributes.Grade + GradeWiseAttributes."Standard Basic Salary";
            GradeWiseAttributes.Modify;
        end;
    end;

    procedure AllCalculateTotalBasicSalary(StepIncrement: Decimal)
    var
        GradeWiseAttributes: Record "Level Wise Attributes";
        StepValue: Decimal;
    begin
        GradeWiseAttributes.Reset;
        if GradeWiseAttributes.FindFirst then
            repeat
                if (GradeWiseAttributes."Level Code" <> '') and (GradeWiseAttributes."Grade Code" <> '') then begin
                    StepValue := 0;
                    GradeWiseAttributes.Grade := 0;
                    if StepIncrement <> 0 then begin
                        if Evaluate(StepValue, GradeWiseAttributes."Grade Code") then begin
                            GradeWiseAttributes.Grade := GradeWiseAttributes."Standard Basic Salary" * StepIncrement / 100 * StepValue;
                        end;
                    end;
                    GradeWiseAttributes."Total Basic Salary" := GradeWiseAttributes.Grade + GradeWiseAttributes."Standard Basic Salary";
                    GradeWiseAttributes.Modify;
                end;
            until GradeWiseAttributes.Next = 0;
    end;

    procedure CreateAllCombinations()
    var
        SalaryLevel: Record "Salary Level";
        SalaryGrades: Record "Salary Grade";
        GradeWiseAttributes: Record "Level Wise Attributes";
        GradesCount: Integer;
    begin
        SalaryLevel.Reset;
        if SalaryLevel.FindFirst then
            repeat
                Clear(GradesCount);
                SalaryGrades.Reset;
                if SalaryGrades.FindFirst then
                    repeat
                        GradesCount += 1;
                        Clear(GradeWiseAttributes);
                        GradeWiseAttributes.Init;
                        GradeWiseAttributes."Grade Code" := SalaryGrades.Code;
                        GradeWiseAttributes."Level Code" := SalaryLevel.Code;
                        GradeWiseAttributes."Standard Basic Salary" := SalaryLevel."Basic Salary";
                        GradeWiseAttributes.Grade := (SalaryGrades."Grade Percentage" / 100) * SalaryLevel."Basic Salary";
                        GradeWiseAttributes."Total Basic Salary" := GradeWiseAttributes."Standard Basic Salary" + GradeWiseAttributes.Grade;
                        GradeWiseAttributes."Additional Time Allowance" := 0.75 * GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."Staff Vehicle Allowance" := SalaryLevel."Vehicle Allowance";
                        GradeWiseAttributes."TA Out of Pocket" := SalaryLevel."Out of Pocket Expense(Nepal)";
                        GradeWiseAttributes."TA Fooding" := SalaryLevel."Nepal Fooding Allowance";
                        GradeWiseAttributes."TA Lodging" := SalaryLevel."Nepal Lodging Allowance";
                        GradeWiseAttributes."Outstation Allowance" := 0.25 * GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."Relocation Allowance" := GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes.Allowance := SalaryLevel.Allowance;
                        GradeWiseAttributes."Dashain Remuneration" := GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."Risk Allowance" := 0.08 * GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."LFA Allowance" := (GradeWiseAttributes."Total Basic Salary" / 12);

                        GradeWiseAttributes."Employee Maintenence Allowance" := SalaryLevel."Employee Maintenence Allowance";
                        GradeWiseAttributes."Transportation Allowance" := SalaryLevel."Transportation Allowance";
                        GradeWiseAttributes."Vehicle Maintenence Allowance" := SalaryLevel."Vehicle Maintenence Allowance";

                        OnCreateAllCombinationOnbeforeInsert(GradeWiseAttributes, SalaryLevel, SalaryGrades);
                        if not GradeWiseAttributes.Insert then;
                        GradeWiseAttributes.Modify(true);
                    until (SalaryGrades.Next = 0) or (GradesCount >= SalaryLevel."Grades Limit");
            until SalaryLevel.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateAllCombinationOnbeforeInsert(var GradeWiseAttributes: Record "Level Wise Attributes"; var SalaryLevel: Record "Salary Level"; var SalaryGrades: Record "Salary Grade");
    begin
    end;
}
