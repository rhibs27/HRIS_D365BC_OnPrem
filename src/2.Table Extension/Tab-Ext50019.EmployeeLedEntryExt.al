tableextension 50019 "Employee Led. Entry Ext " extends "Employee Ledger Entry"
{
    fields
    {
        field(50000; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
            DataClassification = ToBeClassified;
        }
        field(50001; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Period"."Pay Cycle Term" where("Pay Cycle Code" = field("Pay Cycle Code"));
            DataClassification = ToBeClassified;
        }
        field(50002; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                                                                  "Pay Cycle Term" = field("Pay Cycle Term"));
            DataClassification = ToBeClassified;
        }
        field(50003; "Pay Period Start Date"; Date) { DataClassification = ToBeClassified; }
        field(50004; "Pay Period End Date"; Date) { DataClassification = ToBeClassified; }
        field(50005; "Creation Date"; Date) { DataClassification = ToBeClassified; }
        field(50006; "Present Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50007; "Week off Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50008; "Leave Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50009; "Absent Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50010; "Total Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50011; "Tour Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50012; "Half Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50013; "Late Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50014; "Overtime Days"; Decimal) { DataClassification = ToBeClassified; }
        field(50015; "Late Rate"; Decimal) { DataClassification = ToBeClassified; }
        field(50016; "OT Hrs (30MIN)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'OT Hrs (30MIN)';
            Editable = false;
        }
        field(50017; "G/L Document No"; Code[20]) { DataClassification = ToBeClassified; }
        field(50018; "Employee Name"; Text[250]) { DataClassification = ToBeClassified; }
        field(50019; Narration; Text[250]) { DataClassification = ToBeClassified; }
        field(50020; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
            DataClassification = ToBeClassified;
        }
        field(50021; "Posted Payroll Plan Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Payroll Attribute Code"; Code[20]) { DataClassification = ToBeClassified; }
        field(50023; "Fiscal Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50024; "Type"; Enum "Payroll Header Type")
        {
            DataClassification = ToBeClassified;
        }
    }
    procedure CopyFromPayrollJnlLine(var PayrollJournalLine: Record "Payroll Journal Line" temporary);
    begin
        "Employee No." := PayrollJournalLine."Employee No.";
        "Posting Date" := PayrollJournalLine."Posting Date";
        "Document Type" := PayrollJournalLine."Document Type";
        "Document No." := PayrollJournalLine."Document No.";
        "Source Code" := PayrollJournalLine."Source Code";
        "Pay Cycle Code" := PayrollJournalLine."Pay Cycle Code";
        "Pay Cycle Term" := PayrollJournalLine."Pay Cycle Term";
        "Pay Cycle Period" := PayrollJournalLine."Pay Cycle Period";
        "Pay Period Start Date" := PayrollJournalLine."Pay Period Start Date";
        "Pay Period End Date" := PayrollJournalLine."Pay Period End Date";
        "Present Days" := PayrollJournalLine."Present Days";
        "Week off Days" := PayrollJournalLine."Week off Days";
        "Leave Days" := PayrollJournalLine."Leave Days";
        "Absent Days" := PayrollJournalLine."Absent Days";
        "Total Days" := PayrollJournalLine."Total Days";
        "Tour Days" := PayrollJournalLine."Tour Days";
        "Half Days" := PayrollJournalLine."Half Days";
        "Late Days" := PayrollJournalLine."Late Days";
        "Overtime Days" := PayrollJournalLine."OT Days";
        "OT Hrs (30MIN)" := PayrollJournalLine."OT Hrs (30MIN)";
        "Late Rate" := PayrollJournalLine."Late Rate";
        Description := StrSubstNo('Payroll Plan %1, %2, %3', "Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period");
        "G/L Document No" := PayrollJournalLine."Posting No.";
        Narration := PayrollJournalLine.Narration;
        "Employee Name" := PayrollJournalLine."Employee Name";
        "Fiscal Year" := PayrollJournalLine."Fiscal Year";
        Type := PayrollJournalLine.Type;
    end;

    procedure Navigate();
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "G/L Document No");
        NavigateForm.Run;
    end;
}
