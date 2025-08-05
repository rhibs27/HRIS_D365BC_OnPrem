table 50149 "Approval HRMS"
{
    Caption = 'Approval HRMS';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Document Type"; Enum "Employee Activity Type")
        {
            Caption = 'Document Type';
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
        }
        field(5; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
        }
        field(6; "Approval Sequence"; Integer)
        {
            Caption = 'Approval Sequence';
        }
        field(7; Cancelled; Boolean)
        {
            Caption = 'Cancelled';
        }
        field(8; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
            trigger OnValidate()
            var
                ApprovalEmployee: Record Employee;
                Employee: Record Employee;
            begin
                Employee.Reset();
                ApprovalEmployee.Reset();
                if "Approver No" = "Employee No" then
                    Error('You cannot choose your own Employee ID as Recommender.');
                if Employee.Get("Employee No") then;
                if not ApprovalEmployee.Get("Approver No") then
                    Error('Approver Not Found');
            end;
        }
        field(9; "Loan Type"; Enum "Loan Type")
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Status"; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Status Master";
        }
        field(13; "Approval Role"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Approved By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Rejected By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Document No.", "Approver No", "Employee No", "Document Type")
        {
            Clustered = true;
        }
        key(ApprovalSequence; "Approval Sequence")
        {

        }
    }
    procedure ShowRecord()
    var
        RecRef: RecordRef;
        LeaveRequest: Record Leave;
        PageManagement: Codeunit "Page Management";
    begin
        case "Document Type" of
            "Document Type"::"Leave Request":
                RecRef.GetTable(LeaveRequest);
        end;

        RecRef.SetRecFilter();
        PageManagement.PageRun(RecRef);
    end;
}