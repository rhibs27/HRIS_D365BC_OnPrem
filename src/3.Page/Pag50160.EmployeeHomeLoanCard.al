page 50160 "Employee Home Loan Card"
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
            group("Home Loan Parameters")
            {
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requested Loan Date field.';
                    ApplicationArea = All;
                }
                field("Previous Loan Amount"; Rec."Previous Loan Amount")
                {
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
                field("Take-Home Salary"; Rec."Take-Home Salary")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = Rec."Take-Home Salary" > 0;
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
                field("Loan Enhancement"; Rec."Loan Enhancement")
                {
                    ToolTip = 'Specifies the value of the Loan Enhancement field.';
                    ApplicationArea = All;
                }
                field("Approved By Board"; Rec."Approved By Board")
                {
                    ToolTip = 'Specifies the value of the Approved By Board field.';
                    ApplicationArea = All;
                }
                field("Remaining Service Period"; Rec."Remaining Service Period")
                {
                    ToolTip = 'Specifies the value of the Remaining Service Period field.';
                    ApplicationArea = All;
                }
                group(Control17)
                {
                    Editable = IsOpen;
                    ShowCaption = false;
                    field("Purpose of Housing Loan"; Rec."Purpose of Housing Loan")
                    {
                        showMandatory = true;
                        ToolTip = 'Specifies the value of the Purpose of Housing Loan field.';
                        ApplicationArea = All;
                    }
                    field("Repayment Mode"; Rec."Repayment Mode")
                    {
                        showMandatory = true;
                        ToolTip = 'Specifies the value of the Repayment Mode field.';
                        ApplicationArea = All;
                    }
                    field("Commercial Value of Property"; Rec."Commercial Value of Property")
                    {
                        ToolTip = 'Specifies the value of the Commercial Value of Property field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Estimated Cost of Construction"; Rec."Estimated Cost of Construction")
                    {
                        showMandatory = true;
                        ToolTip = 'Specifies the value of the Estimated Cost of Construction field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Repayment Period"; Rec."Repayment Period")
                    {
                        showMandatory = true;
                        ToolTip = 'Specifies the value of the Repayment Period field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Insurance Tieup"; Rec."Insurance Tieup")
                    {
                        ToolTip = 'Specifies the value of the Insurance Tieup field.';
                        ApplicationArea = All;
                    }
                    field("Insurance Company Code"; rec."Insurance Company Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Name of Insurance Company"; rec."Name of Insurance Company")
                    {
                        ApplicationArea = all;
                    }
                    field("Applied Loan"; Rec."Applied Loan/Advance")
                    {
                        showMandatory = true;
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
                }
            }
            group("Collateral Information")
            {
                Editable = IsOpen;
                field("Complete Address of Property"; Rec."Complete Address of Property")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Complete Address of Property field.';
                    ApplicationArea = All;
                }
                field("Plot No. of Property"; Rec."Plot No. of Property")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Plot No. of Property field.';
                    ApplicationArea = All;
                }
                field("Area Format"; Rec."Area Format")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Area Format field.';
                    ApplicationArea = All;
                }
                field("Area of Plot"; Rec."Area of Plot")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Area of Plot field.';
                    ApplicationArea = All;
                }
                field("Area of Property to be Purchased"; rec."Area of Propty. tobe Purchased")
                {
                    Caption = 'Area of Property to be Purchased';
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Area of Property to be Purchased.';
                    ApplicationArea = All;
                }
                field("Existing Owner of the Property"; Rec."Name of Owner")
                {
                    Caption = 'Existing Owner of the Property';
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Name of Owner field.';
                    ApplicationArea = All;
                }
                field("Proposed Owner Name(Nepali)"; Rec."Proposed Owner (Nepali)")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Proposed Owner (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Address of Property (Nepali)"; Rec."Address of Property (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Address of Property (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Address of Existing Owner"; Rec."Address of Owner")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Address of Owner field.';
                    ApplicationArea = All;
                }
                field("Property in the name of"; Rec."Property in the name of")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Name of Proposed Owner field.';
                    ApplicationArea = All;
                }
                field("Name of Spouse"; Rec."Name of Spouse")
                {
                    showMandatory = true;
                    ToolTip = 'Specifies the value of the Name of Spouse field.';
                    ApplicationArea = All;
                }
            }
            group("Security Documentation")
            {
                Visible = Rec."Approval Status" = Rec."Approval Status"::Approved;
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
                field("Offer Letter Date(Nepali)"; Rec."Offer Letter Date(Nepali)")
                {
                    ToolTip = 'Specifies the value of the Offer Letter Date(Nepali) field.';
                    ApplicationArea = All;
                }
                field("Amount In Words (Nepali)"; rec."Amount In Words (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Amount In Words (Nepali) field.';
                    ApplicationArea = All;
                }
                field("Loan Expiry Date"; Rec."Loan Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Loan Expiry Date field.';
                    ApplicationArea = All;
                }
                field("Loan Expiry Date( Nepali)"; Rec."Loan Expiry Date( Nepali)")
                {
                    ToolTip = 'Specifies the value of the Loan Expiry Date( Nepali) field.';
                    ApplicationArea = All;
                }
            }
            group("Facility Disbursement")
            {
                Visible = IsApproved;
                field("Loan Applied"; Rec."Applied Loan/Advance")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Applied Loan field.';
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
                field("Total Settled Amount"; Rec."Total Settled Amount")
                {
                    Caption = 'Total Settled Amount';
                    Editable = false;
                    ToolTip = 'Specifies the cumulative amount settled across all approved settlement entries.';
                    ApplicationArea = All;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    Editable = false;
                    ToolTip = 'Specifies the remaining loan balance (Disbursed Amount minus Total Settled Amount).';
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
                field("Settlement Type"; rec."Settlement Type")
                {
                    ToolTip = 'Specifies the value of the Settlement type field.';
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
                    // LoanMgt.VerifyLoan(Rec);
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
                        Message('Home Loan is Approved by %1', HRMgt.GetEmpName());
                        Clear(Rec."Rejection Remark");
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
                            Message('Home Loan is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action("Settle Home Loan")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Settle Home Loan action.';
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
            action("Update Insurance")
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Update Insurance action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRMgt.UpdateInsuranceFromHomeLoan(Rec);
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
                ToolTip = 'Initiate a Loan Settlement request for this disbursed loan.';
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
                Caption = 'View Settlements';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CanViewSettlement;
                ToolTip = 'Open all Loan Settlement requests for this loan.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanSettlement: Record "Loan Settlement";
                    LoanSettlementList: Page "Loan Settlement List";
                begin
                    LoanSettlement.SetRange("Loan No.", Rec."No.");
                    LoanSettlementList.SetTableView(LoanSettlement);
                    LoanSettlementList.Run();
                end;
            }
            action("Settlement Entries")
            {
                Caption = 'Settlement Entries';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'View the full history of posted settlement entries for this loan.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanSettlementEntry: Record "Loan Settlement Entry";
                    LoanSettlementEntries: Page "Loan Settlement Entries";
                begin
                    LoanSettlementEntry.SetRange("Loan No.", Rec."No.");
                    LoanSettlementEntries.SetTableView(LoanSettlementEntry);
                    LoanSettlementEntries.Run();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetLayout();
        if rec."Approval Status" = rec."Approval Status"::Open then
            LoanMgt.CalculateFields(Rec);
        Rec.CalcFields("Total Settled Amount");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Loan Type" := Rec."Loan Type"::"Home Loan";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec."Loan Type" := Rec."Loan Type"::"Home Loan";
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            Rec.Validate("Requested Loan Date", Today);
            Rec.Validate("Repayment Period", 1);
            Rec.Validate("Applied Loan/Advance", 0);
            Rec.Validate("Employee No.");
            Rec.Modify(true);
        end;
        RecRef.GetTable(Rec);
    end;

    var
        IsOpen, IsPending, IsApproved : Boolean;
        CanCreateSettlement, CanViewSettlement : Boolean;
        HasIncomingDocument: Boolean;
        LoanMgt: Codeunit "Loan Mgt.";
        StatusView: Boolean;
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalStatusView: Boolean;
        RecRef: RecordRef;
        HRMgt: Codeunit "HR Mgt.";


    local procedure SetLayout()
    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        // Allow creating a new settlement only if no active (Open/Pending) settlement exists
        CanCreateSettlement := IsApproved and Rec.Disbursed and not Rec.Settled and not ActiveSettlementExists(Rec."No.");
        // Allow viewing settlement history if any settlement (past or active) exists
        CanViewSettlement := IsApproved and Rec.Disbursed and SettlementExists(Rec."No.");
    end;

    local procedure SettlementExists(LoanNo: Code[20]): Boolean
    var
        LoanSettlement: Record "Loan Settlement";
    begin
        LoanSettlement.SetRange("Loan No.", LoanNo);
        exit(not LoanSettlement.IsEmpty());
    end;

    local procedure ActiveSettlementExists(LoanNo: Code[20]): Boolean
    var
        LoanSettlement: Record "Loan Settlement";
    begin
        LoanSettlement.SetRange("Loan No.", LoanNo);
        LoanSettlement.SetFilter("Approval Status", '%1|%2',
            LoanSettlement."Approval Status"::Open,
            LoanSettlement."Approval Status"::Pending);
        exit(not LoanSettlement.IsEmpty());
    end;
}
