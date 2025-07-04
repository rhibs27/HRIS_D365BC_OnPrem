table 50020 "Salary Level"
{
    DrillDownPageId = "Salary Levels";
    LookupPageId = "Salary Levels";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; Rank; Integer) { }
        field(4; "Basic Salary"; Decimal)
        {
            trigger OnValidate()
            begin
                ApplyNewBasicSalary;
            end;
        }
        field(5; "Nepal Fooding Allowance"; Decimal) { }
        field(6; "Nepal Lodging Allowance"; Decimal) { }
        field(7; "Out of Pocket Expense(Nepal)"; Decimal) { }
        field(8; "Vehicle Allowance"; Decimal) { }
        field(9; Allowance; Decimal) { }
        field(10; "Net Learning"; Decimal) { }
        field(11; "Friday Allowance"; Decimal) { }
        field(12; "Vehicle Loan Limit"; Decimal) { }
        field(13; "Housing Loan Limit"; Decimal) { }
        field(14; "OT Eligible"; Boolean) { }
        field(15; "Reapply Year (Vehicle Loan)"; Decimal)
        {
            Description = 'For reapplying of Vehicle loan';
        }
        field(16; Darbandi; Integer) { }
        field(17; "Banking Experience"; Decimal) { }
        field(18; "Non-Banking Experience"; Decimal) { }
        field(19; "Minimum Age"; Integer) { }
        field(20; "India Fooding Allowance"; Decimal) { }
        field(21; "India Lodging Allowance"; Decimal) { }
        field(22; "Senior Officer Level"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Senior Officer Level" then begin
                    SalaryLevel.Reset;
                    SalaryLevel.SetRange("Senior Officer Level", true);
                    SalaryLevel.SetFilter(Code, '<>%1', Code);
                    if SalaryLevel.FindFirst then
                        Error('Senior officer level is %1. There cannot be two or more senior offier level', SalaryLevel.Code);
                end;
            end;
        }
        field(23; "Leave Balance (Contract Staff)"; Decimal)
        {
            Description = 'For contract staffs';
        }
        field(24; "OT Attachment Mandatory"; Boolean) { }
        field(25; "Travel With Not Eligible"; Boolean) { }
        field(26; "Vault Key Eligible"; Boolean) { }
        field(27; "Maximum Age"; Decimal) { }
        field(28; "Qualification Code"; Code[20])
        {
            TableRelation = Qualification.Code where(Type = const(Education));

            trigger OnValidate()
            begin
                if Qualification.Get("Qualification Code") then
                    Validate(Rank, Qualification.Rank)
                else
                    Clear(Rank);
            end;
        }
        field(29; "Good Service Period"; Integer)
        {
            Description = 'Promotion';
        }
        field(30; "Is AM"; Boolean) { }
        field(31; "Extra Mileage Eligible"; Boolean) { }
        field(32; "Compensatory Leave"; Boolean) { }
        field(33; "Holiday Counter Eligible"; Boolean) { }
        field(34; "Festive Counter Eligible"; Boolean) { }
        field(35; "Year End Encashment"; Boolean) { }
        field(36; "TA OT Basic Salary"; Decimal) { }
        field(37; "Others Fooding Allowance"; Decimal)
        {
            Caption = 'Other Country Fooding Allowance';
        }
        field(38; "Others Lodging Allowance"; Decimal)
        {
            Caption = 'Other Country Lodging Allowance';
        }
        field(39; "Out of Pocket Expense(India)"; Decimal)
        {

        }
        field(40; "Out of Pocket Expense(Other)"; Decimal)
        {
        }
        field(41; "Leave Fare Allowance"; Decimal)
        {
        }
        field(42; "Staff Level"; Enum "Staff Type")
        {
        }

    }

    keys
    {
        key(Key1; "Code") { }
        key(Key2; Rank) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, Rank) { }
    }

    trigger OnRename()
    begin
        //ERROR('');
    end;

    var
        SalaryLevel: Record "Salary Level";
        Qualification: Record Qualification;

    local procedure ApplyNewBasicSalary()
    var
        GradeWiseAttributes: Record "Level Wise Attributes";
    begin
        GradeWiseAttributes.CreateAllCombinations;
        GradeWiseAttributes.Reset;
        GradeWiseAttributes.SetRange("Level Code", Code);
        if GradeWiseAttributes.FindFirst then
            repeat
                GradeWiseAttributes.Validate("Standard Basic Salary", "Basic Salary");
                GradeWiseAttributes.Modify;
            until GradeWiseAttributes.Next = 0;
    end;
}
