page 50106 "Overtime Card"
{
    // version 1.00,OT,Bulk Cash,Out of Office
    PageType = Card;
    SourceTable = "OverTime";
    ApplicationArea = All;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = FormEditable;
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
                field("Estimated Hours"; Rec."Estimated Hours")
                {
                    ToolTip = 'Specifies the value of the Estimated Hours field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Actual OT Hours"; Rec."Actual OT Hours")
                {
                    // Editable = false;
                    ToolTip = 'Specifies the value of the Actual Hours field.';
                    ApplicationArea = All;
                }
                field("Total OT Hours"; Rec."Total OT Hours")
                {
                    Caption = 'Attendance OT Hrs';
                    ToolTip = 'Specifies the value of the Actual Hours field.';
                    ApplicationArea = All;
                }
                field("Morning OT Hours"; Rec."Morning OT Hours")
                {
                    ToolTip = 'Specifies the value of the Morning OT Hours field.';
                    ApplicationArea = All;
                }
                field("Evening OT Hours"; Rec."Evening OT Hours")
                {
                    ToolTip = 'Specifies the value of the Evening OT Hours field.';
                    ApplicationArea = All;
                }
                field("OverTime Claim Type"; Rec."OverTime Claim Type")
                {
                    ToolTip = 'Specifies the value of the OverTime Claim Type field.';
                    ApplicationArea = All;
                }
                field("Encashment Code"; Rec."Encashment Code")
                {
                    ToolTip = 'Specifies the value of the Encashment Code field.';
                    ApplicationArea = All;
                    Visible = false;
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
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Visible = ApprovalStatusView;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                    Visible = StatusView;
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
            }
            // part(Attachment; "Attachment Subform")
            // {
            //     SubPageLink = "No." = field("No."),
            //                   Type = const(" "),
            //                   "Employee Code" = field("Employee No.");
            //     ApplicationArea = All;
            // }
            group(Control6)
            {
                Caption = 'Remarks';
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Reason for OT';
                    Editable = true;
                    ToolTip = 'Specifies the value of the Reason for OT field.';
                    ApplicationArea = All;
                }
                // field("Screener Remarks"; Rec."Screener Remarks")
                // {
                //     Editable = ForScreen;
                //     ToolTip = 'Specifies the value of the Screener Remarks field.';
                //     ApplicationArea = All;
                // }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = IsPending;
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
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
            //     field("Recommender Code"; Rec."Recommender Code")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Code field.';
            //         ApplicationArea = All;
            //     }
            //     field("Recommender Name"; Rec."Recommender Name")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Name field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Code"; Rec."Approver Code")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Code field.';
            //         ApplicationArea = All;
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
            action(Submit)
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = isOpen;
                ToolTip = 'Executes the Submit action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    OverTimeMgt.ApplyForOverTimeApprovalForms(Rec);
                    IsApplied := true;
                    CurrPage.Close;
                end;
            }
        }
        area(Navigation)
        {
            // action("Recommend Request")
            // {
            //     Image = Register;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Visible = false;
            //     ToolTip = 'Executes the Recommend Request action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         if Confirm('Do you want to recommend the request?', false) then
            //             HRMgt.RecommendEmployeeActivity(Rec."No.");
            //     end;
            // }
            // action("Screen Request")
            // {
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     // Visible = ForScreen;
            //     Visible = false;
            //     ToolTip = 'Executes the Screen Request action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         // ResignationMgt.ScreenResignationForOvertime(Rec);
            //     end;
            // }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Message('Overtime is Approved by %1', HRMgt.GetEmpName());
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
                Visible = IsPending;

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Overtime is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            // action("Change Recommender Approver")
            // {
            //     Image = ReOpen;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Change Recommender Approver action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         Rec.ReopenDocument;
            //     end;
            // }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout
    end;

    trigger OnOpenPage()
    begin
        SetLayout;
        if IsOpen then
            ApprovalMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::Overtime, Rec."Approval Status");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF NOT IsApplied and IsOpen THEN
            IF NOT CONFIRM('The data will be erased. Do you want to continue?', TRUE) THEN
                ERROR('')
            else begin
                Approval.Reset();
                Approval.SetRange("Document No.", '');
                Approval.setRange("Document Type", Approval."Document Type"::Overtime);
                Approval.SetRange("Employee No", Rec."Employee No.");
                Approval.DeleteAll();
            end;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        OverTimeMgt: Codeunit "OverTime Mgt";
        IsApplied: Boolean;
        FormEditable: Boolean;
        // ForRecommend: Boolean;
        // ForReject: Boolean;
        ForApprove: Boolean;
        // ForScreen: Boolean;
        IsPending: Boolean;
        IsOpen: Boolean;
        IsApprove: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        RecRef: RecordRef;
        ApprovalMgt: Codeunit "Approver Mgt";
        Approval: Record "Approval HRMS";

    local procedure SetLayout()
    begin
        FormEditable := Rec."Approval Status" in [Rec."Approval Status"::" ", Rec."Approval Status"::Canceled,
                        Rec."Approval Status"::Open];
        IsPending := rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApprove := rec."Approval Status" = rec."Approval Status"::Approved;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);

        // case Rec."Approval Status" of
        //     Rec."Approval Status"::Rejected, Rec."Approval Status"::Open:
        //         begin
        //             ForReject := false;
        //             ForApprove := false;
        //         end;
        //     Rec."Approval Status"::"Pending":
        //         begin
        //              := true;
        //             ForReject := true;
        //             ForApprove := false;
        //             ForScreen := false;
        //         end;
        //     Rec."Approval Status"::Recommended:
        //         begin
        //             ForRecommend := false;
        //             ForReject := true;
        //             ForApprove := true;
        //             ForScreen := false;
        //         end;
        //     Rec."Approval Status"::Screened:
        //         begin
        //             ForRecommend := false;
        //             ForReject := false;
        //             ForApprove := false;
        //             ForScreen := false;
        //         end;
        //     Rec."Approval Status"::Approved:
        //         begin
        //             ForRecommend := false;
        //             ForApprove := false;
        //             ForReject := true;
        //             ForScreen := true;
        //         end;
        // end;
    end;


}
