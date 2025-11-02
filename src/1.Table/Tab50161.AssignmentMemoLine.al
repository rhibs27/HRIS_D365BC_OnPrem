table 50161 "Assignment Memo Line"
{
    Caption = 'Assignment Memo Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; "Line No."; Integer)
        {
        }

        field(5; "Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee Code") then
                    "Employee Name" := Employee."Full Name"
                else
                    "Employee Name" := '';
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
            end;
        }
        field(8; "To Date"; Date)
        {
            trigger OnValidate()
            begin
                if "To Date" <> 0D then
                    if "From Date" > "To Date" then
                        Error('Invalid date.');
            end;
        }
        field(9; "Allowance Type"; Code[20])
        {

            TableRelation = "Payroll Attributes";

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
        field(13; "Document Date"; Date) { }
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
                    PGSetup.Get;
                    if not PGSetup."Use Allowance Configuration" then begin
                        PGSetup.TestField("Vault Key");
                        PGSetup.TestField("ATM Custodian");
                        if ("Allowance Type" <> PGSetup."Vault Key") and ("Allowance Type" <> PGSetup."ATM Custodian") then
                            Error('Panel is not allowed in this Allowance Type');
                        // AllowanceMgt.CheckForPanel(Rec);
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
        field(29; "Allowance Claimed"; Boolean) { }
        field(30; "Allowance Claim from Line No"; Integer) { }
        field(50; "Leave Code"; Code[20]) { }
        field(51; "Leave Document No"; Code[20]) { }
        field(52; "Payroll Doc No."; Code[20]) { }
        field(53; "Recurring Completed"; Boolean) { }
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
        "Document Date" := WorkDate();
        Validate("Approval Status", "Approval Status"::Open);

        if "Line No." = 0 then
            GetLineNo();

        if ("Emp Act Type" = "Emp Act Type"::"Request Allowance") and AssignmentMemoHdr.Get("No.") then
            if AssignmentMemoHdr."Requester Employee No." <> '' then
                Validate("Employee Code", AssignmentMemoHdr."Requester Employee No.");
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

    // local procedure ValidateDate()
    // var
    //     PayrollAttribute: Record "Payroll Attributes";
    //     PayrollAttribute1: Record "Payroll Attributes";
    // begin
    //     "No. of Days" := 0;
    //     //if one mutual exclusive allowance is already selected, no other mutually exclusive allowance is allowed.
    //     AllowanceLine.Reset;
    //     AllowanceLine.SetRange("No.", "No.");
    //     AllowanceLine.SetFilter("Line No.", '<>%1', "Line No.");
    //     AllowanceLine.SetFilter("From Date", '<=%1', "From Date");
    //     AllowanceLine.SetFilter("To Date", '>=%1', "From Date");
    //     AllowanceLine.SetFilter("Allowance Type", '<>%1', "Allowance Type");
    //     AllowanceLine.SetRange(Type, Type);
    //     if AllowanceLine.FindFirst then
    //         repeat
    //             PayrollAttribute.Get("Allowance Type");
    //             if PayrollAttribute."Mutually Exclusive" then begin
    //                 PayrollAttribute1.Get(AllowanceLine."Allowance Type");
    //                 if PayrollAttribute1."Mutually Exclusive" then
    //                     Error(TEXT001, AllowanceLine."Allowance Type", "Allowance Type", AllowanceLine."From Date");
    //             end;
    //         until AllowanceLine.Next = 0;
    //     if Rec."Substitute Type" = Rec."Substitute Type"::" " then begin
    //         AllowanceLine.Reset;
    //         AllowanceLine.SetRange("No.", "No.");
    //         AllowanceLine.SetRange(Type, Type);
    //         AllowanceLine.SetRange("Allowance Type", "Allowance Type");
    //         AllowanceLine.SetRange(Code, Code);
    //         AllowanceLine.SetRange("From Date", "From Date");
    //         AllowanceLine.Setfilter("Substitute Type", '%1', AllowanceLine."Substitute Type"::" ");
    //         AllowanceLine.SetFilter("Employee Code", '<>%1', '');
    //         if AllowanceLine.FindFirst then
    //             if BranchwiseAllowance.Get(Type, Code, "Allowance Type") then
    //                 if BranchwiseAllowance."Max. No. of Staffs" <> 0 then
    //                     if AllowanceLine.Count + 1 > BranchwiseAllowance."Max. No. of Staffs" then
    //                         Error(TEXT002, Name, "Allowance Type",
    //                                 BranchwiseAllowance.FieldCaption("Max. No. of Staffs"));
    //     end;
    //     AllowanceHeader.Get("No.");
    //     if AllowanceHeader."Activity Type" <> "Emp Act Type"::"Allowance Assignment Claim" then begin
    //         AllowanceHeader.TestField("From Date");
    //         AllowanceHeader.TestField("To date");
    //         if "From Date" <> 0D then
    //             if ("From Date" < AllowanceHeader."From Date") or ("From Date" > AllowanceHeader."To date") then
    //                 Error('Date is not within period.');

    //         if "To Date" <> 0D then
    //             if "To Date" > AllowanceHeader."To date" then
    //                 Error('Date is not within period.');
    //         CalculateNoOfDays(Rec);
    //     end;

    // end;

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
        if AssignmentMemoLine."Substitute Type" = "Substitute Type"::"Added as Substitute" then begin
            if ("From Date" = 0D) or ("To Date" = 0D) then
                exit;
            AssignmentMemoLine.Get("No.", "Substitute of Line No.");
            NewToDate := AssignmentMemoLine."To Date";
            if AssignmentMemoLine."From Date" = "From Date" then
                AssignmentMemoLine.Delete(true);

            if not GuiAllowed then begin
                AssignmentMemoHdr.Reset;
                AssignmentMemoHdr.Get("No.");
            end;
            if "From Date" - 1 >= AssignmentMemoHdr."From Date" then begin
                AssignmentMemoLine."To Date" := "From Date" - 1;
                // AllowanceLine.CalculateNoOfDays(AllowanceLine);
                AssignmentMemoLine.Modify(true);
            end;

            NewFromDate := "To Date" + 1;

            if (NewFromDate >= AssignmentMemoHdr."From Date") and (NewToDate <> "To Date") then begin
                //insert new line
                AssignmentMemoLine2.Reset;
                AssignmentMemoLine2.Init;
                AssignmentMemoLine2."No." := "No.";
                AssignmentMemoLine2.Validate("Allowance Type", AssignmentMemoLine."Allowance Type");
                AssignmentMemoLine2.Validate("Employee Code", AssignmentMemoLine."Employee Code");
                AssignmentMemoLine2."Substitute of Line No." := AssignmentMemoLine."Line No.";
                AssignmentMemoLine2."Substitute Type" := AssignmentMemoLine2."Substitute Type"::"Added as Substitute";
                AssignmentMemoLine2."From Date" := NewFromDate;
                AssignmentMemoLine2."To Date" := NewToDate;
                AssignmentMemoHdr.Validate("Approval Status", AssignmentMemoHdr."Approval Status"::"Pending");
                AssignmentMemoHdr.Modify;
                // AllowanceLine1.CalculateNoOfDays(AllowanceLine1);
                AssignmentMemoLine2.Insert(true);
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
        if AssignmentMemoHdr."To date" + PGSetup."Allowance Grace Period" < Today then
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