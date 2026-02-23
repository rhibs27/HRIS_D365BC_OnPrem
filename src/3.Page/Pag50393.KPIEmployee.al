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
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                    Visible = false;
                }
                field("KPI No."; Rec."KPI No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("KRA"; Rec."KRA")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("KPI"; Rec."KPI")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ApplicationArea = All;
                    Editable = False;

                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Questionnaire/Description"; Rec."Questionnaire/Description")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("KPI Rating Type"; Rec."KPI Rating Type")
                {
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
                    ApplicationArea = All;
                    Editable = (not IsReviewerSubmitted) and (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) and not Rec."Group Based";
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Score Total"; Rec."Score Total")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Rating; Rec.Rating)
                {
                    ApplicationArea = All;
                    Editable = (not IsReviewerSubmitted) and (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = not IsReviewerSubmitted;
                }
                field("Reviewer Type"; Rec."Reviewer Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Weightage"; Rec."Weightage")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Max Score"; Rec."Max Score")
                {
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
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Self Rating Applicable"; Rec."Self Rating Applicable")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("KPI Master Remarks"; Rec."KPI Master Remarks")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CheckReviewerSubmissionStatus();
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