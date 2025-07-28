pageextension 50024 "standard Text Ext" extends "Standard Text Codes"
{
    layout
    {
        addafter(Description)
        {
            field("Employee Activity Type"; Rec."Employee Activity Type")
            {
                ApplicationArea = all;
            }
        }
    }
}
