table 50090 "Notice Bulletin"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; Type; Enum "Notice Bulletin Type")
        {
        }
        field(3; "Notice Create Date"; Date) { }

        field(4; Notice; Media)
        {
        }
        field(6; "Notice Title"; Text[1000])
        {
        }
        field(7; "Description"; Blob)
        {
            Caption = 'Description';
        }
        field(8; "Notice End Date"; Date)
        {
        }
        field(9; "Attachment type"; Enum "Attachment Setup Type")
        {
            DataClassification = ToBeClassified;
        }

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
