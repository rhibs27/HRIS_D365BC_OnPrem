table 50162 "Assignment Memo Line"
{
    Caption = 'Assignment Memo Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer)
        {
        }

        field(5; "Employee No."; Code[20])
        {
            TableRelation = Employee where(Status = const(Active));
            trigger OnValidate()
            var
                AssignmentMemoHdr: Record "Assignment Memo Header";
            begin
                if Employee.Get("Employee No.") then
                    "Employee Name" := Employee."Full Name"
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
        field(6; "Employee Name"; Text[100])
        {
        }
        field(7; "From Date"; Date)
        {
            trigger OnValidate()
            begin
                if Rec."From Date" <> xRec."From Date" then begin
                    Clear("To Date");
                end;
                if "From Date" <> 0D then
                    CheckandValidateTheDates("From Date");

                if ("From Date" <> 0D) and ("To Date" <> 0D) then
                    "No. of Days" := "To Date" - "From Date" + 1;

                CheckDuplicateAssignmentMemoLine(Rec);
            end;
        }
        field(8; "To Date"; Date)
        {
            trigger OnValidate()
            begin
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
                        if Employee."Vehicle Type" in [Employee."Vehicle Type"::"Four Wheeler", Employee."Vehicle Type"::"Two Wheeler"] then begin
                            "Fuel Limit (ltr)" := SalaryLevel."Fuel Limit (ltr)";
                            "Fuel Limit (amt)" := SalaryLevel."Fuel Limit (amt)";
                        end;
                    end;
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
        field(23; Panel; Enum Panel)
        {

        }
        field(24; "Allowance Amount"; Decimal)
        {
        }
        field(25; "Rejection Remarks"; Text[100]) { }

        field(27; "Emp Act Type"; Enum "Employee Activity Type")
        {
        }

        field(31; "No of Approved Days"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Assignment Memo Ledger Entry" where(
                                                 "Employee No." = field("Employee No."),
                                                 "Payroll Attribute Code" = field("Payroll Attribute Code"),
                                                 "Document No." = field("Document No."),
                                                 Open = const(true)));
        }
        field(32; "ATM Site"; Enum "ATM Site") { }
        field(33; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }

        field(39; "Fuel Limit (ltr)"; Decimal) { }

        field(40; "Fuel Limit (amt)"; Decimal) { }
        field(41; "Fuel Claimed (ltr)"; Decimal)
        {
        }
        field(42; "Specific Payroll Attribute"; Enum "Specific Payroll Attributes")
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Allowance Configuration"."Specific Payroll Attribute" where("Payroll Attribute" = field("Payroll Attribute Code")));

        }
        field(54; "Assign Memo Ledger Entry No."; Integer)
        {
            Editable = false;
            //will updated when requested against unclaimed ledger entry
        }
        field(55; "Attendance Checked"; Boolean)
        {
            Caption = 'Attendance Checked';
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

        //field related to shift assignment
        field(201; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift";
            trigger OnValidate()
            var
                EmployeeWorkShift: Record "Employee Work Shift";
            begin
                if EmployeeWorkShift.Get("Employee Work Shift") and ("Emp Act Type" = "Emp Act Type"::"Shift Assignment Memo") then begin
                    if EmployeeWorkShift."Payroll Attribute Code" = '' then
                        Error('Employee work shift %1 is not valid for shift assignment', "Employee Work Shift");
                    Validate("Payroll Attribute Code", EmployeeWorkShift."Payroll Attribute Code");
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
        }
        field(301; "Bill No."; Text[50])
        {
            Caption = 'Bill No.';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.") { }
    }

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete);

        if AssignmentMemoLedgerEntry.Get("Assign Memo Ledger Entry No.") then begin
            AssignmentMemoLedgerEntry."Claimed Doc No." := '';
            AssignmentMemoLedgerEntry."Claimed" := false;
            AssignmentMemoLedgerEntry.Modify();
        end;
    end;

    trigger OnInsert()
    begin
        "Document Date" := WorkDate();
        Validate("Approval Status", "Approval Status"::Open);

        if "Line No." = 0 then
            GetLineNo();


        CheckDuplicateAssignmentMemoLine(Rec);
    end;

    var
        Employee: Record Employee;
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLine2: Record "Assignment Memo Line";
        BaseCalenderChange: Record "Base Calendar Change";
        TEXT001: Label '%1 and %2 cannot be assigned on same date %3.';
        TEXT002: Label 'Total No. of Employees in %1 in %2 exceeds %3.';
        PGSetup: Record "Payroll General Setup";
        HrMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        SalaryLevel: Record "Salary Level";
        OrganizationStructureList: Record "Organization Structure List";
        AllowanceConfiguration: Record "Allowance Configuration";

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
    begin
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
            else
                exit(AllowanceConfig.EvaluateAmountForEmployee(AllowanceConfig.Formula, "Employee No."));

        if AllowanceConfig.Source in [AllowanceConfig.Source::Assignment, AllowanceConfig.Source::Shift] then begin
            if AllowanceConfig.Formula = '' then
                MonthlyAmt := AllowanceConfig.Amount
            else
                MonthlyAmt := AllowanceConfig.EvaluateAmountForEmployee(AllowanceConfig.Formula, "Employee No.");

            exit(Round(MonthlyAmt / NoofDaysInMonth, 0.0001, '='));
        end;
    end;

    procedure CheckandValidateTheDates(DateToCheck: Date)
    var
        AssignmentmemoHdr: Record "Assignment Memo Header";
    begin
        AssignmentmemoHdr.Get("Document No.");
        if AssignmentmemoHdr."Activity Type" = AssignmentmemoHdr."Activity Type"::"Request Allowance" then
            exit;

        AssignmentmemoHdr.TestField("From Date");
        AssignmentmemoHdr.TestField("To Date");
        if (DateToCheck < AssignmentmemoHdr."From Date") or (DateToCheck > AssignmentmemoHdr."To Date") then
            Error('Date is not within the valid range.');
    end;

    procedure GetNoofDaysInMonth(DateToCheck: Date): Integer
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PayCyclePeriod.SetFilter("Start Date", '<=%1', DateToCheck);
        PayCyclePeriod.SetFilter("End Date", '>=%1', DateToCheck);
        PayCyclePeriod.FindFirst();
        exit(PayCyclePeriod."End Date" - PayCyclePeriod."Start Date" + 1);
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
    begin
        if PAssignMemo."Emp Act Type" = PAssignMemo."Emp Act Type"::"Request Allowance" then
            exit;
        if PAssignMemo."Employee No." = '' then
            exit;
        if PAssignMemo."Payroll Attribute Code" = '' then
            exit;
        if PAssignMemo."Line No." = 0 then
            exit;
        if PAssignMemo."ATM Site" <> PAssignMemo."ATM Site"::" " then   // for atm andvault key allow multiple entries
            exit;
        if PAssignMemo.Panel <> PAssignMemo.Panel::" " then
            exit;

        AssignmentMemoLine.SetRange("Employee No.", PAssignMemo."Employee No.");
        AssignmentMemoLine.SetRange("Payroll Attribute Code", PAssignMemo."Payroll Attribute Code");
        AssignmentMemoLine.SetRange("Document No.", PAssignMemo."Document No.");
        AssignmentMemoLine.SetFilter("Line No.", '<>%1', PAssignMemo."Line No.");
        if not AssignmentMemoLine.IsEmpty() then
            Error(TEXT001, PAssignMemo."Employee No.", PAssignMemo."Payroll Attribute Code", Format(PAssignMemo."From Date"));

        OnCheckDuplicateAssignmentMemoLineOnAfterCheck(PAssignMemo);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateAmountForLine(var AssignmentMemoLine: Record "Assignment Memo Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckDuplicateAssignmentMemoLineOnAfterCheck(var AssignmentMemoLine: Record "Assignment Memo Line")
    begin
    end;
}