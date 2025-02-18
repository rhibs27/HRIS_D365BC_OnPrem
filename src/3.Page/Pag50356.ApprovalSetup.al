page 50356 "Approval Setup"
{
    ApplicationArea = All;
    Caption = 'Approval Setup';
    PageType = List;
    SourceTable = "Approval Setup";
    UsageCategory = Lists;
    CardPageId = "Approval Setup Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Request Type field.', Comment = '%';
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
