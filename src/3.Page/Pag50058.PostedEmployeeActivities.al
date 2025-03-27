page 50058 "Posted Employee Activities"
{
    // version ATM.19.01.01

    CardPageId = "Posted Employee Activity Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Employee Activity Details";
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                    ApplicationArea = All;
                }
                field("Manager ID"; Rec."Manager ID")
                {
                    ToolTip = 'Specifies the value of the Manager ID field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies the value of the Approved By field.';
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
                    ApplicationArea = All;
                }
                field(Opening; Rec.Opening)
                {
                    ToolTip = 'Specifies the value of the Opening field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
