table 50125 "KPI Rating Setup"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Min Score"; Decimal) { }
        field(3; "Max Score"; Decimal) { }
        field(4; Rating; Enum "Appraisal Rating") { }
        field(5; "User ID"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(6; "Date and Time"; DateTime) { }
        field(7; Blocked; Boolean) { }
        field(8; "KPI Incentive Not Eligible"; Boolean) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "User ID" := UserId;//KPI1.00
        "Date and Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "User ID" := UserId;//KPI1.00
        "Date and Time" := CurrentDateTime;
    end;
}
