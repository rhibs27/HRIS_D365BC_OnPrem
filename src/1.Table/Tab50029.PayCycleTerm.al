table 50029 "Pay Cycle Term"
{
    DrillDownPageId = "Pay Cycle Term";
    LookupPageId = "Pay Cycle Term";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Pay Cycle Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Pay Cycle".Code;
        }
        field(2; Term; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                "Default Periods" := GetDefaultPayPeriods("Pay Cycle Code");
            end;
        }
        field(3; "Default Periods"; Integer)
        {
            Editable = false;
            InitValue = 0;
            MinValue = 0;
        }
        field(4; "Periods Generated"; Integer)
        {
            CalcFormula = count("Pay Cycle Period" where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                          "Pay Cycle Term" = field(Term)));
            Editable = false;
            FieldClass = FlowField;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = true;
        }
    }

    keys
    {
        key(Key1; "Pay Cycle Code", Term) { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        PayrollLedgerEntry.SetRange("Pay Cycle Code", "Pay Cycle Code");
        PayrollLedgerEntry.SetRange("Pay Cycle Term", Term);
        if not PayrollLedgerEntry.IsEmpty() then
            Error(Text001, PayrollLedgerEntry.TableCaption);
        PayCyclePeriod.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term", Period);
        PayCyclePeriod.SetRange("Pay Cycle Code", "Pay Cycle Code");
        PayCyclePeriod.SetRange("Pay Cycle Term", Term);
        PayCyclePeriod.DeleteAll;
    end;

    trigger OnRename()
    begin
        Error('');
    end;

    var
        PayCycle: Record "Pay Cycle";
        PayCyclePeriod: Record "Pay Cycle Period";
        PayrollLedgerEntry: Record "Employee Ledger Entry";
        Text001: Label 'You cannot delete the Pay Cycle Term.  There are records already posted to the %1 table.';

    procedure GetDefaultPayPeriods(PayCycleCode: Code[20]): Integer
    var
        Periods: Integer;
    begin
        Periods := 0;
        PayCycle.SetCurrentKey(Code);
        PayCycle.SetRange(Code, "Pay Cycle Code");
        if PayCycle.FindLast() then
            case PayCycle."Pay Frequency" of
                PayCycle."Pay Frequency"::Weekly:
                    Periods := 52;
                PayCycle."Pay Frequency"::BiWeekly:
                    Periods := 26;
                PayCycle."Pay Frequency"::SemiMonthly:
                    Periods := 24;
                PayCycle."Pay Frequency"::Monthly:
                    Periods := 12;
                PayCycle."Pay Frequency"::BiMonthly:
                    Periods := 6;
                PayCycle."Pay Frequency"::Quarterly:
                    Periods := 4;
                PayCycle."Pay Frequency"::SemiAnnually:
                    Periods := 2;
                PayCycle."Pay Frequency"::Annually:
                    Periods := 1;
                PayCycle."Pay Frequency"::Miscellaneous:
                    Periods := 365;
                PayCycle."Pay Frequency"::Other:
                    Periods := 0;
            end;
        exit(Periods)
    end;
}
