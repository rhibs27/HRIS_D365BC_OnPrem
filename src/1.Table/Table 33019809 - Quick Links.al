table 33019809 "Quick Links"
{
    DataClassification = CustomerContent;
    // version APINICASIA1.00

    fields
    {
        field(1; "Link Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "Link URL"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Link Code") { }
    }

    fieldgroups { }
}
