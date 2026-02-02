table 50092 "Allowance Assignment Header"
{
    DataCaptionFields = "No.", "Code", "From Date", "To date";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    case "Activity Type" of
                        //for Allowance Assignment Header
                        "Activity Type"::"Allowance Assignment":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Allowance Assignment Series");
                                "No. Series" := '';
                            end;
                    end;
            end;
        }
        field(2; "Activity Type"; Enum "Employee Activity Type")
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = if (Type = filter("Deputation Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Branch), Blocked = filter(false))
            else if (Type = filter("Deputation Type"::"Extension Counter")) "Organization Structure Line"."Reporting Code" where(Type = Filter("Deputation Type"::"Branch"), Code = field("Branch Code"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"))
            else if (Type = filter(Department)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Department), Blocked = filter(false))
            else if (Type = filter("Deputation Type"::Unit)) "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Department), Code = field("Department Code"), "Reporting Type" = filter("Deputation Type"::Unit));
            trigger OnValidate()
            begin
                GLsetup.Get;
                Clear(Name);
                if "Employee No." = '' then
                    if not HrMgt.IsSaaS() then
                        "Employee No." := HrMgt.GetEmployeeNo();
                Employee.Get("Employee No.");
                if Type = Type::Branch then begin
                    if Code <> '' then
                        TestField(Code, Employee."Branch Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::"Extension Counter" then begin
                    if Code <> '' then
                        // TestField(Code, Employee."Extension Counter Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Code) then
                            Name := OrganizationStructureList.Name;
                end else if Type = Type::Department then begin
                    if Code <> '' then
                        TestField(Code, Employee."Department Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::Unit then begin
                    if Code <> '' then
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, Code) then
                            Name := OrganizationStructureList.Name;
                end;
            end;
        }
        field(3; Name; Text[100])
        {
            Editable = false;
        }
        field(4; "From Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Activity Type" = "Activity Type"::"Allowance Assignment Claim" then
                    TestField(Month);
                Validate("Fiscal Year", HrMgt.ReturnFiscalYear("From Date"));
                if Rec."From Date" <> xRec."From Date" then
                    Clear("To date");
            end;
        }
        field(5; "To date"; Date)
        {
            trigger OnValidate()
            begin
                TestField("From Date");
                if "Activity Type" = "Activity Type"::"Allowance Assignment Claim" then
                    AllowanceMgt.CheckCutOffDate("From Date", "To date", Month);
                if "From Date" > "To date" then
                    Error('Invalid date.');
            end;
        }
        field(6; "Type"; Enum "Branchwise/Extension Type")
        {
            trigger OnValidate()
            begin
                if Type <> xRec.Type then begin
                    Clear(Code);
                    Clear(Name);
                end;
            end;
        }
        field(7; "Created Date"; Date) { }
        field(8; "Created By"; Code[50]) { }
        field(9; "Last Modified Date"; Date) { }
        field(10; "Last Modified By"; Code[50]) { }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; Return; Boolean) { }
        field(15; "Allowance Type Filter"; Code[20])
        {
            TableRelation = "Branchwise/Extension Allowance"."Allowance Type" where(Code = field(Code),
                                                                                     Type = field(Type));
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = true;
            trigger OnValidate()
            var
                AllowanceAssignmentLine: Record "Allowance Assignment Line";
            begin
                if "Approval Status" = "Approval Status"::Pending then begin
                    AllowanceAssignmentLine.Reset();
                    AllowanceAssignmentLine.SetRange("No.", "No.");
                    if not AllowanceAssignmentLine.FindFirst() then
                        Error('Allowance Assignment Line Not Found');
                end;
            end;
        }
        field(19; "Fiscal Year"; text[10])
        {
        }
        field(21; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Only for Portal functionalities.';
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then begin
                    if Employee."Deputation on" = Employee."Deputation on"::Branch then
                        Validate("Branch Code", Employee."Branch Code")
                    else if Employee."Deputation on" = Employee."Deputation on"::Department then
                        Validate("Department Code", Employee."Department Code");
                    Validate("Employee Name", Employee."Full Name");
                end;
            end;
        }
        field(22; "Branch Code"; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(23; "Rejection Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Department Code"; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(26; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";
            Caption = 'Designation';
        }
        field(37; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(38; "Substitute Approval Status"; Enum "Approval Status")
        {

        }
        field(27; Month; Enum "Nepali Month")
        {
            trigger OnValidate()
            begin
                if xRec.Month <> Rec.Month then begin
                    Clear("From Date");
                    Clear("To date");
                end;
            end;
        }
        field(100; "Status"; Text[20]) { }
    }
    keys
    {
        key(Key1; "No.") { }
    }
    fieldgroups { }
    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            AllowanceLine.Reset;
            AllowanceLine.SetRange("No.", "No.");
            AllowanceLine.DeleteAll(true);
            ApprovalHrms.Reset;
            ApprovalHrms.SetRange("Document No.", "No.");
            ApprovalHrms.DeleteAll(true);
        end;
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date" := Today;
        if "Employee No." = '' then
            if (not GuiAllowed) and (not HrMgt.IsSaaS()) then
                Validate("Employee No.", HrMgt.GetEmployeeNo());
        HRSetup.Get;
        if "No." = '' then
            case "Activity Type" of
                //for AllowanceAssignment
                "Activity Type"::"Allowance Assignment", "Activity Type"::"Allowance Assignment Claim", "Activity Type"::"Request Allowance":
                    begin
                        HRSetup.TestField("Allowance Assignment Series");
                        HRMgt.InitNoSeriesNew(HRSetup."Allowance Assignment Series", xRec."No. Series", "Created Date", "No.", "No. Series");
                        AllowanceHeader.ReadIsolation(IsolationLevel::ReadCommitted);
                        AllowanceHeader.SetLoadFields("No.");
                        while AllowanceHeader.Get("No.") do
                            "No." := NoSeriesMgt.GetNextNo("No. Series");
                        ApproverMgt.InsertApproval("Employee No.", "No.", "Activity Type", "Approval Status");
                    end;
            end;
    end;

    var
        Employee: Record Employee;
        AllowanceLine: Record "Allowance Assignment Line";
        HrMgt: Codeunit "HR Mgt.";
        ApprovalHrms: Record "Approval HRMS";
        HRSetup: Record "Human Resources Setup";
        OrganizationStructureList: Record "Organization Structure List";
        NoSeriesMgt: Codeunit "No. Series";
        ApproverMgt: Codeunit "Approver Mgt";
        GLsetup: Record "General Ledger Setup";
        AllowanceHeader: Record "Allowance Assignment Header";
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
}
