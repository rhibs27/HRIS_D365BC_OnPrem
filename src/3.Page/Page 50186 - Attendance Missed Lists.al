page 50186 "Attendance Missed Lists"
{
    // version NIC Asia1.00,Leave

    CardPageId = "Cancel Document";
    Editable = false;
    PageType = List;
    SourceTable = "Cancel Document";
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
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Approver Type"; Rec."Approver Type")
                {
                    ToolTip = 'Specifies the value of the Approver Type field.';
                    ApplicationArea = All;
                }
                field("Recommender Code"; Rec."Recommender Code")
                {
                    ToolTip = 'Specifies the value of the Recommender Code field.';
                    ApplicationArea = All;
                }
                field("Recommender Name"; Rec."Recommender Name")
                {
                    ToolTip = 'Specifies the value of the Recommender Name field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.';
                    ApplicationArea = All;
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ToolTip = 'Specifies the value of the Reason Description field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Cancel Document")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Cancel Document action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DocCancelMgt.OpenCancelEmpActivity(Rec);
                end;
            }
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
        DocCancelMgt: Codeunit DocCancelMgt;
}
