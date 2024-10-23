table 50117 "Rating Setup"
{
    DrillDownPageId = "Rating Scale";
    LookupPageId = "Rating Scale";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; Type; Enum "Employee Question Type")
        {

        }
        field(3; From; Decimal)
        {
        }
        field(4; "To"; Decimal)
        {
        }
        field(5; Remarks; Enum "Appraisal Rating")
        {

        }
    }

    keys
    {
        key(Key1; "Entry No.", Type, Remarks) { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        GetEntryNo;
    end;

    local procedure GetEntryNo()
    var
        RatingSetup: Record "Rating Setup";
    begin
        RatingSetup.Reset;
        RatingSetup.SetCurrentKey("Entry No.");
        if RatingSetup.FindLast then
            "Entry No." := RatingSetup."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}
