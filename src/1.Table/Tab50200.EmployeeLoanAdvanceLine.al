table 50200 "Employee Loan/Advance Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Loan Type"; Enum "Loan Type")
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Pay Cycle Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Pay Cycle Term"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Payr Cycle Period"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Payroll Attributes"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Settled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Request By Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Payroll Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Nepali Year"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Nepali Month"; Enum "Nepali Month")
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            DataClassification = ToBeClassified;
        }
        field(17; Disbursed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Loan Type", "Line No.")
        {
            Clustered = true;
        }
    }
}
