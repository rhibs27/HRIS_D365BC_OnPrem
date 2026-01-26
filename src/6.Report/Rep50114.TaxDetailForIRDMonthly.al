report 50114 "Tax Detail For IRD Monthly"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019915.TaxDetailForIRDMonthly.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Month; Month) { }
            column(PayCycleTerm; PayCycleTerm) { }
            column(Title; Title) { }
            dataitem(Employee; Employee)
            {
                RequestFilterFields = "No.";
                column(No; "No.") { }
                column(FullName_Employee; Employee."Full Name") { }
                column(PANNo; "PAN No.") { }
                column(TdsAmountSST; TdsAmountSST) { }
                column(TdsTaxOnRenum; TdsTaxOnRenum) { }
                dataitem("Detailed Employee Ledger Entry"; "Detailed Employee Ledger Entry")
                {
                    DataItemLink = "Employee No." = field("No.");
                    DataItemTableView = where("Attribute Sub Type" = filter("Social Security Tax" | "Tax on Remuneration & Benefits"));
                    column(Amount; Amount * -1) { }
                    column(PostingDate; Format("Pay Period End Date")) { }
                    column(TDSAmt; TDSAmt) { }
                    column(TdsType; TdsType) { }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(PostingDate);
                        Clear(TdsType);
                        Clear(TDSAmt);
                        EngNepDate.Reset;
                        EngNepDate.SetRange("English Date", "Detailed Employee Ledger Entry"."Posting Date");
                        EngNepDate.FindFirst;
                        PostingDate := EngNepDate."Nepali Date";
                        PostingDate := GetIRDNepaliFormat(PostingDate);

                        if "Attribute Sub Type" = "Attribute Sub Type"::"Tax on Remuneration & Benefits" then begin
                            TDSAmt := Abs(TdsTaxOnRenum);
                            TdsType := '20'
                        end else begin
                            TDSAmt := Abs(TdsAmountSST);
                            TdsType := '33';
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Posting Date", StartDate, EndDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalAmt);
                    Clear(TdsAmountSST);
                    Clear(TdsTaxOnRenum);

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", "No.");
                    DetailedEmpLedger.SetRange("Posting Date", StartDate, EndDate);
                    DetailedEmpLedger.SetFilter("Attribute Type", '%1|%2', DetailedEmpLedger."Attribute Type"::"Basic Earning"
                                                , DetailedEmpLedger."Attribute Type"::"Other Earnings");
                    DetailedEmpLedger.SetFilter("Payroll Attribute Code", '<>%1&<>%2', 'GRATUITY', 'LEAVE ENCASH');
                    DetailedEmpLedger.CalcSums(Amount);
                    TotalAmt := DetailedEmpLedger.Amount;

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", "No.");
                    DetailedEmpLedger.SetRange("Posting Date", StartDate, EndDate);
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Social Security Tax");
                    DetailedEmpLedger.CalcSums(Amount);
                    TdsAmountSST := -DetailedEmpLedger.Amount * 100;
                    TdsTaxOnRenum := TotalAmt - TdsAmountSST;

                    /*
                    Employee.SetRange("Date Filter",StartDate,EndDate);
                    Employee.CALCFIELDS("Social Security Tax","Remuneration & Benefits Tax");
                    TdsAmountSST := Employee."Social Security Tax" * 100;
                    TdsTaxOnRenum := Employee."Remuneration & Benefits Tax";
                    */
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PayCycleTerm = '' then
                    Error('Please fill pay cycle period.');

                //IF Month = Month::" " THEN
                //ERROR('Please fill month.');

                if Month = Month::" " then begin
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                    if PayCyclePeriod.FindFirst then
                        StartDate := PayCyclePeriod."Start Date";

                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                    if PayCyclePeriod.FindLast then
                        EndDate := PayCyclePeriod."End Date";
                end else begin
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                    PayCyclePeriod.SetRange("Nepali Month", Month);
                    if PayCyclePeriod.FindFirst then
                        StartDate := PayCyclePeriod."Start Date";

                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                    PayCyclePeriod.SetRange("Nepali Month", Month);
                    if PayCyclePeriod.FindFirst then
                        EndDate := PayCyclePeriod."End Date";
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(Month; Month)
                {
                    Caption = 'Month';
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field(PayCycleTerm; PayCycleTerm)
                {
                    Caption = 'Pay Cycle Term';
                    TableRelation = "Pay Cycle Term".Term;
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        EngNepDate: Record "English-Nepali Date";
        DetailedEmpLedger: Record "Detailed Employee Ledger Entry";
        PayCycleTerm: Text;
        Month: Enum "Nepali Month";
        StartDate: Date;
        EndDate: Date;
        TotalAmt: Decimal;
        TdsAmountSST: Decimal;
        TdsTaxOnRenum: Decimal;
        PostingDate: Text;
        TdsType: Text;
        TDSAmt: Decimal;
        PayCyclePeriod: Record "Pay Cycle Period";
        Title: Label 'Tax Detail For IRD Monthly';

    local procedure GetIRDNepaliFormat(DateText: Text): Text
    var
        DateTextVar: Text;
    begin
        if StrPos(DateText, '/') <> 0 then begin
            DateTextVar := CopyStr(DateText, StrPos(DateText, '/') + 1, StrLen(DateText) - StrLen(CopyStr(DateText, 1, StrPos(DateText, '/') - 1)));
            exit(CopyStr(DateText, 1, StrPos(DateText, '/') - 1) + '.' + GetIRDNepaliFormat(DateTextVar));
        end else
            exit(DateText);
    end;
}
