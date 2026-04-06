page 50397 "Emp Staff Social Loan Card"
{
    Caption = 'Employee Staff Social Loan Card';
    PageType = Card;
    SourceTable = "Employee Loan/Advance";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group("Employee Information")
            {
                field("Employee Code"; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;

                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Functional title"; rec."Functional title")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Salary Account Number"; rec."Salary Account Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Name field.';
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
                field("Confirmation Service Period"; Rec."Confirmation Service Period")
                {
                    ToolTip = 'Specifies the value of the Confirmation Service Period field.';
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
            group("Social Loan Parameters")
            {
                Editable = ForScreen;
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requested Loan Date field.';
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                    ApplicationArea = All;
                }
                field("Previous Loan Amount"; Rec."Previous Loan Amount")
                {
                    ToolTip = 'Specifies the value of the Previous Loan Amount field.';
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
                field("Total Loan Amount"; Rec."Total Loan Amount")
                {
                    ToolTip = 'Specifies the value of the Total Loan Amount field.';
                    ApplicationArea = All;
                }
                field(EMI; Rec.EMI)
                {
                    Caption = 'Monthly Interest';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Monthly Interest field.';
                    ApplicationArea = All;
                }
                field("Purpose of Loan"; Rec."Purpose of Loan")
                {
                    Caption = 'Purpose for Staff Social Loan';
                    ShowMandatory = true;
                    Editable = true;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Purpose of Loan field.';
                    ApplicationArea = All;
                }
                field("Applied Loan"; Rec."Applied Loan/Advance")
                {
                    ToolTip = 'Specifies the value of the Applied Loan/Advance field.';
                    ApplicationArea = All;
                    Editable = true;

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
                field("Loan Enhancement"; rec."Loan Enhancement")
                {
                    ApplicationArea = All;
                }
            }
            group("Security Documentation")
            {
                Visible = IsApproved;
                field("Employee Citizenship No."; Rec."Citizenship No.")
                {
                    ToolTip = 'Specifies the value of the Employee Citizenship No. field.';
                    ApplicationArea = All;
                }
                field("Citizenship Issue Date"; Rec."Citizenship Issue Date")
                {
                    ToolTip = 'Specifies the value of the Citizenship Issue Date field.';
                    ApplicationArea = All;
                }
                field("Employee Name in Nepali"; Rec."Employee Name in Nepali")
                {
                    ToolTip = 'Specifies the value of the Employee Name in Nepali field.';
                    ApplicationArea = All;
                }
                field("Father's Name In Nepali"; Rec."Father's Name In Nepali")
                {
                    ToolTip = 'Specifies the value of the Father''s Name In Nepali field.';
                    ApplicationArea = All;
                }
                field("Grandfather's Name In Nepali"; Rec."Grandfather's Name In Nepali")
                {
                    ToolTip = 'Specifies the value of the Grandfather''s Name In Nepali field.';
                    ApplicationArea = All;
                }
                field("Offer Letter Issued Date"; Rec."Offer Letter Issued Date")
                {
                    ToolTip = 'Specifies the value of the Offer Letter Issued Date field.';
                    ApplicationArea = All;
                }
                field("Amount In Words (Nepali)"; Rec."Amount In Words (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Amount In Words (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Offer Letter Date(Nepali)"; Rec."Offer Letter Date(Nepali)")
                {
                    ToolTip = 'Specifies the value of the Offer Letter Date(Nepali) field.';
                    ApplicationArea = All;
                }
            }
            group("Facility Disbursement")
            {
                Visible = IsApproved;
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                    ApplicationArea = All;
                }
                field("Disbursed Amount"; Rec."Disbursed Amount")
                {
                    ToolTip = 'Specifies the value of the Disbursed Amount field.';
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
                    ToolTip = 'Specifies the value of the Settlement Date field.';
                    ApplicationArea = All;
                }
                field("Settler User ID"; Rec."Settler User ID")
                {
                    ToolTip = 'Specifies the value of the Settler User ID field.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field(Disbursed; Rec.Disbursed)
                {
                    ToolTip = 'Specifies the value of the Disbursed field.';
                    ApplicationArea = All;
                }
            }

            group("Group Remarks")
            {
                field(Remarks; Rec.Remarks)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remark"; Rec."Rejection Remark")
                {
                    Editable = IsPending;
                    ToolTip = 'Specifies the value of the Rejection Remark field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No.");
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
                Visible = IsOpen;
                ToolTip = 'Executes the Validate Document action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    LoanMgt: Codeunit "Loan Mgt.";
                begin
                    if LoanMgt.ValidateDocument(Rec) then
                        Message('Leave Document is validated');
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
                        RecRef.GetTable(Rec);
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Message('Staff Social Loan is Approved by %1', HRMgt.GetEmpName());
                        clear(Rec."Rejection Remark");
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
                            RecRef.GetTable(Rec);
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Personal loan is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action("Settle Personal Loan")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Settle Personal Loan action.';
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
            action(Disburse)
            {
                Image = Aging;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Disburse action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.DisburseLoan;
                end;
            }
            action("Modify Security Document")
            {
                Image = Migration;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Modify Security Document action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to modify security document?') then begin
                        LoanMgt.PopUpSecurityDoc(Rec);
                        Message('Security Document updated.');
                    end;
                end;

            }
        }
        area(Reporting)
        {
            action("Staff Social Loan Deed")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Personal Loan Deed action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Staff Social Loan Report", true, false, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
        if rec."Approval Status" = Rec."Approval Status"::Open then
            LoanMgt.CalculateFields(Rec);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Loan Type" := Rec."Loan Type"::"Staff Social Loan";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Loan Type" := Rec."Loan Type"::"Staff Social Loan";
    end;

    trigger OnOpenPage()
    begin
        CreateIncomingDocFromEmailAttachment := OfficeMgt.OCRAvailable;
        CreateIncomingDocumentVisible := not OfficeMgt.IsOutlookMobileApp;
        SetLayout();
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            Rec.Validate("Employee No.");
            Rec.Modify(true);
        end;
        RecRef.GetTable(Rec);
    end;

    var
        CreateIncomingDocumentVisible: Boolean;
        CreateIncomingDocFromEmailAttachment: Boolean;
        OfficeMgt: Codeunit "Office Management";
        HasIncomingDocument: Boolean;
        // FormEditable: Boolean;
        LoanMgt: Codeunit "Loan Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        IsOpen: Boolean;
        RecRef: RecordRef;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        IsPending: Boolean;
        IsApproved: Boolean;

        ForApprove: Boolean;

        ForRecommend: Boolean;

        ForReject: Boolean;
        ForScreen: Boolean;
        ForSettle: Boolean;
        HRMgt: Codeunit "HR Mgt.";

    local procedure SetControlAppearance()
    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
    end;

    local procedure SetLayout()
    begin

        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    ForRecommend := true;
                    ForReject := false;
                    ForApprove := false;
                    ForScreen := true;
                end;
            Rec."Approval Status"::"Pending":
                begin
                    ForRecommend := true;
                    ForReject := true;
                    ForApprove := true;
                    ForScreen := false;
                end;

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
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
    end;
}
