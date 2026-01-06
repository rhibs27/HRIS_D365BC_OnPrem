table 50163 "Assignment Memo Ledger Entry"
{
    //data in this table will be created only after approval of assignment memo documents.
    Caption = 'Assignment Memo Ledger Entry';
    DataClassification = ToBeClassified;
    LookupPageId = "Assignment Memo Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            // TableRelation = "Assignment Memo Header";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            trigger OnValidate()
            var
                PayCyclePeriod: Record "Pay Cycle Period";
            begin
                // validate paycycle related fields based on posting date
                PayCyclePeriod.SetFilter("Start Date", '<=%1', "Posting Date");
                PayCyclePeriod.SetFilter("End Date", '>=%1', "Posting Date");
                if PayCyclePeriod.FindFirst() then begin
                    "Pay Cycle Code" := PayCyclePeriod."Pay Cycle Code";
                    "Pay Cycle Term" := PayCyclePeriod."Pay Cycle Term";
                    "Pay Cycle Period" := PayCyclePeriod."Period";
                    "Nepali Month" := PayCyclePeriod."Nepali Month";
                end else begin
                    "Pay Cycle Code" := '';
                    "Pay Cycle Term" := '';
                    "Pay Cycle Period" := 0;
                    "Nepali Month" := "Nepali Month"::" "
                end;
            end;
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then
                    "Employee Name" := Employee.FullName()
                else
                    "Employee Name" := '';
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(7; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(8; "Substituted Employee No."; Code[20])
        {
            Caption = 'Substituted Employee No.';
        }
        field(9; "Payroll Document No."; Code[20])
        {
            Caption = 'Payroll Document No.';
        }
        field(10; "Employee Activity Type"; Enum "Employee Activity Type")
        {
            Caption = 'Employee Activity Type';
        }
        field(11; "Payroll Attribute Code"; Code[20])
        {
            Caption = 'Payroll Attribute Code';
            TableRelation = "Payroll Attributes";
        }
        field(12; "Valid From Date"; Date)
        {
            Caption = 'Valid From Date';
        }
        field(13; "Valid To Date"; Date)
        {
            Caption = 'Valid To Date';
        }
        field(14; Claimed; Boolean)
        {
            Caption = 'Claimed';
        }
        field(15; "Claimed Doc No."; Code[20])
        {
            Caption = 'Claimed Doc No.';
        }
        field(16; Panel; Enum Panel) { }
        field(17; "ATM Site"; Enum "ATM Site") { }
        field(18; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift";
        }
        field(19; "Payroll Posted"; Boolean)
        {
            Caption = 'Payroll Posted';
            editable = false;
        }
        field(20; "Vault Name"; Code[100])
        {
            Caption = 'Vault Name';
        }
        //attendance related fields (for employee activity type = Assignment and shift)
        field(50; "Present Days"; Decimal)
        {
            Caption = 'Present Days';
            FieldClass = FlowField;
            CalcFormula = sum("Employee Attendance & Activity"."Present Day" where("Employee No." = field("Employee No."), "Attendance Date" = field("Posting Date")));
            Editable = false;
        }
        field(51; "Week Off Days"; Decimal)
        {
            Caption = 'Week Off Days';
            FieldClass = FlowField;
            CalcFormula = sum("Employee Attendance & Activity"."Week Off Day" where("Employee No." = field("Employee No."), "Attendance Date" = field("Posting Date")));
            Editable = false;
        }
        field(52; "Leave Days"; Decimal)
        {
            Caption = 'Leave Days';
            FieldClass = FlowField;
            CalcFormula = sum("Employee Attendance & Activity"."Leave Day" where("Employee No." = field("Employee No."), "Attendance Date" = field("Posting Date")));
            Editable = false;
        }
        field(53; "Absent Days"; Decimal)
        {
            Caption = 'Absent Days';
            FieldClass = FlowField;
            CalcFormula = sum("Employee Attendance & Activity"."Absent Day" where("Employee No." = field("Employee No."), "Attendance Date" = field("Posting Date")));
            Editable = false;
        }
        field(54; "Attendance Checked"; Boolean)
        {
            Caption = 'Attendance Checked';
        }
        field(55; "Blocked for Payroll"; Boolean)
        {
            Caption = 'Blocked for Payroll';
        }
        field(56; Reversed; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
        }
        field(57; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(58; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(59; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(60; "Nepali Month"; Enum "Nepali Month") { }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Employee No.", "Document No.", "Posting Date", "Employee Activity Type") { }
        key(key3; "Payroll Document No.", "Substituted Employee No.", Open, "Blocked for Payroll") { }
    }

    procedure GetNextEntryNo(): Integer
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if AssignmentMemoLedgerEntry.FindLast() then
            exit(AssignmentMemoLedgerEntry."Entry No." + 1)
        else
            exit(1);
    end;

    // procedure CheckDuplicateLedgerEntryExist(EmployeeNo: Code[20]; PostingDate: Date; EmpActType: Enum "Employee Activity Type"; PayrollAttrCode: Code[20]; EntryNo: Integer): Boolean
    // var
    //     AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    // begin
    //     AssignmentMemoLedgerEntry.SetLoadFields("Entry No.", "Employee No.", "Posting Date", "Employee Activity Type", "Payroll Attribute Code");
    //     AssignmentMemoLedgerEntry.SetRange("Employee No.", EmployeeNo);
    //     AssignmentMemoLedgerEntry.SetRange("Posting Date", PostingDate);
    //     AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", EmpActType);
    //     AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", PayrollAttrCode);
    //     AssignmentMemoLedgerEntry.SetFilter("Entry No.", '<> %1', EntryNo);
    //     if AssignmentMemoLedgerEntry.IsEmpty() then
    //         exit(false)
    //     else
    //         exit(true);
    // end;
}
