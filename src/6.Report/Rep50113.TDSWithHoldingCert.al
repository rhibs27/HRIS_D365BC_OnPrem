report 50113 "TDS WithHolding Cert"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019914.TDSWithHoldingCert.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(CompanyName; CompanyInfo.Name) { }
            dataitem(Employee; Employee)
            {
                column(FullName; UpperCase("Full Name")) { }
                column(FiscalYearStartDate; StartDateText) { }
                column(EmployeeNo; "No.") { }
                column(EtdsMonth; EndDateText) { }
                column(PAN1; PAN[1]) { }
                column(PAN2; PAN[2]) { }
                column(PAN3; PAN[3]) { }
                column(PAN4; PAN[4]) { }
                column(PAN5; PAN[5]) { }
                column(PAN6; PAN[6]) { }
                column(PAN7; PAN[7]) { }
                column(PAN8; PAN[8]) { }
                column(PAN9; PAN[9]) { }
                column(MobilePhoneNo; "Mobile Phone No.") { }
                column(PermanentDistrict; "Permanent District") { }
                column(PermanentVDC; "Permanent VDC") { }
                column(WardNo; "Ward No") { }
                column(PermanentHouse; "Permanent House") { }
                column(TaxableAmtTextArrayBefore1; TaxableAmtTextArrayBefore[1]) { }
                column(TaxableAmtTextArrayBefore2; TaxableAmtTextArrayBefore[2]) { }
                column(TaxableAmtTextArrayBefore3; TaxableAmtTextArrayBefore[3]) { }
                column(TaxableAmtTextArrayBefore4; TaxableAmtTextArrayBefore[4]) { }
                column(TaxableAmtTextArrayBefore5; TaxableAmtTextArrayBefore[5]) { }
                column(TaxableAmtTextArrayBefore6; TaxableAmtTextArrayBefore[6]) { }
                column(TaxableAmtTextArrayBefore7; TaxableAmtTextArrayBefore[7]) { }
                column(TaxableAmtTextArrayBefore8; TaxableAmtTextArrayBefore[8]) { }
                column(TaxableAmtTextArrayBefore9; TaxableAmtTextArrayBefore[9]) { }
                column(TaxableAmtTextArrayAfter1; TaxableAmtTextArrayAfter[1]) { }
                column(TaxableAmtTextArrayAfter2; TaxableAmtTextArrayAfter[2]) { }
                column(TdsAmtTextArrayBefore1; TDSAmtTextArrayBefore[1]) { }
                column(TdsAmtTextArrayBefore2; TDSAmtTextArrayBefore[2]) { }
                column(TdsAmtTextArrayBefore3; TDSAmtTextArrayBefore[3]) { }
                column(TdsAmtTextArrayBefore4; TDSAmtTextArrayBefore[4]) { }
                column(TdsAmtTextArrayBefore5; TDSAmtTextArrayBefore[5]) { }
                column(TdsAmtTextArrayBefore6; TDSAmtTextArrayBefore[6]) { }
                column(TdsAmtTextArrayBefore7; TDSAmtTextArrayBefore[7]) { }
                column(TdsAmtTextArrayBefore8; TDSAmtTextArrayBefore[8]) { }
                column(TdsAmtTextArrayBefore9; TDSAmtTextArrayBefore[9]) { }
                column(TDSAmtTextArrayAfter1; TDSAmtTextArrayAfter[1]) { }
                column(TDSAmtTextArrayAfter2; TDSAmtTextArrayAfter[2]) { }
                column(TotalTaxableText; TotalTaxableText[1] + ' ' + TotalTaxableText[2]) { }
                column(TotalTdsText; TotalTdsText[1] + ' ' + TotalTdsText[2]) { }

                trigger OnAfterGetRecord()
                begin
                    SeparateCharacter("PAN No.", StrLen("PAN No."), PAN);
                    SeparateCharacter("Phone No.", StrLen("Phone No."), PhoenNo);
                    Clear(DetailedEmpLedgerEntry);
                    DetailedEmpLedgerEntry.Reset;
                    DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
                    DetailedEmpLedgerEntry.SetRange("Employee No.", "No.");
                    DetailedEmpLedgerEntry.SetFilter("Pay Period End Date", '<=%1', EndDate);
                    DetailedEmpLedgerEntry.SetCurrentKey("Pay Period End Date");
                    if DetailedEmpLedgerEntry.FindLast then
                        EtdsMonth := DetailedEmpLedgerEntry."Pay Period End Date";
                    EngNepDate.Reset;
                    EngNepDate.SetRange("English Date", EtdsMonth);
                    if EngNepDate.FindFirst then
                        EndDateText := EngNepDate."Nepali Date";

                    Clear(TotalTaxable);
                    Clear(DetailedEmpLedgerEntry);
                    DetailedEmpLedgerEntry.Reset;
                    DetailedEmpLedgerEntry.SetRange("Employee No.", "No.");
                    DetailedEmpLedgerEntry.SetFilter("Pay Period End Date", '<=%1', EndDate);
                    DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
                    DetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2', DetailedEmpLedgerEntry."Attribute Type"::"Basic Earning",
                                            DetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
                    DetailedEmpLedgerEntry.SetRange(Reversed, false);
                    DetailedEmpLedgerEntry.CalcSums(Amount);
                    TotalTaxable := DetailedEmpLedgerEntry.Amount;
                    FormatNoText(TotalTaxableText, TotalTaxable, '');

                    TaxableAmtText := DelChr(Format(Round(TotalTaxable, 0.01, '=')), '=', ',');
                    if (Round(TotalTaxable, 0.01, '=') mod 1) = 0 then
                        TaxableAmtText += '.00'
                    else if (Round(TotalTaxable, 0.01, '=') mod 0.1) = 0 then
                        TaxableAmtText += '0';
                    SeparateCharacterOpposite(CopyStr(TaxableAmtText, 1, StrLen(TaxableAmtText) - 3), StrLen(TaxableAmtText) - 3, TaxableAmtTextArrayBefore);
                    SeparateCharacterOpposite(CopyStr(TaxableAmtText, StrLen(TaxableAmtText) - 1, 2), 2, TaxableAmtTextArrayAfter);
                    Clear(TotalTds);
                    DetailedEmpLedgerEntry.Reset;
                    DetailedEmpLedgerEntry.SetRange("Employee No.", "No.");
                    DetailedEmpLedgerEntry.SetFilter("Pay Period End Date", '<=%1', EndDate);
                    DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
                    DetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2', DetailedEmpLedgerEntry."Attribute Sub Type"::"Tax on Remuneration & Benefits",
                                            DetailedEmpLedgerEntry."Attribute Sub Type"::"Social Security Tax");
                    DetailedEmpLedgerEntry.SetRange(Reversed, false);
                    DetailedEmpLedgerEntry.CalcSums(Amount);
                    TotalTds := -DetailedEmpLedgerEntry.Amount;

                    FormatNoText(TotalTdsText, TotalTds, '');
                    TDSAmtText := DelChr(Format(Round(TotalTds, 0.01, '=')), '=', ',');
                    if (Round(TotalTds, 0.01, '=') mod 1) = 0 then
                        TDSAmtText += '.00'
                    else if (Round(TotalTaxable, 0.01, '=') mod 0.1) = 0 then
                        TaxableAmtText += '0';
                    SeparateCharacterOpposite(CopyStr(TDSAmtText, 1, StrLen(TDSAmtText) - 3), StrLen(TDSAmtText) - 3, TDSAmtTextArrayBefore);
                    SeparateCharacterOpposite(CopyStr(TDSAmtText, StrLen(TDSAmtText) - 1, 2), 2, TDSAmtTextArrayAfter);
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("No.", EmployeeFilter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PGSetup.Get;
                Clear(DetailedEmpLedgerEntry);
                if PayCycleTerm = '' then
                    Error('Pay cycle term must have value.');

                if EmployeeFilter = '' then
                    Error('Employee Filter must have value.');

                PGSetup.TestField("Payroll Fiscal Year Start Date");

                PayCyclePeriod.Reset;
                PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                PayCyclePeriod.SetCurrentKey("Start Date");
                if PayCyclePeriod.FindFirst then
                    FiscalYearStartDate := PayCyclePeriod."Start Date";

                if FiscalYearStartDate < PGSetup."Payroll Fiscal Year Start Date" then
                    EndDate := PGSetup."Payroll Fiscal Year End Date"
                else begin
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                    PayCyclePeriod.SetRange("Nepali Month", PGSetup."HRMS Month");
                    PayCyclePeriod.SetCurrentKey("Start Date");
                    if PayCyclePeriod.FindFirst then
                        EndDate := PayCyclePeriod."End Date";
                end;

                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", FiscalYearStartDate);
                if EngNepDate.FindFirst then
                    StartDateText := EngNepDate."Nepali Date";

                InitTextVariable();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(PayCycleTerm; PayCycleTerm)
                {
                    Caption = 'Pay Cycle Term';
                    TableRelation = "Pay Cycle Term".Term;
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
                field("Employee Filter"; EmployeeFilter)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmployeeFilter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        PAN: array[20] of Text[1];
        PhoenNo: array[20] of Text[1];
        CompanyInfo: Record "Company Information";
        PayCycleTerm: Text;
        FiscalYearStartDate: Date;
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
        EtdsMonth: Date;
        TotalTaxable: Decimal;
        TotalTds: Decimal;
        TaxableAmtText: Text;
        TaxableAmtTextArrayBefore: array[20] of Text;
        TaxableAmtTextArrayAfter: array[20] of Text;
        TDSAmtText: Text;
        TDSAmtTextArrayBefore: array[20] of Text;
        TDSAmtTextArrayAfter: array[20] of Text;
        EngNepDate: Record "English-Nepali Date";
        StartDateText: Text;
        EndDateText: Text;
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text1280000: Label 'LAKH';
        Text1280001: Label 'CRORE';
        Text059: Label 'THOUSAND';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        TotalTaxableText: array[2] of Text;
        TotalTdsText: array[2] of Text;
        EmployeeFilter: Text;
        PGSetup: Record "Payroll General Setup";
        PayCyclePeriod: Record "Pay Cycle Period";
        EndDate: Date;

    local procedure SeparateCharacter(Charactertext: Text; CharacterLength: Integer; var ReturnValue: array[20] of Text[1])
    var
        counter: Integer;
    begin
        if CharacterLength > 20 then
            Error('Lenth of value %1 is greater than 20.Must be less than 20');
        if CharacterLength = 0 then
            exit;
        Clear(ReturnValue);
        for counter := 1 to CharacterLength do
            ReturnValue[counter] := CopyStr(Charactertext, counter, 1);
    end;

    local procedure SeparateCharacterOpposite(Charactertext: Text; CharacterLength: Integer; var ReturnValue: array[20] of Text[1])
    var
        counter: Integer;
        reverseCounter: Integer;
    begin
        if CharacterLength > 20 then
            Error('Lenth of value %1 is greater than 20.Must be less than 20');
        if CharacterLength = 0 then
            exit;
        Clear(ReturnValue);
        reverseCounter := 1;
        for counter := CharacterLength downto 1 do begin
            ReturnValue[reverseCounter] := CopyStr(Charactertext, counter, 1);
            reverseCounter += 1;
        end;
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[20])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                if No > 99999 then begin
                    Ones := No div (Power(100, Exponent - 1) * 10);
                    Hundreds := 0;
                end else begin
                    Ones := No div Power(1000, Exponent - 1);
                    Hundreds := Ones div 100;
                end;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                if No > 99999 then
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(100, Exponent - 1) * 10
                else
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode <> '' then begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        // AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        TensDec := ((No * 100) mod 100) div 10;
        OnesDec := (No * 100) mod 10 div 1;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, '')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text1280000;
        ExponentText[4] := Text1280001;
    end;
}
