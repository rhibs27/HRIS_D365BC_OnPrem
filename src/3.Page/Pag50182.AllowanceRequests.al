page 50182 "Allowance Requests"
{
    ApplicationArea = All;
    Caption = 'Allowance Requests';
    CardPageId = "Request Allowance Card";
    PageType = List;
    SourceTable = "Assignment Memo Header";
    SourceTableView = where("Activity Type" = const("Request Allowance"));
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Requester Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field("Requester Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the English Year field.';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To date"; Rec."To date")
                {
                    ToolTip = 'Specifies the value of the To date field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                }
            }
        }
    }
}
