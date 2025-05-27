table 50143 "Medical Insurance Claim"
{
    Caption = 'Medical Insurance Claim';
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

                            //for medical insurance claim
                            Type::"Medical Insurance Claim":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Medical Insurance No.");
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
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Bank Account No.", EmpVar."Bank Account No.");
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
                    Validate("No. of Days", 0);
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
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin

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
            Editable = false;
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
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
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
        field(50; "Insurance Claim"; Enum "Insurance Claim")
        {
            trigger OnValidate()
            begin
                Clear("Father Name");
                Clear("Mother Name");
                Clear("Spouse Name");
                Clear("Child Name");
                if "Insurance Claim" <> "Insurance Claim"::"General Checkup" then begin
                    EmpRelative.Reset;
                    EmpRelative.SetRange("Employee No.", "Employee No.");
                    EmpRelative.SetRange("Relative Code", Format("Insurance Claim"));
                    if EmpRelative.FindFirst then begin
                        case "Insurance Claim" of
                            "Insurance Claim"::Father:
                                Validate("Father Name", EmpRelative."Full Name");
                            "Insurance Claim"::Mother:
                                Validate("Mother Name", EmpRelative."Full Name");
                            "Insurance Claim"::Spouse:
                                Validate("Spouse Name", EmpRelative."Full Name");
                            "Insurance Claim"::Child:
                                Validate("Child Name", EmpRelative."Full Name");
                            else
                                Error('Please enter the family details in "Employee Relative" table.');
                        end;
                    end;
                end;
            end;
        }
        field(51; "Father Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(52; "Mother Name"; Text[50])
        {
        }
        field(53; "Spouse Name"; Text[50])
        {
        }
        field(54; "Child Name"; Text[50])
        {
        }
        field(55; "Total Insurance Claim Amount"; Decimal)
        {
        }
        field(56; "Medical Prescription Date"; Date)
        {
        }
        field(57; "Discharge Date"; Date)
        {
        }
        field(58; "Bank Account No."; Text[30])
        {
        }
        field(59; "Contact No."; Text[30])
        {
        }
        field(60; "Insurance Status"; Enum "Insurance Status")
        {
            Editable = false;
        }
        field(100; Status; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Status Master";
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
        if not GuiAllowed then begin
            Validate("Employee No.", Hrmgt.GetEmployeeNo());
            "Approval Status" := "Approval Status"::Pending;
            Validate(Type, Rec.Type::"Medical Insurance Claim");
        end;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                NoSeriesMgt.InitSeries(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of
                    //for medical insurance claim
                    Type::"Medical Insurance Claim":
                        begin
                            HRSetup.TestField("Medical Insurance No.");
                            NoSeriesMgt.InitSeries(HRSetup."Medical Insurance No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");//Create Approval line from Setup Santosh 
                        end;
                end;
            end;
        if GuiAllowed then begin
            AttachmentSetup.Reset;
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Medical Insurance Claim");
            if AttachmentSetup.Find('-') then
                repeat
                    IncomingDoc.Init;
                    IncomingDoc.Validate("No.", "No.");
                    IncomingDoc.Validate("Table ID", Database::"Medical Insurance Claim");
                    IncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                    IncomingDoc.Validate("Employee Code", "Employee No.");
                    IncomingDoc.Validate("Employee Activity Type", IncomingDoc."Employee Activity Type"::"Medical Insurance Claim");
                    IncomingDoc."Entry No." := IncomingDoc.GetEntryNo();
                    IncomingDoc.Insert;
                until AttachmentSetup.Next = 0;
        end;
        if not GuiAllowed then begin
            InsuranceMgt.SendMedicalInsuranceApproval(Rec)
        end;
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

    var
        EmpVar, EmployeeRec : Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        EmpRelative: Record "Employee Relative";
        ApproverMgt: Codeunit "Approver Mgt";
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
        InsuranceMgt: Codeunit "Insurance Mgt";
}
