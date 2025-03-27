table 50102 "Attendance Machine Mapping"
{
    DataClassification = CustomerContent;
    // version AMS6.1.0

    fields
    {
        field(1; "Machine Code"; Code[10]) { }
        field(2; "Machine Name"; Text[30]) { }
        field(3; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(4; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(5; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(6; "IP Address"; Code[20]) { }
        field(7; Active; Boolean)
        {
            Description = 'Do not import attendance data if active is false';
        }
    }

    keys
    {
        key(Key1; "Machine Code") { }
    }

    fieldgroups { }
}
