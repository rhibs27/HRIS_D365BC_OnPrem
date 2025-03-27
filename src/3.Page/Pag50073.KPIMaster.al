page 50073 "KPI Master"
{
    Caption = 'KPI Master';
    PageType = List;
    SourceTable = "KPI Master";
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
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field("Key Result Area"; Rec."Key Result Area")
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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Weightage (%)"; Rec."Weightage (%)")
                {
                    ToolTip = 'Specifies the value of the Weightage (%) field.';
                    ApplicationArea = All;
                }
                field("Target Assigned"; Rec."Target Assigned")
                {
                    ToolTip = 'Specifies the value of the Target Assigned field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
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

    actions { }

    trigger OnAfterGetRecord()
    begin
        SetEditable;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*AppraisalSetup.GET;
        KPIMaster.RESET;
        KPIMaster.SETRANGE("KRA No.",KPIMaster."KRA No.");
          IF KPIMaster.FINDFIRST THEN
            REPEAT
              Weightage+=KPIMaster."Weightage (%)";
              MESSAGE('%1',Weightage);
            UNTIL KPIMaster.NEXT =0;
          IF Weightage > AppraisalSetup.Weightage THEN
            ERROR(Text001,AppraisalSetup.Weightage);*/
    end;

    trigger OnOpenPage()
    begin
        SetEditable;
    end;

    var
        FieldEditable1: Boolean;
        FieldEditable2: Boolean;

    local procedure SetEditable()
    begin
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
    end;
}
