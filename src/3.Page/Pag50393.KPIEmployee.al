page 50393 "KPI Employee"
{
    Caption = 'KPI Employee';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "KPI Employee";
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Appraisal No"; Rec."Appraisal Code")
                {
                    caption = 'Appraisal No';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    Caption = 'Fiscal Year';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Line No';
                    ApplicationArea = All;
                    Editable = False;
                    Visible = false;
                }
                field("KPI No."; Rec."KPI No.")
                {
                    Caption = 'KPI No';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    Caption = 'Employee No';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = False;
                }
                field("KRA"; Rec."KRA")
                {
                    Caption = 'KRA';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("KPI"; Rec."KPI")
                {
                    Caption = 'KPI';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    Caption = 'Appraisal Template';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    Caption = 'Appraisal Type';
                    ApplicationArea = All;
                    Editable = False;

                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    Caption = 'Appraisal Subtype Monthly';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    Caption = 'Appraisal Subtype Quarterly';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Questionnaire/Description"; Rec."Questionnaire/Description")
                {
                    Caption = 'Questionnaire/Description';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("KPI Rating Type"; Rec."KPI Rating Type")
                {
                    Caption = 'KPI Rating Type';
                    ApplicationArea = All;
                    Editable = False;

                    trigger OnValidate()
                    begin
                        case Rec."KPI Rating Type" of
                            Rec."KPI Rating Type"::Rating:
                                begin
                                    Clear(Rec.Weightage);
                                end;
                        end;
                        CurrPage.Update();
                    end;
                }
                field(Score; Rec.Score)
                {
                    Caption = 'Score';
                    ApplicationArea = All;
                    Editable = (not IsReviewerSubmitted) and (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) and not Rec."Group Based";
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Score Total"; Rec."Score Total")
                {
                    Caption = 'Score Total';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Rating; Rec.Rating)
                {
                    Caption = 'Rating';
                    ApplicationArea = All;
                    Editable = (not IsReviewerSubmitted) and (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Remarks';
                    ApplicationArea = All;
                    Editable = not IsReviewerSubmitted;
                }
                field("Reviewer Type"; Rec."Reviewer Type")
                {
                    Caption = 'Reviewer Type';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reviewer Code"; Rec."Reviewer Code")
                {
                    Caption = 'Reviewer Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Weightage"; Rec."Weightage")
                {
                    Caption = 'Weightage';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Max Score"; Rec."Max Score")
                {
                    Caption = 'Max Score';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        if Rec.Score > Rec."Max Score" then
                            Error('Max score should be equal to or greater than Score Value');
                    end;
                }
                field("Group Based"; Rec."Group Based")
                {
                    Caption = 'Group Based';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Self Rating Applicable"; Rec."Self Rating Applicable")
                {
                    Caption = 'Self Rating Applicable';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("KPI Master Remarks"; Rec."KPI Master Remarks")
                {
                    Caption = 'KPI Master Remarks';
                    ApplicationArea = All;
                    Editable = False;
                }
                field(IsSelfReview; IsSelfReview)
                {
                    //Visible=false;
                    Editable = false;
                    Caption = 'Is Self Review';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // CheckReviewerSubmissionStatus();
        IsSelfReview := false;

        if Rec."Reviewer Type" <> '' then
            if ReviewerSetup.Get(Rec."Reviewer Type") then
                IsSelfReview := ReviewerSetup."Is Self Review";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CheckReviewerSubmissionStatus();
    end;

    trigger OnOpenPage()
    begin
        CheckReviewerSubmissionStatus();
    end;

    var
        IsReviewerSubmitted: Boolean;
        IsSelfReview: Boolean;
        ReviewerSetup: Record "Reviewer Setup";

    local procedure CheckReviewerSubmissionStatus()
    var
        ScoreDetail: Record "Score Detail";
    begin
        IsReviewerSubmitted := false;
        ScoreDetail.Reset();
        ScoreDetail.SetRange("Appraisal Code", Rec."Appraisal Code");
        ScoreDetail.SetRange("Reviewer Type", Rec."Reviewer Type");
        ScoreDetail.SetRange(Submitted, true);
        IsReviewerSubmitted := not ScoreDetail.IsEmpty; // if submitted is true  then  this field gets true value
    end;
}