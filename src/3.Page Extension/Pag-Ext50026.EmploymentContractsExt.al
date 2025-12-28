pageextension 50026 "Employment Contracts Ext" extends "Employment Contracts"
{
    layout
    {
        addafter("No. of Contracts")
        {
            field("Leaves Lapse On Contract Renew"; Rec."Leaves Lapse On Contract Renew")
            {
                ApplicationArea = all;
            }
        }
    }
}
