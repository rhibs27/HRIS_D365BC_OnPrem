table 50075 "Employee Activity Journal"
{
    Caption = 'Employee Activity Journal';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Emp Act. No"; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "Emp Act. No" <> xRec."Emp Act. No" then
                    case Type of
                        //for Employee Journal
                        Type::"Employee Journal":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Employee Act. Journal Series");
                                "No. Series" := '';
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
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate("From Branch", EmpVar."Branch Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Deputation On", EmpVar."Deputation on");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Deputation On Code", EmpVar."Deputation On Code");
                    Validate("Approver Role", EmpVar."Approver Role");
                    "Leave Code" := '';
                    "Start Date" := 0D;
                    "End Date" := 0D;
                    // ValidateTransfer();
                end else begin
                    Clear("Employee Name");
                    Validate("Shortcut Dimension 1 Code", '');
                    Validate(Department, '');
                    Validate("Salary Level Code", '');
                end;
            end;
        }
        field(4; "Employee Name"; Text[50])
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
                Employee: Record Employee;
            begin
                HrMgt.CheckEligibilityBeforeEmploymentDate("Start Date", "Employee No.");
                case "Employee Act Type" of
                    "Employee Act Type"::"Attendance Missed":
                        begin
                            AttendanceMissedMgt.CheckAlreadyExists("Employee No.", "Employee Act Type", "Start Date");
                            EmployeeActMgt.CheckAttendanceMissedInJournal("Employee No.", "Start Date");
                        end;
                    "Employee Act Type"::"Leave Request":
                        begin
                            Employee.Get("Employee No.");
                            if Employee."Contract Expiry Date" <> 0D then
                                if "Start Date" > Employee."Contract Expiry Date" then
                                    Error('Cannot apply leave after contract expiry date');
                        end;
                end;
                Validate("Start Date (BS)", EngNepDate.getNepaliDate("Start Date"));
                if "Start Date" <> xRec."Start Date" then begin
                    Clear("End Date");
                    Clear("End Date (BS)");
                    Clear("No. of Days");
                end;
                Validate("Employee Work Shift", ShiftAssignmentMgt.ReturnEmployeeWorkShift("Employee No.", "Start Date"));
            end;
        }
        field(8; "End Date"; Date)
        {
            trigger OnValidate()
            var
                LeaveMgt: Codeunit "Leave Mgt.";
            begin
                if "Employee Act Type" = "Employee Act Type"::"Leave Request" then begin
                    if ("Leave Code" = '') or ("Leave Type" = "Leave Type"::" ") then
                        Error('Leave code and leave type cannot be blank')
                end;
                Validate("End Date (BS)", EngNepDate.getNepaliDate("End Date"));
                if "End Date" <> 0D then begin
                    if "Employee Act Type" = "Employee Act Type"::"Leave Request" then
                        Validate("No. of Days", LeaveMgt.CalculateNoOfDays("Start Date", "End Date", "Leave Code", "Employee Act Type", "Leave Type", "Employee No."))
                end
                else begin
                    Clear("End Date (BS)");
                    Clear("No. of Days");
                end;
            end;
        }
        field(9; "No. of Days"; Decimal)
        {
            trigger OnValidate()
            begin
                if ("Employee Act Type" = "Employee Act Type"::"Leave Request") and ("Adjustment Type" = "Adjustment Type"::Used) then begin
                    EmployeeActMgt.CheckLeaveInSameDay(Rec);
                    LeaveMgt.CheckPendingLeave('', "Leave Code", "Employee No.");
                    LeaveMgt.CheckRemainingLeaveDays("Leave Code", "Employee No.", "No. of Days");
                    LeaveMgt.CheckForEmployeeLimit("Leave Code", "Employee No.");
                    LeaveMgt.CheckLeaveApproved("Employee No.", "Start Date", "End Date");
                    LeaveMgt.CheckForLimitDays("Leave Code", "No. of Days");
                    LeaveMgt.CheckLeaveConflict("Employee No.", "Start Date", "End Date");
                    LeaveMgt.CheckForLeaveCriteria("Leave Code", "Start Date", "End Date", "Employee No.", "No. of Days");
                    leaveMgt.CheckForMultipleRequest("Leave Code", "Employee No.", "Start Date", "End Date", "No. of Days");
                    LeaveMgt.CheckHalfLeave("Start Date", "End Date", "Leave Type", "Leave Code");
                end
            end;
        }
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
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = False;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
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
        field(22; "Line No"; Integer)
        {
            Editable = false;
        }
        field(23; "Employee Work Shift"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(24; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(25; "Employee Act Type"; Enum "Employee Activity Type")
        {
            Editable = false;
        }
        field(26; "Posting Date"; Date) { }
        field(28; "Extension Counter Code"; Code[20]) { }
        field(30; "Province Code"; Code[20]) { }
        field(31; "Unit Code"; Code[20]) { }
        field(32; "Compensatory Days"; Decimal) { }
        field(33; "Payroll No."; Code[20]) { }
        field(34; "Requester Employee"; Code[20])
        {
            TableRelation = Employee;
        }
        field(36; "Rejection Remarks"; Text[100]) { }
        field(37; "Approved Date"; Date) { }
        field(39; Cancelled; Boolean) //Used in all Employee activity
        {
        }
        //Leave
        field(40; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";
            trigger OnValidate()
            Var
                LeaveTypeVar: Record "Leave Type Setup";
            begin
                if "Leave Code" <> xRec."Leave Code" then begin
                    Clear("For Death Of");
                    Clear("Start Date");
                    Clear("End Date");
                    Clear("No. of Days");
                    Clear("Compensatory Date");
                    Clear("Child's Gender");
                end;
                if LeaveTypeVar.Get("Leave Code") then begin
                    Validate("Leave Description", LeaveTypeVar.Description);
                    Validate("Pay Type", LeaveTypeVar."Pay Type");
                end else begin
                    Clear("Leave Description");
                    Clear("Pay Type");
                end;
            end;
        }
        field(41; "Leave Description"; Text[50])
        {
            Editable = false;
        }
        field(42; "Leave Type"; Enum "Leave Type")
        {
            trigger OnValidate()
            var
                WorkShift: Record "Employee Work Shift";
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
                if "Leave Type" <> xRec."Leave Type" then begin
                    Clear("Start Date");
                    Clear("End Date");
                    Clear("No. of Days");
                end;
                if "End Date" <> 0D then
                    "No. of Days" := leaveMgt.CalculateNoOfDays("Start Date", "End Date", "Leave Code", Type, "Leave Type", "Employee No.");
            end;
        }
        field(43; "Pay Type"; Enum "Leave Pay Type")
        {
            Editable = false;
        }
        field(44; "Start Time"; Time)
        {
            Description = 'also used for OT';
            trigger OnValidate()
            begin
            end;
        }
        field(45; "End Time"; Time)
        {
            Description = 'also used for OT';
            trigger OnValidate()
            begin
            end;
        }
        field(46; "Compensatory Date"; Date)
        {
            trigger OnValidate()
            begin
                leaveMgt.CheckForCompensatory("Leave Code", "Employee No.", "Compensatory Date", "No. of Days");
            end;
        }
        field(47; "For Death Of"; Enum "For Death Of") { }
        field(48; "Child's Gender"; Enum Gender) { }
        field(50; Description; Text[250]) { }
        field(51; "Screener Remarks"; Text[100]) { }
        //Transfer
        field(52; "Transfer Type"; Enum "Transfer Type")
        {
            trigger OnValidate()
            begin
                if "Transfer Type" in ["Transfer Type"::"Intra Branch", "Transfer Type"::"Intra Department", "Transfer Type"::"Intra Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                    "Shortcut Dimension 1 Code (To)" := "Shortcut Dimension 1 Code";
                    "To Branch" := "Shortcut Dimension 1 Code";
                    "To Branch" := "From Branch";
                    "Department Code (To)" := Department;
                    "Province Code (To)" := "Province Code";
                    "Unit (To)" := "Unit Code";
                    "Approver Role (TO)" := "Approver Role";
                end;
                if "Transfer Type" in ["Transfer Type"::"Inter Branch", "Transfer Type"::"Inter Department", "Transfer Type"::"Inter Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                end;
                if "Transfer Type" = "Transfer Type"::"Cross Transfer" then
                    "Deputation On (To)" := "Deputation On (To)"::" ";
            end;
        }
        field(53; "Shortcut Dimension 1 Code (To)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if "Shortcut Dimension 1 Code (To)" <> xRec."Shortcut Dimension 1 Code (To)" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, OrganizationStructureList.Code) then begin
                        "Province Code (To)" := OrganizationStructureList."Province Code";
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
            end;
        }
        //change 0:
        field(54; "Province Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            begin
                if "Province Code (To)" <> xRec."Province Code (To)" then
                    Clear("To Branch");
                if "Deputation On (To)" = "Deputation On (To)"::Province then
                    ValidateDeputationOnTo
            end;
        }
        field(55; "Unit (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Department), Code = field("Department Code (To)"), "Reporting Type" = filter("Deputation Type"::unit));
            trigger OnValidate()
            begin
                if "Unit (To)" <> xRec."Unit (To)" then begin
                end;
            end;
        }
        field(56; "Department Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if "Department Code (To)" <> xRec."Department Code (To)" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type, OrganizationStructureList.Code) then begin
                        "Province Code (To)" := OrganizationStructureList."Province Code";
                        "Unit (To)" := '';
                        "Shortcut Dimension 1 Code (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
                ValidateDeputationOnTo
            end;
        }
        field(57; "Travel Order No"; Code[20]) { }
        field(58; "Extension Counter (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Branch), Code = field("To Branch"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if "Extension Counter (To)" <> xRec."Extension Counter (To)" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Extension Counter (To)") then begin
                        "Province Code (To)" := OrganizationStructureList."Province Code";
                        // "Sub Province Code (To)" := '';
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Shortcut Dimension 1 Code (To)" := '';
                    end;
                end;
            end;
        }
        field(59; "Transfer Effective Date"; Date)
        {
            Description = 'Transfer';
        }
        field(60; "Functional Title (To)"; Code[20])
        {
            Description = 'Transfer / Promotion';
            TableRelation = "Functional Title";
        }
        field(61; "Deputation On"; Enum "Deputation Type") { }
        field(62; "Deputation On (To)"; Enum "Deputation Type")
        {
            trigger OnValidate()
            begin
                if "Deputation On (To)" <> xRec."Deputation On (To)" then begin
                    Clear("Shortcut Dimension 1 Code (To)");
                    Clear("Department Code (To)");
                    Clear("Unit (To)");
                    Clear("Functional Title (To)");
                    Clear("Province Code (To)");
                    Clear("Extension Counter (To)");
                end;
            end;
        }
        field(63; "Outgoing Branch Rep. Person"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            trigger OnValidate()
            begin
                if "Outgoing Branch Rep. Person" <> '' then begin
                    EmployeeRec.Get("Outgoing Branch Rep. Person");
                    "Outgoing Reporting Person Name" := EmployeeRec."Full Name";
                end;
                if "Outgoing Branch Rep. Person" = "Employee No." then
                    Error('Cannot Select Yourself as Outgoing Reporting person');
            end;
        }
        field(64; "Outgoing Reporting Person Name"; Text[50]) { }
        field(65; "Incoming Supervisor"; Code[20])
        {
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            Description = 'Transfer';
            trigger OnValidate()
            begin
                if EmpVar.Get("Incoming Supervisor") then
                    Validate("Incoming Supervisor Name", EmpVar."Full Name")
                else
                    Clear("Incoming Supervisor Name");
            end;
        }
        field(66; "Incoming Supervisor Name"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(67; "Reason for Transfer"; Text[100])
        {
            Description = 'Transfer';
        }
        field(68; "Date of Joining Of Transfer"; Date)
        {
            Description = 'Transfer';
            trigger OnValidate()
            begin
                TestField("Transfer Effective Date");
                if "Date of Joining Of Transfer" < "Transfer Effective Date" then
                    Error('Date of joining of transfer %1 cannot be less than HR Proposed date %2', "Date of Joining Of Transfer", "Transfer Effective Date");
            end;
        }
        field(69; "Transfer Remarks"; Text[50])
        {
            Description = 'Transfer';
        }
        field(70; "Notify to"; Text[200])
        {
            Description = 'Transfer';
            TableRelation = Employee where(Status = filter("Employee Status"::Active));
        }
        field(71; "Transfer Category"; Enum "Transfer Category")
        {
            Description = 'Transfer';
        }
        field(72; "Curr. Placement Period(Month)"; Decimal)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(73; "Reason For Cancel"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(74; "Cancelled Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(75; "Transfer Propose Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(76; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(77; "From Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
        }
        // change 1:
        field(78; "To Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure Line"."Reporting Code"
                   WHERE(Type = filter("Deputation Type"::Province),
                         Code = field("Province Code (To)"),
                         "Reporting Type" = filter("Deputation Type"::Branch));
            trigger OnValidate()
            var
                OrganizationStructureLine: Record "Organization Structure Line";
            begin
                TestField("Province Code (To)");
                ValidateDeputationOnTo;
                OrganizationStructureLine.Reset();
                OrganizationStructureLine.SetRange("Reporting Type", OrganizationStructureLine.Type::Branch);
                OrganizationStructureLine.SetRange("Reporting Code", "TO Branch");
                if OrganizationStructureLine.FindFirst() then
                    Validate("Province Code (To)", OrganizationStructureLine.Code);
            end;
        }
        field(79; "Deputation On Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Deputation On Code To"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(81; "Incoming Supervisor 2"; Code[20])
        {
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            Description = 'Transfer';
            trigger OnValidate()
            begin
                if EmpVar.Get("Incoming Supervisor 2") then
                    Validate("Incoming Supervisor Name 2", EmpVar."Full Name")
                else
                    Clear("Incoming Supervisor Name 2");
            end;
        }
        field(82; "Incoming Supervisor Name 2"; Text[50]) { }
        field(83; "Outgoing Branch Rep. Person 2"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            trigger OnValidate()
            begin
                if "Outgoing Branch Rep. Person 2" <> '' then begin
                    EmployeeRec.Get("Outgoing Branch Rep. Person 2");
                    "Outgoing Rep. Person Name 2" := EmployeeRec."Full Name";
                end;
                if "Outgoing Branch Rep. Person 2" = "Employee No." then
                    Error('Cannot Select Yourself as Outgoing Reporting person');
            end;
        }
        field(84; "Outgoing Rep. Person Name 2"; Text[50]) { }
        // OverTime
        field(90; "Overtime Claim Type"; Enum "Overtime Claim Type")
        {
            DataClassification = ToBeClassified;
        }
        field(91; "Estimated Hours"; Decimal) { }
        field(92; "Actual OT Hours"; Decimal) { }
        field(93; "OT Amount"; Decimal)
        {
            Editable = false;
        }
        field(94; "OT Eligible Hours"; Decimal)
        {
            Editable = false;
        }
        field(95; "Morning OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(96; "Evening OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(97; "Total OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(98; "Adjustment Type"; Enum "Leave Earn Type")
        {
            ValuesAllowed = Used, Adjustment;
            InitValue = Used;
            trigger OnValidate()
            begin
                if "Adjustment Type" = "Adjustment Type"::Adjustment then begin
                    Clear("Start Date");
                    Clear("End Date");
                    Clear("Start Date (BS)");
                    Clear("End Date (BS)");
                end;
            end;
        }
        field(100; Status; text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Status Master";
            Editable = false;
        }
        field(102; "Approver Role"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Approver Role (TO)"; Code[20])
        {
            Description = 'Transfer / Promotion';
            TableRelation = "Approval Role";
        }
        field(108; "CheckIn Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(109; "CheckOut Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(110; "CheckOut OverNight"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "CheckOut OverNight" then
                    if not AttendanceMgt.CheckOverNightShift("Employee Work Shift") then
                        Error('%1 do not have Overnight Shift on %2', "Employee Name", "Start Date")
            end;
        }
        field(111; Attachment; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(112; "Attachment File Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        //loan
        //to import past loan details
        field(115; "Loan Type"; Enum "Loan Type")
        {
            DataClassification = ToBeClassified;
        }
        field(116; "Loan Disbursed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(117; "Loan Account No."; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(118; "Loan Account Opening Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(119; "Loan Interest Rate (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Loan Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(121; "Loan Settlement Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //additional for home loan insurance
        field(122; "Yearly Premium Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(123; "Insurance Company"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(124; "Policy No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(125; "First Premium Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(126; "Substitute Person Code"; code[20])
        {
            Caption = 'Substitute Person Code';
            TableRelation = Employee."No." WHERE(Status = CONST(Active));
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
        field(127; "Substitute Person Name"; text[50])
        {
            Caption = 'Substitute Person Name';
            Editable = false;
        }

        // Promotion
        field(150; "Promoted Salary Grade"; Code[20])
        {
            TableRelation = "Salary Grade";
        }
        field(151; "Promoted Salary level"; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(152; "Promoted Staff Level"; Enum "Staff Type") { }
        field(153; "Promotion Date"; Date) { }
        field(154; "Decision Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Emp Act. No", "Line No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "User ID" := UserId;
        "Requester Employee" := HrMgt.GetEmployeeNo();
        Validate("Requested Date", Today);
    end;

    trigger OnDelete()
    begin
        if not ("Approval Status" in ["Approval Status"::Open]) then
            Error('Only Open records can be deleted. Current status: %1', "Approval Status");
    end;

    procedure SetUpNewLine(LastActJnlLine: Record "Employee Activity Journal")
    var
        ActivityJournal: Record "Employee Activity Journal";
        CurrDocumentNo: Boolean;
        SkipApproval: Boolean;
    begin
        HRSetup.Get();
        ActivityJournal.Reset();
        ActivityJournal.SetRange("Emp Act. No", LastActJnlLine."Emp Act. No");
        ActivityJournal.SetRange("Employee Act Type", LastActJnlLine."Employee Act Type");
        ActivityJournal.SetRange("Approval Status", ActivityJournal."Approval Status"::Open);
        if ActivityJournal.FindFirst() then
            CurrDocumentNo := true;
        ActivityJournal.Reset();
        ActivityJournal.SetRange("Emp Act. No", LastActJnlLine."Emp Act. No");
        ActivityJournal.SetRange("Employee Act Type", LastActJnlLine."Employee Act Type");
        ActivityJournal.SetFilter("Approval Status", '%1|%2', ActivityJournal."Approval Status"::"Pending", ActivityJournal."Approval Status"::Approved);
        if ActivityJournal.FindFirst() then
            CurrDocumentNo := false;
        if CurrDocumentNo then begin
            // "Posting Date" := LastActJnlLine."Posting Date";
            "Emp Act. No" := LastActJnlLine."Emp Act. No";
        end
        else
            if not CurrDocumentNo then begin
                HRSetup.Get();
                "Posting Date" := WorkDate();
                HRSetup.TestField("Employee Act. Journal Series");
                "No. Series" := HRSetup."Employee Act. Journal Series";
                "Emp Act. No" := NoSeriesMgt.GetNextNo("No. Series", "Posting Date", true);
                ApprovalHRMS.Reset();
                ApprovalHRMS.SetRange("Document No.", '');
                ApprovalHRMS.setRange("Document Type", Rec."Employee Act Type");
                ApprovalHRMS.DeleteAll();
                if HRSetup."Skip Approval On HR Transfer" and (Rec."Employee Act Type" = Rec."Employee Act Type"::"HR Transfer") then
                    SkipApproval := true;

                OnSetupNewLineOnBeforeInsertApproval(Rec, SkipApproval);
                if not SkipApproval then
                    ApproverMgt.InsertApproval(HrMgt.GetEmployeeNo(), "Emp Act. No", Type, "Approval Status");
            end;
    end;

    procedure InsertApproval(var FirstLine: Boolean; var EmpActNo: Code[20])
    begin
        if FirstLine then begin
            HRSetup.Get();
            HRSetup.TestField("Employee Act. Journal Series");
            "No. Series" := HRSetup."Employee Act. Journal Series";
            "Emp Act. No" := NoSeriesMgt.GetNextNo("No. Series", "Posting Date", true);
            ApprovalHRMS.Reset();
            ApprovalHRMS.SetRange("Document No.", '');
            ApprovalHRMS.setRange("Document Type", Rec."Employee Act Type");
            ApprovalHRMS.DeleteAll();
            ApproverMgt.InsertApproval(HrMgt.GetEmployeeNo(), "Emp Act. No", Type, "Approval Status");
            FirstLine := false;
            EmpActNo := "Emp Act. No";
        end;
    end;

    local procedure ValidateDeputationOnTo();
    var
        OrganizationStructureList: Record "Organization Structure List";
    begin
        TestField("Deputation On (To)");
        case "Deputation on (To)" of
            "Deputation on"::Branch:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "TO Branch") then begin
                    Validate("Deputation On Code To", OrganizationStructureList.Code);
                    // Validate("Province Code (To)", OrganizationStructureList."Province Code");
                    // Validate("Branch Name To", OrganizationStructureList.Name);
                end;
            "Deputation on"::Department:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Department Code (To)") then begin
                    Validate("Deputation On Code To", OrganizationStructureList.Code);
                    // Validate("Department Name To", OrganizationStructureList.Name);
                    // Validate("Province Code (To)", OrganizationStructureList."Province Code");
                end;
            "Deputation on"::Province:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Province Code (to)") then begin
                    Validate("Deputation On Code To", OrganizationStructureList.Code);
                end;
        end;
    end;

    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        HrMgt: Codeunit "HR Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        LeaveMgt: Codeunit "Leave Mgt.";
        EmployeeActMgt: Codeunit EmployeeActivityMgt;
        AttendanceMgt: Codeunit "Attendance Mgt";
        AttendanceMissedMgt: Codeunit "AttendanceMiss Mgt";
        EmployeeRec: Record Employee;
        ApprovalHRMS: Record "Approval HRMS";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";

    [IntegrationEvent(false, false)]
    local procedure OnSetupNewLineOnBeforeInsertApproval(var EmpActJnl: Record "Employee Activity Journal"; var SkipApproval: Boolean)
    begin
    end;
}
