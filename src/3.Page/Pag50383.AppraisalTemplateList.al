page 50383 "Appraisal Template List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Appraisal Template";
    Caption = 'Appraisal Template List';
    CardPageId = "Appraisal Template Card";
    ModifyAllowed=false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Template Master No."; Rec."Template Master No.")
                {
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                }
                field("Designation"; Rec."Designation")
                {
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        FieldEditableRules;
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
                field("Check Date From"; Rec."Check Date From")
                {
                    ApplicationArea = All;
                }
                field("Minimum Service Period"; Rec."Minimum Service Period")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        FieldEditable1, FieldEditable2 : Boolean;
    local procedure FieldEditableRules()
    begin
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
    end;
}