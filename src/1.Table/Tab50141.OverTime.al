table 50141 OverTime
{
    Caption = 'OverTime';
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

                            //for OT
                            Type::Overtime, type::"Overtime Bulk":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."OT No.");
                                    "No. Series" := '';
                                end;

                            //for out of office
                            Type::"Out of Office":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Out of office No.");
                                    "No. Series" := '';
                                end;

                            //for bulk cash
                            Type::"Bulk Cash":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Bulk Cash No.");
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
            Editable = false;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Branch Code", EmpVar."Branch Code");
                    Validate(Department, EmpVar."Department Code");
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
                    //OTAmountCalculate();
                    // "Bank Account No." := EmpVar."Bank Account No.";
                    // "Contact No." := EmpVar."Mobile Phone No.";
                    // ValidateTransfer();
                end else begin
                    Clear("Employee Name");
                    Validate("Shortcut Dimension 1 Code", '');
                    Validate(Department, '');
                    // Validate("Auth. Account No.", '');
                    Validate("Salary Level Code", '');
                end;
                HRSetup.Get();
                Validate("OT Eligible Hours", HRSetup."OT eligible hour");

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
            var
                EmployeeAttendance: Record "Employee Attendance & Activity";
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Start Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year")
                else
                    Clear("Fiscal Year");
                if Type <> Type::Overtime then
                    EmployeeRec.Get("Employee No.");
                if "Start Date" <> 0D then begin
                    if "Start Date" < EmployeeRec."Employment Date" then
                        Error('Cannot apply before your employment date');
                end;
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Start Date");
                if EngNepDate.FindFirst then
                    Validate("Start Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Start Date (BS)");
                if type = type::Overtime then begin
                    EmployeeAttendance.Reset;
                    if EmployeeAttendance.get("Employee No.", "Start Date") then begin
                        if (EmployeeAttendance."Check In Time" = 0T) or (EmployeeAttendance."Check Out Time" = 0T) then begin
                            Error('No punch in or punch out found.');
                        end
                        else begin
                            Validate("Check In Time", EmployeeAttendance."Check In Time");
                            Validate("Check Out Time", EmployeeAttendance."Check Out Time");
                        end;
                    end else
                        Error('No Attendance Found on %1', rec."Start Date");
                    OverTimeMgt.CheckOvertime(Rec);
                    if "Start Date" <> xRec."Start Date" then begin
                        Clear("Overtime Claim Type");
                        Clear("End Date");
                    end;
                end;
            end;
        }
        field(8; "Check In Time"; Time)
        {
            // DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Check Out Time"; Time)
        {
            // DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("Start Date");
                if "Start Date" > "End date" then
                    Error('Invalid date.');
                if "End date" > "Start Date" + 32 then // 32 days is the maximum range for Nepali date conversion
                    Error('Date range exceed');
                OverTimeMgt.CheckForExistingDate(Rec);
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "End Date");
                if EngNepDate.FindFirst then
                    Validate("End Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("End Date (BS)");
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
            Editable = false;
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(12; "Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(26; "End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(13; "Branch Code"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[100])
        {
            // trigger OnLookup()
            // begin
            // PAGE.Run(PAGE::"Employee List");
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
        field(23; "Overtime Claim Type"; Enum "Overtime Claim Type")
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestField("Start Date");
                if "Overtime Claim Type" <> xRec."Overtime Claim Type" then begin
                    Clear("Compensatory Days");
                    Clear("OT Amount");
                end;
                AttendanceSetup.Get();
                AttendanceSetup.TestField("Full Substitute Leave Hrs");
                AttendanceSetup.TestField("Half Substitute Leave Hrs");
                if "Overtime Claim Type" = "Overtime Claim Type"::"Substitute Leave" then begin
                    OverTimeMgt.CheckOvertime(Rec);
                    if ("Actual OT Hours" < AttendanceSetup."Full Substitute Leave Hrs") and ("Actual OT Hours" >= AttendanceSetup."Half Substitute Leave Hrs") then
                        "Compensatory Days" := 0.5
                    else if "Actual OT Hours" >= AttendanceSetup."Full Substitute Leave Hrs" then
                        "Compensatory Days" := 1
                    else if "Actual OT Hours" < AttendanceSetup."Half Substitute Leave Hrs" then
                        "Compensatory Days" := 0;
                    Clear("OT Amount");
                end else if "Overtime Claim Type" = "Overtime Claim Type"::Encashment then begin
                    OnBeforeOTAmountCalculate(Rec, IsHandled);
                    if not IsHandled then
                        if Type in [Type::Overtime, Type::"Out of Office", Type::"Bulk Cash"] then begin
                            if "Start Date" >= Today then
                                Error('You cannot apply OverTime in current and future date.');
                            // Validate("End Date", "Start Date");
                            //Add Control for OverTime and OverTime Request is Allowed for already attendance date <<santosh<< /3/17/2025/<<
                            // OverTimeMgt.CheckOvertime(Rec);
                            Validate("OT Amount", OverTimeMgt.OTAmountCalculate("Employee No.", "Start Date", "Encashment Code", "Actual OT Hours")); //Calculate OverTime amount << Santosh << 3/17/2025/
                        end;
                    Clear("Compensatory Days");
                end;
            end;
        }
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
            Editable = false;
            // TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));
        }
        field(29; "Province Name"; Code[50])
        {
            Editable = false;
        }
        field(30; "Province Code"; Code[20])
        {
            Editable = false;
        }
        field(31; "Unit Code"; Code[20])
        {
            Editable = false;
            // TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST(Unit));
        }
        field(32; "Compensatory Days"; Decimal)
        {
            Editable = false;
        }
        field(33; "Payroll No."; Code[20])
        {
            Editable = false;
        }
        // field(34; Ecosystem; Code[20])
        // {
        // }
        // field(35; "Office Code"; Code[20])
        // {
        // }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
        // field(38; "Approver Type"; Enum "Approver Type")
        // {
        //     Editable = false;
        // }
        field(39; Cancelled; Boolean)
        {
        }
        // field(40; "Cancelled No."; Code[20])
        // {
        // }
        // field(41; "Cancelled Document No."; Code[20])
        // {
        //     Editable = false;
        //  }
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
        // field(50; "Screener Remarks"; Text[100])
        // {
        // }
        field(106; "Time Duration"; Duration) { }
        field(51; "Estimated Hours"; Decimal)
        {
        }

        field(52; "Actual OT Hours"; Decimal)
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "Estimated Hours" <> 0 then
                    if "Estimated Hours" < HRSetup."OT eligible hour" then
                        Error('You cannot submit overtime less than %1 hour(s).', HRSetup."OT eligible hour");
            end;
        }
        // field(53; "HR Proposed Date"; Date)
        // {
        //     Description = 'Resignation';
        // }
        field(54; "Encashment Code"; Code[30])
        {
            TableRelation = "OT Encashment Setup";

            trigger OnValidate()
            begin
                /*IF EncashmentPeriodSetup.GET("Encashment Code") THEN
                  "Encashment Period" := EncashmentPeriodSetup.Period
                ELSE
                  CLEAR("Encashment Period");*/

            end;
        }
        field(55; "OT Amount"; Decimal)
        {
            Editable = false;
        }
        field(56; "OT Disbursed"; Boolean)
        {
        }
        field(57; "Updated Payroll Line"; Boolean)
        {
        }
        field(58; "OT Eligible Hours"; Decimal)
        {
            Editable = false;
        }
        field(59; "Morning OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(60; "Evening OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(61; "Total OT Hours"; Decimal)
        {
            Editable = false;
        }
        field(62; "Deputation Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = if ("Deputation Type" = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Organization Structure list"::Branch), Blocked = filter(false))
            else if ("Deputation Type" = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure Line"."Reporting Code" where(Type = Filter("Organization Structure list"::"Branch"), Code = field("Branch Code"), "Reporting Type" = filter("Organization Structure list"::"Extension Counter"));

            trigger OnValidate()
            begin
                // CheckLineExist();
                // GLsetup.Get;
                Clear("Deputation Name");
                if not GuiAllowed then
                    Employee.Get(HrMgt.GetEmployeeNo())
                else
                    Employee.Get("Employee No.");
                if "Deputation Type" = "Deputation Type"::Branch then begin
                    if "Deputation Code" <> '' then
                        TestField("Deputation Code", Employee."Branch Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Deputation Code") then
                        "Deputation Name" := OrganizationStructureList.Name;
                end else if "Deputation Type" = "Deputation Type"::"Extension Counter" then begin
                    if "Deputation Code" <> '' then
                        // TestField(Code, Employee."Extension Counter Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Deputation Code") then
                            "Deputation Name" := OrganizationStructureList.Name;
                end;
                //GetApprover();
                // CheckForSameWeek;
            end;
        }
        field(63; "Deputation Name"; Text[100])
        {
            Editable = false;
        }
        field(64; "Deputation Type"; Enum "Deputation Type")
        {
            ValuesAllowed = Branch, Department;
            trigger OnValidate()
            begin
                if "Deputation Type" = "Deputation Type"::Branch then
                    Validate("Deputation Code", "Branch Code")
            end;
        }
        field(65; "Get Employee"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(66; "Calculate Overtime"; Boolean)
        {
            DataClassification = ToBeClassified;

        }

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

                    //for overtime
                    Type::Overtime, type::"Overtime Bulk":
                        begin
                            HRSetup.TestField("OT No.");
                            NoSeriesMgt.InitSeries(HRSetup."OT No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");//Create Approval line from Setup Santosh 
                        end;

                    //for out of office
                    Type::"Out of Office":
                        begin
                            HRSetup.TestField("Out of office No.");
                            NoSeriesMgt.InitSeries(HRSetup."Out of office No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for bulk cash
                    Type::"Bulk Cash":
                        begin
                            HRSetup.TestField("Bulk Cash No.");
                            NoSeriesMgt.InitSeries(HRSetup."Bulk Cash No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;
                end;
            end;

        //InsertAttachmentLines;
    end;

    trigger OnDelete()
    var
        ApprovalEntry: Record "Approval HRMS";
        CannotDelete: Label 'Cannot delete document.';
        OverTimeLine: Record "Overtime Line";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
            OverTimeLine.SetRange("No.", "No.");
            OverTimeLine.DeleteAll();
        end;
    end;
    // local procedure InsertAttendanceMissedAttachment()
    // var
    //     AttachmentMandatory: Record "Attachment Setup";
    //     IncomingDocument: Record "Incoming Document";
    // begin
    //     AttachmentMandatory.Reset;
    //     AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::"Attendance Missed");
    //     if AttachmentMandatory.FindFirst then
    //         repeat
    //             Clear(IncomingDocument);
    //             IncomingDocument.Reset;
    //             IncomingDocument.SetRange("Table ID", DATABASE::"Employee Activity");
    //             IncomingDocument.SetRange("No.", "No.");
    //             IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
    //             if not IncomingDocument.FindFirst then begin
    //                 IncomingDocument.Reset;
    //                 IncomingDocument.Init;
    //                 IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
    //                 IncomingDocument.Description := Rec.TableName;
    //                 IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
    //                 IncomingDocument."No." := "No.";
    //                 IncomingDocument."Employee Code" := "Employee No.";
    //                 IncomingDocument."Table ID" := DATABASE::"Employee Activity";
    //                 IncomingDocument.Insert(true);
    //             end;
    //         until AttachmentMandatory.Next = 0;
    ///end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeOTAmountCalculate(Var Overtime: Record OverTime; var IsHandled: Boolean)
    begin
    end;

    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        OverTimeMgt: Codeunit "OverTime Mgt";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        EmployeeRec: Record Employee;
        Text002: Label 'Compensatory leave has been restricted in HRMS.';
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        PayrollGenSetup: Record "Payroll General Setup";
        SalaryLevelRec: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        ApproverMgt: Codeunit "Approver Mgt";
        IsHandled: Boolean;
        AttendanceSetup: Record "Attendance Setup";
        HrMgt: Codeunit "HR Mgt.";
        OrganizationStructureList: Record "Organization Structure List";
        Employee: Record Employee;

}
