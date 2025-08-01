pageextension 50025 Dimension extends Dimensions
{
    layout
    {
        addlast(Control1)
        {
            field("Deputation On Type"; Rec."Deputation On Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deputation On field.', Comment = '%';
            }
        }
    }
}
