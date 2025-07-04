report 50130 "Tax Deduction Info Mob App"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019931.TaxDeductionInfoMobApp.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(Title; Title) { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyOneLineAddress; CompanyOneLineAddress) { }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress) { }
            column(CompanyInfoVATRegNo; CompanyInfo.FieldCaption("VAT Registration No.") + ' : ' + CompanyInfo."VAT Registration No.") { }
            column(EmployeeNo; Employee."No.") { }
            column(EmployeeName; Employee."Full Name") { }
            column(EmployeePosition; SalaryLevel.Description) { }
            column(Deputationon; Employee."Deputation on") { }
            column(DeputationValue; DeputationValue) { }
            column(DeparmentName; Employee."Department Name") { }
            column(FiscalYear; EngNepDate."Fiscal Year") { }
            column(Month; Month) { }
            column(Year; Year) { }
            column(VoucherNo; DocumentNo) { }
            dataitem("Employee Payroll Opening"; "Employee Payroll Opening")
            {
                DataItemLink = "Employee No." = field("No.");
                column(EmployeeNo_EmployeePayrollOpening; "Employee Payroll Opening"."Employee No.") { }
                column(LineNo_EmployeePayrollOpening; "Employee Payroll Opening"."Line No.") { }
                column(EmployeeName_EmployeePayrollOpening; "Employee Payroll Opening"."Employee Name") { }
                column(FiscalYear_EmployeePayrollOpening; "Employee Payroll Opening"."Fiscal Year") { }
                column(TotalBenefitOpening_EmployeePayrollOpening; "Employee Payroll Opening"."Total Benefit Opening") { }
                column(TotalRFOpening_EmployeePayrollOpening; "Employee Payroll Opening"."Total RF Opening") { }
                column(TotalSocialSecurityOpening_EmployeePayrollOpening; "Employee Payroll Opening"."Total Social Security Opening") { }
                column(TotalTaxRemunerationOpening_EmployeePayrollOpening; "Employee Payroll Opening"."Total Tax Remuneration Opening") { }

                trigger OnPreDataItem()
                begin
                    "Employee Payroll Opening".SetRange("Fiscal Year", EngNepDate."Fiscal Year");
                end;
            }
            dataitem(ExcelBuffer; "Excel Buffer")
            {
                DataItemTableView = where("Cell Type" = const(Text));
                UseTemporary = true;
                column(NepaliMonth; ExcelBuffer.Comment) { }
                column(Heading1; ExcelBuffer."Cell Value as Text") { }
                column(Heading2; ExcelBuffer.Formula) { }
                column(Amount; ExcelBuffer."Decimal Value") { }
                column(NumberFormat; NumberFormat) { }
                column(PayCycleValue; "Pay Cycle Value") { }
            }
            dataitem(CurrentPayroll; "Excel Buffer")
            {
                DataItemTableView = where("Cell Type" = const(Number));
                UseTemporary = true;
                column(RowNo_; "Row No.") { }
                column(ColumnNo_; "Column No.") { }
                column(PayrollHeaderNo; NumberFormat) { }
                column(NepaliYear1; xlRowID) { }
                column(NepaliMonth1; Comment) { }
                column(Type; "Cell Value as Text") { }
                column(Description; Formula) { }
                column(CurrentMonthAmt; "Decimal Value") { }
                column(TotalValue; "Total Value") { }
                column(IntegerValue; "Integer Value") { }
            }

            trigger OnAfterGetRecord()
            begin
                PreviousTaxable := 0;
                PreviousRF := 0;
                Clear(SalaryLevel);

                //oman changed
                EmpPayOpening.Reset;
                EmpPayOpening.SetRange("Employee No.", "No.");
                EmpPayOpening.SetRange("Fiscal Year", EngNepDate."Fiscal Year");
                if EmpPayOpening.FindFirst then;
                if SalaryLevel.Get("Salary Level") then;
                //oman changed
                InsertPreviousPayrollHistory(Employee."No.");
                InsertCurrentPayrollData;
                DeputationValue := ServiceHistoryMgt.ExitTransferDeputationWiseValue(Employee."Deputation on", Employee."No.");
            end;

            trigger OnPreDataItem()
            begin

                if EmployeeNoFilter <> '' then
                    SetFilter("No.", EmployeeNoFilter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Please Please enter year & month")
                {
                    field("Pay Cycle Term"; PayCycleTermText)
                    {
                        TableRelation = "Pay Cycle Term".Term;
                        ToolTip = 'Specifies the value of the PayCycleTermText field.';
                        ApplicationArea = All;
                    }
                    field(Month; Month)
                    {
                        Caption = 'Nepali Month';
                        ToolTip = 'Specifies the value of the Nepali Month field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if PayCycleTermText = '' then
                                Error('Please select pay cycle term first.');
                            PostedPayrollHeader.Reset;
                            PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTermText);
                            PostedPayrollHeader.SetRange("Nepali Month", Month);
                            PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
                            if PostedPayrollHeader.FindFirst then
                                DocumentNo := PostedPayrollHeader."No."
                            else
                                DocumentNo := '';
                        end;
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'Voucher No.';
                        ToolTip = 'Specifies the value of the Voucher No. field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if PayCycleTermText = '' then
                                Error('You must choose pay cycle term.');
                            if Month = Month::" " then
                                Error('You must choose Nepali month.');
                            PostedPayrollHeader.Reset;
                            PostedPayrollHeader.FilterGroup(2);
                            PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTermText);
                            PostedPayrollHeader.SetRange("Nepali Month", Month);
                            PostedPayrollHeader.FilterGroup(0);
                            Clear(PagePostedPayroll);
                            PagePostedPayroll.ToSelect;
                            PagePostedPayroll.SetRecord(PostedPayrollHeader);
                            PagePostedPayroll.SetTableView(PostedPayrollHeader);

                            if PagePostedPayroll.RunModal = Action::OK then begin
                                ;
                                DocumentNo := PagePostedPayroll.ReturnPostedDocext;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            if DocumentNo = '' then
                                Error('Select Voucher no. to run this report.');
                        end;
                    }
                    field("Employee No."; EmployeeNoFilter)
                    {
                        TableRelation = Employee;
                        ToolTip = 'Specifies the value of the EmployeeNoFilter field.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        GetCompanyOneLineAddress;

        PGSetup.Get;
        Month := PGSetup."HRMS Month";
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Start Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        PayCyclePeriod.SetRange("Nepali Month", PGSetup."HRMS Month");
        if PayCyclePeriod.FindFirst then
            PayCycleTermText := PayCyclePeriod."Pay Cycle Term";

        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTermText);
        PostedPayrollHeader.SetRange("Nepali Month", Month);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
        if PostedPayrollHeader.FindFirst then
            DocumentNo := PostedPayrollHeader."No.";
    end;

    trigger OnPreReport()
    begin
        /*IF Year = 0 THEN
          ERROR('Please enter valid year to preview the report.');
        IF Month = Month::" " THEN
          ERROR('Please select valid month to preview the report.');
          */

        if DocumentNo = '' then
            Error('Select Voucher No. to run this report.');
        if EmployeeNoFilter = '' then
            EmployeeNoFilter := Employee."No."; //Min -- Assign employee no.
                                                /*IF EmployeeNoFilter = '' THEN
                                                  ERROR('Please select an employee.');*/
                                                //IF Employee.GETFILTER("No.") = '' THEN
                                                //ERROR('Please select employee no. to preview the report.');

        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTermText);
        PayCyclePeriod.SetRange("Nepali Month", Month);
        if PayCyclePeriod.FindFirst then begin
            EngNepDate.Reset;
            EngNepDate.SetRange("English Date", PayCyclePeriod."Start Date");
            EngNepDate.FindFirst;
            Year := EngNepDate."Nepali Year";
        end;
    end;

    var
        Year: Integer;
        Month: Enum "Nepali Month";
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
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
        PostedPayrollHeader: Record "Posted Payroll Header";
        PreviousPayrollHdr: Record "Posted Payroll Header";
        PreviousPayrollLine: Record "Posted Payroll Line";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollColumnConfig: Record "Payroll Column Configuration";
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        CalculatedAmt: Decimal;
        RowNo: Integer;
        ColumnNo: Integer;
        PreviousTaxable: Decimal;
        PreviousRF: Decimal;
        ProjectionMonth: Integer;
        CurrentMonthRF: Decimal;
        EstimatedRF: Decimal;
        EligibleRF: Decimal;
        ProjectedBenefit: Decimal;
        DisablePersonReduction: Decimal;
        NetTaxable: Decimal;
        EstimatedTax: Decimal;
        TotalTaxPaid: Decimal;
        MedicalRebate: Decimal;
        RemainingTax: Decimal;
        CurrentMonthTax: Decimal;
        EngNepDate: Record "English-Nepali Date";
        EmployeeNoFilter: Code[20];
        PostedPayrollLine: Record "Posted Payroll Line";
        EmployeeFound: Boolean;
        CurrentMonthIncome: Decimal;
        Assessableincome: Decimal;
        TotalTaxableMonthWise: Decimal;
        DocumentNo: Code[20];
        PGSetup: Record "Payroll General Setup";
        HealthInsuranceAmt: Decimal;
        PagePostedPayroll: Page "Posted Payroll Plan List";
        EmpPayOpening: Record "Employee Payroll Opening";
        PayCyclePeriod: Record "Pay Cycle Period";
        PayCycleTermText: Text;
        HRMgt: Codeunit "HR Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        DeputationValue: Text;
        SalaryLevel: Record "Salary Level";
        RemoteAreaAmt: Decimal;

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

    local procedure InsertPreviousPayrollHistory(EmployeeNo: Code[20])
    begin
        PostedPayrollHeader.Reset;
        //PostedPayrollHeader.SETRANGE("Nepali Year",Year);
        //PostedPayrollHeader.SETRANGE("Nepali Month",Month);
        //PostedPayrollHeader.SETRANGE(Type,PostedPayrollHeader.Type::Payroll);
        PostedPayrollHeader.SetRange("No.", DocumentNo);

        /*IF Employee."Employment Type" = Employee."Employment Type"::Contract THEN
          PostedPayrollHeader.SETRANGE("Employee Type",PostedPayrollHeader."Employee Type"::Contract)
        ELSE
          PostedPayrollHeader.SETRANGE("Employee Type",PostedPayrollHeader."Employee Type"::Permanent);*/
        if PostedPayrollHeader.FindFirst then
            repeat
                PostedPayrollLine.Reset;
                PostedPayrollLine.SetRange("Document No.", PostedPayrollHeader."No.");
                PostedPayrollLine.SetRange("Employee No.", Employee."No.");
                if PostedPayrollLine.FindSet then begin
                    EmployeeFound := true;
                end;
            until (PostedPayrollHeader.Next = 0) or EmployeeFound;

        if not EmployeeFound then
            Error('Regular payroll is not posted yet for this employee.');

        PreviousPayrollHdr.Reset;
        PreviousPayrollHdr.SetRange("Pay Cycle Code", PostedPayrollHeader."Pay Cycle Code");
        PreviousPayrollHdr.SetRange("Pay Cycle Term", PostedPayrollHeader."Pay Cycle Term");
        PreviousPayrollHdr.SetFilter("Posted Date", '<%1', PostedPayrollHeader."Posted Date");
        PreviousPayrollHdr.SetRange(Reversed, false); //Min -- for exclude reverse entry.
        //PreviousPayrollHdr.SETFILTER("Pay Cycle Period",'<=%1',PostedPayrollHeader."Pay Cycle Period");
        //PreviousPayrollHdr.SETFILTER("No.",'<>%1',PostedPayrollHeader."No.");
        //PreviousPayrollHdr.SETRANGE("No.",'POSTPADJ_77_78_00046');
        if PreviousPayrollHdr.FindFirst then
            repeat
                PreviousPayrollLine.Reset;
                PreviousPayrollLine.SetRange("Document No.", PreviousPayrollHdr."No.");
                PreviousPayrollLine.SetRange("Employee No.", Employee."No.");
                PreviousPayrollLine.SetRange(Reversed, false); //Min -- for exclude reverse entry.
                if PreviousPayrollLine.FindSet then begin
                    TotalTaxableMonthWise := 0;

                    RecRefs.Open(Database::"Posted Payroll Line");
                    FieldRefs := RecRefs.Field(1);
                    FieldRefs.SetRange(PreviousPayrollHdr."No.");
                    FieldRefs := RecRefs.Field(3);
                    FieldRefs.SetRange(EmployeeNo);
                    RecRefs.FindFirst;

                    PayrollAttributes.SetCurrentKey("Tax Info Report Type");
                    PayrollAttributes.Reset;
                    PayrollAttributes.SetFilter("Tax Info Report Type", '<>%1', PayrollAttributes."Tax Info Report Type"::" ");
                    if PayrollAttributes.FindFirst then
                        repeat
                            CalculatedAmt := 0;
                            PayrollColumnConfig.Reset;
                            PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                            PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
                            if PayrollColumnConfig.FindFirst then begin
                                FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                                CalculatedAmt := FieldRefs.Value;

                                ExcelBuffer.Reset;
                                ExcelBuffer.SetRange("Cell Value as Text", Format(PayrollAttributes."Tax Info Report Type"));
                                ExcelBuffer.SetRange("Cell Type", ExcelBuffer."Cell Type"::Text); //For previous posted payrolls
                                ExcelBuffer.SetRange(Comment, Format(PreviousPayrollHdr."Nepali Month"));
                                if PayrollAttributes."Tax Info Report Type" in [PayrollAttributes."Tax Info Report Type"::"3 RF Contribution",
                                                    PayrollAttributes."Tax Info Report Type"::"5 Retirement Fund"] then
                                    //PayrollAttributes."Tax Info Report Type"::"2 Allowance"] THEN
                                    ExcelBuffer.SetRange(Formula, PayrollAttributes.Code);
                                if PayrollAttributes."Tax Info Report Type" = PayrollAttributes."Tax Info Report Type"::"2 Allowance" then
                                    ExcelBuffer.SetRange(Bold, PayrollAttributes."Apply Every Month");
                                if PayrollAttributes."Tax Info Report Type" = PayrollAttributes."Tax Info Report Type"::"7 Flat" then
                                    ExcelBuffer.SetRange(Formula, '1 Taxable');
                                ExcelBuffer.SetRange(NumberFormat, PreviousPayrollHdr."No.");
                                if not ExcelBuffer.FindFirst then begin

                                    ExcelBuffer.Init;
                                    ExcelBuffer."Row No." := RowNo;
                                    ExcelBuffer."Column No." := ColumnNo;
                                    ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text; //For previous posted payrolls
                                    ExcelBuffer.NumberFormat := PreviousPayrollHdr."No.";
                                    ExcelBuffer.Comment := Format(PreviousPayrollHdr."Nepali Month");
                                    ExcelBuffer.xlRowID := Format(PreviousPayrollHdr."Nepali Year");
                                    ExcelBuffer."Pay Cycle Value" := PreviousPayrollHdr."Pay Cycle Period";
                                    //ExcelBuffer."Value Date" := PreviousPayrollHdr."From Date";
                                    ExcelBuffer."Cell Value as Text" := Format(PayrollAttributes."Tax Info Report Type");
                                    ExcelBuffer."Decimal Value" := CalculatedAmt;
                                    ExcelBuffer.Bold := PayrollAttributes."Apply Every Month";
                                    if PayrollAttributes."Tax Info Report Type" in [PayrollAttributes."Tax Info Report Type"::"3 RF Contribution",
                                                      PayrollAttributes."Tax Info Report Type"::"5 Retirement Fund"] then
                                        ExcelBuffer.Formula := PayrollAttributes.Code;
                                    case PayrollAttributes."Tax Info Report Type" of
                                        PayrollAttributes."Tax Info Report Type"::"2 Allowance":
                                            begin
                                                if not PayrollAttributes."Apply Every Month" then
                                                    ExcelBuffer.Formula := 'Annually'
                                                else
                                                    ExcelBuffer.Formula := 'Monthly';
                                            end;
                                        PayrollAttributes."Tax Info Report Type"::"7 Flat":
                                            begin
                                                ExcelBuffer.Formula := '1 Taxable';
                                            end;
                                    end;
                                    ExcelBuffer.Insert;

                                    IncrementRowColumn;
                                end else begin

                                    ExcelBuffer."Decimal Value" += CalculatedAmt;
                                    ExcelBuffer.Modify;
                                end;
                            end;
                            if PayrollAttributes."Tax Info Report Type" = PayrollAttributes."Tax Info Report Type"::"5 Retirement Fund" then
                                PreviousRF += ExcelBuffer."Decimal Value";
                            if PayrollAttributes."Tax Info Report Type" in [PayrollAttributes."Tax Info Report Type"::"1 Salary", PayrollAttributes."Tax Info Report Type"::"2 Allowance",
                                    PayrollAttributes."Tax Info Report Type"::"3 RF Contribution", PayrollAttributes."Tax Info Report Type"::"4 Other Facility"] then
                                TotalTaxableMonthWise += CalculatedAmt;
                        until PayrollAttributes.Next = 0;
                    RecRefs.Close;
                    InsertTaxableColumn;
                    InsertTotalRFColumn;
                    InsertLeaveEncashGratuityColumn;
                    //InsertOtherFacilityColumn; //Min
                end;
            until PreviousPayrollHdr.Next = 0;
    end;

    local procedure InsertTaxableColumn()
    begin
        ExcelBuffer.Init;
        ExcelBuffer."Row No." := RowNo;
        ExcelBuffer."Column No." := ColumnNo;
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
        ExcelBuffer.NumberFormat := PreviousPayrollHdr."No.";
        ExcelBuffer.Comment := Format(PreviousPayrollHdr."Nepali Month");
        ExcelBuffer.xlRowID := Format(PreviousPayrollHdr."Nepali Year");
        ExcelBuffer."Cell Value as Text" := '4.5 Taxable';
        ExcelBuffer."Decimal Value" := TotalTaxableMonthWise;
        ExcelBuffer.Insert;
        PreviousTaxable += TotalTaxableMonthWise;

        IncrementRowColumn;
    end;

    local procedure InsertLeaveEncashGratuityColumn()
    begin
        ExcelBuffer.Init;
        ExcelBuffer."Row No." := RowNo;
        ExcelBuffer."Column No." := ColumnNo;
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
        ExcelBuffer.NumberFormat := PreviousPayrollHdr."No.";
        ExcelBuffer.Comment := Format(PreviousPayrollHdr."Nepali Month");
        ExcelBuffer.xlRowID := Format(PreviousPayrollHdr."Nepali Year");
        ExcelBuffer."Cell Value as Text" := '7 Flat';
        ExcelBuffer.Formula := '2 Tax';
        ExcelBuffer."Decimal Value" := PreviousPayrollLine."Gratuity & leave Encash Tax";
        ExcelBuffer.Insert;

        IncrementRowColumn;
    end;

    local procedure InsertTotalRFColumn()
    begin
        ExcelBuffer.Init;
        ExcelBuffer."Row No." := RowNo;
        ExcelBuffer."Column No." := ColumnNo;
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
        ExcelBuffer.NumberFormat := PreviousPayrollHdr."No.";
        ExcelBuffer.Comment := Format(PreviousPayrollHdr."Nepali Month");
        ExcelBuffer.xlRowID := Format(PreviousPayrollHdr."Nepali Year");
        ExcelBuffer."Cell Value as Text" := '5.5 Total Deduction';
        ExcelBuffer."Decimal Value" := PreviousPayrollLine."Current Deduction";
        ExcelBuffer.Insert;

        IncrementRowColumn;
    end;

    local procedure IncrementRowColumn()
    begin
        RowNo += 1;
        ColumnNo += 1;
    end;

    local procedure InsertCurrentPayrollData()
    begin
        InsertPreviousTaxable;
        InsertBenefits;
        InsertAssessableIncome;
        InsertPreviousRF;
        InsertReductions;
        InsertCurrentMonthRF;
        InsertEstimatedMonthRF;
        EligibleRFContribution(Employee."No.");
        InsertTaxableRF;
        InsertEstimatedTaxableIncome;
        InsertInsuranceRebate;
        InsertHealthInsuranceRebate;
        InsertRemoteAreaDeduction();
        InsertBalanceTaxableIncome;
        InsertTaxExempt;
        InsertNetTaxable;
        InsertSlabTax;
        InsetEstimatedTax;
        InsertPreviousTax;
        InsertMedicalRebate;
        InsertFemaleRebate;
        InsertRemainingTax;
        InsertCurrentMonthTax;
    end;

    local procedure InsertPreviousTaxable()
    begin
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Taxable';
        CurrentPayroll.Formula := 'Previous Taxable';
        CurrentPayroll."Total Value" := PreviousTaxable + EmpPayOpening."Total Benefit Opening"; //oman changed
        CurrentPayroll.Insert;

        IncrementRowColumn;
    end;

    local procedure InsertPreviousRF()
    begin
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Retire. Fund';
        CurrentPayroll.Formula := 'Previous RF';
        CurrentPayroll."Total Value" := PreviousRF + EmpPayOpening."Total RF Opening";  //oman changed
        CurrentPayroll.Insert;

        IncrementRowColumn;
    end;

    local procedure InsertBenefits()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee.GetFilter("No."));
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70026);
        ProjectionMonth := FieldRefs.Value;
        ProjectionMonth += 1;
        PayrollAttributes.SetCurrentKey("Tax Info Report Type");
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        if PayrollAttributes.FindFirst then
            repeat
                Clear(CalculatedAmt);
                PayrollColumnConfig.Reset;
                PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
                if PayrollColumnConfig.FindFirst then begin
                    FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                    CalculatedAmt := FieldRefs.Value;
                end;
                CurrentPayroll.Init;
                CurrentPayroll."Row No." := RowNo;
                CurrentPayroll."Column No." := ColumnNo;
                CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
                CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
                CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
                CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
                CurrentPayroll."Cell Value as Text" := 'Taxable';
                CurrentPayroll.Formula := PayrollAttributes.Description;
                CurrentPayroll."Decimal Value" := CalculatedAmt;
                if (PayrollAttributes."Apply Every Month") and (PostedPayrollHeader.Type = PostedPayrollHeader.Type::Payroll) then
                    CurrentPayroll."Integer Value" := ProjectionMonth
                else
                    CurrentPayroll."Integer Value" := 1;
                if CurrentPayroll."Integer Value" = 1 then
                    CurrentPayroll."Total Value" := CalculatedAmt
                else
                    CurrentPayroll."Total Value" := ProjectionMonth * CalculatedAmt;
                ProjectedBenefit += CurrentPayroll."Total Value";

                CurrentMonthIncome += CurrentPayroll."Decimal Value";

                CurrentPayroll.Insert;

                IncrementRowColumn;
            until PayrollAttributes.Next = 0;
        if CurrentMonthIncome <> 0 then begin
            CurrentPayroll.Init;
            CurrentPayroll."Row No." := RowNo;
            CurrentPayroll."Column No." := ColumnNo;
            CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
            CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
            CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
            CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
            CurrentPayroll."Cell Value as Text" := '';
            CurrentPayroll.Formula := 'Current Month Income';
            CurrentPayroll."Decimal Value" := CurrentMonthIncome;
            CurrentPayroll."Total Value" := CurrentMonthIncome;
        end;
        IncrementRowColumn;
        IncrementRowColumn;
        RecRefs.Close
    end;

    local procedure InsertReductions()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee.GetFilter("No."));
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70026);
        ProjectionMonth := FieldRefs.Value;
        ProjectionMonth += 1;

        PayrollAttributes.SetCurrentKey("Tax Info Report Type");
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Deduction);
        PayrollAttributes.SetFilter(Subtype, '%1|%2|%3|%4', PayrollAttributes.Subtype::"Employee Contribution", PayrollAttributes.Subtype::"Employer Contribution"
                                    , PayrollAttributes.Subtype::CIT, PayrollAttributes.Subtype::RF);
        if PayrollAttributes.FindFirst then
            repeat
                Clear(CalculatedAmt);
                PayrollColumnConfig.Reset;
                PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
                if PayrollColumnConfig.FindFirst then begin
                    FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                    CalculatedAmt := FieldRefs.Value;
                end;
                CurrentPayroll.Init;
                CurrentPayroll."Row No." := RowNo;
                CurrentPayroll."Column No." := ColumnNo;
                CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
                CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
                CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
                CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
                CurrentPayroll."Cell Value as Text" := 'Retire. Fund';
                CurrentPayroll.Formula := PayrollAttributes.Description;
                CurrentPayroll."Decimal Value" := CalculatedAmt;
                if PayrollAttributes."Apply Every Month" then
                    CurrentPayroll."Integer Value" := ProjectionMonth
                else
                    CurrentPayroll."Integer Value" := 1;
                if CurrentPayroll."Integer Value" = 1 then
                    CurrentPayroll."Total Value" := CalculatedAmt
                else
                    CurrentPayroll."Total Value" := ProjectionMonth * CalculatedAmt;
                CurrentPayroll.Insert;
                CurrentMonthRF += CalculatedAmt;
                EstimatedRF += ProjectionMonth * CalculatedAmt;

                IncrementRowColumn;
            until PayrollAttributes.Next = 0;
        RecRefs.Close;
    end;

    local procedure InsertCurrentMonthRF()
    begin
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Retire. Fund';
        CurrentPayroll.Formula := 'Current Month RF';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := CurrentMonthRF;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertEstimatedMonthRF()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee.GetFilter("No."));
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70005);
        EstimatedRF := FieldRefs.Value;

        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Retire. Fund';
        CurrentPayroll.Formula := 'Estimated Total RF (ii)';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := EstimatedRF;
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    local procedure EligibleRFContribution(EmployeeNo: Code[20])
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(EmployeeNo);
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70006);
        EligibleRF := FieldRefs.Value;
        if PGSetup."Tax Ex. Amt. not Exceeding" < EligibleRF then
            EligibleRF := PGSetup."Tax Ex. Amt. not Exceeding";

        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Retire. Fund';
        CurrentPayroll.Formula := 'Maximum Retirement Fund Manage (without Taxable) *';
        CurrentPayroll."Total Value" := EligibleRF;
        CurrentPayroll.Insert;
        RecRefs.Close;
        IncrementRowColumn;
    end;

    local procedure InsertTaxableRF()
    begin
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Retire. Fund';
        CurrentPayroll.Formula := 'Taxable RF (iii)';
        CurrentPayroll."Decimal Value" := 0;
        if EstimatedRF - EligibleRF < 0 then
            CurrentPayroll."Total Value" := 0
        else
            CurrentPayroll."Total Value" := EstimatedRF - EligibleRF;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertInsuranceRebate()
    var
        InsuranceAmt: Decimal;
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70008);
        InsuranceAmt := FieldRefs.Value;
        //FieldRefs := RecRefs.FIELD(70009);
        //InsuranceAmt := FieldRefs.VALUE;

        RecRefs.Close;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Reductions';
        CurrentPayroll.Formula := 'Life Insurance Premium';
        CurrentPayroll."Decimal Value" := InsuranceAmt;
        CurrentPayroll."Total Value" := 0;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertEstimatedTaxableIncome()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70010);

        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := '';
        CurrentPayroll.Formula := 'Estimated Taxable Income';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := FieldRefs.Value;
        CurrentPayroll.Insert;
        IncrementRowColumn;

        RecRefs.Close;
    end;

    local procedure InsertTaxExempt()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70011);
        DisablePersonReduction := FieldRefs.Value;
        RecRefs.Close;

        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Reductions';
        CurrentPayroll.Formula := 'Disable Person Reduction';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := DisablePersonReduction;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertNetTaxable()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(11);
        NetTaxable := FieldRefs.Value;
        RecRefs.Close;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := '';
        CurrentPayroll.Formula := 'Net Taxable';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := NetTaxable;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertSlabTax()
    var
        SlabCount: Integer;
        SlabAmount: Decimal;
    begin
        SlabCount := 1;
        RecRefs.Open(Database::"Posted Payroll Line");
        while SlabCount <= 5 do begin
            FieldRefs := RecRefs.Field(1);
            FieldRefs.SetRange(PostedPayrollHeader."No.");
            FieldRefs := RecRefs.Field(3);
            FieldRefs.SetRange(Employee."No.");
            RecRefs.FindFirst;
            FieldRefs := RecRefs.Field(70029 + SlabCount);
            SlabAmount := FieldRefs.Value;

            CurrentPayroll.Init;
            CurrentPayroll."Row No." := RowNo;
            CurrentPayroll."Column No." := ColumnNo;
            CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
            CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
            CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
            CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
            CurrentPayroll."Cell Value as Text" := 'Tax';
            CurrentPayroll.Formula := FieldRefs.Caption;
            CurrentPayroll."Decimal Value" := 0;
            CurrentPayroll."Total Value" := SlabAmount;
            CurrentPayroll.Insert;
            IncrementRowColumn;
            IncrementRowColumn;
        end;
        RecRefs.Close;
    end;

    local procedure InsetEstimatedTax()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70014);
        EstimatedTax := FieldRefs.Value;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Tax';
        CurrentPayroll.Formula := 'Estimated Total tax';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := EstimatedTax;
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    local procedure InsertPreviousTax()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70018);
        TotalTaxPaid := FieldRefs.Value;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Tax';
        CurrentPayroll.Formula := 'Total tax paid';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := TotalTaxPaid;//oman changed
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    local procedure InsertMedicalRebate()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        //FieldRefs := RecRefs.FIELD(70018);
        //MedicalRebate := FieldRefs.VALUE;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Tax';
        CurrentPayroll.Formula := 'Medical Rebate';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := MedicalRebate;
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    local procedure InsertRemainingTax()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70015);
        RemainingTax := FieldRefs.Value;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Tax';
        CurrentPayroll.Formula := 'Remaining Tax';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := RemainingTax;
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    local procedure InsertCurrentMonthTax()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");

        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(12);
        CurrentMonthTax := FieldRefs.Value;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Tax';
        CurrentPayroll.Formula := 'Current Month Tax';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := CurrentMonthTax;
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    local procedure InsertAssessableIncome()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");

        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70002);
        Assessableincome := FieldRefs.Value;

        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := '';
        CurrentPayroll.Formula := 'Assessable Income (i)';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := Assessableincome;
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    local procedure InsertHealthInsuranceRebate()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70009);
        HealthInsuranceAmt := FieldRefs.Value;

        RecRefs.Close;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Reductions';
        CurrentPayroll.Formula := 'Health Insurance Premium';
        CurrentPayroll."Decimal Value" := HealthInsuranceAmt;
        CurrentPayroll."Total Value" := 0;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertRemoteAreaDeduction()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(80001);
        RemoteAreaAmt := FieldRefs.Value;

        RecRefs.Close;
        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Reductions';
        CurrentPayroll.Formula := 'Remote Area Reduction';
        CurrentPayroll."Decimal Value" := RemoteAreaAmt;
        CurrentPayroll."Total Value" := 0;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertBalanceTaxableIncome()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(11);
        RecRefs.Close;

        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := '';
        CurrentPayroll.Formula := 'Balance Taxable Income';
        CurrentPayroll."Decimal Value" := 0;
        CurrentPayroll."Total Value" := FieldRefs.Value;
        CurrentPayroll.Insert;
        IncrementRowColumn;
    end;

    local procedure InsertFemaleRebate()
    begin
        RecRefs.Open(Database::"Posted Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PostedPayrollHeader."No.");
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Employee."No.");
        RecRefs.FindFirst;
        FieldRefs := RecRefs.Field(70012);

        CurrentPayroll.Init;
        CurrentPayroll."Row No." := RowNo;
        CurrentPayroll."Column No." := ColumnNo;
        CurrentPayroll."Cell Type" := CurrentPayroll."Cell Type"::Number;
        CurrentPayroll.NumberFormat := PostedPayrollHeader."No.";
        CurrentPayroll.Comment := Format(PostedPayrollHeader."Nepali Month");
        CurrentPayroll.xlRowID := Format(PostedPayrollHeader."Nepali Year");
        CurrentPayroll."Cell Value as Text" := 'Tax';
        CurrentPayroll.Formula := 'Female Tax Rebate';
        CurrentPayroll."Decimal Value" := FieldRefs.Value;
        CurrentPayroll."Total Value" := 0;
        CurrentPayroll.Insert;
        IncrementRowColumn;
        RecRefs.Close;
    end;

    procedure PassParPortal(DocNo: Code[20]; yearpar: Integer; Monthpar: Enum "Nepali Month")
    var
        PostedPayroll: Record "Posted Payroll Header";
    begin
        //EmployeeNo := empCode;
        Month := Monthpar;
        Year := yearpar;
        DocumentNo := DocNo;
        //FisCalYr := FiscalYear;
    end;

    local procedure InsertOtherFacilityColumn()
    begin
        ExcelBuffer.Init;
        ExcelBuffer."Row No." := RowNo;
        ExcelBuffer."Column No." := ColumnNo;
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
        ExcelBuffer.NumberFormat := PreviousPayrollHdr."No.";
        ExcelBuffer.Comment := Format(PreviousPayrollHdr."Nepali Month");
        ExcelBuffer.xlRowID := Format(PreviousPayrollHdr."Nepali Year");
        ExcelBuffer."Cell Value as Text" := '4 Other Facility';
        ExcelBuffer."Decimal Value" := TotalTaxableMonthWise;
        ExcelBuffer.Insert;

        IncrementRowColumn;
    end;
}
