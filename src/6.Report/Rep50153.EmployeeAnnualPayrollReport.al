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
                    var
                        EmployeeQuery1: Query "Employee Ledger Query";
                    begin
                        EmployeeQuery1.SetEmpDetailFilter(Employee."No.", "Variable Field Code", StartDate, EndDate, Enum::"Attribute Type".FromInteger(AttributeType.Number));
                        EmployeeQuery1.Open();
                        if EmployeeQuery1.Read() then
                            TotalAmount := EmployeeQuery1.Amount;
                        EmployeeQuery1.Close();

                        if TotalAmount = 0 then
                            CurrReport.Skip();
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Table No.", Database::"Payroll Line");
                    end;
                }
            }
            trigger OnAfterGetRecord()
            var
                empQuery2: Query "Employee Ledger Query 2";
            begin

                Clear(TotalNonTaxableBenefit);

                DetailedEmployeeLedgerEntry[2].Reset();
                DetailedEmployeeLedgerEntry[2].SetRange("Employee No.", Employee."No.");
                if DetailedEmployeeLedgerEntry[2].IsEmpty() then
                    CurrReport.Skip();

                empQuery2.SetEmpDetailFilter(Employee."No.", StartDate, EndDate);
                empQuery2.Open();
                if empQuery2.Read() then
                    TotalNonTaxableBenefit := empQuery2.Amount;
                empQuery2.Close();
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
