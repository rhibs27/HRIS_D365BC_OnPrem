pageextension 50023 DImensionValue extends "Dimension Values"
{
    layout
    {

        addafter("Consolidation Code")
        {
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Region field.', Comment = '%';
            }
            field("Deputation On Type"; Rec."Deputation On Type")
            {
                ApplicationArea = all;
            }
        }
    }

}
