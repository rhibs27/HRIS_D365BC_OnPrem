report 33019857 "Employee Salary Sheet Preview"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019857.EmployeeSalarySheetPreview.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Payroll Header"; "Payroll Header")
        {
            RequestFilterFields = "No.", "From Date", "To Date", Month, "Nepali Month", "Posting Date";
            column(No_PayrollHeader; "No.") { }
            column(FromDate_PayrollHeader; "From Date") { }
            column(ToDate_PayrollHeader; "To Date") { }
            column(Month_PayrollHeader; Month) { }
            column(Remarks_PayrollHeader; Remarks) { }
            column(GlobalDimension1Code_PayrollHeader; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code_PayrollHeader; "Global Dimension 2 Code") { }
            column(ResponsibilityCenter_PayrollHeader; "Responsibility Center") { }
            column(NoSeries_PayrollHeader; "No. Series") { }
            column(DocumentDate_PayrollHeader; "Document Date") { }
            column(PostingDate_PayrollHeader; "Posting Date") { }
            column(Status_PayrollHeader; Status) { }
            column(PostingNo_PayrollHeader; "Posting No.") { }
            column(PostingNoSeries_PayrollHeader; "Posting No. Series") { }
            column(PostingDescription_PayrollHeader; "Posting Description") { }
            column(AssignedUserID_PayrollHeader; "Assigned User ID") { }
            column(FromDateBS_PayrollHeader; "From Date (B.S)") { }
            column(ToDateBS_PayrollHeader; "To Date (B.S)") { }
            column(NepaliMonth_PayrollHeader; "Nepali Month") { }
            column(NepaliYear_PayrollHeader; "Nepali Year") { }
            column(PayCycleCode_PayrollHeader; "Pay Cycle Code") { }
            column(PayCycleTerm_PayrollHeader; "Pay Cycle Term") { }
            column(PayCyclePeriod_PayrollHeader; "Pay Cycle Period") { }
            column(CurrencyCode_PayrollHeader; "Currency Code") { }
            column(TotalNetPayable_PayrollHeader; "Total Net Payable") { }
            column(TotalDays_PayrollHeader; "Total Days") { }
            column(BankBalancingAmount_PayrollHeader; "Bank Balancing Amount") { }
            column(CompanyName; CompanyRec.Name) { }
            column(Logo; CompanyRec.Picture) { }
            column(CompanyAddress; CompanyRec.Address) { }
            dataitem("Payroll Line"; "Payroll Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Salary Level", "Salary Grade") order(descending);
                column(SN; SN) { }
                column(DimName; DimValue.Name) { }
                column(DocumentNo_PayrollLine; "Document No.") { }
                column(LineNo_PayrollLine; "Line No.") { }
                column(EmployeeNo_PayrollLine; "Employee No.") { }
                column(BasicSalary_PayrollLine; "Basic Salary") { }
                column(NetPay_PayrollLine; "Net Pay") { }
                column(TaxableIncome_PayrollLine; "Taxable Income") { }
                column(TaxforPeriod_PayrollLine; "Tax for Period") { }
                column(TotalBenefit_PayrollLine; "Assessable Income") { }
                column(TotalDeduction_PayrollLine; "Eligible RF Deduction") { }
                column(TotalEmployerContribution_PayrollLine; "Total Employer Contribution") { }
                column(TotalTaxCredit_PayrollLine; "Total Tax Credit") { }
                column(GlobalDimension1Code_PayrollLine; "Global Dimension 1 Code") { }
                column(GlobalDimension2Code_PayrollLine; "Global Dimension 2 Code") { }
                column(Remarks_PayrollLine; Remarks) { }
                column(PresentDays_PayrollLine; "Present Days") { }
                column(AbsentDays_PayrollLine; "Absent Days") { }
                column(PaidDays_PayrollLine; "Paid Days") { }
                column(LateDays_PayrollLine; "Late Days") { }
                column(WeekoffDays_PayrollLine; "Week off Days") { }
                column(LeaveDays_PayrollLine; "Leave Days") { }
                column(TourDays_PayrollLine; "Tour Days") { }
                column(HalfDays_PayrollLine; "Half Days") { }
                column(TotalDays_PayrollLine; "Total Days") { }
                column(OTHrs_PayrollLine; "OT Hrs") { }
                column(OTDays_PayrollLine; "OT Days") { }
                column(LateRate_PayrollLine; "Late Rate") { }
                column(PaidHours_PayrollLine; "Paid Hours") { }
                column(UnpaidHours_PayrollLine; "Unpaid Hours") { }
                column(TotalPresentHours_PayrollLine; "Total Present Hours") { }
                column(StandardHours_PayrollLine; "Standard Hours") { }
                column(WeekOffHours_PayrollLine; "Week Off Hours") { }
                column(LeaveHours_PayrollLine; "Leave Hours") { }
                column(EmployeeName_PayrollLine; "Employee Name") { }
                column(EmployeeType_PayrollLine; "Employee Type") { }
                column(BankAccount_PayrollLine; "Bank Name") { }
                column(BankAccountNo_PayrollLine; "Bank Account No.") { }
                column(CITNo_PayrollLine; "CIT No.") { }
                column(PFNo_PayrollLine; "PF No.") { }
                column(Division_PayrollLine; Division) { }
                column(SalaryLevel_PayrollLine; "Salary Level") { }
                column(SalaryGrade_PayrollLine; "Salary Grade") { }
                column(PanNo_PayrollLine; "Pan No.") { }
                column(EmployeeDesignation_PayrollLine; "Functional Title") { }
                column(CurrencyCode_PayrollLine; "Currency Code") { }
                column(DimensionSetID_PayrollLine; "Dimension Set ID") { }
                column(VariableField50490_PostedPayrollLine; "Variable Field 50490")
                {
                    IncludeCaption = true;
                }
                column(VariableField50491_PostedPayrollLine; "Variable Field 50491")
                {
                    IncludeCaption = true;
                }
                column(VariableField50492_PostedPayrollLine; "Variable Field 50492")
                {
                    IncludeCaption = true;
                }
                column(VariableField50493_PostedPayrollLine; "Variable Field 50493")
                {
                    IncludeCaption = true;
                }
                column(VariableField50494_PostedPayrollLine; "Variable Field 50494")
                {
                    IncludeCaption = true;
                }
                column(VariableField50495_PostedPayrollLine; "Variable Field 50495")
                {
                    IncludeCaption = true;
                }
                column(VariableField50496_PostedPayrollLine; "Variable Field 50496")
                {
                    IncludeCaption = true;
                }
                column(VariableField50497_PostedPayrollLine; "Variable Field 50497")
                {
                    IncludeCaption = true;
                }
                column(VariableField50498_PostedPayrollLine; "Variable Field 50498")
                {
                    IncludeCaption = true;
                }
                column(VariableField50499_PostedPayrollLine; "Variable Field 50499")
                {
                    IncludeCaption = true;
                }
                column(VariableField50500_PostedPayrollLine; "Variable Field 50500")
                {
                    IncludeCaption = true;
                }
                column(VariableField50501_PayrollLine; "Variable Field 50501")
                {
                    IncludeCaption = true;
                }
                column(VariableField50502_PayrollLine; "Variable Field 50502")
                {
                    IncludeCaption = true;
                }
                column(VariableField50503_PayrollLine; "Variable Field 50503")
                {
                    IncludeCaption = true;
                }
                column(VariableField50504_PayrollLine; "Variable Field 50504")
                {
                    IncludeCaption = true;
                }
                column(VariableField50505_PayrollLine; "Variable Field 50505")
                {
                    IncludeCaption = true;
                }
                column(VariableField50506_PayrollLine; "Variable Field 50506")
                {
                    IncludeCaption = true;
                }
                column(VariableField50507_PayrollLine; "Variable Field 50507")
                {
                    IncludeCaption = true;
                }
                column(VariableField50508_PayrollLine; "Variable Field 50508")
                {
                    IncludeCaption = true;
                }
                column(VariableField50509_PayrollLine; "Variable Field 50509")
                {
                    IncludeCaption = true;
                }
                column(VariableField50510_PayrollLine; "Variable Field 50510")
                {
                    IncludeCaption = true;
                }
                column(VariableField50511_PayrollLine; "Variable Field 50511")
                {
                    IncludeCaption = true;
                }
                column(VariableField50512_PayrollLine; "Variable Field 50512")
                {
                    IncludeCaption = true;
                }
                column(VariableField50513_PayrollLine; "Variable Field 50513")
                {
                    IncludeCaption = true;
                }
                column(VariableField50514_PayrollLine; "Variable Field 50514")
                {
                    IncludeCaption = true;
                }
                column(VariableField50515_PayrollLine; "Variable Field 50515")
                {
                    IncludeCaption = true;
                }
                column(VariableField50516_PayrollLine; "Variable Field 50516")
                {
                    IncludeCaption = true;
                }
                column(VariableField50517_PayrollLine; "Variable Field 50517")
                {
                    IncludeCaption = true;
                }
                column(VariableField50518_PayrollLine; "Variable Field 50518")
                {
                    IncludeCaption = true;
                }
                column(VariableField50519_PayrollLine; "Variable Field 50519")
                {
                    IncludeCaption = true;
                }
                column(VariableField50520_PayrollLine; "Variable Field 50520")
                {
                    IncludeCaption = true;
                }
                column(VariableField50521_PayrollLine; "Variable Field 50521")
                {
                    IncludeCaption = true;
                }
                column(VariableField50522_PayrollLine; "Variable Field 50522")
                {
                    IncludeCaption = true;
                }
                column(VariableField50523_PayrollLine; "Variable Field 50523")
                {
                    IncludeCaption = true;
                }
                column(VariableField50524_PayrollLine; "Variable Field 50524")
                {
                    IncludeCaption = true;
                }
                column(VariableField50525_PayrollLine; "Variable Field 50525")
                {
                    IncludeCaption = true;
                }
                column(VariableField50526_PayrollLine; "Variable Field 50526")
                {
                    IncludeCaption = true;
                }
                column(VariableField50527_PayrollLine; "Variable Field 50527")
                {
                    IncludeCaption = true;
                }
                column(VariableField50528_PayrollLine; "Variable Field 50528")
                {
                    IncludeCaption = true;
                }
                column(VariableField50529_PayrollLine; "Variable Field 50529")
                {
                    IncludeCaption = true;
                }
                column(VariableField50530_PayrollLine; "Variable Field 50530")
                {
                    IncludeCaption = true;
                }
                column(VariableField50531_PayrollLine; "Variable Field 50531")
                {
                    IncludeCaption = true;
                }
                column(VariableField50532_PayrollLine; "Variable Field 50532")
                {
                    IncludeCaption = true;
                }
                column(VariableField50533_PayrollLine; "Variable Field 50533")
                {
                    IncludeCaption = true;
                }
                column(VariableField50534_PayrollLine; "Variable Field 50534")
                {
                    IncludeCaption = true;
                }
                column(VariableField50535_PayrollLine; "Variable Field 50535")
                {
                    IncludeCaption = true;
                }
                column(VariableField50536_PayrollLine; "Variable Field 50536")
                {
                    IncludeCaption = true;
                }
                column(VariableField50537_PayrollLine; "Variable Field 50537")
                {
                    IncludeCaption = true;
                }
                column(VariableField50538_PayrollLine; "Variable Field 50538")
                {
                    IncludeCaption = true;
                }
                column(VariableField50539_PayrollLine; "Variable Field 50539")
                {
                    IncludeCaption = true;
                }
                column(VariableField50540_PayrollLine; "Variable Field 50540")
                {
                    IncludeCaption = true;
                }
                column(Field50490; Field50490Visible) { }
                column(Field50491; Field50491Visible) { }
                column(Field50492; Field50492Visible) { }
                column(Field50493; Field50493Visible) { }
                column(Field50494; Field50494Visible) { }
                column(Field50495; Field50495Visible) { }
                column(Field50496; Field50496Visible) { }
                column(Field50497; Field50497Visible) { }
                column(Field50498; Field50498Visible) { }
                column(Field50499; Field50499Visible) { }
                column(Field50500; Field50500Visible) { }
                column(Field50501; Field50501Visible) { }
                column(Field50502; Field50502Visible) { }
                column(Field50503; Field50503Visible) { }
                column(Field50504; Field50504Visible) { }
                column(Field50505; Field50505Visible) { }
                column(Field50506; Field50506Visible) { }
                column(Field50507; Field50507Visible) { }
                column(Field50508; Field50508Visible) { }
                column(Field50509; Field50509Visible) { }
                column(Field50510; Field50510Visible) { }
                column(Field50511; Field50511Visible) { }
                column(Field50512; Field50512Visible) { }
                column(Field50513; Field50513Visible) { }
                column(Field50514; Field50514Visible) { }
                column(Field50515; Field50515Visible) { }
                column(Field50516; Field50516Visible) { }
                column(Field50517; Field50517Visible) { }
                column(Field50518; Field50518Visible) { }
                column(Field50519; Field50519Visible) { }
                column(Field50520; Field50520Visible) { }
                column(Field50521; Field50521Visible) { }
                column(Field50522; Field50522Visible) { }
                column(Field50523; Field50523Visible) { }
                column(Field50524; Field50524Visible) { }
                column(Field50525; Field50525Visible) { }
                column(Field50526; Field50526Visible) { }
                column(Field50527; Field50527Visible) { }
                column(Field50528; Field50528Visible) { }
                column(Field50529; Field50529Visible) { }
                column(Field50530; Field50530Visible) { }
                column(Field50531; Field50531Visible) { }
                column(Field50532; Field50532Visible) { }
                column(Field50533; Field50533Visible) { }
                column(Field50534; Field50534Visible) { }
                column(Field50535; Field50535Visible) { }
                column(Field50536; Field50536Visible) { }
                column(Field50537; Field50537Visible) { }
                column(Field50538; Field50538Visible) { }
                column(Field50539; Field50539Visible) { }
                column(Field50540; Field50540Visible) { }

                trigger OnAfterGetRecord()
                begin
                    EmployeeRec.Reset;
                    EmployeeRec.SetRange("No.", "Employee No.");
                    EmployeeRec.FindFirst;

                    SN += 1;
                    Clear(DimValue);
                    if DimValue.Get(GLSetup."Global Dimension 2 Code", "Global Dimension 2 Code") then;
                end;
            }
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
        CompanyRec.Get;
        CompanyRec.CalcFields(Picture);
        InitColumnVisibility;
        GLSetup.Get;
    end;

    var
        PayrollEngine: Codeunit "Payroll Engine";
        Field50490Visible: Boolean;
        Field50491Visible: Boolean;
        Field50492Visible: Boolean;
        Field50493Visible: Boolean;
        Field50494Visible: Boolean;
        Field50495Visible: Boolean;
        Field50496Visible: Boolean;
        Field50497Visible: Boolean;
        Field50498Visible: Boolean;
        Field50499Visible: Boolean;
        Field50500Visible: Boolean;
        Field50501Visible: Boolean;
        Field50502Visible: Boolean;
        Field50503Visible: Boolean;
        Field50504Visible: Boolean;
        Field50505Visible: Boolean;
        Field50506Visible: Boolean;
        Field50507Visible: Boolean;
        Field50508Visible: Boolean;
        Field50509Visible: Boolean;
        Field50510Visible: Boolean;
        Field50511Visible: Boolean;
        Field50512Visible: Boolean;
        Field50513Visible: Boolean;
        Field50514Visible: Boolean;
        Field50515Visible: Boolean;
        Field50516Visible: Boolean;
        Field50517Visible: Boolean;
        Field50518Visible: Boolean;
        Field50519Visible: Boolean;
        Field50520Visible: Boolean;
        Field50521Visible: Boolean;
        Field50522Visible: Boolean;
        Field50523Visible: Boolean;
        Field50524Visible: Boolean;
        Field50525Visible: Boolean;
        Field50526Visible: Boolean;
        Field50527Visible: Boolean;
        Field50528Visible: Boolean;
        Field50529Visible: Boolean;
        Field50530Visible: Boolean;
        Field50531Visible: Boolean;
        Field50532Visible: Boolean;
        Field50533Visible: Boolean;
        Field50534Visible: Boolean;
        Field50535Visible: Boolean;
        Field50536Visible: Boolean;
        Field50537Visible: Boolean;
        Field50538Visible: Boolean;
        Field50539Visible: Boolean;
        Field50540Visible: Boolean;
        [InDataSet]
        HourCalculationVisible: Boolean;
        [InDataSet]
        TimeSheetVisible: Boolean;
        EmployeeRec: Record Employee;
        CompanyRec: Record "Company Information";
        SN: Integer;
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";

    local procedure InitColumnVisibility()
    begin
        Field50490Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50490"));
        Field50491Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50491"));
        Field50492Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50492"));
        Field50493Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50493"));
        Field50494Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50494"));
        Field50495Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50495"));
        Field50496Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50496"));
        Field50497Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50497"));
        Field50498Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50498"));
        Field50499Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50499"));
        Field50500Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50500"));

        Field50501Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50501"));
        Field50502Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50502"));
        Field50503Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50503"));
        Field50504Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50504"));
        Field50505Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50505"));
        Field50506Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50506"));
        Field50507Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50507"));
        Field50508Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50508"));
        Field50509Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50509"));
        Field50510Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50510"));
        Field50511Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50511"));
        Field50512Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50512"));
        Field50513Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50513"));
        Field50514Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50514"));
        Field50515Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50515"));
        Field50516Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50516"));
        Field50517Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50517"));
        Field50518Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50518"));
        Field50519Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50519"));
        Field50520Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50520"));
        Field50521Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50521"));
        Field50522Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50522"));
        Field50523Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50523"));
        Field50524Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50524"));
        Field50525Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50525"));
        Field50526Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50526"));
        Field50527Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50527"));
        Field50528Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50528"));
        Field50529Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50529"));
        Field50530Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50530"));
        Field50531Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50531"));
        Field50532Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50532"));
        Field50533Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50533"));
        Field50534Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50534"));
        Field50535Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50535"));
        Field50536Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50536"));
        Field50537Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50537"));
        Field50538Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50538"));
        Field50539Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50539"));
        Field50540Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50540"));
        HourCalculationVisible := PayrollEngine.IsHourCalculation;
        TimeSheetVisible := PayrollEngine.IsTimeSheetEnabled;
    end;
}
