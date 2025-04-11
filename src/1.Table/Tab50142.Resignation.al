table 50142 Resignation
{
    Caption = 'Resignation';
    DataClassification = CustomerContent;

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

                            //for resignation
                            Type::Resignation:
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Resignation No.");
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
                    Validate("Deputation On", EmpVar."Deputation on");
                    // Validate("Auth. Account No.", EmpVar."Bank Account No.");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    // Validate("Sub Province Code", EmpVar."Sub Province Code");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    //Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    /*VALIDATE("Compensatory Days", EmpVar."Reporting Line 1");
                    VALIDATE("Reporting Line 2 Code", EmpVar."Reporting Line 2");*/
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Province Name", EmpVar."Province Name");
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
                    Validate("Shortcut Dimension 1 Code", '');
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
                if "Start Date" <> xRec."Start Date" then begin
                    Clear("End Date");
                    Clear("End Date (BS)");
                    //Validate("No. of Days", 0);
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
                //PAGE.Run(PAGE::"Employee List");
            end;
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {

            trigger OnValidate()
            begin
                // if "Approval Status" = "Approval Status"::Screened then begin
                //     Validate("Screener Date", Today);
                //     Validate("Screener ID", HRMgt.GetEmployeeNo);
                // end;
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
        // field(24; "Employee Work Shift"; Code[10])
        // {
        //     Editable = false;
        //     TableRelation = "Employee Work Shift";
        // }
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
        field(29; "Province Name"; Code[50])
        {
            Editable = false;
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
        // }
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
                if Standardtext.Get("Reason Code") then
                    Validate("Reason Description", Standardtext.Description)
                else
                    Clear("Reason Description");
            end;
        }
        field(49; "Reason Description"; Text[50])
        {
        }
        // field(50; "Screener Remarks"; Text[100])
        // {
        // }
        field(51; "Deputation On"; Enum "Deputation Type")
        {
        }
        field(52; "Proposed Date of Resignation"; Date)
        {
            Description = 'Resignation';

            trigger OnValidate()
            begin
                if not GuiAllowed then
                    if "Proposed Date of Resignation" < Today then
                        Error(INVALID, FieldCaption("Proposed Date of Resignation"));
                ResignationMgt.UpdateResignationWaiver(Rec);
            end;
        }
        field(53; "Reason for Resignation"; Text[100])
        {
            Description = 'Resignation';
        }
        field(54; "Waiver Case"; Enum "Waiver Case")
        {
            Description = 'Resignation';
            trigger OnValidate()
            begin
                if "Waiver Case" <> xRec."Waiver Case" then begin
                    Clear("Apply for Waiver");
                    Clear("Reason for Waiver");
                end;
            end;
        }
        // field(55; "Supervisor Proposed Date"; Date)
        // {
        //     Description = 'Resignation';

        //     trigger OnValidate()
        //     begin
        //         if "Supervisor Proposed Date" < "Requested Date" then
        //             Error('Supervisor proposed date(%1) must be greater than requested date(%2)', "Supervisor Proposed Date", "Requested Date");
        //     end;
        // }
        field(56; "HR Proposed Date"; Date)
        {
            Description = 'Resignation';
        }
        field(57; "Insurance Claim"; Enum "Insurance Claim")
        {
            trigger OnValidate()
            begin
                Clear("Father Name");
                Clear("Mother Name");
                Clear("Spouse Name");
                Clear("Child Name");
                EmpRelative.Reset;
                EmpRelative.SetRange("Employee No.", "Employee No.");
                EmpRelative.SetRange("Relative Code", Format("Insurance Claim"));
                if EmpRelative.FindFirst then begin
                    case "Insurance Claim" of
                        "Insurance Claim"::Father:
                            Validate("Father Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        "Insurance Claim"::Mother:
                            Validate("Mother Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        "Insurance Claim"::Spouse:
                            Validate("Spouse Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        "Insurance Claim"::Child:
                            Validate("Child Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        else
                            Error('Please enter the family details in "Employee Relative" table.');
                    end;
                end;
            end;
        }
        field(58; "Father Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(59; "Mother Name"; Text[50])
        {
        }
        field(60; "Spouse Name"; Text[50])
        {
        }
        field(61; "Child Name"; Text[50])
        {
        }
        field(62; "Apply for Waiver"; Boolean)
        {
            Description = 'Resignation';
        }
        field(63; "Reason for Waiver"; Text[50])
        {
            Description = 'Resignation';
        }
        field(100; Status; text[50])
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
        ResignationMgt: Codeunit "Resignation Mgt";
        //LeaveTypeVar: Record "Leave Type Setup";
        //WorkShift: Record "Employee Work Shift";
        //SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        //"Employee Tranfer": Record "Employee/HR Transfer";
        //SalaryLevel1: Record "Salary Level";
        EmployeeRec: Record Employee;
        INVALID: Label 'Invalid %1';
        EmpRelative: Record "Employee Relative";
        //SystemAccessControl: Record "System Access Control";
        //AccessControlLine: Record "Access Control Request Line";
        // ProvinceVar: Record Province;
        //SubProvinceVar: Record "Sub Province";
        //DepartVar: Record Department;
        //EmpHie: Record "Employee Hierarchy Master";
        Standardtext: Record "Standard Text";
        ApproverMgt: Codeunit "Approver Mgt";
    // BranchNameTo: Text;
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
    //Overtime: Record OverTime;
    //Resignation: Record Resignation;
    //FunctionalTitle: Record "Functional Title";
    //FunctionalDescFrom: Text;
    //FunctionalDescTo: Text;
    //EmpAttendanceActivity: Record "Employee Attendance & Activity";
    //LeaveError: Label 'You cannot apply leave in Present day %1.';
    //EmpActivityRec: Record "Employee Activity";
    //Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
    //Text002: Label 'Compensatory leave has been restricted in HRMS.';
    //EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
    //PayrollGenSetup: Record "Payroll General Setup";
    //SalaryLevelRec: Record "Salary Level";
    //SalaryGrade: Record "Salary Grade";
    //EncashmentPeriodSetup: Record "OT Encashment Setup";
    //Error1: Label 'Cannot apply before your employment date.';

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

                    //for resignation
                    Type::Resignation:
                        begin
                            HRSetup.TestField("Resignation No.");
                            NoSeriesMgt.InitSeries(HRSetup."Resignation No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type);//Create Approval line from Setup Santosh 
                        end;
                end;
            end;

        // InsertAttachmentLines;
    end;

    trigger OnDelete()
    var
        ApprovalEntry: Record "Approval HRMS";
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
    // end;

    //     procedure ReopenDocument()
    //     var
    //         EmpActFilterPageBuilder: FilterPageBuilder;
    //         RecommenderCode: Code[20];
    //         ApproverCode: Code[20];
    //     begin
    //         if "Approval Status" in ["Approval Status"::Approved, "Approval Status"::Open] then
    //             Error('You cannot change Recommender and Approver of already open or approved request.');

    //         if not Confirm('Do you want to change Recommender and Approver of this request ?', false) then
    //             exit;

    //         EmpActFilterPageBuilder.AddRecord('Employee Activity', Rec);
    //         EmpActFilterPageBuilder.AddField('Employee Activity', "Recommender Code");
    //         EmpActFilterPageBuilder.AddField('Employee Activity', "Approver Code");
    //         EmpActFilterPageBuilder.RunModal;
    //         Resignation.SetView(EmpActFilterPageBuilder.GetView('Employee Activity'));
    //         RecommenderCode := Resignation.GetFilter("Recommender Code");
    //         ApproverCode := Resignation.GetFilter("Approver Code");

    //         if (RecommenderCode = '') and (ApproverCode = '') then
    //             Error('Please select either recommender or approver of the request.');

    //         if RecommenderCode <> '' then begin
    //             TestField("Approver Type", "Approver Type"::"With Recommendation");
    //             Validate("Recommender Code", RecommenderCode);
    //         end;
    //         if ApproverCode <> '' then
    //             Validate("Approver Code", ApproverCode);
    //         Modify;

    //         Message('The request has been update sucessfully.');
    //     end;

}
