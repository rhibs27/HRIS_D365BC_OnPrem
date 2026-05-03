table 50073 "Training Budget Line"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Training Header Entry No."; Integer) { }
        field(2; "Line No"; Integer) { }
        field(3; "Budget By"; Option)
        {
            OptionMembers = ,Month,"Training Category";
        }
        field(4; Month; Enum "Nepali Month")
        {
            Editable = false;
        }
        field(5; "Training Category"; Code[20])
        {
            TableRelation = "Training Master".Code where("Master Type" = filter("Training Setup Type"::"Training Category"));
        }
        field(6; "Budgeted No. of Trainings"; Integer) { }
        field(7; "Actual No. of Trainings"; Integer) { }
        field(8; "Budgeted Amount"; Decimal) { }
        field(9; "YTD Budgeted Amount"; Decimal) { Editable = false; }
        field(10; "Actual Amount"; Decimal) { }
        field(11; "YTD Actual Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Training Header Entry No.", "Line No") { }
    }

    fieldgroups { }
}
