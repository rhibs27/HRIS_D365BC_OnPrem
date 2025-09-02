page 50184 "Tax Setup Reduction Subform"
{
    ApplicationArea = All;
    Caption = 'Tax Setup Reduction Lines';
    PageType = ListPart;
    SourceTable = "Tax Setup Reduction Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                }
                field("Special Tax Exempt"; Rec."Special Tax Exempt")
                {
                    ToolTip = 'Specifies the value of the Special Tax Exempt % field.', Comment = '%';
                }
                field("Special Red. on 1st Slab"; Rec."Special Red. on 1st Slab")
                {
                    ToolTip = 'Specifies the value of the Special Red. % on 1st Slab field.', Comment = '%';
                }
                field("Pension Reduction 1st Slab"; Rec."Pension Reduction 1st Slab")
                {
                    ToolTip = 'Specifies the value of the Pension Reduction % 1st Slab field.', Comment = '%';
                }
            }
        }
    }
}
