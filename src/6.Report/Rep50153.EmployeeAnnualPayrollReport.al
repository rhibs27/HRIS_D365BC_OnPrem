report 50153 "Employee Annual Payroll Report"
{
    ApplicationArea = All;
    Caption = 'Employee Annual Payroll Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50153.EmployeeAnnualPayrollReport.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(ComInfoName; ComInfo.Name) { }
            column(ComInfoPic; ComInfo.Picture) { }
            column(ComInfoAddr; ComInfo.Address) { }
            column(ComInfoPh; ComInfo."Phone No.") { }
            column(Date_Filter; 'Date Filter : ' + Format(StartDate) + '..' + Format(EndDate)) { }
            column(No_; "No.") { }
            column(FullName; FullName) { }
            column(Job_Title; "Job Title") { }
            column(Tax_Code; "Tax Code") { }
            column(TotalNonTaxableBenefit; TotalNonTaxableBenefit) { }
            column(SumTotalNonTaxableBenefit; SumTotalNonTaxableBenefit) { }
            dataitem(AttributeType; Integer)
            {
                DataItemTableView = where(Number = filter(0 .. 5));
                column(AttributeTypeCode; Enum::"Attribute Type".FromInteger(AttributeType.Number)) { }
                dataitem("Payroll Column Configuration"; "Payroll Column Configuration")
                {
                    column(Variable_Field_Code; "Variable Field Code") { }
                    column(Field_No_; "Field No.") { }
                    column(TotalAmount; TotalAmount) { }
                    trigger OnAfterGetRecord()
                    begin
                        DetailedEmployeeLedgerEntry[2].SetLoadFields(Amount);
                        DetailedEmployeeLedgerEntry[1].Reset();
                        DetailedEmployeeLedgerEntry[1].SetRange("Employee No.", Employee."No.");
                        DetailedEmployeeLedgerEntry[1].SetRange("Payroll Attribute Code", "Payroll Column Configuration"."Variable Field Code");
                        DetailedEmployeeLedgerEntry[1].SetRange("Posting Date", StartDate, EndDate);
                        DetailedEmployeeLedgerEntry[1].SetRange("Attribute Type", AttributeType.Number);
                        DetailedEmployeeLedgerEntry[1].CalcSums(Amount);
                        TotalAmount := DetailedEmployeeLedgerEntry[1].Amount;

                        if DetailedEmployeeLedgerEntry[1].IsEmpty() then
                            CurrReport.Skip();

                        if (TotalAmount = 0) and TotalNonTaxableBenefitBoolean then
                            CurrReport.Skip();
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Table No.", Database::"Payroll Line");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(TotalNonTaxableBenefit);
                DetailedEmployeeLedgerEntry[2].Reset();
                DetailedEmployeeLedgerEntry[2].SetRange("Employee No.", Employee."No.");
                if DetailedEmployeeLedgerEntry[2].IsEmpty() then
                    CurrReport.Skip();

                DetailedEmployeeLedgerEntry[2].Reset();
                DetailedEmployeeLedgerEntry[2].SetRange("Employee No.", Employee."No.");
                DetailedEmployeeLedgerEntry[2].SetRange(Reversed, false);
                if DetailedEmployeeLedgerEntry[2].IsEmpty() then
                    CurrReport.Skip();

                DetailedEmployeeLedgerEntry[2].SetLoadFields(Amount);
                DetailedEmployeeLedgerEntry[2].Reset();
                DetailedEmployeeLedgerEntry[2].SetRange("Employee No.", Employee."No.");
                DetailedEmployeeLedgerEntry[2].SetRange("Posting Date", StartDate, EndDate);
                DetailedEmployeeLedgerEntry[2].SetRange("Non-Taxable", true);
                DetailedEmployeeLedgerEntry[2].CalcSums(Amount);
                TotalNonTaxableBenefit := DetailedEmployeeLedgerEntry[2].Amount;
                SumTotalNonTaxableBenefit += TotalNonTaxableBenefit;

                if TotalNonTaxableBenefit = 0 then
                    TotalNonTaxableBenefitBoolean := false
                else
                    TotalNonTaxableBenefitBoolean := true;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                    field(PayCycleTermCode; PayCycleTermCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Pay Cycle Term';
                        TableRelation = "Pay Cycle Term".Term;
                    }
                }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }
    trigger OnPreReport()
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);

        if PayCycleTermCode <> '' then begin
            if (StartDate <> 0D) or (EndDate <> 0D) then
                Message('When filtering by Pay Cycle Term, Start Date and End Date will be reset.');
            PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTermCode);
            if (PayCyclePeriod.FindFirst()) and (PayCyclePeriod."Start Date" <> 0D) then
                StartDate := PayCyclePeriod."Start Date";
            if (PayCyclePeriod.FindLast()) and (PayCyclePeriod."End Date" <> 0D) then
                EndDate := PayCyclePeriod."End Date";
        end;
    end;

    var
        ComInfo: Record "Company Information";
        CompanyInformation: Record "Company Information";
        PayCycleTermCode: Code[20];
        DetailedEmployeeLedgerEntry: array[2] of Record "Detailed Employee Ledger Entry";
        TotalAmount: Decimal;
        StartDate, EndDate : Date;
        TotalNonTaxableBenefit, SumTotalNonTaxableBenefit : Decimal;
        TotalNonTaxableBenefitBoolean: Boolean;
}
