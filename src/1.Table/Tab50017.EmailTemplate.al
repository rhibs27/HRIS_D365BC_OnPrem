table 50017 "Email Template"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; "Document Profile"; Enum "Document Profile")
        {
        }
        field(4; "Document Type"; Enum "Employee Activity Type")
        {

        }
        field(5; "Approval Status"; Enum "Approval Status")
        {

        }
        field(6; Subject; Text[100]) { }
        field(7; "Memo Type"; Enum "Memo Type")
        {
            Description = 'not required';

        }
        // field(8; "Product Segment"; Code[20])
        // {
        //     TableRelation = "Product Group".Code WHERE("Item Category Code" = CONST('VEHICLE'));

        // }
        field(9; "Email reciepent"; Enum "Email reciepent")
        {

        }
        field(10; "Loan Type"; Enum "Loan Type")
        {

        }
        field(11; "Sub Type"; Enum "Email Sub Type")
        {

        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
