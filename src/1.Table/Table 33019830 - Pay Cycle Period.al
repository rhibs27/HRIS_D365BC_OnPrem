table 33019830 "Pay Cycle Period"
{
    // version PRM19.01.01

    DrillDownPageId = "Pay Cycle Period";
    LookupPageId = "Pay Cycle Period";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Pay Cycle Code"; Code[10])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Pay Cycle";
        }
        field(2; "Pay Cycle Term"; Code[10])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(3; Period; Integer)
        {
            Editable = false;
            NotBlank = true;
        }
        field(4; "Start Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                EmployerPayCycle.Get("Pay Cycle Code");
                case EmployerPayCycle."Pay Frequency" of
                    EmployerPayCycle."Pay Frequency"::Weekly:
                        "End Date" := CalcDate('<+1W>', "Start Date");
                    EmployerPayCycle."Pay Frequency"::BiWeekly:
                        "End Date" := CalcDate('<+2W>', "Start Date");
                    EmployerPayCycle."Pay Frequency"::SemiMonthly:
                        begin
                            Day := Date2DMY("Start Date", 1);
                            if Day <> 15 then
                                Error(Text000);
                            "End Date" := CalcDate('<CM>', "Start Date");
                        end;
                    EmployerPayCycle."Pay Frequency"::Monthly:
                        "End Date" := CalcDate('<CM + 1M>', "Start Date");
                    EmployerPayCycle."Pay Frequency"::BiMonthly:
                        "End Date" := CalcDate('<CM + 2M>', "Start Date");
                    EmployerPayCycle."Pay Frequency"::Quarterly:
                        "End Date" := CalcDate('<+1Q>', "Start Date");
                    EmployerPayCycle."Pay Frequency"::SemiAnnually:
                        "End Date" := CalcDate('<+2Q>', "Start Date");
                    EmployerPayCycle."Pay Frequency"::Annually:
                        "End Date" := CalcDate('<+1Y>', "Start Date");
                end;
                "Pay Date" := "End Date" + EmployerPayCycle."Payment Delay";
            end;
        }
        field(5; "End Date"; Date)
        {
            Editable = false;
        }
        field(6; "Pay Date"; Date)
        {
            Editable = true;

            trigger OnValidate()
            begin
                EngNep.Reset; //Min 1.10.2023
                EngNep.SetRange("English Date", "Pay Date");
                if EngNep.FindFirst then
                    "Nepali Year" := EngNep."Nepali Year";
            end;
        }
        field(7; Posted; Boolean)
        {
            CalcFormula = exist("Employee Ledger Entry" where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                               "Pay Cycle Term" = field("Pay Cycle Term"),
                                                               "Pay Cycle Period" = field(Period)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Insurable Hours"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(9; "Nepali Month"; Enum "Nepali Month")
        {
           
        }
        field(10; "Allowance Start Date"; Date)
        {
            trigger OnValidate()
            begin
                Clear("Allowance End Date");
            end;
        }
        field(11; "Allowance End Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Allowance Start Date" > "Allowance End Date" then
                    Error('Allowance Start must be less than allowance end date.');
            end;
        }
        field(12; "Tax Payment Date"; Date) { }
        field(13; "Income Tax Voucher No."; Text[30]) { }
        field(14; "SST Voucher No."; Text[30]) { }
        field(15; "E-TDS Transaction Number"; Text[30]) { }
        field(16; "Nepali Year"; Integer) { }
    }

    keys
    {
        key(Key1; "Pay Cycle Code", "Pay Cycle Term", Period) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Period, "Nepali Month") { }
    }

    trigger OnDelete()
    begin
        PayrollLedgerEntry.SetRange("Pay Cycle Code", "Pay Cycle Code");
        PayrollLedgerEntry.SetRange("Pay Cycle Term", "Pay Cycle Term");
        PayrollLedgerEntry.SetRange("Pay Cycle Period", Period);
        if not PayrollLedgerEntry.IsEmpty() then
            Error(Text001);
    end;

    var
        PayrollLedgerEntry: Record "Employee Ledger Entry PRM";
        EmployerPayCycle: Record "Pay Cycle";
        Day: Integer;
        Text001: Label 'You cannot delete the Pay Cycle Period.  There are records already posted to the %1 table.';
        Text000: Label 'Day must be the 15th for Pay Frequency of Semi-Monthly.';
        EngNep: Record "English-Nepali Date";
}
