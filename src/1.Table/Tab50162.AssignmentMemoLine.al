table 50162 "Assignment Memo Line"
{
    Caption = 'Assignment Memo Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(5; "Employee No."; Code[20])
        {
            TableRelation = Employee where(Status = const(Active));
            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                    "Employee Name" := Employee."Full Name";
                    if Employee."Last Placement Date" <> 0D then
                        "Last Placement Date" := Employee."Last Placement Date"
                    else
                        "Last Placement Date" := Employee."Employment Date";
                end
                else
                    "Employee Name" := '';
            end;

            trigger OnLookup()
            var
                AssignmentMemoHdr: Record "Assignment Memo Header";
            begin
                //lookup employee based on header org structure filters
                if AssignmentMemoHdr.Get("Document No.") then
                    Validate("Employee No.", HrMgt.LookupEmployeeByOrgStructure(AssignmentMemoHdr."Province Code",
                      AssignmentMemoHdr."Branch Code", AssignmentMemoHdr."Department Code",
                      AssignmentMemoHdr."Unit Code", ''));
            end;
        }
        field(6; "Employee Name"; Text[100]) { }
        field(7; "From Date"; Date)
        {
            trigger OnValidate()
            var
                EngNepDate: Record "English-Nepali Date";
                IsHandled: Boolean;
            begin
                OnBeforeFromDateValidation(Rec, IsHandled);
                if not IsHandled then begin
                    if Rec."From Date" <> xRec."From Date" then begin
                        Clear("To Date");
                    end;
                end;
                if "From Date" <> 0D then
                    CheckandValidateTheDates("From Date");
                if "From Date" <> 0D then
                    Validate("From date(BS)", EngNepDate.getNepaliDate("From Date"))
                else
                    Clear("From Date(BS)");

                if ("From Date" <> 0D) and ("To Date" <> 0D) then
                    "No. of Days" := "To Date" - "From Date" + 1;

                CheckDuplicateAssignmentMemoLine(Rec);
            end;
        }
        field(8; "To Date"; Date)
        {
            trigger OnValidate()
            var
                EngNepDate: Record "English-Nepali Date";
            begin
                if "To Date" <> 0D then
                    Validate("To date(BS)", EngNepDate.getNepaliDate("To Date"))
                else
                    Clear("From Date(BS)");

                if "To Date" <> 0D then
                    CheckandValidateTheDates("To Date");

                if ("From Date" <> 0D) and ("To Date" <> 0D) then
                    "No. of Days" := "To Date" - "From Date" + 1;

                CheckDuplicateAssignmentMemoLine(Rec);

                //calculate the amout for requested allowance line
                if "To Date" <> 0D then
                    if "Emp Act Type" = "Emp Act Type"::"Request Allowance" then begin
                        if ("Payroll Attribute Code" <> '') and ("Employee No." <> '') then
                            CalculateAmountForLine();
                    end;
            end;
        }
        field(9; "Payroll Attribute Code"; Code[20])
        {
            TableRelation = "Allowance Configuration"."Payroll Attribute";

            trigger OnValidate()
            begin

                if "Payroll Attribute Code" <> '' then begin
                    AllowanceConfiguration.Reset();
                    AllowanceConfiguration.SetRange("Payroll Attribute", "Payroll Attribute Code");
                    if not AllowanceConfiguration.FindFirst() then
                        Error('Invalid allowance selected!');

                    //check if assignment memo header contains the same payroll attribute
                    if AssignmentMemoHdr.Get("Document No.") then
                        if AssignmentMemoHdr."Payroll Attribute Code" <> '' then
                            if AssignmentMemoHdr."Payroll Attribute Code" <> "Payroll Attribute Code" then
                                Error('Payroll Attribute Code does not match with the header.');

                    if Employee.Get("Employee No.") then begin
                        SalaryLevel.Get(Employee."Salary Level");
                        if Employee."Vehicle Type" = Employee."Vehicle Type"::"Four Wheeler" then begin
                            "Fuel Limit (ltr)" := SalaryLevel."Fuel Limit (ltr)";
                            if "Fuel Limit (ltr)" = 0 then
                                "Fuel Limit (amt)" := SalaryLevel."Transportation Allowance";
                        end;
                    end;
                    if PayrollAttributes.Get("Payroll Attribute Code") then
                        "Payroll Attribute Description" := PayrollAttributes.Description;
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
        field(13; "Document Date"; Date) { }
        field(19; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }
        field(20; "No. of Days"; Decimal)
        {
            Editable = false;
        }
        field(23; Panel; Enum Panel) { }
        field(24; "Allowance Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                if ("Allowance Amount" <> 0) and ("Fuel Claimed (ltr)" <> 0) then
                    "Amount per Ltr." := Round("Allowance Amount" / "Fuel Claimed (ltr)", 0.01, '=');
            end;
        }
        field(25; "Rejection Remarks"; Text[250]) { }
        field(27; "Emp Act Type"; Enum "Employee Activity Type") { }
        field(31; "No of Approved Days"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Assignment Memo Ledger Entry" where(
                                                 "Employee No." = field("Employee No."),
                                                 "Payroll Attribute Code" = field("Payroll Attribute Code"),
                                                 "Document No." = field("Document No."),
                                                 Open = const(true),
                                                 Reversed = const(false)));
        }
        field(32; "ATM Site"; Enum "ATM Site") { }
        field(33; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(34; "Vault Name"; Code[100])
        {


        }
        field(39; "Fuel Limit (ltr)"; Decimal) { }
        field(40; "Fuel Limit (amt)"; Decimal) { }
        field(41; "Fuel Claimed (ltr)"; Decimal)
        {
            trigger OnValidate()
            begin
                if ("Allowance Amount" <> 0) and ("Fuel Claimed (ltr)" <> 0) then
                    "Amount per Ltr." := Round("Allowance Amount" / "Fuel Claimed (ltr)", 0.01, '=');
            end;
        }
        field(42; "Specific Payroll Attribute"; Enum "Specific Payroll Attributes")
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Allowance Configuration"."Specific Payroll Attribute" where("Payroll Attribute" = field("Payroll Attribute Code")));
            Editable = false;
        }
        field(43; "Amount per Ltr."; Decimal) { }
        field(54; "Assign Memo Ledger Entry No."; Integer)
        {
            Editable = false;
            //will updated when requested against unclaimed ledger entry
        }
        field(55; "Attendance Checked"; Boolean)
        {
            Caption = 'Attendance Checked';
        }
        field(56; Reversed; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
        }
        field(61; "Last Placement Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date of joining current branch';
        }
        field(62; "Previous Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
            DataClassification = ToBeClassified;
        }
        field(63; "Payroll Attribute Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        //If there is education allowance then these fields will be used.
        field(101; "Name of Children"; Text[100])
        {
            Caption = 'Name of Children';
        }
        field(102; "School Name"; Text[100])
        {
            Caption = 'School Name';
        }
        field(103; "Grade/Class"; Text[50])
        {
            Caption = 'Grade/Class';
        }
        field(104; "Distance (KM)"; Decimal)
        {
            Caption = 'Distance (KM)';
            DecimalPlaces = 2 : 2;
        }
        field(105; "Effective From (Edu.)"; Date)
        {
            Caption = 'Effective From';
            Description = 'for education allowance only';
        }
        field(106; Discontinued; Boolean)
        {
            Caption = 'Discontinued';
        }
        field(107; "Effective Months (Edu.)"; Enum "Nepali Month")
        {
            Caption = 'Effective Months';
            Description = 'for education allowance only';
            trigger OnValidate()
            var
                PayCyclePeriod: Record "Pay Cycle Period";
            begin
                if "Effective Months (Edu.)" = "Effective Months (Edu.)"::" " then
                    exit;
                PGSetup.Get();
                PGSetup.TestField("Payroll Fiscal Year Start Date");

                PayCyclePeriod.SetRange("Nepali Month", "Effective Months (Edu.)");
                PayCyclePeriod.SetFilter("Start Date", '>=%1', PGSetup."Payroll Fiscal Year Start Date");
                PayCyclePeriod.FindFirst();
                Validate("Effective From (Edu.)", PayCyclePeriod."Start Date");
            end;
        }
        field(108; "From Date(BS)"; Code[20])
        {
        }
        field(109; "To date(BS)"; Code[20])
        {
        }

        //field related to shift assignment
        field(201; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift";
            trigger OnValidate()
            var
                EmployeeWorkShift: Record "Employee Work Shift";
                IsHandled1: Boolean;
            begin
                if EmployeeWorkShift.Get("Employee Work Shift") and ("Emp Act Type" = "Emp Act Type"::"Shift Assignment Memo") then begin
                    OnBeforeValidatePayrollattribute(Rec, IsHandled1);
                    if not IsHandled1 then begin
                        if EmployeeWorkShift."Payroll Attribute Code" = '' then
                            Error('Employee work shift %1 is not valid for shift assignment', "Employee Work Shift");
                        Validate("Payroll Attribute Code", EmployeeWorkShift."Payroll Attribute Code");
                        CheckAndValidateShiftAssignment();
                    end;
                end;
            end;
        }
        field(202; "Claimed as Leave"; Boolean)
        {
            Caption = 'Claimed as Leave';
        }
        //Reimbursement fields
        field(300; "Bill Date"; Date)
        {
            Caption = 'Bill Date';
            trigger OnValidate()
            begin
                if "Bill Date" <> 0D then begin
                    if "Bill Date" > WorkDate() then
                        Error('Bill Date cannot be a future date.');
                    CheckandValidateTheDates("Bill Date");
                end;
            end;
        }
        field(301; "Bill No."; Text[50])
        {
            Caption = 'Bill No.';
        }
        field(302; "Access Token"; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(303; "Assigned By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.") { }
        key(key2; "Access Token") { }
    }

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        LeaveEarn: Record "Leave Earn";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete);

        if AssignmentMemoLedgerEntry.Get("Assign Memo Ledger Entry No.") then begin
            AssignmentMemoLedgerEntry."Claimed Doc No." := '';
            AssignmentMemoLedgerEntry."Claimed" := false;
            AssignmentMemoLedgerEntry.Modify();
        end;

        LeaveEarn.SetRange("Claimed Document No.", "Document No.");
        if LeaveEarn.FindSet() then begin
            LeaveEarn.ModifyAll("Claimed Document No.", '');
            LeaveEarn.ModifyAll(Claimed, false);
        end;
    end;

    trigger OnInsert()
    begin
        "Document Date" := WorkDate();
        Validate("Approval Status", "Approval Status"::Open);

        if "Line No." = 0 then
            GetLineNo();

        CheckDuplicateAssignmentMemoLine(Rec);
        AutoCalculateDatesAndEmployee(Rec);
    end;

    trigger OnModify()
    begin
        CheckDuplicateAssignmentMemoLine(Rec);
        AutoCalculateDatesAndEmployee(Rec);
    end;

    var
        Employee: Record Employee;
        AssignmentMemoHdr: Record "Assignment Memo Header";
        PGSetup: Record "Payroll General Setup";
        HrMgt: Codeunit "HR Mgt.";
        SalaryLevel: Record "Salary Level";
        AllowanceConfiguration: Record "Allowance Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        EmployeeNo: code[60];

    local procedure GetLineNo()
    var
        AllowanceLine: Record "Assignment Memo Line";
    begin
        AllowanceLine.Reset;
        AllowanceLine.SetCurrentKey("Document No.", "Line No.");
        AllowanceLine.SetRange("Document No.", "Document No.");
        if AllowanceLine.FindLast then
            "Line No." := AllowanceLine."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    procedure GetAllowanceConfigAmount(AllowanceConfig: Record "Allowance Configuration"): Decimal
    var
        MonthlyAmt: Decimal;
        NoofDaysInMonth: Integer;
        AssignmentmemoHdr: Record "Assignment Memo Header";
        IsHandled: Boolean;
        Results: Decimal;
    begin
        OnBeforGetAllowanceConfigAmount(AllowanceConfig, Rec, IsHandled, Results);
        if IsHandled then
            exit(Results);

        AssignmentmemoHdr.Get("Document No.");
        if "From Date" <> 0D then
            NoofDaysInMonth := GetNoofDaysInMonth("From Date")
        else
            NoofDaysInMonth := GetNoofDaysInMonth(AssignmentmemoHdr."From Date");

        if AllowanceConfig."Earning Cycle" = AllowanceConfig."Earning Cycle"::Daily then
            exit(AllowanceConfig.Amount);

        if AllowanceConfig.Source in [AllowanceConfig.Source::Direct, AllowanceConfig.Source::Leave] then
            if AllowanceConfig.Formula = '' then
                exit(AllowanceConfig.Amount)
            else begin
                OnBeforeCalculateAssignmentProrataAmount(MonthlyAmt, AllowanceConfig, Rec, NoofDaysInMonth, IsHandled);
                if not IsHandled then
                    exit(AllowanceConfig.EvaluateAmountForEmployee(AllowanceConfig.Formula, "Employee No."))
                else
                    exit(MonthlyAmt);
            end;

        if AllowanceConfig.Source in [AllowanceConfig.Source::Assignment, AllowanceConfig.Source::Shift] then begin
            if AllowanceConfig.Formula = '' then
                MonthlyAmt := AllowanceConfig.Amount
            else begin
                OnBeforeCalculateAssignmentProrataAmount(MonthlyAmt, AllowanceConfig, Rec, NoofDaysInMonth, IsHandled);
                if not IsHandled then
                    MonthlyAmt := AllowanceConfig.EvaluateAmountForEmployee(AllowanceConfig.Formula, "Employee No.");
            end;

            exit(Round(MonthlyAmt / NoofDaysInMonth, 0.0001, '='));
        end;
    end;

    procedure CheckandValidateTheDates(DateToCheck: Date)
    var
        AssignmentmemoHdr: Record "Assignment Memo Header";
        Employee: Record Employee;
    begin
        AssignmentmemoHdr.Get("Document No.");

        AssignmentmemoHdr.TestField("From Date");
        AssignmentmemoHdr.TestField("To Date");
        if (DateToCheck < AssignmentmemoHdr."From Date") or (DateToCheck > AssignmentmemoHdr."To Date") then
            Error('Date is not within the valid range.');

        if Employee.Get("Employee No.") then
            if DateToCheck < Employee."Employment Date" then
                Error('Date cannot be before employment date %1.', Employee."Employment Date");

        if ("From Date" <> 0D) and ("To Date" <> 0D) then
            if "From Date" > "To Date" then
                Error('From Date cannot be greater than To Date');

    end;

    procedure GetNoofDaysInMonth(DateToCheck: Date): Integer
    var
        PayCyclePeriod: Record "Pay Cycle Period";
        PGSetUP: Record "Payroll General Setup";
        TotalDays: Integer;
        NonWorkingDays: Integer;
        leaveMgt: Codeunit "Leave Mgt.";
        AssignmentHeader: Record "Assignment Memo Header";
    begin
        Clear(TotalDays);
        Clear(NonWorkingDays);
        PGSetUP.Get();
        PayCyclePeriod.SetFilter("Start Date", '<=%1', DateToCheck);
        PayCyclePeriod.SetFilter("End Date", '>=%1', DateToCheck);
        PayCyclePeriod.FindFirst();
        case PGSetUP."Allowance days basedOn" of
            PGSetUp."Allowance days basedOn"::"Total days", PGSetUP."Allowance days basedOn"::" ":
                begin
                    exit(PayCyclePeriod."End Date" - PayCyclePeriod."Start Date" + 1)
                end;
            PGSetUP."Allowance days basedOn"::"Working days":
                begin
                    AssignmentHeader.Get("Document No.");
                    if (PayCyclePeriod."Allowance Start Date" <> 0D) and (PayCyclePeriod."Allowance End Date" <> 0D) then begin
                        TotalDays := PayCyclePeriod."Allowance End Date" - PayCyclePeriod."Allowance Start Date" + 1;
                        // NonWorkingDays := leaveMgt.GetNonWorkingDays(PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date", HrMgt.GetEmployeeNo());
                        NonWorkingDays := leaveMgt.GetNonWorkingDays(PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date", AssignmentHeader."Employee No.");
                    end else begin
                        TotalDays := PayCyclePeriod."End Date" - PayCyclePeriod."Start Date" + 1;
                        // NonWorkingDays := leaveMgt.GetNonWorkingDays(PayCyclePeriod."Start Date", PayCyclePeriod."End Date", HrMgt.GetEmployeeNo());
                        NonWorkingDays := leaveMgt.GetNonWorkingDays(PayCyclePeriod."Start Date", PayCyclePeriod."End Date", AssignmentHeader."Employee No.");
                    end;
                    exit(TotalDays - NonWorkingDays);
                end;
        end;
    end;

    //calculate allowance amount for the line before send for approval
    procedure CalculateAmountForLine()
    var
        IsHandled: Boolean;
    begin
        if "Payroll Attribute Code" <> '' then begin
            OnBeforeCalculateAmountForLine(Rec, IsHandled);

            if IsHandled then
                exit;

            AllowanceConfiguration.Reset();
            AllowanceConfiguration.SetRange("Payroll Attribute", "Payroll Attribute Code");
            AllowanceConfiguration.SetFilter("ATM Site", '%1|%2', "ATM Site"::" ", "ATM Site");
            if AllowanceConfiguration.FindSet() then begin
                repeat
                    if AllowanceConfiguration.IsValidAllowanceConfigurationForEmployee(AllowanceConfiguration, "Employee No.", "To Date") then
                        "Allowance Amount" := GetAllowanceConfigAmount(AllowanceConfiguration);
                    if "Allowance Amount" <> 0 then
                        break;
                until AllowanceConfiguration.Next() = 0;
            end;
        end;
    end;

    procedure CheckDuplicateAssignmentMemoLine(PAssignMemo: Record "Assignment Memo Line")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        AtmPayrollAttr, PayrollAttr : Record "Payroll Attributes";
        AllowanceConfig: Record "Allowance Configuration";
    begin
        if PAssignMemo."Employee No." = '' then
            exit;
        if PAssignMemo."Payroll Attribute Code" <> '' then begin
            if PAssignMemo."Emp Act Type" = PAssignMemo."Emp Act Type"::"Request Allowance" then begin
                PayrollAttr.Get(PAssignMemo."Payroll Attribute Code");
                if PayrollAttr."Specific Attributes" <> PayrollAttr."Specific Attributes"::"Holiday Allowance" then
                    exit;
            end;

            AtmPayrollAttr.SetRange("Specific Attributes", AtmPayrollAttr."Specific Attributes"::"ATM Allowance");
            if AtmPayrollAttr.FindFirst() then;
            if PAssignMemo."Payroll Attribute Code" = AtmPayrollAttr.Code then
                exit; // allow multiple entries for atm and vault key allowance

            if PAssignMemo."Line No." = 0 then
                exit;

            PayrollAttr.Get(PAssignMemo."Payroll Attribute Code");

            AssignmentMemoLine.SetRange("Employee No.", PAssignMemo."Employee No.");
            if PAssignMemo."Payroll Attribute Code" <> '' then
                AssignmentMemoLine.SetRange("Payroll Attribute Code", PAssignMemo."Payroll Attribute Code")
            else if PAssignMemo."Employee Work Shift" <> '' then
                AssignmentMemoLine.SetRange("Employee Work Shift", PAssignMemo."Employee Work Shift");

            if PayrollAttr."Specific Attributes" = PayrollAttr."Specific Attributes"::"Vault Key Allowance" then
                AssignmentMemoLine.SetRange("Vault Name", PAssignMemo."Vault Name");
            AssignmentMemoLine.SetRange("Document No.", PAssignMemo."Document No.");
            AssignmentMemoLine.SetFilter("Approval Status", '<>%1', PAssignMemo."Approval Status"::"Rejected");  //for same document check all status line except reject.
            AssignmentMemoLine.SetFilter("From Date", '<=%1', PAssignMemo."To Date");
            AssignmentMemoLine.SetFilter("To Date", '>=%1', PAssignMemo."From Date");
            AssignmentMemoLine.SetFilter("Line No.", '<>%1', PAssignMemo."Line No.");
            if not AssignmentMemoLine.IsEmpty() then
                Error('Duplicate assignment of %1 for %2 at date %3', PAssignMemo."Payroll Attribute Code", PAssignMemo."Employee Name", Format(PAssignMemo."From Date"));
        end;
        OnCheckDuplicateAssignmentMemoLineOnAfterCheck(PAssignMemo);
    end;

    procedure AutoCalculateDatesAndEmployee(var AssignmentMemoLine: Record "Assignment Memo Line")
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        Ishandled: Boolean;
    begin
        if AssignmentMemoLine."Emp Act Type" <> AssignmentMemoLine."Emp Act Type"::"Request Allowance" then
            exit;
        OnBeforeCalculateDateAndEmployee(AssignmentMemoLine, Ishandled);
        if not Ishandled then begin
            if AssignmentMemoHdr.Get(AssignmentMemoLine."Document No.") then begin
                if AssignmentMemoLine."Employee No." = '' then
                    AssignmentMemoLine.Validate("Employee No.", AssignmentMemoHdr."Employee No.");
                if AssignmentMemoLine."From Date" = 0D then
                    AssignmentMemoLine.Validate("From Date", AssignmentMemoHdr."From Date");
                if AssignmentMemoLine."To Date" = 0D then
                    AssignmentMemoLine.Validate("To Date", AssignmentMemoHdr."To Date");
                if (AssignmentMemoLine."From Date" <> 0D) and (AssignmentMemoLine."To Date" <> 0D) then
                    AssignmentMemoLine."No. of Days" := AssignmentMemoLine."To Date" - AssignmentMemoLine."From Date" + 1;
            end;
        end;
    end;

    procedure CheckAndValidateShiftAssignment()
    var
        AllowanceConfig: Record "Allowance Configuration";
        IsEligibleForShiftAllowance: Boolean;
        AssignmentmemoMgt: Codeunit "Assignment Memo Mgt";
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        if "Emp Act Type" <> "Emp Act Type"::"Shift Assignment Memo" then
            exit;

        if "Payroll Attribute Code" = '' then
            exit;

        AssignmentMemoHdr.Get("Document No.");

        AllowanceConfig.SetRange(Source, AllowanceConfig.Source::Shift);
        AllowanceConfig.SetRange("Payroll Attribute", "Payroll Attribute Code");
        if AllowanceConfig.FindSet() then
            repeat
                if AllowanceConfig.IsValidAllowanceConfigurationForEmployee(AllowanceConfig, "Employee No.", "From Date") then begin
                    IsEligibleForShiftAllowance := true;
                    break;
                end;
            until AllowanceConfig.Next() = 0;

        if not IsEligibleForShiftAllowance then
            Error('Not eligible for selected shift.');

    end;

    procedure CopyFromAssignmentMemoLedgerEntry(AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry")
    begin
        Validate("Employee No.", AssignmentMemoLedgerEntry."Employee No.");
        Validate("Employee No.", AssignmentMemoLedgerEntry."Employee No.");
        Validate("Payroll Attribute Code", AssignmentMemoLedgerEntry."Payroll Attribute Code");
        Validate("From Date", AssignmentMemoLedgerEntry."Posting Date");
        Validate("To Date", AssignmentMemoLedgerEntry."Posting Date");
        Validate("Allowance Amount", AssignmentMemoLedgerEntry.Amount);
        "Assign Memo Ledger Entry No." := AssignmentMemoLedgerEntry."Entry No.";
        Validate("ATM Site", AssignmentMemoLedgerEntry."ATM Site");
        Validate("Vault Name", AssignmentMemoLedgerEntry."Vault Name");
        Validate(Panel, AssignmentMemoLedgerEntry.Panel);
    end;

    procedure GetLineNo(DocNo: Code[20]): Integer
    var
        AllowanceAssignmentMemoLine: Record "Assignment Memo Line";
    begin
        AllowanceAssignmentMemoLine.Reset;
        AllowanceAssignmentMemoLine.SetCurrentKey("Document No.", "Line No.");
        AllowanceAssignmentMemoLine.SetRange("Document No.", DocNo);
        if AllowanceAssignmentMemoLine.FindLast then
            exit(AllowanceAssignmentMemoLine."Line No." + 10000)
        else
            exit(10000);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateAmountForLine(var AssignmentMemoLine: Record "Assignment Memo Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckDuplicateAssignmentMemoLineOnAfterCheck(var AssignmentMemoLine: Record "Assignment Memo Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidatePayrollattribute(var AssignmentMemoLine: Record "Assignment Memo Line"; var IsHandled1: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateDateAndEmployee(var AssignmentMemoLine: Record "Assignment Memo Line"; var IsHandled1: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforGetAllowanceConfigAmount(allowanceConfig: Record "Allowance Configuration"; var AssignmentMemoLine: Record "Assignment Memo Line"; var IsHandled: Boolean; var Results: Decimal)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateAssignmentProrataAmount(var MonthlyAmt: Decimal; AllowanceConfig: Record "Allowance Configuration"; var AssignmentMemoLine: Record "Assignment Memo Line"; NoofDaysInMonth: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFromDateValidation(var AssignmentMemoLine: Record "Assignment Memo Line"; var IsHandled: Boolean)
    begin
    end;
}