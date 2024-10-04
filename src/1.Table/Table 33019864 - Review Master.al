table 33019864 "Review Master"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; Value; Integer)
        {
            trigger OnValidate()
            begin
                ReviewMaster.Reset;
                ReviewMaster.SetRange(Value, Value);
                if ReviewMaster.FindFirst then
                    Error('Value cannnot be duplicate');
            end;
        }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Value, "No.", Description) { }
    }

    var
        ReviewMaster: Record "Review Master";
}
