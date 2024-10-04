report 50079 "Employee Tax Info Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019880.EmployeeTaxInfoDetail.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(NepaliMonth; NepaliMonth) { }
            column(NepaliYear; NepaliYear) { }
        }
        dataitem("Posted Payroll Header"; "Posted Payroll Header")
        {
            DataItemTableView = where(Type = const(Payroll));
            column(DocNo; "No.") { }
            column(PostingDate; "Posting Date") { }
            dataitem("Posted Payroll Line"; "Posted Payroll Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(EmployeeNo; "Employee No.") { }
                column(EmployeeName; "Employee Name") { }
                column(SalaryLevelDescription; SalaryLevel.Description) { }
                column(PreviousTaxable; PreviousTaxable) { }
                column(AssessableIncome; AssessibleIncome) { }
                column(PreviousRetireFund; PreviousRF) { }
                column(ProjectedRetirementFund; ProjectedRF) { }
                column(ActualRFContribution; ActualRF) { }
                column(EligibleRFDeduction; EligibleRF) { }
                column(TaxaleRF; TaxaleRF) { }
                column(BalanceTaxableIncome; TaxableIncome) { }
                column(RFDeposit; RFDeposit) { }
                column(PFDeposit; PFDeposit) { }
                column(CITDeposit; CITDeposit) { }
                column(TotalRebate; TotalRebate) { }
                column(BalTaxableIncome; BalTaxableIncome) { }
                column(Slab1; Slab1) { }
                column(Slab2; Slab2) { }
                column(Slab3; Slab3) { }
                column(Slab4; Slab4) { }
                column(Slab5; Slab5) { }
                column(TotalTax; TotalTax) { }
                column(InsuranceRebate; InsuranceRebate) { }
                column(TotalTaxPaid; TotalTaxPaid) { }
                column(FemaleRebate; FemaleRebate) { }
                column(RemainingTax; RemainingTax) { }
                column(CurrentMonthTax; CurrentMonthTax) { }
                column(PFBenefits; PFBenefits) { }
                dataitem("Payroll Attributes"; "Payroll Attributes")
                {
                    column(Amount; Amt) { }
                    column(PayrollAttributeCode_; Code) { }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(Amt);
                        ClearValues;
                        PayrollColumnConfig.Reset;
                        PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                        PayrollColumnConfig.SetRange("Variable Field Code", Code);

                        if PayrollColumnConfig.FindFirst then begin
                            RecRefs.Open(Database::"Posted Payroll Line");
                            FieldRefs := RecRefs.Field(1);
                            FieldRefs.SetRange("Posted Payroll Header"."No.");
                            FieldRefs := RecRefs.Field(3);
                            FieldRefs.SetRange("Posted Payroll Line"."Employee No.");
                            RecRefs.FindFirst;
                            FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                            Amt := FieldRefs.Value;
                            if "Payroll Attributes"."Apply Every Month" then
                                Amt := Amt * ("Posted Payroll Line"."Projection Month" + 1);
                            RecRefs.Close;
                        end;
                        if Counter = 0 then begin
                            GetValues;
                        end;
                        Counter += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter(Subtype, '<>%1&<>%2&<>%3&<>%4', Subtype::CIT, Subtype::"Employee Contribution",
                                        Subtype::"Employer Contribution", Subtype::RF);
                        SetRange(Type, Type::Benefits);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(Counter);
                    SalaryLevel.Get("Salary Level");
                    EmpVar.Get("Employee No.");
                    EmpVar.CalcFields("RF Deposit", "Lump Sum CIT", "PF Contribution", "PF Contribution (Office)", "CIT Deposit");
                end;

                trigger OnPreDataItem()
                begin
                    if EmployeeFilter <> '' then
                        SetFilter("Employee No.", EmployeeFilter);
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange("Nepali Month", NepaliMonth);
                SetRange("Nepali Year", NepaliYear);
                SetRange("No.", DocumentNo);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Pay Cycle Term"; PayCycleTermText)
                {
                    TableRelation = "Pay Cycle Term".Term;
                    ToolTip = 'Specifies the value of the PayCycleTermText field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; NepaliMonth)
                {
                    ToolTip = 'Specifies the value of the NepaliMonth field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if PayCycleTermText = '' then
                            Error('Please select pay cycle term first.');
                        PostedPayrollHeader.Reset;
                        PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTermText);
                        PostedPayrollHeader.SetRange("Nepali Month", NepaliMonth);
                        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
                        if PostedPayrollHeader.FindFirst then
                            DocumentNo := PostedPayrollHeader."No."
                        else
                            DocumentNo := '';
                    end;
                }
                field("Document No."; DocumentNo)
                {
                    ToolTip = 'Specifies the value of the DocumentNo field.';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PagePostePayrollList: Page "Posted Payroll Plan List";
                    begin
                        Clear(PagePostePayrollList);
                        PostedPayrollHeader.Reset;
                        PostedPayrollHeader.FilterGroup(2);
                        PostedPayrollHeader.SetFilter("Nepali Month", Format(NepaliMonth));
                        PostedPayrollHeader.SetFilter("Pay Cycle Term", PayCycleTermText);
                        PostedPayrollHeader.FilterGroup(0);
                        PagePostePayrollList.LookupMode(true);
                        PagePostePayrollList.SetRecord(PostedPayrollHeader);
                        PagePostePayrollList.SetTableView(PostedPayrollHeader);
                        if PagePostePayrollList.RunModal = Action::LookupOK then begin
                            PagePostePayrollList.GetRecord(PostedPayrollHeader);
                            DocumentNo := PostedPayrollHeader."No.";
                        end;
                    end;
                }
                field(Employee; EmployeeFilter)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmployeeFilter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        PGSetup.Get;
        NepaliMonth := PGSetup."HRMS Month";
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Start Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        PayCyclePeriod.SetRange("Nepali Month", PGSetup."HRMS Month");
        if PayCyclePeriod.FindFirst then
            PayCycleTermText := PayCyclePeriod."Pay Cycle Term";

        PostedPayrollHeader.Reset;
        PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTermText);
        PostedPayrollHeader.SetRange("Nepali Month", NepaliMonth);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
        if PostedPayrollHeader.FindFirst then
            DocumentNo := PostedPayrollHeader."No.";
    end;

    trigger OnPreReport()
    begin
        if PayCycleTermText = '' then
            Error('Please fill up pay cycle term.');

        if (NepaliMonth = NepaliMonth::" ") then
            Error('Please fill up nepali month.');
        if DocumentNo = '' then
            Error('Please fill up document no.');

        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTermText);
        PayCyclePeriod.SetRange("Nepali Month", NepaliMonth);
        if PayCyclePeriod.FindFirst then begin
            EngNepDate.Reset;
            EngNepDate.SetRange("English Date", PayCyclePeriod."Start Date");
            EngNepDate.FindFirst;
            NepaliYear := EngNepDate."Nepali Year";
        end else
            Error('Could not find pay cycle period.');
    end;

    var
        PGSetup: Record "Payroll General Setup";
        SalaryLevel: Record "Salary Level";
        TaxaleRF: Decimal;
        InsuranceRebate: Decimal;
        Amt: Decimal;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        Counter: Integer;
        AssessibleIncome: Decimal;
        PreviousTaxable: Decimal;
        PreviousRF: Decimal;
        ProjectedRF: Decimal;
        ActualRF: Decimal;
        EligibleRF: Decimal;
        TaxableIncome: Decimal;
        EmpVar: Record Employee;
        RFDeposit: Decimal;
        PFDeposit: Decimal;
        CITDeposit: Decimal;
        TotalRebate: Decimal;
        BalTaxableIncome: Decimal;
        Slab1: Decimal;
        Slab2: Decimal;
        Slab3: Decimal;
        Slab4: Decimal;
        Slab5: Decimal;
        TotalTax: Decimal;
        TotalTaxPaid: Decimal;
        FemaleRebate: Decimal;
        RemainingTax: Decimal;
        CurrentMonthTax: Decimal;
        PFBenefits: Decimal;
        NepaliMonth: Enum "Nepali Month";
        NepaliYear: Integer;
        EngNepDate: Record "English-Nepali Date";
        PayCycleTermText: Text;
        PayCyclePeriod: Record "Pay Cycle Period";
        DocumentNo: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        EmployeeFilter: Text;

    local procedure ClearValues()
    begin
        AssessibleIncome := 0;
        TaxaleRF := 0;
        InsuranceRebate := 0;
        PreviousTaxable := 0;
        PreviousRF := 0;
        ProjectedRF := 0;
        ActualRF := 0;
        EligibleRF := 0;
        BalTaxableIncome := 0;
        TaxableIncome := 0;
        CITDeposit := 0;
        PFDeposit := 0;
        RFDeposit := 0;
        TotalRebate := 0;
        Slab1 := 0;
        Slab2 := 0;
        Slab3 := 0;
        Slab4 := 0;
        Slab5 := 0;
        TotalTax := 0;
        TotalTaxPaid := 0;
        FemaleRebate := 0;
        PFBenefits := 0;
        RemainingTax := 0;
        CurrentMonthTax := 0;
    end;

    local procedure GetValues()
    var
        PayAtt: Record "Payroll Attributes";
        Amts: Decimal;
    begin
        PayAtt.Reset;
        PayAtt.SetRange(Type, PayAtt.Type::Deduction);
        PayAtt.SetFilter(Subtype, '%1|%2|%3|%4', PayAtt.Subtype::CIT, PayAtt.Subtype::"Employee Contribution",
                        PayAtt.Subtype::"Employer Contribution", PayAtt.Subtype::RF);
        if PayAtt.Find('-') then
            repeat
                PayrollColumnConfig.Reset;
                PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                PayrollColumnConfig.SetRange("Variable Field Code", PayAtt.Code);
                if PayrollColumnConfig.FindFirst then begin
                    RecRefs.Open(Database::"Posted Payroll Line");
                    FieldRefs := RecRefs.Field(1);
                    FieldRefs.SetRange("Posted Payroll Header"."No.");
                    FieldRefs := RecRefs.Field(3);
                    FieldRefs.SetRange("Posted Payroll Line"."Employee No.");
                    RecRefs.FindFirst;
                    FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                    Amts := FieldRefs.Value;
                    if PayAtt."Apply Every Month" then
                        Amts := Amts * ("Posted Payroll Line"."Projection Month" + 1);

                    if PayAtt.Subtype = PayAtt.Subtype::CIT then
                        CITDeposit := Amts
                    else if PayAtt.Subtype in [PayAtt.Subtype::"Employee Contribution", PayAtt.Subtype::"Employer Contribution"] then
                        PFDeposit += Amts
                    else if PayAtt.Subtype = PayAtt.Subtype::RF then
                        RFDeposit := Amts;

                    RecRefs.Close;
                end;
            until PayAtt.Next = 0;

        PayAtt.Reset;
        PayAtt.SetRange(Type, PayAtt.Type::Benefits);
        PayAtt.SetFilter(Subtype, '%1|%2', PayAtt.Subtype::"Employer Contribution", PayAtt.Subtype::"Employee Contribution");
        if PayAtt.Find('-') then
            repeat
                PayrollColumnConfig.Reset;
                PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                PayrollColumnConfig.SetRange("Variable Field Code", PayAtt.Code);
                if PayrollColumnConfig.FindFirst then begin
                    RecRefs.Open(Database::"Posted Payroll Line");
                    FieldRefs := RecRefs.Field(1);
                    FieldRefs.SetRange("Posted Payroll Header"."No.");
                    FieldRefs := RecRefs.Field(3);
                    FieldRefs.SetRange("Posted Payroll Line"."Employee No.");
                    RecRefs.FindFirst;
                    FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                    Amts := FieldRefs.Value;
                    if PayAtt."Apply Every Month" then
                        Amts := Amts * ("Posted Payroll Line"."Projection Month" + 1);

                    PFBenefits += Amts;

                    RecRefs.Close;
                end;
            until PayAtt.Next = 0;

        PFDeposit += EmpVar."PF Contribution" + EmpVar."PF Contribution (Office)";
        RFDeposit += EmpVar."RF Deposit";
        AssessibleIncome := "Posted Payroll Line"."Assessable Income";
        InsuranceRebate := "Posted Payroll Line"."Health Insurance Premium" + "Posted Payroll Line"."Life Insurance Premium";
        PreviousTaxable := "Posted Payroll Line"."Past Benefit";
        PreviousRF := "Posted Payroll Line"."Past Retirement Fund";
        ProjectedRF := "Posted Payroll Line"."Projected Retirement Fund";
        ActualRF := "Posted Payroll Line"."Actual RF Contribution";
        EligibleRF := "Posted Payroll Line"."Eligible RF Deduction";
        TaxableIncome := "Posted Payroll Line"."Taxable Income";
        TotalRebate := InsuranceRebate;
        BalTaxableIncome := "Posted Payroll Line"."Balance Taxable Income";
        Slab1 := "Posted Payroll Line"."1% Slab";
        Slab2 := "Posted Payroll Line"."20% Slab";
        Slab3 := "Posted Payroll Line"."20% Slab";
        Slab4 := "Posted Payroll Line"."30% Slab";
        Slab5 := "Posted Payroll Line"."36% Slab";
        TotalTax := "Posted Payroll Line"."Total Tax Liability";
        TotalTaxPaid := "Posted Payroll Line"."Total Tax Paid";
        FemaleRebate := "Posted Payroll Line"."Female Tax Credit";
        RemainingTax := "Posted Payroll Line"."Net Tax Liability";
        CurrentMonthTax := "Posted Payroll Line"."Tax for Period";
    end;
}
