table 33019840 "Payroll Balancing Account"
{
    DataClassification = CustomerContent;
    // version PRM19.01.01

    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(4; "Credit Amount"; Decimal)
        {
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.") { }
    }

    fieldgroups { }
}
