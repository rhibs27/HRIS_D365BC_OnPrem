page 50100 "Posted Leave Card"
{
    // version NIC Asia1.00,Leave
    SourceTable = "Leave";
    ApplicationArea = All;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
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
                field("Employee Work Shift"; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.';
                    ApplicationArea = All;
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.';
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
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
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
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("For Death Of"; Rec."For Death Of")
                {
                    ToolTip = 'Specifies the value of the For Death Of field.';
                    ApplicationArea = All;
                }
                field("Child's Gender"; Rec."Child's Gender")
                {
                    ToolTip = 'Specifies the value of the Child''s Gender field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ToolTip = 'Specifies the value of the Pay Type field.';
                    ApplicationArea = All;
                }
                field("Compensatory Date"; Rec."Compensatory Date")
                {
                    ToolTip = 'Specifies the value of the Compensatory Date field.';
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.';
                    ApplicationArea = All;
                }
            }
            group("For Rejection")
            {
                Caption = 'For Rejection';
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No."),
                              Type = const(" "),
                              "Employee Code" = field("Employee No."),
                              "Leave Type Code" = field("Leave Code");
                ApplicationArea = All;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
            // group(Approval)
            // {
            //     Caption = 'Approval';
            //     Editable = false;
            // field("Approver Type"; Rec."Approver Type")
            // {
            //     ToolTip = 'Specifies the value of the Approver Type field.';
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
            // field("Approver Code"; Rec."Approver Code")
            // {
            //     ToolTip = 'Specifies the value of the Approver Code field.';
            //     ApplicationArea = All;
            //     }
            //     field("Approver Name"; Rec."Approver Name")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Name field.';
            //         ApplicationArea = All;
            //     }
            // }
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
                Visible = not IsRecommended;
                ToolTip = 'Executes the Recommend Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to recommend the request?', false) then begin
                        Leavemgt.RecommendEmployeeLeave(Rec."No.");
                        CurrPage.Close;
                    end;
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsRecommended;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin

                    if Confirm('Do you want to approve the request?', false) then begin
                        Leavemgt.ApprovedRejectLeaveApproval(true, Rec."No.");
                        CurrPage.Close;
                    end;
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

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        Leavemgt.ApprovedRejectLeaveApproval(false, Rec."No.");
                        CurrPage.Close;
                    end;
                end;
            }
            action(Reopen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reopen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ReopenDocument;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Leave Request";
    end;

    trigger OnOpenPage()
    begin
        IsPending := Rec."Approval Status" in [Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Recommended];
        IsRecommended := Rec."Approval Status" = Rec."Approval Status"::Recommended;
    end;

    var
        Leavemgt: Codeunit "Leave Mgt.";
        HRMgt: Codeunit "HR Mgt.";
        [InDataSet]
        IsPending: Boolean;
        IsRecommended: Boolean;
}
