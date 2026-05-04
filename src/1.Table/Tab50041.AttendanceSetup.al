table 50041 "Attendance Setup"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Primary Key"; Code[20]) { }
        field(2; "Attendance Document No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Activity Document No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Base Calender"; Code[20])
        {
            TableRelation = "Base Calendar";
        }
        field(5; "Per Day Late Tolerance"; Decimal)
        {
            Caption = 'Per Day Late tolerance (Minutes)';
            MinValue = 0;
            DecimalPlaces = 9;
        }
        field(6; "Per Month Late Tolerance"; Decimal)
        {
            Caption = 'Per Month Late tolerance (Minutes)';
            MinValue = 0;
        }
        field(7; "Min. minutes to be OT Eligible"; Decimal)
        {
            Caption = 'Minimum minutes to be eligible for OT per day';
            MinValue = 0;
        }
        field(8; "Daily Food Allow. on Holiday"; Boolean)
        {
            Caption = 'Daily Food Allowance on Holiday if full day present';
        }
        field(9; "Type of Integration"; Enum "Type of Integration") { }
        field(10; "Calculation Method"; Enum "Attendance Calculation Method") { }
        field(11; "Working Hour per day"; Decimal) { }
        field(12; "Attendance Line No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Deactivate Punch in Count"; Boolean)
        {
            trigger OnValidate()
            begin
                if not "Deactivate Punch in Count" then
                    Validate("Activate Punch in Date", Today);
            end;
        }
        field(14; "Activate Punch in Date"; Date) { }
        field(15; "Sync Attendance From"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Half Substitute Leave Hrs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Full Substitute Leave Hrs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Max Overtime In Week"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Check Out From"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Overtime Claim Type"; enum "Overtime Claim Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Different Emp. ID for Device"; Boolean)
        {
            Caption = 'Different Employee ID for Device';
            DataClassification = ToBeClassified;
            // True if "Employee ID" and "machine Emp. Code" are different in attendance log table.
        }
        field(51; "Attendance Allowed From"; Date)
        {
            Caption = 'Attendance Allowed From';
            DataClassification = ToBeClassified;
            // True this value is set then Attendance Process is only allowed form this Date.
        }

        // device configuration related field
        field(100; "User Name"; Text[50])
        {
            Caption = 'User Name';
            DataClassification = ToBeClassified;
        }
        field(101; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = ToBeClassified;
        }
        field(102; "Base URL"; Text[250])
        {
            Caption = 'URL';
            DataClassification = ToBeClassified;
        }
        field(104; "Company Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(105; "Branch Code"; code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
            DataClassification = ToBeClassified;
        }
        field(106; "Department Code"; code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
            DataClassification = ToBeClassified;
        }
        field(107; "Store Procedure Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(108; "Absent Deductions"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key") { }
    }

    fieldgroups { }
}
