report 50151 "Payroll Voucher summary 2"
{
    ApplicationArea = All;
    Caption = 'Payroll Voucher summary 2';
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50151.PayrollSummaryVoucher2.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Posted Payroll Header"; "Posted Payroll Header")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyOneLineAddress; CompanyOneLineAddress) { }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress) { }
            column(CompanyInfoVATRegNo; CompanyInfo.FieldCaption("VAT Registration No.") + ' : ' + CompanyInfo."VAT Registration No.") { }
            column(PostingDate; HrMgt.GetNepaliDate("Posting Date")) { }
            column(PrintedOn; CurrentDateTime) { }
            column(PrintedBy; UserId) { }
            column(PostedPayrollNo; "Posted Payroll Header"."No.") { }
            column(NepaliMonth; "Posted Payroll Header"."Nepali Month") { }
            column(FiscalYear; HrMgt.ReturnFiscalYear("Posting Date")) { }
            column(PostingDescription; "Posted Payroll Header".Narration) { }
            column(PaymentAmountInWords; TotalAmountText[1] + ' ' + TotalAmountText[2]) { }
            column(Text062; StrSubstNo(Text062, "Nepali Month", HrMgt.ReturnFiscalYear("Posting Date"))) { }
            dataitem("Document Workflow"; "Document Workflow")
            {
                DataItemLink = "Primary Key" = field("No.");
                column(LineNo; "Document Workflow"."Line No.") { }
                column(EmployeeNo; "Document Workflow"."Employee No.") { }
                column(EmployeeName; "Document Workflow"."Employee Name") { }
                column(HeadingType; "Document Workflow"."Heading Type") { }
                column(OutputNo; OutputNo) { }

                trigger OnAfterGetRecord()
                begin
                    if "Document Workflow"."Employee No." <> '' then
                        OutputNo += 1;

                    case "Document Workflow"."Heading Type" of
                        "Document Workflow"."Heading Type"::"Entered By":
                            EnteredBy := "Document Workflow"."Employee Name";
                        "Document Workflow"."Heading Type"::"Prepared By":
                            PreparedBy := "Document Workflow"."Employee Name";
                        "Document Workflow"."Heading Type"::"Checked By":
                            CheckedBy := "Document Workflow"."Employee Name";
                        "Document Workflow"."Heading Type"::"Supported By":
                            ReviewedBy := "Document Workflow"."Employee Name";
                        "Document Workflow"."Heading Type"::"Approved By":
                            ApprovedBy := "Document Workflow"."Employee Name";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                UnitCost: Decimal;
                BudgetedAmt: Decimal;
                GLEntry: Record "G/L Entry";
            begin
                if "Posted Payroll Header".Reversed then
                    CurrReport.Skip();

                GLEntry.SetLoadFields("Document No.", "G/L Account No.", Amount);
                GLEntry.SetRange("Document No.", "Posted Payroll Header"."No.");
                GLEntry.SetRange("G/L Account No.", PGSetup."Net Payable Account Code");
                GLEntry.CalcSums(Amount);
                TotaNetPay := GLEntry.Amount;

                PayrollAttributes.Reset;
                PayrollAttributes.SetFilter(Subtype, '<>%1&<>%2', PayrollAttributes.Subtype::"Lump Sum Contribution", PayrollAttributes.Subtype::"Tax on Interest");
                PayrollAttributes.SetFilter("G/L Account No.", '<>%1', '');
                if PayrollAttributes.FindFirst then
                    repeat
                        UnitCost := 0;
                        BudgetedAmt := 0;

                        GetAttributeWiseDebitCredit(PayrollAttributes.Code, UnitCost, BudgetedAmt, "Posted Payroll Header"."Global Dimension 1 Code", "Posted Payroll Header"."Global Dimension 2 Code");
                        if (UnitCost <> 0) or (BudgetedAmt <> 0) then begin
                            TempPayrollAttributes.Init;
                            TempPayrollAttributes."No." := PayrollAttributes.Code;
                            TempPayrollAttributes.Description := PayrollAttributes."G/L Account No.";
                            TempPayrollAttributes."Description 2" := PayrollAttributes.Description;
                            TempPayrollAttributes."Unit Cost" := UnitCost;
                            TempPayrollAttributes."Budgeted Amount" := abs(BudgetedAmt);

                            TempPayrollAttributes.Insert;

                            TotalDebitAmt += TempPayrollAttributes."Unit Cost";
                        end;
                    until PayrollAttributes.Next = 0;

                TempPayrollAttributes.Init;
                TempPayrollAttributes."No." := 'Net Pay';
                TempPayrollAttributes.Description := PGSetup."Net Payable Account Code";
                TempPayrollAttributes."Description 2" := 'Liability To Employees';
                if TotaNetPay > 0 then
                    TempPayrollAttributes."Unit Cost" := TotaNetPay
                else
                    TempPayrollAttributes."Budgeted Amount" := Abs(TotaNetPay);
                TempPayrollAttributes.Insert;

                InitTextVariable;
                FormatNoText(TotalAmountText, TotalDebitAmt, '');
            end;
        }
        dataitem(TempPayrollAttributes; Item)
        {
            UseTemporary = true;
            column(GLAccountNo_PayrollAttributes; TempPayrollAttributes.Description) { }
            column(Code_PayrollAttributes; TempPayrollAttributes."Description 2") { }
            column(DebitAmt; TempPayrollAttributes."Unit Cost") { }
            column(CreditAmt; TempPayrollAttributes."Budgeted Amount") { }

            // for workflow
            column(EnteredBy; EnteredBy) { }
            column(PreparedBy; PreparedBy) { }
            column(CheckedBy; CheckedBy) { }
            column(ReviewedBy; ReviewedBy) { }
            column(ApprovedBy; ApprovedBy) { }
            trigger OnPreDataItem()
            begin
                TempPayrollAttributes.SetCurrentKey("Unit Cost");
                TempPayrollAttributes.SetAscending("Unit Cost", false);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(BranchFilter; BranchFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Branch Filter';
                    TableRelation = "Organization Structure List".Code where(Type = const(Branch));
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        GetCompanyOneLineAddress;
        PGSetup.Get;
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        TotalAmountText: array[2] of Text[80];
        CompanyOneLineAddress: Text;
        CompanyCommunicationAddress: Text;
        CompanyAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
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
        HrMgt: Codeunit "HR Mgt.";
        TotaNetPay: Decimal;
        GLAccount: Record "G/L Account";
        TotalDebitAmt: Decimal;
        PayrollAttributes: Record "Payroll Attributes";
        PGSetup: Record "Payroll General Setup";
        OutputNo: Integer;
        Text062: Label 'Payroll summary voucher for the month of %1 Fiscal Year %2 as per following detail is placed for approval.';
        DetailedEmployeeledger: Record "Detailed Employee Ledger Entry";
        BranchFilter: Code[20];
        EnteredBy, PreparedBy, CheckedBy, ReviewedBy, ApprovedBy : text[100];

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


    procedure GetAttributeWiseDebitCredit(AttrCode: Code[20];
                                        var DebitAmt: Decimal;
                                        Var CreditAmt: Decimal;
                                        GlobalDim1Filter: Code[20];
                                        GlobalDim2Filter: Code[20])
    begin
        DetailedEmployeeledger.Reset();
        DetailedEmployeeledger.SetLoadFields("Document No.", "Payroll Attribute Code", Amount);
        DetailedEmployeeledger.SetRange("Payroll Attribute Code", PayrollAttributes.Code);
        DetailedEmployeeledger.SetRange("Document No.", "Posted Payroll Header"."No.");
        DetailedEmployeeledger.SetFilter("Shortcut Dimension 1 Code", GlobalDim1Filter);
        DetailedEmployeeledger.SetFilter("Shortcut Dimension 2 Code", GlobalDim2Filter);
        DetailedEmployeeledger.SetFilter(Amount, '>=0');
        DetailedEmployeeledger.CalcSums(Amount);
        DebitAmt := DetailedEmployeeledger.Amount;

        DetailedEmployeeledger.SetFilter(Amount, '<0');
        DetailedEmployeeledger.CalcSums(Amount);
        CreditAmt := DetailedEmployeeledger.Amount;
    end;
}
