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
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    // Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Branch Code", EmpVar."Branch Code");
                    // Validate("Deputation On", EmpVar."Deputation on");
                    // Validate("Auth. Account No.", EmpVar."Bank Account No.");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    // Validate("Sub Province Code", EmpVar."Sub Province Code");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    /*VALIDATE("Compensatory Days", EmpVar."Reporting Line 1");
                    VALIDATE("Reporting Line 2 Code", EmpVar."Reporting Line 2");*/
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Province Name", EmpVar."Province Name");
                    // Validate(Ecosystem, EmpVar."Eco-System");
                    // Validate("Office Code", EmpVar.Office);
                    // if Type = Type::Overtime then begin //Min 11.18.2022
                    //     if "Start Date" > 20221207D then begin
                    //         PayrollGenSetup.Get;
                    //         if EmployeeAttendanceActivity.Get("Employee No.", "Start Date") then begin
                    //             SalaryLevelRec.Get(EmployeeAttendanceActivity."Salary Level Code");
                    //             SalaryGrade.Get(EmployeeAttendanceActivity."Salary Grade");
                    //         end;
                    //     end;
                    // end;
                    // if not (Type in [Type::"Employee Transfer", Type::"HR Transfer"]) then begin
                    //     Validate("Recommender Code", EmpVar."KPI Deputation Value");
                    //     Validate("Recommender Name", EmpVar."Recommender Name");
                    //     Validate("Approver Code", EmpVar."Approver Code");
                    //     Validate("Approver Name", EmpVar."Approver Name");
                    // end;
                    // "Bank Account No." := EmpVar."Bank Account No.";
                    // "Contact No." := EmpVar."Mobile Phone No.";

                    // ValidateTransfer();
                end else begin
                    Clear("Employee Name");
                    // Validate("Shortcut Dimension 1 Code", '');
                    Validate(Department, '');
                    // Validate("Auth. Account No.", '');
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
                // //>>check for leave
                // if Type = Type::"Leave Request" then begin
                //     if EmployeeRec."Contract Expiry Date" <> 0D then
                //         if "Start Date" > EmployeeRec."Contract Expiry Date" then
                //             Error('Cannot apply leave after contract expiry date');
                //     EmpAttendanceActivity.Reset; //Min 4.11.2022
                //     EmpAttendanceActivity.SetRange("Employee No.", "Employee No.");
                //     EmpAttendanceActivity.SetFilter("Attendance Date", '%1..%2', "Start Date", "End Date");
                //     if EmpAttendanceActivity.FindFirst then
                //         repeat
                //             if EmpAttendanceActivity."Present Day" = 1 then
                //                 Error(LeaveError, EmpAttendanceActivity."Attendance Date");
                //         until EmpAttendanceActivity.Next = 0;
                // end;
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
                    // Validate("No. of Days", 0);
                end;

                //Min 4.26.2022 -- Check for Missed Attendance.
                if Type = Type::"Attendance Missed" then begin
                    MissedAttendanceRec.Reset;
                    MissedAttendanceRec.SetRange("Employee No.", "Employee No.");
                    MissedAttendanceRec.SetRange(Type, MissedAttendanceRec.Type::"Attendance Missed");
                    MissedAttendanceRec.SetRange("Start Date", Rec."Start Date");
                    MissedAttendanceRec.SetFilter("Approval Status", '<>%1', MissedAttendanceRec."Approval Status"::Rejected);
                    if MissedAttendanceRec.FindFirst then
                        Error('Missed Attendance already applied for date %1', Rec."Start Date");
                end;
                Validate("End Date", "Start Date");

            end;
        }
        field(8; "End Date"; Date)
        {
            trigger OnValidate()
            var
                LeaveMgt: Codeunit "Leave Mgt.";
                leaveType: Enum "Leave Type";
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
                // if "End Date" <> 0D then
                //     Validate("No. of Days", "End Date" - "Start Date" + 1)
                // else begin
                //     Clear("End Date (BS)");
                //     Clear("No. of Days");
                // end;
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
        }
        field(13; "End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[100])
        {

            trigger OnValidate()
            begin
                Clear("Rejection Remarks");
            end;
        }
        // field(15; "User ID"; Text[50])
        // {
        //     Editable = false;
        //     TableRelation = "User Setup"."User ID";
        // }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            // trigger OnValidate()
            // begin
            //     if "Approval Status" = "Approval Status"::Approved then
            //         if Type = Type::Resignation then begin
            //             EmployeeRec.Get("Employee No.");
            //             EmployeeRec.Validate("Resignation Date", "HR Proposed Date");
            //             // EmployeeRec.VALIDATE(Status,EmployeeRec.Status::Inactive);
            //             EmployeeRec.Modify;
            //         end;
            //     if "Approval Status" = "Approval Status"::Screened then begin
            //         Validate("Screener Date", Today);
            //         Validate("Screener ID", HRMgt.GetEmployeeNo);
            //     end;
            //     if "Approval Status" = "Approval Status"::"Final Approved & Forwarded to Finance Department" then begin
            //         Validate("Final Approver Date", Today);
            //         Validate("Final Approver", HRMgt.GetEmployeeNo);
            //     end;
            // end;
        }
        field(17; "Branch Code"; Code[20])
        {
            // CaptionClass = '1,2,1';
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
            // TableRelation = Department;

            // trigger OnValidate()
            // var
            //     DeptVar: Record Department;
            // begin
            //     if DeptVar.Get(Department) then
            //         Validate("Department Name", DeptVar.Name)
            //     else
            //         Clear("Department Name");
            // end;
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
        // field(22; "Recommender Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Recommender Code", EmpVar."No.") = 0 then
        //                 Validate("Recommender Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Recommender Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Recommender.');
        //         HRMgt.GetEmployeeName("Recommender Code", "Recommender Name");
        //         if "Recommender Code" = '' then
        //             Validate("Approver Type", "Approver Type"::Direct)
        //         else
        //             Validate("Approver Type", "Approver Type"::"With Recommendation");
        //         //requirement not fixed
        //         if "Recommender Code" <> '' then begin
        //             if Type <> Type::Overtime then //Min 8.25.2022
        //                 if "Recommender Code" = "Approver Code" then
        //                     Error('Recommender and Approver cannot be same person.');
        //             EmployeeRec.Get("Recommender Code");
        //             if SalaryLevel.Get("Salary Level Code") then;
        //             if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //             if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                 Error('Salary level of recommender (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
        //         end;
        //     end;
        // }
        // field(23; "Approver Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Approver Code", EmpVar."No.") = 0 then
        //                 Validate("Approver Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Approver Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Approver.');
        //         //requirement not fixed
        //         HRMgt.GetEmployeeName("Approver Code", "Approver Name");
        //         if "Approver Code" <> '' then begin
        //             HRSetup.Get;
        //             if EmployeeRec.Get("Recommender Code") then;
        //             if Type = Type::Resignation then begin
        //                 if not (EmployeeRec."Functional Title" = HRSetup."HR Head Functional Title") then
        //                     if "Recommender Code" = "Approver Code" then
        //                         Error('Recommender and Approver cannot be same person.');
        //             end else
        //                 if Type <> Type::Overtime then //Min 8.25.2022
        //                     if "Recommender Code" = "Approver Code" then
        //                         Error('Recommender and Approver cannot be same person.');

        //             EmployeeRec.Get("Approver Code");
        //             HRSetup.Get;
        //             if EmployeeRec."Functional Title" <> HRSetup."HR Head Functional Title" then begin
        //                 if SalaryLevel.Get("Salary Level Code") then;
        //                 if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //                 if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                     Error('Salary level of approver (%1) must be greater than salary level of employee (%2).', EmployeeRec."Full Name", "Employee Name");
        //             end;
        //         end;
        //     end;
        // }
        field(24; "Employee Work Shift"; Code[10])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        // field(26; "Recommender Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(27; "Approver Name"; Text[50])
        // {
        //     Editable = false;
        // }
        field(28; "Extension Counter Code"; Code[20])
        {
            // TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));
        }
        field(29; "province Name"; Code[50])
        {
            // TableRelation = "Sub Province".Code;
        }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = Province;
        }
        field(31; "Unit Code"; Code[20])
        {
            // TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST(Unit));
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
        }
        field(37; "Approved Date"; Date)
        {
        }
        // field(38; "Approver Type"; Option)
        // {
        //     Editable = false;
        //     OptionCaption = ' ,Direct,With Recommendation';
        //     OptionMembers = " ",Direct,"With Recommendation";
        // }
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
        // field(42; "Screener ID"; Code[20])
        // {
        //     Editable = false;

        //     trigger OnValidate()
        //     begin
        //         if EmployeeRec.Get("Screener ID") then
        //             Validate("Screener Name", EmployeeRec."Full Name")
        //         else
        //             Clear("Screener Name");
        //     end;
        // }
        // field(43; "Screener Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(44; "Screener Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(45; "Final Approver"; Code[20])
        // {
        //     Editable = false;
        //     TableRelation = Employee;

        //     trigger OnValidate()
        //     begin
        //         if EmployeeRec.Get("Final Approver") then
        //             Validate("Final Approver Name", EmployeeRec."Full Name")
        //         else
        //             Clear("Final Approver Name");
        //     end;
        // }
        // field(46; "Final Approver Name"; Text[50])
        // {
        //     Description = 'S';
        //     Editable = false;
        // }
        // field(47; "Final Approver Date"; Date)
        // {
        //     Editable = false;
        // }
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
        field(49; "Reason Description"; Text[50])
        {
        }
        // field(148; "HR Proposed Date"; Date)
        // {
        //     Description = 'Resignation';
        // }
        // field(50; "Leave Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Leave Type Setup";
        //     trigger OnValidate()

        //     begin
        //         if "Leave Code" <> xRec."Leave Code" then begin
        //             if LeaveTypeVar.Get("Leave Code") then begin
        //                 Validate("Leave Description", LeaveTypeVar.Description);
        //                 Validate("Start Date", 0D);
        //             end else begin
        //                 Clear("Leave Description");
        //             end;

        //             // Clear("Contact No."); //nilesh
        //         end;
        //     end;

        // }
        // field(51; "Leave Description"; Text[50])
        // {
        //     Editable = false;
        // }
        field(100; Status; text[20])
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
    trigger OnInsert()
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                NoSeriesMgt.InitSeries(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");

            end else begin
                case Type of
                    //for leave
                    Type::"Leave Request":
                        begin
                            HRSetup.TestField("Leave No. Series");
                            NoSeriesMgt.InitSeries(HRSetup."Leave No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type);
                            //if HRSetup."Approval From Setup" then
                            // InsertApproval();
                        end;
                    Type::"Attendance Missed":
                        begin
                            HRSetup.TestField("Attendance Missed No.");
                            NoSeriesMgt.InitSeries(HRSetup."Attendance Missed No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type);
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
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        LeaveTypeVar: Record "Leave Type Setup";
        //WorkShift: Record "Employee Work Shift";
        SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        EmpAct: Record "Employee Activity";
        SalaryLevel1: Record "Salary Level";
        EmployeeRec: Record Employee;
        //INVALID: Label 'Invalid %1';
        // EmpRelative: Record "Employee Relative";
        // SystemAccessControl: Record "System Access Control";
        // AccessControlLine: Record "Access Control Request Line";
        // ProvinceVar: Record Province;
        // SubProvinceVar: Record "Sub Province";
        // DepartVar: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        StandardText: Record "Standard Text";
        // BranchNameTo: Text;
        // DepartmentNameTo: Text;
        // ProvinceNameTo: Text;
        // SubProvinceNameTo: Text;
        // ExtensionNameTo: Text;
        // UnitNameTo: Text;
        // BranchName: Text;
        // DepartmentName: Text;
        // ProvinceName: Text;
        // SubProvinceName: Text;
        // ExtensionName: Text;
        // UnitName: Text;
        // FunctionalTitle: Record "Functional Title";
        // FunctionalDescFrom: Text;
        // FunctionalDescTo: Text;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
        LeaveError: Label 'You cannot apply leave in Present day %1.';
        // EmpActivityRec: Record "Employee Activity";
        MissedAttendanceRec: Record "Cancel Document";
        //Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
        //Text002: Label 'Compensatory leave has been restricted in HRMS.';
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        PayrollGenSetup: Record "Payroll General Setup";
        SalaryLevelRec: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        ApprovalEntry: Record "Approval HRMS";
        ApproverMgt: Codeunit "Approver Mgt";


    //EncashmentPeriodSetup: Record "OT Encashment Setup";
    //Error1: Label 'Cannot apply before your employment date.';

}
