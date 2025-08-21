report 50115 "TDS Deposit Record"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019916.TDSDepositRecord.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(PayCycleTerm; PayCycleTerm) { }
            column(FiscalYear; FiscalYear) { }
            column(Title; Title) { }
            column(CompanyName; CompanyInfo.Name) { }
            dataitem(Employee; Employee)
            {
                column(No; "No.") { }
                column(Name; "Full Name") { }
                column(PANNo; "PAN No.") { }
                column(AddressText; AddressText) { }
                dataitem("Pay Cycle Period"; "Pay Cycle Period")
                {
                    column(NepaliMonth; "Nepali Month") { }
                    column(TaxPaymentDate; "Tax Payment Date") { }
                    column(IncomeTaxVoucherNo; "Income Tax Voucher No.") { }
                    column(SSTVoucherNo; "SST Voucher No.") { }
                    column(ETDSTransactionNumber; "E-TDS Transaction Number") { }
                    column(NepaliYear; EngNepDate."Nepali Year") { }
                    column(TotalBenefit; TotalBenefit) { }
                    column(SST; SST) { }
                    column(TaxonRenum; TaxonRenum) { }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(TotalBenefit);
                        Clear(TaxonRenum);
                        Clear(SST);
                        DetailedEmpLedger.Reset;
                        DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                        DetailedEmpLedger.SetRange(Reversed, false);
                        DetailedEmpLedger.SetFilter("Attribute Type", '%1|%2', DetailedEmpLedger."Attribute Type"::"Basic Earning",
                                                    DetailedEmpLedger."Attribute Type"::"Other Earnings");
                        //DetailedEmpLedger.SETFILTER("Attribute Sub Type",'<>%1',DetailedEmpLedger."Attribute Sub Type"::"Tax on Interest");
                        DetailedEmpLedger.SetRange("Posting Date", "Start Date", "End Date");
                        DetailedEmpLedger.CalcSums(Amount);
                        TotalBenefit := DetailedEmpLedger.Amount;
                        /*
                        DetailedEmpLedger.Reset();
                        DetailedEmpLedger.SetRange("Employee No.",Employee."No.");
                        DetailedEmpLedger.SetRange(Reversed,FALSE);
                        DetailedEmpLedger.SetRange(Disabled,FALSE);
                        DetailedEmpLedger.SetRange("Attribute Type",DetailedEmpLedger."Attribute Type"::Deduction);
                        DetailedEmpLedger.SETFILTER("Attribute Sub Type",'%1|%2|%3|%4|%5',DetailedEmpLedger."Attribute Sub Type"::CIT,
                                                    DetailedEmpLedger."Attribute Sub Type"::"Employee Contribution",DetailedEmpLedger."Attribute Sub Type"::"Employer Contribution",
                                                    DetailedEmpLedger."Attribute Sub Type"::"Lump Sum Contribution",DetailedEmpLedger."Attribute Sub Type"::RF);
                        DetailedEmpLedger.SetRange("Posting Date","Start Date","End Date");
                        DetailedEmpLedger.CALCSUMS(Amount);
                        //TotalBenefit -= DetailedEmpLedger.Amount;
                        */
                        DetailedEmpLedger.Reset;
                        DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                        DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Social Security Tax");
                        DetailedEmpLedger.SetRange("Posting Date", "Start Date", "End Date");
                        DetailedEmpLedger.SetRange(Reversed, false);
                        DetailedEmpLedger.CalcSums(Amount);
                        SST := -DetailedEmpLedger.Amount;

                        DetailedEmpLedger.Reset;
                        DetailedEmpLedger.SetRange(Reversed, false);
                        DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                        DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Tax on Remuneration & Benefits");
                        DetailedEmpLedger.SetRange("Posting Date", "Start Date", "End Date");
                        DetailedEmpLedger.CalcSums(Amount);
                        TaxonRenum := -DetailedEmpLedger.Amount;

                        EngNepDate.Reset;
                        EngNepDate.SetRange("English Date", "Start Date");
                        if EngNepDate.FindFirst then;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Pay Cycle Term", PayCycleTerm);
                        SetRange("End Date", FiscalYearStartDate, EndDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(AddressText);
                    AddressText := StrSubstNo('%1-%2, %3', "Permanent VDC", "Permanent Ward No", "Permanent District");
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter(Employee."No.", EmpNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PayCycleTerm = '' then
                    Error('Pay Cycle term must have value.');

                PGSetup.Get;

                PayCyclePeriod.Reset;
                PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                if PayCyclePeriod.FindFirst then begin
                    EngNepDate.Reset;
                    EngNepDate.SetRange("English Date", PayCyclePeriod."Start Date");
                    if EngNepDate.FindFirst then
                        FiscalYear := EngNepDate."Fiscal Year";
                    FiscalYearStartDate := PayCyclePeriod."Start Date";
                end;

                if FiscalYearStartDate < PGSetup."Payroll Fiscal Year Start Date" then
                    EndDate := PGSetup."Payroll Fiscal Year End Date"
                else begin
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                    PayCyclePeriod.SetCurrentKey("Start Date");
                    if PayCyclePeriod.FindFirst then
                        EndDate := PayCyclePeriod."End Date";
                end;
                Clear(EngNepDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Pay Cycle Term"; PayCycleTerm)
                {
                    TableRelation = "Pay Cycle Term".Term;
                    ToolTip = 'Specifies the value of the PayCycleTerm field.';
                    ApplicationArea = All;
                }
                field("Employee Filter"; EmpNo)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmpNo field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
    end;

    var
        AddressText: Text;
        PayCycleTerm: Text;
        EmpNo: Code[20];
        TotalBenefit: Decimal;
        SST: Decimal;
        TaxonRenum: Decimal;
        DetailedEmpLedger: Record "Detailed Employee Ledger Entry";
        PayCyclePeriod: Record "Pay Cycle Period";
        EngNepDate: Record "English-Nepali Date";
        FiscalYear: Text;
        Title: Label 'TDS Deposit Record';
        CompanyInfo: Record "Company Information";
        PGSetup: Record "Payroll General Setup";
        FiscalYearStartDate: Date;
        EndDate: Date;
}
