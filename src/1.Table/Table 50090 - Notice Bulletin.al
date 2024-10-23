table 50090 "Notice Bulletin"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; Type; Enum "Notice Bulletin Type")
        {
        }
        field(3; Date; Date) { }
        field(4; Notice; Blob) { }
        field(5; "Image File Path"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        NoticeBulletin.Reset;
        if NoticeBulletin.FindLast then
            "Entry No." := NoticeBulletin."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    var
        NoticeBulletin: Record "Notice Bulletin";
}
