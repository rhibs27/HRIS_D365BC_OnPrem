report 50141 "KPI Management"
{
    // version KPI1.00

    ProcessingOnly = true;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        Clear(KPIMgt);//KPI1.00
        Clear(KPIDailyScore);
        Clear(EmployeeRec);
        Clear(KPIDailyScpre1);
        CalculateKPIs;//KPI1.00
    end;

    var
        KPIMgt: Codeunit "KPI Mgt.";
        KPIDailyScore: Record "KPI Daily Score";
        EmployeeRec: Record Employee;
        EmpCode: Code[20];
        DepCode: Code[20];
        KPIDailyScpre1: Record "KPI Daily Score";
        ExcessScore: Decimal;

    local procedure InsertDailyIncentive(EmpCode: Code[20])
    var
        DailyIncentive: Record "KPI Daily Incentive";
    begin
        //<<KPI1.00
        DailyIncentive.Reset;
        DailyIncentive.SetRange(Calculated, false);
        DailyIncentive.SetRange(Type, DailyIncentive.Type::Employee);
        DailyIncentive.SetRange("Employee Code", EmpCode);
        if not DailyIncentive.FindFirst then begin
            DailyIncentive.Init;
            DailyIncentive."Employee Code" := EmpCode;
            DailyIncentive."Location Incentive" := KPIMgt.CalculateLocationIncentive(EmpCode);
            DailyIncentive."Role Incentive" := KPIMgt.CalculateRoleIncentive(EmpCode);
            DailyIncentive.Validate("Entry Date", KPIMgt.EntryDateForIncentive(EmpCode));
            DailyIncentive.Validate("Net KPI Score", KPIMgt.CalculateDailyKPIScoreSummary(EmpCode) + DailyIncentive."Location Incentive" + DailyIncentive."Role Incentive");
            DailyIncentive.Validate("KPI Score", KPIMgt.CalculateDailyKPIScoreSummary(EmpCode));
            DailyIncentive.Validate(Type, DailyIncentive.Type::Employee);
            if EmployeeRec.Get(EmpCode) then
                DailyIncentive.Validate("Functional Title", EmployeeRec."KPI Functional Title");
            DailyIncentive.Validate(Calculated, true);
            DailyIncentive.Insert(true);
        end;
        //>>KPI1.00
    end;

    procedure CalculateKPIs()
    var
        EmpRec: Record Employee;
    begin
        //<<KPI1.00
        Clear(EmpCode);
        Clear(DepCode);
        Clear(ExcessScore);
        KPIDailyScore.Reset;
        KPIDailyScore.SetRange(Calculated, false);
        KPIDailyScore.SetCurrentKey("Employee Code", Department);
        if KPIDailyScore.FindSet then
            repeat
                if KPIDailyScore.Type = KPIDailyScore.Type::Employee then begin
                    if EmpCode <> KPIDailyScore."Employee Code" then begin
                        KPIMgt.DailyKPIScoreCalculationIndv(KPIDailyScore."Employee Code");
                        EmpCode := KPIDailyScore."Employee Code";
                        if EmpRec.Get(KPIDailyScore."Employee Code") then begin
                            if EmpRec."KPI Deputation" in [EmpRec."KPI Deputation"::Branch, EmpRec."KPI Deputation"::"Extension Counter", EmpRec."KPI Deputation"::Department, EmpRec."KPI Deputation"::Unit] then
                                KPIMgt.InsertDeptScoreForEmployee(KPIDailyScore."Employee Code");
                        end;
                        if KPIMgt.OperatingProfitScore(KPIDailyScore."Employee Code") > 0 then
                            ExcessScore := KPIMgt.ScoreWithoutOperatingProfit(KPIDailyScore."Employee Code") - KPIMgt.OperatingProfitScore(KPIDailyScore."Employee Code");
                        if ExcessScore > 0 then
                            KPIMgt.InsertAdjustmentKPIScore(KPIDailyScore."Employee Code", -ExcessScore);
                        InsertDailyIncentive(KPIDailyScore."Employee Code");
                    end;
                end
                else if KPIDailyScore.Type = KPIDailyScore.Type::Department then begin
                    if DepCode <> KPIDailyScore.Department then begin
                        KPIMgt.DailyKPIScoreCalculationDept(KPIDailyScore.Department);
                        DepCode := KPIDailyScore.Department;
                        InsertNetKpiForDepartment(KPIDailyScore.Department);
                    end;
                end;
                KPIDailyScpre1.Reset;
                KPIDailyScpre1.SetRange(Calculated, false);
                if KPIDailyScore.Type = KPIDailyScore.Type::Employee then begin
                    KPIDailyScpre1.SetRange(Type, KPIDailyScpre1.Type::Employee);
                    KPIDailyScpre1.SetRange("Employee Code", KPIDailyScore."Employee Code");
                end
                else if KPIDailyScore.Type = KPIDailyScore.Type::Department then begin
                    KPIDailyScpre1.SetRange(Type, KPIDailyScpre1.Type::Department);
                    KPIDailyScpre1.SetRange(Department, KPIDailyScore.Department);
                end;
                if KPIDailyScpre1.FindSet then
                    repeat
                        KPIDailyScpre1.Validate(Calculated, true);
                        KPIDailyScpre1.Modify;
                    until KPIDailyScpre1.Next = 0;
            until KPIDailyScore.Next = 0;
        //>>KPI1.00
    end;

    local procedure InsertNetKpiForDepartment(DeptCode: Code[20])
    var
        DailyIncentiveDept: Record "KPI Daily Incentive";
    begin
        //<<KPI1.00
        DailyIncentiveDept.Reset;
        DailyIncentiveDept.SetRange(Calculated, false);
        DailyIncentiveDept.SetRange(Type, DailyIncentiveDept.Type::Department);
        DailyIncentiveDept.SetRange(Department, DeptCode);
        if not DailyIncentiveDept.FindFirst then begin
            DailyIncentiveDept.Init;
            DailyIncentiveDept.Department := DeptCode;
            DailyIncentiveDept."Entry Date" := KPIMgt.EntryDateForIncentive(DeptCode);
            DailyIncentiveDept.Validate(Type, DailyIncentiveDept.Type::Department);
            DailyIncentiveDept."Net KPI Score" := KPIMgt.CalculateDailyKPIScoreSummaryDept(DeptCode);
            DailyIncentiveDept.Validate(Type, DailyIncentiveDept.Type::Department);
            DailyIncentiveDept.Validate(Calculated, true);
            DailyIncentiveDept.Insert(true);
        end;
        //>>KPI1.00
    end;
}
