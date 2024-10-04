report 33019807 "Pay Cycle Period Generator"
{
    // version PRM19.01.01

    Caption = 'Pay Cycle Period Generator';
    // Permissions = TableData TableData37032300 = rim;
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                if (PayCycleCode = '') or (PayCycleTermCode = '') then
                    Error(Text009);
                PayCyclePeriod.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term");
                PayCyclePeriod.SetRange("Pay Cycle Code", PayCycleCode);
                PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTermCode);
                if PayCyclePeriod.FindSet(true, true) then begin
                    if Confirm(Text008 + Text008a, false) then begin
                        PayCyclePeriod.DeleteAll;
                        GeneratePayPeriods;
                        PayrollLedgerEntry.SetRange("Pay Cycle Code", PayCycleCode);
                        PayrollLedgerEntry.SetRange("Pay Cycle Term", PayCycleTermCode);
                        if PayrollLedgerEntry.FindSet(true, false) then begin
                            repeat
                                PayCyclePeriod.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term", Period);
                                PayCyclePeriod.SetRange("Pay Cycle Code", PayCycleCode);
                                PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTermCode);
                                PayCyclePeriod.SetRange(Period, PayrollLedgerEntry."Pay Cycle Period");
                                if PayCyclePeriod.Find('-') then begin
                                    PayrollLedgerEntry."Pay Period Start Date" := PayCyclePeriod."Start Date";
                                    PayrollLedgerEntry."Pay Period End Date" := PayCyclePeriod."End Date";
                                    PayrollLedgerEntry.Modify;
                                end;
                            until PayrollLedgerEntry.Next = 0;
                        end;
                    end else
                        exit;
                end else
                    GeneratePayPeriods;
            end;

            trigger OnPreDataItem()
            begin
                if PayCycleCode = '' then
                    Error(Text000);
                if PayCycleTermCode = '' then
                    Error(Text009);
                if PayPeriodsToGenerate <= 0 then
                    Error(Text013);

                if (PayFrequency = PayFrequency::Other) and
                   (GenerateFrequency = GenerateFrequency::" ") then
                    Error(Text040);

                if FROMPayPeriodStart = 0D then
                    Error(Text011);
            end;
        }
    }

    requestpage
    {
        Caption = 'Pay Cycle Period Generator';

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PayCycleCodeTextBox; PayCycleCode)
                    {
                        Caption = 'Pay Cycle Code';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                        ApplicationArea = All;
                    }
                    field(PayCycleTermCodeTextBox; PayCycleTermCode)
                    {
                        Caption = 'Pay Cycle Term';
                        Editable = false;
                        Enabled = true;
                        ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                        ApplicationArea = All;
                    }
                    field(PayFrequency; PayFrequency)
                    {
                        Caption = 'Pay Frequency';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Pay Frequency field.';
                        ApplicationArea = All;
                    }
                    field(DefaultPayPeriods; DefaultPayPeriods)
                    {
                        Caption = 'Default Pay Periods';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Default Pay Periods field.';
                        ApplicationArea = All;
                    }
                    field(GenerateFrequency; GenerateFrequency)
                    {
                        Caption = 'Generate Frequency';
                        Editable = GenerateFrequencyEditable;
                        ToolTip = 'Specifies the value of the Generate Frequency field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            PayPeriodsToGenerate := GetDefaultPayPeriods();
                            DefaultPayPeriods := GetDefaultPayPeriods();
                            if GenerateFrequency = GenerateFrequency::"Date Formula" then begin
                                DateFormulaEditable := true;
                            end
                            else begin
                                Clear(DateFormula);
                                DateFormulaEditable := false;
                            end;
                        end;
                    }
                    field(DateFormula; DateFormula)
                    {
                        Caption = 'Date Formula';
                        Editable = DateFormulaEditable;
                        ToolTip = 'Specifies the value of the Date Formula field.';
                        ApplicationArea = All;
                    }
                    field(PayPeriodsToGenerate; PayPeriodsToGenerate)
                    {
                        Caption = 'Pay Periods to Generate';
                        Editable = PayPeriodsToGenerateEditable;
                        ToolTip = 'Specifies the value of the Pay Periods to Generate field.';
                        ApplicationArea = All;
                        // Numeric = true;

                        trigger OnValidate()
                        begin
                            if PayPeriodsToGenerate <= 0 then
                                Error(Text013);

                            case PayFrequency of
                                PayFrequency::Weekly:
                                    begin
                                        if (PayPeriodsToGenerate <> 52) and (PayPeriodsToGenerate <> 53) then
                                            Error('%1', Text027);
                                        if PayPeriodsToGenerate <> 52 then
                                            Message('%1', Text024);
                                    end;
                                PayFrequency::BiWeekly:
                                    begin
                                        if (PayPeriodsToGenerate <> 26) and (PayPeriodsToGenerate <> 27) then
                                            Error('%1', Text028);
                                        if PayPeriodsToGenerate <> 26 then
                                            Message('%1', Text025);
                                    end;
                                PayFrequency::Miscellaneous:
                                    begin
                                        if (PayPeriodsToGenerate <> 365) and (PayPeriodsToGenerate <> 366) then
                                            Error('%1', Text029);
                                        if PayPeriodsToGenerate <> 365 then
                                            Message('%1', Text026);
                                    end;
                                PayFrequency::Other:
                                    begin
                                        case GenerateFrequency of
                                            GenerateFrequency::Weekly:
                                                if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 53) then
                                                    Error('%1', Text030);
                                            GenerateFrequency::BiWeekly:
                                                if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 27) then
                                                    Error('%1', Text031);
                                            GenerateFrequency::SemiMonthly:
                                                if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 24) then
                                                    Error('%1', Text032);
                                            GenerateFrequency::Monthly:
                                                if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 12) then
                                                    Error('%1', Text033);
                                            GenerateFrequency::BiMonthly:
                                                if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 6) then
                                                    Error('%1', Text034);
                                            GenerateFrequency::Quarterly:
                                                if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 4) then
                                                    Error('%1', Text035);
                                            GenerateFrequency::SemiAnnually:
                                                if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 2) then
                                                    Error('%1', Text036);
                                            GenerateFrequency::"Date Formula":
                                                begin
                                                    if (PayPeriodsToGenerate < 1) or (PayPeriodsToGenerate > 366) then
                                                        Error('%1', Text037);
                                                    DefaultPayPeriods := PayPeriodsToGenerate;
                                                end;
                                        end;
                                    end;
                            end;
                        end;
                    }
                    field(FROMPayPeriodStart; FROMPayPeriodStart)
                    {
                        Caption = 'Pay Period Start Date';
                        ToolTip = 'Specifies the value of the Pay Period Start Date field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if PayFrequency = PayFrequency::SemiMonthly then begin
                                Day := Date2DMY(FROMPayPeriodStart, 1);
                                if (Day <> 1) and (Day <> 16) then begin
                                    Clear(FROMPayPeriodStart);
                                    Message(Text002);
                                end;
                            end;
                        end;
                    }
                    field(DefaultInsurableHours; InsurableHours)
                    {
                        Caption = 'Default Insurable Hours';
                        Visible = DefaultInsurableHoursVisible;
                        ToolTip = 'Specifies the value of the Default Insurable Hours field.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions { }

        trigger OnInit()
        begin
            PayPeriodsToGenerateEditable := true;
            GenerateFrequencyEditable := true;
            DefaultInsurableHoursVisible := true;
            DateFormulaEditable := true;
        end;

        trigger OnOpenPage()
        begin
            if GenerateFrequency = GenerateFrequency::"Date Formula" then begin
                DateFormulaEditable := true;
            end
            else begin
                Clear(DateFormula);
                DateFormulaEditable := false;
            end;

            if (PayCycleCode = '') or (PayCycleTermCode = '') then begin
                Error('%1', Text039);
            end;

            PRSetup.FindFirst();

            InsurableHours := 0;
            DefaultInsurableHoursVisible := false;
        end;
    }

    labels { }

    var
        PayCycle: Record "Pay Cycle";
        PayCyclePeriod: Record "Pay Cycle Period";
        PayCycleTerm: Record "Pay Cycle Term";
        PayrollLedgerEntry: Record "Employee Ledger Entry PRM";
        PRSetup: Record "Payroll General Setup";
        ENDate: Record "English-Nepali Date";
        SENDate: Record "English-Nepali Date";
        PayFrequency: Enum "Pay Frequency";
        GenerateFrequency: Option " ",Weekly,BiWeekly,SemiMonthly,Monthly,BiMonthly,Quarterly,SemiAnnually,"Date Formula";
        DateFormula: Text[20];
        PayCycleCode: Code[10];
        FROMPayPeriodStart: Date;
        CurrPayPeriodStart: Date;
        CurrPayPeriodEnd: Date;
        CountPeriods: Integer;
        DefaultPayPeriods: Integer;
        PayCycleTermCode: Code[10];
        PayPeriodsToGenerate: Integer;
        Day: Integer;
        WhatDay: Integer;
        Text000: Label 'You must enter a Pay Cycle before doing a generate.';
        Text001: Label 'Unable to generate.  This pay frequency (%1) is not being handled.';
        Text002: Label 'The Start Date must be the 1st or 16th for a Pay Frequency of Semi-Monthly.';
        Text003: Label 'Created %1 Pay Cycle Period records for the selected Pay Cycle Term.';
        Text004: Label 'Please enter a valid pay cycle code.  %1 is not a valid code.';
        Text008: Label 'Pay Period records already exist for the selected Pay Cycle and Pay Cycle Term.  Do you wish to regenerate the Pay Periods?';
        Text008a: Label '  If yes, the existing Pay Period records will be deleted and regenerated. Corresponding transactions in the Payroll Ledger will also be updated with the new Pay Period information.';
        Text009: Label 'Pay Cycle Code/Pay Cycle Term cannot be blank.';
        DayOfMonth: Integer;
        MonthNo: Integer;
        YearNo: Integer;
        Text011: Label 'Pay Period Start Date must be entered.';
        Text012: Label 'The Term %1 for Pay Cycle %2 could not be found in the Pay Cycle Term table.';
        Text013: Label 'Pay Periods to Generate must be greater than 0.';
        InsurableHours: Decimal;
        NewTermStartDate: Date;
        NewTermEndDate: Date;
        Text023: Label 'You cannot create periods for the new term because the dates that the term spans overlaps the span of an existing term %1 within the same Pay Cycle Code.';
        Text024: Label 'Warning: Pay Periods to Generate is usually 52.';
        Text025: Label 'Warning: Pay Periods to Generate is usually 26.';
        Text026: Label 'Warning: Pay Periods to Generate is usually 365.';
        Text027: Label 'Pay Periods to Generate must be 52 or 53.';
        Text028: Label 'Pay Periods to Generate must be 26 or 27.';
        Text029: Label 'Pay Periods to Generate must be 365 or 366.';
        Text030: Label 'Pay Periods to Generate must be between 1 and 53.';
        Text031: Label 'Pay Periods to Generate must be between 1 and 27.';
        Text032: Label 'Pay Periods to Generate must be between 1 and 24.';
        Text033: Label 'Pay Periods to Generate must be between 1 and 12.';
        Text034: Label 'Pay Periods to Generate must be between 1 and 6.';
        Text035: Label 'Pay Periods to Generate must be between 1 and 4.';
        Text036: Label 'Pay Periods to Generate must be between 1 and 2.';
        Text037: Label 'Pay Periods to Generate must be between 1 and 366.';
        Text038: Label 'A generated Start Date cannot exceed the Pay Period Start Date plus one year.';
        Text039: Label 'This report can only be run from the Pay Cycle Terms form.';
        Text040: Label 'You must enter a Generate Frequency.';
        [InDataSet]
        DateFormulaEditable: Boolean;
        [InDataSet]
        DefaultInsurableHoursVisible: Boolean;
        [InDataSet]
        GenerateFrequencyEditable: Boolean;
        [InDataSet]
        PayPeriodsToGenerateEditable: Boolean;

    procedure GeneratePayPeriods()
    begin
        CurrPayPeriodStart := FROMPayPeriodStart;
        DayOfMonth := Date2DMY(FROMPayPeriodStart, 1);

        CountPeriods := 0;
        PayCyclePeriod.Reset;
        while CountPeriods < PayPeriodsToGenerate do begin
            PayCyclePeriod."Pay Cycle Code" := PayCycleCode;
            PayCyclePeriod."Start Date" := CurrPayPeriodStart;
            PayCyclePeriod."Pay Cycle Term" := PayCycleTermCode;
            CountPeriods := CountPeriods + 1;
            case PayFrequency of
                PayFrequency::Weekly:
                    CurrPayPeriodEnd := CalcDate('<+1W - 1D>', CurrPayPeriodStart);
                PayFrequency::BiWeekly:
                    CurrPayPeriodEnd := CalcDate('<+2W - 1D>', CurrPayPeriodStart);
                PayFrequency::SemiMonthly:
                    begin
                        if Date2DMY(CurrPayPeriodStart, 1) = 16 then
                            CurrPayPeriodEnd := CalcDate('<CM>', CurrPayPeriodStart)
                        else
                            CurrPayPeriodEnd := CalcDate('<+2W>', CurrPayPeriodStart);
                    end;
                PayFrequency::Monthly:
                    begin
                        if DayOfMonth in [1 .. 28] then begin
                            CurrPayPeriodEnd := CalcDate('<+1M-1D>', CurrPayPeriodStart);
                        end;
                        if DayOfMonth = 29 then begin
                            CurrPayPeriodEnd := CalcDate('<+1M>', CurrPayPeriodStart);
                            YearNo := Date2DMY(CurrPayPeriodEnd, 3);
                            if (Date2DMY(CurrPayPeriodEnd, 3) mod 4) <> 0 then begin
                                if (Date2DMY(CurrPayPeriodEnd, 2) = 2) then begin
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 2), 2, YearNo);
                                end else begin
                                    MonthNo := Date2DMY(CurrPayPeriodEnd, 2);
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 1), MonthNo, YearNo);
                                end;
                            end else begin
                                if (Date2DMY(CurrPayPeriodEnd, 2) = 2) then begin
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 1), 2, YearNo);
                                end else begin
                                    MonthNo := Date2DMY(CurrPayPeriodEnd, 2);
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth), MonthNo, YearNo);
                                    CurrPayPeriodEnd := CurrPayPeriodEnd - 1;
                                end;
                            end;
                        end;
                        if DayOfMonth = 30 then begin
                            CurrPayPeriodEnd := CalcDate('<+1M>', CurrPayPeriodStart);
                            YearNo := Date2DMY(CurrPayPeriodEnd, 3);
                            if (Date2DMY(CurrPayPeriodEnd, 3) mod 4) <> 0 then begin
                                if (Date2DMY(CurrPayPeriodEnd, 2) = 2) then begin
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 3), 2, YearNo);
                                end else begin
                                    MonthNo := Date2DMY(CurrPayPeriodEnd, 2);
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 1), MonthNo, YearNo);
                                end;
                            end else begin
                                if (Date2DMY(CurrPayPeriodEnd, 2) = 2) then begin
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 2), 2, YearNo);
                                end else begin
                                    MonthNo := Date2DMY(CurrPayPeriodEnd, 2);
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth), MonthNo, YearNo);
                                    CurrPayPeriodEnd := CurrPayPeriodEnd - 1;
                                end;
                            end;
                        end;
                        if DayOfMonth = 31 then begin
                            CurrPayPeriodEnd := CalcDate('<+1M + CM>', CurrPayPeriodStart);
                            YearNo := Date2DMY(CurrPayPeriodEnd, 3);
                            if (Date2DMY(CurrPayPeriodEnd, 3) mod 4) <> 0 then begin
                                if (Date2DMY(CurrPayPeriodEnd, 2) = 2) then begin
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 4), 2, YearNo);
                                end else begin
                                    MonthNo := Date2DMY(CurrPayPeriodEnd, 2);
                                    if MonthNo in [1, 3, 5, 7, 8, 10, 12] then begin
                                        CurrPayPeriodEnd := DMY2Date((DayOfMonth), MonthNo, YearNo);
                                    end else if MonthNo in [4, 6, 9, 11] then begin
                                        CurrPayPeriodEnd := DMY2Date((DayOfMonth - 1), MonthNo, YearNo);
                                    end;
                                    CurrPayPeriodEnd := CurrPayPeriodEnd - 1;
                                end;
                            end else begin
                                if (Date2DMY(CurrPayPeriodEnd, 2) = 2) then begin
                                    CurrPayPeriodEnd := DMY2Date((DayOfMonth - 3), 2, YearNo);
                                end else begin
                                    MonthNo := Date2DMY(CurrPayPeriodEnd, 2);
                                    if MonthNo in [1, 3, 5, 7, 8, 10, 12] then begin
                                        CurrPayPeriodEnd := DMY2Date((DayOfMonth), MonthNo, YearNo);
                                    end else if MonthNo in [4, 6, 9, 11] then begin
                                        CurrPayPeriodEnd := DMY2Date((DayOfMonth - 1), MonthNo, YearNo);
                                    end;
                                    CurrPayPeriodEnd := CurrPayPeriodEnd - 1;
                                end;
                            end;
                        end;
                    end;
                PayFrequency::BiMonthly:
                    CurrPayPeriodEnd := CalcDate('<CM>', CalcDate('<+2M - 1D>', CurrPayPeriodStart));
                PayFrequency::Quarterly:
                    CurrPayPeriodEnd := CalcDate('<CM>', CalcDate('<+1Q - 1D>', CurrPayPeriodStart));
                PayFrequency::SemiAnnually:
                    CurrPayPeriodEnd := CalcDate('<CM>', CalcDate('<+6M - 1D>', CurrPayPeriodStart));
                PayFrequency::Annually:
                    CurrPayPeriodEnd := CalcDate('<CM>', CalcDate('<+1Y - 1D>', CurrPayPeriodStart));
                PayFrequency::Miscellaneous:
                    CurrPayPeriodEnd := CurrPayPeriodStart;
                PayFrequency::Other:
                    begin
                        case GenerateFrequency of
                            GenerateFrequency::Weekly:
                                CurrPayPeriodEnd := CalcDate('<+1W - 1D>', CurrPayPeriodStart);
                            GenerateFrequency::BiWeekly:
                                CurrPayPeriodEnd := CalcDate('<+2W - 1D>', CurrPayPeriodStart);
                            GenerateFrequency::SemiMonthly:
                                begin
                                    if Date2DMY(CurrPayPeriodStart, 1) = 16 then
                                        CurrPayPeriodEnd := CalcDate('<CM>', CurrPayPeriodStart)
                                    else
                                        CurrPayPeriodEnd := CalcDate('<+2W>', CurrPayPeriodStart);
                                end;
                            GenerateFrequency::Monthly:
                                CurrPayPeriodEnd := CalcDate('<+1M -1D>', CurrPayPeriodStart);
                            GenerateFrequency::BiMonthly:
                                CurrPayPeriodEnd := CalcDate('<CM>', CalcDate('<+2M - 1D>', CurrPayPeriodStart));
                            GenerateFrequency::Quarterly:
                                CurrPayPeriodEnd := CalcDate('<CM>', CalcDate('<+1Q - 1D>', CurrPayPeriodStart));
                            GenerateFrequency::SemiAnnually:
                                CurrPayPeriodEnd := CalcDate('<CM>', CalcDate('<+6M - 1D>', CurrPayPeriodStart));
                            GenerateFrequency::"Date Formula":
                                CurrPayPeriodEnd := CalcDate(DateFormula, CurrPayPeriodStart);
                        end;
                    end;
                else
                    Error(Text001, Format(PayFrequency));
            end;
            PayCyclePeriod."End Date" := CurrPayPeriodEnd;
            if PayFrequency = PayFrequency::Monthly then begin
                ENDate.Reset;
                ENDate.SetRange("English Date", PayCyclePeriod."Start Date");
                if ENDate.FindFirst then
                    PayCyclePeriod."Nepali Month" := ENDate."Nepali Month";
                SENDate.Reset;
                SENDate.SetCurrentKey("Nepali Year", "Nepali Month");
                SENDate.SetRange("Nepali Year", ENDate."Nepali Year");
                SENDate.SetRange("Nepali Month", ENDate."Nepali Month");
                if SENDate.FindLast then begin
                    CurrPayPeriodEnd := SENDate."English Date";
                    PayCyclePeriod."End Date" := CurrPayPeriodEnd;
                end;
            end;
            PayCyclePeriod."Pay Date" := PayCyclePeriod."End Date" + PayCycle."Payment Delay";
            WhatDay := Date2DWY(PayCyclePeriod."Pay Date", 1);
            if WhatDay = 6 then
                PayCyclePeriod."Pay Date" := (CalcDate('<-1D>', PayCyclePeriod."Pay Date"));
            PayCyclePeriod.Period := CountPeriods;

            if CountPeriods = 1 then begin
                NewTermStartDate := PayCyclePeriod."Start Date";
            end;
            if CountPeriods = PayPeriodsToGenerate then begin
                NewTermEndDate := PayCyclePeriod."End Date";
            end;

            PayCyclePeriod.Insert;
            CurrPayPeriodStart := CurrPayPeriodEnd + 1;
        end;

        OverlapCheck(NewTermStartDate, NewTermEndDate, PayCycleTermCode, PayCycleCode);

        PayCyclePeriod.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term");
        PayCyclePeriod.SetRange("Pay Cycle Code", PayCycleCode);
        PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTermCode);
        if PayCyclePeriod.Find('+') then begin
            if PayCyclePeriod."Start Date" >= CalcDate('<+1Y>', FROMPayPeriodStart) then
                Error('%1', Text038);
        end;
        PayCyclePeriod.SetRange("Pay Cycle Code");
        PayCyclePeriod.SetRange("Pay Cycle Term");

        if PayFrequency = PayFrequency::Other then begin
            PayCycleTerm.SetCurrentKey("Pay Cycle Code", Term);
            PayCycleTerm.Get(PayCycleCode, PayCycleTermCode);
            if GenerateFrequency = GenerateFrequency::"Date Formula" then
                PayCycleTerm."Default Periods" := PayPeriodsToGenerate
            else
                PayCycleTerm."Default Periods" := GetDefaultPayPeriods();
            PayCycleTerm.Modify;
        end;

        Message(Text003, CountPeriods);
    end;

    procedure GetDefaultPayPeriods(): Integer
    var
        Periods: Integer;
    begin
        Periods := 0;
        case GenerateFrequency of
            GenerateFrequency::Weekly:
                Periods := 52;
            GenerateFrequency::BiWeekly:
                Periods := 26;
            GenerateFrequency::SemiMonthly:
                Periods := 24;
            GenerateFrequency::Monthly:
                Periods := 12;
            GenerateFrequency::BiMonthly:
                Periods := 6;
            GenerateFrequency::Quarterly:
                Periods := 4;
            GenerateFrequency::SemiAnnually:
                Periods := 2;
            else
                Periods := 0;
        end;
        exit(Periods);
    end;

    procedure SetOptions(PayCycleTermTemp: Record "Pay Cycle Term")
    begin
        PayCycleCode := PayCycleTermTemp."Pay Cycle Code";
        PayCycleTermCode := PayCycleTermTemp.Term;
        DefaultPayPeriods := PayCycleTermTemp."Default Periods";

        PayCycle.SetCurrentKey(Code);
        PayCycle.SetRange(Code, PayCycleCode);
        if PayCycle.FindFirst() then
            PayFrequency := PayCycle."Pay Frequency"
        else
            Error(Text004, PayCycleCode);

        PayCycleTerm.SetCurrentKey("Pay Cycle Code", Term);
        PayCycleTerm.SetRange("Pay Cycle Code", PayCycleCode);
        PayCycleTerm.SetRange(Term, PayCycleTermCode);
        if not PayCycleTerm.FindFirst() then
            Error(Text012, PayCycleTermCode, PayCycleCode);

        Clear(GenerateFrequency);
        Clear(DateFormula);
        if PayFrequency = PayFrequency::Other then begin
            Clear(DefaultPayPeriods);
            GenerateFrequencyEditable := true;
        end
        else begin
            GenerateFrequencyEditable := false;
        end;

        if (PayFrequency <> PayFrequency::Weekly) and
           (PayFrequency <> PayFrequency::BiWeekly) and
           (PayFrequency <> PayFrequency::Miscellaneous) and
           (PayFrequency <> PayFrequency::Other) then begin
            PayPeriodsToGenerate := DefaultPayPeriods;
            PayPeriodsToGenerateEditable := false;
        end
        else
            PayPeriodsToGenerateEditable := true;
    end;

    procedure OverlapCheck(NewTermStartDate: Date; NewTermEndDate: Date; PayCycleTermCode: Code[10]; PayCycleCode: Code[10])
    var
        PayCycleTerm2: Record "Pay Cycle Term";
        PayCyclePeriod2: Record "Pay Cycle Period";
        ExistingTermStartDate: Date;
        ExistingTermEndDate: Date;
    begin
        PayCycleTerm2.Reset;
        PayCycleTerm2.SetRange("Pay Cycle Code", PayCycleCode);
        PayCycleTerm2.SetFilter(Term, '<>%1', PayCycleTermCode);
        if PayCycleTerm2.FindSet(true, true) then begin
            PayCyclePeriod2.Reset;
            PayCyclePeriod2.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term", Period);
            PayCyclePeriod2.SetRange("Pay Cycle Code", PayCycleTerm2."Pay Cycle Code");
            repeat
                PayCyclePeriod2.SetRange("Pay Cycle Term", PayCycleTerm2.Term);
                if PayCyclePeriod2.FindFirst then begin
                    ExistingTermStartDate := PayCyclePeriod2."Start Date";
                end;
                if PayCyclePeriod2.FindLast then begin
                    ExistingTermEndDate := PayCyclePeriod2."End Date";
                end;
                if IsTermSpanOverlapping(NewTermStartDate, NewTermEndDate,
                                         ExistingTermStartDate, ExistingTermEndDate) then begin
                    Error(Text023, PayCycleTerm2.Term);
                end
            until PayCycleTerm2.Next = 0;
        end;
    end;

    procedure IsTermSpanOverlapping(NewTermStartDate: Date; NewTermEndDate: Date; ExistingTermStartDate: Date; ExistingTermEndDate: Date): Boolean
    begin
        if (ExistingTermStartDate <= NewTermEndDate) and (ExistingTermEndDate >= NewTermStartDate) then begin
            exit(true);
        end;
    end;
}
