table 50002 "Language Proficiency"
{
    Caption = 'Language Proficiency';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            Editable = false;
            TableRelation = Employee;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Language; Text[20])
        {
            Caption = 'Language';
        }
        field(4; Speaking; Enum "Payback Months")
        {
            Caption = 'Speaking';
        }
        field(5; Reading; Enum "Payback Months")
        {
            Caption = 'Reading';
        }
        field(6; Writing; Enum "Payback Months")
        {
            Caption = 'Writing';
        }
        field(7; Typing; Enum "Payback Months")
        {
            Caption = 'Typing';
        }
    }
    keys
    {
        key(PK; "Employee Code", "Line No.")
        {
            Clustered = true;
        }
    }
}
