page 50186 "Attendance Missed Lists"
{


    CardPageId = "Attendance missed Card";
    Editable = false;
    PageType = List;
    SourceTable = "Attendance Missed";
    SourceTableView = WHERE(Type = CONST("Attendance Missed"));
    UsageCategory = Lists;
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
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                // field("No. of Days"; Rec."No. of Days")
                // {
                //     ToolTip = 'Specifies the value of the No. of Days field.';
                //     ApplicationArea = All;
                // }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                // field("Approver Type"; Rec."Approver Type")
                // {
                //     ToolTip = 'Specifies the value of the Approver Type field.';
                //     ApplicationArea = All;
                // }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action("Cancel Document")
            // {
            //     Image = Cancel;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Cancel Document action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         DocCancelMgt.OpenAttendanceMissed(Rec);
            //     end;
            // }
            // action("Change Recommender/Approver")
            // {
            //     Image = ReOpen;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Visible = Rec.Type = Rec.Type::"Attendance Missed";
            //     ToolTip = 'Executes the Change Recommender/Approver action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         Rec.ReopenDocument;
            //     end;
            // }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
        DocCancelMgt: Codeunit "AttendanceMiss Mgt";
}
