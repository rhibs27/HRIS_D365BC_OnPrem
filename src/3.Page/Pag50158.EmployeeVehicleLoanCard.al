page 50158 "Employee Vehicle Loan Card"
{
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

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Job Title(Desgination)"; Rec."Job Title")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                }
                field("Salary Account Number"; rec."Salary Account Number")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ToolTip = 'Specifies the value of the Unit Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Functional title"; rec."Functional title")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Confirmation Service Period"; Rec."Confirmation Service Period")
                {
                    ToolTip = 'Specifies the value of the Confirmation Service Period field.';
                    ApplicationArea = All;
                }
                field("Remaining Service Period"; rec."Remaining Service Period")
                {
                    ApplicationArea = all;
                    Editable = false;
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
            group("Vehicle Loan Parameter")
            {
                Editable = IsOpen;
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requested Loan Date field.';
                    ApplicationArea = All;
                }
                field("Previous Loan Amount"; Rec."Previous Loan Amount")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Previous Loan Amount field.';
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Interest Rate field.';
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the EMI field.';
                    ApplicationArea = All;
                }
                field("Purpose of Loan"; Rec."Purpose of Loan")
                {
                    Editable = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Purpose of Loan field.';
                    ApplicationArea = All;
                }
                field("Driving License Owner"; rec."Driving License Owner")
                {
                    ApplicationArea = All;
                }
                field("License Category"; rec."License Category")
                {
                    ApplicationArea = All;
                }
                field("Cost of Vehicle"; Rec."Cost of Vehicle")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Cost of Vehicle field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }

                field("Repayment Period"; Rec."Repayment Period")
                {
                    ToolTip = 'Specifies the value of the Repayment Period field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Requested Loan Amount"; Rec."Applied Loan/Advance")
                {
                    Caption = 'Requested Loan Amount';
                    ToolTip = 'Specifies the value of the Applied Loan/Advance field.';
                    ApplicationArea = All;

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
                field("Insurance Company Code"; rec."Insurance Company Code")
                {
                    ApplicationArea = All;
                }
                field("Insurance Company"; rec."Insurance Company")
                {
                    Caption = 'Insurance Company Name';
                    ApplicationArea = All;
                }
                field("Vehicle Loan Type"; Rec."Vehicle Loan Type")
                {
                    Editable = true;
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Vehicle Loan Type field.';
                    ApplicationArea = All;
                }
                field("Vehicle Type (Nepali)"; Rec."Vehicle Type (Nepali)")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Vehicle Type (Nepali) field.';
                    ApplicationArea = All;
                }
                field("License No."; rec."License No.")
                {
                    ApplicationArea = All;
                }
                field("License Expiry Date"; rec."License Expiry Date")
                {
                    ApplicationArea = All;
                }
            }
            group("Vehicle Details")
            {
                Editable = IsOpen;
                field("Vehicle Purchase Type"; Rec."Vehicle Purchase Type")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Vehicle Purchase Type field.';
                    ApplicationArea = All;
                }
                field("Name of Supplier"; Rec."Name of Supplier")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Name of Supplier field.';
                    ApplicationArea = All;
                }
                field("Address of Supplier"; Rec."Address of Supplier")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Address of Supplier field.';
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
                field("Vehicle Model"; Rec."Vehicle Model")
                {
                    ToolTip = 'Specifies the value of the Vehicle Model field.';
                    ApplicationArea = All;
                }
                field("Transportation Management off."; Rec."Transportation Management off.")
                {
                    ToolTip = 'Specifies the value of the Transportation Management off. field.';
                    ApplicationArea = All;
                }
                field("Vehicle Engine No."; Rec."Vehicle Engine No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle Engine No. field.';
                    ApplicationArea = All;
                }
                field("Vehicle Chasis No."; Rec."Vehicle Chasis No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle Chasis No. field.';
                    ApplicationArea = All;
                }
                field("Vehicle Registration No."; Rec."Vehicle Registration No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle Registration No. field.';
                    ApplicationArea = All;
                }
                field("Offer Letter Issued Date"; Rec."Offer Letter Issued Date")
                {
                    ToolTip = 'Specifies the value of the Offer Letter Issued Date field.';
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
                field("Applied Loan"; AppliedLoan)
                {
                    ToolTip = 'Specifies the value of the AppliedLoan field.';
                    ApplicationArea = All;
                }
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
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("Rejection Remark"; Rec."Rejection Remark")
                {
                    ToolTip = 'Specifies the value of the Rejection Remark field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
            }
            part(Attachment; "Attachment Subform")
            {
                Editable = IsOpen;
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
            group("HR Recommendation")
            {
                Visible = IsPending;
                field("Staff VL previously"; rec."Staff VL previously")
                {
                    Caption = 'Did Staff Utlized Previous SVL for more than half tenure?';
                    ApplicationArea = all;
                }
                field("HR VL Recommended Amount"; rec."HR VL Recommended Amount")
                {
                    Editable = Rec."Staff VL previously";
                    Caption = 'HR VL Recommended Amount';
                    ApplicationArea = ALL;
                }
                field(Tenure; rec."HR Recommended Tenure")
                {
                    Editable = Rec."Staff VL previously";
                    Caption = 'HR Recommended Tenure';
                    ApplicationArea = ALL;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No.");
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
                        Message('Loan Document is validated');
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
                        Message('Vehicle Loan is Approved by %1', HRMgt.GetEmpName());
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
                            Message('Vehicle Loan is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action("Settle Vehicle Loan")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Settle Vehicle Loan action.';
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
                Visible = IsApproved;

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
                ToolTip = 'Executes the Modify Security Document action.';
                ApplicationArea = All;
                Visible = IsApproved;

                trigger OnAction()
                begin
                    if Confirm('Do you want to modify security document?') then begin
                        LoanMgt.PopUpSecurityDoc(Rec);
                        Message('Security Document updated.');
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
                        Message('Approver updated.');
                    end;
                end;
            }
            action("Update Vehicle Details")
            {
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Update Vehicle Details action.';
                ApplicationArea = All;
                Visible = IsApproved;

                trigger OnAction()
                begin
                    if Confirm('Do you want to modify vehicle details?') then begin
                        LoanMgt.PopUpVechicleLoanDetails(Rec);
                    end;
                end;
            }
            action("Create Settlement")
            {
                Caption = 'Create Settlement';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CanCreateSettlement;
                ToolTip = 'Initiate a Loan Settlement request for this disbursed vehicle loan.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanSettlement: Record "Loan Settlement";
                    LoanSettlementCard: Page "Loan Settlement Card";
                begin
                    LoanSettlement.Init();
                    LoanSettlement."Loan Type" := Rec."Loan Type";
                    LoanSettlement.Validate("Loan No.", Rec."No.");
                    LoanSettlement.Insert(true);
                    LoanSettlementCard.SetRecord(LoanSettlement);
                    LoanSettlementCard.Run();
                    CurrPage.Update(false);
                end;
            }
            action("View Settlement")
            {
                Caption = 'View Settlement';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CanViewSettlement;
                ToolTip = 'Open the existing Loan Settlement for this vehicle loan.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanSettlement: Record "Loan Settlement";
                    LoanSettlementCard: Page "Loan Settlement Card";
                begin
                    LoanSettlement.SetRange("Loan No.", Rec."No.");
                    if LoanSettlement.FindFirst() then begin
                        LoanSettlementCard.SetRecord(LoanSettlement);
                        LoanSettlementCard.Run();
                    end;
                end;
            }
        }
        area(Reporting)
        {
            action("Vehicle Loan Deed")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Vehicle Loan Deed action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Loan Deed Vehicle Loan", true, false, Rec);
                end;
            }
            action("Offer Loan")
            {
                Image = Loaner;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Offer Loan action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Offer Letter Vehicle Loan", true, false, Rec);
                end;
            }
            action("Promissory Note Vehicle Loan")
            {
                Image = Loaners;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Promissory Note Vehicle Loan action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Promissory Note Personal Loan", true, false, Rec);
                end;
            }
            action("Naamsari Vehicle Loan")
            {
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Naamsari Vehicle Loan action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Loan Deed Vehicle Loan", true, false, Rec);
                end;
            }
            action("Delivery Order Vehicle  Loan")
            {
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Delivery Order Vehicle  Loan action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Delivery Order Vehicle  Loan", true, false, Rec);
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
        SetControlAppearance;
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
        if rec."Approval Status" = rec."Approval Status"::Open then
            LoanMgt.CalculateFields(Rec);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Loan Type" := Rec."Loan Type"::"Vehicle Loan";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Loan Type" := Rec."Loan Type"::"Vehicle Loan";
    end;

    trigger OnOpenPage()
    begin
        CreateIncomingDocFromEmailAttachment := OfficeMgt.OCRAvailable;
        CreateIncomingDocumentVisible := not OfficeMgt.IsOutlookMobileApp;
        SetLayout();
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            Rec.Validate("Requested Loan Date", Today);
            Rec.Validate("Repayment Period", 1);
            Rec.Validate("Applied Loan/Advance", 0);
            Rec.Validate("Employee No.");
            Rec.Modify(true);
            RecRef.GetTable(Rec);
        end;
    end;

    var
        CreateIncomingDocumentVisible: Boolean;
        CreateIncomingDocFromEmailAttachment: Boolean;
        OfficeMgt: Codeunit "Office Management";
        HasIncomingDocument: Boolean;
        LoanMgt: Codeunit "Loan Mgt.";
        AppliedLoan: Decimal;

        ForApprove: Boolean;

        ForRecommend: Boolean;

        ForReject: Boolean;
        ForScreen: Boolean;
        ForSettle: Boolean;
        IsOpen: Boolean;
        IsPending: Boolean;
        IsApproved: Boolean;
        CanCreateSettlement, CanViewSettlement : Boolean;
        ApprovalStatusView: Boolean;
        StatusView: Boolean;
        RecRef: RecordRef;
        ApproverMgt: Codeunit "Approver Mgt";
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
                    ForScreen := true;
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
        CanCreateSettlement := IsApproved and Rec.Disbursed and not Rec.Settled and not SettlementExists(Rec."No.");
        CanViewSettlement := IsApproved and Rec.Disbursed and SettlementExists(Rec."No.");
    end;

    local procedure SettlementExists(LoanNo: Code[20]): Boolean
    var
        LoanSettlement: Record "Loan Settlement";
    begin
        LoanSettlement.SetRange("Loan No.", LoanNo);
        exit(not LoanSettlement.IsEmpty());
    end;
}
