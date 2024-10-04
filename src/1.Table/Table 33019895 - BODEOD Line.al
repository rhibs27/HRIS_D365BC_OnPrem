table 33019895 "BOD/EOD Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No"; Integer) { }
        field(2; "Line No."; Integer) { }
        field(3; "Task Code"; Code[20]) { }
        field(4; "Task Description"; Text[250]) { }
        field(5; "Task Status"; Text[250]) { }
        field(6; "Is Created on EOD"; Boolean) { }
    }

    keys
    {
        key(Key1; "Entry No", "Line No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        BodEodLine.Reset;
        BodEodLine.SetRange("Entry No", "Entry No");
        BodEodLine.SetCurrentKey("Line No.");
        if BodEodLine.FindLast then
            "Line No." := BodEodLine."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    var
        BodEodLine: Record "BOD/EOD Line";
}
