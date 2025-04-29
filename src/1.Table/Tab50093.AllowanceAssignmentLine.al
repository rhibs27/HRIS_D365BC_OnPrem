table 50093 "Allowance Assignment Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Code"; Code[20])
        {
            // TableRelation = if (Type = const(Branch)) "Dimension Value".Code where("Dimension Code" = const('BRANCH'),
            //                                                                       "Dimension Value Type" = const(Standard))
            // else if (Type = const("Extension Counter")) "Employee Hierarchy Master".Code where(Type = const("Extension Counter"));

            // trigger OnValidate()
            // begin
            //     GLSetup.Get;
            //     if Type = Type::Branch then begin
            //         if DimValue.Get(GLSetup."Global Dimension 1 Code", Code) then
            //             Validate(Name, DimValue.Name);
            //     end else if Type = Type::"Extension Counter" then begin
            //         EmpHie.Reset;
            //         EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
            //         EmpHie.SetRange(Code, Code);
            //         if EmpHie.FindFirst then
            //             Validate(Name, EmpHie.Description);
            //     end;
            // end;
            TableRelation = if (Type = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Organization Structure list"::Branch), Blocked = filter(false))
            else if (Type = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure List".Code where(Type = Filter("Organization Structure list"::"Extension Counter"), Blocked = filter(false));
            trigger OnValidate()
            begin
                Clear(Name);
                if Type = Type::Branch then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::"Extension Counter" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Code) then
                        Name := OrganizationStructureList.Name;
                end;
            end;
        }
        field(4; Name; Text[100])
        {
            Editable = false;
        }
        field(5; "Employee Code"; Code[20])
        {
            TableRelation = if (Type = const(Branch)) Employee."No." where("Global Dimension 1 Code" = field(Code))
            else if (Type = const("Extension Counter")) Employee."No." where("Extension Counter Code" = field(Code));

            trigger OnValidate()
            begin
                TestField("From Date");
                // if "Approval Status" = "Approval Status"::Screened then
                // Error('Cannot substitute screened employee.');
                AllowanceMgt.CheckEmployeeAlreadyExistsforSameEmployee("No.", "Line No.", "Employee Code", "Allowance Type", "From Date");
                //TESTFIELD("Allowance Type");
                PayrollGeneralSetup.Get;
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

                OverTimeMgt.CheckApprovedOvertimeExists(Rec);

                if Employee.Get("Employee Code") then
                    "Employee Name" := Employee."Full Name";

                // if xRec."Employee Code" <> "Employee Code" then
                //     "Approval Status" := "Approval Status"::"Pending Approval";

                ValidateAllowanceType();
                Validate("Allowance Amount", Round(AllowanceMgt.SetAllowanceAmount("Employee Code", "Allowance Type", "From Date"), 0.01, '='));
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
                AllowanceMgt.CheckEmployeeAlreadyExistsforSameEmployee("No.", "Line No.", "Employee Code", "Allowance Type", "From Date");
                ValidateDate();
                Validate("To Date", "From Date");
            end;
        }
        field(8; "To Date"; Date)
        {
            trigger OnValidate()
            begin
                ValidateDate();
            end;
        }
        field(9; "Allowance Type"; Code[20])
        {
            TableRelation = "Branchwise/Extension Allowance"."Allowance Type" where(Code = field(Code));

            trigger OnValidate()
            begin
                // TestField("Employee Code", '');
                // PGSetup.Get;
                // if ("Allowance Type" = PGSetup."Holiday Counter") or ("Allowance Type" = PGSetup."Festival Counter") then //Min 12.20.2022
                //     Error(TEXT003);//santosh
            end;
        }
        field(10; "Is Substitute"; Boolean) { }
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
        // field(18; "Approved Id"; Code[50])
        // {
        //     TableRelation = Employee;
        //}
        field(19; "Approval Status"; Enum "Attendance Status")
        {
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
                    PayrollGeneralSetup.TestField("Vault Key");
                    if "Allowance Type" <> PayrollGeneralSetup."Vault Key" then
                        Error('Allowance type must be vault key to select panel.');
                    AllowanceMgt.CheckForPanel(Rec);
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
    }

    keys
    {
        key(Key1; "No.", "Line No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        // if "Approval Status" in ["Approval Status"::Approved, "Approval Status"::Screened, "Approval Status"::Rejected] then
        // Error('You cannot delete approved or screened or rejected entries.');
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date" := Today;

        if "Line No." = 0 then
            GetLineNo();

        if AllowanceHeader.Get("No.") then begin
            Week := AllowanceHeader.Week;
        end;

        if AllowanceHeader."Approval Status" in [AllowanceHeader."Approval Status"::Screened] then
            Error('Document is already screened.');

        // TestField("Employee Code");
        // TestField("From Date");

        //for portal
        if not GuiAllowed then begin
            ValidateDate;
            ChangeHeaderApprovalStatus
        end;
        PayrollGeneralSetup.Get;
        PayrollGeneralSetup.TestField("Vault Key");
        if PayrollGeneralSetup."Vault Key" = "Allowance Type" then
            if Panel = Panel::" " then
                Error('Please select panel.');
        CheckForGracePeriod;
    end;

    trigger OnModify()
    begin
        // if "Approval Status" in ["Approval Status"::Screened] then
        //     Error('You cannot modify already screened entries.');

        "Last Modified Date" := Today;
        "Last Modified By" := UserId;
        if not GuiAllowed then
            ChangeHeaderApprovalStatus;
    end;

    var
        Employee: Record Employee;
        AllowanceHeader: Record "Allowance Assignment Header";
        AllowanceLine: Record "Allowance Assignment Line";
        AllowanceLine1: Record "Allowance Assignment Line";
        BaseCalenderChange: Record "Base Calendar Change";
        TEXT001: Label '%1 and %2 cannot be assigned on same date %3.';
        BranchwiseAllowance: Record "Branchwise/Extension Allowance";
        TEXT002: Label 'Total No. of Employees in %1 in %2 exceeds %3.';
        PayrollGeneralSetup: Record "Payroll General Setup";
        HrMgt: Codeunit "HR Mgt.";
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
        LeaveMgt: Codeunit "Leave Mgt.";
        // LoanMgt: Codeunit "Loan Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
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
                //  AllowanceLine1.RESET;
                //  AllowanceLine1.SETRANGE("Entry No.", AllowanceLine."Entry No.");
                //  AllowanceLine1.SETFILTER("Line No.", '<>%1', AllowanceLine."Line No.");
                //  IF AllowanceLine1.FINDFIRST THEN BEGIN
                PayrollAttribute.Get("Allowance Type");
                if PayrollAttribute."Mutually Exclusive" then begin
                    PayrollAttribute1.Get(AllowanceLine."Allowance Type");
                    if PayrollAttribute1."Mutually Exclusive" then
                        Error(TEXT001, AllowanceLine."Allowance Type", "Allowance Type", AllowanceLine."From Date");
                end;
            //END;
            until AllowanceLine.Next = 0;

        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", "No.");
        AllowanceLine.SetRange(Type, Type);
        AllowanceLine.SetRange("Allowance Type", "Allowance Type");
        AllowanceLine.SetRange(Code, Code);
        AllowanceLine.SetRange("From Date", "From Date");
        AllowanceLine.SetRange("Is Substitute", false);
        AllowanceLine.SetFilter("Employee Code", '<>%1', '');
        if AllowanceLine.FindFirst then
            if BranchwiseAllowance.Get(Type, Code, "Allowance Type") then
                if BranchwiseAllowance."Max. No. of Staffs" <> 0 then
                    if AllowanceLine.Count + 1 > BranchwiseAllowance."Max. No. of Staffs" then
                        Error(TEXT002, Name, "Allowance Type",
                                BranchwiseAllowance.FieldCaption("Max. No. of Staffs"));

        AllowanceHeader.Get("No.");
        if "From Date" <> 0D then
            if ("From Date" < AllowanceHeader."From Date") or ("From Date" > AllowanceHeader."To date") then
                Error('Date is not within period.');

        if "To Date" <> 0D then
            if "To Date" > AllowanceHeader."To date" then
                Error('Date is not within period.');

        CalculateNoOfDays(Rec);
    end;

    local procedure ValidateAllowanceType(): Boolean
    begin
        TestField("Allowance Type");
        BaseCalenderChange.Reset;
        BaseCalenderChange.SetRange(Date, "From Date");
        //BaseCalenderChange.SETRANGE(Nonworking, TRUE);
        if BaseCalenderChange.FindFirst then;

        case "Allowance Type" of
            'FESTIVAL':
                begin
                    if (BaseCalenderChange."Holiday Type" = BaseCalenderChange."Holiday Type"::Festival)
                      and (LeaveMgt.GetNonWokingDays("From Date", "From Date", "Employee Code") = 1) then begin
                        "To Date" := "From Date";
                        "No. of Days" := 1;
                        exit(true);
                    end
                    else
                        Error('Selected date is not festival.');
                end;
            'FRIDAY COUNTER':
                begin
                    if HrMgt.IsFriday("From Date") then begin
                        "To Date" := "From Date";
                        "No. of Days" := 1;
                        exit(true);
                    end
                    else
                        Error('Selected day is not friday.');
                end;
            'HOLIDAY COUNTER':
                begin
                    if (LeaveMgt.GetNonWokingDays("From Date", "From Date", "Employee Code") = 1) then begin
                        "To Date" := "From Date";
                        "No. of Days" := 1;
                        exit(true);
                    end
                    else
                        Error('Selected date is not marked as holiday in calendar.');
                end;
        end;

        exit(true);
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
        if "Is Substitute" then begin
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
                AllowanceLine1."Is Substitute" := true;
                AllowanceLine1."From Date" := NewFromDate;
                AllowanceLine1."To Date" := NewToDate;
                //    IF NOT GUIALLOWED THEN BEGIN
                AllowanceHeader.Validate("Approval Status", AllowanceHeader."Approval Status"::"Pending");
                AllowanceHeader.Modify;
                //  END;

                // AllowanceLine1.Validate("Approval Status", AllowanceLine1."Approval Status"::Screened);
                AllowanceLine1.CalculateNoOfDays(AllowanceLine1);
                AllowanceLine1.Insert(true);
            end;

            //IF (AllowanceLine."From Date" = 0D) OR (AllowanceLine."To date" = 0D) THEN
            //  AllowanceLine.DELETE;
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

    local procedure ChangeHeaderApprovalStatus()
    begin
        if AllowanceHeader.Get("No.") then begin
            if AllowanceHeader."Approval Status" = AllowanceHeader."Approval Status"::Approved then begin
                AllowanceHeader."Approval Status" := AllowanceHeader."Approval Status"::"Pending";
                AllowanceHeader.Modify;
            end;
        end;
    end;

    local procedure CheckForGracePeriod()
    begin

        //PayrollGeneralSetup.TESTFIELD("Allowance Grace Period");
        if AllowanceHeader."To date" + PayrollGeneralSetup."Allowance Grace Period" < Today then
            Error('Grace period for filling allowance assignment has been exceeded. Please Contact HR Team');
    end;
}
