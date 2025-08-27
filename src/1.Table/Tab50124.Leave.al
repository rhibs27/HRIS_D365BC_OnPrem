table 50124 Leave
{
    Caption = 'Leave';
    DataClassification = CustomerContent;
    //Field 1,2,16,37 100 are used in ApprovalMgt Codeunit as field Ref << Santosh 3.25.2025
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
                            //for leave
                            Type::"Leave Request":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Leave No. Series");
                                    "No. Series" := '';
                                end;
                        end;
                    end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type")
        {
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Deputation On", EmpVar."Deputation on");
                    Validate("Deputation On Code", EmpVar."Deputation On Code");
                    Validate("Contact No.", EmpVar."Mobile Phone No.");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate("Province Name", EmpVar."Province Name");
                end else begin
                    Clear("Employee Name");
                    Validate("Shortcut Dimension 1 Code", '');
                    Validate(Department, '');
                    // Validate("Auth. Account No.", '');//NILESH
                    Validate("Salary Level Code", '');
                end;
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if Type <> Type::Overtime then
                    EmployeeRec.Get("Employee No.");
                if "Start Date" <> 0D then begin
                    if "Start Date" < EmployeeRec."Employment Date" then
                        Error('Cannot apply before your employment date');
                    if Type = Type::"Leave Request" then begin
                        if EmployeeRec."Confirmation Date" <> 0D then
                            if "Start Date" < EmployeeRec."Confirmation Date" then
                                Error('Cannot apply before your confirmation date.');
                    end;
                end;
                //>>check for leave
                if Type = Type::"Leave Request" then begin
                    if EmployeeRec."Contract Expiry Date" <> 0D then
                        if "Start Date" > EmployeeRec."Contract Expiry Date" then
                            Error('Cannot apply leave after contract expiry date');

                end;
                //<<check for leave

                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Start Date");
                if EngNepDate.FindFirst then
                    Validate("Start Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Start Date (BS)");
                if GuiAllowed then
                    if "Start Date" <> xRec."Start Date" then begin
                        Clear("End Date");
                        Clear("End Date (BS)");
                        // Validate("No. of Days", 0);
                    end;
            end;
        }
        field(8; "End Date"; Date)
        {

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "End Date");
                if EngNepDate.FindFirst then
                    Validate("End Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("End Date (BS)");
                if GuiAllowed then begin
                    if Type = Type::"Leave Request" then
                        TestField("Leave Code");
                    if "End Date" <> 0D then begin
                        OnvalidateEndDateOnbeforeCalculatingNoofDays(Rec, IsHandled);   //added as needed to bypass "Exclude non working days" setup control
                                                                                        //based on information provided in leave form
                        if not IsHandled then
                            Validate("No. of Days", leaveMgt.CalculateNoOfDays("Start Date", "End Date", "Leave Code", Type, "Leave Type", "Employee No."))
                    end else begin
                        Clear("End Date (BS)");
                        Clear("No. of Days");
                    end;
                end;
            end;
        }
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                if GuiAllowed then
                    if Type = Type::"Leave Request" then
                        leaveMgt.GenerateLeaveAttachment(rec);
                if "No. of Days" <= 0 then
                    Error('No of Days Cannot be zero');
                if not Cancelled then
                    if (Type = Type::"Leave Request") and ("End Date" <> 0D) then begin
                        leaveMgt.CheckForLimitDays("Leave Code", "No. of Days");
                        leaveMgt.CheckLeaveConflict("Employee No.", "Start Date", "End Date");
                        leaveMgt.CheckForLeaveCriteria("Leave Code", "Start Date", "End Date", "Employee No.", "No. of Days");
                        leaveMgt.CheckForMulipleRequest("Leave Code", "Employee No.", "Start Date", "End Date", "No. of Days");
                        leaveMgt.CheckHalfLeave("Start Date", "End Date", "Leave Type", "Leave Code");
                        leaveMgt.CheckRemainingLeaveDays("Leave Code", "Employee No.", "No. of Days");
                    end;
            end;
        }
        field(10; "Requested Date"; Date)
        {
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
        field(14; Remarks; Text[100])
        {
            // trigger OnValidate()
            // begin
            //     Clear("Rejection Remarks");
            // end;
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }

        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                GLSetup.Get;
                if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
                    Validate("Branch Name", DimValue.Name)
                else
                    Validate("Branch Name", '');
            end;
        }
        field(18; Department; Code[20])
        {
            Editable = false;
        }
        field(19; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[50])
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
        }
        field(30; "Province Code"; Code[20])
        {
        }
        field(29; "Province Name"; Code[50])
        {
        }
        field(31; "Unit Code"; Code[20])
        {
        }
        field(32; "Compensatory Days"; Decimal)
        {
        }
        field(33; "Payroll No."; Code[20])
        {
        }
        field(34; Ecosystem; Code[20])
        {
        }
        field(35; "Office Code"; Code[20])
        {
        }
        field(36; "Rejection Remarks"; Text[100])
        {
            // trigger OnValidate()

            // begin
            //     Clear(Remarks);
            // end;
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(38; "Approver Type"; Enum "Approver Type")
        {
            Editable = false;
        }
        field(39; Cancelled; Boolean)
        {
        }
        field(40; "Cancelled No."; Code[20])
        {
        }
        field(41; "Cancelled Document No."; Code[20])
        {
            Editable = false;
        }
        field(50; "Contact No."; Text[50])
        {
        }
        field(51; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";

            trigger OnValidate()
            begin
                if GuiAllowed then begin
                    if "Leave Code" <> xRec."Leave Code" then begin
                        Clear("For Death Of");
                        if GuiAllowed then
                            leaveMgt.GenerateLeaveAttachment(Rec);
                        if LeaveTypeVar.Get("Leave Code") then begin
                            Validate("Leave Description", LeaveTypeVar.Description);
                            Validate("Pay Type", LeaveTypeVar."Pay Type");
                            Clear("Start Date");
                            Clear("End Date");
                            Clear("No. of Days");
                        end else begin
                            Clear("Leave Description");
                            Clear("Pay Type");
                        end;
                        Clear("Compensatory Date");
                        Clear("Child's Gender");
                        // Clear("Contact No."); //nilesh
                    end;
                end else
                    if LeaveTypeVar.Get("Leave Code") then
                        Validate("Leave Description", LeaveTypeVar.Description)

            end;
        }
        field(52; "Leave Description"; Text[50])
        {
            Editable = false;
        }
        field(53; "Leave Type"; Enum "Leave Type")
        {
            trigger OnValidate()
            var
                LeaveTypeSetup: Record "Leave Type Setup";
                HalfLeaveError: Label 'Half Leaves cannot be applied in multiple days.';
            begin
                WorkShift.Get("Employee Work Shift");
                case "Leave Type" of
                    "Leave Type"::"Full Day":
                        begin
                            Validate("Start Time", WorkShift."Start Time");
                            Validate("End Time", WorkShift."End Time");
                        end;

                    "Leave Type"::"First Half":
                        begin
                            Validate("Start Time", WorkShift."Start Time");
                            Validate("End Time", WorkShift."Lunch Start");
                        end;

                    "Leave Type"::"Second Half":
                        begin
                            Validate("Start Time", WorkShift."Lunch Start");
                            Validate("End Time", WorkShift."End Time");
                        end;
                end;
                if GuiAllowed then
                    if "Leave Type" <> xRec."Leave Type" then begin
                        Clear("Start Date");
                        Clear("End Date");
                        Clear("No. of Days");
                    end;
                if "End Date" <> 0D then begin
                    "No. of Days" := leaveMgt.CalculateNoOfDays("Start Date", "End Date", "Leave Code", Type, "Leave Type", "Employee No.");
                end;
            end;
        }
        field(54; "Pay Type"; Enum "Leave Pay Type")
        {
            Editable = false;
        }
        field(55; "Start Time"; Time)
        {
            Description = 'also used for OT';
            trigger OnValidate()
            begin
            end;
        }
        field(56; "End Time"; Time)
        {
            Description = 'also used for OT';
            trigger OnValidate()
            begin
            end;
        }
        field(57; "Compensatory Date"; Date)
        {

            trigger OnValidate()
            begin
                leaveMgt.CheckForCompensatory("Leave Code", "Employee No.", "Compensatory Date", "No. of Days");
            end;
        }
        field(58; "For Death Of"; Enum "For Death Of")
        {
        }
        field(59; "Child's Gender"; Enum Gender)
        {
        }
        field(60; "LFA Paid"; Boolean)
        {

        }
        field(61; "Deputation On"; Enum "Deputation Type")
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Form Journal"; Boolean)
        {
        }
        field(63; "Deputation On Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Status"; Text[20])
        {
        }

    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;

        }
        key(Key2; "Start Date")
        {
        }
    }
    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        LeaveTypeVar: Record "Leave Type Setup";
        WorkShift: Record "Employee Work Shift";
        SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        EmployeeRec: Record Employee;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
        LeaveError: Label 'You cannot apply leave in Present day %1.';
        leaveMgt: Codeunit "Leave Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalEntry: Record "Approval HRMS";

    trigger OnInsert()
    var
        LeaveRec: Record Leave;
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        if not GuiAllowed then begin
            "Employee No." := HRMgt.GetEmployeeNo();
            // Type := type::"Leave Request";
            "User ID" := userID;
            if "Approval Status" <> "Approval Status"::Approved then
                "Approval Status" := "Approval Status"::Pending;
        end;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                HRMgt.InitNoSeriesNew(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of
                    //for leave
                    Type::"Leave Request":
                        begin
                            HRSetup.TestField("Leave No. Series");
                            HRMgt.InitNoSeriesNew(HRSetup."Leave No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            LeaveRec.ReadIsolation(IsolationLevel::ReadUncommitted);
                            LeaveRec.SetLoadFields("No.");
                            while LeaveRec.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");

                            if "Approval Status" <> "Approval Status"::Approved then
                                ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");

                            if not GuiAllowed then begin
                                leaveMgt.ApplyForLeave(Rec)
                                OnAfterApplyForLeave(Rec);
                            end;
                        end;
                end;


    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        ApprovalEntry.SetRange("Employee No", "Employee No.");
        ApprovalEntry.DeleteAll();
        end;
    end;

    procedure AssistEdit(OldLeave: Record "Leave"): Boolean
    var
        Leave: Record "Leave";
    begin
        HRSetup.Get;
        Leave := Rec;
        if Leave.Cancelled then begin
            HRSetup.TestField("Cancel Document No. Series");
            if NoSeriesMgt.LookupRelatedNoSeries(HRSetup."Cancel Document No. Series", OldLeave."No. Series", Leave."No. Series") then begin
                NoSeriesMgt.GetNextNo(Leave."No.");
                Rec := Leave;
                exit(true);
            end;
        end else begin
            case Leave.Type of
                //for leave
                Leave.Type::"Leave Request":
                    begin
                        HRSetup.TestField("Leave No. Series");
                        if NoSeriesMgt.LookupRelatedNoSeries(HRSetup."Leave No. Series", OldLeave."No. Series", Leave."No. Series") then begin
                            NoSeriesMgt.GetNextNo(Leave."No.");
                            Rec := Leave;
                            exit(true);
                        end;
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnvalidateEndDateOnbeforeCalculatingNoofDays(var Leave: Record Leave; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterApplyForLeave(var Leave: Record Leave)
    begin
    end;
}
