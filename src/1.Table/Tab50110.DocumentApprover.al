table 50110 "Document Approver"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                EmpRec.Get("Employee No.");
                Validate("Employee Name", EmpRec."Full Name");
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(5; Remarks; Text[250])
        {
            trigger OnValidate()
            begin
                UpdateApprovalStatus();
            end;
        }
        field(6; "Approval Status"; enum "Approval Status")
        {
            trigger OnValidate()
            begin
                UpdateApprovalStatus();
            end;
        }
        field(7; "Functional Title"; Code[20])
        {
            Editable = false;
        }
        field(8; "Approved Date"; Date) { }
        field(9; "Employee Type"; Enum "Document Approver Emp. Type")
        {
            trigger OnValidate()
            begin
                if "Employee Type" = "Employee Type"::"Initiated By" then
                    if "Employee No." = '' then
                        if not HrMgt.IsSaaS() then
                            Validate("Employee No.", HRMgt.GetEmployeeNo());
            end;
        }
        field(10; "Document Type"; Enum "Document Approver Doc. Type")
        {
        }
        field(11; "Rejection Remarks"; Text[250]) { }
    }
    keys
    {
        key(Key1; "Document No.", "Line No.") { }
    }
    fieldgroups { }
    trigger OnInsert()
    begin
        GetLineNo();
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        EmpRec: Record Employee;

    local procedure GetLineNo()
    var
        ResignationApprover: Record "Document Approver";
    begin
        ResignationApprover.Reset;
        ResignationApprover.SetCurrentKey("Line No.");
        ResignationApprover.SetRange("Document No.", "Document No.");
        if ResignationApprover.FindLast then
            "Line No." := ResignationApprover."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    local procedure UpdateApprovalStatus()
    begin
        UpdateApprovalStatus(HRMgt.GetEmployeeNo());
    end;

    local procedure UpdateApprovalStatus(empno: code[20])
    var
        Unauthorized: Label 'Not authorized.';
    begin
        if GuiAllowed then
            if "Employee No." <> HRMgt.GetEmployeeNo() then
                Error(Unauthorized);
        IF "Approval Status" = "Approval Status"::Approved THEN
            Validate("Approved Date", Today);
    end;
}
