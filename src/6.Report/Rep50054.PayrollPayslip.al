report 50054 "Payroll Payslip"
{
    // version PRM19.01.01
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019855.PayrollPayslip.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ReportHeader; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyOneLineAddress; CompanyOneLineAddress) { }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress) { }
            column(CompanyInfoVATRegNo; CompanyInfo.FieldCaption("VAT Registration No.") + ' : ' + CompanyInfo."VAT Registration No.") { }
            column(PrintedOn; CurrentDateTime) { }
            column(PrintedBy; UserId) { }
            column(IsConfidential; PGSetup."Make Payroll Slip Confidential") { }
        }
        dataitem(Header; "Posted Payroll Header")
        {
            DataItemTableView = where(Reversed = const(false));
            PrintOnlyIfDetail = true;
            column(No_PostedPayrollHeader; Header."No.") { }
            dataitem(EmployeeLedger; "Employee Ledger Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Entry No.");
                PrintOnlyIfDetail = true;
                column(PayPeriodDate; StrSubstNo('%1 %2', Months, FisCalYr)) { }
                column(PayPeriod; PayPeriod) { }
                column(EmployeeNo; "Employee No.") { }
                column(EmployeeFullName; Employee.FullName) { }
                column(EmployeeDesignation; Employee."Functional Title Desc") { }
                column(CITNo; Employee."CIT No.") { }
                column(PFNo; Employee."PF No.") { }
                column(PanNo; Employee."PAN No.") { }
                column(BankAccountNo; Employee."Bank Account No.") { }
                column(BankName; Employee."Bank Name") { }
                column(DeputationOn; DeputationOn) { }
                column(DeputationOnCode; DeputationOnValue) { }
                column(Grade; Grade) { }
                column(FunctionalTitledesc; FunctionalTitledesc) { }
                column(Dim1Code; Dim1Code) { }
                column(Dim2Code; Dim2Code) { }
                column(Dim1CodeCaption; Employee.FieldCaption("Global Dimension 1 Code")) { }
                column(Dim2CodeCaption; Employee.FieldCaption("Global Dimension 2 Code")) { }
                column(Level; SalaryLevel.Description) { }
                column(PresentDays; "Present Days")
                {
                    IncludeCaption = true;
                }
                column(WeekoffDays; "Week off Days")
                {
                    IncludeCaption = true;
                }
                column(LeaveDays; "Leave Days")
                {
                    IncludeCaption = true;
                }
                column(AbsentDays; "Absent Days")
                {
                    IncludeCaption = true;
                }
                column(TotalDays; "Total Days")
                {
                    IncludeCaption = true;
                }
                column(TourDays; "Tour Days")
                {
                    IncludeCaption = true;
                }
                column(HalfDays; "Half Days")
                {
                    IncludeCaption = true;
                }
                column(LateDays; "Late Days")
                {
                    IncludeCaption = true;
                }
                column(OvertimeDays; "Overtime Days")
                {
                    IncludeCaption = true;
                }
                column(OTHrs; "OT Hrs (30MIN)")
                {
                    IncludeCaption = true;
                }
                dataitem(EmployeeLedgerDetails; "Detailed Employee Ledger Entry")
                {
                    DataItemLink = "Employee Ledger Entry No." = field("Entry No.");
                    DataItemTableView = sorting("Entry No.") where("Attribute Type" = filter("Basic Earning" | "Other Earnings" | Deduction | "Tax Credit"), "Attribute Sub Type" = filter(<> "Tax on Interest" & <> "Lump Sum Contribution"));
                    column(EntryNo; "Entry No.") { }
                    column(PostingDate; "Posting Date") { }
                    column(PayCycleCode; "Pay Cycle Code") { }
                    column(PayCycleTerm; "Pay Cycle Term") { }
                    column(PayCyclePeriod; "Pay Cycle Period") { }
                    column(PaymentAmount; NetPayAmount) { }
                    column(PaymentAmountInWords; TotalAmountText[1] + ' ' + TotalAmountText[2]) { }
                    dataitem(Benefits; "Detailed Employee Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Entry No.");
                        DataItemTableView = sorting("Entry No.") where("Attribute Type" = filter("Basic Earning" | "Other Earnings"), "Attribute Sub Type" = filter(<> "Tax on Interest"));
                        column(Benefits_PayrollAttributeCode; AttributeDescription) { }
                        column(Benefits_Amount; Amount) { }
                        trigger OnAfterGetRecord()
                        begin
                            AttributeDescription := '';
                            if PayrollAttributes.Get("Payroll Attribute Code") then
                                AttributeDescription := PayrollAttributes.Description;
                        end;
                    }
                    dataitem(Deductions; "Detailed Employee Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Entry No.");
                        DataItemTableView = sorting("Entry No.") where("Attribute Type" = filter(Deduction | "Tax Credit"), "Attribute Sub Type" = filter(<> "Tax on Interest" & <> "Lump Sum Contribution"));
                        column(Deductions_PayrollAttributeCode; AttributeDescription) { }
                        column(Deductions_Amount; Amount) { }
                        trigger OnAfterGetRecord()
                        begin
                            AttributeDescription := '';
                            if PayrollAttributes.Get("Payroll Attribute Code") then
                                AttributeDescription := PayrollAttributes.Description;
                        end;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        NetPayAmount += Amount;
                        InitTextVariable;
                        FormatNoText(TotalAmountText, NetPayAmount, '');
                    end;

                    trigger OnPreDataItem()
                    begin
                        EmployeeLedgerDetails.SetRange(Reversed, false);
                        if EmployeeNo <> '' then
                            EmployeeLedgerDetails.SetRange("Employee No.", EmployeeNo);
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    NetPayAmount := 0;
                    Clear(Employee);
                    Clear(PostedPayrollLine);
                    Clear(FunctionalTitle);
                    Clear(DeputationOn);
                    Clear(DeputationOnValue);
                    Clear(Grade);
                    Clear(FunctionalTitledesc);
                    if Employee.Get("Employee No.") then;
                    PostedPayrollLine.Reset;
                    PostedPayrollLine.SetRange("Document No.", EmployeeLedger."Document No.");
                    PostedPayrollLine.SetRange("Employee No.", EmployeeLedger."Employee No.");
                    if PostedPayrollLine.FindFirst then begin
                        DeputationOn := Format(PostedPayrollLine."Deputation On");
                        DeputationOnValue := ExitTransferDeputationWiseValue(PostedPayrollLine."Deputation On", PostedPayrollLine."Deputation Code");
                        Grade := PostedPayrollLine."Salary Grade";
                        if SalaryLevel.Get(PostedPayrollLine."Salary Level") then;
                    end;
                    if FunctionalTitle.Get(PostedPayrollLine."Functional Title") then
                        FunctionalTitledesc := FunctionalTitle.Description;
                    PayPeriod := EnglishNepaliDate.getNepaliMonth("Pay Period Start Date") + ', ' + Format(EnglishNepaliDate.getNepaliYear("Pay Period Start Date"));
                    Dim1Code := '';
                    Dim2Code := '';
                    if DimensionValue.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then
                        Dim1Code := DimensionValue.Name;
                    if DimensionValue.Get(GLSetup."Global Dimension 2 Code", Employee."Global Dimension 2 Code") then
                        Dim2Code := DimensionValue.Name;
                end;

                trigger OnPreDataItem()
                begin
                    if FisCalYr <> '' then
                        SetRange("Fiscal Year", FisCalYr);
                    if Months <> 0 then
                        if ((Months + 9) mod 12) <> 0 then
                            SetRange("Pay Cycle Period", (Months + 9) mod 12)
                        else
                            SetRange("Pay Cycle Period", Months + 9);
                    if EmployeeNo <> '' then
                        EmployeeLedger.SetRange("Employee No.", EmployeeNo);
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Choose Employee code")
                {
                    Caption = 'Choose Employee code';
                    field(EmployeeNo; EmployeeNo)
                    {
                        Caption = 'Employee No.';
                        TableRelation = Employee;
                        ToolTip = 'Specifies the value of the Employee No. field.';
                        ApplicationArea = All;
                    }
                    field(Year; NepaliYear)
                    {
                        ToolTip = 'Specifies the value of the NepaliYear field.';
                        ApplicationArea = All;
                    }
                    field(Month; Months)
                    {
                        ToolTip = 'Specifies the value of the Months field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions { }
    }
    labels
    {
        ReportCaption = 'PAY SLIP';
    }
    trigger OnPreReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        PGSetup.Get;
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        GetCompanyOneLineAddress;
        if NepaliYear = 0 then
            Error('Please enter year');
        if Months = Months::" " then
            Error('Please enter months');
        EngNepDate.Reset;
        EngNepDate.SetRange("Nepali Year", NepaliYear);
        EngNepDate.SetRange("Nepali Month", Months);
        if EngNepDate.FindFirst then
            FisCalYr := EngNepDate."Fiscal Year"
        else
            Error('Could not find the Nepali year');
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PGSetup: Record "Payroll General Setup";
        CompanyInfo: Record "Company Information";
        Employee: Record Employee;
        DimensionValue: Record "Dimension Value";
        PayrollAttributes: Record "Payroll Attributes";
        EnglishNepaliDate: Record "English-Nepali Date";
        FormatAddr: Codeunit "Format Address";
        TotalAmountText: array[2] of Text[80];
        NetPayAmount: Decimal;
        CompanyOneLineAddress: Text;
        CompanyCommunicationAddress: Text;
        CompanyAddr: array[8] of Text[50];
        PayPeriod: Text[250];
        Dim1Code: Text[250];
        Dim2Code: Text[250];
        AttributeDescription: Text[30];
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
        EmployeeNo: Code[20];
        FisCalYr: Code[20];
        Months: Enum "Nepali Month";
        PayrollHeader: Record "Payroll Header";
        NepaliYear: Integer;
        EngNepDate: Record "English-Nepali Date";
        PostedPayrollLine: Record "Posted Payroll Line";
        FunctionalTitle: Record "Functional Title";
        DeputationOn: Text;
        DeputationOnValue: Text;
        Grade: Text;
        FunctionalTitledesc: Text;
        SalaryLevel: Record "Salary Level";

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

    procedure SetEmployeeFilter(EmpFIlter: Text)
    begin
        EmployeeNo := EmpFIlter;
    end;

    procedure PassParPortal(empCode: Code[20]; year: Integer; Month: Enum "Nepali Month")
    var
        PostedPayroll: Record "Posted Payroll Header";
    begin
        EmployeeNo := empCode;
        Months := Month;
        NepaliYear := year;
        //FisCalYr := FiscalYear;
    end;

    procedure ExitTransferDeputationWiseValue(DeputationOnOpt: enum "Deputation Type"; DeputationCodeVar: Code[20]): Text
    var
        // DimValue: Record "Dimension Value";
        // Depart: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        // SubProvince: Record "Sub Province";
        Province: Record Province;
        OrganizationStructureList: Record "Organization Structure List";
    begin
        // Clear(DimValue);
        // Clear(Depart);
        // Clear(EmpHie);
        // Clear(SubProvince);
        Clear(Province);
        case DeputationOnOpt of
            DeputationOnOpt::Branch:
                begin
                    OrganizationStructureList.Reset();
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, DeputationCodeVar) then
                        exit(OrganizationStructureList.Name);
                end;
            DeputationOnOpt::Department:
                begin
                    OrganizationStructureList.Reset();
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, DeputationCodeVar) then
                        exit(OrganizationStructureList.Name);
                end;
            DeputationOnOpt::"Extension Counter":
                begin
                    OrganizationStructureList.Reset();
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", DeputationCodeVar) then
                        exit(OrganizationStructureList.Name);
                end;
            // DeputationOnOpt::"Sub Province":
            //     begin
            //         SubProvince.Reset;
            //         SubProvince.SetRange(Code, DeputationCodeVar);
            //         if SubProvince.FindFirst then
            //             exit(SubProvince.City);
            //     end;
            DeputationOnOpt::Unit:
                begin
                    OrganizationStructureList.Reset();
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, DeputationCodeVar) then
                        exit(OrganizationStructureList.Name);
                end;
            DeputationOnOpt::Province:
                begin
                    OrganizationStructureList.Reset();
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, DeputationCodeVar) then
                        exit(OrganizationStructureList.Name);
                end;
        end;
    end;
}
