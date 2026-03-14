page 50389 "Appraisal KPI Master"
{
    Caption = 'Appraisal KPI Master';
    PageType = List;
    SourceTable = "Appraisal KPI Master";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("KPI No."; Rec."KPI No.")
                {
                    ToolTip = 'Specifies the value of the KPI No. field.';
                    ApplicationArea = All;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("KRA"; Rec."KRA")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field("KPI"; Rec."KPI")
                {
                    ToolTip = 'Specifies the value of the Key Result Area field.';
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        SetEditable;
                    end;
                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    ToolTip = 'Specifies the value of the Appraisal Subtype Monthly field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    ToolTip = 'Specifies the value of the Appraisal Subtype Quarterly field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                Field("Functional Title"; Rec."Functional Title")
                {
                    ApplicationArea = All;
                }
                Field("Province code"; Rec."Province code")
                {
                    ApplicationArea = All;
                }
                Field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Extension Counter Code"; Rec."Extension Counter Code")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                }
                field("Sub-Unit Code"; Rec."Sub-Unit Code")
                {
                    ApplicationArea = All;
                }
                field("Questionnaire/Description"; Rec."Questionnaire/Description")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                Field("KPI Rating Type"; Rec."KPI Rating Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        SetEditable;
                    end;
                }
                field("Weightage"; Rec."Weightage")
                {
                    ToolTip = 'Specifies the value of the Weightage (%) field.';
                    ApplicationArea = All;
                    MinValue = 0;
                }
                field("Max Score"; Rec."Max Score")
                {
                    ApplicationArea = All;
                    MinValue = 0;
                    Editable = FieldEditableMaxScore;
                }
                field("Group Based"; Rec."Group Based")
                {
                    ApplicationArea = All;
                    Editable = FieldEditableGroupBased;
                    trigger OnValidate()
                    begin
                        if Rec."Group Based" then begin
                            if Rec."Branch Code" = '' then
                                Error('Branch Code must be specified when KPI is Group Based.');
                            Clear(Rec."Self Rating Applicable");
                            Rec."Self Rating Applicable" := false;
                        end else begin
                            Clear(Rec."Group Performance Based Score");
                            Clear(Rec."Self Rating Applicable");
                        end;
                        SetEditable();
                        CurrPage.Update(true);
                    end;
                }
                field("Self Rating Applicable"; Rec."Self Rating Applicable")
                {
                    ApplicationArea = All;
                    Editable = FieldEditableSelfRatingApplicable;
                }
                field("Group Performance Based Score"; Rec."Group Performance Based Score")
                {
                    ApplicationArea = All;
                    Editable = FieldEditableGroupScore;
                    MinValue = 0;
                    trigger OnValidate()
                    begin
                        if Rec."Group Based" and (Rec."Group Performance Based Score" > Rec."Max Score") then
                            Error('Group Performance Based Score %1 cannot exceed Max Score %2.',
                                  Rec."Group Performance Based Score", Rec."Max Score");
                    end;
                }
                field("KPI Master Remarks"; Rec."KPI Master Remarks")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetEditable;
    end;

    trigger OnOpenPage()
    begin
        SetEditable;
    end;

    var
        FieldEditable3: Boolean;
        FieldEditableGroupScore: Boolean;
        FieldEditableSelfRatingApplicable: Boolean;
        FieldEditableGroupBased: Boolean;
        FieldEditableMaxScore: Boolean;

    local procedure SetEditable()
    begin
        FieldEditable3 := (Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring) or Rec."Group Based";
        FieldEditableGroupScore := Rec."Group Based";
        FieldEditableSelfRatingApplicable := not Rec."Group Based";
        FieldEditableGroupBased := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;
        FieldEditableMaxScore := Rec."KPI Rating Type" = Rec."KPI Rating Type"::Scoring;
    end;
}
