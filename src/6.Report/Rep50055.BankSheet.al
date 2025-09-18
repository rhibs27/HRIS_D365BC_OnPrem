report 50055 "Bank Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019856.BankSheet.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Posted Payroll Header"; "Posted Payroll Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Nepali Month", "From Date", "To Date";
            column(CompanyName; CompanyInfo.Name) { }
            column(No_PostedPayrollHeader; "No.") { }
            column(FromDate_PostedPayrollHeader; "From Date") { }
            column(ToDate_PostedPayrollHeader; "To Date") { }
            column(Month_PostedPayrollHeader; Month) { }
            column(Remarks_PostedPayrollHeader; Remarks) { }
            column(GlobalDimension1Code_PostedPayrollHeader; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code_PostedPayrollHeader; "Global Dimension 2 Code") { }
            column(ResponsibilityCenter_PostedPayrollHeader; "Responsibility Center") { }
            column(PreAssignedNoSeries_PostedPayrollHeader; "Pre-Assigned No. Series") { }
            column(DocumentDate_PostedPayrollHeader; "Document Date") { }
            column(PostingDate_PostedPayrollHeader; "Posting Date") { }
            column(Status_PostedPayrollHeader; Status) { }
            column(PostingNo_PostedPayrollHeader; "Posting No.") { }
            column(PostingNoSeries_PostedPayrollHeader; "Posting No. Series") { }
            column(PostingDescription_PostedPayrollHeader; "Posting Description") { }
            column(AssignedUserID_PostedPayrollHeader; "Assigned User ID") { }
            column(FromDateBS_PostedPayrollHeader; "From Date (B.S)") { }
            column(ToDateBS_PostedPayrollHeader; "To Date (B.S)") { }
            column(NepaliMonth_PostedPayrollHeader; "Nepali Month") { }
            column(NepaliYear_PostedPayrollHeader; "Nepali Year") { }
            column(PayCycleCode_PostedPayrollHeader; "Pay Cycle Code") { }
            column(PayCycleTerm_PostedPayrollHeader; "Pay Cycle Term") { }
            column(PayCyclePeriod_PostedPayrollHeader; "Pay Cycle Period") { }
            column(CurrencyCode_PostedPayrollHeader; "Currency Code") { }
            column(TotalNetPayable_PostedPayrollHeader; "Total Net Payable") { }
            column(PostingUserID_PostedPayrollHeader; "Posting User ID") { }
            column(PreAssignedNo_PostedPayrollHeader; "Pre-Assigned No.") { }
            column(Reversed_PostedPayrollHeader; Reversed) { }
            column(Filters; Filters) { }
            column(Period; Period) { }
            dataitem("Posted Payroll Line"; "Posted Payroll Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Salary Level", "Salary Grade") order(descending);
                RequestFilterFields = "Employee No.", "Bank Account No.";
                column(BankName; "Bank Name") { }
                column(DocumentNo_PostedPayrollLine; "Document No.") { }
                column(LineNo_PostedPayrollLine; "Line No.") { }
                column(SolID; Employee."Sol Id") { }
                column(BankBranchName; Employee."Bank Branch No.") { }
                column(EmployeeNo_PostedPayrollLine; "Employee No.") { }
                column(BasicSalary_PostedPayrollLine; "Basic Salary") { }
                column(NetPay_PostedPayrollLine; "Net Pay") { }
                column(TaxableIncome_PostedPayrollLine; "Taxable Income After RF") { }
                column(TaxforPeriod_PostedPayrollLine; "Tax for Period") { }
                column(TotalBenefit_PostedPayrollLine; "Assessable Income") { }
                column(TotalDeduction_PostedPayrollLine; "Eligible RF Deduction") { }
                column(TotalEmployerContribution_PostedPayrollLine; "Total Employer Contribution") { }
                column(TotalTaxCredit_PostedPayrollLine; "Total Tax Credit") { }
                column(GlobalDimension1Code_PostedPayrollLine; "Global Dimension 1 Code") { }
                column(GlobalDimension2Code_PostedPayrollLine; "Global Dimension 2 Code") { }
                column(Remarks_PostedPayrollLine; Remarks) { }
                column(PresentDays_PostedPayrollLine; "Present Days") { }
                column(AbsentDays_PostedPayrollLine; "Absent Days") { }
                column(PaidDays_PostedPayrollLine; "Paid Days") { }
                column(LateDays_PostedPayrollLine; "Late Days") { }
                column(WeekoffDays_PostedPayrollLine; "Week off Days") { }
                column(LeaveDays_PostedPayrollLine; "Leave Days") { }
                column(TourDays_PostedPayrollLine; "Tour Days") { }
                column(HalfDays_PostedPayrollLine; "Half Days") { }
                column(TotalDays_PostedPayrollLine; "Total Days") { }
                column(OTHrs_PostedPayrollLine; "OT Hrs") { }
                column(OTDays_PostedPayrollLine; "OT Days") { }
                column(LateRate_PostedPayrollLine; "Late Rate") { }
                column(PaidHours_PostedPayrollLine; "Paid Hours") { }
                column(UnpaidHours_PostedPayrollLine; "Unpaid Hours") { }
                column(TotalPresentHours_PostedPayrollLine; "Total Present Hours") { }
                column(StandardHours_PostedPayrollLine; "Standard Hours") { }
                column(WeekOffHours_PostedPayrollLine; "Week Off Hours") { }
                column(LeaveHours_PostedPayrollLine; "Leave Hours") { }
                column(EmployeeName_PostedPayrollLine; "Employee Name") { }
                column(EmployeeType_PostedPayrollLine; "Employee Type") { }
                column(BankAccount_PostedPayrollLine; "Bank Account No.") { }
                column(CITNo_PostedPayrollLine; "CIT No.") { }
                column(PFNo_PostedPayrollLine; "PF No.") { }
                column(Division_PostedPayrollLine; Division) { }
                column(SalaryLevel_PostedPayrollLine; "Salary Level") { }
                column(SalaryGrade_PostedPayrollLine; "Salary Grade") { }
                column(PanNo_PostedPayrollLine; "Pan No.") { }
                column(EmployeeDesignation_PostedPayrollLine; "Posted Payroll Line"."Functional Title") { }
                column(BankAccountNo_PostedPayrollLine; "Bank Account No.") { }
                column(CurrencyCode_PostedPayrollLine; "Currency Code") { }
                column(PostingDate_PostedPayrollLine; "Posting Date") { }
                column(DimensionSetID_PostedPayrollLine; "Dimension Set ID") { }
                column(Reversed_PostedPayrollLine; Reversed) { }
                column(VariableField50501_PostedPayrollLine; "Variable Field 50501") { }
                column(VariableField50502_PostedPayrollLine; "Variable Field 50502") { }
                column(VariableField50503_PostedPayrollLine; "Variable Field 50503") { }
                column(VariableField50504_PostedPayrollLine; "Variable Field 50504") { }
                column(VariableField50505_PostedPayrollLine; "Variable Field 50505") { }
                column(VariableField50506_PostedPayrollLine; "Variable Field 50506") { }
                column(VariableField50507_PostedPayrollLine; "Variable Field 50507") { }
                column(VariableField50508_PostedPayrollLine; "Variable Field 50508") { }
                column(VariableField50509_PostedPayrollLine; "Variable Field 50509") { }
                column(VariableField50510_PostedPayrollLine; "Variable Field 50510") { }
                column(VariableField50511_PostedPayrollLine; "Variable Field 50511") { }
                column(VariableField50512_PostedPayrollLine; "Variable Field 50512") { }
                column(VariableField50513_PostedPayrollLine; "Variable Field 50513") { }
                column(VariableField50514_PostedPayrollLine; "Variable Field 50514") { }
                column(VariableField50515_PostedPayrollLine; "Variable Field 50515") { }
                column(VariableField50516_PostedPayrollLine; "Variable Field 50516") { }
                column(VariableField50517_PostedPayrollLine; "Variable Field 50517") { }
                column(VariableField50518_PostedPayrollLine; "Variable Field 50518") { }
                column(VariableField50519_PostedPayrollLine; "Variable Field 50519") { }
                column(VariableField50520_PostedPayrollLine; "Variable Field 50520") { }
                column(VariableField50521_PostedPayrollLine; "Variable Field 50521") { }
                column(VariableField50522_PostedPayrollLine; "Variable Field 50522") { }
                column(VariableField50523_PostedPayrollLine; "Variable Field 50523") { }
                column(VariableField50524_PostedPayrollLine; "Variable Field 50524") { }
                column(VariableField50525_PostedPayrollLine; "Variable Field 50525") { }
                column(VariableField50526_PostedPayrollLine; "Variable Field 50526") { }
                column(VariableField50527_PostedPayrollLine; "Variable Field 50527") { }
                column(VariableField50528_PostedPayrollLine; "Variable Field 50528") { }
                column(VariableField50529_PostedPayrollLine; "Variable Field 50529") { }
                column(VariableField50530_PostedPayrollLine; "Variable Field 50530") { }
                column(VariableField50531_PostedPayrollLine; "Variable Field 50531") { }
                column(VariableField50532_PostedPayrollLine; "Variable Field 50532") { }
                column(VariableField50533_PostedPayrollLine; "Variable Field 50533") { }
                column(VariableField50534_PostedPayrollLine; "Variable Field 50534") { }
                column(VariableField50535_PostedPayrollLine; "Variable Field 50535") { }
                column(VariableField50536_PostedPayrollLine; "Variable Field 50536") { }
                column(VariableField50537_PostedPayrollLine; "Variable Field 50537") { }
                column(VariableField50538_PostedPayrollLine; "Variable Field 50538") { }
                column(VariableField50539_PostedPayrollLine; "Variable Field 50539") { }
                column(VariableField50540_PostedPayrollLine; "Variable Field 50540") { }

                trigger OnAfterGetRecord()
                begin
                    Employee.Get("Employee No.");
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Bank Account No.", '<>%1', '');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Period := 'Period: ' + Format("Nepali Month") + ', '
                          + Format("Nepali Year") + ' ('
                          + Format("From Date") + ' to '
                          + Format("To Date") + ')';
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        Filters := "Posted Payroll Header".GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        Filters: Text;
        Period: Text;
        Employee: Record Employee;
}
