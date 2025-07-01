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
                // if Type <> Type::Overtime then
                //     EmployeeRec.Get("Employee No.");
                if "Start Date" <> 0D then begin
                    if "Start Date" < EmployeeRec."Employment Date" then
                        Error('Cannot apply before your employment date');
                end;

                //<<check for leave

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

            trigger OnValidate()
            var
                TravelMgt: Codeunit "Travel Mgt.";
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "End Date");
                if EngNepDate.FindFirst then
                    Validate("End Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("End Date (BS)");
                if "End Date" <> 0D then
                    Validate("No. of Days", TravelMgt.CalculateNoOfDaysTravel("Start Date", "End Date"))
                else begin
                    Clear("End Date (BS)");
                    Clear("No. of Days");
                end;
            end;
        }
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;

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

            trigger OnLookup()
            begin
                // PAGE.Run(PAGE::"Employee List");
            end;
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            // TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            // trigger OnValidate()
            // begin
            //     GLSetup.Get;
            //     if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
            //         Validate("Branch Name", DimValue.Name)
            //     else
            //         Validate("Branch Name", '');
            // end;
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
        field(23; "Employee Work Shift"; Code[10])
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
        field(26; "Posting Date"; Date)
        {
            Editable = false;
        }

        field(28; "Extension Counter Code"; Code[20])
        {
        }
        field(30; "Province Code"; Code[20])
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
        field(34; "Requester Employee"; Code[20])
        {
            TableRelation = Employee;
        }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
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
                    // if GuiAllowed then
                    //     leaveMgt.GenerateLeaveAttachment(Rec);
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
                /*IF "Leave Code" = 'COMPENSATORY' THEN //Min 8.7.2022
                  ERROR(Text002);*/

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
        field(47; "For Death Of"; Enum "For Death Of")
        {
        }
        field(48; "Child's Gender"; Enum Gender)
        {
        }
        field(50; Description; Text[250])
        {
        }
        field(51; "Screener Remarks"; Text[100])
        {
        }
        //Transfer 
        field(52; "Transfer Type"; Enum "Transfer Type")
        {
            trigger OnValidate()
            begin
                if "Transfer Type" in ["Transfer Type"::"Intra Branch", "Transfer Type"::"Intra Department", "Transfer Type"::"Intra Provincial"] then begin //Min >>
                    "Deputation On (To)" := "Deputation On";
                    "Shortcut Dimension 1 Code (To)" := "Shortcut Dimension 1 Code";
                    "Department Code (To)" := Department;
                    "Province Code (To)" := "Province Code";
                    "Unit (To)" := "Unit Code";
                    // GetTransferName;
                end;
                if "Transfer Type" in ["Transfer Type"::"Inter Branch", "Transfer Type"::"Inter Department", "Transfer Type"::"Inter Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                    // GetTransferName;
                end;
                if "Transfer Type" = "Transfer Type"::"Cross Transfer" then
                    "Deputation On (To)" := "Deputation On (To)"::" ";
                //Min >>
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
                    // GLSetup.Get;
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, OrganizationStructureList.Code) then begin
                        "Province Code (To)" := OrganizationStructureList."Province Code";
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
            end;
        }
        field(54; "Province Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            begin
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
        field(57; "Travel Order No"; Code[20])
        {
        }
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
            Description = 'Transfer';
            TableRelation = "Functional Title";
        }
        field(61; "Deputation On"; Enum "Deputation Type")
        {

        }
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
            // Description = 'Transfer';
            // TableRelation = Employee."No." where("Deputation On Code" = field("Deputation on Code"));
            // trigger OnValidate()
            // var
            //     Employee: Record Employee;
            // begin
            //     if Employee.get("Outgoing Branch Rep. Person") then
            //         "Outgoing Reporting Person Name" := Employee."Full Name";
            // end;
            Description = 'Transfer';
            TableRelation = Employee."No." where("Deputation On Code" = field("Deputation on Code"), status = const("Employee Status"::Active));

            trigger OnValidate()
            begin
                if "Outgoing Branch Rep. Person" <> '' then begin //Min 12.13.2022
                    EmployeeRec.Get("Outgoing Branch Rep. Person");
                    "Outgoing Reporting Person Name" := EmployeeRec."Full Name";
                    // if SalaryLevel.Get("Salary Level Code") then;
                    // if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                    // if SalaryLevel.Rank >= SalaryLevel1.Rank then
                    //     Error('Salary level of Outgoing Branch Person (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
                end;
                if "Outgoing Branch Rep. Person" = "Employee No." then
                    Error('Cannot Select Yourself as Outgoing Reporting person');
            end;
        }
        field(64; "Outgoing Reporting Person Name"; Text[50])
        {
        }
        field(65; "Incoming Supervisor"; Code[20])
        {
            Description = 'Transfer';
            // TableRelation = Employee."No." where("Deputation On Code" = field("Deputation on Code To"));
            TableRelation = Employee."No." where("Deputation On Code" = field("Deputation on Code To"), status = const("Employee Status"::Active));
            trigger OnValidate()
            begin
                // if "Incoming Supervisor" <> '' then begin //Min 12.13.2022
                //     EmployeeRec.Get("Incoming Supervisor");
                //     if SalaryLevel.Get("Salary Level Code") then;
                //     if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                //     if SalaryLevel.Rank >= SalaryLevel1.Rank then
                //         Error('Salary level of Incoming Supervisor (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
                // end;
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
        field(78; "To Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            trigger OnValidate()
            begin
                ValidateDeputationOnTo
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

        // OverTime 
        field(90; "Overtime Claim Type"; Enum "Overtime Claim Type")
        {
            DataClassification = ToBeClassified;
        }
        field(91; "Estimated Hours"; Decimal)
        {
        }
        field(92; "Actual OT Hours"; Decimal)
        {
        }
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
        field(100; Status; text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Status Master";
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
        "Requested Date" := Today;
    end;

    procedure SetUpNewLine(LastActJnlLine: Record "Employee Activity Journal")
    var
        ActivityJournal: Record "Employee Activity Journal";
        EmpVar: Record Employee;
        EngNep: Record "English-Nepali Date";
        CurrDocumentNo: Boolean;
    begin
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
                "No. Series" := HRSetup."Employee Act. Journal Series";
                "Emp Act. No" := NoSeriesMgt.GetNextNo("No. Series", "Posting Date", true);
                ApprovalHRMS.Reset();
                ApprovalHRMS.SetRange("Document No.", '');
                ApprovalHRMS.setRange("Document Type", Rec."Employee Act Type");
                ApprovalHRMS.DeleteAll();
                ApproverMgt.InsertApproval(HrMgt.GetEmployeeNo(), "Emp Act. No", Type, "Approval Status");
            end;
    end;

    local procedure ValidateDeputationOnTo();
    var
        OrganizationStructureLine: Record "Organization Structure line";
        OrganizationStructureList: Record "Organization Structure List";
    begin
        TestField("Deputation On (To)");
        case "Deputation on (To)" of
            "Deputation on"::Branch:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "TO Branch") then begin
                    Validate("Deputation On Code To", OrganizationStructureList.Code);
                    // Validate("Branch Name To", OrganizationStructureList.Name);
                    // Validate("Province Code (To)", OrganizationStructureList."Province Code");
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
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        HrMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        LeaveMgt: Codeunit "Leave Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        SalaryLevel: Record "Salary Level";
        AttendanceSetup: Record "Attendance Setup";
        // GLSetup: Record "General Ledger Setup";
        // DimValue: Record "Dimension Value";
        // "Employee Tranfer": Record "Employee Transfer";
        SalaryLevel1: Record "Salary Level";
        EmployeeRec: Record Employee;
        ApprovalHRMS: Record "Approval HRMS";
        Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
        Error1: Label 'Cannot apply before your employment date.';
}
