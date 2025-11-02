table 50149 "Approval HRMS"
{
    Caption = 'Approval HRMS';
    DrillDownPageId = "Request to Approve HRIS";
    LookupPageId = "Request to Approve HRIS";
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
        EmployeeEdit: Record "Employee Edit";
        MissedAttendance: Record "Attendance Missed";
        Travel: Record "Travel Request";
        Transfer, TransferClaim : Record "Employee Transfer";
        OT: Record OverTime;
        RetirementFund: Record "Retirement Fund";
        AllowanceAssignment: Record "Allowance Assignment Header";
        CancelDocument: Record "Cancel Document";
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        EmpActjournal: Record "Employee Activity Journal";
        ShiftAssignment: Record "Shift Assignment Header";
        EncashmentRequest: Record "Encashment Request";
        Insurance: Record "Employee Insurance Information";
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        case "Document Type" of
            "Document Type"::"Leave Request":
                if LeaveRequest.Get("Document No.") then
                    RecRef.GetTable(LeaveRequest);
            "Document Type"::"Employee Edit":
                if EmployeeEdit.Get("Document No.") then
                    RecRef.GetTable(EmployeeEdit);
            "Document Type"::"Attendance Missed", "Document Type"::"Late Attendance":
                if MissedAttendance.Get("Document No.") then
                    RecRef.GetTable(MissedAttendance);
            "Document Type"::"Travel Request":
                if Travel.Get("Document No.") then
                    RecRef.GetTable(Travel);
            "Document Type"::"Employee Transfer", "Document Type"::"Transfer Claim":
                if Transfer.Get("Document No.") then
                    RecRef.GetTable(Transfer);
            "Document Type"::Overtime, "Document Type"::"Overtime Bulk":
                if OT.Get("Document No.") then
                    RecRef.GetTable(OT);
            "Document Type"::"Allowance Assignment", "Document Type"::"Allowance Assignment Claim":
                if AllowanceAssignment.Get("Document No.") then
                    RecRef.GetTable(AllowanceAssignment);
            "Document Type"::Retirement:
                if RetirementFund.Get("Document No.") then
                    RecRef.GetTable(RetirementFund);
            "Document Type"::"Cancel Document":
                if CancelDocument.Get("Document No.") then
                    RecRef.GetTable(CancelDocument);
            "Document Type"::Loan:
                if EmployeeLoanAdvance.Get("Document No.") then
                    RecRef.GetTable(EmployeeLoanAdvance);
            "Document Type"::"Employee Journal":
                begin
                    EmpActjournal.SetRange(Type, "Document Type");
                    EmpActjournal.SetRange("Document No", "Document No.");
                    if EmpActjournal.FindSet() then
                        RecRef.GetTable(EmpActjournal);
                end;
            "Document Type"::"Shift Assignment":
                if ShiftAssignment.Get("Document No.") then
                    RecRef.GetTable(ShiftAssignment);
            "Document Type"::"Leave Encashment":
                if EncashmentRequest.Get("Document No.") then
                    RecRef.GetTable(EncashmentRequest);
            "Document Type"::Insurance:
                if Insurance.Get("Document No.") then
                    RecRef.GetTable(Insurance);
            "Document Type"::"Allowance Assignment Memo", "Document Type"::"Request Allowance":
                if AssignmentMemoHdr.Get("Document No.") then
                    RecRef.GetTable(AssignmentMemoHdr);
        end;

        RecRef.SetRecFilter();
        PageManagement.PageRun(RecRef);
    end;

    procedure ApproveRecord()
    var
        RecRef: RecordRef;
        LeaveRequest: Record Leave;
        EmployeeEdit: Record "Employee Edit";
        MissedAttendance: Record "Attendance Missed";
        Travel: Record "Travel Request";
        Transfer: Record "Employee Transfer";
        OT: Record OverTime;
        RetirementFund: Record "Retirement Fund";
        AllowanceAssignment: Record "Allowance Assignment Header";
        CancelDocument: Record "Cancel Document";
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        EmpActjournal: Record "Employee Activity Journal";
        ShiftAssignment: Record "Shift Assignment Header";
        ApproverMgt: Codeunit "Approver Mgt";
        EncashmentRequest: Record "Encashment Request";
        Insurance: Record "Employee Insurance Information";
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        case "Document Type" of
            "Document Type"::"Leave Request":
                if LeaveRequest.Get("Document No.") then
                    RecRef.GetTable(LeaveRequest);
            "Document Type"::"Employee Edit":
                if EmployeeEdit.Get("Document No.") then
                    RecRef.GetTable(EmployeeEdit);
            "Document Type"::"Attendance Missed", "Document Type"::"Late Attendance":
                if MissedAttendance.Get("Document No.") then
                    RecRef.GetTable(MissedAttendance);
            "Document Type"::"Travel Request":
                if Travel.Get("Document No.") then
                    RecRef.GetTable(Travel);
            "Document Type"::"Employee Transfer", "Document Type"::"Transfer Claim":
                if Transfer.Get("Document No.") then
                    RecRef.GetTable(Transfer);
            "Document Type"::Overtime:
                if OT.Get("Document No.") then
                    RecRef.GetTable(OT);
            "Document Type"::"Allowance Assignment", "Document Type"::"Allowance Assignment Claim":
                if AllowanceAssignment.Get("Document No.") then
                    RecRef.GetTable(AllowanceAssignment);
            "Document Type"::Retirement:
                if RetirementFund.Get("Document No.") then
                    RecRef.GetTable(RetirementFund);
            "Document Type"::"Cancel Document":
                if CancelDocument.Get("Document No.") then
                    RecRef.GetTable(CancelDocument);
            "Document Type"::Loan:
                if EmployeeLoanAdvance.Get("Document No.") then
                    RecRef.GetTable(EmployeeLoanAdvance);
            "Document Type"::"Employee Journal":
                begin
                    EmpActjournal.SetRange(Type, "Document Type");
                    EmpActjournal.SetRange("Document No", "Document No.");
                    if EmpActjournal.FindSet() then
                        RecRef.GetTable(EmpActjournal);
                end;
            "Document Type"::"Shift Assignment":
                if ShiftAssignment.Get("Document No.") then
                    RecRef.GetTable(ShiftAssignment);
            "Document Type"::"Leave Encashment":
                if EncashmentRequest.Get("Document No.") then
                    RecRef.GetTable(EncashmentRequest);
            "Document Type"::Insurance:
                if Insurance.Get("Document No.") then
                    RecRef.GetTable(Insurance);
            "Document Type"::"Allowance Assignment Memo", "Document Type"::"Request Allowance":
                if AssignmentMemoHdr.Get("Document No.") then
                    RecRef.GetTable(AssignmentMemoHdr);
        end;
        ApproverMgt.ApproveRejectDocument(RecRef, true);
    end;

    procedure RejectRecord()
    var
        RecRef: RecordRef;
        LeaveRequest: Record Leave;
        EmployeeEdit: Record "Employee Edit";
        MissedAttendance: Record "Attendance Missed";
        Travel: Record "Travel Request";
        Transfer, TransferClaim : Record "Employee Transfer";
        OT: Record OverTime;
        RetirementFund: Record "Retirement Fund";
        AllowanceAssignment: Record "Allowance Assignment Header";
        CancelDocument: Record "Cancel Document";
        EmployeeLoanAdvance: Record "Employee Loan/Advance";
        EmpActjournal: Record "Employee Activity Journal";
        ShiftAssignment: Record "Shift Assignment Header";
        ApproverMgt: Codeunit "Approver Mgt";
        EncashmentRequest: Record "Encashment Request";
        Insurance: Record "Employee Insurance Information";
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        case "Document Type" of
            "Document Type"::"Leave Request":
                if LeaveRequest.Get("Document No.") then
                    RecRef.GetTable(LeaveRequest);
            "Document Type"::"Employee Edit":
                if EmployeeEdit.Get("Document No.") then
                    RecRef.GetTable(EmployeeEdit);
            "Document Type"::"Attendance Missed", "Document Type"::"Late Attendance":
                if MissedAttendance.Get("Document No.") then
                    RecRef.GetTable(MissedAttendance);
            "Document Type"::"Travel Request":
                if Travel.Get("Document No.") then
                    RecRef.GetTable(Travel);
            "Document Type"::"Employee Transfer":
                if Transfer.Get("Document No.") then
                    RecRef.GetTable(Transfer);
            "Document Type"::"Transfer Claim":
                if TransferClaim.Get("Document No.") then
                    RecRef.GetTable(Transfer);
            "Document Type"::Overtime:
                if OT.Get("Document No.") then
                    RecRef.GetTable(OT);
            "Document Type"::"Allowance Assignment", "Document Type"::"Allowance Assignment Claim":
                if AllowanceAssignment.Get("Document No.") then
                    RecRef.GetTable(AllowanceAssignment);
            "Document Type"::Retirement:
                if RetirementFund.Get("Document No.") then
                    RecRef.GetTable(RetirementFund);
            "Document Type"::"Cancel Document":
                if CancelDocument.Get("Document No.") then
                    RecRef.GetTable(CancelDocument);
            "Document Type"::Loan:
                if EmployeeLoanAdvance.Get("Document No.") then
                    RecRef.GetTable(EmployeeLoanAdvance);
            "Document Type"::"Employee Journal":
                begin
                    EmpActjournal.SetRange(Type, "Document Type");
                    EmpActjournal.SetRange("Document No", "Document No.");
                    if EmpActjournal.FindSet() then
                        RecRef.GetTable(EmpActjournal);
                end;
            "Document Type"::"Shift Assignment":
                if ShiftAssignment.Get("Document No.") then
                    RecRef.GetTable(ShiftAssignment);
            "Document Type"::"Leave Encashment":
                if EncashmentRequest.Get("Document No.") then
                    RecRef.GetTable(EncashmentRequest);
            "Document Type"::Insurance:
                if Insurance.Get("Document No.") then
                    RecRef.GetTable(Insurance);
            "Document Type"::"Allowance Assignment Memo", "Document Type"::"Request Allowance":
                if AssignmentMemoHdr.Get("Document No.") then
                    RecRef.GetTable(AssignmentMemoHdr);
        end;
        ApproverMgt.ApproveRejectDocument(RecRef, false);
    end;
}