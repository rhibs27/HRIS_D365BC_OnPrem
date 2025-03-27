table 50073 "Training Budget Line"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Training Header Entry No."; Integer)
        {
        }
        field(2; "Line No"; Integer)
        {
        }
        field(3; Month; Enum "Nepali Month")
        {
            Editable = false;
        }
        field(4; "No. of Training"; Integer) { }
        field(5; "Budget Amount"; Decimal) { }
        field(6; "YTD Budget"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Training Header Entry No.", "Line No") { }
    }

    fieldgroups { }
}
