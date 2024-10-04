report 50073 "Payroll Journal Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019874.PayrollJournalVoucher.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(VoucherNo; DocNo) { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyOneLineAddress; CompanyOneLineAddress) { }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress) { }
            column(CompanyInfoVATRegNo; CompanyInfo.FieldCaption("VAT Registration No.") + ' : ' + CompanyInfo."VAT Registration No.") { }
            column(PostingDate; HRMgt.GetNepaliDate(PostedPayHeader."Posting Date")) { }
            column(FiscalYear; HRMgt.ReturnFiscalYear(PostedPayHeader."Posting Date")) { }
            column(Title; Title) { }
            column(CurrentDate; HRMgt.GetNepaliDate(Today)) { }
            column(PostingDescription; PostedPayHeader."Posting Description") { }

            trigger OnAfterGetRecord()
            begin
                if PostedPayHeader.Get(DocNo) then;
                NepaliYear := HRMgt.ReturnNepaliYear(PostedPayHeader."From Date");
            end;

            trigger OnPreDataItem()
            begin
                "Detailed Employee Ledger Entry".DeleteAll;
            end;
        }
        dataitem(Employee; Employee)
        {
            trigger OnAfterGetRecord()
            begin
                EmpLedEntry.Reset;
                EmpLedEntry.SetRange("Employee No.", "No.");
                EmpLedEntry.SetRange("Document No.", DocNo);
                if not EmpLedEntry.FindFirst then
                    CurrReport.Skip;

                DetLedEntry.Reset;
                DetLedEntry.SetRange("Employee No.", "No.");
                DetLedEntry.SetRange("Document No.", DocNo);
                DetLedEntry.SetFilter("Attribute Sub Type", '<>%1&<>%2', DetLedEntry."Attribute Sub Type"::"Lump Sum Contribution"
                                      , DetLedEntry."Attribute Sub Type"::"Tax on Interest");
                if DetLedEntry.Find('-') then
                    repeat
                        EntryNo += 1;
                        "Detailed Employee Ledger Entry".Init;
                        "Detailed Employee Ledger Entry".TransferFields(DetLedEntry);
                        "Detailed Employee Ledger Entry"."Entry No." := EntryNo;
                        "Detailed Employee Ledger Entry".Description := StrSubstNo('%1 %2', DetLedEntry."Sol ID", DetLedEntry."Deputation Value");
                        if PayrollAttributes.Get(DetLedEntry."Payroll Attribute Code") then
                            "Detailed Employee Ledger Entry"."G/L Document No" := PayrollAttributes."G/L Account No.";
                        "Detailed Employee Ledger Entry".Insert;
                    until DetLedEntry.Next = 0;

                DetLedEntry.Reset;
                DetLedEntry.SetRange("Employee No.", "No.");
                DetLedEntry.SetRange("Document No.", DocNo);
                DetLedEntry.SetFilter("Attribute Sub Type", '<>%1&<>%2', DetLedEntry."Attribute Sub Type"::"Lump Sum Contribution"
                                      , DetLedEntry."Attribute Sub Type"::"Tax on Interest");
                DetLedEntry.CalcSums(Amount);
                EntryNo += 1;
                "Detailed Employee Ledger Entry".Init;
                "Detailed Employee Ledger Entry".Validate("Employee No.", "No.");
                "Detailed Employee Ledger Entry".Validate("Entry No.", EntryNo);
                "Detailed Employee Ledger Entry".Validate(Amount, -DetLedEntry.Amount);
                "Detailed Employee Ledger Entry".Validate(Description, StrSubstNo('%1 %2', "No.", "Full Name"));
                "Detailed Employee Ledger Entry".Validate("G/L Document No", PGSetup."Net Payable Account Code");
                "Detailed Employee Ledger Entry".Validate("Finacle GL Name", StrSubstNo('Net Salary %1-%2', NepaliYear, PostedPayHeader."Nepali Month"));
                "Detailed Employee Ledger Entry".Insert;
            end;
        }
        dataitem("Detailed Employee Ledger Entry"; "Detailed Employee Ledger Entry")
        {
            UseTemporary = true;
            column(FinacleGLName_; "Finacle GL Name") { }
            column(SolID_; "Sol ID") { }
            column(DeputationValue_; "Deputation Value") { }
            column(Debit; Debit) { }
            column(Credit; Credit) { }
            column(GroupByAcc; GroupByAcc) { }
            column(Description; Description) { }
            column(AccNo; AccNo) { }
            column(GLDocumentNo_; "G/L Document No") { }
            column(TotalCredit; TotalCredit) { }
            column(TotalDebit; TotalDebit) { }
            column(AmountInTxt; TotalAmountText[1] + ' ' + TotalAmountText[2]) { }

            trigger OnAfterGetRecord()
            begin
                Clear(Debit);
                Clear(Credit);
                Clear(GroupByAcc);
                Clear(AccNo);
                Clear(TotalAmountText);
                if Amount > 0 then begin
                    Debit := Abs(Amount);
                    TotalDebit += Debit;
                end else begin
                    Credit := Abs(Amount);
                    TotalCredit += Credit;
                end;
                if "Payroll Attribute Code" <> '' then
                    AccNo := "Payroll Attribute Code"
                else
                    AccNo := 'Libaility To Employees';

                GroupByAcc := StrSubstNo('%1 %2', AccNo, Description);
                InitTextVariable;
                FormatNoText(TotalAmountText, TotalCredit, '');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(DocNo; DocNo)
                {
                    Caption = 'Document No';
                    TableRelation = "Posted Payroll Header";
                    ToolTip = 'Specifies the value of the Document No field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        "Detailed Employee Ledger Entry".DeleteAll;
    end;

    trigger OnPreReport()
    begin
        if DocNo = '' then
            Error('Must select the document no.');
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        GetCompanyOneLineAddress;

        PGSetup.Get;
        Clear(TotalCredit);
        Clear(TotalCredit);
    end;

    var
        DocNo: Code[20];
        EmpLedEntry: Record "Employee Ledger Entry";
        Debit: Decimal;
        Credit: Decimal;
        GroupByAcc: Text;
        DetLedEntry: Record "Detailed Employee Ledger Entry";
        EntryNo: Integer;
        AccNo: Text;
        PayrollAttributes: Record "Payroll Attributes";
        PGSetup: Record "Payroll General Setup";
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        TotalAmountText: array[2] of Text[80];
        CompanyOneLineAddress: Text;
        CompanyCommunicationAddress: Text;
        CompanyAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Title: Label 'Payroll Journal Voucher';
        Text026: Label 'Zero';
        Text027: Label 'Hundred';
        Text028: Label 'And';
        Text029: Label '%1 results in a written number that is too long.';
        Text032: Label 'One';
        Text033: Label 'Two';
        Text034: Label 'Three';
        Text035: Label 'Four';
        Text036: Label 'Five';
        Text037: Label 'Six';
        Text038: Label 'Seven';
        Text039: Label 'Eight';
        Text040: Label 'Nine';
        Text041: Label 'Ten';
        Text042: Label 'Eleven';
        Text043: Label 'Twelve';
        Text044: Label 'Thirteen';
        Text045: Label 'Fourteen';
        Text046: Label 'Fifteen';
        Text047: Label 'Sixteen';
        Text048: Label 'Seventeen';
        Text049: Label 'Eighteen';
        Text050: Label 'Nineteen';
        Text051: Label 'Twenty';
        Text052: Label 'Thirty';
        Text053: Label 'Forty';
        Text054: Label 'Fifty';
        Text055: Label 'Sixty';
        Text056: Label 'Seventy';
        Text057: Label 'Eighty';
        Text058: Label 'Ninety';
        Text1280000: Label 'Lakh';
        Text1280001: Label 'Crore';
        Text059: Label 'Thousand';
        PostedPayHeader: Record "Posted Payroll Header";
        HRMgt: Codeunit "HR Mgt.";
        NepaliYear: Integer;

    local procedure GetCompanyOneLineAddress()
    begin
        CompanyAddr[1] := CompanyInfo.Name;
        if CompanyInfo."Phone No." <> '' then
            CompanyOneLineAddress := OneLineAddress(CompanyAddr) + ', ' + CompanyInfo.FieldCaption("Phone No.") + ' : ' + CompanyInfo."Phone No."
        else
            CompanyOneLineAddress := OneLineAddress(CompanyAddr);

        if CompanyInfo."Fax No." <> '' then
            CompanyCommunicationAddress := CompanyInfo.FieldCaption("Fax No.") + ' : ' + CompanyInfo."Fax No.";

        if CompanyInfo."E-Mail" <> '' then begin
            if (CompanyCommunicationAddress <> '') then
                CompanyCommunicationAddress += ', ' + CompanyInfo.FieldCaption("E-Mail") + ' : ' + CompanyInfo."E-Mail"
            else
                CompanyCommunicationAddress += CompanyInfo.FieldCaption("E-Mail") + ' : ' + CompanyInfo."E-Mail";
        end;
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
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
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'Ruppes');

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
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' Paisa Only');
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

    procedure OneLineAddress(var AddrArray: array[8] of Text[50]) OneLineAddress: Text
    var
        i: Integer;
    begin
        CompressArray(AddrArray);
        for i := 2 to ArrayLen(AddrArray) do begin
            if AddrArray[i] <> '' then
                if OneLineAddress = '' then
                    OneLineAddress += AddrArray[i]
                else
                    OneLineAddress += ', ' + AddrArray[i];
        end;
        exit(OneLineAddress);
    end;
}
