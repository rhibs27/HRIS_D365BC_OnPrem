table 50153 "Cancel Document"
{
    Caption = 'Cancel Document';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    if Cancelled then begin
                        NoSeriesMgt.TestManual(HRSetup."Cancel Document No. Series");
                        "No. Series" := '';
                    end else begin
                        case Type of
                            //attendance missed
                            Type::"Attendance Missed":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Attendance Missed No.");
                                    "No. Series" := '';
                                end;
                        end;
                    end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type")
        {
            Editable = false;
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            Editable = false;
            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Branch Code", EmpVar."Branch Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Deputation On", EmpVar."Deputation on");
                    Validate("Deputation On Code", EmpVar."Deputation On Code");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Province Name", EmpVar."Province Name");
                end else begin
                    Clear("Employee Name");
                    Validate("Branch Code", '');
                    Validate(Department, '');
                    Validate("Salary Level Code", '');
                end;
                if Type = Type::"Attendance Missed" then begin
                end;
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(5; Posted; Boolean) { }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Start Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin

                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Start Date");
                if EngNepDate.FindFirst then
                    Validate("Start Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Start Date (BS)");
                if "Start Date" <> xRec."Start Date" then begin
                    Clear("End Date");
                    Clear("End Date (BS)");
                    Validate("No. of Days", 0);
                end;
            end;
        }
        field(8; "End Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            var
                DateError: Label 'Start Date (%1) must be less than End Date (%2).';
            begin
                if "Start Date" > "End Date" then
                    Error(DateError, "Start Date", "End Date");
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "End Date");
                if EngNepDate.FindFirst then
                    Validate("End Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("End Date (BS)");
                //>>Calculate No. of Days Santosh
                if "End Date" <> 0D then
                    Validate("No. of Days", "End Date" - "Start Date" + 1)
                else begin
                    Clear("End Date (BS)");
                    Clear("No. of Days");
                end;
            end;
        }
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(10; "Requested Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Requested Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year")
                else
                    Clear("Fiscal Year");
            end;
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(12; "Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(13; "End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[250])
        {
            trigger OnValidate()
            begin
                Clear("Rejection Remarks");
            end;
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status") { }
        field(17; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
            Editable = false;
        }
        field(18; Department; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
            Editable = false;
        }
        field(19; "Branch Name"; Text[100])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[100])
        {
            Editable = false;
        }
        field(21; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(22; "Deputation On"; Enum "Deputation Type")
        {
            Editable = false;
        }
        field(23; "Deputation On Code"; Code[20])
        {
            Editable = false;
        }
        field(24; "Employee Work Shift"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
            trigger OnValidate()
            var
                SalaryLevelRec: Record "Salary Level";
            begin
                if SalaryLevelRec.Get("Salary Level Code") then
                    "Salary Level Description" := SalaryLevelRec.Description
                else
                    Clear("Salary Level Description");
            end;
        }
        field(28; "Extension Counter Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const("Extension Counter"));
        }
        field(29; "Province Name"; Text[100])
        {
            Editable = false;
        }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Province), Blocked = filter(false));
        }
        field(31; "Unit Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Unit));
        }
        field(32; "Compensatory Days"; Decimal) { }
        field(33; "Payroll No."; Code[20]) { }
        field(34; Ecosystem; Code[20]) { }
        field(35; "Office Code"; Code[20]) { }
        field(36; "Rejection Remarks"; Text[250]) { }
        field(37; "Approved Date"; Date) { }
        field(38; "Approver Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Direct,With Recommendation';
            OptionMembers = " ",Direct,"With Recommendation";
        }
        field(39; Cancelled; Boolean) { }
        field(40; "Cancelled No."; Code[20]) { }
        field(41; "Cancelled Document No."; Code[20])
        {
            Editable = false;
        }
        field(48; "Reason Code"; Code[20])
        {
            TableRelation = "Standard Text" WHERE("Employee Activity Type" = FIELD(Type));

            trigger OnValidate()
            begin
                if StandardText.Get("Reason Code") then
                    Validate("Reason Description", StandardText.Description)
                else
                    Clear("Reason Description");
            end;
        }
        field(49; "Reason Description"; Text[50]) { }
        field(51; "Leave Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Leave Type Setup";
            trigger OnValidate()

            begin
                if "Leave Code" <> xRec."Leave Code" then begin
                    if LeaveTypeVar.Get("Leave Code") then begin
                        Validate("Leave Description", LeaveTypeVar.Description);
                    end else begin
                        Clear("Leave Description");
                    end;
                end;
            end;
        }
        field(52; "Leave Description"; Text[50])
        {
            Editable = false;
        }
        field(53; "Leave Type"; Enum "Leave Type") { }
        field(100; Status; text[20]) { }
        field(101; "Salary Level Description"; Text[50])
        {
            Caption = 'Salary Level Description';
            Editable = false;
        }
        field(102; "Substitute Person Code"; code[20])
        {
            Caption = 'Substitute Person Code';
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                EmployeeRec: Record Employee;
            begin
                if EmployeeRec.Get("Substitute Person Code") then
                    "Substitute Person Name" := EmployeeRec."Full Name"
                else
                    Clear("Substitute Person Name");
            end;
        }
        field(103; "Substitute Person Name"; Text[100])
        {
            Caption = 'Substitute Person Name';
            Editable = false;
        }
        field(104; "CheckIn Time"; Time)
        {
        }
        field(105; "CheckOut Time"; Time)
        {
        }
         field(106; "Previous Check In Time"; Time)
        {
        }
        field(107; "Previous Check Out Time"; Time)
        {
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Start Date") { }
    }
    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                HRMgt.InitNoSeriesNew(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                CancelDocumentRec.ReadIsolation(IsolationLevel::ReadCommitted);
                CancelDocumentRec.SetLoadFields("No.");
                while CancelDocumentRec.Get("No.") do
                    "No." := NoSeriesMgt.GetNextNo("No. Series");
                OnInsertCancelDocumentOnBeforeCreateApproval(Rec, IsHandled);
                if not IsHandled then
                    ApproverMgt.InsertApprovalCancelled("Employee No.", "No.", Type, Cancelled);

            end else begin
                case Type of
                    //for leave
                    Type::"Leave Request":
                        begin
                            HRSetup.TestField("Leave No. Series");
                            HRMgt.InitNoSeriesNew(HRSetup."Leave No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            CancelDocumentRec.ReadIsolation(IsolationLevel::ReadCommitted);
                            CancelDocumentRec.SetLoadFields("No.");
                            while CancelDocumentRec.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type::"Leave Request", "Approval Status");
                            //if HRSetup."Approval From Setup" then
                            // InsertApproval();
                        end;
                    Type::"Attendance Missed":
                        begin
                            HRSetup.TestField("Attendance Missed No.");
                            HRMgt.InitNoSeriesNew(HRSetup."Attendance Missed No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            CancelDocumentRec.ReadIsolation(IsolationLevel::ReadCommitted);
                            CancelDocumentRec.SetLoadFields("No.");
                            while CancelDocumentRec.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type::"Attendance Missed", "Approval Status");
                        end;
                end;
            end;
    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        // >> Delete Approval Entry if doc deleted >> Santosh>>  4.3.2025
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
        end;
    end;

    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        LeaveTypeVar: Record "Leave Type Setup";
        StandardText: Record "Standard Text";
        ApprovalEntry: Record "Approval HRMS";
        ApproverMgt: Codeunit "Approver Mgt";
        CancelDocumentRec: Record "Cancel Document";

    [IntegrationEvent(false, false)]
    local procedure OnInsertCancelDocumentOnBeforeCreateApproval(var CancelDoc: Record "Cancel Document"; var IsHandled: Boolean);
    begin
    end;
}
