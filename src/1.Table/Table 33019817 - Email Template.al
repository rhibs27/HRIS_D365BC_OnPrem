table 33019817 "Email Template"
{
    DataClassification = CustomerContent;
    // version NP16.04

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; "Document Profile"; Option)
        {
            OptionMembers = " ","Employee Activity";
        }
        field(4; "Document Type"; Enum "Email Document Type")
        {

        }
        field(5; Type; Enum "Email Status Type")
        {
           
        }
        field(6; Subject; Text[100]) { }
        field(7; "Memo Type"; Option)
        {
            Description = 'not required';
            OptionMembers = " ",test;
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
        field(11; "Sub Type";Enum "Email Sub Type" )
        {
            
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }
}
