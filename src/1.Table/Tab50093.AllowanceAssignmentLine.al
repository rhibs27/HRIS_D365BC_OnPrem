table 50093 "Allowance Assignment Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; "Line No."; Integer)
        {
            Editable = false;
        }
        field(3; "Code"; Code[20])
        {
            TableRelation = if (Type = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Branch), Blocked = filter(false))
            else if (Type = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure List".Code where(Type = Filter("Deputation Type"::"Extension Counter"), Blocked = filter(false))
            else if (Type = filter("Branchwise/Extension Type"::Department)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Department), Blocked = filter(false))
            else if (Type = filter("Branchwise/Extension Type"::Unit)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Unit), Blocked = filter(false));
            trigger OnValidate()
            begin
                Clear(Name);
                if Type = Type::Branch then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::"Extension Counter" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::Department then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::Unit then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, Code) then
                        Name := OrganizationStructureList.Name;
                end
            end;
        }
        field(4; Name; Text[100])
        {
            Editable = false;
        }
        field(5; "Employee Code"; Code[20])
        {
            TableRelation = if (Type = const(Branch)) Employee."No." where("Branch Code" = field(Code))
            else if (Type = const("Extension Counter")) Employee."No." where("Extension Counter Code" = field(Code))
            else if (Type = const("Department")) Employee."No." where("Department Code" = field(Code))
            else if (Type = const("Unit")) Employee."No." where("Unit Code" = field(Code))
            else if ("Emp Act Type" = const("Request Allowance")) Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee Code") then
                    "Employee Name" := Employee."Full Name";
                PayrollGeneralSetup.Get;
                if not PayrollGeneralSetup."Use Allowance Configuration" then begin
                    PayrollGeneralSetup.TestField("Risk Allowance");
                    PayrollGeneralSetup.TestField("Morning Counter");
                    PayrollGeneralSetup.TestField("Holiday Counter");

                    if "Allowance Type" in [PayrollGeneralSetup."Risk Allowance", PayrollGeneralSetup."Morning Counter"] then
                        AllowanceMgt.CheckFunctionalTitleForRiskAllowance(Rec);
                    if "Allowance Type" = PayrollGeneralSetup."Evening Counter" then
                        AllowanceMgt.CheckFunctionalTitleForEveningCounter(Rec);

                    if "Allowance Type" = PayrollGeneralSetup."Holiday Counter" then
                        AllowanceMgt.CheckFunctionalTitleForHolidayCounter(Rec);

                    if "Allowance Type" = PayrollGeneralSetup."Vault Key" then
                        AllowanceMgt.CheckSalaryLevelForVaultKey(Rec);

                    //OverTimeMgt.CheckApprovedOvertimeExists(Rec); not needed in base
                end;
            end;
        }
        field(6; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(7; "From Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("To Date", "From Date");
                AllowanceMgt.CheckEmployeeAlreadyExistsforSameEmployee("No.", "Line No.", "Employee Code", "Allowance Type", "From Date", "Emp Act Type");
                AllowanceMgt.CheckMutuallyExclusive(Rec);
                AllowanceMgt.CheckDate(Rec);
                AllowanceMgt.CheckMaximumEmployeeInBranch(Rec);
                AllowanceMgt.ValidateAllowanceType(Rec);
                Validate("Allowance Amount", Round(AllowanceMgt.SetAllowanceAmount("Employee Code", "Allowance Type", "From Date"), 0.01, '='));
            end;
        }
        field(8; "To Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("No. of Days", "To Date" - "From Date" + 1);
            end;
        }
        field(9; "Allowance Type"; Code[20])
        {
            TableRelation = if ("Emp Act Type" = const("Request Allowance")) "Allowance Configuration"."Payroll Attribute"
            else
            "BranchWise/Extension Allowance"."Allowance Type" where(Code = field(Code), Type = field(Type));

            trigger OnValidate()
            begin
                if ("Allowance Type" <> xRec."Allowance Type") and GuiAllowed then begin
                    Clear("From Date");
                    Clear("To Date");
                    Clear(Panel);
                    Clear("Allowance Amount");
                end;
            end;
        }
        field(10; "Substitute Type"; Enum "Allowance Substitute")
        {
            InitValue = '';
            Editable = false;
        }
        field(11; "Substitute of Line No."; Integer)
        {
            Editable = false;
        }
        field(12; Type; Enum "Branchwise/Extension Type") { }
        field(13; "Created Date"; Date) { }
        field(14; "Created By"; Code[50]) { }
        field(15; "Last Modified Date"; Date) { }
        field(16; "Last Modified By"; Code[50]) { }
        field(17; "Approved Date"; Date) { }
        field(19; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }
        field(20; "No. of Days"; Decimal)
        {
            Editable = false;
        }
        field(23; Panel; Enum Panel)
        {
            trigger OnValidate()
            begin
                if Panel <> Panel::" " then begin
                    PayrollGeneralSetup.Get;
                    if not PayrollGeneralSetup."Use Allowance Configuration" then begin
                        PayrollGeneralSetup.TestField("Vault Key");
                        PayrollGeneralSetup.TestField("ATM Custodian");
                        if ("Allowance Type" <> PayrollGeneralSetup."Vault Key") and ("Allowance Type" <> PayrollGeneralSetup."ATM Custodian") then
                            Error('Panel is not allowed in this Allowance Type');
                        AllowanceMgt.CheckForPanel(Rec);
                    end;
                end;
            end;
        }
        field(24; "Allowance Amount"; Decimal)
        {
            Editable = false;
        }
        field(25; "Rejection Remarks"; Text[100]) { }
        field(26; Week; Enum WeekNumber) { }
        field(27; "Emp Act Type"; Enum "Employee Activity Type") { }
        field(28; "Allowance Claim From"; Code[20]) { }
        field(50; "Leave Code"; Code[20]) { }
        field(51; "Leave Document No"; Code[20]) { }
        field(52; "Payroll Doc No."; Code[20]) { }
        field(29; "Allowance Claimed"; Boolean) { }
        field(30; "Allowance Claim from Line No"; Integer) { }
    }

    keys
    {
        key(Key1; "No.", "Line No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete);
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date" := Today;
        Validate("Approval Status", "Approval Status"::Open);
        if "Line No." = 0 then
            GetLineNo();
        // CheckForGracePeriod;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := Today;
        "Last Modified By" := UserId;
    end;

    var
        Employee: Record Employee;
        AllowanceHeader: Record "Allowance Assignment Header";
        AllowanceLine: Record "Allowance Assignment Line";
        PayrollGeneralSetup: Record "Payroll General Setup";
        HrMgt: Codeunit "HR Mgt.";
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
        OrganizationStructureList: Record "Organization Structure List";

    local procedure GetLineNo()
    var
        AllowanceLine: Record "Allowance Assignment Line";
    begin
        AllowanceLine.Reset;
        AllowanceLine.SetCurrentKey("No.", "Line No.");
        AllowanceLine.SetRange("No.", "No.");
        if AllowanceLine.FindLast then
            "Line No." := AllowanceLine."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    procedure CalculateNoOfDays(var _AllowanceLine: Record "Allowance Assignment Line")
    begin
        if (_AllowanceLine."From Date" <> 0D) and (_AllowanceLine."To Date" <> 0D) then
            _AllowanceLine."No. of Days" := _AllowanceLine."To Date" - _AllowanceLine."From Date" + 1;
    end;

    local procedure CheckForGracePeriod()
    begin
        if AllowanceHeader."To date" + PayrollGeneralSetup."Allowance Grace Period" < Today then
            Error('Grace period for filling allowance assignment has been exceeded. Please Contact HR Team');
    end;
}
