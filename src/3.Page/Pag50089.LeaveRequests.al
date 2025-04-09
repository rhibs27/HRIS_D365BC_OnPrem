page 50089 "Leave Requests"
{
    CardPageId = "Posted Leave Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,SetFilter';
    SourceTable = "Leave";
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE(Type = CONST("Leave Request"));
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;

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
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ToolTip = 'Specifies the value of the Cancelled field.';
                    ApplicationArea = All;
                }
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
                field("Compensatory Date"; Rec."Compensatory Date")
                {
                    ToolTip = 'Specifies the value of the Compensatory Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Recommend Request")
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Recommend Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // if Confirm('Do you want to recommend the request?', false) then
                    //     leaveMgt.RecommendEmployeeLeave(Rec."No.");
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // if Confirm('Do you want to approve the request?', false) then
                    //     leaveMgt.ApprovedRejectLeaveApproval(true, Rec."No.");
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    // if Confirm('Do you want reject the request?', false) then
                    //     leaveMgt.ApprovedRejectLeaveApproval(false, Rec."No.");
                end;
            }
            // action(Reopen)
            // {
            //     Image = ReOpen;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Reopen action.';
            //     ApplicationArea = All;
            //     Visible = false;

            //     trigger OnAction()
            //     begin
            //         Rec.ReopenDocument;
            //     end;
            // }
        }
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
            action(Screened)
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Screened action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::Screened);
                    // Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Image = PendingApproval;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                Visible = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::"Pending");
                    Rec.FilterGroup(0);
                end;
            }
            action(Recommended)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Recommended action.';
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::Recommended);

                    // Rec.FilterGroup(0);
                end;
            }
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
            action("Final Approve")
            {
                Image = Flow;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Final Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::"Final Approved & Forwarded to Finance Department");
                    // Rec.FilterGroup(0);
                end;
            }
        }
    }

    // trigger OnAfterGetRecord()
    // begin
    //     IsRecommended := Rec."Approval Status" = Rec."Approval Status"::Recommended;
    // end;

    trigger OnOpenPage()
    begin
        /*EmployeeVar.RESET;
        EmployeeVar.SETRANGE("NAV Login ID",USERID);
        IF EmployeeVar.FINDFIRST THEN;

          FILTERGROUP(-1);
          SETRANGE("Recommender Code",EmployeeVar."No.");
          SETRANGE("Employee No.",EmployeeVar."No.");
          SETRANGE("Approver Code",EmployeeVar."No.");
          IF FIND('-') THEN REPEAT
            MARK(TRUE);
          UNTIL NEXT=0;
          FILTERGROUP(0);
          MARKEDONLY(TRUE);
          */
    end;

    var
        leaveMgt: Codeunit "Leave Mgt.";
        HRMgt: Codeunit "HR Mgt.";
    // [InDataSet]
    // IsRecommended: Boolean;
}
