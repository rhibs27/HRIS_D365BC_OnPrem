page 50073 "Appraisal KPI Master"
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
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("KPI No."; Rec."KPI No.")
                {
                    ToolTip = 'Specifies the value of the KPI No. field.';
                    ApplicationArea = All;
                }
                field("KRA Master"; Rec."KRA Master")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field("KRA Subtype"; Rec."KRA Subtype")
                {
                    ToolTip = 'Specifies the value of the Key Result Area field.';
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetEditable;
                    end;
                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    Editable = FieldEditable1;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Monthly field.';
                    ApplicationArea = All;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    Editable = FieldEditable2;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Quarterly field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                Field(Designation; Rec.Designation)
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
                    trigger OnValidate()
                    begin
                        SetEditable;
                    end;
                }
                field("Weightage"; Rec."Weightage")
                {
                    ToolTip = 'Specifies the value of the Weightage (%) field.';
                    ApplicationArea = All;
                    Editable = FieldEditable3;
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
        FieldEditable1: Boolean;
        FieldEditable2: Boolean;
        FieldEditable3: Boolean;
        FieldEditableGroupScore: Boolean;
        FieldEditableSelfRatingApplicable: Boolean;

    local procedure SetEditable()
    begin
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
        FieldEditable3 := Rec."KPI Rating Type" in [Rec."KPI Rating Type"::Scoring, Rec."KPI Rating Type"::"Group Based"];
        FieldEditableGroupScore := Rec."KPI Rating Type" = Rec."KPI Rating Type"::"Group Based";
        FieldEditableSelfRatingApplicable := Rec."KPI Rating Type" <> Rec."KPI Rating Type"::"Group Based";
    end;
}
