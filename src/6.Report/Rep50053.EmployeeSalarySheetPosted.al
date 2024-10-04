report 50053 "Employee Salary Sheet Posted"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019854.EmployeeSalarySheetPosted.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Posted Payroll Header"; "Posted Payroll Header")
        {
            RequestFilterFields = "No.", "From Date", "To Date", Month, "Nepali Month", "Posting Date";
            column(No_PostedPayrollHeader; "No.") { }
            column(FromDate_PostedPayrollHeader; "From Date") { }
            column(ToDate_PostedPayrollHeader; "To Date") { }
            column(Month_PostedPayrollHeader; Month) { }
            column(Remarks_PostedPayrollHeader; Remarks) { }
            column(GlobalDimension1Code_PostedPayrollHeader; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code_PostedPayrollHeader; "Global Dimension 2 Code") { }
            column(ResponsibilityCenter_PostedPayrollHeader; "Responsibility Center") { }
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
            column(CompanyName; CompanyRec.Name) { }
            column(CompanyAddress; CompanyRec.Address) { }
            column(Logo; CompanyRec.Picture) { }
            dataitem("Posted Payroll Line"; "Posted Payroll Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Salary Level", "Salary Grade") order(descending);
                column(SN; SN) { }
                column(EmployeeName_PostedPayrollLine; "Employee Name") { }
                column(EmployeeType_PostedPayrollLine; "Employee Type") { }
                column(BankName_PostedPayrollLine; "Bank Name") { }
                column(BankAccountNo_PostedPayrollLine; "Bank Account No.") { }
                column(CITNo_PostedPayrollLine; "CIT No.") { }
                column(PFNo_PostedPayrollLine; "PF No.") { }
                column(Division_PostedPayrollLine; Division) { }
                column(SalaryLevel_PostedPayrollLine; "Salary Level") { }
                column(SalaryGrade_PostedPayrollLine; "Salary Grade") { }
                column(PanNo_PostedPayrollLine; "Pan No.") { }
                column(DocumentNo_PostedPayrollLine; "Document No.") { }
                column(LineNo_PostedPayrollLine; "Line No.") { }
                column(EmployeeNo_PostedPayrollLine; "Employee No.") { }
                column(BasicSalary_PostedPayrollLine; "Basic Salary") { }
                column(NetPay_PostedPayrollLine; "Net Pay") { }
                column(TaxableIncome_PostedPayrollLine; "Taxable Income") { }
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
                column(CurrencyCode_PostedPayrollLine; "Currency Code") { }
                column(PostingDate_PostedPayrollLine; "Posting Date") { }
                column(DimensionSetID_PostedPayrollLine; "Dimension Set ID") { }
                column(Reversed_PostedPayrollLine; Reversed) { }
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
                column(VariableField50501_PostedPayrollLine; "Variable Field 50501")
                {
                    IncludeCaption = true;
                }
                column(VariableField50502_PostedPayrollLine; "Variable Field 50502")
                {
                    IncludeCaption = true;
                }
                column(VariableField50503_PostedPayrollLine; "Variable Field 50503")
                {
                    IncludeCaption = true;
                }
                column(VariableField50504_PostedPayrollLine; "Variable Field 50504")
                {
                    IncludeCaption = true;
                }
                column(VariableField50505_PostedPayrollLine; "Variable Field 50505")
                {
                    IncludeCaption = true;
                }
                column(VariableField50506_PostedPayrollLine; "Variable Field 50506")
                {
                    IncludeCaption = true;
                }
                column(VariableField50507_PostedPayrollLine; "Variable Field 50507")
                {
                    IncludeCaption = true;
                }
                column(VariableField50508_PostedPayrollLine; "Variable Field 50508")
                {
                    IncludeCaption = true;
                }
                column(VariableField50509_PostedPayrollLine; "Variable Field 50509")
                {
                    IncludeCaption = true;
                }
                column(VariableField50510_PostedPayrollLine; "Variable Field 50510")
                {
                    IncludeCaption = true;
                }
                column(VariableField50511_PostedPayrollLine; "Variable Field 50511")
                {
                    IncludeCaption = true;
                }
                column(VariableField50512_PostedPayrollLine; "Variable Field 50512")
                {
                    IncludeCaption = true;
                }
                column(VariableField50513_PostedPayrollLine; "Variable Field 50513")
                {
                    IncludeCaption = true;
                }
                column(VariableField50514_PostedPayrollLine; "Variable Field 50514")
                {
                    IncludeCaption = true;
                }
                column(VariableField50515_PostedPayrollLine; "Variable Field 50515")
                {
                    IncludeCaption = true;
                }
                column(VariableField50516_PostedPayrollLine; "Variable Field 50516")
                {
                    IncludeCaption = true;
                }
                column(VariableField50517_PostedPayrollLine; "Variable Field 50517")
                {
                    IncludeCaption = true;
                }
                column(VariableField50518_PostedPayrollLine; "Variable Field 50518")
                {
                    IncludeCaption = true;
                }
                column(VariableField50519_PostedPayrollLine; "Variable Field 50519")
                {
                    IncludeCaption = true;
                }
                column(VariableField50520_PostedPayrollLine; "Variable Field 50520")
                {
                    IncludeCaption = true;
                }
                column(VariableField50521_PostedPayrollLine; "Variable Field 50521")
                {
                    IncludeCaption = true;
                }
                column(VariableField50522_PostedPayrollLine; "Variable Field 50522")
                {
                    IncludeCaption = true;
                }
                column(VariableField50523_PostedPayrollLine; "Variable Field 50523")
                {
                    IncludeCaption = true;
                }
                column(VariableField50524_PostedPayrollLine; "Variable Field 50524")
                {
                    IncludeCaption = true;
                }
                column(VariableField50525_PostedPayrollLine; "Variable Field 50525")
                {
                    IncludeCaption = true;
                }
                column(VariableField50526_PostedPayrollLine; "Variable Field 50526")
                {
                    IncludeCaption = true;
                }
                column(VariableField50527_PostedPayrollLine; "Variable Field 50527")
                {
                    IncludeCaption = true;
                }
                column(VariableField50528_PostedPayrollLine; "Variable Field 50528")
                {
                    IncludeCaption = true;
                }
                column(VariableField50529_PostedPayrollLine; "Variable Field 50529")
                {
                    IncludeCaption = true;
                }
                column(VariableField50530_PostedPayrollLine; "Variable Field 50530")
                {
                    IncludeCaption = true;
                }
                column(VariableField50531_PostedPayrollLine; "Variable Field 50531")
                {
                    IncludeCaption = true;
                }
                column(VariableField50532_PostedPayrollLine; "Variable Field 50532")
                {
                    IncludeCaption = true;
                }
                column(VariableField50533_PostedPayrollLine; "Variable Field 50533")
                {
                    IncludeCaption = true;
                }
                column(VariableField50534_PostedPayrollLine; "Variable Field 50534")
                {
                    IncludeCaption = true;
                }
                column(VariableField50535_PostedPayrollLine; "Variable Field 50535")
                {
                    IncludeCaption = true;
                }
                column(VariableField50536_PostedPayrollLine; "Variable Field 50536")
                {
                    IncludeCaption = true;
                }
                column(VariableField50537_PostedPayrollLine; "Variable Field 50537")
                {
                    IncludeCaption = true;
                }
                column(VariableField50538_PostedPayrollLine; "Variable Field 50538")
                {
                    IncludeCaption = true;
                }
                column(VariableField50539_PostedPayrollLine; "Variable Field 50539")
                {
                    IncludeCaption = true;
                }
                column(VariableField50540_PostedPayrollLine; "Variable Field 50540")
                {
                    IncludeCaption = true;
                }
                column(BranchName; DimValue.Name) { }
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
                    Clear(DimValue);
                    if DimValue.Get(GLSetup."Global Dimension 2 Code", EmployeeRec."Global Dimension 2 Code") then;

                    SN += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SN := 0;
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
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";

    local procedure InitColumnVisibility()
    begin
        Field50490Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50490"));
        Field50491Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50491"));
        Field50492Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50492"));
        Field50493Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50493"));
        Field50494Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50494"));
        Field50495Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50495"));
        Field50496Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50496"));
        Field50497Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50497"));
        Field50498Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50498"));
        Field50499Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50499"));
        Field50500Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50500"));

        Field50501Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50501"));
        Field50502Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50502"));
        Field50503Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50503"));
        Field50504Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50504"));
        Field50505Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50505"));
        Field50506Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50506"));
        Field50507Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50507"));
        Field50508Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50508"));
        Field50509Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50509"));
        Field50510Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50510"));
        Field50511Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50511"));
        Field50512Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50512"));
        Field50513Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50513"));
        Field50514Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50514"));
        Field50515Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50515"));
        Field50516Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50516"));
        Field50517Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50517"));
        Field50518Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50518"));
        Field50519Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50519"));
        Field50520Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50520"));
        Field50521Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50521"));
        Field50522Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50522"));
        Field50523Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50523"));
        Field50524Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50524"));
        Field50525Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50525"));
        Field50526Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50526"));
        Field50527Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50527"));
        Field50528Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50528"));
        Field50529Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50529"));
        Field50530Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50530"));
        Field50531Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50531"));
        Field50532Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50532"));
        Field50533Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50533"));
        Field50534Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50534"));
        Field50535Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50535"));
        Field50536Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50536"));
        Field50537Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50537"));
        Field50538Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50538"));
        Field50539Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50539"));
        Field50540Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Posted Payroll Line".FieldNo("Variable Field 50540"));
        HourCalculationVisible := PayrollEngine.IsHourCalculation;
        TimeSheetVisible := PayrollEngine.IsTimeSheetEnabled;
    end;
}
