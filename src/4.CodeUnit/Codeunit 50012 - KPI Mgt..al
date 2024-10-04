codeunit 50012 "KPI Mgt."
{
    // version KPI1.00


    trigger OnRun()
    begin
    end;

    var
        DimensionValues: Record "Dimension Value";
        LocationIncentivePer: Decimal;
        RemoteAreaCategory: Record "Remote Area Category";
        CategoryIncentive: Decimal;
        Province: Record Province;
        AppriasalHeader: Record "KPI Appraisal Header NIC";
        AccountingPeriod: Record "Accounting Period";
        EngNepDate: Record "English-Nepali Date";
        DateRec: Record Date;
        HrMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        KPIDailyScore: Record "KPI Daily Score";
        KPIDailyScore1: Record "KPI Daily Score";
        DeptCode: Code[20];
        Department: Record Department;
        KPIMaster: Record "KPI Master NIC";

    procedure DailyKPIScoreCalculationIndv(EmpCode: Code[20])
    var
        AppriasalLine: Record "KPI Appraisal (NIC) Lines";
    begin
        KPIDailyScore.Reset;
        KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Employee);
        KPIDailyScore.SetRange("Employee Code", EmpCode);
        KPIDailyScore.SetRange(Calculated, false);
        if KPIDailyScore.FindSet then
            repeat
                if KPIDailyScore."Target Per Day" <> 0 then begin
                    if KPIDailyScore."Actual Score Per Day" < KPIDailyScore."Target Per Day" then
                        KPIDailyScore."KPI Score" := (KPIDailyScore."Weightage%" * KPIDailyScore."Actual Score Per Day") / KPIDailyScore."Target Per Day";
                    if KPIDailyScore."Actual Score Per Day" > KPIDailyScore."Target Per Day" then
                        KPIDailyScore."KPI Score" := (KPIDailyScore."Weightage%" * KPIDailyScore."Target Per Day") / KPIDailyScore."Target Per Day";
                end;
                KPIDailyScore.Modify;
            until KPIDailyScore.Next = 0;
    end;

    procedure CategoryAndDistrictIncentive(EmpCode: Code[25]): Decimal
    var
        Employee: Record Employee;
        HrSetup: Record "Human Resources Setup";
    begin
        HrSetup.Get;//KPI1.00 Aakrista to calculate location incentive
        Employee.Get(EmpCode);
        if not (Employee."KPI Deputation" in [Employee."KPI Deputation"::Branch, Employee."KPI Deputation"::"Extension Counter", Employee."KPI Deputation"::Province, Employee."KPI Deputation"::Unit]) then
            exit(0);
        DimensionValues.Reset;
        DimensionValues.SetRange(Code, Employee."Global Dimension 1 Code");
        if DimensionValues.FindFirst then begin
            Province.Get(DimensionValues.Province);
            if DimensionValues."Inside/Outisde Valley" = DimensionValues."Inside/Outisde Valley"::Inside then
                exit(0);
            if EligibleForIncentive(EmpCode) then begin
                RemoteAreaCategory.Reset;
                RemoteAreaCategory.SetRange(Category, DimensionValues."Remote Area Category");
                if RemoteAreaCategory.FindFirst then begin
                    CategoryIncentive := RemoteAreaCategory."KPI Incentive %";
                end;
                if not (Province.Description in [Employee."Permanent Province", Employee."Temporary Province"]) then
                    exit((HrSetup."Location Incentive 3" / 100) * (CategoryIncentive / 100));
                if not (DimensionValues.District in [Employee."Permanent District", Employee."Temporary District"]) then
                    exit((HrSetup."Location Incentive 2" / 100) * (CategoryIncentive) / 100);
                if not (DimensionValues.Municipality in [Employee."Permanent VDC", Employee."Temporary VDC"]) then
                    exit((HrSetup."Location Incentive 1" / 100) * (CategoryIncentive) / 100);
                exit(0);
            end;
        end;
        //<<KPI1.00 Aakrista
    end;

    procedure EligibleForIncentive(EmplCode: Code[20]): Boolean
    var
        AppriasalHdr: Record "KPI Appraisal Header NIC";
        KPIratingSetup: Record "KPI Rating Setup";
        KPIDailyScore: Record "KPI Daily Score";
        KPIDailyScore1: Record "KPI Daily Score";
    begin
        KPIDailyScore.Reset;
        KPIDailyScore.SetCurrentKey("Employee Code");
        KPIDailyScore.SetRange("Employee Code", EmplCode);
        KPIDailyScore.SetRange(Calculated, false);
        KPIDailyScore.CalcSums("KPI Score");
        KPIDailyScore1.Reset;
        KPIDailyScore1.SetRange("Employee Code", EmplCode);
        KPIDailyScore1.SetRange(Calculated, false);
        KPIDailyScore1.SetRange("Target Per Day", 0);
        if KPIDailyScore1.FindFirst then
            repeat
                KPIMaster.Get(KPIDailyScore1."KPI Code");
                if KPIMaster."Is Adjustment KPI" then begin
                end else
                    exit(false);
            until KPIDailyScore1.Next = 0;
        KPIratingSetup.Reset;
        KPIratingSetup.SetFilter("Min Score", '<=%1', KPIDailyScore."KPI Score");
        KPIratingSetup.SetFilter("Max Score", '>=%1', KPIDailyScore."KPI Score");
        if KPIratingSetup.FindFirst then begin
            if KPIratingSetup.Rating = KPIratingSetup.Rating::Good then
                exit(true);
        end;
        //>>
        //<<KPI 1.00 Aakrista
    end;

    procedure CalculateLocationIncentive(EmpCode: Code[20]): Decimal
    var
        LocationIncentive: Decimal;
        AppriasalHdr: Record "KPI Appraisal Header NIC";
        EmpRec: Record Employee;
        DailyScore: Decimal;
    begin
        LocationIncentive := CategoryAndDistrictIncentive(EmpCode);
        DailyScore := CalculateDailyKPIScoreSummary(EmpCode);
        exit(DailyScore * LocationIncentive);
        //>KPI 1.00 Aakrista
    end;

    procedure CalculateRoleIncentive(EmpCode: Code[20]): Decimal
    var
        FunctionalTitleList: Record "Functional Title";
        DailyScore: Decimal;
        EmployeeRec: Record Employee;
    begin
        DailyScore := CalculateDailyKPIScoreSummary(EmpCode);
        if EligibleForIncentive(EmpCode) then begin
            EmployeeRec.Get(EmpCode);
            if FunctionalTitleList.Get(EmployeeRec."KPI Functional Title") then begin
                if FunctionalTitleList."KPI Incentive %" <> 0 then
                    exit(DailyScore * (FunctionalTitleList."KPI Incentive %") / 100);
            end;
        end;
    end;

    procedure InsertDeptScoreForEmployee(EmpCode: Code[20])
    var
        KPIAppriasalHdr: Record "KPI Appraisal Header NIC";
        AppriasalLine: Record "KPI Appraisal (NIC) Lines";
        KPIAppriasalDept: Record "KPI Appraisal Header NIC";
        DailyScore: Decimal;
        KPIDailyIncentive: Record "KPI Daily Incentive";
        KPIDailyScore: Record "KPI Daily Score";
        EmpRec: Record Employee;
        KPIMaster: Record "KPI Master NIC";
    begin
        if EmpRec.Get(EmpCode) then begin
            DeptCode := EmpRec."KPI Deputation Value";
            KPIDailyIncentive.Reset;
            KPIDailyIncentive.SetRange(Type, KPIDailyIncentive.Type::Department);
            KPIDailyIncentive.SetRange(Department, DeptCode);
            if KPIDailyIncentive.FindLast then begin
                KPIDailyScore1.Reset;
                KPIDailyScore1.SetRange("Employee Code", EmpCode);
                KPIDailyScore1.SetRange(Type, KPIDailyScore1.Type::Employee);
                KPIDailyScore1.SetRange(Calculated, false);
                KPIDailyScore1.SetRange("Is Department", true);
                if not KPIDailyScore1.FindFirst then begin
                    KPIDailyScore1.Init;
                    KPIDailyScore1.Validate(Type, KPIDailyScore1.Type::Employee);
                    KPIDailyScore1.Validate("Employee Code", EmpCode);
                    KPIDailyScore1.Validate("Entry Date", EntryDateForIncentive(EmpCode));
                    KPIMaster.Reset;
                    KPIMaster.SetRange("Is Department", true);
                    if KPIMaster.FindFirst then begin
                        KPIDailyScore1."KPI Code" := KPIMaster."KPI No.";
                        KPIDailyScore1."KPI Description" := KPIMaster.Description;
                    end;
                    KPIDailyScore1.Validate("Weightage%", 50);
                    KPIDailyScore1.Validate("KPI Score", (KPIDailyIncentive."Net KPI Score" * (KPIDailyScore1."Weightage%" / 100)));
                    KPIDailyScore1.Validate("Is Department", true);
                    KPIDailyScore1.Insert;
                end;
            end;
        end;
    end;

    procedure CreateAppriasalAfterEmployeeTransfer(EmployeeCode: Code[20])
    var
        AppriasalHdr: Record "KPI Appraisal Header NIC";
        AccountingPeriod: Record "Accounting Period";
    begin
        AppriasalHdr.Init;
        AppriasalHdr.Insert(true);
        AppriasalHdr.Validate("Employee Code", EmployeeCode);
        AppriasalHdr.Validate(Quarter, GetQuarter(AppriasalHdr."Created Date"));
        AppriasalHdr.Modify;
    end;

    procedure GetQuarter(CreatedDate: Date): Text
    var
        NepaliMonth: Enum "Nepali Month";
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", CreatedDate);
        if EngNepDate.FindFirst then
            exit(EngNepDate.Quarter);
    end;

    procedure CalculateNoOfWorkingDays(StartDate: Date; EndDate: Date; EmpCode: Code[20]): Integer
    begin
        exit(EndDate - StartDate - LeaveMgt.GetNonWokingDays(StartDate, EndDate, EmpCode) + 1);
    end;

    procedure CalculateDailyKPIScoreSummary(EmpCode: Code[20]): Decimal
    var
        "Sum": Decimal;
    begin
        KPIDailyScore.Reset;
        KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Employee);
        KPIDailyScore.SetRange(Calculated, false);
        KPIDailyScore.SetRange("Employee Code", EmpCode);
        KPIDailyScore.CalcSums("KPI Score");
        exit(KPIDailyScore."KPI Score");
    end;

    procedure DailyKPIScoreCalculationDept(DeptCode: Code[20])
    begin
        KPIDailyScore.Reset;
        KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Department);
        KPIDailyScore.SetRange(Department, DeptCode);
        KPIDailyScore.SetRange(Calculated, false);
        if KPIDailyScore.FindSet then
            repeat
                KPIDailyScore."KPI Score" := (KPIDailyScore."Weightage%" * KPIDailyScore."Actual Score Per Day") / KPIDailyScore."Target Per Day";
                //KPIDailyScore.Calculated := TRUE;
                KPIDailyScore.Modify;
            until KPIDailyScore.Next = 0;
    end;

    procedure CalculateDailyKPIScoreSummaryDept(DeptCode: Code[20]): Decimal
    begin
        KPIDailyScore.Reset;
        KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Department);
        KPIDailyScore.SetRange(Calculated, false);
        KPIDailyScore.SetRange(Department, DeptCode);
        KPIDailyScore.CalcSums("KPI Score");
        exit(KPIDailyScore."KPI Score");
    end;

    procedure CalculateFiscalYear(CreatedDate: Date): Text
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", CreatedDate);
        if EngNepDate.FindFirst then
            exit(EngNepDate."Fiscal Year");
    end;

    procedure ImportXMLFile()
    var
        ImportXMLFile: File;
        XMLInstream: InStream;
        SelectCSVFile: Label 'Select the CSV Requisition File.';
        Filename: Text;
    begin
        Filename := 'Import Daily KPI';
        UploadIntoStream(SelectCSVFile, 'F:\Aakrista\', 'XML File *.csv| *.csv', Filename, XMLInstream);

        // ImportXMLFile.Open('F:\Aakrista\Import Daily KPI.csv');
        // ImportXMLFile.CreateInStream(XMLInstream);
        XMLPORT.Import(33019804, XMLInstream);
        // ImportXMLFile.Close;
        Message('Daily KPI Score Is Inserted');
    end;

    procedure ImportXMLFileDept()
    var
        ImportXMLFile: File;
        XMLInstream: InStream;
        SelectCSVFile: Label 'Select the CSV Requisition File.';
        Filename: Text;
    begin
        Filename := 'KPI Daily Score Dept';
        UploadIntoStream(SelectCSVFile, 'C:\KPI SYSTEM FILE\DAILY SCORE\', 'XML File *.csv| *.csv', Filename, XMLInstream);

        // ImportXMLFile.Open('C:\KPI SYSTEM FILE\DAILY SCORE\KPI Daily Score Dept.csv');
        // ImportXMLFile.CreateInStream(XMLInstream);
        XMLPORT.Import(33019805, XMLInstream);
        // ImportXMLFile.Close;
        Message('Daily KPI Score Is Inserted');
    end;

    procedure closekpiquarter(AppriasalCode: Code[20])
    var
        KPIAppriasalLine: Record "KPI Appraisal (NIC) Lines";
        KPIAppriasalHdr: Record "KPI Appraisal Header NIC";
    begin
        KPIAppriasalLine.Reset;
        KPIAppriasalLine.SetRange("Appraisal Code", AppriasalCode);
        KPIAppriasalLine.CalcSums("Check Reviewer's Score");
        KPIAppriasalHdr.Reset;
        KPIAppriasalHdr.SetRange("Appraisal Code", AppriasalCode);
        if KPIAppriasalHdr.FindFirst then begin
            KPIAppriasalHdr."Approved KPI Score" := KPIAppriasalLine."Check Reviewer's Score";
            KPIAppriasalHdr.CalcFields("KPI Score With Location Inc");
            KPIAppriasalHdr.CalcFields("KPI Score With Role Incentive");
            KPIAppriasalHdr."Net Approved KPI Score" := KPIAppriasalHdr."KPI Score With Location Inc" + KPIAppriasalHdr."KPI Score With Role Incentive" + KPIAppriasalHdr."Approved KPI Score";
            KPIAppriasalHdr."Closed KPI" := true;
            KPIAppriasalHdr.Modify;
        end;
    end;

    procedure EntryDateForIncentive(DocCode: Code[20]): Date
    var
        KPIDailyScore: Record "KPI Daily Score";
        EmpRec: Record Employee;
        DepRec: Record Department;
    begin
        KPIDailyScore.Reset;
        KPIDailyScore.SetRange(Calculated, false);
        if EmpRec.Get(DocCode) then begin
            KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Employee);
            KPIDailyScore.SetRange("Employee Code", DocCode);
        end else if DepRec.Get(DocCode) then begin
            KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Department);
            KPIDailyScore.SetRange("Employee Code", DocCode);
        end;
        if KPIDailyScore.FindFirst then
            exit(KPIDailyScore."Entry Date");
    end;

    procedure ScoreWithoutOperatingProfit(EmpCode: Code[20]): Decimal
    var
        KPIDailyScore: Record "KPI Daily Score";
    begin
        KPIDailyScore.Reset;
        KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Employee);
        KPIDailyScore.SetRange("Is Operating Profit", false);
        KPIDailyScore.SetRange(Calculated, false);
        KPIDailyScore.SetRange("Employee Code", EmpCode);
        KPIDailyScore.SetFilter("Weightage%", '>%1', 0);
        KPIDailyScore.CalcSums("KPI Score");
        exit(KPIDailyScore."KPI Score");
    end;

    procedure OperatingProfitScore(EmpCode: Code[20]): Decimal
    var
        KPIDailyScore: Record "KPI Daily Score";
        Department: Record Department;
        EmpRec: Record Employee;
    begin
        KPIDailyScore.Reset;
        if Department.Get(EmpCode) then begin
            KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Department);
            KPIDailyScore.SetRange("Employee Code", EmpCode);
        end else if EmpRec.Get(EmpCode) then
                KPIDailyScore.SetRange(Type, KPIDailyScore.Type::Employee);
        KPIDailyScore.SetRange("Employee Code", EmpCode);
        KPIDailyScore.SetRange("Is Operating Profit", true);
        KPIDailyScore.SetRange(Calculated, false);
        KPIDailyScore.SetRange("Employee Code", EmpCode);
        KPIDailyScore.CalcSums("KPI Score");
        exit(KPIDailyScore."KPI Score");
    end;

    procedure InsertAdjustmentKPIScore(EmpCode: Code[20]; ExcessScore: Decimal)
    var
        KPIDailyScore: Record "KPI Daily Score";
        KPIMaster: Record "KPI Master NIC";
        KPICode: Code[20];
        KPIDescription: Text;
    begin
        KPIMaster.Reset;
        KPIMaster.SetRange("Is Adjustment KPI", true);
        if KPIMaster.FindFirst then begin
            KPICode := KPIMaster."KPI No.";
            KPIDescription := KPIMaster.Description;
        end;
        KPIDailyScore.Init;
        KPIDailyScore.Validate("KPI Code", KPICode);
        KPIDailyScore.Validate("KPI Description", KPIDescription);
        KPIDailyScore.Validate(Type, KPIDailyScore.Type::Employee);
        KPIDailyScore.Validate("Employee Code", EmpCode);
        KPIDailyScore.Validate("KPI Score", ExcessScore);
        KPIDailyScore.Validate("Entry Date", EntryDateForIncentive(EmpCode));
        KPIDailyScore.Validate("Weightage%", 0);
        KPIDailyScore.Insert(true);
    end;

    procedure checkIfTargetExceeds(empcode: Code[20]; kpicode: Code[20]; startdate: Date; enddate: Date): Decimal
    var
        KPITarget: Record "KPI Target Raw";
        KPItargetvalue: Decimal;
        KPIAssignedValue: Decimal;
        KPIRemainingValue: Decimal;
        KPIExpiredAssignedTarget: Decimal;
    begin
        KPITarget.Reset;
        KPITarget.SetRange("Employee Code", empcode);
        KPITarget.SetRange("KPI Code", kpicode);
        KPITarget.SetRange("Start Date", startdate);
        KPITarget.SetRange("End Date", enddate);
        if KPITarget.FindFirst then begin
            KPItargetvalue := KPITarget."Target Score";
        end;
        KPITarget.Reset;
        KPITarget.SetRange("Assigned By", empcode);
        KPITarget.SetRange("KPI Code", kpicode);
        KPITarget.SetRange("Start Date", startdate);
        KPITarget.SetRange("End Date", enddate);
        if KPITarget.FindSet then
            repeat
                KPIAssignedValue += KPITarget."Target Score";
                if KPITarget."Expire Target" then
                    KPIExpiredAssignedTarget += KPITarget."Target Score";
            until KPITarget.Next = 0;
        KPIRemainingValue := KPItargetvalue - KPIAssignedValue + KPIExpiredAssignedTarget;
        exit(KPIRemainingValue);
    end;

    procedure ImportXMLFilEmpQuantitative()
    var
        ImportXMLFile: File;
        XMLInstream: InStream;
        SelectCSVFile: Label 'Select the CSV Requisition File.';
        Filename: Text;
    begin
        Filename := 'Import Daily KPI';
        UploadIntoStream(SelectCSVFile, 'C:\KPI SYSTEM FILE\DAILY KPI\', 'XML File *.csv| *.csv', Filename, XMLInstream);

        // ImportXMLFile.Open('C:\KPI SYSTEM FILE\DAILY KPI\Import Daily KPI.csv');
        // ImportXMLFile.CreateInStream(XMLInstream);
        XMLPORT.Import(33019804, XMLInstream);
        // ImportXMLFile.Close;
        Message('Daily KPI Score Is Inserted');
    end;

    procedure ImportXMLFileDeptQuantitative()
    var
        ImportXMLFile: File;
        XMLInstream: InStream;
        SelectCSVFile: Label 'Select the CSV Requisition File.';
        Filename: Text;
    begin
        Filename := 'KPI Daily Score Dept';
        UploadIntoStream(SelectCSVFile, 'C:\KPI SYSTEM FILE\DAILY SCORE\', 'XML File *.csv| *.csv', Filename, XMLInstream);

        // ImportXMLFile.Open('C:\KPI SYSTEM FILE\DAILY SCORE\KPI Daily Score Dept.csv');
        // ImportXMLFile.CreateInStream(XMLInstream);
        XMLPORT.Import(33019805, XMLInstream);
        // ImportXMLFile.Close;
        Message('Daily KPI Score Is Inserted');
    end;

    local procedure UpdateDepartment()
    begin
        Department.Reset;
        Department.SetRange(Type, Department.Type::" ");
        if Department.FindSet then
            repeat
                Department.Type := Department.Type::Department;
                Department.Modify;
            until Department.Next = 0;
    end;

    procedure ImportKPITargetEmployee()
    var
        ImportXMLFile: File;
        XMLInstream: InStream;
        SelectCSVFile: Label 'Select the CSV Requisition File.';
        Filename: Text;
    begin
        Filename := 'KPI Daily Score Dept';
        UploadIntoStream(SelectCSVFile, 'C:\KPI SYSTEM FILE\DAILY SCORE\', 'XML File *.csv| *.csv', Filename, XMLInstream);
        // ImportXMLFile.Open('C:\KPI SYSTEM FILE\DAILY SCORE\KPI Daily Score Dept.csv');
        // ImportXMLFile.CreateInStream(XMLInstream);
        XMLPORT.Import(33019802, XMLInstream);
        // ImportXMLFile.Close;
        Message('Daily KPI Target Is Inserted');
    end;

    procedure ImportKPITargetDepartment()
    var
        ImportXMLFile: File;
        XMLInstream: InStream;
        SelectCSVFile: Label 'Select the CSV Requisition File.';
        Filename: Text;
    begin
        Filename := 'KPI Daily Score Dept';
        UploadIntoStream(SelectCSVFile, 'C:\KPI SYSTEM FILE\DAILY SCORE\', 'XML File *.csv| *.csv', Filename, XMLInstream);

        // ImportXMLFile.Open('C:\KPI SYSTEM FILE\DAILY SCORE\KPI Daily Score Dept.csv');
        // ImportXMLFile.CreateInStream(XMLInstream);
        XMLPORT.Import(33019803, XMLInstream);
        // ImportXMLFile.Close;
        Message('Daily KPI Target Is Inserted');
    end;

    procedure UpdateKPIDeputation()
    var
        EmployeeRec: Record Employee;
    begin
        EmployeeRec.Reset;
        EmployeeRec.SetRange("KPI Deputation", EmployeeRec."KPI Deputation"::" ");
        if EmployeeRec.FindSet then
            repeat
                EmployeeRec."KPI Deputation" := EmployeeRec."Deputation on";
                EmployeeRec.Modify;
            until EmployeeRec.Next = 0;
        Message('Data Updated');
    end;

    local procedure UpdateKPIFunctionalTitle()
    var
        EmployeeRec: Record Employee;
        FunctionalTitleRec: Record "Functional Title";
    begin
        EmployeeRec.Reset;
        EmployeeRec.SetRange("KPI Functional Title", '');
        if EmployeeRec.FindSet then
            repeat
                FunctionalTitleRec.Get(EmployeeRec."Functional Title");
                if FunctionalTitleRec."Is Specific Functional" then begin
                    EmployeeRec."KPI Functional Title" := EmployeeRec."Functional Title";
                    EmployeeRec.Modify;
                end;
            until EmployeeRec.Next = 0;
        Message('Data Updated');
    end;

    procedure ExpireKPITarget(PreviousFunctionalTitle: Code[20]; EmployeeCode: Code[20])
    var
        KPITargetRawRec: Record "KPI Target Raw";
    begin
        KPITargetRawRec.Reset;
        KPITargetRawRec.SetRange("Functional Title", PreviousFunctionalTitle);
        KPITargetRawRec.SetRange("Employee Code", EmployeeCode);
        if KPITargetRawRec.FindSet then
            repeat
                KPITargetRawRec."Expire Target" := true;
                KPITargetRawRec.Modify;
            until KPITargetRawRec.Next = 0;
    end;

    procedure calculatefinalscoreforprobatation(AppraisalCode: Code[20])
    var
        AppraisalHdr: Record "KPI Appraisal Header NIC";
        AppraisalLine: Record "KPI Appraisal (NIC) Lines";
        ProbScore: Decimal;
        KPIratingSetup: Record "KPI Rating Setup";
    begin
        AppraisalHdr.Get(AppraisalCode);
        AppraisalLine.Reset;
        AppraisalLine.SetRange("Appraisal Code", AppraisalHdr."Appraisal Code");
        if AppraisalLine.FindSet then
            repeat
                ProbScore += AppraisalLine."Probation Employee Score" * (AppraisalLine."Weightage %" / 100);
            until AppraisalLine.Next = 0;
        KPIratingSetup.Reset;
        KPIratingSetup.SetFilter("Min Score", '<=%1', ProbScore);
        KPIratingSetup.SetFilter("Max Score", '>=%1', ProbScore);
        if KPIratingSetup.FindFirst then begin
            AppraisalHdr.Rating := KPIratingSetup.Rating;
            AppraisalHdr."Reviewed KPI Score" := ProbScore;
            AppraisalHdr.Modify;
        end;
    end;
}

