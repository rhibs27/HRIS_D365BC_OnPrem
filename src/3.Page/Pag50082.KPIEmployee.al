page 50082 "KPI Employee"
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
                field("KRA Master"; Rec."KRA Master")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("KRA Subtype"; Rec."KRA Subtype")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                    trigger OnValidate()
                    begin
                        GetAppraisalStatus();
                        SetGeneralEditable();
                        SetScoreEditable();
                    end;
                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable1 AND FieldGeneralEditable;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable2 AND FieldGeneralEditable;
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
                            Rec."KPI Rating Type"::Scoring:
                                begin
                                    Clear(Rec."Self Rating");
                                    Clear(Rec."Immediate Supervisor Rating");
                                    Clear(Rec."Reviewer Rating");
                                    Clear(Rec."HR Committee Rating");
                                end;
                            Rec."KPI Rating Type"::Rating:
                                begin
                                    Clear(Rec.Weightage);
                                    Clear(Rec."Self Score");
                                    Clear(Rec."Immediate Supervisor Score");
                                    Clear(Rec."Reviewer Score");
                                    Clear(Rec."HR Committee Score");
                                end;
                            Rec."KPI Rating Type"::"Group Based":
                                begin
                                    Clear(Rec."Self Score");
                                    Clear(Rec."Immediate Supervisor Score");
                                    Clear(Rec."Reviewer Score");
                                    Clear(Rec."HR Committee Score");
                                    Clear(Rec."Self Rating");
                                    Clear(Rec."Immediate Supervisor Rating");
                                    Clear(Rec."Reviewer Rating");
                                    Clear(Rec."HR Committee Rating");
                                    Clear(Rec."Self Remarks");
                                    Clear(Rec."Immediate Supervisor Remarks");
                                    Clear(Rec."Reviewer Remarks");
                                    Clear(Rec."HR Committee Remarks");
                                end;
                        end;
                        GetAppraisalStatus();
                        SetGeneralEditable();
                        SetScoreEditable();
                        CurrPage.Update();
                    end;
                }
                field("Weightage"; Rec."Weightage")
                {
                    ApplicationArea = All;
                    Editable = FieldEditablescoring AND FieldGeneralEditable;
                }
                field("Self Rating Applicable"; Rec."Self Rating Applicable")
                {
                    ApplicationArea = All;
                    Editable = (NOT FieldEditableGroupBased) AND FieldGeneralEditable;
                    trigger OnValidate()
                    begin
                        GetAppraisalStatus();
                        SetGeneralEditable();
                        SetScoreEditable();
                        CurrPage.Update();
                    end;
                }
                field("Group Performance Based Score"; Rec."Group Performance Based Score")
                {
                    ApplicationArea = All;
                    Editable = FieldEditableGroupBased AND FieldGeneralEditable;
                }
                field("KPI Master Remarks"; Rec."KPI Master Remarks")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Self Score"; Rec."Self Score")
                {
                    ApplicationArea = All;
                    Editable = FieldSelfScoring;
                }
                field("Self Rating"; Rec."Self Rating")
                {
                    ApplicationArea = All;
                    Editable = FieldSelfRating;
                }
                field("Self Remarks"; Rec."Self Remarks")
                {
                    ApplicationArea = All;
                    Editable = FieldSelfRemarks;
                }
                field("Immediate Supervisor Score"; Rec."Immediate Supervisor Score")
                {
                    ApplicationArea = All;
                    Editable = FieldSupervisorScoring;
                }
                field("Immediate Supervisor Rating"; Rec."Immediate Supervisor Rating")
                {
                    ApplicationArea = All;
                    Editable = FieldSupervisorRating;
                }
                field("Immediate Supervisor Remarks"; Rec."Immediate Supervisor Remarks")
                {
                    ApplicationArea = All;
                    Editable = FieldSupervisorRemarks;
                }
                field("Reviewer Score"; Rec."Reviewer Score")
                {
                    ApplicationArea = All;
                    Editable = FieldReviewerScoring;
                }
                field("Reviewer Rating"; Rec."Reviewer Rating")
                {
                    ApplicationArea = All;
                    Editable = FieldReviewerRating;
                }
                field("Reviewer Remarks"; Rec."Reviewer Remarks")
                {
                    ApplicationArea = All;
                    Editable = FieldReviewerRemarks;
                }
                field("HR Committee Score"; Rec."HR Committee Score")
                {
                    ApplicationArea = All;
                    Editable = FieldHRScoring;
                }
                field("HR Committee Rating"; Rec."HR Committee Rating")
                {
                    ApplicationArea = All;
                    Editable = FieldHRRating;
                }
                field("HR Committee Remarks"; Rec."HR Committee Remarks")
                {
                    ApplicationArea = All;
                    Editable = FieldHRRemarks;
                }
                field("Target Assigned"; Rec."Target Assigned")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Actual Achievement"; Rec."Actual Achievement")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Action"; Rec.Action)
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("From Setup"; Rec."From Setup")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
                field("Hide Delete Action"; Rec."Hide Delete Action")
                {
                    ApplicationArea = All;
                    Editable = FieldGeneralEditable;
                }
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
        FieldEditableGroupBased := Rec."KPI Rating Type" = Rec."KPI Rating Type"::"Group Based";
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
            Enum::"Appraisal Status"::Open:
                begin
                    FieldSelfScoring :=
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) AND
                        Rec."Self Rating Applicable";

                    FieldSelfRating :=
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating) AND
                        Rec."Self Rating Applicable";

                    FieldSelfRemarks :=
                        ((Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR
                         (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating))
                        AND Rec."Self Rating Applicable";
                end;

            AppraisalStatus::Submitted:
                begin
                    FieldSupervisorScoring :=
                        Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;

                    FieldSupervisorRating :=
                        Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating;

                    FieldSupervisorRemarks :=
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                end;

            AppraisalStatus::Reviewed:
                begin

                    FieldReviewerScoring :=
                        Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;

                    FieldReviewerRating :=
                        Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating;

                    FieldReviewerRemarks :=
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                end;

            AppraisalStatus::"Check Reviewed":
                begin

                    FieldHRScoring :=
                        Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;

                    FieldHRRating :=
                        Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating;

                    FieldHRRemarks :=
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) OR
                        (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Rating);
                end;
        end;
    end;
}