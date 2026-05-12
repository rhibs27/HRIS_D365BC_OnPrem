page 50153 "Employee Salary Advance Card"
{
    PageType = Card;
    SourceTable = "Employee Loan/Advance";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = IsOpen;
                field("Employee Code"; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        //LoanMgt.NewSalaryAdvanceCheck("Employee Code");
                        CurrPage.Update;
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Job Type"; Rec."Employee Type")
                {
                    ToolTip = 'Specifies the value of the Job Type field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
                field("Confirmation Service Period"; Rec."Confirmation Service Period")
                {
                    ToolTip = 'Specifies the value of the Confirmation Service Period field.';
                    ApplicationArea = All;
                }
                field("Date of Joining"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Date of Joining field.';
                    ApplicationArea = All;
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.';
                    ApplicationArea = All;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Gross Salary field.';
                    ApplicationArea = All;
                }
                field("Eligible Loan/Advance"; Rec."Eligible Loan/Advance")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Eligible Loan/Advance field.';
                    ApplicationArea = All;
                }
                field("Monthly Installment"; Rec.EMI)
                {
                    ToolTip = 'Specifies the value of the EMI field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Salary Advance Paid"; Rec."Salary Advance Paid")
                {
                    DrillDownPageId = "Detailed Empl. Ledger Entries";
                    ToolTip = 'Specifies the value of the Salary Advance Paid field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field("Status"; Rec."Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = StatusView;
                }
            }
            group("Facility Disbursement")
            {
                Visible = Rec."Approval Status" = Rec."Approval Status"::Approved;
                field(Reversed; Rec.Reversed)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
                field(Disburse; Rec.Disbursed)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Disbursed field.';
                    ApplicationArea = All;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                    ApplicationArea = All;
                }
                field(Settled; Rec.Settled)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Settled field.';
                    ApplicationArea = All;
                }
                field("Settlement Date"; Rec."Settlement Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Settlement Date field.';
                    ApplicationArea = All;
                }
                field("Settler User ID"; Rec."Settler User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Settler User ID field.';
                    ApplicationArea = All;
                }
            }
            group(Control17)
            {
                ShowCaption = false;
                Editable = IsOpen;
                field("Purpose of Advance Salary"; Rec."Purpose of Advance Salary")
                {
                    ToolTip = 'Specifies the value of the Purpose of Advance Salary field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    ToolTip = 'Specifies the value of the Requested Loan Date field.';
                    ApplicationArea = All;
                }
                field("Payback Months"; Rec."Payback Months")
                {
                    ToolTip = 'Specifies the value of the Payback Months field.';
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Applied Loan/Advance"; Rec."Applied Loan/Advance")
                {
                    ToolTip = 'Specifies the value of the Applied Loan/Advance field.';
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("DBR Ratio"; Rec."DBR Ratio")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the DBR Ratio field.';
                    ApplicationArea = All;
                }
            }
            group("Group Remarks")
            {
                Editable = IsPending or IsSettlementPending;
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                // field("Screener Remarks"; Rec."Screener Remarks")
                // {
                //     Editable = ForScreen;
                //     ToolTip = 'Specifies the value of the Screener Remarks field.';
                //     ApplicationArea = All;
                // }
                // field("Recommendation Remarks"; Rec."Recommendation Remarks")
                // {
                //     Editable = ForRecommend;
                //     ToolTip = 'Specifies the value of the Recommendation Remarks field.';
                //     ApplicationArea = All;
                // }
                field("Rejection Remark"; Rec."Rejection Remark")
                {
                    ToolTip = 'Specifies the value of the Rejection Remark field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
            }
            group(SettlementDetails)
            {
                Caption = 'Settlement Details';
                Editable = false;
                field("Settlement Approval Status"; Rec."Settlement Approval Status")
                {
                    ToolTip = 'Specifies the value of the Settlement Approval Status field.', Comment = '%';
                }
            }
            part("Employee Loan Advance Subform"; "Employee Loan Advance Subform")
            {
                SubPageLink = "Document No." = field("No.");
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No."),
                              "Employee Code" = field("Employee No."),
                              "Employee Activity Type" = field(Type);
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
            // field(Recommender; Rec.Recommender)
            // {
            //     Editable = false;
            //     ToolTip = 'Specifies the value of the Recommender field.';
            //     ApplicationArea = All;
            // }
            // field("Recommender Name"; Rec."Recommender Name")
            // {
            //     Editable = false;
            //     ToolTip = 'Specifies the value of the Recommender Name field.';
            //     ApplicationArea = All;
            // // }
            // field(Screener; Rec.Screener)
            // {
            //     Editable = false;
            //     ToolTip = 'Specifies the value of the Screener field.';
            //     ApplicationArea = All;
            // }
            // field(Approver; Rec.Approver)
            // {
            //     Editable = ForScreen;
            //     ToolTip = 'Specifies the value of the Approver field.';
            //     ApplicationArea = All;
            // }
            // field("Approver Name"; Rec."Approver Name")
            // {
            //     ToolTip = 'Specifies the value of the Approver Name field.';
            //     ApplicationArea = All;
            // }
            //}
        }
    }

    actions
    {
        area(Processing)
        {
            action("Validate Document")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ForRecommend;
                ToolTip = 'Executes the Validate Document action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanMgt: Codeunit "Loan Mgt.";
                begin
                    LoanMgt.ValidateDocument(Rec);
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsOpen;
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanMgt: Codeunit "Loan Mgt.";
                begin
                    LoanMgt.SendApprovaLoan(Rec, true);
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Cancel Approval Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoanMgt.SendApprovaLoan(Rec, false);
                end;
            }
            action("Screen Request")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Screen Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoanMgt.VerifyLoan(Rec);
                end;
            }
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
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Message('Salary Advance is Approved by %1', HRMgt.GetEmpName());
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
                Visible = IsPending;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;

                trigger OnAction()

                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remark" = '' then
                            Error('Rejection Remark is Empty')
                        else begin
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Salary Advance is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action("Settle Salary Advance")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Settle Salary Advance action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoanMgt.SettleAdvance(Rec);
                end;
            }
            action(Return)
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Return action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    //Rec.ReOpenDocument(Rec);
                end;
            }
            action(Disbursed)
            {
                Image = Delivery;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Disbursed action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to disbured?') then begin
                        Rec.Validate(Disbursed, true);
                        Rec.Validate("Disbursement Date", Today);
                        Rec.Modify(false);
                    end;
                end;
            }
            action("Change Approver")
            {
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Change Approver action.';
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    if Confirm('Do you want to modify approver?') then begin
                        //LoanMgt.PopUpChangingApprover(Rec);
                    end;
                end;
            }
            action("Print Reports")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Print Reports action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to print the document?', false) then begin
                        CurrPage.SetSelectionFilter(Rec);
                        Report.Run(Report::"Loan/Salary Advance Report", true, false, Rec);
                    end;
                end;
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        // if Rec."Approval Status" = Rec."Approval Status"::Recommended then
        //     ScreenerRemarksEditable := true
        // else
        //     ScreenerRemarksEditable := false;
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Loan Type" := Rec."Loan Type"::"Salary Advance";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Loan Type" := Rec."Loan Type"::"Salary Advance";
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
        HRSetup.Get;
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            //Rec.Validate("Employee Code");
            Rec.Modify(true);
        end;
        Rec.CalcFields("Salary Advance Paid");
        RecRef.GetTable(Rec);
    end;

    var
        LoanMgt: Codeunit "Loan Mgt.";
        // FormEditable: Boolean;
        // FormVisible: Boolean;

        ForApprove: Boolean;

        ForRecommend: Boolean;

        ForReject: Boolean;
        ForScreen: Boolean;
        ForSettle: Boolean;
        HRSetup: Record "Human Resources Setup";
        IsOpen: Boolean;
        IsPending: Boolean;
        IsSettlementPending: Boolean;
        IsApproved: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        RecRef: RecordRef;
        ApproverMgt: Codeunit "Approver Mgt";
        HRMgt: Codeunit "HR Mgt.";

    local procedure SetLayout()
    begin
        // FormEditable := Rec."Approval Status" in [Rec."Approval Status"::" ", Rec."Approval Status"::Canceled,
        //                 Rec."Approval Status"::Open];

        // FormVisible := Rec."Approval Status" in [Rec."Approval Status"::" ", Rec."Approval Status"::Canceled,
        //                 Rec."Approval Status"::Open];

        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    ForRecommend := true;
                    ForReject := false;
                    ForApprove := false;
                    ForScreen := false;
                end;
            Rec."Approval Status"::"Pending":
                begin
                    ForRecommend := true;
                    ForReject := true;
                    ForApprove := true;
                    ForScreen := false;
                end;
            // Rec."Approval Status"::Recommended:
            //     begin
            //         ForRecommend := false;
            //         ForReject := true;
            //         ForApprove := false;
            //         ForScreen := true;
            //     end;
            // Rec."Approval Status"::Screened:
            //     begin
            //         ForRecommend := false;
            //         ForReject := true;
            //         ForApprove := true;
            //         ForScreen := false;
            //     end;
            Rec."Approval Status"::Rejected, Rec."Approval Status"::Approved:
                begin
                    ForRecommend := false;
                    ForApprove := false;
                    ForReject := false;
                    ForScreen := false;
                    ForSettle := true;
                end;
        end;
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsSettlementPending := Rec."Settlement Approval Status" = Rec."Settlement Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;

        // if Rec."Approval Status" in [Rec."Approval Status"::Recommended, Rec."Approval Status"::Screened,
        //                           Rec."Approval Status"::Approved, Rec."Approval Status"::Rejected] then
        //     AfterRecommendedVisible := true
        // else
        //     AfterRecommendedVisible := false;
    end;
}
