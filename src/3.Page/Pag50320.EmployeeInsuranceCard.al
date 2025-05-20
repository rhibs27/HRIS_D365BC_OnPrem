page 50320 "Employee Insurance Card"
{
    ApplicationArea = All;
    Caption = 'Employee Insurance Card';
    PageType = Card;
    InsertAllowed = false;
    SourceTable = "Employee Insurance Information";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Insurance No."; Rec."Insurance No.")
                {
                    ToolTip = 'Specifies the value of the Insurance No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Insurance Company Code"; Rec."Insurance Company Code")
                {
                    ToolTip = 'Specifies the value of the Insurance Company field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsuranceCompanyEdit;
                }
                field("Insurance Company Name"; Rec."Insurance Company Name")
                {
                    ToolTip = 'Specifies the value of the Insurance Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                // field("Life Insurance Company"; Rec."Life Insurance Company")
                // {
                //     ToolTip = 'Specifies the value of the Life Insurance Company field.', Comment = '%';
                //     ApplicationArea = All;
                //     Editable = LifeInsEdit;
                // }
                // field("Medical/Property Ins Company"; Rec."Medical/Property Ins Company")
                // {
                //     ToolTip = 'Specifies the value of the Medical/Property Ins Company field.', Comment = '%';
                //     ApplicationArea = All;
                //     Editable = NonLifeInsEdit;
                // }
                field("Policy Number"; Rec."Policy Number")
                {
                    ToolTip = 'Specifies the value of the Policy Number field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = PolicyNoEdit;
                }
                field("Insurance Start Date (AD)"; Rec."Insurance Start Date (AD)")
                {
                    ToolTip = 'Specifies the value of the Insurance Start Date (AD) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsStartDateEdit;
                }
                field("Insurance Start Date (BS)"; Rec."Insurance Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Insurance Start Date (BS) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsStartDateEdit;
                }
                field("Insurance Expiry Date (AD)"; Rec."Insurance Expiry Date (AD)")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (AD) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsEndDateEdit;
                }
                field("Insurance Expiry Date (BS)"; Rec."Insurance Expiry Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (BS) field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsEndDateEdit;
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    ToolTip = 'Specifies the value of the Insurance Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsAmountEdit;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = StatusView;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ApprovalStatusView;
                }
                field("Annual Premium Amount"; Rec."Annual Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Annual Premium Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = AnnualPremiumAmtEdit;
                }
                field("Monthly Premium Amount"; Rec."Monthly Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Monthly Premium Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsAmountEdit;
                }
                field("Linked Home Loan Account No."; Rec."Linked Home Loan Account No.")
                {
                    ToolTip = 'Specifies the value of the Linked Home Loan Account No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Home Loan TieUp"; Rec."Is Home Loan TieUp")
                {
                    ToolTip = 'Specifies the value of the Is Home Loan TieUp field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Type"; Rec."Insurance Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = InsuranceTypeEdit;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = IsPending;
                    Visible = IsPending;
                    ToolTip = 'Specifies the value of the Rejection Remarks field.', Comment = '%';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("Insurance No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
            part(Attachments; "Attachment Subform")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Insurance No.");
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Send Request")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = SendConfirmation;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Send Request action.';
                Visible = IsOpen;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to send request for this insurance?', false) then
                        exit;
                    Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                    Rec.Validate("Approval Status", Rec."Approval Status"::Pending);
                    ApproverMgt.UpdateFirstApproverStatus(Rec."Insurance No.");
                    LoanMgt.CheckInsuranceAttachment(Rec."Insurance No.", Rec."Employee No.");
                    Rec.Modify();
                    Message('Reqeust Sent');
                end;
            }
            action(Screen)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Screen action.';
                Visible = false;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to screen this insurance?', false) then
                        exit;
                    Rec.TestField("Approval Status", Rec."Approval Status"::Pending);
                    CheckPremiumInsurance(Rec."Employee No."); //Min 6.28.2022
                    Rec.Validate("Approval Status", Rec."Approval Status"::Screened);
                    Rec.Modify;
                    Message('Reqeust Screened');
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
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Rec."Rejection Remarks" := '';
                        Message('Insurance is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action("Return Request")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Return;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Return Request action.';
                Visible = false;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to return this insurance?', false) then
                        exit;
                    Rec.TestField("Approval Status", Rec."Approval Status"::Pending);
                    Rec.Validate("Approval Status", Rec."Approval Status"::Open);
                    Rec.Modify;
                    Message('Reqeust Returned');
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
                            Message('Insurance is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            // action("Reject Request")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     Image = Reject;
            //     PromotedCategory = Process;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the Reject Request action.';
            //     trigger OnAction()
            //     begin
            //         if Confirm('Do you want reject the request?', false) then
            //             Rec.Validate("Approval Status", Rec."Approval Status"::Rejected);
            //         Message('The Employee Insurance request has been rejected.');
            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    begin
        InsuranceEditControl;
    end;

    trigger OnAfterGetRecord()
    begin
        InsuranceEditControl;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    var
        Employee: Record Employee;
        LoanMgt: Codeunit "Loan Mgt.";
        InsuranceTypeEdit: Boolean;
        InsuranceCompanyEdit: Boolean;
        PolicyNoEdit: Boolean;
        InsStartDateEdit: Boolean;
        InsEndDateEdit: Boolean;
        InsAmountEdit: Boolean;
        AnnualPremiumAmtEdit: Boolean;
        LifeInsEdit: Boolean;
        NonLifeInsEdit: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        ApproverMgt: Codeunit "Approver Mgt";
        IsPending: Boolean;
        IsOpen: Boolean;
        RecRef: RecordRef;
        ApprovalMgt: Codeunit "Approver Mgt";
        HrMgt: Codeunit "HR Mgt.";



    local procedure InsuranceEditControl();
    begin
        IsPending := Rec."Approval Status" = rec."Approval Status"::Pending;
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;

        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        if Rec."Approval Status" = Rec."Approval Status"::Pending then begin
            InsuranceTypeEdit := false;
            InsuranceCompanyEdit := false;
            PolicyNoEdit := false;
            InsStartDateEdit := false;
            InsEndDateEdit := false;
            InsAmountEdit := false;
            AnnualPremiumAmtEdit := false;
        end else if Rec."Approval Status" = Rec."Approval Status"::open then begin
            InsuranceTypeEdit := true;
            InsuranceCompanyEdit := true;
            PolicyNoEdit := true;
            InsStartDateEdit := true;
            InsEndDateEdit := true;
            InsAmountEdit := true;
            AnnualPremiumAmtEdit := true;
        end else begin
            InsuranceTypeEdit := false;
            InsuranceCompanyEdit := false;
            PolicyNoEdit := false;
            InsStartDateEdit := false;
            InsEndDateEdit := false;
            InsAmountEdit := false;
            AnnualPremiumAmtEdit := false;
        end;
        if Rec."Insurance Type" = Rec."Insurance Type"::"Life Insurance" then
            LifeInsEdit := true
        else
            NonLifeInsEdit := false;
        if Rec."Insurance Type" in [Rec."Insurance Type"::"Medical Insurance", Rec."Insurance Type"::"Property Insurance"] then
            NonLifeInsEdit := true
        else
            LifeInsEdit := false;
        RecRef.GetTable(Rec);
    end;

    local procedure CheckPremiumInsurance(EmployeeNo: Code[20]);
    var
        EmployeeInsurance: Record "Employee Insurance Information";
        LifeInsuranceAmt: Decimal;
        EmpInsHealth: Record "Employee Insurance Information";
        HealthInsAmt: Decimal;
        EmpInsProperty: Record "Employee Insurance Information";
        PropertyInsAmt: Decimal;
    begin
        if Rec."Insurance Type" = Rec."Insurance Type"::"Life Insurance" then begin
            EmployeeInsurance.Reset;
            EmployeeInsurance.SetRange("Employee No.", EmployeeNo);
            EmployeeInsurance.SetRange("Approval Status", EmployeeInsurance."Approval Status"::Approved);
            EmployeeInsurance.SetRange("Insurance Type", EmployeeInsurance."Insurance Type"::"Life Insurance");
            EmployeeInsurance.CalcSums("Annual Premium Amount");
            LifeInsuranceAmt := EmployeeInsurance."Annual Premium Amount" + Rec."Annual Premium Amount";
            Employee.Get(EmployeeNo);
            Employee.Validate("Premium of Life Insurance", LifeInsuranceAmt);
            Employee.Modify;
        end;
        if Rec."Insurance Type" = Rec."Insurance Type"::"Medical Insurance" then begin
            EmpInsHealth.Reset;
            EmpInsHealth.SetRange("Employee No.", EmployeeNo);
            EmpInsHealth.SetRange("Insurance Type", EmpInsHealth."Insurance Type"::"Medical Insurance");
            EmpInsHealth.SetRange("Approval Status", EmployeeInsurance."Approval Status"::Approved);
            EmpInsHealth.CalcSums("Annual Premium Amount");
            HealthInsAmt := EmpInsHealth."Annual Premium Amount" + Rec."Annual Premium Amount";
            Employee.Get(Rec."Employee No.");
            Employee.Validate("Premium of Health Insurance", HealthInsAmt);
            Employee.Modify;
        end;
        if Rec."Insurance Type" = Rec."Insurance Type"::"Property Insurance" then begin
            EmpInsProperty.Reset;
            EmpInsProperty.SetRange("Employee No.", EmployeeNo);
            EmpInsProperty.SetRange("Insurance Type", EmpInsProperty."Insurance Type"::"Property Insurance");
            EmpInsProperty.SetRange("Approval Status", EmpInsProperty."Approval Status"::Approved);
            EmpInsProperty.CalcSums("Annual Premium Amount");
            PropertyInsAmt := EmpInsProperty."Annual Premium Amount" + Rec."Annual Premium Amount";
            Employee.Get(Rec."Employee No.");
            Employee.Validate("Premium Property Insurance", PropertyInsAmt);
            Employee.Modify;
        end;
    end;
}
