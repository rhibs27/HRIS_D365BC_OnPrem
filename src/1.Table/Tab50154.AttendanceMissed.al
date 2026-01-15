table 50154 "Attendance Missed"
{
    Caption = 'Attendance Missed';
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
                            Type::"Attendance Missed", Type::"Late Attendance":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Attendance Missed No.");
                                    "No. Series" := '';
                                end;
                        end;
                    end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type") { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Branch Code", EmpVar."Branch Code");
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
                    Validate(Department, '');
                    Validate("Salary Level Code", '');
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
            trigger OnValidate()
            var
                EmpAttendanceActivity: Record "Employee Attendance & Activity";
            begin
                EmpAttendanceActivity.Reset;
                EmpAttendanceActivity.SetRange("Employee No.", "Employee No.");
                EmpAttendanceActivity.SetRange("Attendance Date", "Start Date");
                if EmpAttendanceActivity.FindFirst then begin
                    if Type = Type::"Attendance Missed" then begin
                        Validate("Previous Check In Time", EmpAttendanceActivity."Check In Time");
                        Validate("Previous Check Out Time", EmpAttendanceActivity."Check Out Time");
                        Validate("Employee Work Shift", EmpAttendanceActivity."Employee Working Shift");
                    end else
                        if Type = Type::"Late Attendance" then begin
                            Validate("Check In Time", EmpAttendanceActivity."Check In Time");
                            Validate("Check Out Time", EmpAttendanceActivity."Check Out Time");
                            Validate("Employee Work Shift", EmpAttendanceActivity."Employee Working Shift");
                        end;
                end;
                Validate("Start Date (BS)", EngNepDate.getNepaliDate("Start Date"));
                if "Start Date" <> xRec."Start Date" then begin
                    Clear("End Date");
                    Clear("End Date (BS)");
                end;
                if not "From Journal" then
                    AttendanceMissedMgt.CheckAlreadyExists("Employee No.", Type, "Start Date");
                Validate("End Date", "Start Date");
            end;
        }
        field(8; "End Date"; Date)
        {
            trigger OnValidate()
            var
                DateError: Label 'Start Date (%1) must be less than End Date (%2).';
            begin
                if "Start Date" > "End Date" then
                    Error(DateError, "Start Date", "End Date");
                Validate("End Date (BS)", EngNepDate.getNepaliDate("End Date"));
            end;
        }
        // field(9; "No. of Days"; Decimal)
        // {
        //     Editable = false;
        //     trigger OnValidate()
        //     begin
        //     end;
        // }
        field(10; "Requested Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Fiscal Year", HrMgt.ReturnFiscalYear("Requested Date"));
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
        field(14; Remarks; Text[100]) { }
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
        field(24; "Employee Work Shift"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(28; "Extension Counter Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Organization Structure List".Code where(Type = const("Extension Counter"));
        }
        field(29; "province Name"; Text[100]) { }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Province));
        }
        field(31; "Unit Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Unit));
        }
        field(32; "Compensatory Days"; Decimal) { }
        field(33; "Payroll No."; Code[20]) { }
        field(34; Ecosystem; Code[20]) { }
        field(35; "Office Code"; Code[20]) { }
        field(36; "Rejection Remarks"; Text[100]) { }
        field(37; "Approved Date"; Date) { }
        field(39; Cancelled; Boolean) { }
        field(40; "Cancelled No."; Code[20]) { }
        field(41; "Cancelled Document No."; Code[20])
        {
            Editable = false;
        }
        field(42; "Check In Time"; Time) { }
        field(43; "Check Out Time"; Time) { }
        field(44; "Previous Check In Time"; Time)
        {
            Editable = false;
        }
        field(45; "Previous Check Out Time"; Time)
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
        field(61; "Deputation On"; Enum "Deputation Type") { }
        field(79; "Deputation On Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Checkout OverNight"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "CheckOut OverNight" then
                    if not AttendanceMgt.CheckOverNightShift("Employee Work Shift") then
                        Error('%1 do not have Overnight Shift on %2', "Employee Name", "Start Date")
            end;
        }
        field(100; Status; text[20]) { }
        field(101; "From Journal"; Boolean) { }
        field(102; "Device IP"; Text[30])
        {
            DataClassification = ToBeClassified;
            //this will store the device IP from which employee request is created
        }
        field(301; "Access Token"; code[60])
        {
            caption = 'Access Token';
            DataClassification = CustomerContent;
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
        AttendanceMissed: Record "Attendance Missed";
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        HRSetup.Get;
        if "No." = '' then begin
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                HRMgt.InitNoSeriesNew(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of
                    Type::"Attendance Missed", Type::"Late Attendance":
                        begin
                            HRSetup.TestField("Attendance Missed No.");
                            HRMgt.InitNoSeriesNew(HRSetup."Attendance Missed No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            AttendanceMissed.ReadIsolation(IsolationLevel::ReadUncommitted);
                            AttendanceMissed.SetLoadFields("No.");
                            while AttendanceMissed.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                            if not "From Journal" then begin
                                ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");
                            end;
                        end;
                end;
            end;
        end;
        //get the device ip
        GetClientIPAddress();
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
        StandardText: Record "Standard Text";
        ApprovalEntry: Record "Approval HRMS";
        ApproverMgt: Codeunit "Approver Mgt";
        AttendanceMissedMgt: Codeunit "AttendanceMiss Mgt";
        AttendanceMgt: Codeunit "Attendance Mgt";

    local procedure GetClientIPAddress()
    begin
        // Set to 'Pending' - actual IP will be captured by page control add-in
        // This is cloud-compatible approach
        "Device IP" := 'Pending';
    end;
}
