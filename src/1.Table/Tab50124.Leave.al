table 50124 Leave
{
    Caption = 'Leave';
    DataClassification = CustomerContent;
    //Field 1, 16, 100 are used in ApprovalMgt Codeunit as field Ref
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
                    Validate("Sub Province Code", EmpVar."Sub Province Code");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate(Ecosystem, EmpVar."Eco-System");
                    Validate("Office Code", EmpVar.Office);
                    Validate("Deputation On", EmpVar."Deputation on");
                    Validate("Contact No.", EmpVar."Mobile Phone No.");
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
                    EmpAttendanceActivity.Reset; //Min 4.11.2022
                    EmpAttendanceActivity.SetRange("Employee No.", "Employee No.");
                    EmpAttendanceActivity.SetFilter("Attendance Date", '%1..%2', "Start Date", "End Date");
                    if EmpAttendanceActivity.FindFirst then
                        repeat
                            if EmpAttendanceActivity."Present Day" = 1 then
                                Error(LeaveError, EmpAttendanceActivity."Attendance Date");
                        until EmpAttendanceActivity.Next = 0;
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
                    // Validate("No. of Days", 0);
                end;
            end;
        }
        field(8; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "End Date");
                if EngNepDate.FindFirst then
                    Validate("End Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("End Date (BS)");
                if Type = Type::"Leave Request" then
                    TestField("Leave Code");
                if "End Date" <> 0D then
                    Validate("No. of Days", leaveMgt.CalculateNoOfDays("Start Date", "End Date", "Leave Code", Type, "Leave Type", "Employee No."))
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
            var
                HalfLeaveError: Label 'Half Leaves cannot be applied in multiple days.';
            begin
                if GuiAllowed then
                    leaveMgt.GenerateLeaveAttachment(rec);
                if "No. of Days" <= 0 then
                    Error('No of Days Cannot be zero');
                if not Cancelled then
                    if (Type = Type::"Leave Request") and ("End Date" <> 0D) then begin
                        leaveMgt.CheckForLimitDays("Leave Code", "No. of Days");
                        if LeaveTypeVar.Get("Leave Code") then;
                        if not LeaveTypeVar.Compensatory then
                            leaveMgt.CheckLeaveConflict("Employee No.", "Start Date", "End Date");
                        leaveMgt.CheckForLeaveCriteria("Leave Code", "Start Date", "End Date", "Employee No.", "No. of Days");
                        leaveMgt.CheckForMulipleRequest("Leave Code", "Employee No.", "Start Date", "End Date", "No. of Days");
                    end;
                case "Leave Type" of
                    "Leave Type"::"First Half":
                        begin
                            if "Start Date" <> "End Date" then
                                Error(HalfLeaveError)
                        end;
                    "Leave Type"::"Second Half":
                        begin
                            if "Start Date" <> "End Date" then
                                Error(HalfLeaveError)
                        end;
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

        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
            trigger OnValidate()
            begin
                // if "Approval Status" = "Approval Status"::Approved then
                //     if "Approval Status" = "Approval Status"::Screened then begin
                //         Validate("Screener Date", Today);
                //         Validate("Screener ID", HRMgt.GetEmployeeNo);
                //     end;
                // if "Approval Status" = "Approval Status"::"Final Approved & Forwarded to Finance Department" then begin
                //     Validate("Final Approver Date", Today);
                //     Validate("Final Approver", HRMgt.GetEmployeeNo);
                // end;
            end;
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
            TableRelation = Department;

            trigger OnValidate()
            var
                DeptVar: Record Department;
            begin
                if DeptVar.Get(Department) then
                    Validate("Department Name", DeptVar.Name)
                else
                    Clear("Department Name");
            end;
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
            TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));
        }
        field(29; "Sub Province Code"; Code[20])
        {
            TableRelation = "Sub Province".Code;
        }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = Province;
        }
        field(31; "Unit Code"; Code[20])
        {
            TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST(Unit));
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
        // field(48; "Reason Code"; Code[20])
        // {
        //     TableRelation = "Standard Text" WHERE("Employee Activity Type" = FIELD(Type));

        //     trigger OnValidate()
        //     begin
        //         if Standardtext.Get("Reason Code") then
        //             Validate("Reason Description", Standardtext.Description)
        //         else
        //             Clear("Reason Description");
        //     end;
        // }
        // field(49; "Reason Description"; Text[50])
        // {
        // }
        field(50; "Contact No."; Text[50])
        {
        }
        field(51; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";

            trigger OnValidate()
            begin
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
                /*IF "Leave Code" = 'COMPENSATORY' THEN //Min 8.7.2022
                  ERROR(Text002);*/

            end;
        }
        field(52; "Leave Description"; Text[50])
        {
            Editable = false;
        }
        field(53; "Leave Type"; Enum "Leave Type")
        {

            trigger OnValidate()
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
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        LeaveTypeVar: Record "Leave Type Setup";
        WorkShift: Record "Employee Work Shift";
        SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        //Leave: Record "Leave";
        //SalaryLevel1: Record "Salary Level";
        EmployeeRec: Record Employee;
        //INVALID: Label 'Invalid %1';
        //EmpRelative: Record "Employee Relative";
        //SystemAccessControl: Record "System Access Control";
        //AccessControlLine: Record "Access Control Request Line";
        //ProvinceVar: Record Province;
        //SubProvinceVar: Record "Sub Province";
        //DepartVar: Record Department;
        //EmpHie: Record "Employee Hierarchy Master";
        //Standardtext: Record "Standard Text";
        //BranchNameTo: Text;
        //DepartmentNameTo: Text;
        //ProvinceNameTo: Text;
        //SubProvinceNameTo: Text;
        //ExtensionNameTo: Text;
        //UnitNameTo: Text;
        //BranchName: Text;
        //DepartmentName: Text;
        //ProvinceName: Text;
        //SubProvinceName: Text;
        //ExtensionName: Text;
        //UnitName: Text;
        //FunctionalTitle: Record "Functional Title";
        //FunctionalDescFrom: Text;
        //FunctionalDescTo: Text;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
        LeaveError: Label 'You cannot apply leave in Present day %1.';
        //EmpActivityRec: Record "Employee Activity";
        //Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
        //Text002: Label 'Compensatory leave has been restricted in HRMS.';
        //EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        //PayrollGenSetup: Record "Payroll General Setup";
        //SalaryLevelRec: Record "Salary Level";
        //SalaryGrade: Record "Salary Grade";
        //EncashmentPeriodSetup: Record "OT Encashment Setup";
        //Error1: Label 'Cannot apply before your employment date.';
        leaveMgt: Codeunit "Leave Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalEntry: Record "Approval HRMS";

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
                        end;
                end;
            end;

    end;

    trigger OnDelete()
    var

    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        ApprovalEntry.DeleteAll();

    end;

    procedure AssistEdit(OldLeave: Record "Leave"): Boolean
    var
        Leave: Record "Leave";
    begin
        HRSetup.Get;
        Leave := Rec;
        if Leave.Cancelled then begin
            HRSetup.TestField("Cancel Document No. Series");
            if NoSeriesMgt.SelectSeries(HRSetup."Cancel Document No. Series", OldLeave."No. Series", Leave."No. Series") then begin
                NoSeriesMgt.SetSeries(Leave."No.");
                Rec := Leave;
                exit(true);
            end;
        end else begin
            case Leave.Type of
                //change in employee
                Leave.Type::"Changes in employee":
                    begin
                        HRSetup.TestField("Employee Change No. Series");
                        if NoSeriesMgt.SelectSeries(HRSetup."Employee Change No. Series", OldLeave."No. Series", Leave."No. Series") then begin
                            NoSeriesMgt.SetSeries(Leave."No.");
                            Rec := Leave;
                            exit(true);
                        end;
                    end;

                //for leave
                Leave.Type::"Leave Request":
                    begin
                        HRSetup.TestField("Leave No. Series");
                        if NoSeriesMgt.SelectSeries(HRSetup."Leave No. Series", OldLeave."No. Series", Leave."No. Series") then begin
                            NoSeriesMgt.SetSeries(Leave."No.");
                            Rec := Leave;
                            exit(true);
                        end;
                    end;
            end;
        end;
    end;

    // local procedure InsertLeaveApprovalStatus()
    // var
    //     ApprovalSetupLine: Record "Approval Setup line";
    // begin
    //     ApprovalSetupLine.Reset();
    //     ApprovalSetupLine.SetRange("Request Type", Type::"Leave Request");
    //     ApprovalSetupLine.SetRange("Deputation On", "Deputation On");
    //     ApprovalSetupLine.SetRange("Approval Sequence", 1);
    //     if ApprovalSetupLine.FindFirst() then
    //         Status := ApprovalSetupLine."Approval Status";
    // end;
    // procedure ReopenDocument()
    // var
    //     EmpActFilterPageBuilder: FilterPageBuilder;
    //     RecommenderCode: Code[20];
    //     ApproverCode: Code[20];
    // begin
    //     if "Approval Status" in ["Approval Status"::Approved, "Approval Status"::Open] then
    //         Error('You cannot change Recommender and Approver of already open or approved request.');

    //     if not Confirm('Do you want to change Recommender and Approver of this request ?', false) then
    //         exit;

    //     EmpActFilterPageBuilder.AddRecord('Leave', Rec);
    //     EmpActFilterPageBuilder.ADdField('Leave', "Recommender Code");
    //     EmpActFilterPageBuilder.ADdField('Leave', "Approver Code");
    //     EmpActFilterPageBuilder.RunModal;
    //     Leave.SetView(EmpActFilterPageBuilder.GetView('Leave'));
    //     RecommenderCode := Leave.GetFilter("Recommender Code");
    //     ApproverCode := Leave.GetFilter("Approver Code");

    //     if (RecommenderCode = '') and (ApproverCode = '') then
    //         Error('Please select either recommender or approver of the request.');

    //     if RecommenderCode <> '' then begin
    //         TestField("Approver Type", "Approver Type"::"With Recommendation");
    //         Validate("Recommender Code", RecommenderCode);
    //     end;
    //     if ApproverCode <> '' then
    //         Validate("Approver Code", ApproverCode);
    //     Modify;

    //     Message('The request has been update sucessfully.');
    // end;

    // local procedure InsertApproval()
    // var
    //     ApprovalSetupLine: Record "Approval Setup line";
    //     Approval: Record "Approval HRMS";
    //     Employee: Record Employee;
    //     EmpRequest: Record Employee;
    //     Approval1: Record "Approval HRMS";
    //     count: Integer;
    // begin
    //     EmpRequest.Reset();
    //     EmpRequest.Get("Employee No.");
    //     ApprovalSetupLine.Reset();
    //     ApprovalSetupLine.SetRange("Request Type", ApprovalSetupLine."Request Type"::"Leave Request");
    //     ApprovalSetupLine.SetRange("Deputation On", "Deputation On");
    //     count := 0;
    //     if ApprovalSetupLine.Findset() then
    //         repeat
    //             Employee.Reset();
    //             Employee.SetRange("Deputation On", ApprovalSetupLine."Deputation On");
    //             if "Deputation On" = "Deputation On"::Branch then
    //                 Employee.SetRange("Global Dimension 1 Code", EmpRequest."Global Dimension 1 Code")
    //             else if "Deputation On" = "Deputation On"::Department then
    //                 Employee.SetRange("Department Code", EmpRequest."Department Code")
    //             else if "Deputation On" = "Deputation On"::Province then
    //                 Employee.SetRange("Province Code", EmployeeRec."Province Code");
    //             Employee.SetRange("Approver Role", ApprovalSetupLine."Approver Role");
    //             if Employee.FindFirst() then begin
    //                 Approval.Init();
    //                 Approval.Validate("Document No.", "No.");
    //                 Approval.Validate("Document Type", Approval."Document Type"::"Leave Request");
    //                 Approval.Validate("Approver No", Employee."No.");
    //                 Approval.Validate("Approval Sequence", ApprovalSetupLine."Approval Sequence");
    //                 if ApprovalSetupLine."Approval Sequence" = 1 then begin
    //                     Approval.Validate("Approval Status", "Approval Status"::Open);
    //                     count := count + 1;
    //                 end else
    //                     Approval.Validate("Approval Status", "Approval Status"::Created);
    //                 Approval.Validate("Employee No", "Employee No.");
    //                 Approval.Insert(true);
    //             end;
    //         until ApprovalSetupLine.Next() = 0
    //     else
    //         Error('Approval Setup not found');
    //     if count = 0 then begin
    //         Error('There is no approver setup for sequence 1');
    //     end;
    //     Approval1.Reset();
    //     Approval1.SetRange("Document No.", "No.");
    //     if not Approval1.FindFirst() then
    //         Error('Approval Not Found');
    // end;

}
