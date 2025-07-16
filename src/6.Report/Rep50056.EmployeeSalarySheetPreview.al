report 50056 "Employee Salary Sheet Preview"
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
                // column(VariableField50490_PostedPayrollLine; "Variable Field 50490")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50491_PostedPayrollLine; "Variable Field 50491")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50492_PostedPayrollLine; "Variable Field 50492")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50493_PostedPayrollLine; "Variable Field 50493")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50494_PostedPayrollLine; "Variable Field 50494")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50495_PostedPayrollLine; "Variable Field 50495")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50496_PostedPayrollLine; "Variable Field 50496")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50497_PostedPayrollLine; "Variable Field 50497")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50498_PostedPayrollLine; "Variable Field 50498")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50499_PostedPayrollLine; "Variable Field 50499")
                // {
                //     IncludeCaption = true;
                // }
                // column(VariableField50500_PostedPayrollLine; "Variable Field 50500")
                // {
                //     IncludeCaption = true;
                // }
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
                column(VariableField50541_PayrollLine; "Variable Field 50541")
                {
                    IncludeCaption = true;
                }
                column(VariableField50542_PayrollLine; "Variable Field 50542")
                {
                    IncludeCaption = true;
                }
                column(VariableField50543_PayrollLine; "Variable Field 50543")
                {
                    IncludeCaption = true;
                }
                column(VariableField50544_PayrollLine; "Variable Field 50544")
                {
                    IncludeCaption = true;
                }
                column(VariableField50545_PayrollLine; "Variable Field 50545")
                {
                    IncludeCaption = true;
                }
                column(VariableField50546_PayrollLine; "Variable Field 50546")
                {
                    IncludeCaption = true;
                }
                column(VariableField50547_PayrollLine; "Variable Field 50547")
                {
                    IncludeCaption = true;
                }
                column(VariableField50548_PayrollLine; "Variable Field 50548")
                {
                    IncludeCaption = true;
                }
                column(VariableField50549_PayrollLine; "Variable Field 50549")
                {
                    IncludeCaption = true;
                }
                column(VariableField50550_PayrollLine; "Variable Field 50550")
                {
                    IncludeCaption = true;
                }
                column(VariableField50551_PayrollLine; "Variable Field 50551")
                {
                    IncludeCaption = true;
                }
                column(VariableField50552_PayrollLine; "Variable Field 50552")
                {
                    IncludeCaption = true;
                }
                column(VariableField50553_PayrollLine; "Variable Field 50553")
                {
                    IncludeCaption = true;
                }
                column(VariableField50554_PayrollLine; "Variable Field 50554")
                {
                    IncludeCaption = true;
                }
                column(VariableField50555_PayrollLine; "Variable Field 50555")
                {
                    IncludeCaption = true;
                }
                column(VariableField50556_PayrollLine; "Variable Field 50556")
                {
                    IncludeCaption = true;
                }
                column(VariableField50557_PayrollLine; "Variable Field 50557")
                {
                    IncludeCaption = true;
                }
                column(VariableField50558_PayrollLine; "Variable Field 50558")
                {
                    IncludeCaption = true;
                }
                column(VariableField50559_PayrollLine; "Variable Field 50559")
                {
                    IncludeCaption = true;
                }
                column(VariableField50560_PayrollLine; "Variable Field 50560")
                {
                    IncludeCaption = true;
                }
                column(VariableField50561_PayrollLine; "Variable Field 50561")
                {
                    IncludeCaption = true;
                }
                column(VariableField50562_PayrollLine; "Variable Field 50562")
                {
                    IncludeCaption = true;
                }
                column(VariableField50563_PayrollLine; "Variable Field 50563")
                {
                    IncludeCaption = true;
                }
                column(VariableField50564_PayrollLine; "Variable Field 50564")
                {
                    IncludeCaption = true;
                }
                column(VariableField50565_PayrollLine; "Variable Field 50565")
                {
                    IncludeCaption = true;
                }
                column(VariableField50566_PayrollLine; "Variable Field 50566")
                {
                    IncludeCaption = true;
                }
                column(VariableField50567_PayrollLine; "Variable Field 50567")
                {
                    IncludeCaption = true;
                }
                column(VariableField50568_PayrollLine; "Variable Field 50568")
                {
                    IncludeCaption = true;
                }
                column(VariableField50569_PayrollLine; "Variable Field 50569")
                {
                    IncludeCaption = true;
                }
                column(VariableField50570_PayrollLine; "Variable Field 50570")
                {
                    IncludeCaption = true;
                }
                column(VariableField50571_PayrollLine; "Variable Field 50571")
                {
                    IncludeCaption = true;
                }
                column(VariableField50572_PayrollLine; "Variable Field 50572")
                {
                    IncludeCaption = true;
                }
                column(VariableField50573_PayrollLine; "Variable Field 50573")
                {
                    IncludeCaption = true;
                }
                column(VariableField50574_PayrollLine; "Variable Field 50574")
                {
                    IncludeCaption = true;
                }
                column(VariableField50575_PayrollLine; "Variable Field 50575")
                {
                    IncludeCaption = true;
                }
                column(VariableField50576_PayrollLine; "Variable Field 50576")
                {
                    IncludeCaption = true;
                }
                column(VariableField50577_PayrollLine; "Variable Field 50577")
                {
                    IncludeCaption = true;
                }
                column(VariableField50578_PayrollLine; "Variable Field 50578")
                {
                    IncludeCaption = true;
                }
                column(VariableField50579_PayrollLine; "Variable Field 50579")
                {
                    IncludeCaption = true;
                }
                column(VariableField50580_PayrollLine; "Variable Field 50580")
                {
                    IncludeCaption = true;
                }
                column(VariableField50581_PayrollLine; "Variable Field 50581")
                {
                    IncludeCaption = true;
                }
                column(VariableField50582_PayrollLine; "Variable Field 50582")
                {
                    IncludeCaption = true;
                }
                column(VariableField50583_PayrollLine; "Variable Field 50583")
                {
                    IncludeCaption = true;
                }
                column(VariableField50584_PayrollLine; "Variable Field 50584")
                {
                    IncludeCaption = true;
                }
                column(VariableField50585_PayrollLine; "Variable Field 50585")
                {
                    IncludeCaption = true;
                }
                column(VariableField50586_PayrollLine; "Variable Field 50586")
                {
                    IncludeCaption = true;
                }
                column(VariableField50587_PayrollLine; "Variable Field 50587")
                {
                    IncludeCaption = true;
                }
                column(VariableField50588_PayrollLine; "Variable Field 50588")
                {
                    IncludeCaption = true;
                }
                column(VariableField50589_PayrollLine; "Variable Field 50589")
                {
                    IncludeCaption = true;
                }
                column(VariableField50590_PayrollLine; "Variable Field 50590")
                {
                    IncludeCaption = true;
                }
                column(VariableField50591_PayrollLine; "Variable Field 50591")
                {
                    IncludeCaption = true;
                }
                column(VariableField50592_PayrollLine; "Variable Field 50592")
                {
                    IncludeCaption = true;
                }
                column(VariableField50593_PayrollLine; "Variable Field 50593")
                {
                    IncludeCaption = true;
                }
                column(VariableField50594_PayrollLine; "Variable Field 50594")
                {
                    IncludeCaption = true;
                }
                column(VariableField50595_PayrollLine; "Variable Field 50595")
                {
                    IncludeCaption = true;
                }
                column(VariableField50596_PayrollLine; "Variable Field 50596")
                {
                    IncludeCaption = true;
                }
                column(VariableField50597_PayrollLine; "Variable Field 50597")
                {
                    IncludeCaption = true;
                }
                column(VariableField50598_PayrollLine; "Variable Field 50598")
                {
                    IncludeCaption = true;
                }
                column(VariableField50599_PayrollLine; "Variable Field 50599")
                {
                    IncludeCaption = true;
                }
                column(VariableField50600_PayrollLine; "Variable Field 50600")
                {
                    IncludeCaption = true;
                }
                column(VariableField50601_PayrollLine; "Variable Field 50601")
                {
                    IncludeCaption = true;
                }
                column(VariableField50602_PayrollLine; "Variable Field 50602")
                {
                    IncludeCaption = true;
                }
                column(VariableField50603_PayrollLine; "Variable Field 50603")
                {
                    IncludeCaption = true;
                }
                column(VariableField50604_PayrollLine; "Variable Field 50604")
                {
                    IncludeCaption = true;
                }
                column(VariableField50605_PayrollLine; "Variable Field 50605")
                {
                    IncludeCaption = true;
                }
                column(VariableField50606_PayrollLine; "Variable Field 50606")
                {
                    IncludeCaption = true;
                }
                column(VariableField50607_PayrollLine; "Variable Field 50607")
                {
                    IncludeCaption = true;
                }
                column(VariableField50608_PayrollLine; "Variable Field 50608")
                {
                    IncludeCaption = true;
                }
                column(VariableField50609_PayrollLine; "Variable Field 50609")
                {
                    IncludeCaption = true;
                }
                column(VariableField50610_PayrollLine; "Variable Field 50610")
                {
                    IncludeCaption = true;
                }
                column(VariableField50611_PayrollLine; "Variable Field 50611")
                {
                    IncludeCaption = true;
                }
                column(VariableField50612_PayrollLine; "Variable Field 50612")
                {
                    IncludeCaption = true;
                }
                column(VariableField50613_PayrollLine; "Variable Field 50613")
                {
                    IncludeCaption = true;
                }
                column(VariableField50614_PayrollLine; "Variable Field 50614")
                {
                    IncludeCaption = true;
                }
                column(VariableField50615_PayrollLine; "Variable Field 50615")
                {
                    IncludeCaption = true;
                }
                column(VariableField50616_PayrollLine; "Variable Field 50616")
                {
                    IncludeCaption = true;
                }
                column(VariableField50617_PayrollLine; "Variable Field 50617")
                {
                    IncludeCaption = true;
                }
                column(VariableField50618_PayrollLine; "Variable Field 50618")
                {
                    IncludeCaption = true;
                }
                column(VariableField50619_PayrollLine; "Variable Field 50619")
                {
                    IncludeCaption = true;
                }
                column(VariableField50620_PayrollLine; "Variable Field 50620")
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
                column(Field50541; Field50541Visible) { }
                column(Field50542; Field50542Visible) { }
                column(Field50543; Field50543Visible) { }
                column(Field50544; Field50544Visible) { }
                column(Field50545; Field50545Visible) { }
                column(Field50546; Field50546Visible) { }
                column(Field50547; Field50547Visible) { }
                column(Field50548; Field50548Visible) { }
                column(Field50549; Field50549Visible) { }
                column(Field50550; Field50550Visible) { }
                column(Field50551; Field50551Visible) { }
                column(Field50552; Field50552Visible) { }
                column(Field50553; Field50553Visible) { }
                column(Field50554; Field50554Visible) { }
                column(Field50555; Field50555Visible) { }
                column(Field50556; Field50556Visible) { }
                column(Field50557; Field50557Visible) { }
                column(Field50558; Field50558Visible) { }
                column(Field50559; Field50559Visible) { }
                column(Field50560; Field50560Visible) { }
                column(Field50561; Field50561Visible) { }
                column(Field50562; Field50562Visible) { }
                column(Field50563; Field50563Visible) { }
                column(Field50564; Field50564Visible) { }
                column(Field50565; Field50565Visible) { }
                column(Field50566; Field50566Visible) { }
                column(Field50567; Field50567Visible) { }
                column(Field50568; Field50568Visible) { }
                column(Field50569; Field50569Visible) { }
                column(Field50570; Field50570Visible) { }
                column(Field50571; Field50571Visible) { }
                column(Field50572; Field50572Visible) { }
                column(Field50573; Field50573Visible) { }
                column(Field50574; Field50574Visible) { }
                column(Field50575; Field50575Visible) { }
                column(Field50576; Field50576Visible) { }
                column(Field50577; Field50577Visible) { }
                column(Field50578; Field50578Visible) { }
                column(Field50579; Field50579Visible) { }
                column(Field50580; Field50580Visible) { }
                column(Field50581; Field50581Visible) { }
                column(Field50582; Field50582Visible) { }
                column(Field50583; Field50583Visible) { }
                column(Field50584; Field50584Visible) { }
                column(Field50585; Field50585Visible) { }
                column(Field50586; Field50586Visible) { }
                column(Field50587; Field50587Visible) { }
                column(Field50588; Field50588Visible) { }
                column(Field50589; Field50589Visible) { }
                column(Field50590; Field50590Visible) { }
                column(Field50591; Field50591Visible) { }
                column(Field50592; Field50592Visible) { }
                column(Field50593; Field50593Visible) { }
                column(Field50594; Field50594Visible) { }
                column(Field50595; Field50595Visible) { }
                column(Field50596; Field50596Visible) { }
                column(Field50597; Field50597Visible) { }
                column(Field50598; Field50598Visible) { }
                column(Field50599; Field50599Visible) { }
                column(Field50600; Field50600Visible) { }
                column(Field50601; Field50601Visible) { }
                column(Field50602; Field50602Visible) { }
                column(Field50603; Field50603Visible) { }
                column(Field50604; Field50604Visible) { }
                column(Field50605; Field50605Visible) { }
                column(Field50606; Field50606Visible) { }
                column(Field50607; Field50607Visible) { }
                column(Field50608; Field50608Visible) { }
                column(Field50609; Field50609Visible) { }
                column(Field50610; Field50610Visible) { }
                column(Field50611; Field50611Visible) { }
                column(Field50612; Field50612Visible) { }
                column(Field50613; Field50613Visible) { }
                column(Field50614; Field50614Visible) { }
                column(Field50615; Field50615Visible) { }
                column(Field50616; Field50616Visible) { }
                column(Field50617; Field50617Visible) { }
                column(Field50618; Field50618Visible) { }
                column(Field50619; Field50619Visible) { }
                column(Field50620; Field50620Visible) { }


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
        Field50541Visible: Boolean;
        Field50542Visible: Boolean;
        Field50543Visible: Boolean;
        Field50544Visible: Boolean;
        Field50545Visible: Boolean;
        Field50546Visible: Boolean;
        Field50547Visible: Boolean;
        Field50548Visible: Boolean;
        Field50549Visible: Boolean;
        Field50550Visible: Boolean;
        Field50551Visible: Boolean;
        Field50552Visible: Boolean;
        Field50553Visible: Boolean;
        Field50554Visible: Boolean;
        Field50555Visible: Boolean;
        Field50556Visible: Boolean;
        Field50557Visible: Boolean;
        Field50558Visible: Boolean;
        Field50559Visible: Boolean;
        Field50560Visible: Boolean;
        Field50561Visible: Boolean;
        Field50562Visible: Boolean;
        Field50563Visible: Boolean;
        Field50564Visible: Boolean;
        Field50565Visible: Boolean;
        Field50566Visible: Boolean;
        Field50567Visible: Boolean;
        Field50568Visible: Boolean;
        Field50569Visible: Boolean;
        Field50570Visible: Boolean;
        Field50571Visible: Boolean;
        Field50572Visible: Boolean;
        Field50573Visible: Boolean;
        Field50574Visible: Boolean;
        Field50575Visible: Boolean;
        Field50576Visible: Boolean;
        Field50577Visible: Boolean;
        Field50578Visible: Boolean;
        Field50579Visible: Boolean;
        Field50580Visible: Boolean;
        Field50581Visible: Boolean;
        Field50582Visible: Boolean;
        Field50583Visible: Boolean;
        Field50584Visible: Boolean;
        Field50585Visible: Boolean;
        Field50586Visible: Boolean;
        Field50587Visible: Boolean;
        Field50588Visible: Boolean;
        Field50589Visible: Boolean;
        Field50590Visible: Boolean;
        Field50591Visible: Boolean;
        Field50592Visible: Boolean;
        Field50593Visible: Boolean;
        Field50594Visible: Boolean;
        Field50595Visible: Boolean;
        Field50596Visible: Boolean;
        Field50597Visible: Boolean;
        Field50598Visible: Boolean;
        Field50599Visible: Boolean;
        Field50600Visible: Boolean;
        Field50601Visible: Boolean;
        Field50602Visible: Boolean;
        Field50603Visible: Boolean;
        Field50604Visible: Boolean;
        Field50605Visible: Boolean;
        Field50606Visible: Boolean;
        Field50607Visible: Boolean;
        Field50608Visible: Boolean;
        Field50609Visible: Boolean;
        Field50610Visible: Boolean;
        Field50611Visible: Boolean;
        Field50612Visible: Boolean;
        Field50613Visible: Boolean;
        Field50614Visible: Boolean;
        Field50615Visible: Boolean;
        Field50616Visible: Boolean;
        Field50617Visible: Boolean;
        Field50618Visible: Boolean;
        Field50619Visible: Boolean;
        Field50620Visible: Boolean;


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
        // Field50490Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50490"));
        // Field50491Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50491"));
        // Field50492Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50492"));
        // Field50493Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50493"));
        // Field50494Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50494"));
        // Field50495Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50495"));
        // Field50496Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50496"));
        // Field50497Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50497"));
        // Field50498Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50498"));
        // Field50499Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50499"));
        // Field50500Visible := PayrollEngine.ShowColumn(Database::"Payroll Line", "Payroll Line".FieldNo("Variable Field 50500"));

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
