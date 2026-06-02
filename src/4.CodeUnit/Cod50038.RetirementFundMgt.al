codeunit 50038 "Retirement Fund Mgt"
{
    procedure GetRetirementFund(RetirementFund: Record "Retirement Fund")
    var
        RFContributionLine: Record "RF Contribution";
        PayrollAttributeUsgae: Record "Payroll Attributes Usage";
        PayrollLine: Record "Payroll Line";
    begin
        RFContributionLine.SetRange("Document No.", RetirementFund."No.");
        RFContributionLine.SetRange("Employee No.", RetirementFund."Employee No.");
        if RFContributionLine.FindFirst() then
            case RFContributionLine.Type of
                RFContributionLine.Type::Manual, RFContributionLine.Type::Optimum:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end;
                    end;
                RFContributionLine.Type::Fixed:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae.Amount := RFContributionLine.Amount;
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end else begin
                            PayrollAttributeUsgae.Init();
                            PayrollAttributeUsgae.Validate("Employee Code", RetirementFund."Employee No.");
                            PayrollAttributeUsgae.Validate(Code, RFContributionLine."Attribute Code");
                            PayrollAttributeUsgae.Validate(Amount, RFContributionLine.Amount);
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            if PayrollAttributeUsgae.Insert() then;
                        end;
                    end;
                RFContributionLine.Type::Percent:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae.Amount := PayrollLine.GetAmountRFContribution(RetirementFund."Employee No.") * RFContributionLine.Amount / 100;
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end else begin
                            PayrollAttributeUsgae.Init();
                            PayrollAttributeUsgae.Validate("Employee Code", RetirementFund."Employee No.");
                            PayrollAttributeUsgae.Validate(Code, RFContributionLine."Attribute Code");
                            PayrollAttributeUsgae.Validate(Amount, PayrollLine.GetAmountRFContribution(RetirementFund."Employee No.") * RFContributionLine.Amount / 100);
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            if PayrollAttributeUsgae.Insert() then;
                        end;
                    end;
            end;
    end;

    procedure ApplyForRetirementFund(TempRetirementFund: Record "Retirement Fund"): Boolean
    var
        RFContibution: Record "RF Contribution";
        ApprovalMgt: Codeunit "Approver Mgt";
    begin
        if GuiAllowed then
            if not Confirm('Do you want to send retirement fund for approval?', false) then
                exit;
        TempRetirementFund.TestField("Fiscal Year");
        TempRetirementFund.TestField("Payroll Month");
        TempRetirementFund.TestField("Employee No.");
        TempRetirementFund.Validate("Approval Status", TempRetirementFund."Approval Status"::Pending);
        TempRetirementFund.Modify(true);
        ApprovalMgt.UpdateFirstApproverStatus(TempRetirementFund."No.");
        RFContibution.SetRange("Employee No.", TempRetirementFund."Employee No.");
        RFContibution.SetRange("Document No.", TempRetirementFund."No.");
        if RFContibution.FindSet() then
            repeat
                if (RFContibution.Type <> TempRetirementFund.Type) and (RFContibution.Type = RFContibution.Type::" ") then
                    Error('Type must be same in Header and line.');
                RFContibution."Approval Status" := RFContibution."Approval Status"::Pending;
                RFContibution.Modify();
            until RFContibution.Next = 0
        else
            Error('Error Retirement Fund Line not Found in %1', TempRetirementFund."No.");
        //   RFContibution.DeleteAll();
        //SendMailFromTemplate(DATABASE::"Employee Activity",EmpAct.Type::"Travel Request",EmpAct."Approval Status"::Open,'',EmpAct."Employee No.",EmpAct."No.",0);   //For email
        if GuiAllowed then
            Message('Retirement fund request sent for apporval.');
        exit(true);
    end;

    procedure CalculateRetirementFund(var RF: Record "Retirement Fund"; ProjectionMonth: Integer)
    begin
        RF."Total Committed Contribution" := (RF."RTF Amount (Month)" * (ProjectionMonth)) +
                           RF."RTF Amount (Lumpsum)" + (RF."CIT Amount (Month)" * (ProjectionMonth)) +
                           RF."CIT Amount( Lumpsum)";
        RF."Total Deduction" := RF."Total Committed Contribution" + RF."Actual/Projected Contribution";
        RF.Difference := Round(RF."RF Contribution Eligible Amt" - RF."Total Deduction", 0.01, '=');
        RF."Lumpsum Committed Contribution" := RF."RTF Amount (Lumpsum)" + RF."CIT Amount( Lumpsum)";
        RF."Lumpsum Space Max Benefit" := Round(RF."Additional Space for RF Cont." - (RF."RTF Amount (Month)" + RF."CIT Amount (Month)") * ProjectionMonth, 0.01, '=');
        if RF."Lumpsum Space Max Benefit" < 0 then
            RF."Lumpsum Space Max Benefit" := 0;
    end;

    procedure OpenRFRequest(EmpCode: Code[20]; var TempRetirementFund: Record "Retirement Fund")
    var
        PostedPayrollHdr: Record "Posted Payroll Header";
        PostedPayrollLine: Record "Posted Payroll Line";
        PostedDocFound: Boolean;
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        TotalDeduction: Decimal;
        PayrollAttribute: Record "Payroll Attributes";
        LevelWiseAttributes: Record "Level Wise Attributes";
        PayrollReportMgt: Codeunit "Payroll Report Mgt.";
        PayCyclePeriod: Record "Pay Cycle Period";
        DetailedEmpledger: Record "Detailed Employee Ledger Entry";
        EmployeeLedgerEntries: Record "Employee Ledger Entry";
        PGSetup: Record "Payroll General Setup";
        ImportPayrollAttrReport: Report "Import Payroll Attributes";
        PayrollOpening: Record "Employee Payroll Opening";
        Employee: Record Employee;
        IsHandled: Boolean;
        PRSetup: Record "Payroll General Setup";
        HrMgt: Codeunit "HR Mgt.";
    begin
        Clear(Employee);
        Employee.Get(EmpCode);
        PRSetup.Get;

        PayrollOpening.SetRange("Employee No.", EmpCode);
        PayrollOpening.SetRange("Fiscal Year", PRSetup."Pay Cycle Term");
        if PayrollOpening.FindFirst() then;

        PRSetup.TestField("Tax Ex. Amt Divsion");
        TempRetirementFund.Init;
        TempRetirementFund.Validate("Employee No.", EmpCode);
        TempRetirementFund.Validate("Fiscal Year", HrMgt.ReturnFiscalYear(Today));
        TempRetirementFund.Validate("Approval Status", TempRetirementFund."Approval Status"::Open);
        TempRetirementFund.Validate("Created Date", Today);
        TempRetirementFund.Validate("Requested Date", Today);
        TempRetirementFund.Insert(true);
        if Employee."Employment Date" > PRSetup."Payroll Fiscal Year Start Date" then
            PayCyclePeriod.SetRange("Pay Date", Employee."Employment Date", PRSetup."Payroll Fiscal Year End Date")
        else
            PayCyclePeriod.SetRange("Start Date", PRSetup."Payroll Fiscal Year Start Date", PRSetup."Payroll Fiscal Year End Date");
        PayCyclePeriod.SetAutoCalcFields();
        PayCyclePeriod.SetRange(Posted, false);
        PayCyclePeriod.FindFirst();
        TempRetirementFund."Payroll Month" := PayCyclePeriod."Nepali Month";

        OnBeforeInsertOfPayrollAttributeUsage(EmpCode, IsHandled);
        if not IsHandled then begin
            Clear(ImportPayrollAttrReport);
            ImportPayrollAttrReport.SetEmployeeNo(Employee."No.");
            ImportPayrollAttrReport.UseRequestPage(false);
            ImportPayrollAttrReport.Run();
        end;

        PayrollReportMgt.GetPayrollAttributes(Employee);
        EmployeeLedgerEntries.SetRange("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
        EmployeeLedgerEntries.SetRange("Employee No.", EmpCode);
        EmployeeLedgerEntries.SetRange(Type, EmployeeLedgerEntries.Type::Payroll);
        EmployeeLedgerEntries.SetFilter(Amount, '<>%1', 0);
        if EmployeeLedgerEntries.FindLast() then begin
            DetailedEmpledger.SetRange("Employee Ledger Entry No.", EmployeeLedgerEntries."Entry No.");
            if DetailedEmpledger.FindFirst() then
                TempRetirementFund."Projection Month" := PayrollReportMgt.GetLastPayCycleForEmployee(empcode, PayCyclePeriod."Pay Cycle Term") - DetailedEmpledger."Pay Cycle Period"
        end
        else if (PRSetup."Payroll Fiscal Year Start Date" < Employee."Employment Date") and
                            (PRSetup."Payroll Fiscal Year End Date" > Employee."Employment Date") then
            TempRetirementFund."Projection Month" := PayrollReportMgt.GetFirstPayCycleForEmployee(empcode, PayCyclePeriod."Pay Cycle Term")
        else
            TempRetirementFund."Projection Month" := PayrollReportMgt.GetLastPayCycleForEmployee(empcode, PayCyclePeriod."Pay Cycle Term");
        Employee.Reset();
        Employee.SetFilter("Date Filter", '%1..%2', PRSetup."Payroll Fiscal Year Start Date", PRSetup."Payroll Fiscal Year End Date");
        Employee.CalcFields("CIT Deposit", "RF Deposit", "Total Retirement Contribution", "PF Contribution (Office)", "PF Contribution", "Lump Sum CIT");
        PayrollReportMgt.GetAnnualAccessibleIncome(EmpCode, '', PayCyclePeriod."Pay Cycle Term",
                                                   TempRetirementFund."Projection Month",
                                                   TempRetirementFund."Annual Assessable Income");
        if TempRetirementFund."Annual Assessable Income" / PRSetup."Tax Ex. Amt Divsion" < PRSetup."Tax Ex. Amt. not Exceeding" then
            TempRetirementFund."RF Contribution Eligible Amt" := Round(TempRetirementFund."Annual Assessable Income" / PRSetup."Tax Ex. Amt Divsion", 0.01, '=')
        else
            TempRetirementFund."RF Contribution Eligible Amt" := Round(PRSetup."Tax Ex. Amt. not Exceeding", 0.01, '=');
        TempRetirementFund."Provident Fund Deposited" := Round(Employee."PF Contribution (Office)" + Employee."PF Contribution", 0.01, '=');
        TempRetirementFund."RF Contribution Deposited" := Round(Employee."RF Deposit" + Employee."Lumpsum RF (Not Actual)" + PayrollOpening."Total RF Opening", 0.01, '=');
        TempRetirementFund."CIT Contribution Deposited" := Round(Employee."CIT Deposit" + Employee."Lump Sum CIT" + Employee."Lumpsum CIT (Not Actual)", 0.01, '=');
        TempRetirementFund."Provident Fund Projected" := CalculateProvidentFundProjected(EmpCode, TempRetirementFund."Projection Month");
        TempRetirementFund."Actual/Projected Contribution" := Round((TempRetirementFund."Provident Fund Deposited" + TempRetirementFund."CIT Contribution Deposited" + TempRetirementFund."RF Contribution Deposited" + TempRetirementFund."Provident Fund Projected"), 0.01, '=');
        OnAfterCalculationOfAcutalOrProjectedContribution(TempRetirementFund);
        TempRetirementFund."Additional Space for RF Cont." := CalculateValueNegtiveOrPostive(Round(TempRetirementFund."RF Contribution Eligible Amt" - TempRetirementFund."Actual/Projected Contribution", 0.01, '='));
        TempRetirementFund."Recommended Monthly CIT/RF" := CalculateValueNegtiveOrPostive(Round(TempRetirementFund."Additional Space for RF Cont." / TempRetirementFund."Projection Month", 0.01));
        CalculateRetirementFund(TempRetirementFund, TempRetirementFund."Projection Month");
        TempRetirementFund.Difference := Round(TempRetirementFund."RF Contribution Eligible Amt" - TempRetirementFund."Total Deduction", 0.01, '=');
        TempRetirementFund.Modify;
        if GuiAllowed then
            PAGE.Run(PAGE::"Retirement Fund Card", TempRetirementFund)
    end;

    procedure CalculateValueNegtiveOrPostive(Amount: Decimal): Decimal
    begin
        if Amount >= 0 then
            exit(Amount)
        else
            exit(0);
    end;

    procedure CalculateRFContributionDeposited(EmployeeNo: Code[20]; PayCycleTerm: Code[20]): Decimal
    var
        DetailEmployeeLedgerEntries: Record "Detailed Employee Ledger Entry";
        EmployeePayrollOpening: Record "Employee Payroll Opening";
        Employee: Record Employee;
    begin
        DetailEmployeeLedgerEntries.SetRange("Employee No.", EmployeeNo);
        DetailEmployeeLedgerEntries.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailEmployeeLedgerEntries.SetRange("Attribute Type", DetailEmployeeLedgerEntries."Attribute Type"::Deduction);
        DetailEmployeeLedgerEntries.SetFilter("Attribute Sub Type", '%1|%2|%3', DetailEmployeeLedgerEntries."Attribute Sub Type"::CIT, DetailEmployeeLedgerEntries."Attribute Sub Type"::RF, DetailEmployeeLedgerEntries."Attribute Sub Type"::"Lump Sum Contribution");
        DetailEmployeeLedgerEntries.SetRange(Reversed, false);
        DetailEmployeeLedgerEntries.CalcSums(Amount);

        EmployeePayrollOpening.SetRange("Employee No.", EmployeeNo);
        EmployeePayrollOpening.SetRange("Fiscal Year", PayCycleTerm);
        if EmployeePayrollOpening.FindFirst() then;

        Employee.Get(EmployeeNo);
        Employee.CalcFields("Lump Sum CIT");
        exit(Abs(DetailEmployeeLedgerEntries.Amount) + EmployeePayrollOpening."Total RF Opening" + Employee."Lump Sum CIT" + Employee."Lumpsum CIT (Not Actual)" + Employee."Lumpsum RF (Not Actual)");
    end;

    procedure CalculateProvidentFundProjected(EmployeeNo: Code[20]; ProjectionMonth: Integer): Decimal
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        TotalProvidentFundProjected: Decimal;
        PayrollAttributes: Record "Payroll Attributes";
        PayrollReportMgt: Codeunit "Payroll Report Mgt.";
        Amount: Decimal;
        AttributeAmount: Decimal;
    begin
        Clear(TotalProvidentFundProjected);
        Clear(Amount);
        Clear(AttributeAmount);
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Deduction);
        PayrollAttributes.SetFilter(Subtype, '%1|%2', PayrollAttributes.Subtype::"Employee Contribution", PayrollAttributes.Subtype::"Employer Contribution");
        if PayrollAttributes.FindSet() then
            repeat
                if PayrollAttributesUsage.Get(PayrollAttributes.Code, EmployeeNo) then begin
                    if (PayrollAttributes.Formula <> '') then begin
                        PayrollReportMgt.SetEmployeeCode(EmployeeNo);
                        AttributeAmount += PayrollReportMgt.EvaluateAmount(PayrollAttributes.Formula, 0);
                    end else if PayrollAttributesUsage."Static Amount" then
                            Amount += PayrollAttributesUsage.Amount - AttributeAmount
                    else
                        Amount += PayrollAttributesUsage.Amount;
                end;
            until PayrollAttributes.Next() = 0;
        TotalProvidentFundProjected := (Amount + AttributeAmount) * ProjectionMonth;
        exit(Round(TotalProvidentFundProjected, 0.01, '='));
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertOfPayrollAttributeUsage(EmployeeNo: Code[20]; var IsHandled: Boolean);
    begin
        //To make specific checks before inserting Attributes in Attribute Usage.
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCalculationOfAcutalOrProjectedContribution(var RetirementFund: Record "Retirement Fund");
    begin
        //To add additional contribution if any
    end;

}

