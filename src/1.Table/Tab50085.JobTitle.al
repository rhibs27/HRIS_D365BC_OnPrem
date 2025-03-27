table 50085 "Job Title"
{
    DataClassification = CustomerContent;
    // version HRP6.1.0

    fields
    {
        field(1; "Salary Level Code"; Code[20])
        {
            TableRelation = "Salary Level".Code;
        }
        field(2; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title".Code;
        }
        field(3; "Banking Experince"; Decimal) { }
        field(4; "Non-Banking Experince"; Decimal) { }
        field(5; "Minimum Age"; Integer) { }
    }

    keys
    {
        key(Key1; "Salary Level Code", "Functional Title") { }
    }

    fieldgroups { }
}
