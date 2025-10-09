table 50028 "Pay Cycle"
{

    DrillDownPageId = "Pay Cycle";
    LookupPageId = "Pay Cycle";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Pay Frequency"; Enum "Pay Frequency")
        {
            trigger OnValidate()
            var
                PayrollLedgerEntry: Record "Employee Ledger Entry";
            begin
                PayrollLedgerEntry.SetRange("Pay Cycle Code", Code);
                if not PayrollLedgerEntry.IsEmpty() then
                    Error(Text001, PayrollLedgerEntry.TableCaption);
                "Pay Cycle Period".SetCurrentKey("Pay Cycle Code", "Pay Cycle Term");
                "Pay Cycle Period".SetRange("Pay Cycle Code", Code);
                if "Pay Cycle Period".FindFirst then
                    Error(Text004);
                PayCycleTerm.Reset;
                PayCycleTerm.SetCurrentKey("Pay Cycle Code");
                PayCycleTerm.SetRange("Pay Cycle Code", Code);
                if PayCycleTerm.FindFirst then
                    Error(Text006);

                "Annualizing Factor" := "Annualizing Factor"::"Generated Periods";

                case "Pay Frequency" of
                    "Pay Frequency"::Weekly:
                        "Monthly Factor" := 4.33;
                    "Pay Frequency"::BiWeekly:
                        "Monthly Factor" := 2.17;
                    "Pay Frequency"::SemiMonthly:
                        "Monthly Factor" := 2;
                    "Pay Frequency"::Monthly:
                        "Monthly Factor" := 1;
                    "Pay Frequency"::BiMonthly:
                        "Monthly Factor" := 2;
                    "Pay Frequency"::Quarterly:
                        "Monthly Factor" := 3;
                    "Pay Frequency"::SemiAnnually:
                        "Monthly Factor" := 6;
                    "Pay Frequency"::Annually:
                        "Monthly Factor" := 12;
                    "Pay Frequency"::Miscellaneous,
                  "Pay Frequency"::Other:
                        "Monthly Factor" := 0;
                end;
            end;
        }
        field(4; "Payment Delay"; Integer)
        {
        }
        field(5; "Annualizing Factor"; Enum "Annualizing Factor")
        {
            InitValue = "Generated Periods";
        }
        field(6; "Monthly Factor"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            InitValue = 4.33;
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }

    trigger OnDelete()
    var
        PayrollLedgerEntry: Record "Employee Ledger Entry";
    begin
        PayrollLedgerEntry.SetRange("Pay Cycle Code", Code);
        if not PayrollLedgerEntry.IsEmpty() then
            Error(Text002, PayrollLedgerEntry.TableCaption);

        "Pay Cycle Period".SetCurrentKey("Pay Cycle Code");
        "Pay Cycle Period".SetRange("Pay Cycle Code", Code);
        "Pay Cycle Period".DeleteAll;

        PayCycleTerm.SetCurrentKey("Pay Cycle Code");
        PayCycleTerm.SetRange("Pay Cycle Code", Code);
        PayCycleTerm.DeleteAll;
    end;

    var
        Text004: Label 'You cannot change the Payroll Frequency.  There are records already generated for the pay cycle.';
        Text001: Label 'You cannot change the Payroll Frequency.  There are records already posted to the %1 table.';
        "Pay Cycle Period": Record "Pay Cycle Period";
        PayCycleTerm: Record "Pay Cycle Term";
        Text006: Label 'You cannot change the Payroll Frequency. There are Pay Cycle Term records already created.';
        Text002: Label 'You cannot delete the Pay Cycle.  There are records already posted to the %1 table.';
}
