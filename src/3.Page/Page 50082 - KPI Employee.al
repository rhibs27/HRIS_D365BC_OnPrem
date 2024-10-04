page 50082 "KPI Employee"
{
    Caption = 'KPI Employee';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "KPI Employee";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(appraisalCode; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                }
                field(kRACategory; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field(keyResultArea; Rec."Key Result Area")
                {
                    ToolTip = 'Specifies the value of the Key Result Area field.';
                    ApplicationArea = All;
                }
                field("KPI No."; Rec."KPI No.")
                {
                    ToolTip = 'Specifies the value of the KPI No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Weightage(%)"; Rec."Weightage(%)")
                {
                    ToolTip = 'Specifies the value of the Weightage(%) field.';
                    ApplicationArea = All;
                }
                field("Target Assigned"; Rec."Target Assigned")
                {
                    ToolTip = 'Specifies the value of the Target Assigned field.';
                    ApplicationArea = All;
                }
                field("Actual Achievement"; Rec."Actual Achievement")
                {
                    ToolTip = 'Specifies the value of the Actual Achievement field.';
                    ApplicationArea = All;
                }
                field("Action"; Rec.Action)
                {
                    ToolTip = 'Specifies the value of the Action field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
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
                field("From Setup"; Rec."From Setup")
                {
                    Visible = IsGuiAllowed;
                    ToolTip = 'Specifies the value of the From Setup field.';
                    ApplicationArea = All;
                }
                field("Hide Delete Action"; Rec."Hide Delete Action")
                {
                    ToolTip = 'Specifies the value of the Hide Delete Action field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing) { }
    }

    trigger OnAfterGetRecord()
    begin
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
        IsGuiAllowed := GuiAllowed;
    end;

    trigger OnOpenPage()
    begin
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
        IsGuiAllowed := GuiAllowed;
    end;

    var
        FieldEditable1: Boolean;
        FieldEditable2: Boolean;
        IsGuiAllowed: Boolean;
}
