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
                    Editable = FieldGeneralEditable;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                    Visible = false;
                }
                field("KPI No."; Rec."KPI No.")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("KRA"; Rec."KRA")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("KPI"; Rec."KPI")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;

                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Questionnaire/Description"; Rec."Questionnaire/Description")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("KPI Rating Type"; Rec."KPI Rating Type")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;

                    trigger OnValidate()
                    begin
                        case Rec."KPI Rating Type" of
                            Rec."KPI Rating Type"::Rating:
                                begin
                                    Clear(Rec.Weightage);
                                end;
                        end;
                        GetAppraisalStatus();
                        SetGeneralEditable();
                        SetScoreEditable();
                        CurrPage.Update();
                    end;
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                    Editable = (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) and not (Rec."Group Based");
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
                    Editable = (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Reviewer Type"; Rec."Reviewer Type")
                {
                    ApplicationArea = All;
                }
                field("Weightage"; Rec."Weightage")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Max Score"; Rec."Max Score")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec.Score > Rec."Max Score" then
                            Error('Max score should be equal to or greater than Score Value');
                    end;
                }
                field("Group Based"; Rec."Group Based")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Self Rating Applicable"; Rec."Self Rating Applicable")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("KPI Master Remarks"; Rec."KPI Master Remarks")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }

                // field("Target Assigned"; Rec."Target Assigned")
                // {
                //     ApplicationArea = All;
                //     Editable = FieldGeneralEditable;
                // }
                // field("Actual Achievement"; Rec."Actual Achievement")
                // {
                //     ApplicationArea = All;
                //     Editable = FieldGeneralEditable;
                // }
                // field("Action"; Rec.Action)
                // {
                //     ApplicationArea = All;
                //     Editable = FieldGeneralEditable;
                // }
                // field("From Setup"; Rec."From Setup")
                // {
                //     ApplicationArea = All;
                //     Editable = FieldGeneralEditable;
                // }
                // field("Hide Delete Action"; Rec."Hide Delete Action")
                // {
                //     ApplicationArea = All;
                //     Editable = FieldGeneralEditable;
                // }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        GetAppraisalStatus();
        SetGeneralEditable();
        SetScoreEditable();
    end;

    trigger OnOpenPage()
    begin
        GetAppraisalStatus();
        SetGeneralEditable();
        SetScoreEditable();
    end;

    var
        FieldGeneralEditable: Boolean;
        FieldEditable1: Boolean;
        FieldEditable2: Boolean;
        FieldEditablescoring: Boolean;
        FieldEditableGroupBased: Boolean;
        FieldSelfScoring: Boolean;
        FieldSelfRating: Boolean;
        FieldSelfRemarks: Boolean;
        FieldSupervisorScoring: Boolean;
        FieldSupervisorRating: Boolean;
        FieldSupervisorRemarks: Boolean;
        FieldReviewerScoring: Boolean;
        FieldReviewerRating: Boolean;
        FieldReviewerRemarks: Boolean;
        FieldHRScoring: Boolean;
        FieldHRRating: Boolean;
        FieldHRRemarks: Boolean;
        Appraisal: Record Appraisal;
        AppraisalStatus: Enum "Appraisal Status";

    local procedure GetAppraisalStatus()
    begin
        Appraisal.Reset();
        Appraisal.SetRange("Appraisal Code", Rec."Appraisal Code");
        Appraisal.SetRange("Fiscal Year", Rec."Fiscal Year");
        if Appraisal.FindFirst() then
            AppraisalStatus := Appraisal.Status
        else
            AppraisalStatus := Enum::"Appraisal Status"::" ";
    end;

    local procedure SetGeneralEditable()
    begin

        FieldGeneralEditable := false;
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
        FieldEditablescoring := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;
        FieldEditableGroupBased := (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) and Rec."Group Based";
    end;

    local procedure SetScoreEditable()
    begin
        FieldSelfScoring := false;
        FieldSelfRating := false;
        FieldSelfRemarks := false;
        FieldSupervisorScoring := false;
        FieldSupervisorRating := false;
        FieldSupervisorRemarks := false;
        FieldReviewerScoring := false;
        FieldReviewerRating := false;
        FieldReviewerRemarks := false;
        FieldHRScoring := false;
        FieldHRRating := false;
        FieldHRRemarks := false;

        case AppraisalStatus of
            AppraisalStatus::Open:
                begin
                    FieldSelfScoring := (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) AND Rec."Self Rating Applicable";
                    FieldSelfRating := (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating) AND Rec."Self Rating Applicable";
                    FieldSelfRemarks := ((Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating)) AND Rec."Self Rating Applicable";
                end;
            AppraisalStatus::Submitted:
                begin
                    FieldSupervisorScoring := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;
                    FieldSupervisorRating := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating;
                    FieldSupervisorRemarks := (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                end;
            AppraisalStatus::Reviewed:
                begin
                    FieldReviewerScoring := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;
                    FieldReviewerRating := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating;
                    FieldReviewerRemarks := (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                end;
            AppraisalStatus::"Check Reviewed":
                begin
                    FieldHRScoring := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;
                    FieldHRRating := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating;
                    FieldHRRemarks := (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                end;
        end;
    end;
}