table 50185 "Loan Settlement"
{
    DataCaptionFields = "No.", "Employee No.", "Employee Name";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                HRSetup.Get();
                if "No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(HRSetup."Loan Settlement No.");
                    "No. Series" := '';
                end;
            end;
        }

        field(2; Type; Enum "Employee Activity Type")
        {
            Editable = false;
        }
        field(3; "Loan No."; Code[20])
        {
            TableRelation = "Employee Loan/Advance";

            trigger OnValidate()
            var
                EmpLoan: Record "Employee Loan/Advance";
                loanMgt: Codeunit "Loan Mgt.";
            begin
                if EmpLoan.Get("Loan No.") then begin
                    if not (EmpLoan."Approval Status" = EmpLoan."Approval Status"::Approved) then
                        Error('Settlement can only be created for Approved and Disbursed loans.');
                    if not EmpLoan.Disbursed then
                        Error('Settlement can only be created for disbursed loans.');
                    if EmpLoan.Settled then
                        Error('This loan is already settled.');
                    "Loan Type" := EmpLoan."Loan Type";
                    Validate("Employee No.", EmpLoan."Employee No.");
                    "Disbursed Amount" := EmpLoan."Disbursed Amount";
                    "Total Approved Amount" := EmpLoan."Applied Loan/Advance";
                    "Outstanding Amount" := loanMgt.GetLoanOutstandingAmount("Loan No.");
                    "Branch Code" := EmpLoan."Branch Code";
                    "Branch Name" := EmpLoan."Branch Name";
                    "Department Code" := EmpLoan."Department Code";
                    "Department Name" := EmpLoan."Department Name";
                    "Unit Code" := EmpLoan."Unit Code";
                    "Unit Name" := EmpLoan."Unit Name";
                end;
            end;
        }
        field(4; "Loan Type"; Enum "Loan Type")
        {
            Editable = false;
        }
        field(5; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            Editable = false;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then begin
                    "Employee Name" := Employee.FullName();
                    "Functional Title Code" := Employee."Functional Title";
                    "Functional Title Description" := Employee."Functional Title Desc";
                    "Salary Account Number" := Employee."Bank Account No.";
                end;
            end;
        }
        field(6; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(7; "Settlement Request Date"; Date)
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Settlement Request Date"));
            end;
        }
        field(8; "Disbursed Amount"; Decimal)
        {
            Editable = false;
        }
        field(9; "Outstanding Amount"; Decimal)
        {
            Editable = false;
        }
        field(10; "Settlement Amount"; Decimal) { }
        field(11; Remarks; Text[250]) { }
        field(12; "Rejection Remark"; Text[150]) { }
        field(13; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Settled Date"; Date)
        {
            Editable = false;
        }
        field(15; "Settler User ID"; Code[50])
        {
            Editable = false;
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }
        field(17; "Fiscal Year"; Code[20]) { }
        field(18; "Settlement Type"; Enum "Settlement Type") { }

        field(19; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
            Editable = false;
        }
        field(20; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(21; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
            Editable = false;
        }
        field(22; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(23; "Unit Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Unit));
            Editable = false;
        }
        field(24; "Unit Name"; Text[50])
        {
            Editable = false;
        }
        field(25; "Functional Title Code"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(26; "Functional Title Description"; Text[100]) { Editable = false; }
        field(27; "Salary Account Number"; Text[50])
        {
        }
        field(28; "Total Approved Amount"; Decimal) { Editable = false; }
        field(100; "Status"; Text[20]) { }
    }

    keys
    {
        key(Key1; "No.") { Clustered = true; }
        key(Key2; "Employee No.", "Loan Type", "Loan No.") { }
        key(Key3; "Loan No.") { }
    }

    trigger OnInsert()
    var
        LoanSettlement: Record "Loan Settlement";
    begin
        Validate(Type, Type::"Loan Settlement");
        HRSetup.Get();
        if "No." = '' then begin
            Validate("Approval Status", "Approval Status"::Open);
            Validate("Settlement Request Date", Today);
            HRSetup.TestField("Loan Settlement No.");
            HRMgt.InitNoSeriesNew(HRSetup."Loan Settlement No.", xRec."No. Series", "Settlement Request Date", "No.", "No. Series");
            LoanSettlement.ReadIsolation(IsolationLevel::ReadUncommitted);
            LoanSettlement.SetLoadFields("No.");
            while LoanSettlement.Get("No.") do
                "No." := NoSeriesMgt.GetNextNo("No. Series");

            ApproverMgt.InsertApprovalLoan("Employee No.", "No.", Type, "Loan Type");

            if "Approval Status" = "Approval Status"::Open then
                loanMgt.InsertSettelmentAttachmentLines(rec);
        end;
    end;

    trigger OnDelete()
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error('Cannot delete a settlement that is not in Open status.');
        incomingAttachmentDoc.Reset();
        incomingAttachmentDoc.SetRange("No.", "No.");
        incomingAttachmentDoc.DeleteAll();
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        ApprovalEntry.DeleteAll();
    end;

    var
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        NoSeriesMgt: Codeunit "No. Series";
        ApproverMgt: Codeunit "Approver Mgt";
        loanMgt: Codeunit "Loan Mgt.";
        ApprovalEntry: Record "Approval HRMS";
        incomingAttachmentDoc: Record "Incoming Document";
}
