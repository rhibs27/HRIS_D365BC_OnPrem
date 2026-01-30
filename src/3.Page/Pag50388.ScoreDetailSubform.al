page 50388 "Score Detail Subform"
{
    ApplicationArea = All;
    Caption = 'Score Detail Subform';
    PageType = ListPart;
    SourceTable = "Score Detail";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reviewer Type"; Rec."Reviewer Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Score/Rating By"; Rec."Score/Rating By")
                {
                    ApplicationArea = All;
                    Editable = ScoreRatingEditable;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Weightage; Rec.Weightage)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Submitted; Rec.Submitted)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Submitted Date Time"; Rec."Submitted Date Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    var
        ScoreRatingEditable: Boolean;
        ReviewerSetup: Record "Reviewer Setup";

    trigger OnAfterGetRecord()
    begin
        UpdateScoreRatingEditable();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ScoreRatingEditable := true;
    end;

    local procedure UpdateScoreRatingEditable()
    begin
        ScoreRatingEditable := true;
        if Rec."Reviewer Type" = '' then
            exit;
        if ReviewerSetup.Get(Rec."Reviewer Type") then
            ScoreRatingEditable := not (ReviewerSetup."Is Self Review" or ReviewerSetup."Is Group Based");
    end;
}