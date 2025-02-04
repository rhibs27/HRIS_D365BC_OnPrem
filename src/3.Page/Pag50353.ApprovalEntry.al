page 50353 "HRMS Approval Entry"
{
    ApplicationArea = All;
    Caption = 'HRMS Approval Entry';
    PageType = ListPart;
    SourceTable = "Approval HRMS";
    //AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Approver No"; Rec."Approver No")
                {
                    ToolTip = 'Specifies the value of the Approver No field.', Comment = '%';
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("Approval Sequence"; Rec."Approval Sequence")
                {
                    ToolTip = 'Specifies the value of the Approval Sequence field.', Comment = '%';
                }
            }
        }
    }
}