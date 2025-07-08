table 50021 "Level Wise Attributes"
{

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
        field(7; "Starting Point"; Decimal) { }
        field(8; "Annual Income Inc. Grade"; Decimal)
        {
            trigger OnValidate()
            begin
                TestField("Starting Point");
                Validate("Standard Basic Salary", "Starting Point" + "Annual Income Inc. Grade");
            end;
        }
        field(9; "Total Income Inc. Grade"; Decimal) { }
        field(10; "TA Out of Pocket"; Decimal) { }
        field(11; "Relocation Allowance"; Decimal)
        {
            Description = '1 month Basic Salary( Basic + Grade)';
        }
        field(12; "Outstation Allowance"; Decimal)
        {
            Description = '25% of Total Basic salary';
        }
        field(13; "Friday Counter Allowance"; Decimal) { }
        field(14; "Club Membership"; Decimal)
        {
            Description = 'Actual Cost or 15000 whichever is lower';
        }
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
        field(19; "TA Lodging"; Decimal)
        {
            Description = 'Travel Allowence on fooding per day';
        }
        field(20; "TA Fooding"; Decimal)
        {
            Description = 'Travel Allowence on Lodging per day';
        }
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
        SalaryGrade: Record "Salary Level";
        SalaryStep: Record "Salary Grade";
        GradeWiseAttributes: Record "Level Wise Attributes";
    begin
        SalaryGrade.Reset;
        if SalaryGrade.FindFirst then
            repeat
                SalaryStep.Reset;
                if SalaryStep.FindFirst then
                    repeat
                        Clear(GradeWiseAttributes);
                        GradeWiseAttributes.Init;
                        GradeWiseAttributes."Grade Code" := SalaryStep.Code;
                        GradeWiseAttributes."Level Code" := SalaryGrade.Code;
                        GradeWiseAttributes."Standard Basic Salary" := SalaryGrade."Basic Salary";
                        GradeWiseAttributes.Grade := (SalaryStep."Grade Percentage" / 100) * SalaryGrade."Basic Salary";
                        GradeWiseAttributes."Total Basic Salary" := GradeWiseAttributes."Standard Basic Salary" + GradeWiseAttributes.Grade;
                        GradeWiseAttributes."Additional Time Allowance" := 0.75 * GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."Staff Vehicle Allowance" := SalaryGrade."Vehicle Allowance";
                        GradeWiseAttributes."TA Out of Pocket" := SalaryGrade."Out of Pocket Expense(Nepal)";
                        GradeWiseAttributes."TA Fooding" := SalaryGrade."Nepal Fooding Allowance";
                        GradeWiseAttributes."TA Lodging" := SalaryGrade."Nepal Lodging Allowance";
                        GradeWiseAttributes."Outstation Allowance" := 0.25 * GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."Relocation Allowance" := GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes.Allowance := SalaryGrade.Allowance;
                        GradeWiseAttributes."Dashain Remuneration" := GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."Risk Allowance" := 0.08 * GradeWiseAttributes."Total Basic Salary";
                        GradeWiseAttributes."LFA Allowance" := (GradeWiseAttributes."Total Basic Salary" / 12);
                        if not GradeWiseAttributes.Insert then;
                        GradeWiseAttributes.Modify(true);
                    until SalaryStep.Next = 0;
            until SalaryGrade.Next = 0;
    end;
}
