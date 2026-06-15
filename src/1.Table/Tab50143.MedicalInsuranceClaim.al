table 50143 "Medical Insurance Claim"
{
    Caption = 'Medical Insurance Claim';
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
        field(2; Type; Enum "Employee Activity Type") { }
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
                    Validate("Contact No.", EmpVar."Mobile Phone No.");
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
        field(7; "Policy Start Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Policy Start Date (BS)", EngNepDate.getNepaliDate("Policy Start Date"));
                if "Policy Start Date" <> xRec."Policy Start Date" then begin
                    Clear("Policy End Date");
                    Clear("Policy End Date (BS)");
                end;
            end;
        }
        field(8; "Policy End Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Policy End Date (BS)", EngNepDate.getNepaliDate("Policy End Date"))
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
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Requested Date"))
            end;
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(12; "Policy Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(13; "Policy End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[250]) { }
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
            // TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));
        }
        field(29; "Province Name"; Code[100])
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
        field(32; "Compensatory Days"; Decimal) { }
        field(33; "Payroll No."; Code[20]) { }
        field(36; "Rejection Remarks"; Text[250]) { }
        field(37; "Approved Date"; Date) { }
        field(39; Cancelled; Boolean) { }
        field(40; "Cancelled No."; Code[20]) { }
        field(41; "Cancelled Document No."; Code[20])
        {
            Editable = false;
        }
        field(50; "Insurance Claim"; Enum "Insurance Claim")
        {
            ValuesAllowed = 1, 7;
            trigger OnValidate()
            begin
                if "Insurance Claim" <> xRec."Insurance Claim" then begin
                    Clear("Insured Name");
                    Clear("Relation");
                end;
                if "Insurance Claim" = "Insurance Claim"::Self then begin
                    if EmpVar.Get("Employee No.") then
                        Validate("Insured Name", EmpVar."Full Name");
                end;
            end;
        }
        field(51; "Father Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(52; "Mother Name"; Text[50]) { }
        field(53; "Spouse Name"; Text[50]) { }
        field(54; "Child Name"; Text[50]) { }
        field(55; "Total Insurance Claim Amount"; Decimal) { }
        field(56; "Medical Prescription Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Medical Prescription Date (BS)", EngNepDate.getNepaliDate("Medical Prescription Date"))
            end;
        }
        field(57; "Discharge Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Discharge Date (BS)", EngNepDate.getNepaliDate("Discharge Date"))
            end;
        }
        field(58; "Bank Account No."; Text[30]) { }
        field(59; "Contact No."; Text[30]) { }
        field(60; "Insurance Status"; Enum "Insurance Status")
        {
            Editable = false;
        }
        field(100; Status; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Status Master";
        }
        field(301; "Access Token"; Code[60])
        {
            DataClassification = ToBeClassified;
            Caption = 'Access Token';
        }
        field(302; "Insured Name"; Text[100])
        {
            Caption = 'Insured Name';

            trigger OnLookup()
            var
                HrMgt: Codeunit "HR Mgt.";
            begin
                if "Insurance Claim" = "Insurance Claim"::Dependent then
                    Validate("Insured Name", HrMgt.LookupRelatives("Employee No."));
            end;

            trigger OnValidate()
            var
                Relatives: Record Relative;
            begin
                if "Insurance Claim" = "Insurance Claim"::Dependent then begin
                    EmpRelative.Reset();
                    EmpRelative.SetRange("Employee No.", "Employee No.");
                    EmpRelative.SetRange("Is Medical Insurance Eligible", true);
                    EmpRelative.SetRange("Full Name", "Insured Name");
                    if EmpRelative.FindFirst() then begin
                        if Relatives.Get(EmpRelative."Relative Code") then
                            Relation := Relatives.Description;
                    end;
                end;
                if "Insurance Claim" = "Insurance Claim"::Self then
                    Relation := 'Self';
            end;

        }
        field(303; "Relation"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(304; "Batch Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(305; "Reimbursed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(306; "Medical Prescription Date (BS)"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(307; "Discharge Date (BS)"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(308; "HR Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Policy Start Date", "Insured Name", "Access Token") { }
    }
    trigger OnInsert()
    var
        IsHandle: Boolean;
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        if not GuiAllowed then begin
            if not HrMgt.IsSaaS() then
                Validate("Employee No.", Hrmgt.GetEmployeeNo());
            "Approval Status" := "Approval Status"::Pending;
            Validate(Type, Rec.Type::"Medical Insurance Claim");
        end;
        HRSetup.Get;
        if (HRSetup."Policy Start Date" = 0D) or (HRSetup."Policy End Date" = 0D) then
            Error('The Policy Start Date and Policy End Date must be specified in the Human Resources Setup.');

        Rec.Validate("Policy Start Date", HRSetup."Policy Start Date");
        Rec.Validate("Policy End Date", HRSetup."Policy End Date");

        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                HRMgt.InitNoSeriesNew(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of
                    //for medical insurance claim
                    Type::"Medical Insurance Claim":
                        begin
                            HRSetup.TestField("Medical Insurance No.");
                            HRMgt.InitNoSeriesNew(HRSetup."Medical Insurance No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            MedicalInsuranceClaimRec.ReadIsolation(IsolationLevel::ReadCommitted);
                            MedicalInsuranceClaimRec.SetLoadFields("No.");
                            while MedicalInsuranceClaimRec.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                            if not HRSetup."Skip Medical Approval Setup" then
                                ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");//Create Approval line from Setup Santosh
                        end;
                end;
            end;

        OnBeforeGenerateAttachmentLineM("No.", "Employee No.", "Employee Activity Type"::"Medical Insurance Claim", IsHandle);
        if (not IsHandle) And GuiAllowed then
            InsuranceMgt.GenerateAttachmentLine("No.", "Employee No.", "Employee Activity Type"::"Medical Insurance Claim");

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
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        EmpRelative: Record "Employee Relative";
        ApproverMgt: Codeunit "Approver Mgt";
        IncomingDoc: Record "Incoming Document";
        InsuranceMgt: Codeunit "Insurance Mgt";
        MedicalInsuranceClaimRec: Record "Medical Insurance Claim";

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGenerateAttachmentLineM(No: Code[20]; EmployeeNo: Code[20]; EmployeeActivityType: Enum "Employee Activity Type"; var IsHandle: Boolean)
    begin
    end;
}
