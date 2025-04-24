codeunit 50002 "Loan Mgt."
{
    // //Min 7.3.2022 -- For allowed to change approver of Status::Pending and Open allowance assignment.
    // //Min 9.29.2022 -- Round down "RemAgePeriodAsPerBankTenure" and "RemServicePeriodAsPerBankTenure",Decimal age calc. in "Age Home Loan".
    // //Min 12.20.2022 -- Risk allowance calc. updated fotr TA Position.


    trigger OnRun()
    var
        EmpLoan: Record "Employee Loan/Advance";
        LoanOutstand: Record "Loan Outstanding from Finacle";
        AllowanceHeader: Record "Allowance Assignment Header";
    begin
    end;

    var
        Employee: Record Employee;
        EmployeeAttribute: Record "Payroll Attributes Usage";
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        EmpSalaryAdv: Record "Employee Loan/Advance";
        EngNep: Record "English-Nepali Date";
        LoanInterest: Record "Employee Loan Interest";
        InsurancePolicy: Record "Insurance Premium Setup";
        FileMgt: Codeunit "File Management";
        AttachmentMgt: Codeunit "Attachment Mgt.";
        HasRecommender: Boolean;
        HasApprover: Boolean;
        GotRecord: Boolean;
        ReadyExit: Boolean;
        RecommendedBy: Text;
        ApprovedBy: Text;
        RecommendedByName: Text;
        ApprovedByName: Text;
        From1: Text;
        From2: Text;
        FindRecommender: Boolean;
        FindApprover: Boolean;
        LastRankValue: Decimal;
        "ERROR BM": Label 'Only %1 can approve this document.';
        // DimensionValue: Record "Dimension Value";
        RemoteArea: Record "Remote Area Category";
        Colon: Label ' : ';
        DocumentType: Option " ","Leave Request","Travel Request","Travel Claim","Late Attendance",Training,"Salary Advance","Personal Loan","Vehicle Loan","Home Loan";
        PrevLoanAmt: Decimal;
        VehicleLoanReapplyErr: Label 'Duration from disbursement date of previos loan is not greater than 5 years.';
        GLSetup: Record "General Ledger Setup";
        // DepartVar: Record Department;
        // EmpHierMaster: Record "Employee Hierarchy Master";
        HomeLoanReapplyErr: Label 'Duration from disbursement date of previos loan is not greater than 5 years.';
        // SMTPSetup: Record "SMTP Mail Setup";
        CompanyInfo: Record "Company Information";
        PGSetup: Record "Payroll General Setup";
        LoanError: Label 'Your previous loan or salary advance %1 is still pending.Please wait until your previous salary advance or loan is approved.';
        // JsonTextReader: DotNet JsonTextReader;
        AcctNo: Text;
        SchemeTypeText: Text;
        Balance: Decimal;
        LoanLimit: Decimal;
        SchemeCode: Text;
        EMIValue: Decimal;
        LevelWiseAttribute: Record "Level Wise Attributes";
        LineNo2: Integer;
        BelowSOAmt: Decimal;

    procedure CalculateFields(var EmpLoan: Record "Employee Loan/Advance")
    var
        AgeDays: Integer;
        IsBirthDay: Boolean;
        RemServicePeriodAsPerBankTenure: Decimal;
        RemAgePeriodAsPerBankTenure: Decimal;
    begin
        HRSetup.Get;
        HRSetup.TestField("DBR Ratio");
        HRSetup.TestField("V.loan Repay. Limit above SO");
        HRSetup.TestField("Vehicle Loan Eligible Month");
        HRSetup.TestField("Home Loan Eligible Month");
        EmpLoan."Eligible Loan/Advance" := 0;
        EmpLoan."Gross Salary" := 0;
        if not Employee.Get(EmpLoan."Employee Code") then
            exit;
        Employee.TestField("Birth Date");
        GLSetup.Get;
        EmpLoan."Employee Name" := Employee."Full Name";
        EmpLoan."Job Title" := Employee."Salary Level";
        EmpLoan."Job Type" := Employee."Employment Type";
        EmpLoan."Date of Joining" := Employee."Employment Date";

        EmpLoan.Gender := Employee.Gender;
        if Employee."Confirmation Date" = 0D then
            Error('Confirmation Date must have value in employee %1.', Employee.FullName);
        Evaluate(EmpLoan."Confirmation Service Period", Format((Today - Employee."Confirmation Date") / 365));
        EmpLoan.Validate("Confirmation Service Period", Round(EmpLoan."Confirmation Service Period", 0.01, '='));
        EmpLoan.Department := Employee."Department Code";
        EmpLoan."Date of Birth" := Employee."Birth Date";
        HRMgt.CheckAgeAndBirthday(EmpLoan."Date of Birth", Today, EmpLoan.Age, AgeDays, IsBirthDay);
        HRSetup.TestField("Retirement Age");
        EmpLoan."Remaining Service Period" := HRSetup."Retirement Age" - EmpLoan.Age;
        Evaluate(RemServicePeriodAsPerBankTenure, Format(30 - (Today - Employee."Employment Date") / 365));
        if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Home Loan" then begin //Min 9.29.2022
            EmpLoan."Age Home Loan" := Round((Today - EmpLoan."Date of Birth") / 365, 0.01, '=');
            Evaluate(RemAgePeriodAsPerBankTenure, Format(HRSetup."Retirement Age" - (Today - EmpLoan."Date of Birth") / 365));
            RemAgePeriodAsPerBankTenure := Round(RemAgePeriodAsPerBankTenure, 1, '<');
            RemServicePeriodAsPerBankTenure := Round(RemServicePeriodAsPerBankTenure, 1, '<');
            if EmpLoan."Remaining Service Period" > RemServicePeriodAsPerBankTenure then
                EmpLoan."Remaining Service Period" := RemServicePeriodAsPerBankTenure
            else
                EmpLoan."Remaining Service Period" := RemAgePeriodAsPerBankTenure;
        end else begin
            RemServicePeriodAsPerBankTenure := Round(RemServicePeriodAsPerBankTenure, 0.1, '=');
            if EmpLoan."Remaining Service Period" > RemServicePeriodAsPerBankTenure then
                EmpLoan."Remaining Service Period" := RemServicePeriodAsPerBankTenure;
        end;
        EmpLoan.Branch := Employee."Global Dimension 1 Code";//branch
        EmpLoan."Branch Name" := Employee."Branch Name";
        EmpLoan."Department Name" := Employee."Department Name";
        EmpLoan."Unit Name" := Employee."Unit Name";

        // if DimensionValue.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then
        //     EmpLoan."Branch Name" := DimensionValue.Name;
        // if DepartVar.Get(Employee."Department Code") then
        //     EmpLoan."Department Name" := DepartVar.Name;
        // if EmpHierMaster.Get(Employee."Unit Code") then
        //     EmpLoan."Unit Name" := EmpHierMaster.Description;

        EmpLoan."Citizenship Issue Date" := Employee."Citizenship Issue Date";
        EmpLoan."Employee Citizenship No." := Employee."Citizen Number";
        EmpLoan."Employee Name in Nepali" := Employee."Full Name (Nepali)";
        EmpLoan."Father's Name In Nepali" := Employee."Father's Name (Nepali)";
        EmpLoan."Grandfather's Name In Nepali" := Employee."GrandFather's Name (Nepali)";
        //frequency

        EmpSalaryAdv.Reset;
        EmpSalaryAdv.SetRange("Employee Code", EmpLoan."Employee Code");
        EmpSalaryAdv.SetRange("Approval Status", EmpLoan."Approval Status"::Approved);
        EmpSalaryAdv.SetRange(FY, EmpLoan.FY);
        EmpSalaryAdv.SetFilter("No.", '<>%1', EmpLoan."No.");
        EmpSalaryAdv.SetRange("Loan Type", EmpSalaryAdv."Loan Type"::"Salary Advance");
        EmpLoan.Frequency := EmpSalaryAdv.Count;


        SalaryLevel.Get(Employee."Salary Level");
        SalaryGrade.Get(Employee."Salary Grade");

        EmpLoan."Gross Salary" := SalaryLevel."Basic Salary" +
                            SalaryLevel.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel."Basic Salary";

        BelowSOAmt := GetLFAAndDashainAllowance(SalaryLevel, SalaryGrade);
        CalculateEligibleLoanAmount(EmpLoan);

        if EmpLoan."Applied Loan/Advance" <> 0 then
            //IF "Total Loan Amount"> "Eligible Loan/Advance" THEN
            if EmpLoan."Applied Loan/Advance" > EmpLoan."Eligible Loan/Advance" then //pram
                Error('Applied loan exceeded.');


        CalculateEMI(EmpLoan);

        CalculateDBR(EmpLoan, SalaryLevel);

        //InsertApprover(EmpLoan);

        InsertAttachmentLines(EmpLoan);
    end;

    local procedure CalculateEligibleLoanAmount(var EmpLoan: Record "Employee Loan/Advance")
    var
        RepaymentPeriod: Decimal;
        PreviousLoan: Record "Employee Loan/Advance";
        CheckSalaryLevel: Record "Salary Level";
        EligibleMonth: Decimal;
    begin
        Clear(PrevLoanAmt);
        case EmpLoan."Loan Type" of
            EmpLoan."Loan Type"::"Salary Advance":
                begin
                    HRSetup.TestField("Max Adv. Salary Payback Month");
                    EmpLoan."Eligible Loan/Advance" := EmpLoan."Gross Salary" * 2;
                end;
            EmpLoan."Loan Type"::"Personal Loan":
                begin
                    PrevLoanAmt := GetExistingLoanAmount(EmpLoan."Employee Code", EmpLoan."Loan Type", EmpLoan."No.");
                    EmpLoan."Previous Loan Amount" := PrevLoanAmt;
                    EmpLoan."Total Loan Amount" := PrevLoanAmt + EmpLoan."Applied Loan/Advance";
                    if EmpLoan."Confirmation Service Period" >= 2 then
                        EmpLoan."Eligible Loan/Advance" := EmpLoan."Gross Salary" * 10 - PrevLoanAmt
                    else if EmpLoan."Confirmation Service Period" >= 1 then
                        EmpLoan."Eligible Loan/Advance" := EmpLoan."Gross Salary" * 4 - PrevLoanAmt;

                    CheckSalaryLevel.Reset;
                    CheckSalaryLevel.SetRange("Senior Officer Level", true);
                    if CheckSalaryLevel.FindFirst then begin
                        if (SalaryLevel.Rank <= CheckSalaryLevel.Rank) then begin
                            if EmpLoan."Confirmation Service Period" > 5 then
                                EmpLoan."Eligible Loan/Advance" := EmpLoan."Gross Salary" * 15 - PrevLoanAmt
                            else if EmpLoan."Confirmation Service Period" > 3 then
                                EmpLoan."Eligible Loan/Advance" := EmpLoan."Gross Salary" * 12 - PrevLoanAmt;
                        end;
                    end;

                end;
            EmpLoan."Loan Type"::"Vehicle Loan":
                begin
                    EmpLoan."Eligible Loan/Advance" := 90 / 100 * EmpLoan."Cost of Vehicle";
                    CheckSalaryLevel.Reset;
                    CheckSalaryLevel.SetRange("Is AM", true);
                    if CheckSalaryLevel.FindFirst then;
                    PrevLoanAmt := GetExistingLoanAmount(EmpLoan."Employee Code", EmpLoan."Loan Type", EmpLoan."No.");
                    EmpLoan."Previous Loan Amount" := PrevLoanAmt;
                    EmpLoan."Total Loan Amount" := PrevLoanAmt + EmpLoan."Applied Loan/Advance";
                    if SalaryLevel.Get(Employee."Salary Level") then begin
                        if CheckSalaryLevel.Rank <= SalaryLevel.Rank then
                            EmpLoan."Eligible Loan/Advance" := EmpLoan."Cost of Vehicle";
                        if SalaryLevel."Vehicle Loan Limit" <> 0 then
                            if SalaryLevel."Vehicle Loan Limit" < EmpLoan."Eligible Loan/Advance" then
                                EmpLoan."Eligible Loan/Advance" := SalaryLevel."Vehicle Loan Limit";
                        if EmpLoan."Eligible Loan/Advance" > HRSetup."Vehicle Loan Eligible Month" * EmpLoan."Gross Salary" then
                            EmpLoan."Eligible Loan/Advance" := HRSetup."Vehicle Loan Eligible Month" * EmpLoan."Gross Salary";
                    end;

                    if SalaryLevel."Reapply Year (Vehicle Loan)" <> 0 then begin
                        PreviousLoan.Reset;
                        PreviousLoan.SetRange("Employee Code", EmpLoan."Employee Code");
                        PreviousLoan.SetRange("Approval Status", PreviousLoan."Approval Status"::Approved);
                        PreviousLoan.SetRange(Disbursed, true);
                        PreviousLoan.SetRange(Settled, true);
                        PreviousLoan.SetFilter("No.", '<>%1', EmpLoan."No.");
                        if PreviousLoan.FindLast then begin
                            if Today < CalcDate(Format(SalaryLevel."Reapply Year (Vehicle Loan)"), PreviousLoan."Disbursement Date") then
                                Error(VehicleLoanReapplyErr);
                        end;
                    end;
                end;
            EmpLoan."Loan Type"::"Home Loan":
                begin
                    CheckSalaryLevel.Reset;
                    CheckSalaryLevel.SetRange("Senior Officer Level", true);
                    if CheckSalaryLevel.FindFirst then;
                    if SalaryLevel.Get(Employee."Salary Level") then begin
                        PrevLoanAmt := GetExistingLoanAmount(EmpLoan."Employee Code", EmpLoan."Loan Type", EmpLoan."No.");
                        EmpLoan."Previous Loan Amount" := PrevLoanAmt;
                        EmpLoan."Total Loan Amount" := PrevLoanAmt + EmpLoan."Applied Loan/Advance";
                        if SalaryLevel.Rank <= CheckSalaryLevel.Rank then
                            EligibleMonth := HRSetup."Loan Eligible Month Below SO"
                        else
                            EligibleMonth := HRSetup."Home Loan Eligible Month";
                        if SalaryLevel."Housing Loan Limit" <> 0 then begin
                            if (EligibleMonth * EmpLoan."Gross Salary") > (SalaryLevel."Housing Loan Limit") then
                                EmpLoan."Eligible Loan/Advance" := (SalaryLevel."Housing Loan Limit") - PrevLoanAmt
                            else
                                EmpLoan."Eligible Loan/Advance" := (EligibleMonth * EmpLoan."Gross Salary") - PrevLoanAmt;
                        end else
                            EmpLoan."Eligible Loan/Advance" := (EligibleMonth * EmpLoan."Gross Salary") - PrevLoanAmt;

                        if EmpLoan."Purpose of Housing Loan" = EmpLoan."Purpose of Housing Loan"::"Renovate/Extend/Repair" then begin
                            if EmpLoan."Eligible Loan/Advance" > 95 / 100 * (EmpLoan."Commercial Value of Property" + EmpLoan."Estimated Cost of Construction") then
                                EmpLoan."Eligible Loan/Advance" := 95 / 100 * (EmpLoan."Commercial Value of Property" + EmpLoan."Estimated Cost of Construction");

                        end else if EmpLoan."Eligible Loan/Advance" > 90 / 100 * (EmpLoan."Commercial Value of Property" + EmpLoan."Estimated Cost of Construction") then
                                EmpLoan."Eligible Loan/Advance" := 90 / 100 * (EmpLoan."Commercial Value of Property" + EmpLoan."Estimated Cost of Construction");
                    end;

                    if not EmpLoan."Loan Enhancement" then begin
                        PreviousLoan.Reset;
                        PreviousLoan.SetRange("Employee Code", EmpLoan."Employee Code");
                        PreviousLoan.SetRange("Approval Status", PreviousLoan."Approval Status"::Approved);
                        PreviousLoan.SetRange("Loan Type", PreviousLoan."Loan Type"::"Home Loan");
                        PreviousLoan.SetRange(Disbursed, true);
                        PreviousLoan.SetRange(Settled, true);
                        PreviousLoan.SetRange("Loan Enhancement", false);
                        PreviousLoan.SetFilter("No.", '<>%1', EmpLoan."No.");
                        if PreviousLoan.FindLast then begin
                            if Today < CalcDate('<5Y>', PreviousLoan."Disbursement Date") then
                                Error(HomeLoanReapplyErr);
                        end;
                    end;

                    RepaymentPeriod := 25;
                    if RepaymentPeriod < EmpLoan."Repayment Period" then
                        EmpLoan."Repayment Period" := RepaymentPeriod;

                    if EmpLoan."Repayment Period" > EmpLoan."Remaining Service Period" then begin
                        Error('Maximum repayment period is %1', EmpLoan."Remaining Service Period");
                        EmpLoan."Repayment Period" := EmpLoan."Remaining Service Period";
                    end;
                end;
        end;
    end;

    local procedure CalculateEMI(var EmpLoan: Record "Employee Loan/Advance")
    var
        InterestRate: Decimal;
        PowerValue: Decimal;
    begin
        HRSetup.Get;
        EmpLoan.EMI := 0;
        case EmpLoan."Loan Type" of
            EmpLoan."Loan Type"::"Salary Advance":
                begin
                    if EmpLoan."Payback Months" <> 0 then
                        EmpLoan.EMI := EmpLoan."Applied Loan/Advance" / EmpLoan."Payback Months".AsInteger()
                    else
                        EmpLoan.EMI := EmpLoan."Applied Loan/Advance" / 1;
                end;
            EmpLoan."Loan Type"::"Personal Loan":
                begin
                    EmpLoan."Interest Rate" := GetInterestRate(EmpLoan."Requested Loan Date", EmpLoan."Loan Type");
                    EmpLoan.EMI := (EmpLoan."Applied Loan/Advance" * EmpLoan."Interest Rate" / 100) / 12;
                end;

            EmpLoan."Loan Type"::"Vehicle Loan":
                begin
                    if EmpLoan."Repayment Period" > HRSetup."Max. Veh. Loan Repay Period" then
                        Error('Repayment period exceeded.');
                    if (SalaryLevel."Vehicle Loan Limit" <> 0) then   //changes for salary level greater than AM
                        EmpLoan."Interest Rate" := 0    //changes for salary level greater than AM
                    else
                        EmpLoan."Interest Rate" := GetInterestRate(EmpLoan."Requested Loan Date", EmpLoan."Loan Type");
                    InterestRate := (EmpLoan."Interest Rate" / 12) / 100;
                    PowerValue := Power((1 + InterestRate), (EmpLoan."Repayment Period" * 12));
                    if EmpLoan."Interest Rate" = 0 then     //changes for salary level greater than AM
                        EmpLoan.EMI := EmpLoan."Applied Loan/Advance" / (EmpLoan."Repayment Period" * 12)    //changes for salary level greater than AM
                    else
                        EmpLoan.EMI := (EmpLoan."Applied Loan/Advance" * InterestRate * PowerValue)  //pram 1.31.2020
                              / (PowerValue - 1);

                end;
            EmpLoan."Loan Type"::"Home Loan":
                begin
                    if EmpLoan."Repayment Mode" = EmpLoan."Repayment Mode"::"EMI Basis" then begin
                        EmpLoan."Interest Rate" := GetInterestRate(EmpLoan."Requested Loan Date", EmpLoan."Loan Type");
                        InterestRate := (EmpLoan."Interest Rate" / 12) / 100;
                        PowerValue := Power((1 + InterestRate), (EmpLoan."Repayment Period" * 12));
                        EmpLoan.EMI := (EmpLoan."Applied Loan/Advance" * InterestRate * PowerValue)
                            / (PowerValue - 1);
                    end
                    else if EmpLoan."Repayment Mode" = EmpLoan."Repayment Mode"::"Insurance Tieup" then begin
                        EmpLoan."Interest Rate" := 0;
                        InsurancePolicy.Reset;
                        //InsurancePolicy.SetRange("Insurance Company", EmpLoan."Insurance Tieup");
                        InsurancePolicy.SetRange(Age, EmpLoan.Age);
                        InsurancePolicy.SetRange(Period, EmpLoan."Repayment Period");
                        if InsurancePolicy.FindFirst then begin
                            EmpLoan."Interest Rate" := InsurancePolicy.Value;
                            EmpLoan.EMI := (EmpLoan."Applied Loan/Advance" / 1000) * InsurancePolicy.Value / 12;
                        end;
                    end;
                end;
        end;
    end;

    local procedure CalculateDBR(var EmpLoan: Record "Employee Loan/Advance"; SalaryLevel: Record "Salary Level")
    var
        TotalDBR: Decimal;
        TotalEMI: Decimal;
        LoanOutstanding: Record "Loan Outstanding from Finacle";
        PreviosuEMI: Decimal;
        EMIPersonalLoan: Decimal;
        EmpLoanInterest: Record "Employee Loan Interest";
        HomeloanEMI: Decimal;
        VehicleLoanEMI: Decimal;
        CheckSalaryLevel: Record "Salary Level";
    begin
        Employee.Get(EmpLoan."Employee Code");
        SalaryLevel.Get(Employee."Salary Level");
        SalaryGrade.Get(Employee."Salary Grade");
        LoanOutstanding.Reset;
        LoanOutstanding.SetRange("Employee No.", EmpLoan."Employee Code");
        LoanOutstanding.SetFilter("Loan Type", '%1|%2', LoanOutstanding."Loan Type"::"Home Loan", LoanOutstanding."Loan Type"::"Home Loan Insurance Tieup");
        LoanOutstanding.CalcSums(EMI);
        PreviosuEMI := LoanOutstanding.EMI;

        LoanOutstanding.Reset;
        LoanOutstanding.SetRange("Employee No.", EmpLoan."Employee Code");
        LoanOutstanding.SetRange("Scheme Type", 'ODA');
        LoanOutstanding.CalcSums("Loan Limit");

        EmpLoanInterest.Reset;
        EmpLoanInterest.SetRange("Loan Type", EmpLoanInterest."Loan Type"::"Personal Loan");
        EmpLoanInterest.SetCurrentKey("Starting Date");
        if EmpLoanInterest.FindLast then;
        EMIPersonalLoan := LoanOutstanding."Loan Limit" * EmpLoanInterest."Interest Rate" / 100 / 12;

        EmpSalaryAdv.Reset;
        EmpSalaryAdv.SetRange("Employee Code", EmpLoan."Employee Code");
        //EmpSalaryAdv.SetRange("Approval Status", EmpLoan."Approval Status"::Approved);
        //EmpSalaryAdv.SetFilter("Approval Status", '%1|%2|%3|%4|%5', EmpLoan."Approval Status"::"Pending Approval", EmpLoan."Approval Status"::Recommended, EmpLoan."Approval Status"::Reviewed, EmpLoan."Approval Status"::Screened, EmpLoan."Approval Status"::Approved);
        EmpSalaryAdv.SetFilter("Approval Status", '%1|%2', EmpLoan."Approval Status"::"Pending", EmpLoan."Approval Status"::Approved);
        EmpSalaryAdv.SetFilter("No.", '<>%1', EmpLoan."No.");
        EmpSalaryAdv.SetRange(Settled, false);
        //EmpSalaryAdv.SetRange("Loan Type", EmpSalaryAdv."Loan Type"::"Salary Advance");
        EmpSalaryAdv.SetFilter("Loan Type", '%1|%2|%3|%4', EmpSalaryAdv."Loan Type"::"Salary Advance", EmpSalaryAdv."Loan Type"::"Home Loan", EmpSalaryAdv."Loan Type"::"Personal Loan", EmpSalaryAdv."Loan Type"::"Vehicle Loan");
        EmpSalaryAdv.CalcSums(EMI);

        Clear(VehicleLoanEMI);
        if SalaryLevel."Vehicle Loan Limit" = 0 then begin
            Clear(LoanOutstanding);
            LoanOutstanding.SetRange("Employee No.", EmpLoan."Employee Code");
            LoanOutstanding.SetRange("Employee No.", EmpLoan."Employee Code");
            LoanOutstanding.SetRange("Loan Type", LoanOutstanding."Loan Type"::"Vehicle Loan");
            LoanOutstanding.CalcSums(EMI);
            VehicleLoanEMI := LoanOutstanding.EMI;
        end;
        /*
          Homeloan.RESET;
          Homeloan.SETRANGE("Employee Code", "Employee Code");
          Homeloan.SETRANGE("Approval Status", "Approval Status"::Approved);
          Homeloan.SETFILTER("No.", '<>%1', "No.");
          Homeloan.SETRANGE(Settled,FALSE);
          Homeloan.SETRANGE("Loan Type",Homeloan."Loan Type"::"Home Loan");
          Homeloan.SETRANGE("Repayment Mode",Homeloan."Repayment Mode"::"Insurance Tieup");
          Homeloan.CALCSUMS(EMI);
        */

        if (SalaryLevel."Vehicle Loan Limit" <> 0) then begin
            if (EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Vehicle Loan") then
                TotalEMI := EmpSalaryAdv.EMI + PreviosuEMI + EMIPersonalLoan + VehicleLoanEMI + EmpLoan.EMI //+ Homeloan.EMI
            else
                TotalEMI := EmpSalaryAdv.EMI + EmpLoan.EMI + PreviosuEMI + EMIPersonalLoan + VehicleLoanEMI; //+Homeloan.EMI;
        end else
            TotalEMI := EmpSalaryAdv.EMI + EmpLoan.EMI + PreviosuEMI + EMIPersonalLoan + VehicleLoanEMI; //+Homeloan.EMI;

        //all emi + advance / gross
        CheckSalaryLevel.Reset();
        CheckSalaryLevel.SetRange("Senior Officer Level", true);
        CheckSalaryLevel.FindFirst;
        if SalaryLevel.Rank > CheckSalaryLevel.Rank then begin
            EmpLoan."DBR Ratio" := TotalEMI / EmpLoan."Gross Salary" * 100;
            HRSetup.Get;
            if EmpLoan."DBR Ratio" > HRSetup."DBR Ratio" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end else begin
            BelowSOAmt := GetLFAAndDashainAllowance(SalaryLevel, SalaryGrade);
            EmpLoan."DBR Ratio" := TotalEMI / (EmpLoan."Gross Salary" + BelowSOAmt) * 100;
            HRSetup.Get;
            if EmpLoan."DBR Ratio" > HRSetup."Below SO DBR" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end;

    end;

    // local procedure InsertApprover(var EmpLoan: Record "Employee Loan/Advance")//santosh commented 
    // var
    //     EmployeeRec: Record Employee;
    // begin
    //     if EmpLoan.Recommender = '' then begin
    //         Employee.Get(EmpLoan."Employee Code");
    //         EmpLoan.Validate(Recommender, Employee."Approver Code");
    //     end;
    //     if EmpLoan.Approver = '' then begin
    //         HRSetup.Get;
    //         HRSetup.TestField("HR Head Functional Title");
    //         HRSetup.TestField("HR Department Code");
    //         EmployeeRec.Reset;
    //         EmployeeRec.SetRange("Functional Title", HRSetup."HR Head Functional Title");
    //         EmployeeRec.SetRange("Department Code", HRSetup."HR Department Code");
    //         EmployeeRec.SetRange(Status, EmployeeRec.Status::Active); //Min
    //         if EmployeeRec.FindFirst then
    //             EmpLoan.Validate(Approver, EmployeeRec."No.");
    //     end;
    //     /*
    //     UpdateApproval(Employee,
    //                   EmpLoan.Recommender,
    //                   EmpLoan.Approver,
    //                   EmpLoan."Recommender Name",
    //                   EmpLoan."Approver Name",
    //                   FALSE
    //                  );
    //                  */

    // end;

    local procedure InsertAttachmentLines(var EmpLoan: Record "Employee Loan/Advance")
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        AttachmentMandatory.Reset;
        //AttachmentMandatory.SETRANGE("Table ID", DATABASE::"Employee Loan/Advance");
        AttachmentMandatory.SetFilter(Type, Format(EmpLoan."Loan Type"));
        AttachmentMandatory.SetRange("Purpose of Housing Loan", EmpLoan."Purpose of Housing Loan");
        AttachmentMandatory.SetRange(Enhancement, EmpLoan."Loan Enhancement");
        if AttachmentMandatory.FindFirst then
            repeat
                IncomingDocument.Reset;
                IncomingDocument.SetRange("Table ID", DATABASE::"Employee Loan/Advance");
                IncomingDocument.SetRange("No.", EmpLoan."No.");
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := EmpLoan.TableName;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := EmpLoan."No.";
                    IncomingDocument."Employee Code" := EmpLoan."Employee Code";
                    IncomingDocument."Employee Activity Type" := EmpLoan.Type::Loan;
                    IncomingDocument."Table ID" := DATABASE::"Employee Loan/Advance";
                    IncomingDocument.Insert(true);

                end;
            until AttachmentMandatory.Next = 0;
    end;

    procedure GetInterestRate(StartingDate: Date; LoanType: Option " ","Salary Advance","Personal Loan","Home Loan","Vehicle Loan"): Decimal
    begin
        LoanInterest.Reset;
        LoanInterest.SetCurrentKey("Starting Date");
        LoanInterest.SetRange("Starting Date", 0D, StartingDate);
        LoanInterest.SetRange("Loan Type", LoanType);
        if LoanInterest.FindLast then
            exit(LoanInterest."Interest Rate");

        Error('Loan Interest setup not found for %1, Date %2', LoanType, StartingDate);
    end;

    procedure ValidateDocument(var EmpLoan: Record "Employee Loan/Advance"): Boolean
    begin
        if EmpLoan."Applied Loan/Advance" <= 0 then
            Error('Requested Amount must be greater than 0');
        case EmpLoan."Loan Type" of
            EmpLoan."Loan Type"::"Salary Advance":
                SalaryAdvanceValidateDocument(EmpLoan);
            EmpLoan."Loan Type"::"Personal Loan":
                PersonalLoanValidateDocument(EmpLoan);
            EmpLoan."Loan Type"::"Vehicle Loan":
                VehicleLoanValidateDocument(EmpLoan);
            EmpLoan."Loan Type"::"Home Loan":
                HomeLoanValidateDocument(EmpLoan);
            else
                Error('Case not handled.');
        end;
        exit(true)
    end;

    procedure SalaryAdvanceValidateDocument(var EmpLoan: Record "Employee Loan/Advance")
    var
        CheckSalaryLevel: Record "Salary Level";
    begin
        //frequency
        CheckAttachmentMandatory(EmpLoan);
        EmpSalaryAdv.Reset;
        EmpSalaryAdv.SetRange("Employee Code", EmpLoan."Employee Code");
        EmpSalaryAdv.SetRange("Loan Type", EmpSalaryAdv."Loan Type"::"Salary Advance");
        EmpSalaryAdv.SetRange("Approval Status", EmpSalaryAdv."Approval Status"::Approved);
        EmpSalaryAdv.SetRange(Settled, false);
        if EmpSalaryAdv.FindFirst then
            Error('Please settle Salary Advance of No. %1', EmpSalaryAdv."No.");

        Clear(EmpSalaryAdv);
        //EmpSalaryAdv.RESET;
        EmpSalaryAdv.SetRange("Employee Code", EmpLoan."Employee Code");
        EmpSalaryAdv.SetRange("Approval Status", EmpLoan."Approval Status"::Approved);
        EmpSalaryAdv.SetRange(FY, EmpLoan.FY);
        EmpSalaryAdv.SetFilter("No.", '<>%1', EmpLoan."No.");
        EmpSalaryAdv.SetRange("Loan Type", EmpSalaryAdv."Loan Type"::"Salary Advance");
        EmpLoan.Frequency := EmpSalaryAdv.Count + 1;
        HRSetup.Get;
        HRSetup.TestField("Max. no. of Salary Adv. in FY");
        if EmpLoan.Frequency > HRSetup."Max. no. of Salary Adv. in FY" then
            Error('No. of advance exceeded for this FY.');
        HRSetup.TestField("Max Adv. Salary Payback Month");
        if (EmpLoan."Payback Months" > HRSetup."Max Adv. Salary Payback Month") or (EmpLoan."Payback Months" < 1) then
            Error('Payback months must be between 1 to %1', HRSetup."Max Adv. Salary Payback Month");
        Employee.Get(EmpLoan."Employee Code");
        if Employee."Employment Type" <> Employee."Employment Type"::Permanent then
            Error('Employee %1 must be permanent.', Employee.FullName);

        if SalaryLevel.Get(Employee."Salary Level") then;

        CheckSalaryLevel.Reset();
        CheckSalaryLevel.SetRange("Senior Officer Level", true);
        CheckSalaryLevel.FindFirst;
        if SalaryLevel.Rank > CheckSalaryLevel.Rank then begin
            if EmpLoan."DBR Ratio" > HRSetup."DBR Ratio" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end else begin
            if EmpLoan."DBR Ratio" > HRSetup."Below SO DBR" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end;
        //MODIFY;
    end;

    procedure PersonalLoanValidateDocument(var EmpLoan: Record "Employee Loan/Advance")
    var
        CheckSalaryLevel: Record "Salary Level";
    begin
        HRSetup.Get;
        EmpLoan.TestField("Purpose of Loan");
        if EmpLoan."Confirmation Service Period" < HRSetup."Home Loan Confirmation Period" then
            Error('Employee not eligible as service period is less than %1 year.', HRSetup."Home Loan Confirmation Period");
        CheckAttachmentMandatory(EmpLoan);


        if SalaryLevel.Get(Employee."Salary Level") then;

        CheckSalaryLevel.Reset();
        CheckSalaryLevel.SetRange("Senior Officer Level", true);
        CheckSalaryLevel.FindFirst;
        if SalaryLevel.Rank > CheckSalaryLevel.Rank then begin
            if EmpLoan."DBR Ratio" > HRSetup."DBR Ratio" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end else begin
            if EmpLoan."DBR Ratio" > HRSetup."Below SO DBR" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end;

        //MESSAGE('All Good.');
    end;

    local procedure VehicleLoanValidateDocument(var EmpLoan: Record "Employee Loan/Advance")
    var
        SeniorOffierSalLevel: Record "Salary Level";
        LoanOutstandingfromFinacle: Record "Loan Outstanding from Finacle";
        EmployeeLoan: Record "Employee Loan/Advance";
        CheckSalaryLevel: Record "Salary Level";
    begin
        HRSetup.Get;
        EmpLoan.TestField("Vehicle Purchase Type");
        EmpLoan.TestField("Purpose of Loan");

        if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Vehicle Loan" then begin
            LoanOutstandingfromFinacle.Reset;
            LoanOutstandingfromFinacle.SetRange("Employee No.", EmpLoan."Employee Code");
            LoanOutstandingfromFinacle.SetRange("Loan Type", LoanOutstandingfromFinacle."Loan Type"::"Vehicle Loan");
            LoanOutstandingfromFinacle.SetFilter("Outstanding Amount", '<>%1', 0);
            if LoanOutstandingfromFinacle.FindFirst then
                Error('Vehicle loan cannot be submitted. There is already outstanding amount for previous vehicle loan %1.',
                          LoanOutstandingfromFinacle."Account ID");
        end;

        EmployeeLoan.Reset;
        EmployeeLoan.SetRange("Employee Code", EmpLoan."Employee Code");
        EmployeeLoan.SetRange("Loan Type", EmployeeLoan."Loan Type"::"Vehicle Loan");
        EmployeeLoan.SetRange("Approval Status", EmployeeLoan."Approval Status"::Approved);
        EmployeeLoan.SetRange(Settled, false);
        if EmployeeLoan.FindFirst then
            Error('Please settle previous vehicle loan first.');
        CheckRankforEmployeeLoan(EmpLoan);
        //TESTFIELD("Vehicle Loan Type");
        if EmpLoan."Vehicle Loan Type" = EmpLoan."Vehicle Loan Type"::" " then
            Error('Vechicle Loan Type must have value.');

        // IF "Repayment Period" > HRSetup."V.loan Repay. Limit SO or more" THEN
        // ERROR('Invalid Repayment Period.');
        EmpLoan.TestField("Name of Supplier");
        EmpLoan.TestField("Cost of Vehicle");

        CheckAttachmentMandatory(EmpLoan);

        if SalaryLevel.Get(Employee."Salary Level") then;

        CheckSalaryLevel.Reset();
        CheckSalaryLevel.SetRange("Senior Officer Level", true);
        CheckSalaryLevel.FindFirst;
        if SalaryLevel.Rank > CheckSalaryLevel.Rank then begin
            if EmpLoan."DBR Ratio" > HRSetup."DBR Ratio" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end else begin
            if EmpLoan."DBR Ratio" > HRSetup."Below SO DBR" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end;
        //MESSAGE('All Good.');
    end;

    local procedure HomeLoanValidateDocument(var EmpLoan: Record "Employee Loan/Advance")
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
        InsurancePremiumSetup: Record "Insurance Premium Setup";
        CheckSalaryLevel: Record "Salary Level";
    begin
        if EmpLoan."Purpose of Housing Loan" = EmpLoan."Purpose of Housing Loan"::" " then
            Error('Purpose of housing loan must have value.');
        if EmpLoan."Repayment Mode" = EmpLoan."Repayment Mode"::" " then
            Error('Repayment mode must have value.');
        //TESTFIELD("Purpose of Housing Loan");
        //TESTFIELD("Repayment Mode");
        if EmpLoan."Repayment Mode" = EmpLoan."Repayment Mode"::"Insurance Tieup" then begin
            EmpLoan.TestField("Insurance Tieup");
            EmpLoan.TestField(Age);
            InsurancePremiumSetup.Reset;
            //InsurancePremiumSetup.SetRange("Insurance Company", EmpLoan."Insurance Tieup");
            InsurancePremiumSetup.SetRange(Age, EmpLoan.Age);
            InsurancePremiumSetup.SetRange(Period, EmpLoan."Repayment Period");
            if not InsurancePremiumSetup.FindFirst then
                Error('Premium Setup is not available for this insurance company. Please contact HR department.');
        end;
        EmpLoan.TestField("Property in the name of");
        EmpLoan.TestField("Address of Owner");
        Employee.Get(EmpLoan."Employee Code");
        if Employee."Marital Status" = Employee."Marital Status"::Married then
            EmpLoan.TestField("Name of Spouse");
        EmpLoan.TestField("Name of Owner");
        EmpLoan.TestField("Area Format");
        EmpLoan.TestField("Area of Plot");
        CheckAttachmentMandatory(EmpLoan);

        //IF "Confirmation Service Period"< 1 THEN
        //      ERROR('Total service period is not sufficient.');
        HRSetup.Get;
        //check board approval
        if EmpLoan."Approved By Board" then begin
            AttachmentSetup.Reset;
            AttachmentSetup.SetRange("Board Approval", true);
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Home Loan");
            if AttachmentSetup.Find('-') then
                repeat
                    IncomingDoc.Reset;
                    IncomingDoc.SetRange("No.", EmpLoan."No.");
                    if IncomingDoc.FindFirst then
                        if IncomingDoc."File Name" = '' then
                            Error('Please upload attachment of %1', IncomingDoc."Attachment Code");
                until AttachmentSetup.Next = 0;
        end else
            if EmpLoan."Confirmation Service Period" < HRSetup."Home Loan Confirmation Period" then
                Error('Employee not eligible as service period is less than %1 year.', HRSetup."Home Loan Confirmation Period");

        if SalaryLevel.Get(Employee."Salary Level") then;

        CheckSalaryLevel.Reset();
        CheckSalaryLevel.SetRange("Senior Officer Level", true);
        CheckSalaryLevel.FindFirst;
        if SalaryLevel.Rank > CheckSalaryLevel.Rank then begin
            if EmpLoan."DBR Ratio" > HRSetup."DBR Ratio" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end else begin
            if EmpLoan."DBR Ratio" > HRSetup."Below SO DBR" then
                Error('DBR Ratio %1 exceeded.', EmpLoan."DBR Ratio");
        end;

        if EmpLoan."Repayment Period" > HRSetup."Home/Persona Loan Repay Period" then
            Error('Invalid Repayment Period.');
    end;

    local procedure GetEmployeeCode(): Code[20]
    var
        Employee: Record Employee;
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then
            exit(Employee."No.");
    end;

    local procedure GetExistingLoanAmount(EmployeeCode: Code[20]; LoanType: Enum "Loan Type"; "No.": Code[20]): Decimal
    var
        PreviousLoan: Record "Employee Loan/Advance";
        LoanOutstanding: Record "Loan Outstanding from Finacle";
    begin
        if LoanType = LoanType::"Home Loan" then begin
            LoanOutstanding.Reset;
            LoanOutstanding.SetRange("Employee No.", EmployeeCode);
            LoanOutstanding.SetFilter("Loan Type", '%1|%2', LoanOutstanding."Loan Type"::"Home Loan Insurance Tieup", LoanOutstanding."Loan Type"::"Home Loan");
            LoanOutstanding.CalcSums("Outstanding Amount");
            exit(Abs(LoanOutstanding."Outstanding Amount"));
        end else if LoanType = LoanType::"Personal Loan" then begin
            LoanOutstanding.Reset;
            LoanOutstanding.SetRange("Employee No.", EmployeeCode);
            LoanOutstanding.SetRange("Loan Type", LoanType);
            LoanOutstanding.CalcSums("Loan Limit");
            exit(LoanOutstanding."Loan Limit");
        end else if LoanType = LoanType::"Vehicle Loan" then begin
            LoanOutstanding.Reset;
            LoanOutstanding.SetRange("Employee No.", EmployeeCode);
            LoanOutstanding.SetRange("Loan Type", LoanOutstanding."Loan Type"::"Vehicle Loan");
            LoanOutstanding.CalcSums("Outstanding Amount");
            exit(Abs(LoanOutstanding."Outstanding Amount"));
        end;
    end;

    local procedure CheckEligibilityforLoanReapplication(EmployeeCode: Code[20]; LoanType: Option; EntryNo: Integer)
    var
        PreviousLoan: Record "Employee Loan/Advance";
    begin
        PreviousLoan.Reset;
        PreviousLoan.SetRange("Employee Code", EmployeeCode);
        PreviousLoan.SetRange("Approval Status", PreviousLoan."Approval Status"::Approved);
        PreviousLoan.SetRange(Disbursed, true);
        PreviousLoan.SetRange(Settled, true);
        if PreviousLoan.FindLast then begin
            if Today < CalcDate('<5Y>', PreviousLoan."Disbursement Date") then
                Error(VehicleLoanReapplyErr);
        end;
    end;

    procedure SettleAdvance(EmpLoanAdv: Record "Employee Loan/Advance")
    begin
        EmpLoanAdv.TestField("Approval Status", EmpLoanAdv."Approval Status"::Approved);
        Employee.Get(HRMgt.GetEmployeeNo);
        // Employee.TestField(Screener);
        EmpLoanAdv.TestField(Settled, false);
        EmpLoanAdv.Validate(Settled, true);
        EmpLoanAdv.Validate("Settlement Date", Today);
        EmpLoanAdv.Validate("Settler User ID", UserId);
        EmpLoanAdv.Modify;
        Message('Settlement has been updated of %1.', EmpLoanAdv."Employee Name");
    end;

    procedure NewSalaryAdvanceCheck(EmpCode: Code[20])
    var
        EmpSalAvd: Record "Employee Loan/Advance";
    begin
        EmpSalAvd.Reset;
        EmpSalAvd.SetRange("Employee Code", EmpCode);
        EmpSalAvd.SetRange("Loan Type", EmpSalAvd."Loan Type"::"Salary Advance");
        EmpSalAvd.SetFilter("Approval Status", '%1|%2', EmpSalAvd."Approval Status"::Approved, EmpSalAvd."Approval Status"::Pending);
        EmpSalAvd.SetRange(Settled, false);
        if EmpSalAvd.FindFirst then begin
            // if (EmpSalAvd."Approval Status" <> EmpSalAvd."Approval Status"::Rejected)
            //   or (EmpSalAvd."Approval Status" <> EmpSalAvd."Approval Status"::Canceled) then
            //     if not EmpSalAvd.Settled then
            Error('Please settle the existing salary advance. %1', EmpSalAvd."No.");
        end;
    end;

    procedure GetLFAAndDashainAllowance(SalLevel: Record "Salary Level"; SalGrade: Record "Salary Grade"): Decimal
    var
        LevelwiseAttribute: Record "Level Wise Attributes";
    begin
        if LevelwiseAttribute.Get(SalGrade.Code, SalLevel.Code) then begin
            exit((2 * LevelwiseAttribute."Total Basic Salary" + LevelwiseAttribute.Allowance) / 12);
        end;
    end;

    local procedure "-------loan approval----"()
    begin
    end;

    procedure SendApprovaLoan(var EmpLoan: Record "Employee Loan/Advance"; SendCancelBool: Boolean)
    var
        CONFIRMATION: Label 'Do you want to proceed?';
        EmpLoan1: Record "Employee Loan/Advance";
        LoanMgt: Codeunit "Loan Mgt.";
        APPROVALSENT: Label 'Approval request has been sent.';
        APPROVALCANCELLED: Label 'Approval request has been cancelled.';
        APPROVED: Label 'Document is approved.';
        APPROVALERROR: Label 'Approval status must be open.';
    begin
        if GuiAllowed then
            if not Confirm(CONFIRMATION, false) then
                exit;

        HRSetup.Get;
        // Employee.Reset;
        // Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        // Employee.SetRange(Status, Employee.Status::Active); //Min
        // if Employee.FindFirst then;
        // EmpLoan.Validate(Approver, Employee."No.");
        // if not GuiAllowed then begin

        //     EmpLoan.Validate(Recommender);
        // end;
        Clear(Employee);
        Employee.Get(EmpLoan."Employee Code");

        EmpLoan."Requested Loan Date" := Today;

        EmpLoan1.Reset;
        EmpLoan1.SetRange("Employee Code", EmpLoan."Employee Code");
        EmpLoan1.SetFilter("Approval Status", '%1', EmpLoan1."Approval Status"::Pending);
        if EmpLoan1.FindFirst then
            Error(LoanError, EmpLoan1."No.");

        SalaryLevel.Get(EmpLoan."Job Title");
        //control
        if SendCancelBool then
            ValidateDocument(EmpLoan);
        CalculateEligibleLoanAmount(EmpLoan);
        CalculateEMI(EmpLoan);
        CalculateDBR(EmpLoan, SalaryLevel);
        // if EmpLoan.Recommender = '' then
        //     Error('Recommender must not be blank.');


        if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Approved then
            Error(APPROVED);
        //action
        if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Salary Advance" then
            EmpLoan.TestField("Purpose of Advance Salary");
        if SendCancelBool then begin
            if not (EmpLoan."Approval Status" in [EmpLoan."Approval Status"::" ", EmpLoan."Approval Status"::Open]) then
                Error(APPROVALERROR);
            EmpLoan."Approval Status" := EmpLoan."Approval Status"::Pending;
            // if EmpLoan.Recommender = '' then
            //     EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Recommended)
            // else
            //     EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::"Pending Approval");
            EmpLoan.Modify();
            Message(APPROVALSENT);
        end else begin
            EmpLoan.TestField("Approval Status", EmpLoan."Approval Status"::"Pending");
            EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Open);
            EmpLoan.Modify();
            Message(APPROVALCANCELLED);
        end;


        HRMgt.SendMailFromTemplate(DATABASE::"Employee Loan/Advance", 0, EmpLoan."Approval Status", '', EmpLoan."Employee Code", Format(EmpLoan."No."), 0);
    end;

    procedure VerifyLoan(var EmpLoan: Record "Employee Loan/Advance")
    var
        Verified: Label 'Document verified.';
        AlreadyVerified: Label 'Document already verfied.';
    begin
        //screen commented santosh
        // Employee.Get(GetEmployeeCode);
        // Employee.TestField(Screener);

        // EmpLoan.TestField("Approval Status", EmpLoan."Approval Status"::Recommended);
        // if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Screened then
        //     Error(AlreadyVerified);
        // EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Screened);
        // EmpLoan.Validate("Screened Date", Today);
        // EmpLoan.Screener := Employee."No.";
        // EmpLoan.Modify;
        // Message(Verified);
    end;

    // procedure ApproveRejectLoan(var EmpLoan: Record "Employee Loan/Advance"; Approve: Boolean)
    // var
    //     Confirmation: Label 'Confirm action?';
    //     Approved: Label 'Document is approved.';
    // begin
    //     if GuiAllowed then
    //         if not Confirm(Confirmation, false) then
    //             exit;
    //     //control
    //     if Approve then
    //         ValidateDocument(EmpLoan);
    // if not Approve then
    //     EmpLoan.TestField("Rejection Remark")
    // else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Approved then
    //     Error(Approved);
    // commented by santosh
    // check approver
    // CheckLoanApproval(EmpLoan);
    //action
    // if Approve then begin
    //     if EmpLoan."Approval Status" = EmpLoan."Approval Status"::"Pending Approval" then begin
    //         if EmpLoan."Recommendation Remarks" = '' then
    //             Error('Recommendation remarks must have value');
    //         EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Recommended)
    //     end else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Screened then begin
    //         EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Approved);
    //         if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Salary Advance" then
    //             EmpLoan.Validate("Remaining Amount", EmpLoan."Applied Loan/Advance");
    //     end else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Recommended then
    //             Error('Please verfiy loan first.');
    // end else begin
    //     if EmpLoan."Rejection Remark" = '' then
    //         Error('Rejection Remarks must have value.');
    //     if EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Recommended, EmpLoan."Approval Status"::Approved] then begin
    //         Employee.Get(HRMgt.GetEmployeeNo);
    //         if not Employee.Screener then
    //             Error('You are not eligble to reject this document.');
    //     end;

    //     EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Rejected);

    // end;
    //         EmpLoan."Approved Date" := Today;
    //         //VALIDATE("Employee Code",HRMgt.GetEmployeeNo);
    //         EmpLoan.Modify();

    //         HRMgt.SendMailFromTemplate(DATABASE::"Employee Loan/Advance", 0, EmpLoan."Approval Status", '', GetEmployeeCode(), Format(EmpLoan."No."), 0);
    //     end;

    // procedure ApproveRejectLoanAPI(var EmpLoan: Record "Employee Loan/Advance"; Approve: Boolean; ApproverNo: code[20])
    // var
    //     Confirmation: Label 'Confirm action?';
    //     Approved: Label 'Document is approved.';
    // begin
    //     if GuiAllowed then
    //         if not Confirm(Confirmation, false) then
    //             exit;

    //     //control
    //     if Approve then
    //         ValidateDocument(EmpLoan);


    //     if not Approve then
    //         EmpLoan.TestField("Rejection Remark")
    //     else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Approved then
    //         Error(Approved);

    //     //check approver
    //     CheckLoanApprovalAPI(EmpLoan, ApproverNo);
    //     //action
    //     if Approve then begin
    //         if EmpLoan."Approval Status" = EmpLoan."Approval Status"::"Pending Approval" then begin
    //             if EmpLoan."Recommendation Remarks" = '' then
    //                 Error('Recommendation remarks must have value');
    //             EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Recommended)
    //         end else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Screened then begin
    //             EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Approved);
    //             if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Salary Advance" then
    //                 EmpLoan.Validate("Remaining Amount", EmpLoan."Applied Loan/Advance");
    //         end else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Recommended then
    //                 Error('Please verfiy loan first.');
    //     end else begin
    //         if EmpLoan."Rejection Remark" = '' then
    //             Error('Rejection Remarks must have value.');
    //         if EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Recommended, EmpLoan."Approval Status"::Approved] then begin
    //             Employee.Get(HRMgt.GetEmployeeNo);
    //             if not Employee.Screener then
    //                 Error('You are not eligble to reject this document.');
    //         end;

    //         EmpLoan.Validate("Approval Status", EmpLoan."Approval Status"::Rejected);

    //     end;
    //     EmpLoan."Approved Date" := Today;
    //     //VALIDATE("Employee Code",HRMgt.GetEmployeeNo);
    //     EmpLoan.Modify();

    //     HRMgt.SendMailFromTemplate(DATABASE::"Employee Loan/Advance", 0, EmpLoan."Approval Status", '', GetEmployeeCode(), Format(EmpLoan."No."), 0);
    // end;

    local procedure "------update approver------"()
    begin
    end;

    procedure UpdateApproval(var Employee: Record Employee; var Recommender: Code[150]; var Approver: Code[150]; var RecommenderName: Text; var ApproverName: Text; IsTest: Boolean)
    var
        FunctionalTitle: Record "Functional Title";
        FunctionalTitle1: Record "Functional Title";
        EmployeeRec: Record Employee;
    begin
        FunctionalTitle.Get(Employee."Functional Title");

        RecommendedBy := '';
        RecommendedByName := '';
        ApprovedBy := '';
        ApprovedByName := '';
        LastRankValue := 0;
        if Employee."Global Dimension 1 Code" <> '' then //branch
            ValidateApprover(Employee, true, false, false, false, false, false, false, false, false);

        if (not HasRecommender) or (not HasApprover) then  //subprovince
            // if Employee."Sub Province Code" <> '' then
            //     ValidateApprover(Employee, false, true, false, false, false, false, false, false, false);

        if (not HasRecommender) or (not HasApprover) then  //province
                if Employee."Province Code" <> 'REGO' then
                    ValidateApprover(Employee, false, false, true, false, false, false, false, false, false);

        if (not HasRecommender) or (not HasApprover) then  //unit wise
            if Employee."Unit Code" <> '' then
                ValidateApprover(Employee, false, false, false, true, false, false, false, false, false);

        if (not HasRecommender) or (not HasApprover) then  //department
            if Employee."Department Code" <> '' then
                ValidateApprover(Employee, false, false, false, false, true, false, false, false, false);

        // if (not HasRecommender) or (not HasApprover) then  //reporting line 1
        //     if Employee."Reporting Line 1" <> '' then
        //         ValidateApprover(Employee, false, false, false, false, false, true, false, false, false);

        // if (not HasRecommender) or (not HasApprover) then  //reportin line 2
        //     if Employee."Reporting Line 2" <> '' then
        //         ValidateApprover(Employee, false, false, false, false, false, false, true, false, false);

        // if (not HasRecommender) or (not HasApprover) then   //ecosystem
        //     if Employee."Eco-System" <> '' then
        //         ValidateApprover(Employee, false, false, false, false, false, false, false, true, false);

        // if (not HasRecommender) or (not HasApprover) then  //office
        //     if Employee.Office <> '' then
        //         ValidateApprover(Employee, false, false, false, false, false, false, false, false, true);

        if ApprovedBy = '' then begin
            ApprovedBy := RecommendedBy;
            RecommendedBy := '';
            ApprovedByName := RecommendedByName;
            RecommenderName := '';
        end;



        if RecommendedBy <> '' then begin
            Recommender := CopyStr(RecommendedBy, 2, 150);
            RecommenderName := CopyStr(RecommendedByName, 2, 250);
        end;
        if ApprovedBy <> '' then begin
            Approver := CopyStr(ApprovedBy, 2, 150);
            ApproverName := CopyStr(ApprovedByName, 2, 250);
        end;
        if Recommender = Approver then begin
            Recommender := '';
            RecommenderName := '';
        end;

        if IsTest then
            Message(StrSubstNo('Employee: %1, %2, %3, %4\Recommender:\ %5\ %6\\Approver:\ %7\ %8\\Recommender %9\Approver %10',
                    Employee."No.", Employee."Full Name", Employee."Functional Title", FunctionalTitle."Rank Value",
                    Recommender, RecommenderName,
                    Approver, ApproverName,
                    From1,
                    From2

                    )
                    );
    end;

    procedure ValidateApprover(var Employee: Record Employee; Branchwise: Boolean; SubProvinceWise: Boolean; Provincewise: Boolean; Unitwise: Boolean; Departmentwise: Boolean; ReportingLine1wise: Boolean; ReportingLine2wise: Boolean; EcoSystemwise: Boolean; Officewise: Boolean)
    var
        FunctionalTitle: Record "Functional Title";
        FunctionalTitle1: Record "Functional Title";
        EmployeeRec: Record Employee;
    begin
        FunctionalTitle.Get(Employee."Functional Title");

        //extra control
        /*
        IF FindApprover AND (HasRecommender OR HasApprover) AND FindRecommender THEN
          IF FunctionalTitle.Code = 'COSPO' THEN//cospo
            EXIT;
          */
        if (FunctionalTitle."Rank Value" >= 100) and HasRecommender and (RecommendedBy <> '') then
            exit;

        if FunctionalTitle."Rank Value" > LastRankValue then
            LastRankValue := FunctionalTitle."Rank Value";

        FunctionalTitle1.Reset;
        FunctionalTitle1.SetCurrentKey("Rank Value");
        FunctionalTitle1.SetFilter("Rank Value", '>%1', LastRankValue);
        if FunctionalTitle."Rank Check Range" <> '' then
            FunctionalTitle1.SetFilter("Rank Value", FunctionalTitle."Rank Check Range");

        if FunctionalTitle1.FindFirst then
            repeat

                GotRecord := false;
                EmployeeRec.Reset;
                EmployeeRec.SetRange("Functional Title", FunctionalTitle1.Code);
                if Branchwise or FunctionalTitle."Check Branchwise Only" then
                    EmployeeRec.SetRange("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
                if SubProvinceWise then begin

                    //EmployeeRec.SETFILTER("Global Dimension 1 Code", '%1|%2', '',Employee."Global Dimension 1 Code");
                    if FunctionalTitle."Rank Value" = 0 then
                        EmployeeRec.SetRange("Global Dimension 1 Code", '');
                    // EmployeeRec.SetRange("Sub Province Code", Employee."Sub Province Code");
                end;
                if Provincewise then begin
                    /*
                    IF FunctionalTitle."Rank Value" =0 THEN //IDE, subprovince staff with no cospo , acospo
                      EmployeeRec.SETRANGE("Global Dimension 1 Code", '');
                      */
                    //EmployeeRec.SETFILTER("Global Dimension 1 Code", '%1|%2', '',Employee."Global Dimension 1 Code");
                    if Employee."Province Code" <> 'REGO' then
                        HasRecommender := true; //direct approver
                                                // EmployeeRec.SetFilter("Sub Province Code", '%1|%2', '', Employee."Sub Province Code"); //mess
                                                //EmployeeRec.SETRANGE("Post Code", Employee."Post Code");
                    EmployeeRec.SetRange("Province Code", Employee."Province Code");
                end;
                if Unitwise then begin
                    EmployeeRec.SetFilter("Global Dimension 1 Code", '%1|%2', '', Employee."Global Dimension 1 Code");
                    // EmployeeRec.SetFilter("Sub Province Code", '%1|%2', '', Employee."Sub Province Code");
                    EmployeeRec.SetFilter("Province Code", '%1|%2|%3', '', Employee."Province Code", 'REGO');
                    EmployeeRec.SetRange("Unit Code", Employee."Unit Code");
                end;

                if Departmentwise then begin
                    HasApprover := true; //for
                    EmployeeRec.SetFilter("Global Dimension 1 Code", '%1|%2', '', Employee."Global Dimension 1 Code");
                    // EmployeeRec.SetFilter("Sub Province Code", '%1|%2', '', Employee."Sub Province Code");
                    EmployeeRec.SetFilter("Province Code", '%1|%2|%3', '', Employee."Province Code", 'REGO');
                    EmployeeRec.SetFilter("Unit Code", '%1|%2', '', Employee."Unit Code");
                    EmployeeRec.SetRange("Department Code", Employee."Department Code");
                end;
                // if ReportingLine1wise then begin
                //     EmployeeRec.SetFilter("Unit Code", '%1|%2', '', Employee."Unit Code");
                //     EmployeeRec.SetFilter("Department Code", '%1|%2', '', Employee."Department Code");
                //     EmployeeRec.SetRange("Reporting Line 1", Employee."Reporting Line 1");
                // end;
                // if ReportingLine2wise then begin
                //     EmployeeRec.SetFilter("Unit Code", '%1|%2', '', Employee."Unit Code");
                //     EmployeeRec.SetFilter("Department Code", '%1|%2', '', Employee."Department Code");
                //     EmployeeRec.SetFilter("Reporting Line 1", '%1|%2', '', Employee."Reporting Line 1");
                //     EmployeeRec.SetRange("Reporting Line 2", Employee."Reporting Line 2");
                // end;

                // if EcoSystemwise then begin
                //     EmployeeRec.SetFilter("Province Code", '%1|%2|%3', '', Employee."Province Code", 'REGO'); // cospo
                //     // EmployeeRec.SetFilter("Sub Province Code", '%1|%2', '', Employee."Sub Province Code"); //cospo
                //     EmployeeRec.SetFilter("Unit Code", '%1|%2', '', Employee."Unit Code");
                //     EmployeeRec.SetFilter("Department Code", '%1|%2', '', Employee."Department Code");
                //     EmployeeRec.SetFilter("Reporting Line 1", '%1|%2', '', Employee."Reporting Line 1");
                //     EmployeeRec.SetFilter("Reporting Line 2", '%1|%2', '', Employee."Reporting Line 2");
                //     EmployeeRec.SetRange("Eco-System", Employee."Eco-System");
                // end;
                // if Officewise then begin
                //     EmployeeRec.SetFilter("Unit Code", '%1|%2', '', Employee."Unit Code");
                //     EmployeeRec.SetFilter("Department Code", '%1|%2', '', Employee."Department Code");
                //     EmployeeRec.SetFilter("Reporting Line 1", '%1|%2', '', Employee."Reporting Line 1");
                //     EmployeeRec.SetFilter("Reporting Line 2", '%1|%2', '', Employee."Reporting Line 2");
                //     EmployeeRec.SetFilter("Eco-System", '%1|%2', '', Employee."Eco-System");
                //     EmployeeRec.SetRange(Office, Employee.Office);
                // end;

                if EmployeeRec.FindFirst then
                    repeat

                        if (FunctionalTitle."Rank Value" > 130) and HasRecommender then begin
                            FindRecommender := true;
                            exit;
                        end;

                        GotRecord := true;

                        LastRankValue := FunctionalTitle1."Rank Value";

                        if not HasRecommender then begin
                            RecommendedBy += '|' + EmployeeRec."No.";
                            RecommendedByName += '|' + EmployeeRec."Full Name";
                            From1 := StrSubstNo('Branch %1\SubProvince %2\ Province %3\Unit %4\Department %5\Reporting line 1 %6\Reporting line 2 %7\Eco system %8\Office %9',
                                    Branchwise, SubProvinceWise, Provincewise, Unitwise, Departmentwise, ReportingLine1wise, ReportingLine2wise, EcoSystemwise, Officewise);

                        end else if not HasApprover then begin
                            ApprovedBy += '|' + EmployeeRec."No.";
                            ApprovedByName += '|' + EmployeeRec."Full Name";
                            From2 := StrSubstNo('Branch %1\SubProvince %2\ Province %3\Unit %4\Department %5\Reporting line 1 %6\Reporting line 2 %7\Eco system %8\Office %9',
                                    Branchwise, SubProvinceWise, Provincewise, Unitwise, Departmentwise, ReportingLine1wise, ReportingLine2wise, EcoSystemwise, Officewise);

                        end;
                    until EmployeeRec.Next = 0;



                if GotRecord then begin
                    if FunctionalTitle1."Rank Value" >= 160 then
                        HasApprover := true;
                    if not HasRecommender then
                        HasRecommender := true
                    else
                        HasApprover := true;
                end;



                if HasRecommender and HasApprover then
                    ReadyExit := true;


            until (FunctionalTitle1.Next = 0) or (ReadyExit);



        if FindRecommender then
            FindApprover := true;
        FindRecommender := true;

    end;

    local procedure "------allowance approval-----"()
    begin
    end;

    // local procedure CheckLoanApproval(var EmpLoan: Record "Employee Loan/Advance")
    // var
    //     ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    //     RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    // begin
    //     if EmpLoan."Approval Status" = EmpLoan."Approval Status"::"Pending Approval" then begin
    //         if StrPos(EmpLoan.Recommender, GetEmployeeCode()) = 0 then
    //             Error(RecommendNotEligibleError);
    //     end else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Screened then begin
    //         HRSetup.Get;
    //         if StrPos(EmpLoan.Approver, GetEmployeeCode()) = 0 then
    //             Error(ApproveNotEligibleError);
    //     end;
    // end;

    // local procedure CheckLoanApprovalAPI(var EmpLoan: Record "Employee Loan/Advance"; ApprovalCode: Code[20])
    // var
    //     ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    //     RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    // begin
    //     if EmpLoan."Approval Status" = EmpLoan."Approval Status"::"Pending Approval" then begin
    //         if StrPos(EmpLoan.Recommender, ApprovalCode) = 0 then
    //             Error(RecommendNotEligibleError);
    //     end else if EmpLoan."Approval Status" = EmpLoan."Approval Status"::Screened then begin
    //         HRSetup.Get;
    //         if StrPos(EmpLoan.Approver, ApprovalCode) = 0 then
    //             Error(ApproveNotEligibleError);
    //     end;
    // end;

    local procedure CheckAttachmentMandatory(var EmpLoan: Record "Employee Loan/Advance")
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin

        IncomingDocument.Reset;
        IncomingDocument.SetRange("No.", EmpLoan."No.");
        IncomingDocument.SetRange("Table ID", DATABASE::"Employee Loan/Advance");
        IncomingDocument.SetRange("File Name", '');
        if IncomingDocument.FindFirst then
            repeat
                AttachmentSetup.Reset;
                //AttachmentSetup.SETRANGE("Table ID", DATABASE::"Employee Loan/Advance");
                AttachmentSetup.SetRange(Mandatory, true);
                //AttachmentSetup.SetRange(Type, EmpLoan."Loan Type");
                //IF EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Home Loan" THEN
                // AttachmentSetup.SETFILTER("Purpose of Housing Loan",'%1|%2',AttachmentSetup."Purpose of Housing Loan",AttachmentSetup."Purpose of Housing Loan"::" ");
                AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
                if AttachmentSetup.FindFirst then begin
                    Error('Upload attachment for %1', IncomingDocument."Attachment Code");
                end;
            until IncomingDocument.Next = 0;
    end;

    local procedure "-----------loan open------------"()
    begin
    end;

    procedure OpenLoan(No: Code[20]; Type: Enum "Loan Type")
    var
        EmpLoanAdvance: Record "Employee Loan/Advance";
    begin
        EmpLoanAdvance.Reset;
        EmpLoanAdvance.SetRange("Loan Type", Type);
        EmpLoanAdvance.SetRange("Employee Code", No);
        EmpLoanAdvance.SetFilter("Approval Status", '%1|%2', EmpLoanAdvance."Approval Status"::" ",
                          EmpLoanAdvance."Approval Status"::Open);
        if not EmpLoanAdvance.FindFirst then begin
            Employee.Get(No);
            EmpLoanAdvance.Init;
            EmpLoanAdvance.Validate("Loan Type", Type);
            EmpLoanAdvance.Validate("Employee Code", No);
            EmpLoanAdvance.Validate("Employee Name in Nepali", Employee."Full Name (Nepali)");
            EmpLoanAdvance.Validate("Father's Name In Nepali", Employee."Father's Name (Nepali)");
            EmpLoanAdvance.Validate("Grandfather's Name In Nepali", Employee."GrandFather's Name (Nepali)");
            EmpLoanAdvance.Validate("Approval Status", EmpLoanAdvance."Approval Status"::"Pending");
            EmpLoanAdvance.Insert(true);
        end;

        case Type of
            Type::"Salary Advance":
                PAGE.Run(PAGE::"Employee Salary Advance Card", EmpLoanAdvance);
            Type::"Home Loan":
                PAGE.Run(PAGE::"Employee Home Loan Card", EmpLoanAdvance);
            Type::"Personal Loan":
                PAGE.Run(PAGE::"Employee Personal Loan Card", EmpLoanAdvance);
            Type::"Vehicle Loan":
                PAGE.Run(PAGE::"Employee Vehicle Loan Card", EmpLoanAdvance);
        end;
    end;

    procedure CheckRankforEmployeeLoan(EmpLoan: Record "Employee Loan/Advance")
    var
        SeniorOffierSalLevel: Record "Salary Level";
    begin
        HRSetup.Get;
        if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Vehicle Loan" then begin
            if EmpLoan."Repayment Period" > HRSetup."Max. Veh. Loan Repay Period" then
                Error('Repayment period cannot be greater than %1 years for Vehicle Loan.', HRSetup."Max. Veh. Loan Repay Period");
            SeniorOffierSalLevel.Reset;
            SeniorOffierSalLevel.SetRange("Senior Officer Level", true);
            if SeniorOffierSalLevel.FindFirst then;
            SalaryLevel.Get(EmpLoan."Job Title");
            if SalaryLevel.Rank > SeniorOffierSalLevel.Rank then begin
                if HRSetup."V.loan Repay. Limit above SO" < EmpLoan."Repayment Period" then
                    Error('Repayment period must be less or equal to %1', HRSetup."V.loan Repay. Limit above SO");
            end else
                if HRSetup."V.loan Repay. Limit SO or less" < EmpLoan."Repayment Period" then
                    Error('Repayment period must be less or equal to %1', HRSetup."V.loan Repay. Limit SO or less");
        end else if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Home Loan" then
                if EmpLoan."Repayment Period" > HRSetup."Home/Persona Loan Repay Period" then
                    Error('Repayment period must be less or equal to %1', HRSetup."Home/Persona Loan Repay Period");
    end;

    procedure GetEmployeeSalaryOutstandingAmt(EmpNo: Code[20]): Decimal
    var
        EmpLoan: Record "Employee Loan/Advance";
        EmpDetailedLedEntry: Record "Detailed Employee Ledger Entry";
        PayrollAtt: Record "Payroll Attributes";
    begin
        PayrollAtt.Reset;
        PayrollAtt.SetRange(Type, PayrollAtt.Type::Deduction);
        PayrollAtt.SetRange(Subtype, PayrollAtt.Subtype::Advance);
        if PayrollAtt.FindFirst then begin
            EmpLoan.Reset;
            EmpLoan.SetRange("Employee Code", EmpNo);
            EmpLoan.SetRange(Settled, false);
            EmpLoan.SetRange("Approval Status", EmpLoan."Approval Status"::Approved);
            EmpLoan.SetRange(Disbursed, true);
            EmpLoan.CalcSums("Disbursed Amount");

            EmpDetailedLedEntry.Reset;
            EmpDetailedLedEntry.SetRange("Payroll Attribute Code", PayrollAtt.Code);
            EmpDetailedLedEntry.SetRange("Employee No.", EmpNo);
            EmpDetailedLedEntry.CalcSums(Amount);

            exit(EmpLoan."Disbursed Amount" - Abs(EmpDetailedLedEntry.Amount));
        end;

    end;

    // local procedure "-----FinacleIntegration----"()
    // begin
    // end;

    // [TryFunction]
    // procedure GetOutstandingEmployeeLoanDetails(EmpNo: Code[20]; CIFNo: Code[30])
    // var
    //     request: DotNet HttpWebRequest;
    //     reader: DotNet XmlTextReader;
    //     ascii: DotNet Encoding;
    //     ResponseType: Option " ",Loan,"Loan Limit",EMI;
    // begin
    //     SetDefaults(request);
    //     SendFinacleWebRequestForEmployeeOutstandingBalance(EmpNo, CIFNo, request);
    //     SkipCertificateCheckForHttpsWebrequest(request);
    //     GetFinacleResponse(request, reader, ResponseType::Loan, EmpNo);
    // end;

    // local procedure SetDefaults(var request: DotNet HttpWebRequest)
    // var
    //     uriObj: DotNet Uri;
    //     url: Text;
    // begin
    //     //url := 'https://10.200.2.1:22222/FISERVLET/fihttp'; //Let's keep this in HR Setup
    //     HRSetup.Get;
    //     url := HRSetup."Finacle URL";
    //     uriObj := uriObj.Uri(url);
    //     request := request.HttpWebRequest;
    //     request := request.CreateDefault(uriObj);
    //     request.Method := 'POST';
    //     request.ContentType := 'text/xml';
    //     request.Accept := '*/*';
    //     request.Timeout := 120000;
    //     request.UseDefaultCredentials := true;
    //     request.KeepAlive := true;
    // end;

    // local procedure SendFinacleWebRequestForEmployeeOutstandingBalance(EmpNo: Code[20]; CIFNo: Code[30]; var request: DotNet HttpWebRequest)
    // var
    //     // stream: DotNet StreamWriter;
    //     xmlnode: Label '<?xml version="1.0" encoding="UTF-8"?><FIXML xmlns="http://www.finacle.com/fixml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.finacle.com/fixml executeFinacleScript.xsd">';
    //     xmlheader: Label '<Header><RequestHeader><MessageKey><RequestUUID>Req_1593666231573</RequestUUID><ServiceRequestId>executeFinacleScript</ServiceRequestId><ServiceRequestVersion>10.2</ServiceRequestVersion><ChannelId>COR</ChannelId>';
    //     xmllanguage: Label '<LanguageId /></MessageKey><RequestMessageInfo><BankId /><TimeZone /><EntityId /><EntityType /><ArmCorrelationId />';
    //     xmlmessage: Label '<MessageDateTime>2020-05-22T12:59:22.795</MessageDateTime></RequestMessageInfo><Security><Token><PasswordToken><UserId /><Password /></PasswordToken></Token><FICertToken />';
    //     xmlloginsession: Label '<RealUserLoginSessionId /><RealUser /><RealUserPwd /><SSOTransferToken /></Security></RequestHeader></Header><Body><executeFinacleScriptRequest><ExecuteFinacleScriptInputVO>';
    //     xmlrequest: Label '<requestId>DoCifIDAccoutDetail.scr</requestId></ExecuteFinacleScriptInputVO><executeFinacleScript_CustomData><cif_id>%2</cif_id></executeFinacleScript_CustomData>';
    //     xmlend: Label '</executeFinacleScriptRequest></Body></FIXML> ';
    // begin
    //     // Send the request to the webservice
    //     // stream := stream.StreamWriter(request.GetRequestStream());
    //     // stream.Write(StrSubstNo(xmlnode + xmlheader + xmllanguage + xmlmessage + xmlloginsession + xmlrequest + xmlend, EmpNo, CIFNo));
    //     // stream.Close();
    // end;

    // local procedure SkipCertificateCheckForHttpsWebrequest(var request: DotNet HttpWebRequest)
    // var
    // // HttpCertificateCheckSkip: DotNet RequestValidator;
    // // ServicePointManager: DotNet ServicePointManager;
    // // SecurityProtocolType: DotNet SecurityProtocolType;
    // begin
    //     // Force SSL Certificate validation (custom .net dll file created need to import in server add-ins folder to work)
    //     // HttpCertificateCheckSkip := HttpCertificateCheckSkip.RequestValidator(request);

    //     // //Ensure TLS security to access Finacle server
    //     // ServicePointManager.Expect100Continue := true;
    //     // ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls;
    // end;

    // local procedure GetFinacleResponse(var request: DotNet HttpWebRequest; var reader: DotNet XmlTextReader; ResponseType: Option " ",Loan,"Loan Limit",EMI; EmpNo: Code[20])
    // var
    //     // response: DotNet HttpWebResponse;
    //     // document: DotNet XmlDocument;
    //     ToFile: Text;
    //     FileSrv: Text;
    //     FileMgmt: Codeunit "File Management";
    //     EmployeeOutstandingBalance: Text;
    // begin
    //     // Get the response from Financle Server
    //     // response := request.GetResponse();
    //     // reader := reader.XmlTextReader(response.GetResponseStream());
    //     // reader.Namespaces(false); // Not to support Namespaces

    //     // // Save the response to a XML
    //     // document := document.XmlDocument();
    //     // document.Load(reader);

    //     // ParseFinacleResponse(document, ResponseType, EmpNo);

    //     // Used only to check the format of the Finacle response
    //     /*
    //     FileSrv := FileMgt.ServerTempFileName('xml');
    //     document.Save(FileSrv);

    //     // Get file from the server
    //     ToFile := FileMgmt.ClientTempFileName('xml');
    //     FileMgmt.DownloadToFile(FileSrv,ToFile);

    //     // Show the response XML
    //     HYPERLINK(ToFile);
    //     */

    // end;

    // local procedure ParseFinacleResponse(var document: DotNet XmlDocument; Type: Option " ",Loan,"Loan Limit",EMI; DocNo: Code[20])
    // var
    //     XmlNodeList: DotNet XmlNodeList;
    //     XmlNode: DotNet XmlNode;
    //     NodeNo: Integer;
    //     XmlAttributes: DotNet XmlAttributeCollection;
    //     XmlElement: DotNet XmlElement;
    //     OutStandingBalance: Decimal;
    //     schm_type: Text;
    //     foracid: Code[30];
    //     clr_bal_amt: Decimal;
    //     ElementNo: Integer;
    //     XmlChildNode: DotNet XmlNode;
    //     XmlChildElement: DotNet XmlElement;
    //     ChildElementNo: Integer;
    //     schm_code: Text;
    //     limit_balance: Decimal;
    //     emi_amount: Decimal;
    // begin
    //     case Type of
    //         Type::Loan:
    //             begin
    //                 XmlNodeList := document.SelectNodes('//Body/executeFinacleScriptResponse/executeFinacleScript_CustomData/Multirec/Details');
    //                 repeat
    //                     ElementNo := 0;
    //                     XmlNode := XmlNodeList.Item(NodeNo);
    //                     if XmlNodeList.Count = 0 then
    //                         exit;
    //                     foreach XmlElement in XmlNode do begin
    //                         XmlAttributes := XmlElement.Attributes;
    //                         case ElementNo of
    //                             0:
    //                                 Evaluate(schm_type, XmlElement.InnerText);
    //                             1:
    //                                 Evaluate(foracid, XmlElement.InnerText);
    //                             3:
    //                                 Evaluate(clr_bal_amt, XmlElement.InnerText);
    //                         end;
    //                         ElementNo += 1;
    //                     end;
    //                     NodeNo += 1;
    //                     InsertEmployeeLoanDetails(DocNo, foracid, schm_type, clr_bal_amt); // Enter ncessary parameters here
    //                 until NodeNo = XmlNodeList.Count;
    //             end;

    //         Type::"Loan Limit":
    //             begin
    //                 XmlNodeList := document.SelectNodes('//Body/AcctInqResponse/AcctInqRs/AcctBal');
    //                 repeat
    //                     ElementNo := 0;
    //                     XmlNode := XmlNodeList.Item(NodeNo);
    //                     if XmlNodeList.Count = 0 then
    //                         exit;

    //                     foreach XmlElement in XmlNode do begin
    //                         XmlAttributes := XmlElement.Attributes;
    //                         case ElementNo of
    //                             0:
    //                                 Evaluate(schm_code, XmlElement.InnerText);
    //                             1:
    //                                 begin
    //                                     ChildElementNo := 0;
    //                                     XmlChildNode := XmlElement.ChildNodes;
    //                                     foreach XmlChildElement in XmlChildNode do begin
    //                                         if ChildElementNo = 0 then
    //                                             Evaluate(limit_balance, XmlChildElement.InnerText);
    //                                         ChildElementNo += 1;
    //                                     end;
    //                                 end;
    //                         end;
    //                         ElementNo += 1;

    //                     end;
    //                     NodeNo += 1;
    //                     if schm_code = 'DRWPWR' then begin
    //                         GenerateLoanEMI_OR_Limit(DocNo, limit_balance, Type);
    //                         break;
    //                     end;
    //                 until NodeNo = XmlNodeList.Count;

    //             end;

    //         Type::EMI:
    //             begin
    //                 XmlNodeList := document.SelectNodes('//Body/fetchLoanRepaymentHistoryDetailsResponse/LoanRepaymentHistoryInquiryOutputVO/cICrvloanLastRecordsHistory/collection');
    //                 repeat
    //                     ElementNo := 0;
    //                     XmlNode := XmlNodeList.Item(NodeNo);
    //                     if XmlNodeList.Count = 0 then
    //                         exit;

    //                     foreach XmlElement in XmlNode do begin
    //                         XmlAttributes := XmlElement.Attributes;

    //                         case ElementNo of
    //                             0:
    //                                 Evaluate(emi_amount, XmlElement.InnerText);
    //                         end;
    //                         ElementNo += 1;
    //                     end;
    //                     NodeNo += 1;
    //                     //MESSAGE(schm_code+' '+ 'emi amount'+ ' '+FORMAT(emi_amount));
    //                     if emi_amount <> 0 then begin
    //                         GenerateLoanEMI_OR_Limit(DocNo, emi_amount, Type);
    //                         break;
    //                     end;
    //                 until NodeNo = XmlNodeList.Count;
    //             end;
    //     end;
    // end;

    local procedure InsertEmployeeLoanDetails(EmpNo: Code[20]; foracid: Code[20]; schm_type: Text; outstanding: Decimal)
    var
        LoanOutstanding: Record "Loan Outstanding from Finacle";
    begin
        LoanOutstanding.Reset;
        LoanOutstanding.SetRange("Employee No.", EmpNo);
        LoanOutstanding.SetRange("Scheme Type", schm_type);
        LoanOutstanding.SetRange("Account ID", foracid);
        if not LoanOutstanding.FindFirst then begin
            LoanOutstanding.Init;
            LoanOutstanding.Validate("Employee No.", EmpNo);
            LoanOutstanding.Validate("Account ID", foracid);
            LoanOutstanding.Validate("Scheme Type", schm_type);
            LoanOutstanding.Validate("Outstanding Amount", outstanding);
            LoanOutstanding.Insert(true);
        end else begin
            LoanOutstanding.Validate("Outstanding Amount", outstanding);
            LoanOutstanding.Modify;
        end;
    end;

    //[TryFunction]

    // procedure GetEmployeeLoanLimitDetails(LoanAccountNo: Code[30])
    // var
    //     request: DotNet HttpWebRequest;
    //     reader: DotNet XmlTextReader;
    //     ascii: DotNet Encoding;
    //     ResponseType: Option " ",Loan,"Loan Limit";
    // begin
    //     SetDefaults(request);
    //     SendFinacleWebRequestForEmployeeLoanLimit(LoanAccountNo, request);
    //     SkipCertificateCheckForHttpsWebrequest(request);
    //     GetFinacleResponse(request, reader, ResponseType::"Loan Limit", LoanAccountNo);
    // end;

    // local procedure SendFinacleWebRequestForEmployeeLoanLimit(LoanAccountNo: Code[30]; var request: DotNet HttpWebRequest)
    // var
    //     stream: DotNet StreamWriter;
    //     xmlnode: Label '<?xml version="1.0" encoding="UTF-8"?><FIXML xsi:schemaLocation="http://www.finacle.com/fixml AcctInq.xsd" xmlns="http://www.finacle.com/fixml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
    //     xmlheader: Label '<Header><RequestHeader><MessageKey><RequestUUID>Req_1594357239881</RequestUUID><ServiceRequestId>AcctInq</ServiceRequestId><ServiceRequestVersion>10.2</ServiceRequestVersion><ChannelId>COR</ChannelId>';
    //     xmllanguage: Label '<LanguageId></LanguageId></MessageKey><RequestMessageInfo><BankId></BankId><TimeZone></TimeZone><EntityId></EntityId><EntityType></EntityType><ArmCorrelationId></ArmCorrelationId>';
    //     xmlmessage: Label '<MessageDateTime>2020-06-10T10:45:39.881</MessageDateTime></RequestMessageInfo><Security><Token><PasswordToken><UserId></UserId><Password></Password></PasswordToken></Token><FICertToken></FICertToken>';
    //     xmlloginsession: Label '<RealUserLoginSessionId></RealUserLoginSessionId><RealUser></RealUser><RealUserPwd></RealUserPwd><SSOTransferToken></SSOTransferToken></Security>';
    //     xmlrequest: Label '</RequestHeader></Header><Body><AcctInqRequest><AcctInqRq><AcctId><AcctId>%1</AcctId>';
    //     xmlend: Label '</AcctId></AcctInqRq></AcctInqRequest></Body></FIXML>';
    //     test: Text;
    // begin
    //     // Send the request to the webservice
    //     stream := stream.StreamWriter(request.GetRequestStream());
    //     stream.Write(StrSubstNo(xmlnode + xmlheader + xmllanguage + xmlmessage + xmlloginsession + xmlrequest + xmlend, LoanAccountNo));
    //     stream.Close();
    // end;

    // [TryFunction]
    // procedure GetEmployeeLoanEMIDetails(LoanAccountNo: Code[30])
    // var
    //     request: DotNet HttpWebRequest;
    //     reader: DotNet XmlTextReader;
    //     ascii: DotNet Encoding;
    //     ResponseType: Option " ",Loan,"Loan Limit",EMI;
    // begin
    //     SetDefaults(request);
    //     SendFinacleWebRequestForEmployeeLoanEMI(LoanAccountNo, request);
    //     SkipCertificateCheckForHttpsWebrequest(request);
    //     GetFinacleResponse(request, reader, ResponseType::EMI, LoanAccountNo);
    // end;

    // local procedure SendFinacleWebRequestForEmployeeLoanEMI(LoanAccountNo: Code[30]; var request: DotNet HttpWebRequest)
    // var
    //     stream: DotNet StreamWriter;
    //     xmlnode: Label '<?xml version="1.0" encoding="UTF-8"?><FIXML xsi:schemaLocation="http://www.finacle.com/fixml fetchLoanRepaymentHistoryDetails.xsd" xmlns="http://www.finacle.com/fixml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
    //     xmlheader: Label '<Header><RequestHeader><MessageKey><RequestUUID>Req_1594023345918</RequestUUID><ServiceRequestId>fetchLoanRepaymentHistoryDetails</ServiceRequestId><ServiceRequestVersion>10.2</ServiceRequestVersion><ChannelId>COR</ChannelId>';
    //     xmllanguage: Label '<LanguageId></LanguageId></MessageKey><RequestMessageInfo><BankId></BankId><TimeZone></TimeZone><EntityId></EntityId><EntityType></EntityType><ArmCorrelationId></ArmCorrelationId>';
    //     xmlmessage: Label '<MessageDateTime>2020-06-06T14:00:45.918</MessageDateTime></RequestMessageInfo><Security><Token><PasswordToken><UserId></UserId><Password></Password></PasswordToken></Token><FICertToken></FICertToken>';
    //     xmlloginsession: Label '<RealUserLoginSessionId></RealUserLoginSessionId><RealUser></RealUser><RealUserPwd></RealUserPwd><SSOTransferToken></SSOTransferToken></Security>';
    //     xmlrequest: Label '</RequestHeader></Header><Body><fetchLoanRepaymentHistoryDetailsRequest><LoanRepaymentHistoryInquiryInputVO><acctNum>%1</acctNum></LoanRepaymentHistoryInquiryInputVO>';
    //     xmlend: Label '</fetchLoanRepaymentHistoryDetailsRequest></Body></FIXML>';
    //     test: Text;
    // begin
    //     // Send the request to the webservice
    //     stream := stream.StreamWriter(request.GetRequestStream());
    //     stream.Write(StrSubstNo(xmlnode + xmlheader + xmllanguage + xmlmessage + xmlloginsession + xmlrequest + xmlend, LoanAccountNo));
    //     stream.Close();
    // end;

    local procedure GenerateLoanEMI_OR_Limit(LoanAcctNo: Code[30]; Amt: Decimal; Type: Option " ",Loan,"Loan Limit",EMI)
    var
        LoanOutstanding: Record "Loan Outstanding from Finacle";
    begin
        LoanOutstanding.Reset;
        LoanOutstanding.SetRange("Account ID", LoanAcctNo);
        if LoanOutstanding.FindFirst then begin
            if Type = Type::"Loan Limit" then
                LoanOutstanding."Loan Limit" := Amt
            else if Type = Type::EMI then
                LoanOutstanding.EMI := Amt;
            LoanOutstanding.Modify;
        end;
    end;

    procedure SendReportEmailAfterApproval(EmployeeLoanAdvance: Record "Employee Loan/Advance")
    var
        ReportSelections: Record "Report Selections";
        FileMgt: Codeunit "File Management";
        FileDirectory: Text;
        // SMTPMail: Codeunit "SMTP Mail";
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        CC: List of [Text];
        BCC: List of [Text];
        EmailReceipentTxtList: List of [Text];
        EmailTemplate: Record "Email Template";
        Employee: Record Employee;
        EmailReceipentTxt: Text;
        EmailReceipent: Record "Agile Email Recipient";
        EmailMessage: Record "Agile Email Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        ClientFileName: Text;
        IncomingDocument: Record "Incoming Document";
        DirectoryName: Text;
        Extention: Text;
        FileName: Text;
        recRef: RecordRef;
        tmpBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        inStr: InStream;
        format: ReportFormat;
    begin
        EmployeeLoanAdvance.TestField("Approval Status", EmployeeLoanAdvance."Approval Status"::Approved);

        if not Confirm('Do you want to send documents to %1 ?', false, EmployeeLoanAdvance."Employee Name") then
            exit;

        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        Clear(OutStr);
        Clear(inStr);
        HRSetup.Get;
        HRSetup.TestField("Attachment Storage Location");

        EmailTemplate.Reset;
        EmailTemplate.SetRange("Document Type", EmailTemplate."Document Type"::"Loan Attachment");
        EmailTemplate.SetRange("Loan Type", EmployeeLoanAdvance."Loan Type");
        if not EmailTemplate.FindFirst then
            exit;

        Employee.Get(EmployeeLoanAdvance."Employee Code");

        // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Employee."Company E-Mail", EmailTemplate.Subject, '', true);
        CodeunitEmailMessage.Create(Employee."Company E-Mail", EmailTemplate.Subject, '');
        EmailMessage.Reset;
        EmailMessage.SetRange("Template Code", EmailTemplate.Code);
        if EmailMessage.FindFirst then
            repeat
                case EmailMessage.Type of
                    EmailMessage.Type::Header:
                        Header := Header + EmailMessage."Body Message";

                    EmailMessage.Type::Body:
                        Body := Body + EmailMessage."Body Message";

                    EmailMessage.Type::Footer:
                        Footer := Footer + EmailMessage."Body Message";
                end;
            until EmailMessage.Next = 0;

        EmailReceipent.Reset;
        EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
        if EmailReceipent.FindFirst then
            repeat
                if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" then
                    EmailReceipentTxtList.Add(EmailReceipent."Email Recipients");
                if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Bcc then
                    BCC.Add(EmailReceipent."Email Recipients");
                if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Cc then
                    CC.Add(EmailReceipent."Email Recipients");
                CodeunitEmailMessage.Create(EmailReceipentTxtList, EmailTemplate.Subject, '', true, CC, BCC);
            until EmailReceipent.Next = 0;

        CodeunitEmailMessage.AppendToBody(Header);
        CodeunitEmailMessage.AppendToBody('<br><br>');
        CodeunitEmailMessage.AppendToBody(Body);
        CodeunitEmailMessage.AppendToBody('<br><br>');
        if EmployeeLoanAdvance.Remarks <> '' then begin
            CodeunitEmailMessage.AppendToBody(EmployeeLoanAdvance.Remarks);
        end;

        ReportSelections.Reset;
        ReportSelections.SetRange("Use for Email Attachment", true);
        case EmployeeLoanAdvance."Loan Type" of
            EmployeeLoanAdvance."Loan Type"::"Salary Advance":
                ReportSelections.SetRange(Usage, ReportSelections.Usage::"Salary Advance");
            EmployeeLoanAdvance."Loan Type"::"Personal Loan":
                ReportSelections.SetRange(Usage, ReportSelections.Usage::"Personal Loan");
            EmployeeLoanAdvance."Loan Type"::"Home Loan":
                ReportSelections.SetRange(Usage, ReportSelections.Usage::"Home Loan");
            EmployeeLoanAdvance."Loan Type"::"Vehicle Loan":
                ReportSelections.SetRange(Usage, ReportSelections.Usage::"Vehicle Loan");
        end;
        if ReportSelections.FindFirst then begin
            repeat
                ReportSelections.CalcFields("Report Caption");
                ClientFileName := HRSetup."Attachment Storage Location" + 'temp\';

                AttachmentMgt.CreateNewDir(HRSetup."Attachment Storage Location", EmployeeLoanAdvance."Employee Code", DirectoryName);
                FileName := EmployeeLoanAdvance."Employee Code" + '_' + ReportSelections."Report Caption" + '_' + Format(EmployeeLoanAdvance."No.") + '.docx';
                ClientFileName := FileMgt.GetDirectoryName(DirectoryName) + '\' + EmployeeLoanAdvance."Employee Code" + '\' + FileName;
                recRef.GetTable(EmployeeLoanAdvance);
                tmpBlob.CreateOutStream(OutStr);
                REPORT.SaveAs(ReportSelections."Report ID", '', format::Word, OutStr, recRef);
                // REPORT.SaveAsWord(ReportSelections."Report ID", ClientFileName, EmployeeLoanAdvance);
                tmpBlob.CreateInStream(InStr);
                CodeunitEmailMessage.AddAttachment(ClientFileName, '.pdf', InStr);
            // CodeunitEmailMessage.AddAttachment(ClientFileName, FileName);
            until ReportSelections.Next = 0;
        end else
            exit;

        Email.Send(CodeunitEmailMessage);

        Message('Email sent successfully.');
    end;

    procedure PopUpForDisbursement(EmployeeLoan: Record "Employee Loan/Advance")
    var
        LoanPageBuilder: FilterPageBuilder;
        EmpLoan: Record "Employee Loan/Advance";
        DisbursementDate: Date;
        DisbursedAmt: Decimal;
        OfferLetterDate: Date;
    begin
        if EmployeeLoan.Disbursed then
            Error('Loan has already been disbursed.');
        LoanPageBuilder.AddRecord('Disbursement', EmpLoan);
        LoanPageBuilder.ADdField('Disbursement', EmpLoan."Disbursement Date");
        LoanPageBuilder.ADdField('Disbursement', EmpLoan."Disbursed Amount");
        LoanPageBuilder.ADdField('Disbursement', EmpLoan."Account No.");

        LoanPageBuilder.RunModal;
        EmpLoan.SetView(LoanPageBuilder.GetView('Disbursement'));


        Evaluate(DisbursementDate, EmpLoan.GetFilter("Disbursement Date"));
        if EmpLoan.GetFilter("Disbursed Amount") <> '' then
            Evaluate(DisbursedAmt, EmpLoan.GetFilter("Disbursed Amount"));

        if (DisbursementDate = 0D) or (DisbursedAmt = 0) then
            Error('Every field must have value');

        EmployeeLoan.Validate("Disbursement Date", DisbursementDate);
        EmployeeLoan.Validate("Disbursed Amount", DisbursedAmt);
        EmployeeLoan.Validate("Account No.", EmpLoan.GetFilter("Account No."));
        EmployeeLoan.Disbursed := true;
        EmployeeLoan.Modify;
    end;

    procedure PopUpSecurityDoc(EmployeeLoan: Record "Employee Loan/Advance")
    var
        LoanPageBuilder: FilterPageBuilder;
        EmpLoan: Record "Employee Loan/Advance";
        DisbursementDate: Date;
        DisbursedAmt: Decimal;
        OfferLetterDate: Date;
    begin

        LoanPageBuilder.AddRecord('Security Document', EmpLoan);
        LoanPageBuilder.ADdField('Security Document', EmpLoan."Offer Letter Issued Date");
        LoanPageBuilder.ADdField('Security Document', EmpLoan."Offer Letter Date(Nepali)");
        LoanPageBuilder.ADdField('Security Document', EmpLoan."Amount In Words (Nepali)");
        LoanPageBuilder.RunModal;
        EmpLoan.SetView(LoanPageBuilder.GetView('Security Document'));


        Evaluate(OfferLetterDate, EmpLoan.GetFilter("Offer Letter Issued Date"));


        EmployeeLoan.Validate("Offer Letter Date(Nepali)", EmpLoan.GetFilter("Offer Letter Date(Nepali)"));
        EmployeeLoan.Validate("Offer Letter Issued Date", OfferLetterDate);
        EmployeeLoan.Validate("Amount In Words (Nepali)", EmpLoan.GetFilter("Amount In Words (Nepali)"));
        EmployeeLoan.Modify;
    end;

    procedure PopUpVechicleLoanDetails(EmployeeLoan: Record "Employee Loan/Advance")
    var
        LoanPageBuilder: FilterPageBuilder;
        EmpLoan: Record "Employee Loan/Advance";
        DisbursementDate: Date;
        DisbursedAmt: Decimal;
    begin

        LoanPageBuilder.AddRecord('Vehicle Details', EmpLoan);
        LoanPageBuilder.ADdField('Vehicle Details', EmpLoan."Vehicle Chasis No.");
        LoanPageBuilder.ADdField('Vehicle Details', EmpLoan."Vehicle Engine No.");
        LoanPageBuilder.ADdField('Vehicle Details', EmpLoan."Vehicle Model");
        LoanPageBuilder.ADdField('Vehicle Details', EmpLoan."Vehicle Registration No.");
        LoanPageBuilder.ADdField('Vehicle Details', EmpLoan."Vehicle Type (Nepali)");
        LoanPageBuilder.ADdField('Vehicle Details', EmpLoan."Transportation Management off.");

        LoanPageBuilder.RunModal;
        EmpLoan.SetView(LoanPageBuilder.GetView('Vehicle Details'));


        if EmpLoan.GetFilter("Vehicle Chasis No.") <> '' then
            EmployeeLoan.Validate("Vehicle Chasis No.", EmpLoan.GetFilter("Vehicle Chasis No."));

        if EmpLoan.GetFilter("Vehicle Engine No.") <> '' then
            EmployeeLoan.Validate("Vehicle Engine No.", EmpLoan.GetFilter("Vehicle Engine No."));

        if EmpLoan.GetFilter("Vehicle Model") <> '' then
            EmployeeLoan.Validate("Vehicle Model", EmpLoan.GetFilter("Vehicle Model"));

        if EmpLoan.GetFilter("Vehicle Registration No.") <> '' then
            EmployeeLoan.Validate("Vehicle Registration No.", EmpLoan.GetFilter("Vehicle Registration No."));

        if EmpLoan.GetFilter("Vehicle Type (Nepali)") <> '' then
            EmployeeLoan.Validate("Vehicle Type (Nepali)", EmpLoan.GetFilter("Vehicle Type (Nepali)"));

        if EmpLoan.GetFilter("Transportation Management off.") <> '' then
            EmployeeLoan.Validate("Transportation Management off.", EmpLoan.GetFilter("Transportation Management off."));

        EmployeeLoan.Modify;
    end;

    // procedure PopUpChangingApprover(EmployeeLoan: Record "Employee Loan/Advance")
    // var
    //     LoanPageBuilder: FilterPageBuilder;
    //     EmpLoan: Record "Employee Loan/Advance";
    //     DisbursementDate: Date;
    //     DisbursedAmt: Decimal;
    // begin
    //     LoanPageBuilder.AddRecord('Change Approver', EmpLoan);
    //     LoanPageBuilder.ADdField('Change Approver', EmpLoan.Approver);
    //     if LoanPageBuilder.RunModal then begin
    //         EmpLoan.SetView(LoanPageBuilder.GetView('Change Approver'));

    //         if EmpLoan.GetFilter(Approver) = '' then
    //             Error('Approver Code cannot be blank.');

    //         EmployeeLoan.Validate(Approver, EmpLoan.GetFilter(Approver));
    //         EmployeeLoan.Modify;
    //         Message('Approver updated.');

    //     end;
    // end;

    // procedure PopUpChangingApproverAllowance(AllowanceHeader: Record "Allowance Assignment Header")
    // var
    //     AllowancePageBuilder: FilterPageBuilder;
    //     AllowanceHead: Record "Allowance Assignment Header";
    // begin
    //     AllowancePageBuilder.AddRecord('Change Approver', AllowanceHead);
    //     AllowancePageBuilder.ADdField('Change Approver', AllowanceHead."Approver ID");
    //     AllowancePageBuilder.ADdField('Change Approver', AllowanceHead."Change Approver Remarks");
    //     if AllowancePageBuilder.RunModal then begin
    //         if AllowanceHeader."Approval Status" in [AllowanceHeader."Approval Status"::"Pending Approval", AllowanceHeader."Approval Status"::Open] then begin //Min 7.3.2022
    //             AllowanceHead.SetView(AllowancePageBuilder.GetView('Change Approver'));
    //             Employee.Get(HRMgt.GetEmployeeNo);
    //             // if not Employee.Screener then
    //             //     Error('You are not eligible to change approver.');
    //             if AllowanceHead.GetFilter("Approver ID") = '' then
    //                 Error('Approver Id cannot be blank.');
    //             if AllowanceHead.GetFilter("Change Approver Remarks") = '' then
    //                 Error('Change approver Remarks must have value');
    //             AllowanceHeader.Validate("Change Approver Remarks", AllowanceHead.GetFilter("Change Approver Remarks"));
    //             AllowanceHeader.Validate("Approver ID", AllowanceHead.GetFilter("Approver ID"));
    //             AllowanceHeader.Modify;
    //             Message('Approver updated.');
    //         end else begin //Min 7.3.2022
    //             Error('You cannot change the approver of Approval Status : %1', AllowanceHeader."Approval Status");
    //         end;
    //     end;
    // end;

    procedure CheckInsuranceAttachment(InsuranceNo: Code[20]; EmpNo: Code[20])
    var
        IncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        EmployeInsurance: Record "Employee Insurance Information";
    begin
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Insurance);
        AttachmentSetup.SetRange(Mandatory, true);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("No.", InsuranceNo);
                IncomingDoc.SetRange("Employee Code", EmpNo);
                IncomingDoc.SetRange("File Name", '');
                if IncomingDoc.FindFirst then
                    Error('Please upload mandatory attachments.');
            until AttachmentSetup.Next = 0;
    end;

    local procedure "----Json API----"()
    begin
    end;

    [TryFunction]
    // procedure SetJSONAPI(CIFId: Code[20]; EmpNo: Code[20])
    // var
    //     url: Text;
    //     HTTPContent: DotNet StringContent;
    //     HTTPResponseMessage: DotNet HttpResponseMessage;
    //     HTTPClient: DotNet HttpClient;
    //     uri: DotNet Uri;
    //     data: Text;
    //     encoding: DotNet Encoding;
    //     httpUtility: DotNet HttpUtility;
    //     JSON: DotNet JsonConvert;
    //     result: Text;
    //     variable: Variant;
    // begin
    //     HRSetup.Get;
    //     url := HRSetup."Finacle URL";//'http://10.10.0.203/fiservicetest/api/hr/GetLoanAccountInfo';
    //     HTTPClient := HTTPClient.HttpClient();
    //     HTTPClient.BaseAddress := uri.Uri(url);
    //     data := 'CifId=' + httpUtility.UrlEncode(CIFId, encoding.GetEncoding('ISO-8859-1'));
    //     data += '&Token=' + httpUtility.UrlEncode(HRSetup."Json Token", encoding.GetEncoding('ISO-8859-1'));

    //     HTTPContent := HTTPContent.StringContent(data, encoding.UTF8, 'application/x-www-form-urlencoded');
    //     HTTPResponseMessage := HTTPClient.PostAsync('', HTTPContent).Result;
    //     result := HTTPResponseMessage.Content.ReadAsStringAsync.Result;
    //     ReadJson(result, EmpNo);
    // end;

    // local procedure ReadJson(var String: DotNet String; EmpNo: Code[20])
    // var
    //     JsonToken: DotNet JsonToken;
    //     PrefixArray: DotNet Array;
    //     PrefixString: DotNet String;
    //     PropertyName: Text;
    //     ColumnNo: Integer;
    //     InArray: array[250] of Boolean;
    //     ArrayDepth: Integer;
    //     ActualLineNumber: Integer;
    //     TempLineNumber: Integer;
    //     StringReader: DotNet StringReader;
    //     NewValue: Text;
    //     LoanOutstanding: Record "Loan Outstanding from Finacle";
    //     LineNo: Integer;
    // begin
    //     Clear(LoanOutstanding);
    //     LoanOutstanding.SetRange("Employee No.", EmpNo);
    //     LoanOutstanding.SetRange("Is Manual", false);
    //     LoanOutstanding.DeleteAll;

    //     LineNo2 := 0;
    //     ;
    //     Clear(LoanOutstanding);
    //     LoanOutstanding.SetRange("Employee No.", EmpNo);
    //     if LoanOutstanding.FindFirst then
    //         LineNo2 := LoanOutstanding."Line No.";

    //     PrefixArray := PrefixArray.CreateInstance(GetDotNetType(String), 250);
    //     StringReader := StringReader.StringReader(String);
    //     JsonTextReader := JsonTextReader.JsonTextReader(StringReader);
    //     ActualLineNumber := 1;
    //     TempLineNumber := 0;
    //     ClearAPIValues;
    //     while JsonTextReader.Read do
    //         case true of
    //             JsonTextReader.TokenType.CompareTo(JsonToken.StartObject) = 0:
    //                 begin
    //                     TempLineNumber += 1;
    //                 end;

    //             JsonTextReader.TokenType.CompareTo(JsonToken.StartArray) = 0:
    //                 begin
    //                     InArray[JsonTextReader.Depth + 1] := true;
    //                     ColumnNo := 0;
    //                     ArrayDepth += 1;
    //                 end;

    //             JsonTextReader.TokenType.CompareTo(JsonToken.StartConstructor) = 0:
    //                 ;

    //             JsonTextReader.TokenType.CompareTo(JsonToken.PropertyName) = 0:
    //                 begin
    //                     PrefixArray.SetValue(JsonTextReader.Value, JsonTextReader.Depth - ArrayDepth);
    //                     if JsonTextReader.Depth > 1 then begin
    //                         PrefixString := PrefixString.Join('.', PrefixArray, 0, JsonTextReader.Depth - ArrayDepth);
    //                         if PrefixString.Length > 0 then
    //                             PropertyName := PrefixString.ToString + '.' + Format(JsonTextReader.Value, 0, 9)
    //                         else
    //                             PropertyName := Format(JsonTextReader.Value, 0, 9);
    //                     end else
    //                         PropertyName := Format(JsonTextReader.Value, 0, 9);
    //                 end;

    //             JsonTextReader.TokenType.CompareTo(JsonToken.String) = 0,
    //             JsonTextReader.TokenType.CompareTo(JsonToken.Integer) = 0,
    //             JsonTextReader.TokenType.CompareTo(JsonToken.Float) = 0,
    //             JsonTextReader.TokenType.CompareTo(JsonToken.Boolean) = 0,
    //             JsonTextReader.TokenType.CompareTo(JsonToken.Date) = 0,
    //             JsonTextReader.TokenType.CompareTo(JsonToken.Bytes) = 0:
    //                 begin
    //                     NewValue := Format(JsonTextReader.Value, 0, 9);
    //                     SetJsonValue(PropertyName, NewValue);
    //                 end;

    //             JsonTextReader.TokenType.CompareTo(JsonToken.EndConstructor) = 0:
    //                 begin
    //                     LineNo += 1;
    //                 end;
    //             JsonTextReader.TokenType.CompareTo(JsonToken.EndArray) = 0:
    //                 begin
    //                     InArray[JsonTextReader.Depth + 1] := false;
    //                     ArrayDepth -= 1;

    //                 end;

    //             JsonTextReader.TokenType.CompareTo(JsonToken.EndObject) = 0:
    //                 begin
    //                     TempLineNumber -= 1;
    //                     if TempLineNumber = 0 then begin
    //                         ActualLineNumber += 1;
    //                     end;
    //                     if JsonTextReader.Depth > 0 then
    //                         if InArray[JsonTextReader.Depth] then
    //                             ColumnNo += 1;
    //                     //    IF NOT (SchemeCode IN ['SD023','SD001','SBSTF']) THEN
    //                     InsertEmployeeLoanDetailsViaJson(EmpNo);
    //                     ClearAPIValues;
    //                 end;
    //         end;
    // end;

    // local procedure SetJsonValue(PropertyName: Text; PropertyValue: Text)
    // begin
    //     case PropertyName of
    //         'AccountNumber':
    //             AcctNo := PropertyValue;

    //         'SchemeType':
    //             SchemeTypeText := PropertyValue;

    //         'Balance':
    //             Evaluate(Balance, PropertyValue);

    //         'LoanLimit':
    //             Evaluate(LoanLimit, PropertyValue);

    //         'SchemeCode':
    //             SchemeCode := PropertyValue;

    //         'EMI':
    //             Evaluate(EMIValue, PropertyValue);
    //     end;
    // end;

    local procedure InsertEmployeeLoanDetailsViaJson(EmpNo: Code[20])
    var
        LoanOutstanding: Record "Loan Outstanding from Finacle";
    begin
        LineNo2 += 10000;
        LoanOutstanding.Init;
        LoanOutstanding.Validate("Employee No.", EmpNo);
        LoanOutstanding.Validate("Line No.", LineNo2);
        LoanOutstanding.Validate("Account ID", AcctNo);
        LoanOutstanding.Validate("Scheme Type", SchemeTypeText);
        LoanOutstanding.Validate("Outstanding Amount", Abs(Balance));
        LoanOutstanding.Validate("Loan Limit", Abs(LoanLimit));
        LoanOutstanding.Validate(EMI, Abs(EMIValue));
        LoanOutstanding.Validate("Scheme Code", SchemeCode);
        LoanOutstanding.Insert(true);
    end;

    local procedure ClearAPIValues()
    begin
        Clear(AcctNo);
        Clear(SchemeTypeText);
        Clear(SchemeCode);
        Clear(Balance);
        Clear(EMIValue);
        Clear(LoanLimit);
    end;

    local procedure "----Loan----"()
    begin
    end;

    procedure DisbursementEmailToEmployee(EmpLoanAdvCode: Code[20])
    var
        EmpAdvLoan: Record "Employee Loan/Advance";
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Agile Email Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
        EmployeeRec: Record Employee;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        EmpAdvLoan.Reset;
        Counter := 0;
        EmpAdvLoan.SetRange("No.", EmpLoanAdvCode);
        if EmpAdvLoan.FindFirst then
            repeat
                if EmailTemplate.Get(HRSetup."Loan Disbursement Email") then begin
                    Clear(Footer);
                    Clear(Header);
                    Clear(Body);
                    EmployeeRec.Get(EmpAdvLoan."Employee Code");
                    // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", EmployeeRec."E-Mail(Personal)", EmailTemplate.Subject, '', true);

                    EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                    if EmailMessage.FindFirst then
                        repeat
                            case EmailMessage.Type of
                                EmailMessage.Type::Header:
                                    Header := Header + EmailMessage."Body Message";

                                EmailMessage.Type::Body:
                                    Body := Body + EmailMessage."Body Message";

                                EmailMessage.Type::Footer:
                                    Footer := Footer + EmailMessage."Body Message";
                            end;
                        until EmailMessage.Next = 0;
                    CodeunitEmailMessage.AppendToBody(Header);
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                    CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Employee Name") + Colon + Format(EmpAdvLoan."Employee Name"));
                    CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Loan Type") + Colon + Format(EmpAdvLoan."Loan Type"));
                    CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Total Loan Amount") + Colon + Format(EmpAdvLoan."Total Loan Amount"));
                    CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Disbursement Date") + Colon + Format(EmpAdvLoan."Disbursement Date"));
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                    CodeunitEmailMessage.AppendToBody(Footer);
                    if Email.Send(CodeunitEmailMessage) then
                        Counter += 1;
                end;
            until EmpAdvLoan.Next = 0;
        if Counter <> 0 then
            Message('Mail Sent');
    end;

    procedure GetLoanBody(var Emploan: Record "Employee Loan/Advance")
    begin
        case Emploan."Loan Type" of
            Emploan."Loan Type"::"Salary Advance":
                begin
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
                end;

            Emploan."Loan Type"::"Home Loan":
                begin
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
                end;


            Emploan."Loan Type"::"Personal Loan":
                begin
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
                end;

            Emploan."Loan Type"::"Vehicle Loan":
                begin
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
                    CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
                end;

        end;
    end;

    var
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;


}

