table 50149 "Approval HRMS"
{
    Caption = 'Approval HRMS';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(2; "Document Type"; Enum "Employee Activity Type")
        {
            Caption = 'Document Type';
            Editable = false;
        }
        field(3; "Approver No"; Code[20])
        {
            Caption = 'Approver No';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if "Approver No" <> xRec."Approver No" then
                    Clear("Approver Name");
                if Employee.get("Approver No") then
                    Validate("Approver Name", Employee."Full Name");
            end;
        }
        field(4; "Approver Name"; Text[100])
        {
            Caption = 'Approver Name';
            Editable = false;
        }
        field(5; "Approval Status"; Enum "Employee Act. Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;
        }
        field(6; "Approval Sequence"; Integer)
        {
            Caption = 'Approval Sequence';
        }
        field(8; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
            Editable = false;
            trigger OnValidate()
            var
                ApprovalEmployee: Record Employee;
                Employee: Record Employee;
                ApprovalSalaryLevel: Record "Salary Level";
                SalaryLevel: Record "Salary Level";
            begin
                Employee.Reset();
                ApprovalEmployee.Reset();
                SalaryLevel.Reset();
                ApprovalSalaryLevel.Reset();
                if "Approver No" = "Employee No" then
                    Error('You cannot choose your own Employee ID as Recommender.');
                if Employee.Get("Employee No") then;
                if ApprovalEmployee.Get("Approver No") then;
                if SalaryLevel.Get(Employee."Salary Level") then;
                if ApprovalSalaryLevel.Get(ApprovalEmployee."Salary Level") then;
                if SalaryLevel.Rank >= ApprovalSalaryLevel.Rank then
                    Error('Salary level of Approver (%1) must be greater than salary level of employee (%2)', ApprovalEmployee."Full Name", Employee."Full Name")
            end;
        }
    }

    keys
    {
        key(PK; "Document No.", "Approver No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        Approval: Record "Approval HRMS";
    begin
        // Approval.Reset();
        // if Approval.FindLast() then
        //     "Entry No." := Approval."Entry No." + 1
        // else
        //     "Entry No." := 1;
    end;
}