page 33020130 "Employee Insurance Card"
{
    ApplicationArea = All;
    Caption = 'Employee Insurance Card';
    PageType = Card;
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
                }
                field("Insurance Company"; Rec."Insurance Company")
                {
                    ToolTip = 'Specifies the value of the Insurance Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Life Insurance Company"; Rec."Life Insurance Company")
                {
                    ToolTip = 'Specifies the value of the Life Insurance Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Medical/Property Ins Company"; Rec."Medical/Property Ins Company")
                {
                    ToolTip = 'Specifies the value of the Medical/Property Ins Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Policy Number"; Rec."Policy Number")
                {
                    ToolTip = 'Specifies the value of the Policy Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Start Date (AD)"; Rec."Insurance Start Date (AD)")
                {
                    ToolTip = 'Specifies the value of the Insurance Start Date (AD) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Start Date (BS)"; Rec."Insurance Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Insurance Start Date (BS) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date (AD)"; Rec."Insurance Expiry Date (AD)")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (AD) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date (BS)"; Rec."Insurance Expiry Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (BS) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    ToolTip = 'Specifies the value of the Insurance Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Annual Premium Amount"; Rec."Annual Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Annual Premium Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Monthly Premium Amount"; Rec."Monthly Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Monthly Premium Amount field.', Comment = '%';
                    ApplicationArea = All;
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
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    ApplicationArea = All;
                }
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
                trigger OnAction()
                begin
                    if not Confirm('Do you want to send request for this insurance?', false) then
                        exit;
                    Rec.TestField(Status, Rec.Status::Open);
                    Rec.Validate(Status, Rec.Status::Pending);
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
                trigger OnAction()
                begin
                    if not Confirm('Do you want to screen this insurance?', false) then
                        exit;
                    Rec.TestField(Status, Rec.Status::Pending);
                    CheckPremiumInsurance(Rec."Employee No."); //Min 6.28.2022
                    Rec.Validate(Status, Rec.Status::Screened);
                    Rec.Modify;
                    Message('Reqeust Screened');
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
                trigger OnAction()
                begin
                    if not Confirm('Do you want to return this insurance?', false) then
                        exit;
                    Rec.TestField(Status, Rec.Status::Pending);
                    Rec.Validate(Status, Rec.Status::Open);
                    Rec.Modify;
                    Message('Reqeust Returned');
                end;
            }
            action("Reject Request")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Reject;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Request action.';
                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then
                        Rec.Validate(Status, Rec.Status::Rejected);
                    Message('The Employee Insurance request has been rejected.');
                end;
            }
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
        Rec.Status := Rec.Status::Open;
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

    local procedure InsuranceEditControl();
    begin
        if Rec.Status = Rec.Status::Pending then begin
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
        if Rec.Type = Rec.Type::"Life Insurance" then
            LifeInsEdit := true
        else
            NonLifeInsEdit := false;
        if Rec.Type in [Rec.Type::"Medical Insurance", Rec.Type::"Property Insurance"] then
            NonLifeInsEdit := true
        else
            LifeInsEdit := false;
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
        if Rec.Type = Rec.Type::"Life Insurance" then begin
            EmployeeInsurance.Reset;
            EmployeeInsurance.SetRange("Employee No.", EmployeeNo);
            EmployeeInsurance.SetRange(Status, EmployeeInsurance.Status::Screened);
            EmployeeInsurance.SetRange(Type, EmployeeInsurance.Type::"Life Insurance");
            EmployeeInsurance.CalcSums("Annual Premium Amount");
            LifeInsuranceAmt := EmployeeInsurance."Annual Premium Amount" + Rec."Annual Premium Amount";
            Employee.Get();
            Employee.Validate("Premium of Life Insurance", LifeInsuranceAmt);
            Employee.Modify;
        end;
        if Rec.Type = Rec.Type::"Medical Insurance" then begin
            EmpInsHealth.Reset;
            EmpInsHealth.SetRange("Employee No.", EmployeeNo);
            EmpInsHealth.SetRange(Type, EmpInsHealth.Type::"Medical Insurance");
            EmpInsHealth.SetRange(Status, EmployeeInsurance.Status::Screened);
            EmpInsHealth.CalcSums("Annual Premium Amount");
            HealthInsAmt := EmpInsHealth."Annual Premium Amount" + Rec."Annual Premium Amount";
            Employee.Get(Rec."Employee No.");
            Employee.Validate("Premium of Health Insurance", HealthInsAmt);
            Employee.Modify;
        end;
        if Rec.Type = Rec.Type::"Property Insurance" then begin
            EmpInsProperty.Reset;
            EmpInsProperty.SetRange("Employee No.", EmployeeNo);
            EmpInsProperty.SetRange(Type, EmpInsProperty.Type::"Property Insurance");
            EmpInsProperty.SetRange(Status, EmpInsProperty.Status::Screened);
            EmpInsProperty.CalcSums("Annual Premium Amount");
            PropertyInsAmt := EmpInsProperty."Annual Premium Amount" + Rec."Annual Premium Amount";
            Employee.Get(Rec."Employee No.");
            Employee.Validate("Premium Property Insurance", PropertyInsAmt);
            Employee.Modify;
        end;
    end;
}
