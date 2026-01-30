table 50004 Promotion
{
    DataClassification = CustomerContent;
    //Field 1,2,16,37 100 are used in ApprovalMgt Codeunit as field Ref << Santosh 3.25.2025
    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Promotion No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type") { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
            trigger OnValidate()
            begin
                OnValidateEmployeeNo;
            end;
        }
        field(4; "Employee Name"; Text[100]) { }
        field(5; "Date of Employment"; Date) { }
        field(6; "Previous Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(7; "Previous Functional Title Desc"; Text[100]) { }
        field(8; "Previous Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(9; "Previous Salary Grade"; Code[20]) { }
        field(10; "Previous Salary Description"; text[50]) { }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }
        field(17; "Deputation on"; Enum "Deputation Type") { }
        field(18; "Deputation Code"; Code[20]) { }
        field(19; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Province));
            Editable = false;
        }
        field(20; "Province Name"; Text[100])
        {
            Editable = false;
        }
        field(21; "Department Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
        }
        field(22; "Department Name"; Text[100])
        {
            Editable = false;
        }
        field(25; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
            Editable = false;
        }
        field(26; "Branch Name"; Text[100])
        {
            Editable = false;
        }
        field(27; "Extension Counter"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const("Extension Counter"));
            Editable = false;
        }
        field(28; "Extension Counter Name"; Text[100])
        {
            Editable = false;
        }
        field(29; "Unit Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Unit));
            Editable = false;
        }
        field(30; "Unit Name"; Text[100])
        {
            Editable = false;
        }
        field(31; "Fiscal Year"; Code[20])
        {
            Editable = true;
        }
        field(32; "Sol Id"; Code[20])
        {
            Caption = 'Sol Id';
        }
        field(33; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(39; Cancelled; Boolean) { }
        field(40; "Cancelled No."; Code[20]) { }
        field(41; "Cancelled Document No."; Code[20]) { }
        field(50; "Total Tenure in Bank"; Integer) { }
        field(51; "Total Tenure in Crc Position"; Date) { }
        field(52; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(53; "Remarks"; Text[100]) { }
        field(54; "Rejection Remarks"; Text[100]) { }
        field(55; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(56; "Requested Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Requested Date"));
            end;
        }
        // Promotion
        field(60; "Promoted Functional Title"; Code[20]) { }
        field(61; "Promoted Salary Grade"; Code[20]) { }
        field(62; "Promoted Salary level"; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(63; "Promoted Approver Role"; Code[20]) { }
        field(64; "Promoted Staff Level"; Enum "Staff Type") { }
        field(65; "Promotion Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Promotion Date (BS)", EngNepDate.getNepaliDate("Promotion Date"));
            end;
        }
        field(66; "Promotion Date (BS)"; Code[20]) { }
        field(100; "Status"; Text[20]) { }
        field(301; "Access Token"; code[60])
        {
            caption = 'Access Token';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }
    trigger OnInsert()
    begin
        HumanResSetup.Get;
        if "Requested Date" = 0D then
            Validate("Requested Date", Today);
        if "No." = '' then
            if Cancelled then begin
                HumanResSetup.TestField("Promotion No.");
                HRMgt.InitNoSeriesNew(HumanResSetup."Promotion No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of
                    Type::Promotion:
                        begin
                            HumanResSetup.TestField("Promotion No.");
                            HRMgt.InitNoSeriesNew(HumanResSetup."Promotion No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            Promotion.ReadIsolation(IsolationLevel::ReadUncommitted);
                            Promotion.SetLoadFields("No.");
                            while Promotion.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                        end;
                end;
            end;
        if not GuiAllowed then begin
            if not HrMgt.IsSaaS() then
                "Employee No." := HRMgt.GetEmployeeNo();
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

    var
        EmployeeVar: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        Promotion: Record Promotion;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        ApprovalEntry: Record "Approval HRMS";
        EngNepDate: Record "English-Nepali Date";

    procedure AssistEdit(OldAppraisal: Record Appraisal): Boolean
    begin
        Promotion := Rec;
        HumanResSetup.Get;
        HumanResSetup.TestField("Promotion No.");
        if NoSeriesMgt.LookupRelatedNoSeries(HumanResSetup."Promotion No.", OldAppraisal."No. Series", Promotion."No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Promotion No.");
            NoSeriesMgt.GetNextNo(Promotion."No.");
            Rec := Promotion;
            exit(true);
        end;
    end;

    local procedure OnValidateEmployeeNo()
    begin
        Clear("Branch Code");
        Clear("Branch Name");
        Clear("Department Code");
        Clear("Department Name");
        Clear("Extension Counter");
        Clear("Extension Counter Name");
        Clear("Province Code");
        Clear("Province Name");
        Clear("Deputation on");
        Clear("Unit Code");
        Clear("Unit Name");
        Clear("Previous Functional Title Desc");
        Clear("Sol Id");
        if EmployeeVar.Get("Employee No.") then begin
            "Previous Functional Title" := EmployeeVar."Functional Title";
            "Employee Name" := EmployeeVar."Full Name";
            "Previous Salary Level" := EmployeeVar."Salary Level";
            "Previous Salary Grade" := EmployeeVar."Salary Grade";
            "Previous Salary Description" := EmployeeVar."Salary Level Description";
            "Date of Employment" := EmployeeVar."Employment Date";
            Validate("Sol Id", EmployeeVar."Sol Id");
            Validate("Deputation on", EmployeeVar."Deputation on");
            Validate("Deputation Code", EmployeeVar."Deputation on code");
            Validate("Province Code", EmployeeVar."Province Code");
            Validate("Province Name", EmployeeVar."Province Name");
            Validate("Branch Code", EmployeeVar."Branch Code");
            Validate("Branch Name", EmployeeVar."Branch Name");
            Validate("Department Code", EmployeeVar."Department Code");
            Validate("Department Name", EmployeeVar."Department Name");
            Validate("Extension Counter", EmployeeVar."Extension Counter Code");
            Validate("Extension Counter Name", EmployeeVar."Extension Counter Name");
            Validate("Unit Code", EmployeeVar."Unit Code");
            Validate("Unit Name", EmployeeVar."Unit Name");
            Validate("Previous Functional Title Desc", EmployeeVar."Functional Title Desc");
        end;
    end;
}