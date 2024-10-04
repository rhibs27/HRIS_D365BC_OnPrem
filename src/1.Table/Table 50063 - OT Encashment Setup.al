table 50063 "OT Encashment Setup"
{
    DrillDownPageId = "Encashment Setup";
    LookupPageId = "Encashment Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Encashment Code"; Code[30])
        {
        }
        field(2; Period; Enum "Encashment Period")
        {

        }
        field(3; "Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
    }

    keys
    {
        key(Key1; "Encashment Code") { }
    }

    fieldgroups { }
}
