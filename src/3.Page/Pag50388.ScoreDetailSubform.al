page 50388 "Score Detail Subform"
{
    ApplicationArea = All;
    Caption = 'Score Detail Subform';
    PageType = ListPart;
    SourceTable = "Score Detail";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No';
                    ApplicationArea = All;
                    Editable = false;
                }
                Field(appraisalNo; Rec."Appraisal Code")
                {
                    Caption = 'Appraisal No';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(appraisalTemplate; Rec."Appraisal Template")
                {
                    Caption = 'Appraisal Template';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(fiscalYear; Rec."Fiscal Year")
                {
                    Caption = 'Fiscal Year';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(reviewerType; Rec."Reviewer Type")
                {
                    Caption = 'Reviewer Type';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(scoreRatingBy; Rec."Score/Rating By")
                {
                    Caption = 'Score/Rating By';
                    ApplicationArea = All;
                    Editable = ScoreRatingEditable;
                }
                field(sequence; Rec.Sequence)
                {
                    Caption = 'Sequence';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(weightage; Rec.Weightage)
                {
                    Caption = 'Weightage';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(total; Rec.Total)
                {
                    Caption = 'Total';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(submitted; Rec.Submitted)
                {
                    Caption = 'Submitted';
                    ApplicationArea = All;
                    Editable = false;

                }
                field(submittedDate; Rec."Submitted Date")
                {
                    Caption = 'Submitted Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(isSelfReview; Rec."Is Self Review")
                {
                    //Visible = false;
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Is Self Review';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Caption = 'Submit Scores';
                Image = Approval;
                ToolTip = 'Submit all scores for this appraisal';

                trigger OnAction()
                begin
                    AppraisalMgt.SubmitAllScores(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    var
        ScoreRatingEditable: Boolean;
        SubmittedEditable: Boolean;
        ReviewerSetup: Record "Reviewer Setup";
        AppraisalHdr: Record Appraisal;

        AppraisalMgt: Codeunit "AppraisalMgt.";

    trigger OnAfterGetRecord()
    begin
        UpdateEditability();
        // IsSelfReview := false;

        // if Rec."Reviewer Type" <> '' then
        //     if ReviewerSetup.Get(Rec."Reviewer Type") then
        //         IsSelfReview := ReviewerSetup."Is Self Review";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ScoreRatingEditable := true;
        SubmittedEditable := true;
    end;

    local procedure UpdateEditability()
    begin
        ScoreRatingEditable := true;
        SubmittedEditable := true;
        if not AppraisalHdr.Get(Rec."Appraisal Code") then
            exit;
        if AppraisalHdr."Approval Status" = AppraisalHdr."Approval Status"::Approved then begin
            ScoreRatingEditable := false;
            SubmittedEditable := false;
            exit;
        end;
        if Rec."Reviewer Type" = '' then
            exit;
        if ReviewerSetup.Get(Rec."Reviewer Type") then
            ScoreRatingEditable :=
                not (ReviewerSetup."Is Self Review" or ReviewerSetup."Is Group Based");
    end;


}
