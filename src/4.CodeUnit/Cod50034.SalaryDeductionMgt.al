codeunit 50034 "Salary Deduction Mgt"
{
    trigger OnRun()
    begin

    end;

    procedure GenerateSalaryDeductionEntries(AttendanceHeader: Record "Attendance Header")
    var
        EmpAttenActivity: array[3] of Record "Employee Attendance & Activity";
        AttendanceSummary: Record "Attendance Summary";
        PayrollAttributeUsage: Record "Payroll Attributes Usage";
        PayrollEngine: Codeunit "Payroll Engine";
        DeductionType: Enum "Attribute Deduction Type";
        SalaryLedgerEntryNo: Integer;
        AttendanceSetup: Record "Attendance Setup";
        ProgressDialog: Dialog;
        LineCount: Integer;
        ProcessedLines: Integer;
        PercentComplete: Integer;
        ProgressText: Label 'Generating Deduction Entries\Attendance Document No.: #1##########\Current Employee: #2##########\Progress: #3#### \Processed: #4##########################################';
    begin
        AttendanceSetup.Get();
        AttendanceSummary.Reset();
        AttendanceSummary.SetRange("Document No.", AttendanceHeader."No.");

        LineCount := AttendanceSummary.Count;
        ProcessedLines := 0;
        if LineCount > 0 then begin
            ProgressDialog.Open(ProgressText);
            ProgressDialog.Update(1, AttendanceHeader."No.");

            if AttendanceSummary.FindSet() then begin
                repeat
                    ProcessedLines += 1;
                    PercentComplete := Round(ProcessedLines / LineCount * 100, 1);
                    ProgressDialog.Update(2, AttendanceSummary."Employee No.");
                    ProgressDialog.Update(3, Format(PercentComplete) + ' %');
                    ProgressDialog.Update(4, Format(ProcessedLines) + ' of ' + Format(LineCount) + ' Employees');

                    if AttendanceSetup."Absent Deductions" then begin
                        EmpAttenActivity[1].Reset();
                        EmpAttenActivity[1].SetLoadFields("Employee No.", "Attendance Date", "Absent Day");
                        EmpAttenActivity[1].SetRange("Attendance Date", AttendanceHeader."From Date", AttendanceHeader."To Date");
                        EmpAttenActivity[1].SetRange("Employee No.", AttendanceSummary."Employee No.");
                        EmpAttenActivity[1].SetRange("Absent Day", 1);
                        OnAfterFilterEmpAttendanceActivityOnAbsentDeduction(EmpAttenActivity[1], AttendanceHeader);
                        if EmpAttenActivity[1].FindSet() then
                            repeat
                                Clear(SalaryLedgerEntryNo);
                                InitSalaryDeductionEntries(EmpAttenActivity[1]."Employee No.",
                                                                        EmpAttenActivity[1]."Attendance Date",
                                                                        DeductionType::Absent,
                                                                        AttendanceHeader."Pay Cycle Code",
                                                                        AttendanceHeader."Pay Cycle Term",
                                                                        AttendanceHeader."Pay Cycle Period",
                                                                        SalaryLedgerEntryNo,
                                                                        AttendanceHeader."No.");
                                PayrollAttributeUsage.Reset();
                                PayrollAttributeUsage.SetAutoCalcFields(Type, Subtype, "Formula Exists");
                                PayrollAttributeUsage.SetRange("Employee Code", EmpAttenActivity[1]."Employee No.");
                                PayrollAttributeUsage.SetRange("Deduct on Absent", true);
                                PayrollAttributeUsage.SetFilter(Amount, '<>%1', 0);
                                if PayrollAttributeUsage.FindSet() then
                                    repeat
                                        if (PayrollAttributeUsage.Subtype in [PayrollAttributeUsage.Subtype::CIT, PayrollAttributeUsage.Subtype::RF]) then begin
                                            if (PayrollAttributeUsage."RF Contribution Type" = PayrollAttributeUsage."RF Contribution Type"::Percent) then
                                                InsertDetailedSalaryDeductionEntries(EmpAttenActivity[1]."Employee No.",
                                                                                        EmpAttenActivity[1]."Attendance Date",
                                                                                        DeductionType::Absent,
                                                                                        AttendanceHeader."Pay Cycle Code",
                                                                                        AttendanceHeader."Pay Cycle Term",
                                                                                        AttendanceHeader."Pay Cycle Period",
                                                                                        PayrollAttributeUsage."Type",
                                                                                        PayrollAttributeUsage.Code,
                                                                                        GetPercentRFContributionAmount(EmpAttenActivity[1]."Employee No.", PayrollAttributeUsage.Code),
                                                                                        SalaryLedgerEntryNo,
                                                                                        AttendanceHeader."No.",
                                                                                        false)
                                        end else
                                            InsertDetailedSalaryDeductionEntries(EmpAttenActivity[1]."Employee No.",
                                                                                EmpAttenActivity[1]."Attendance Date",
                                                                                DeductionType::Absent,
                                                                                AttendanceHeader."Pay Cycle Code",
                                                                                AttendanceHeader."Pay Cycle Term",
                                                                                AttendanceHeader."Pay Cycle Period",
                                                                                PayrollAttributeUsage."Type",
                                                                                PayrollAttributeUsage.Code,
                                                                                PayrollAttributeUsage.Amount,
                                                                                SalaryLedgerEntryNo,
                                                                                AttendanceHeader."No.",
                                                                                false);
                                    until PayrollAttributeUsage.Next() = 0;
                                // Formula      
                                InsertAmountsWithFormula(
                                    EmpAttenActivity[1]."Employee No.",
                                    EmpAttenActivity[1]."Attendance Date",
                                    DeductionType::Absent,
                                    AttendanceHeader."Pay Cycle Code",
                                    AttendanceHeader."Pay Cycle Term",
                                    AttendanceHeader."Pay Cycle Period",
                                    SalaryLedgerEntryNo,
                                    AttendanceHeader."No.");
                            until EmpAttenActivity[1].Next() = 0;
                    end;

                    EmpAttenActivity[2].Reset();
                    EmpAttenActivity[2].SetLoadFields("Employee No.", "Attendance Date", "Leave Day", "Pay Type");
                    EmpAttenActivity[2].SetRange("Attendance Date", GetPreviousPeriodPayDate(AttendanceHeader), AttendanceHeader."To Date");
                    EmpAttenActivity[2].SetRange("Employee No.", AttendanceSummary."Employee No.");
                    EmpAttenActivity[2].SetFilter("Leave Day", '<>%1', 0);
                    EmpAttenActivity[2].SetRange("Pay Type", EmpAttenActivity[2]."Pay Type"::Unpaid);
                    if EmpAttenActivity[2].FindSet() then
                        repeat
                            InitSalaryDeductionEntries(EmpAttenActivity[2]."Employee No.",
                                                                    EmpAttenActivity[2]."Attendance Date",
                                                                    DeductionType::LWP,
                                                                    AttendanceHeader."Pay Cycle Code",
                                                                    AttendanceHeader."Pay Cycle Term",
                                                                    AttendanceHeader."Pay Cycle Period",
                                                                    SalaryLedgerEntryNo,
                                                                    AttendanceHeader."No.");
                            PayrollAttributeUsage.Reset();
                            PayrollAttributeUsage.SetAutoCalcFields(Type, Subtype, "Formula Exists");
                            PayrollAttributeUsage.SetRange("Employee Code", EmpAttenActivity[2]."Employee No.");
                            PayrollAttributeUsage.SetRange("Deduct on Absent", true);
                            PayrollAttributeUsage.SetFilter(Amount, '<>%1', 0);
                            if PayrollAttributeUsage.FindSet() then
                                repeat
                                    if (PayrollAttributeUsage.Subtype in [PayrollAttributeUsage.Subtype::CIT, PayrollAttributeUsage.Subtype::RF]) then begin
                                        if (PayrollAttributeUsage."RF Contribution Type" = PayrollAttributeUsage."RF Contribution Type"::Percent) then
                                            InsertDetailedSalaryDeductionEntries(EmpAttenActivity[2]."Employee No.",
                                                                                    EmpAttenActivity[2]."Attendance Date",
                                                                                    DeductionType::LWP,
                                                                                    AttendanceHeader."Pay Cycle Code",
                                                                                    AttendanceHeader."Pay Cycle Term",
                                                                                    AttendanceHeader."Pay Cycle Period",
                                                                                    PayrollAttributeUsage."Type",
                                                                                    PayrollAttributeUsage.Code,
                                                                                    GetPercentRFContributionAmount(EmpAttenActivity[2]."Employee No.", PayrollAttributeUsage.Code),
                                                                                    SalaryLedgerEntryNo,
                                                                                    AttendanceHeader."No.",
                                                                                    false)
                                    end else
                                        InsertDetailedSalaryDeductionEntries(EmpAttenActivity[2]."Employee No.",
                                                                            EmpAttenActivity[2]."Attendance Date",
                                                                            DeductionType::LWP,
                                                                            AttendanceHeader."Pay Cycle Code",
                                                                            AttendanceHeader."Pay Cycle Term",
                                                                            AttendanceHeader."Pay Cycle Period",
                                                                            PayrollAttributeUsage."Type",
                                                                            PayrollAttributeUsage.Code,
                                                                            PayrollAttributeUsage.Amount,
                                                                            SalaryLedgerEntryNo,
                                                                            AttendanceHeader."No.",
                                                                            false);
                                until PayrollAttributeUsage.Next() = 0;
                            // Formula
                            InsertAmountsWithFormula(
                                EmpAttenActivity[2]."Employee No.",
                                EmpAttenActivity[2]."Attendance Date",
                                DeductionType::LWP,
                                AttendanceHeader."Pay Cycle Code",
                                AttendanceHeader."Pay Cycle Term",
                                AttendanceHeader."Pay Cycle Period",
                                SalaryLedgerEntryNo,
                                AttendanceHeader."No.");
                        until EmpAttenActivity[2].Next() = 0;

                    EmpAttenActivity[3].Reset();
                    EmpAttenActivity[3].SetLoadFields("Employee No.", "Attendance Date", "Late Deduction");
                    EmpAttenActivity[3].SetRange("Attendance Date", AttendanceHeader."From Date", AttendanceHeader."To Date");
                    EmpAttenActivity[3].SetRange("Employee No.", AttendanceSummary."Employee No.");
                    EmpAttenActivity[3].SetRange("Late Deduction", true);
                    OnAfterFilterEmpAttendanceActivityOnLateDeduction(EmpAttenActivity[3], AttendanceHeader);
                    if EmpAttenActivity[3].FindSet() then
                        repeat
                            InitSalaryDeductionEntries(EmpAttenActivity[3]."Employee No.",
                                                                    EmpAttenActivity[3]."Attendance Date",
                                                                    DeductionType::Late,
                                                                    AttendanceHeader."Pay Cycle Code",
                                                                    AttendanceHeader."Pay Cycle Term",
                                                                    AttendanceHeader."Pay Cycle Period",
                                                                    SalaryLedgerEntryNo,
                                                                    AttendanceHeader."No.");

                            PayrollAttributeUsage.Reset();
                            PayrollAttributeUsage.SetAutoCalcFields(Type, Subtype, "Formula Exists");
                            PayrollAttributeUsage.SetRange("Employee Code", EmpAttenActivity[3]."Employee No.");
                            PayrollAttributeUsage.SetRange("Deduct on Absent", true);
                            PayrollAttributeUsage.SetFilter(Amount, '<>%1', 0);
                            if PayrollAttributeUsage.FindSet() then
                                repeat
                                    if (PayrollAttributeUsage.Subtype in [PayrollAttributeUsage.Subtype::CIT, PayrollAttributeUsage.Subtype::RF]) then begin
                                        if (PayrollAttributeUsage."RF Contribution Type" = PayrollAttributeUsage."RF Contribution Type"::Percent) then
                                            InsertDetailedSalaryDeductionEntries(EmpAttenActivity[3]."Employee No.",
                                                                                    EmpAttenActivity[3]."Attendance Date",
                                                                                    DeductionType::Late,
                                                                                    AttendanceHeader."Pay Cycle Code",
                                                                                    AttendanceHeader."Pay Cycle Term",
                                                                                    AttendanceHeader."Pay Cycle Period",
                                                                                    PayrollAttributeUsage."Type",
                                                                                    PayrollAttributeUsage.Code,
                                                                                    GetPercentRFContributionAmount(EmpAttenActivity[3]."Employee No.", PayrollAttributeUsage.Code),
                                                                                    SalaryLedgerEntryNo,
                                                                                    AttendanceHeader."No.",
                                                                                    false)
                                    end else
                                        InsertDetailedSalaryDeductionEntries(EmpAttenActivity[3]."Employee No.",
                                                                            EmpAttenActivity[3]."Attendance Date",
                                                                            DeductionType::Late,
                                                                            AttendanceHeader."Pay Cycle Code",
                                                                            AttendanceHeader."Pay Cycle Term",
                                                                            AttendanceHeader."Pay Cycle Period",
                                                                            PayrollAttributeUsage."Type",
                                                                            PayrollAttributeUsage.Code,
                                                                            PayrollAttributeUsage.Amount,
                                                                            SalaryLedgerEntryNo,
                                                                            AttendanceHeader."No.",
                                                                            false);
                                until PayrollAttributeUsage.Next() = 0;
                            // Formula
                            InsertAmountsWithFormula(
                                EmpAttenActivity[3]."Employee No.",
                                EmpAttenActivity[3]."Attendance Date",
                                DeductionType::Late,
                                AttendanceHeader."Pay Cycle Code",
                                AttendanceHeader."Pay Cycle Term",
                                AttendanceHeader."Pay Cycle Period",
                                SalaryLedgerEntryNo,
                                AttendanceHeader."No.");
                        until EmpAttenActivity[3].Next() = 0;
                until AttendanceSummary.Next = 0;
            end;
            UpdateDocumentNoOnReversedEntries(AttendanceHeader);
            ProgressDialog.Close();
        end;
    end;

    local procedure GetPreviousPeriodPayDate(AttenHeader: Record "Attendance Header"): Date
    var
        PreviousPayCyclePeriod: Record "Pay Cycle Period";
    begin
        if PreviousPayCyclePeriod.Get(AttenHeader."Pay Cycle Code", AttenHeader."Pay Cycle Term", AttenHeader."Pay Cycle Period" - 1) then
            exit(PreviousPayCyclePeriod."Pay Date");
    end;

    local procedure GetPercentRFContributionAmount(EmployeeNo: Code[20]; AttributeCode: Code[20]): Decimal
    var
        RFContributionLines: Record "RF Contribution";
        RFContributionHeader: Record "Retirement Fund";
        PayrollLine: Record "Payroll Line";
    begin
        RFContributionHeader.Reset();
        RFContributionHeader.SetRange("Employee No.", EmployeeNo);
        RFContributionHeader.SetRange("Approval Status", RFContributionHeader."Approval Status"::Approved);
        if RFContributionHeader.FindLast() then;

        RFContributionLines.Reset();
        RFContributionLines.SetRange("Document No.", RFContributionHeader."No.");
        RFContributionLines.SetRange("Attribute Code", AttributeCode);
        RFContributionLines.SetRange(Type, RFContributionLines.Type::Percent);
        RFContributionLines.SetRange("Approval Status", RFContributionLines."Approval Status"::Approved);
        if RFContributionLines.FindLast() then
            exit(PayrollLine.GetAmountRFContribution(EmployeeNo) * RFContributionLines.Amount / 100)
    end;

    procedure ReverseSalaryLedgerEntry(EmployeeNo: Code[20]; DeductionDate: Date)
    var
        SalaryDeductionEntry: Record "Salary Deduction Entry";
        DetailedSalaryDeductionEntry: Record "Det Salary Deduction Entry";
        ReversedDetailedSalaryDeductionEntry: Record "Det Salary Deduction Entry";
    begin
        SalaryDeductionEntry.Reset();
        SalaryDeductionEntry.SetRange("Employee No.", EmployeeNo);
        SalaryDeductionEntry.SetRange("Deduction Date", DeductionDate);
        SalaryDeductionEntry.SetRange("Attendance Posted", true);
        SalaryDeductionEntry.SetRange(Reversed, false);
        if SalaryDeductionEntry.FindFirst() then begin
            DetailedSalaryDeductionEntry.SetRange("Deduction Entry No.", SalaryDeductionEntry."Entry No.");
            DetailedSalaryDeductionEntry.SetRange(Reversed, false);
            if DetailedSalaryDeductionEntry.FindSet() then
                repeat
                    ReversedDetailedSalaryDeductionEntry.Init();
                    ReversedDetailedSalaryDeductionEntry := DetailedSalaryDeductionEntry;
                    ReversedDetailedSalaryDeductionEntry.Amount := -DetailedSalaryDeductionEntry.Amount;
                    ReversedDetailedSalaryDeductionEntry."Entry No." := GetDetailedSalaryDeductionEntryNo();
                    GetPayCycleCodeTermAndPeriod(Today(), ReversedDetailedSalaryDeductionEntry);
                    ReversedDetailedSalaryDeductionEntry.Reversed := true;
                    ReversedDetailedSalaryDeductionEntry."Reversed By Entry No." := DetailedSalaryDeductionEntry."Entry No.";
                    ReversedDetailedSalaryDeductionEntry."Reversed From Pay Cycle Term" := DetailedSalaryDeductionEntry."Pay Cycle Term";
                    ReversedDetailedSalaryDeductionEntry."Reversed From Pay Cycle Period" := DetailedSalaryDeductionEntry."Pay Cycle Period";
                    ReversedDetailedSalaryDeductionEntry."Attendance Posted" := false;
                    ReversedDetailedSalaryDeductionEntry."Attendance No." := '';
                    ReversedDetailedSalaryDeductionEntry.Insert();
                    DetailedSalaryDeductionEntry.Reversed := true;
                    DetailedSalaryDeductionEntry.Modify();
                until DetailedSalaryDeductionEntry.Next() = 0;
            SalaryDeductionEntry.Reversed := true;
            SalaryDeductionEntry.Modify();
        end;
    end;

    local procedure UpdateDocumentNoOnReversedEntries(AttenHeader: Record "Attendance Header")
    var
        DetSalaryDeductionEntries: Record "Det Salary Deduction Entry";
    begin
        DetSalaryDeductionEntries.Reset();
        DetSalaryDeductionEntries.SetRange("Pay Cycle Code", AttenHeader."Pay Cycle Code");
        DetSalaryDeductionEntries.SetRange("Pay Cycle Term", AttenHeader."Pay Cycle Term");
        DetSalaryDeductionEntries.SetRange("Pay Cycle Period", AttenHeader."Pay Cycle Period");
        DetSalaryDeductionEntries.SetRange(Reversed, true);
        DetSalaryDeductionEntries.SetRange("Attendance Posted", false);
        DetSalaryDeductionEntries.SetFilter("Attendance No.", '');
        DetSalaryDeductionEntries.ModifyAll("Attendance No.", AttenHeader."No.");
    end;

    local procedure InsertAmountsWithFormula(EmployeeNo: Code[20];
                                            DeductionDate: Date;
                                            Type: Enum "Attribute Deduction Type";
                                            PayCycleCode: Code[20];
                                            PayCycleTerm: Code[20];
                                            PayCyclePeriod: Integer;
                                            SalaryLedgerEntryNo: Integer;
                                            AttendanceNo: Code[20])
    var
        PayrollAttributeUsage: Record "Payroll Attributes Usage";
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        PayrollAttributeUsage.Reset();
        PayrollAttributeUsage.SetAutoCalcFields(Type, Subtype, "Formula Exists");
        PayrollAttributeUsage.SetRange("Employee Code", EmployeeNo);
        PayrollAttributeUsage.SetRange("Formula Exists", true);
        if PayrollAttributeUsage.FindSet() then
            repeat
                InsertDetailedSalaryDeductionEntries(
                    EmployeeNo,
                    DeductionDate,
                    Type,
                    PayCycleCode,
                    PayCycleTerm,
                    PayCyclePeriod,
                    PayrollAttributeUsage.Type,
                    PayrollAttributeUsage.Code,
                    EvaluateAmountOnDetailedSalaryEntry(
                        GetFormula(PayrollAttributeUsage.Code),
                        AttendanceNo,
                        EmployeeNo),
                    SalaryLedgerEntryNo,
                    AttendanceNo,
                    true);
            until PayrollAttributeUsage.Next() = 0;
    end;

    local procedure GetFormula(AttributeCode: Code[20]): Code[100]
    var
        PayrollAttributes: Record "Payroll Attributes";
    begin
        PayrollAttributes.Get(AttributeCode);
        exit(PayrollAttributes.Formula);
    end;

    local procedure GetPayCycleCodeTermAndPeriod(DateParam: Date; var DetailedSalaryEntry: Record "Det Salary Deduction Entry")
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetFilter("Start Date", '<=%1', DateParam);
        PayCyclePeriod.SetFilter("End Date", '>=%1', DateParam);
        PayCyclePeriod.FindFirst();

        DetailedSalaryEntry."Pay Cycle Code" := PayCyclePeriod."Pay Cycle Code";
        DetailedSalaryEntry."Pay Cycle Term" := PayCyclePeriod."Pay Cycle Term";

        if PayCyclePeriod."Pay Date" < DateParam then
            DetailedSalaryEntry."Pay Cycle Period" := PayCyclePeriod."Period" + 1
        else
            DetailedSalaryEntry."Pay Cycle Period" := PayCyclePeriod."Period";
    end;

    procedure InitSalaryDeductionEntries(EmployeeNo: Code[20];

                                      DeductionDate: Date;
                                      Type: Enum "Attribute Deduction Type";
                                      PayCycleCode: Code[20];
                                      PayCycleTerm: Code[20];
                                      PayCyclePeriod: Integer;
                                      var SalaryDeductEntryNo: Integer;
                                      AttenDocNo: Code[20])
    var
        SalaryDeductEntry: Record "Salary Deduction Entry";
    begin
        SalaryDeductEntry.Reset();
        SalaryDeductEntry.SetRange("Deduction Date", DeductionDate);
        SalaryDeductEntry.SetRange("Employee No.", EmployeeNo);
        if not SalaryDeductEntry.FindFirst() then begin
            SalaryDeductEntry.Init();
            SalaryDeductEntry."Entry No." := GetSalaryDeductionEntryNo();
            SalaryDeductEntryNo := SalaryDeductEntry."Entry No.";
            SalaryDeductEntry."Employee No." := EmployeeNo;
            SalaryDeductEntry."Employee Name" := HRMgt.GetEmployeeName(EmployeeNo);
            SalaryDeductEntry."Deduction Date" := DeductionDate;
            SalaryDeductEntry."Deduction Type" := Type;
            SalaryDeductEntry."Pay Cycle Code" := PayCycleCode;
            SalaryDeductEntry."Pay Cycle Term" := PayCycleTerm;
            SalaryDeductEntry."Pay Cycle Period" := PayCyclePeriod;
            SalaryDeductEntry."Attendance Document No" := AttenDocNo;
            SalaryDeductEntry.Insert(true);
        end;
    end;

    local procedure GetSalaryDeductionEntryNo(): Integer
    var
        SalaryDeductEntry: Record "Salary Deduction Entry";
    begin
        SalaryDeductEntry.Reset();
        if SalaryDeductEntry.FindLast() then
            exit(SalaryDeductEntry."Entry No." + 1);

        exit(1);
    end;

    procedure InsertDetailedSalaryDeductionEntries(EmployeeNo: Code[20];
                                                    DeductionDate: Date;
                                                    Type: Enum "Attribute Deduction Type";
                                                    PayCycleCode: Code[20];
                                                    PayCycleTerm: Code[20];
                                                    PayCyclePeriod: Integer;
                                                    AttributeType: Enum "Payroll Type";
                                                    AttributeCode: Code[20];
                                                    Amount: Decimal;
                                                    SalaryLedgerEntryNo: Integer;
                                                    AttendanceNo: Code[20];
                                                    FromFormula: Boolean)
    var
        DetailedSalaryDeductEntry: Record "Det Salary Deduction Entry";
    begin
        DetailedSalaryDeductEntry.Reset();
        DetailedSalaryDeductEntry.SetRange("Employee No.", EmployeeNo);
        DetailedSalaryDeductEntry.SetRange("Deduction Date", DeductionDate);
        DetailedSalaryDeductEntry.SetRange("Attribute Code", AttributeCode);
        if not DetailedSalaryDeductEntry.FindFirst() then begin
            DetailedSalaryDeductEntry.Init();
            DetailedSalaryDeductEntry."Entry No." := GetDetailedSalaryDeductionEntryNo();
            DetailedSalaryDeductEntry."Employee No." := EmployeeNo;
            DetailedSalaryDeductEntry."Employee Name" := HRMgt.GetEmployeeName(EmployeeNo);
            DetailedSalaryDeductEntry."Deduction Date" := DeductionDate;
            DetailedSalaryDeductEntry."Deduction Type" := Type;
            DetailedSalaryDeductEntry."Pay Cycle Code" := PayCycleCode;
            DetailedSalaryDeductEntry."Pay Cycle Term" := PayCycleTerm;
            DetailedSalaryDeductEntry."Pay Cycle Period" := PayCyclePeriod;
            DetailedSalaryDeductEntry."Attribute Type" := AttributeType;
            DetailedSalaryDeductEntry."Attribute Code" := AttributeCode;
            DetailedSalaryDeductEntry."Attendance No." := AttendanceNo;
            DetailedSalaryDeductEntry."Deduction Entry No." := SalaryLedgerEntryNo;
            if FromFormula then
                DetailedSalaryDeductEntry.Amount := Amount * GetSignFactor(AttributeType)
            else
                DetailedSalaryDeductEntry.Amount := CalculateDeductedAmount(Amount, DetailedSalaryDeductEntry) * GetSignFactor(AttributeType);
            DetailedSalaryDeductEntry.Insert(true);
        end;
    end;

    procedure GetDetailedSalaryDeductionEntryNo(): Integer
    var
        DetailedSalaryDeductEntry: Record "Det Salary Deduction Entry";
    begin
        DetailedSalaryDeductEntry.Reset();
        if DetailedSalaryDeductEntry.FindLast() then
            exit(DetailedSalaryDeductEntry."Entry No." + 1);

        exit(1);
    end;

    local procedure CalculateDeductedAmount(TotalAmount: Decimal; DetailedSalaryDeductEntry: Record "Det Salary Deduction Entry"): Decimal
    var
        CalculatedDays: Decimal;
        SignFactor: Integer;
    begin
        // SignFactor := 1;
        // if DetailedSalaryDeductEntry."Attribute Type" = DetailedSalaryDeductEntry."Attribute Type"::Deduction then
        //     SignFactor := -1;

        CalculatedDays := CalculateTotalDays(DetailedSalaryDeductEntry);
        if CalculatedDays <> 0 then
            exit((TotalAmount / CalculatedDays));
    end;

    local procedure GetSignFactor(AttributeType: Enum "Payroll Type"): Integer
    begin
        if AttributeType = AttributeType::Deduction then
            exit(-1)
        else
            exit(1);
    end;

    local procedure CalculateTotalDays(DetailedSalaryDeductEntry: Record "Det Salary Deduction Entry"): Decimal
    var
        PGSetup: Record "Payroll General Setup";
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PGSetup.Get();
        if PGSetup."Total Days From" = PGSetup."Total Days From"::Year then
            exit(PGSetup."Total Days" / 12);

        if GetPayCyclePeriodByDeductionDate(DetailedSalaryDeductEntry."Deduction Date", PayCyclePeriod) then
            exit(PayCyclePeriod."End Date" - PayCyclePeriod."Start Date" + 1);
    end;

    local procedure GetPayCyclePeriodByDeductionDate(DateParam: Date; var PayCyclePeriod: Record "Pay Cycle Period"): Boolean
    begin
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetFilter("Start Date", '<=%1', DateParam);
        PayCyclePeriod.SetFilter("End Date", '>=%1', DateParam);
        if PayCyclePeriod.FindFirst() then
            exit(true)

    end;

    procedure EvaluateAmountOnDetailedSalaryEntry(Expression: Code[100]; AttendanceNo: Code[20]; EmpCode: Code[20]): Decimal
    var
        OperatorStack: array[100] of Code[20];
        NumberStack: array[100] of Decimal;
        DecNumber: Decimal;
        ContiguousNumber: Boolean;
        CurrExpr: Code[100];
        Counter: Integer;
        Num1: Decimal;
        Num2: Decimal;
        operat: Code[20];
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
        BasicSalaryAfterDeduction: Decimal;
    begin
        ResolveColumnOnDetailedSalaryDeduction(Expression, AttendanceNo, EmpCode);
        Expression := DelChr(Expression, '=', ',');
        Counter := 0;
        ExNo := StrLen(Expression);
        OsNo := 0;
        NsNo := 0;
        repeat
            Counter += 1;
            if Expression[Counter] = '(' then begin
                OsNo += 1;
                OperatorStack[OsNo] := Format(Expression[Counter]);
            end else if Expression[Counter] = ')' then begin
                if OsNo <> 0 then
                    while (OperatorStack[OsNo] <> '(') and (OsNo <> 0) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
                        if OsNo = 0 then
                            break;
                    end;
                if (OsNo <> 0) then begin
                    OperatorStack[OsNo] := '';
                    OsNo -= 1;
                end;
            end
            else if Expression[Counter] in ['+', '-', '*', '/'] then begin
                if OsNo <> 0 then
                    while (OsNo <> 0) and (CheckPrecedence(OperatorStack[OsNo]) >= CheckPrecedence(Format(Expression[Counter]))) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
                        if OsNo = 0 then
                            break;
                    end;
                OsNo += 1;
                OperatorStack[OsNo] := Format(Expression[Counter]);
            end else begin
                CurrExpr := '';
                repeat
                    ContiguousNumber := false;
                    if Expression[Counter] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'] then
                        CurrExpr := CurrExpr + Format(Expression[Counter]);
                    if Counter < ExNo then begin
                        if Evaluate(DecNumber, Format(Expression[Counter + 1])) or (Expression[Counter + 1] = '.') then begin
                            ContiguousNumber := true;
                            Counter += 1;
                        end;
                    end;
                until not ContiguousNumber;
                Evaluate(DecNumber, CurrExpr);
                NsNo += 1;
                NumberStack[NsNo] := DecNumber;
            end;
        until Counter = ExNo;

        while (OsNo <> 0) do begin
            Num2 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            Num1 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            operat := OperatorStack[OsNo];
            OperatorStack[OsNo] := '';
            OsNo -= 1;
            NsNo += 1;
            NumberStack[NsNo] := CalculateValueOnBasisOfOperator(Num1, Num2, operat);
        end;
        exit(NumberStack[NsNo]);
    end;

    procedure ResolveColumnOnDetailedSalaryDeduction(var Expression: Code[100]; AttendanceNo: Code[20]; EmpCode: Code[20])
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        DetailedSalaryDeductionLine: Record "Det Salary Deduction Entry";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
        Substring1: Text;
        SubString2: Text;
        SubString3: Text;
        Length: Integer;
        CalculatedAmount: Decimal;
    begin
        Expression := DelChr(Expression, '=');

        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
            Expression := InsStr(Expression, Format(BasicAmount), StrPosition)
        end;
        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'] then begin
                PayrollAttributes.Reset;
                PayrollAttributes.SetRange("Column Name", Format(Expression[StrLength]));
                if PayrollAttributes.FindFirst then begin
                    StrPosition := StrPos(Expression, Format(Expression[StrLength]));
                    Expression := DelStr(Expression, StrPosition, StrLen(Format(Expression[StrLength])));

                    DetailedSalaryDeductionLine.SetRange("Attendance No.", AttendanceNo);
                    DetailedSalaryDeductionLine.SetRange("Employee No.", EmpCode);
                    DetailedSalaryDeductionLine.SetRange("Attribute Code", PayrollAttributes.Code);
                    DetailedSalaryDeductionLine.SetRange(Reversed, false);
                    if DetailedSalaryDeductionLine.FindFirst() then begin
                        CalculatedAmount := DetailedSalaryDeductionLine.Amount;

                        if CalculatedAmount < 0 then begin
                            Length := StrLen(Expression);
                            Substring1 := CopyStr(Expression, 1, StrPosition - 2);
                            SubString2 := CopyStr(Expression, StrPosition);
                            SubString3 := CopyStr(Expression, StrPosition - 1, 1);
                            if SubString3 = '-' then
                                Expression := InsStr(Substring1 + SubString2, '+' + Format(Abs(CalculatedAmount)), StrPosition - 1)
                            else if SubString3 = '+' then
                                Expression := InsStr(Substring1 + SubString2, '-' + Format(Abs(CalculatedAmount)), StrPosition - 1)
                        end else
                            Expression := InsStr(Expression, Format(CalculatedAmount), StrPosition)
                    end else
                        Expression := InsStr(Expression, Format(0), StrPosition);
                end;
            end;
            StrLength -= 1;
        until StrLength = 0;
    end;

    local procedure CalculateValueOnBasisOfOperator(Number1: Decimal; Number2: Decimal; Opt: Code[20]): Decimal
    begin
        case Opt of
            '*':
                exit(Number1 * Number2);
            '/':
                exit(Number1 / Number2);
            '+':
                exit(Number1 + Number2);
            '-':
                exit(Number1 - Number2);
        end;
    end;

    local procedure CheckPrecedence(Opt: Code[20]): Integer
    begin
        if (Opt = '*') or (Opt = '/') then
            exit(2);
        if (Opt = '+') or (Opt = '-') then
            exit(1);
        exit(0);
    end;

    procedure CheckAbsentEntriesBeforePosting(AttendanceHeader: Record "Attendance Header")
    var
        SalaryDeductionEntry: Record "Salary Deduction Entry";
        EmployeeAttendance: Record "Employee Attendance & Activity";
    begin
        SalaryDeductionEntry.Reset();
        SalaryDeductionEntry.SetRange("Attendance Document No", AttendanceHeader."No.");
        SalaryDeductionEntry.SetRange("Deduction Type", SalaryDeductionEntry."Deduction Type"::Absent);
        SalaryDeductionEntry.SetRange(Reversed, false);
        if SalaryDeductionEntry.FindSet() then
            repeat
                EmployeeAttendance.SetRange("Employee No.", SalaryDeductionEntry."Employee No.");
                EmployeeAttendance.SetRange("Attendance Date", SalaryDeductionEntry."Deduction Date");
                EmployeeAttendance.SetRange("Absent Day", 0);
                if EmployeeAttendance.FindFirst() then
                    Error('Cannot post absent deduction entry of %1. Employee is not absent on %2',
                     SalaryDeductionEntry."Employee Name", SalaryDeductionEntry."Deduction Date");
            until SalaryDeductionEntry.Next() = 0;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";

    [IntegrationEvent(false, false)]
    local procedure OnAfterFilterEmpAttendanceActivityOnLateDeduction(var EmpAttendanceAct: Record "Employee Attendance & Activity"; AttendanceHeader: Record "Attendance Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFilterEmpAttendanceActivityOnAbsentDeduction(var EmpAttendanceAct: Record "Employee Attendance & Activity"; AttendanceHeader: Record "Attendance Header")
    begin
    end;
}