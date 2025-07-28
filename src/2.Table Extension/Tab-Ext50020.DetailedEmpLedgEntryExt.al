tableextension 50020 "Detailed Emp. Ledg. Entry Ext" extends "Detailed Employee Ledger Entry"
{
    fields
    {
        field(50000; "G/L Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
        }
        field(50003; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
        }
        field(50004; "Payroll Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes";
            DataClassification = ToBeClassified;
        }
        field(50005; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
            DataClassification = ToBeClassified;
        }
        field(50006; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Period"."Pay Cycle Term" where("Pay Cycle Code" = field("Pay Cycle Code"));
            DataClassification = ToBeClassified;
        }
        field(50007; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                                                                  "Pay Cycle Term" = field("Pay Cycle Term"));
            DataClassification = ToBeClassified;
        }
        field(50008; "Pay Period Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Pay Period End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Attribute Type"; Enum "Attribute Type")
        {
            DataClassification = ToBeClassified;

        }
        field(50011; "Attribute Sub Type"; Enum "Payroll SubType")
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            DataClassification = ToBeClassified;
            Caption = 'Dimension Set ID';
            Editable = false;
        }
        field(50013; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Non-Taxable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
            DataClassification = ToBeClassified;
        }
        field(50017; "Posted Payroll Plan Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            DataClassification = ToBeClassified;
            Editable = false;
            CaptionClass = '1,2,3';
        }
        field(50019; "Shortcut Dimension 4 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            DataClassification = ToBeClassified;
            Editable = false;
            CaptionClass = '1,2,4';
        }
        field(50020; "Shortcut Dimension 5 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            DataClassification = ToBeClassified;
            Editable = false;
            CaptionClass = '1,2,5';
        }
        field(50021; "Shortcut Dimension 6 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            DataClassification = ToBeClassified;
            Editable = false;
            CaptionClass = '1,2,6';
        }
        field(50022; "Shortcut Dimension 7 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            DataClassification = ToBeClassified;
            Editable = false;
            CaptionClass = '1,2,7';
        }
        field(50023; "Shortcut Dimension 8 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            DataClassification = ToBeClassified;
            Editable = false;
            CaptionClass = '1,2,8';
        }
        field(50024; "Salary Advance No."; Code[20])
        {
            TableRelation = "Employee Loan/Advance" where("Loan Type" = const("Salary Advance"));
            DataClassification = ToBeClassified;
        }
        field(50025; "Finacle GL No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Finacle GL Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Deputation On"; Enum "Deputation Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Deputation Value"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Sol ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Fiscal Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50031; Disabled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        Employee: Record Employee;
        PayrollAttributes: Record "Payroll Attributes";
        EngNepDate: Record "English-Nepali Date";

    procedure CopyFromPayrollJnlLine(var PayrollJournalLine: Record "Payroll Journal Line" temporary);
    begin
        "Employee No." := PayrollJournalLine."Employee No.";
        "Posting Date" := PayrollJournalLine."Posting Date";
        "Document Type" := PayrollJournalLine."Document Type";
        "Document No." := PayrollJournalLine."Document No.";
        Description := PayrollJournalLine.Description;
        Amount := PayrollJournalLine.Amount;
        "Source Code" := PayrollJournalLine."Source Code";
        "Payroll Attribute Code" := PayrollJournalLine."Attribute Code";
        "Pay Cycle Code" := PayrollJournalLine."Pay Cycle Code";
        "Pay Cycle Term" := PayrollJournalLine."Pay Cycle Term";
        "Pay Cycle Period" := PayrollJournalLine."Pay Cycle Period";
        "Pay Period Start Date" := PayrollJournalLine."Pay Period Start Date";
        "Pay Period End Date" := PayrollJournalLine."Pay Period End Date";
        "Attribute Type" := PayrollJournalLine."Attribute Type";
        "Attribute Sub Type" := PayrollJournalLine."Attribute Sub Type";
        "G/L Document No" := PayrollJournalLine."Posting No.";
        "Non-Taxable" := PayrollJournalLine."Non-Taxable";
        "Salary Advance No." := PayrollJournalLine."External Document No.";
        "Deputation On" := PayrollJournalLine."Deputation On";
        "Deputation Value" := PayrollJournalLine."Deputation Value";
        "Sol ID" := PayrollJournalLine."Sol ID";
        "Dimension Set ID" := PayrollJournalLine."Dimension Set ID";
        "Fiscal Year" := PayrollJournalLine."Fiscal Year";
        "Shortcut Dimension 1 Code" := PayrollJournalLine."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := PayrollJournalLine."Shortcut Dimension 2 Code";
        "Shortcut Dimension 3 Code" := PayrollJournalLine."Shortcut Dimension 3 Code";
        "Shortcut Dimension 4 Code" := PayrollJournalLine."Shortcut Dimension 4 Code";
        "Shortcut Dimension 5 Code" := PayrollJournalLine."Shortcut Dimension 5 Code";
        "Shortcut Dimension 6 Code" := PayrollJournalLine."Shortcut Dimension 6 Code";
        "Shortcut Dimension 7 Code" := PayrollJournalLine."Shortcut Dimension 7 Code";
        "Shortcut Dimension 8 Code" := PayrollJournalLine."Shortcut Dimension 8 Code";
        "Salary Advance No." := PayrollJournalLine."External Document No.";
        ValidateFincaleGL;
    end;

    procedure Navigate();
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "Document No.");
        NavigateForm.Run;
    end;

    local procedure ValidateFincaleGL();
    begin
        Employee.Get("Employee No.");
        PayrollAttributes.Get("Payroll Attribute Code");
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", "Pay Period Start Date");
        if EngNepDate.FindFirst then;

        if PayrollAttributes.Type in [PayrollAttributes.Type::Benefits, PayrollAttributes.Type::"Non-Payment"] then begin
            case Employee."Deputation on" of
                Employee."Deputation on"::Province:
                    begin
                        if PayrollAttributes."Static GL Ledger" then begin
                            PayrollAttributes.TestField("Static GL Ledger Account");
                            Validate("Finacle GL No", PayrollAttributes."Static GL Ledger Account" + PayrollAttributes."CBS Expense Code");
                        end else
                            Validate("Finacle GL No", Employee."Sol Id" + PayrollAttributes."CBS GL Code" + PayrollAttributes."CBS Expense Code");
                    end else begin
                    if PayrollAttributes."Static GL Ledger" then begin
                        PayrollAttributes.TestField("Static GL Ledger Account");
                        Validate("Finacle GL No", PayrollAttributes."Static GL Ledger Account" + PayrollAttributes."CBS GL Code");
                    end else
                        Validate("Finacle GL No", Employee."Sol Id" + PayrollAttributes."CBS GL Code");
                end;
            end;
        end else begin
            if PayrollAttributes."Static GL Ledger" then
                Validate("Finacle GL No", PayrollAttributes."Static GL Ledger Account" + PayrollAttributes."CBS GL Code")
            else
                Validate("Finacle GL No", PayrollAttributes."CBS GL Code")
        end;
        if PayrollAttributes."Finacle GL Name" <> '' then
            Validate("Finacle GL Name", StrSubstNo('%1 %2-%3', PayrollAttributes."Finacle GL Name", EngNepDate."Nepali Year", EngNepDate."Nepali Month"))
        else
            Clear("Finacle GL Name");
    end;
}
