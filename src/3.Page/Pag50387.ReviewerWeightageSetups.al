page 50387 "Reviewer Weightage Setups"
{
    ApplicationArea = All;
    Caption = 'Reviewer Weightage Setups';
    PageType = ListPart;
    SourceTable = "Reviewer Weightage Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Appraisal Template field.';
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                }
                field("Reviewer Type"; Rec."Reviewer Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reviewer Type field.';
                }
                field("Approver Role"; Rec."Approver Role")
                {
                    ApplicationArea = all;
                }
                field("Deputation Type"; Rec."Deputation Type")
                {
                    ApplicationArea = all;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
                field(Weightage; Rec.Weightage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Weightage field.';
                }
            }
        }
    }
}
