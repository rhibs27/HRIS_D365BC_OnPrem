table 50161 "Assignment Memo Line"
{
    Caption = 'Assignment Memo Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20]) { }
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

            trigger OnLookup()
            var
                AssignmentMemoHdr: Record "Assignment Memo Header";
            begin
                //lookup employee based on header org structure filters
                if AssignmentMemoHdr.Get("Document No.") then
                    Validate("Employee Code", HrMgt.LookupEmployeeByOrgStructure(AssignmentMemoHdr."Province Code",
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
            end;
        }
        field(8; "To Date"; Date)
        {
            trigger OnValidate()
            begin
                if "To Date" <> 0D then
                    if "From Date" > "To Date" then
                        Error('Invalid date.');

                if "To Date" <> 0D then
                    CheckandValidateTheDates("To Date");

                if ("From Date" <> 0D) and ("To Date" <> 0D) then
                    "No. of Days" := "To Date" - "From Date" + 1;
            end;
        }
        field(9; "Allowance Type"; Code[20])
        {

            TableRelation = "Allowance Configuration"."Payroll Attribute" where(source = const(Assignment));

            trigger OnValidate()
            begin

                if ("Emp Act Type" = "Emp Act Type"::"Request Allowance") and ("Allowance Type" <> '') then begin
                    AllowanceConfiguration.Reset();
                    AllowanceConfiguration.SetRange("Payroll Attribute", "Allowance Type");
                    if AllowanceConfiguration.FindFirst() then
                        "Allowance Amount" := GetAllowanceConfigAmount(AllowanceConfiguration)
                    else
                        Error('Invalid allowance selected!');
                    Clear(Panel);
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
        key(Key1; "Document No.", "Line No.") { }
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

        // if ("Emp Act Type" = "Emp Act Type"::"Request Allowance") and AssignmentMemoHdr.Get("Document No.") then
        //     if AssignmentMemoHdr."Requester Employee No." <> '' then
        //         Validate("Employee Code", AssignmentMemoHdr."Requester Employee No.");
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
        AllowanceLine.SetRange("No.", "Document No.");
        if AllowanceLine.FindLast then
            "Line No." := AllowanceLine."Line No." + 10000
        else
            "Line No." := 10000;
    end;


    procedure UpdateSubstitue()
    var
        NewToDate: Date;
        NewFromDate: Date;
    begin
        if AssignmentMemoLine."Substitute Type" = "Substitute Type"::"Added as Substitute" then begin
            if ("From Date" = 0D) or ("To Date" = 0D) then
                exit;
            AssignmentMemoLine.Get("Document No.", "Substitute of Line No.");
            NewToDate := AssignmentMemoLine."To Date";
            if AssignmentMemoLine."From Date" = "From Date" then
                AssignmentMemoLine.Delete(true);

            if not GuiAllowed then begin
                AssignmentMemoHdr.Reset;
                AssignmentMemoHdr.Get("Document No.");
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
                AssignmentMemoLine2."Document No." := "Document No.";
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

    procedure CheckandValidateTheDates(DateToCheck: Date)
    var
        AssignmentmemoHdr: Record "Assignment Memo Header";
    begin
        AssignmentmemoHdr.Get("Document No.");
        AssignmentmemoHdr.TestField("From Date");
        AssignmentmemoHdr.TestField("To Date");
        if (DateToCheck < AssignmentmemoHdr."From Date") or (DateToCheck > AssignmentmemoHdr."To Date") then
            Error('Date is not within the valid range.');
    end;
}