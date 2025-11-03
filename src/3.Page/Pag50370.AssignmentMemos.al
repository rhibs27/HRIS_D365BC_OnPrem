page 50370 "Assignment Memos"
{
    ApplicationArea = All;
    Caption = 'Assignment Memos';
    PageType = List;
    SourceTable = "Assignment Memo Header";
    SourceTableView = where("Activity Type" = const("Allowance Assignment Memo"));
    CardPageId = "Assignment Memo Card";
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
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To date"; Rec."To date")
                {
                    ToolTip = 'Specifies the value of the To date field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.', Comment = '%';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ToolTip = 'Specifies the value of the Unit Code field.', Comment = '%';
                }
                field("Requester Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Requester Employee No. field.', Comment = '%';
                }
                field("Requester Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Requester Employee Name field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }


            }
        }
    }
}
