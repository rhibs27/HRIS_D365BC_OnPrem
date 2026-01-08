page 50382 "Appraisal Weightage Setup"
{
    ApplicationArea = All;
    Caption = 'Appraisal Weightage Setup';
    PageType = List;
    SourceTable = "Appraisal Weightage Setup";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fiscal year';
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the appraisal type';
                }
                field("KRA Master"; Rec."KRA Master")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the KRA Master';
                }
                field("Self Score"; Rec."Self Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight percentage for Self Score';
                }
                field("Immediate Supervisor"; Rec."Immediate Supervisor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight percentage for Immediate Supervisor';
                }
                field("Reviewer"; Rec."Reviewer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight percentage for Reviewer';
                }
                field("Group Performance"; Rec."Group Performance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight percentage for Group Performance';
                }
                field("HR Committee"; Rec."HR Committee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight percentage for HR Committee';
                }
                field("Total Weightage"; Rec."Total Weightage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total of all weight percentages';
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
}