page 50357 "Approval Setup Card"
{
    ApplicationArea = All;
    Caption = 'Approval Setup Card';
    PageType = Card;
    SourceTable = "Approval Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Request Type"; Rec."Request Type")
                {
                    ToolTip = 'Specifies the value of the Request Type field.', Comment = '%';
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ToolTip = 'Specifies the value of the Deputation On field.', Comment = '%';
                }
            }
            part("Approval Setup Lines"; "Approval Setup Subform")
            {
                Caption = 'Approval Setup Lines';
                ApplicationArea = all;
                SubPageLink = "Request Type" = field("Request Type"), "Deputation On" = field("Deputation On");
            }
        }
    }
}
