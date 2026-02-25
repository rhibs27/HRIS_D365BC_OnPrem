table 50135 "Encashment Request"
{
    //LEAVE ENCASHMENT,  OTHER ENCASHMENT CAN BE ADDED AS PER NEEDED...
    Caption = 'Encashment Request';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(4; "Leave Code"; Code[20])
        {
            Caption = 'Leave Code';
            TableRelation = "Leave Type Setup";
            trigger OnValidate()
            begin
                if LeaveTypeSetup.Get("Leave Code") then
                    "Leave Description" := LeaveTypeSetup.Description
                else
                    "Leave Description" := '';
            end;
        }
        field(5; "Leave Description"; Text[50])
        {
            Caption = 'Leave Description';
        }
        field(6; "No. of Days"; Decimal)
        {
            Caption = 'No. of Days';
            trigger OnValidate()
            begin
                if ("No. of Days" <> 0) and ("Leave Code" <> '') and ("Employee No." <> '') then
                    ValidateNoOfDays("Employee No.", "Leave Code", "No. of Days");
            end;
        }
        field(7; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(9; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then
                    "Employee Name" := Employee.FullName()
                else
                    "Employee Name" := '';
            end;
        }
        field(10; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; Remarks; text[250]) { }
        field(12; "Rejection Remarks"; Text[250]) { }
        field(14; "Cancelled Document No."; Code[20]) { }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }
        field(37; "Approved Date"; Date) { }
        field(39; Cancelled; Boolean) { }
        field(100; "Status"; Text[20]) { }
        field(101; "Cancellation Remarks"; Text[250]) { }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        EncashmentRequest: Record "Encashment Request";
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
        if "Employee No." = '' then
            if not HrMgt.IsSaaS() then
                Validate("Employee No.", HrMgt.GetEmployeeNo());
        if not GuiAllowed then
            Validate("Approval Status", "Approval Status"::Pending);
        TestField(Type);
        HRSetup.Get;
        if "No." = '' then begin
            case Type of
                Type::"Leave Encashment":
                    begin
                        HRSetup.TestField("Leave Encashment Nos.");
                        HRMgt.InitNoSeriesNew(HRSetup."Leave Encashment Nos.", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        EncashmentRequest.ReadIsolation(IsolationLevel::ReadUncommitted);
                        EncashmentRequest.SetLoadFields("No.");
                        while EncashmentRequest.Get("No.") do
                            "No." := NoSeries.GetNextNo("No. Series");
                        if "Approval Status" <> "Approval Status"::Approved then
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");
                    end;
            end;
        end;
    end;

    trigger OnDelete()
    begin
        Rec.TestField("Approval Status", "Approval Status"::Open);
    end;

    var
        HrSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        LeaveTypeSetup: Record "Leave Type Setup";
        NoSeries: Codeunit "No. Series";
        HRMgt: Codeunit "HR Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";

    procedure OnbeforeSendForApproval()
    begin
        TestField("Employee No.");
        TestField("Leave Code");
        TestField("No. of Days");
        ValidateNoOfDays("Employee No.", "Leave Code", "No. of Days");
    end;

    procedure ValidateNoOfDays(EmployeeNo: Code[20]; LeaveCode: Code[20]; NoOfDays: Decimal)
    var
        LeaveTypeSetup: Record "Leave Type Setup";
    begin
        if (NoOfDays <> 0) and (LeaveCode <> '') and (EmployeeNo <> '') then begin
            LeaveTypeSetup.SetRange(Code, LeaveCode);
            LeaveTypeSetup.SetFilter("Employee No. Filter", EmployeeNo);
            LeaveTypeSetup.SetFilter("Date Filter", '..%1', WorkDate);
            if LeaveTypeSetup.FindFirst() then begin
                LeaveTypeSetup.calcFields("Remaining Days");
                if NoOfDays > LeaveTypeSetup."Remaining Days" then
                    Error('No of days can not exceed the leave balance %1', LeaveTypeSetup."Remaining Days");
            end;
        end;
    end;
}
