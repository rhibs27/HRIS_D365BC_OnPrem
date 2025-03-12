page 50107 Overtimes
{
    CardPageId = "Overtime Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "OverTime";
    SourceTableView = WHERE(Type = FILTER(Overtime));
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
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Caption = 'OT Date';
                    ToolTip = 'Specifies the value of the OT Date field.';
                    ApplicationArea = All;
                }
                field("Check In Time"; Rec."Check In Time")
                {
                    Caption = 'Check In Time';
                    ToolTip = 'Specifies the value of the Check In Time field.';
                    ApplicationArea = All;
                }
                field("Check Out Time"; Rec."Check Out Time")
                {
                    Caption = 'Check Out Time';
                    ToolTip = 'Specifies the value of the Check Out Time field.';
                    ApplicationArea = All;
                }
                field("Estimated Hours"; Rec."Estimated Hours")
                {
                    ToolTip = 'Specifies the value of the Estimated Hours field.';
                    ApplicationArea = All;
                }
                field("Actual Hours"; Rec."Actual Hours")
                {
                    ToolTip = 'Specifies the value of the Actual Hours field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Reason for OT';
                    ToolTip = 'Specifies the value of the Reason for OT field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
                // field("Approver Code"; Rec."Approver Code")
                // {
                //     ToolTip = 'Specifies the value of the Approver Code field.';
                //     ApplicationArea = All;
                // }
                // field("Approver Name"; Rec."Approver Name")
                // {
                //     ToolTip = 'Specifies the value of the Approver Name field.';
                //     ApplicationArea = All;
                // }
                // field("Recommender Code"; Rec."Recommender Code")
                // {
                //     ToolTip = 'Specifies the value of the Recommender Code field.';
                //     ApplicationArea = All;
                // }
                // field("Recommender Name"; Rec."Recommender Name")
                // {
                //     ToolTip = 'Specifies the value of the Recommender Name field.';
                //     ApplicationArea = All;
                // }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Encashment Code"; Rec."Encashment Code")
                {
                    ToolTip = 'Specifies the value of the Encashment Code field.';
                    ApplicationArea = All;
                }
                field("OT Amount"; Rec."OT Amount")
                {
                    ToolTip = 'Specifies the value of the OT Amount field.';
                    ApplicationArea = All;
                }
                field("OT Disbursed"; Rec."OT Disbursed")
                {
                    ToolTip = 'Specifies the value of the OT Disbursed field.';
                    ApplicationArea = All;
                }
                field("Compensatory Days"; Rec."Compensatory Days")
                {
                    ToolTip = 'Specifies the value of the Compensatory Days field.';
                    ApplicationArea = All;
                }
                field("Payroll No."; Rec."Payroll No.")
                {
                    ToolTip = 'Specifies the value of the Payroll No. field.';
                    ApplicationArea = All;
                }
                field("Updated Payroll Line"; Rec."Updated Payroll Line")
                {
                    ToolTip = 'Specifies the value of the Updated Payroll Line field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Open)
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
                    Rec.FilterGroup(0);
                end;
            }
            // action(Screened)
            // {
            //     Promoted = true;
            //     PromotedCategory = Category4;
            //     PromotedIsBig = true;
            //     ToolTip = 'Executes the Screened action.';
            //     ApplicationArea = All;
            //     Visible=false;

            //     trigger OnAction()
            //     begin
            //         Rec.FilterGroup(2);
            //         ClearAll();
            //         Rec.SetRange("Approval Status", Rec."Approval Status"::Screened);
            //         Rec.FilterGroup(0);
            //     end;
            // }
            action("Pending Approval")
            {
                Image = PendingApproval;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::"Pending");
                    Rec.FilterGroup(0);
                end;
            }
            // action(Recommended)
            // {
            //     Image = Approve;
            //     Promoted = true;
            //     PromotedCategory = Category4;
            //     PromotedIsBig = true;
            //     ToolTip = 'Executes the Recommended action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         Rec.FilterGroup(2);
            //         ClearAll();
            //         Rec.SetRange("Approval Status", Rec."Approval Status"::Recommended);

            //         Rec.FilterGroup(0);
            //     end;
            // }
            action(Approved)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approved action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
                    Rec.FilterGroup(0);
                end;
            }
            action(Rejected)
            {
                Image = DeleteQtyToHandle;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Rejected action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Rejected);
                    Rec.FilterGroup(0);
                end;
            }
            // action("Final Approve")
            // {
            //     Image = Flow;
            //     Promoted = true;
            //     PromotedCategory = Category4;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Visible = false;
            //     ToolTip = 'Executes the Final Approve action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         Rec.FilterGroup(2);
            //         ClearAll();
            //         Rec.SetRange("Approval Status", Rec."Approval Status"::"Final Approved & Forwarded to Finance Department");
            //         Rec.FilterGroup(0);
            //     end;
            // }
        }
    }
}
