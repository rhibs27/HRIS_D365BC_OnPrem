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
                if Employee.Get("Employee Code") then
                    "Employee Name" := Employee."Full Name"
                else
                    "Employee Name" := '';
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

                if "Emp Act Type" <> "Emp Act Type"::"Request Allowance" then begin
                    AllowanceMgt.CheckEmployeeAlreadyExistsforSameEmployee("No.", "Line No.", "Employee Code", "Allowance Type", "From Date", "Emp Act Type");
                    ValidateDate();
                    Validate("To Date", "From Date");
                    ValidateAllowanceType;
                    Validate("Allowance Amount", Round(AllowanceMgt.SetAllowanceAmount("Employee Code", "Allowance Type", "From Date"), 0.01, '='));
                end;
            end;
        }
        field(8; "To Date"; Date)
        {
            trigger OnValidate()
            begin
                // ValidateDate();
            end;
        }
        field(9; "Allowance Type"; Code[20])
        {

            TableRelation = if ("Emp Act Type" = const("Request Allowance")) "Allowance Configuration"."Payroll Attribute"
            else
            "Branchwise/Extension Allowance"."Allowance Type" where(Code = field(Code), Type = field(Type));

            trigger OnValidate()
            var
                AllowanceHeader: Record "Allowance Assignment Header";
            begin
                if ("Allowance Type" <> xRec."Allowance Type") and GuiAllowed then begin
                    Clear("From Date");
                    Clear("To Date");
                    Clear(Panel);
                    if "Emp Act Type" <> "Emp Act Type"::"Request Allowance" then begin
                        Clear("Employee Code");
                        Clear("Employee Name");
                        Clear("Allowance Amount");
                    end;
                end;

                if ("Emp Act Type" = "Emp Act Type"::"Request Allowance") and ("Allowance Type" <> '') then begin
                    AllowanceConfiguration.Reset();
                    AllowanceConfiguration.SetRange("Payroll Attribute", "Allowance Type");
                    if AllowanceConfiguration.FindFirst() then
                        "Allowance Amount" := GetAllowanceConfigAmount(AllowanceConfiguration)
                    else
                        Error('Invalid allowance selected!');
                    Clear(Panel);
                end;
                if AllowanceHeader.Get("No.") then
                    Validate("Emp Act Type", AllowanceHeader."Activity Type")
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
        field(12; Type; Enum "Branchwise/Extension Type")
        {

        }
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
        field(21; "Screened By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(22; "Screened Date"; DateTime)
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
        field(26; Week; Enum WeekNumber)
        {
        }
        field(27; "Emp Act Type"; Enum "Employee Activity Type")
        {
        }
        field(28; "Allowance Claim From"; Code[20])
        {
        }
        field(50; "Leave Code"; Code[20]) { }
        field(51; "Leave Document No"; Code[20]) { }
        field(52; "Payroll Doc No."; Code[20]) { }
        field(53; "Recurring Completed"; Boolean) { }
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
        if ("Emp Act Type" = "Emp Act Type"::"Request Allowance") and AllowanceHeader.Get("No.") then
            if AllowanceHeader."Employee No." <> '' then
                Validate("Employee Code", AllowanceHeader."Employee No.");
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
        AllowanceLine1: Record "Allowance Assignment Line";
        BaseCalenderChange: Record "Base Calendar Change";
        TEXT001: Label '%1 and %2 cannot be assigned on same date %3.';
        BranchWiseAllowance: Record "BranchWise/Extension Allowance";
        TEXT002: Label 'Total No. of Employees in %1 in %2 exceeds %3.';
        PayrollGeneralSetup: Record "Payroll General Setup";
        HrMgt: Codeunit "HR Mgt.";
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
        LeaveMgt: Codeunit "Leave Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        SalaryLevel: Record "Salary Level";
        OrganizationStructureList: Record "Organization Structure List";
        AllowanceConfiguration: Record "Allowance Configuration";

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

    local procedure ValidateDate()
    var
        PayrollAttribute: Record "Payroll Attributes";
        PayrollAttribute1: Record "Payroll Attributes";
    begin
        "No. of Days" := 0;
        //if one mutual exclusive allowance is already selected, no other mutually exclusive allowance is allowed.
        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", "No.");
        AllowanceLine.SetFilter("Line No.", '<>%1', "Line No.");
        AllowanceLine.SetFilter("From Date", '<=%1', "From Date");
        AllowanceLine.SetFilter("To Date", '>=%1', "From Date");
        AllowanceLine.SetFilter("Allowance Type", '<>%1', "Allowance Type");
        AllowanceLine.SetRange(Type, Type);
        if AllowanceLine.FindFirst then
            repeat
                PayrollAttribute.Get("Allowance Type");
                if PayrollAttribute."Mutually Exclusive" then begin
                    PayrollAttribute1.Get(AllowanceLine."Allowance Type");
                    if PayrollAttribute1."Mutually Exclusive" then
                        Error(TEXT001, AllowanceLine."Allowance Type", "Allowance Type", AllowanceLine."From Date");
                end;
            until AllowanceLine.Next = 0;
        if Rec."Substitute Type" = Rec."Substitute Type"::" " then begin
            AllowanceLine.Reset;
            AllowanceLine.SetRange("No.", "No.");
            AllowanceLine.SetRange(Type, Type);
            AllowanceLine.SetRange("Allowance Type", "Allowance Type");
            AllowanceLine.SetRange(Code, Code);
            AllowanceLine.SetRange("From Date", "From Date");
            AllowanceLine.Setfilter("Substitute Type", '%1', AllowanceLine."Substitute Type"::" ");
            AllowanceLine.SetFilter("Employee Code", '<>%1', '');
            if AllowanceLine.FindFirst then
                if BranchwiseAllowance.Get(Type, Code, "Allowance Type") then
                    if BranchwiseAllowance."Max. No. of Staffs" <> 0 then
                        if AllowanceLine.Count + 1 > BranchwiseAllowance."Max. No. of Staffs" then
                            Error(TEXT002, Name, "Allowance Type",
                                    BranchwiseAllowance.FieldCaption("Max. No. of Staffs"));
        end;
        AllowanceHeader.Get("No.");
        if AllowanceHeader."Activity Type" <> "Emp Act Type"::"Allowance Assignment Claim" then begin
            AllowanceHeader.TestField("From Date");
            AllowanceHeader.TestField("To date");
            if "From Date" <> 0D then
                if ("From Date" < AllowanceHeader."From Date") or ("From Date" > AllowanceHeader."To date") then
                    Error('Date is not within period.');

            if "To Date" <> 0D then
                if "To Date" > AllowanceHeader."To date" then
                    Error('Date is not within period.');
            CalculateNoOfDays(Rec);
        end;

    end;

    procedure ValidateAllowanceType()
    var
        AttendanceMgt: Codeunit "Attendance Mgt";
        PGSetup: Record "Payroll General Setup";
    begin
        TestField("Allowance Type");
        PGSetup.Get();
        case "Allowance Type" of
            PGSetup."Dashain Allowance":
                begin
                    if not HrMgt.IsDashinTihar("From Date") then
                        Error('Selected date is not Dashain Tihar.');
                    if not AttendanceMgt.CheckEmployeePresent("Employee Code", "From Date") then
                        Error('Attendance Not Found On %1', "From Date");
                end;
        end;
    end;

    procedure CalculateNoOfDays(var _AllowanceLine: Record "Allowance Assignment Line")
    begin
        if (_AllowanceLine."From Date" <> 0D) and (_AllowanceLine."To Date" <> 0D) then
            _AllowanceLine."No. of Days" := _AllowanceLine."To Date" - _AllowanceLine."From Date" + 1;
    end;

    procedure UpdateSubstitue()
    var
        NewToDate: Date;
        NewFromDate: Date;
    begin
        if AllowanceLine."Substitute Type" = "Substitute Type"::"Added as Substitute" then begin
            if ("From Date" = 0D) or ("To Date" = 0D) then
                exit;
            AllowanceLine.Get("No.", "Substitute of Line No.");
            NewToDate := AllowanceLine."To Date";
            if AllowanceLine."From Date" = "From Date" then
                AllowanceLine.Delete(true);

            if not GuiAllowed then begin
                AllowanceHeader.Reset;
                AllowanceHeader.Get("No.");
            end;
            if "From Date" - 1 >= AllowanceHeader."From Date" then begin
                AllowanceLine."To Date" := "From Date" - 1;
                AllowanceLine.CalculateNoOfDays(AllowanceLine);
                AllowanceLine.Modify(true);
            end;

            NewFromDate := "To Date" + 1;

            if (NewFromDate >= AllowanceHeader."From Date") and (NewToDate <> "To Date") then begin
                //insert new line
                AllowanceLine1.Reset;
                AllowanceLine1.Init;
                AllowanceLine1."No." := "No.";
                AllowanceLine1.Validate("Allowance Type", AllowanceLine."Allowance Type");
                AllowanceLine1.Validate("Employee Code", AllowanceLine."Employee Code");
                AllowanceLine1."Substitute of Line No." := AllowanceLine."Line No.";
                AllowanceLine1."Substitute Type" := AllowanceLine1."Substitute Type"::"Added as Substitute";
                AllowanceLine1."From Date" := NewFromDate;
                AllowanceLine1."To Date" := NewToDate;
                AllowanceHeader.Validate("Approval Status", AllowanceHeader."Approval Status"::"Pending");
                AllowanceHeader.Modify;
                AllowanceLine1.CalculateNoOfDays(AllowanceLine1);
                AllowanceLine1.Insert(true);
            end;
        end;
    end;

    procedure CalctoDate(FromDate: Date): Date
    var
        ToDate: Date;
        MonthEndDate: Date;
    begin
        ToDate := CalcDate('<1W>', FromDate);
        MonthEndDate := CalcDate('<1M>', FromDate);
        if ToDate < MonthEndDate then
            exit(ToDate)
        else
            exit(MonthEndDate);
    end;

    local procedure CheckForGracePeriod()
    begin
        if AllowanceHeader."To date" + PayrollGeneralSetup."Allowance Grace Period" < Today then
            Error('Grace period for filling allowance assignment has been exceeded. Please Contact HR Team');
    end;

    procedure GetAllowanceConfigAmount(AllowanceConfig: Record "Allowance Configuration"): Decimal
    var
        MonthlyAmt: Decimal;
    begin
        if AllowanceConfig."Earning Cycle" = AllowanceConfig."Earning Cycle"::Daily then
            exit(AllowanceConfig.Amount);

        if AllowanceConfig.Source in [AllowanceConfig.Source::Direct, AllowanceConfig.Source::Leave] then
            if AllowanceConfig.Formula = '' then
                exit(AllowanceConfig.Amount)
            else
                exit(AllowanceConfig.EvaluateAmountForEmployee(AllowanceConfig.Formula, "Employee Code"));

        if AllowanceConfig.Source in [AllowanceConfig.Source::Assignment, AllowanceConfig.Source::Shift] then begin
            if AllowanceConfig.Formula = '' then
                MonthlyAmt := AllowanceConfig.Amount
            else
                MonthlyAmt := AllowanceConfig.EvaluateAmountForEmployee(AllowanceConfig.Formula, "Employee Code");

            exit(Round(MonthlyAmt / 30, 0.01, '='));
        end;
    end;
}
