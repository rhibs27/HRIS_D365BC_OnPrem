page 50363 "Transfer Claim Details Subform"
{
    ApplicationArea = All;
    Caption = 'Transfer Claim Details Subform';
    PageType = ListPart;
    SourceTable = "Transfer Claim Detail";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Attribute code"; Rec."Attribute code")
                {
                    ToolTip = 'Specifies the value of the Attribute code field.', Comment = '%';
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ToolTip = 'Specifies the value of the Requested Amount field.', Comment = '%';
                }
                field("Maximum Eligible Amount"; Rec."Eligible Amount")
                {
                    ToolTip = 'Specifies the value of the Maximum Eligible Amount field.', Comment = '%';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.', Comment = '%';
                }
            }
        }
    }
}
