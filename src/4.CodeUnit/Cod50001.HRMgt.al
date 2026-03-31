codeunit 50001 "HR Mgt."
{
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd;
    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'The previous column set could not be found.';
        Text002: Label 'The period could not be found.';
        Text003: label 'There are no Calendar entries within the filter.';
        SetOption: Option "Initial","Previous","Same","Next","PreviousColumn","NextColumn";
        i: Integer;
        Window: Dialog;
        EmailBodyText: Text;
        Employee: Record Employee;
        EmailRecipients: Text;
        HRSetup: Record "Human Resources Setup";
        EmployeeActivityJournal: Record "Employee Activity Journal";
        leave: Record Leave;
        TravelRequest: Record "Travel Request";
        AttendanceMissed: Record "Attendance Missed";
        EmployeeTransfer: Record "Employee Transfer";
        Overtime: Record OverTime;
        MedicalInsuranceClaim: Record "Medical Insurance Claim";
        Resignation: Record Resignation;
        EmpLoan: Record "Employee Loan/Advance";
        TrainLine: Record "Training Line";
        TrainHead: Record "Training Header";
        Candidate: Record Candidate;
        AllowanceHeader: Record "Allowance Assignment Header";
        OrgStructureList: Record "Organization Structure List";
        CompanyInfo: Record "Company Information";
        EngNep: Record "English-Nepali Date";
        WorkShift: Record "Rating Scale";
        PayrollSetup: Record "Payroll General Setup";
        VacancyDocCategoryTxt: Label 'Vacancy', Locked = true;
        CustVacancyCategoryTxt: Label 'Vacancy', Locked = true;
        CustVacancyCategoryDescTxt: Label 'Vacancy Documents';
        VacancyApprWorkflowCodeTxt: Label 'VACANCY', Locked = true;
        VacancyApprWorkflowDescTxt: Label 'Vacancy Approval Workflow';
        VacancyTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Vacancy Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        BlankDateFormula: DateFormula;
        CustomTemplateTok: Label 'AGILE-', Locked = true;
        VacancySendForApproval: Label 'Approval of a Vacancy is requested.';
        VacancyCancelForApproval: Label 'Approval of a Vacancy is cancelled.';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        SetVacancyToPendingApprovalTxt: Label 'Custom - Set Vacancy to Pending Approval.';
        ReleaseVacancyTxt: Label 'Custom - Release the Vacancy document.';
        CreateVacancyApproveApprovalRequestAutomaticallyTxt: Label 'Custom - Create and approve an approval request automatically on Vacancy.';
        OpenDocumentVacancyTxt: Label 'Custom - Reopen the Vacancy.';
        UnsupportedRecordTypeErr: Label 'Custom - Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        TrainingDocCategoryTxt: Label 'Training';
        CustTrainingCategoryTxt: Label 'Training';
        CustTrainingCategoryDescTxt: Label 'Traning Document';
        TrainingApprWorkflowCodeTxt: Label 'TRAINING', Locked = true;
        TrainingApprWorkflowDescTxt: Label 'Training Approval Workflow';
        TrainingTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Training Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        TrainingSendForApproval: Label 'Approval of a Training is requested.';
        TrainingCancelForApproval: Label 'Approval of a Training is cancelled.';
        SetTrainingToPendingApprovalTxt: Label 'Custom - Set Training to Pending Approval.';
        ReleaseTrainingTxt: Label 'Custom - Release the Training document.';
        CreateTrainingApproveApprovalRequestAutomaticallyTxt: Label 'Custom - Create and approve an approval request automatically on Training.';
        OpenDocumentTrainingTxt: Label 'Custom - Reopen the Training.';
        ExportTraineeTxt: Label 'Export Trainee';
        ExportAttendanceTxt: Label 'Export Attendance';
        FacilitatorDocCategoryTxt: Label 'Facilitator';
        CustFacilitatorCategoryTxt: Label 'Facilitator';
        CustFacilitatorCategoryDescTxt: Label 'Facilitator Document';
        FacilitatorApprWorkflowCodeTxt: Label 'FACILITATOR', Locked = true;
        FacilitatorApprWorkflowDescTxt: Label 'Facilitator Approval Workflow';
        FacilitatorTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Facilitator Pool">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        FacilitatorSendForApproval: Label 'Approval of a Facilitator is requested.';
        FacilitatorCancelForApproval: Label 'Approval of a Facilitator is cancelled.';
        SetFacilitatorToPendingApprovalTxt: Label 'Custom - Set Facilitator to Pending Approval.';
        ReleaseFacilitatorTxt: Label 'Custom - Release the Facilitator document.';
        CreateFacilitatorApproveApprovalRequestAutomaticallyTxt: Label 'Custom - Create and approve an approval request automatically on Facilitator.';
        OpenDocumentFacilitatorTxt: Label 'Custom - Reopen the Facilitator.';
        CR: Integer;
        LF: Integer;
        Colon: Label ' : ';
        MutuallyExclPayrollGroup: Record "Mutually Excl. Payroll Group";
        DimensionValue: Record "Dimension Value";
        TempInt: Integer;
        Employee1: Record Employee;
        SQLConnectionMgt: Codeunit "SQL Connection Mgt";
        SQLCommandType: Option StoredProcedure,TableDirect,Text;
        CommandText: Text;
        reader: Text;
        InputStream: InStream;
        SQLstr: Text;
        ReadCommandTxt: Label 'Select * from ';
        WhereTxt: Label 'Where ';
        SetTxt: Label 'Set ';
        UpdateTxt: Label 'Update ';
        InsertTxt: Label 'Insert Into ';
        SpaceTxt: Label ' ';
        ValuesTxt: Label 'Values ';
        NullTxt: Label '12/31/9999';
        ExcelBuffer: Record "Excel Buffer";
        ImportSuccess: Label 'Order Plan Lines imported successfully.';
        UploadFileTxt: Label 'Select the Excel File to Import';
        ExlExt: Label '.xlsx';
        CalendarDescription: Text;
        AndText: Label 'AND';
        IsPunchQuestion: Text;
        PRSetup: Record "Payroll General Setup";
        AttendanceSetup: Record "Attendance Setup";
        PayrollEngine: Codeunit "Payroll Engine";
        DeleteCommandTxt: Label 'Delete from ';
        EmployeeRec: Record Employee;
        LeaveError: Label 'You cannot apply leave in Present day %1.';
        EvaluationEntryRec: Record "Evaluation Entry";
        Interviewer: Record Interviewer;
        InterviewerCount: Integer;
        j: Integer;
        CandidateRec: Record Candidate;
        TransferError: Label 'You cannot Approve HR Transfer of Effective Date %1 in %2.';
        PageMunicipality: Page Municipalities;
        KPIMgt: Codeunit "KPI Mgt.";
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        LeaveMgt: Codeunit "Leave Mgt.";
        loanMgt: Codeunit "Loan Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        TravelMgt: CodeUnit "Travel Mgt.";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        ApprovalMgt: Codeunit "Approver Mgt";

    procedure MoveToMagicPath(SourceFileName: Text[1024]) DestinationFileName: Text[1024]
    var
    // FileSystemObject: Automation;todo
    // ThreeTierMgt: Codeunit "File Management";
    begin
        // DestinationFileName := ThreeTierMgt.ClientTempFileName(''); todo
        // if IsClear(FileSystemObject) then todo
        // Create(FileSystemObject, true, true); todo
        // FileSystemObject.MoveFile(SourceFileName, DestinationFileName);todo
    end;

    procedure RecommendCandidate(Candidate: Record Candidate; IsApproved: Boolean)
    var
        VacancyHeader: Record "Vacancy Header";
    begin
        Candidate.TestField(Status, Candidate.Status::Applied);
        Candidate.TestField("Vacancy Code");
        VacancyHeader.Get(Candidate."Vacancy Code");
        VacancyHeader.TestField(Type, VacancyHeader.Type::Internal);
        if not IsSaaS() then
            if Candidate."Recommender Code" <> GetEmployeeNo then
                Error('You are not elgible to recommend this candidate');
        if IsApproved then
            Candidate.Validate(Status, Candidate.Status::Recommended)
        else
            Candidate.Validate(Status, Candidate.Status::" ");
        Candidate.Modify;
    end;

    procedure RecommendCandidateAPI(Candidate: Record Candidate; IsApproved: Boolean; employeeNo: Code[20])
    var
        VacancyHeader: Record "Vacancy Header";
    begin
        Candidate.TestField(Status, Candidate.Status::Applied);
        Candidate.TestField("Vacancy Code");
        VacancyHeader.Get(Candidate."Vacancy Code");
        VacancyHeader.TestField(Type, VacancyHeader.Type::Internal);
        if Candidate."Recommender Code" <> employeeNo then
            Error('You are not elgible to recommend this candidate');
        if IsApproved then
            Candidate.Validate(Status, Candidate.Status::Recommended)
        else
            Candidate.Validate(Status, Candidate.Status::" ");
        Candidate.Modify;
    end;

    procedure ApplyForPromoiton(Candidate: Record Candidate)
    var
        VacancyHeader: Record "Vacancy Header";
    begin
        Candidate.TestField(Status, Candidate.Status::" ");
        Candidate.TestField("Vacancy Code");
        VacancyHeader.Get(Candidate."Vacancy Code");
        VacancyHeader.TestField(Type, VacancyHeader.Type::Internal);
        if not IsSaaS() then
            if Candidate."Employee No." <> GetEmployeeNo then
                Error('You are not elgible to apply this candidate');
        Candidate.Validate(Status, Candidate.Status::Applied);
        Candidate.Modify;
    end;

    procedure UpdatePromotion(EmpNo: Code[20])
    var
        PromotionPageBuilder: FilterPageBuilder;
        PromotionHistory: Record "Promotion";
        PromoHis: Record "Promotion";
        LineNo: Integer;
        PromotedDate: Date;
        ServiceHistory: Record "Employee Service History";
        ServiceHistoryCode: Code[20];
        PreviousServiceHistory: Record "Employee Service History";
    begin
        Employee.Get(EmpNo);
        PromotionPageBuilder.AddRecord('Promote Employee', PromotionHistory);
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Salary Level");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Salary Grade");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promotion Date");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Functional Title");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory.Remarks);
        if PromotionPageBuilder.RunModal then begin
            PromotionHistory.SetView(PromotionPageBuilder.GetView('Promote Employee'));
            Evaluate(PromotedDate, PromotionHistory.GetFilter("Promotion Date"));
            Clear(PromoHis);
            PromoHis.Init;
            PromoHis.Validate("Employee No.", EmpNo);
            PromoHis.Validate("Promotion Date", PromotedDate);
            PromoHis.Validate("Promoted Salary Level", PromotionHistory.GetFilter("Promoted Salary Level"));
            PromoHis.Validate("Promoted Salary Grade", PromotionHistory.GetFilter("Promoted Salary Grade"));
            PromoHis.Validate("Promoted Functional Title", PromotionHistory.GetFilter("Promoted Functional Title"));
            PromoHis.Validate(Remarks, PromotionHistory.GetFilter(Remarks));
            PromoHis.Insert(true);
            ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(EmpNo, ServiceHistory."Service Event"::"Internal Appointment", 'Promoted', PromotedDate);
            Employee.Validate("Salary Level", PromotionHistory.GetFilter("Promoted Salary Level"));
            Employee.Validate("Salary Grade", PromotionHistory.GetFilter("Promoted Salary Grade"));
            Employee.Validate("Functional Title", PromotionHistory.GetFilter("Promoted Functional Title"));
            Employee.Validate("Promotion Date", PromotedDate);
            Employee.Modify;
            if ServiceHistory.Get(ServiceHistoryCode) then begin
                ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
                ServiceHistory.Validate("Salary Grade (To)", Employee."Salary Grade");
                ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
                ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
                ServiceHistory.Validate("Deputation Code (To)", ServiceHistoryMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate("Deputation Value (To)", ServiceHistoryMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate(Remarks, PromotionHistory.GetFilter(Remarks));
                PreviousServiceHistory.Reset;
                PreviousServiceHistory.SetRange("Employee No.", Employee."No.");
                PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceHistoryCode);
                PreviousServiceHistory.SetCurrentKey("Effective Date");
                if PreviousServiceHistory.FindLast then begin
                    ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
                end;
                ServiceHistory.Modify;
            end;
            Message('Employee Promoted');
        end;
    end;

    procedure ReturnNepaliYear(EnglishDate: Date): Integer
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", EnglishDate);
        if EngNep.FindFirst then
            exit(EngNep."Nepali Year");
    end;

    local procedure GetOneLessSalaryCode(SalaryCode: Code[20]): Text[20]
    var
        SalaryLevel: Record "Salary Level";
        SalaryLevel2: Record "Salary Level";
    begin
        SalaryLevel.Get(SalaryCode);
        SalaryLevel2.SetCurrentKey(Rank);
        SalaryLevel2.SetRange(Rank, 0, SalaryLevel.Rank - 1);
        if SalaryLevel2.FindLast then
            exit(SalaryLevel2.Code);
    end;

    procedure SelectEligibleEmployee(VacancyCode: Code[20])
    var
        VacancyHeader: Record "Vacancy Header";
        PromotionEligbility: Record "Promotion Eligibilty Criteria";
        SalaryText: Text;
        Appraisal: Record Appraisal;
        DateExpr: Text;
        ServiceHistory: Record "Employee Service History";
        SalaryLevelVar: Record "Salary Level";
    begin
        VacancyHeader.Get(VacancyCode);
        HRSetup.Get;
        VacancyHeader.TestField(Type, VacancyHeader.Type::Internal);
        if not (VacancyHeader.Status in [VacancyHeader.Status::" ", VacancyHeader.Status::Applied]) then
            Error('Status must be applied or blank');
        SalaryText := GetOneLessSalaryCode(VacancyHeader."Salary Level Code");
        Employee.Reset;
        if SalaryText <> '' then begin
            Employee.SetRange("Salary Level", SalaryText);
            if Employee.Find('-') then
                repeat
                    Appraisal.Reset;
                    Appraisal.SetRange("Employee Code", Employee."No.");
                    Appraisal.SetRange("Appraisal Type", Appraisal."Appraisal Type"::Annually);
                    Appraisal.SetRange("Approval Status", Appraisal."Approval Status"::Approved);
                    Appraisal.SetRange("Fiscal Year", ReturnFiscalYear(CalcDate('<-1Y>')));
                    if Appraisal.FindLast then begin
                        ServiceHistory.Reset;
                        ServiceHistory.SetRange("Employee No.", Employee."No.");
                        ServiceHistory.SetFilter("Service Event", '%1|%2', ServiceHistory."Service Event"::"Internal Appointment", ServiceHistory."Service Event"::Appointment);
                        ServiceHistory.SetRange("Salary Level (To)", Employee."Salary Level");
                        if ServiceHistory.FindFirst then begin
                            case Appraisal."Final Grading" of
                                Appraisal."Final Grading"::Excellent:
                                    begin
                                        if CalcDate(StrSubstNo('<%1Y>', HRSetup."Excellent Serivce Period"), ServiceHistory."Effective Date") <= VacancyHeader."Date of Request" then
                                            InsertPromotionCandidate(VacancyHeader);
                                    end;
                                Appraisal."Final Grading"::"Very Good":
                                    begin
                                        if CalcDate(StrSubstNo('<%1Y>', HRSetup."Very Good Service Period"), ServiceHistory."Effective Date") <= VacancyHeader."Date of Request" then
                                            InsertPromotionCandidate(VacancyHeader);
                                        SalaryLevelVar.Get(Employee."Salary Level");
                                        if CalcDate(StrSubstNo('<%1Y>', SalaryLevelVar."Good Service Period"), ServiceHistory."Effective Date") <= VacancyHeader."Date of Request" then
                                            InsertPromotionCandidate(VacancyHeader);
                                    end;
                            end;
                        end;
                    end;
                until Employee.Next = 0;
        end;
    end;

    local procedure InsertPromotionCandidate(VacancyHeader: Record "Vacancy Header")
    var
        Candidate: Record Candidate;
    begin
        Candidate.Init;
        Candidate.Validate("First Name", Employee."First Name");
        Candidate.Validate("Middle Name", Employee."Middle Name");
        Candidate.Validate("Last Name", Employee."Last Name");
        Candidate.Validate("Vacancy Code", VacancyHeader."No.");
        Candidate.Validate("Applied Salary Level", VacancyHeader."Salary Level Code");
        Candidate.Validate("Employee No.", Employee."No.");
        Candidate.Validate("Candidate Type", Candidate."Candidate Type"::Internal);
        Candidate.Validate(Status, Candidate.Status::" ");
        Candidate.Insert(true);
    end;

    procedure PromoteEmployee(CandidateNo: Code[20]; VacancyNo: Code[20])
    var
        Candidate: Record Candidate;
        VacancyHead: Record "Vacancy Header";
    // EmployeePromotion: Record "Employee Promotion";
    begin
        VacancyHead.Get(VacancyNo);
        VacancyHead.TestField(Type, VacancyHead.Type::Internal);
        Employee.Get(CandidateNo);
        Candidate.Get(CandidateNo, VacancyNo);
        // EmpAct.Reset;
        // EmpAct.Init;
        // EmpAct.Type := EmpAct.Type::Promotion;
        // EmpAct.Validate("No.", Employee."No.");
        // EmpAct.Validate("Employee Name", Employee."Full Name");
        // EmpAct.Validate("Requested Date", Today);
        // EmpAct.Validate("Functional Title", Employee."Functional Title");
        // EmpAct.Validate("Salary Level Code", Employee."Salary Level");
        // EmpAct.Validate("Salary Level Code(To)", Candidate."Applied Salary Level");
        // EmpAct.Validate("Functional Title (To)", Candidate."Functional Title");
        // EmpAct.Insert(true);
        Employee."Functional Title" := Candidate."Functional Title";
        Employee."Salary Level" := Candidate."Applied Salary Level";
        Employee."Promotion Date" := Today;
        Employee.Modify;
    end;

    procedure PostRecruitement(MemoNo: Code[20])
    var
        Recruitment: Record "Recruitment Memo";
        VacaHeadaer: Record "Vacancy Header";
        RecruitmentLine: Record "Recruitement Memo Line";
        DocNo: Text;
        NoMgt: Codeunit "No. Series";
        VacancyLine: Record "Vacancy Line";
        SalaryLevel: Record "Salary Level";
        FunctionalTitle: Record "Functional Title";
        TempRecruLine: Record "Recruitement Memo Line" temporary;
        SelectionCommitee: Record "Selection Commitee";
        LineNo: Integer;
    begin
        if Recruitment.Get(MemoNo) then begin
            HRSetup.Get;
            Recruitment.TestField(Posted, false);
            Recruitment.TestField("Reference No.");
            Recruitment.TestField(Subject);
            Recruitment.TestField(Type);
            RecruitmentLine.Reset;
            RecruitmentLine.SetRange("Memo No.", Recruitment."Memo No.");
            //for recruitment (external vacancy)
            if (Recruitment.Type = Recruitment.Type::External) then begin
                if RecruitmentLine.Find('-') then
                    repeat
                        VacaHeadaer.Reset;
                        VacaHeadaer.SetRange("Memo No.", Recruitment."Memo No.");
                        VacaHeadaer.SetRange("Functional Title", RecruitmentLine."Functional Title");
                        if VacaHeadaer.FindFirst then
                            Error('Vacancy Already Created for Memo No.: %1', Recruitment."Memo No.")
                        else begin
                            DocNo := NoMgt.GetNextNo(HRSetup."Vacancy Nos.", Today, true);
                            VacaHeadaer.Init;
                            VacaHeadaer.Validate("No.", DocNo);
                            VacaHeadaer.Validate(Status, VacaHeadaer.Status::Applied);
                            VacaHeadaer.Validate("Reference No.", Recruitment."Reference No.");
                            VacaHeadaer.Validate("Functional Title", RecruitmentLine."Functional Title");
                            VacaHeadaer.Validate("Approval Status", VacaHeadaer."Approval Status"::open);
                            VacaHeadaer.Validate(Location, RecruitmentLine.Location);
                            VacaHeadaer.Validate("Date of Request", Recruitment."Date of Request");
                            VacaHeadaer.Validate(Type, Recruitment.Type);
                            VacaHeadaer.Insert;
                            Employee.Reset;
                            // Employee.SetRange("Selection committee", true);
                            if Employee.Find('-') then
                                repeat
                                    SelectionCommitee.Init;
                                    SelectionCommitee.Validate("Vacancy Code", VacaHeadaer."No.");
                                    SelectionCommitee.Validate("Employee No", Employee."No.");
                                    SelectionCommitee.Validate(Email, Employee."Company E-Mail");
                                    SelectionCommitee.Insert(true);
                                until Employee.Next = 0;
                            if RecruitmentLine."Salary Level Code" <> '' then begin
                                SalaryLevel.Reset;
                                SalaryLevel.SetFilter(Code, RecruitmentLine."Salary Level Code");
                                if SalaryLevel.Find('-') then
                                    repeat
                                        VacancyLine.Init;
                                        VacancyLine.Validate("Vacancy No.", DocNo);
                                        VacancyLine.Validate("Salary Level", SalaryLevel.Code);
                                        VacancyLine.Validate("Functional Title", RecruitmentLine."Functional Title");
                                        VacancyLine.Validate("No. of People", RecruitmentLine."Required No.");
                                        VacancyLine.Validate("Banking Experince", SalaryLevel."Banking Experience");
                                        VacancyLine.Validate("Non Banking Experince", SalaryLevel."Non-Banking Experience");
                                        VacancyLine.Validate("Minimum Age", SalaryLevel."Minimum Age");
                                        VacancyLine.Validate("Maximum Age", SalaryLevel."Maximum Age");
                                        VacancyLine.Validate("Qualification Code", SalaryLevel."Qualification Code");
                                        VacancyLine.Insert;
                                    until SalaryLevel.Next = 0;
                            end;
                        end;
                        RecruitmentLine."Vacancy No." := VacaHeadaer."No.";
                        RecruitmentLine.Modify;
                    until RecruitmentLine.Next = 0;
            end else begin
                //for promotion (internal)
                TempRecruLine.DeleteAll;
                LineNo := 0;
                if RecruitmentLine.Find('-') then
                    repeat
                        LineNo += 10000;
                        TempRecruLine.Reset;
                        TempRecruLine.SetRange("Salary Level Code", RecruitmentLine."Salary Level Code");
                        if TempRecruLine.FindFirst then begin
                            //VacaHeadaer.Reset;
                            //VacaHeadaer.SetRange("Memo No.","Memo No.");
                            //VacaHeadaer.SetRange("Salary Level Code",RecruitmentLine."Salary Level Code");
                            //IF VacaHeadaer.FindFirst() THEN begin
                            FunctionalTitle.Reset;
                            FunctionalTitle.SetFilter(Code, RecruitmentLine."Functional Title");
                            if FunctionalTitle.Find('-') then
                                repeat
                                    VacancyLine.Init;
                                    VacancyLine.Validate("Vacancy No.", TempRecruLine."Vacancy No.");
                                    VacancyLine.Validate("Functional Title", FunctionalTitle.Code);
                                    VacancyLine.Validate("Salary Level", RecruitmentLine."Salary Level Code");
                                    VacancyLine.Validate("No. of People", RecruitmentLine."Required No.");
                                    VacancyLine.Insert;
                                until FunctionalTitle.Next = 0
                        end else begin
                            DocNo := NoMgt.GetNextNo(HRSetup."Vacancy Nos.", Today, true);
                            VacaHeadaer.Init;
                            VacaHeadaer.Validate(Status, VacaHeadaer.Status::Applied);
                            VacaHeadaer.Validate("No.", DocNo);
                            VacaHeadaer.Validate("Memo No.", Recruitment."Memo No.");
                            VacaHeadaer.Validate("Reference No.", Recruitment."Reference No.");
                            VacaHeadaer.Validate("Salary Level Code", RecruitmentLine."Salary Level Code");
                            VacaHeadaer.Validate("Approval Status", VacaHeadaer."Approval Status"::open);
                            VacaHeadaer.Validate(Location, RecruitmentLine.Location);
                            VacaHeadaer.Validate(Type, Recruitment.Type);
                            VacaHeadaer.Insert(true);
                            Employee.Reset;
                            // Employee.SetRange("Selection committee", true);
                            if Employee.Find('-') then
                                repeat
                                    SelectionCommitee.Init;
                                    SelectionCommitee.Validate("Vacancy Code", VacaHeadaer."No.");
                                    SelectionCommitee.Validate("Employee No", Employee."No.");
                                    SelectionCommitee.Validate(Email, Employee."Company E-Mail");
                                    SelectionCommitee.Insert(true);
                                until Employee.Next = 0;
                            TempRecruLine.Init;
                            TempRecruLine."Salary Level Code" := RecruitmentLine."Salary Level Code";
                            TempRecruLine."Vacancy No." := DocNo;
                            TempRecruLine."Memo No." := '1';
                            TempRecruLine."Line No." := LineNo;
                            TempRecruLine.Insert;
                            if RecruitmentLine."Functional Title" <> '' then begin
                                FunctionalTitle.Reset;
                                FunctionalTitle.SetFilter(Code, RecruitmentLine."Functional Title");
                                if FunctionalTitle.Find('-') then
                                    repeat
                                        VacancyLine.Init;
                                        VacancyLine.Validate("Vacancy No.", DocNo);
                                        VacancyLine.Validate("Functional Title", FunctionalTitle.Code);
                                        VacancyLine.Validate("Salary Level", RecruitmentLine."Salary Level Code");
                                        VacancyLine.Validate("No. of People", RecruitmentLine."Required No.");
                                        VacancyLine.Insert;
                                    until FunctionalTitle.Next = 0;
                            end;
                        end;
                        RecruitmentLine."Vacancy No." := VacaHeadaer."No.";
                        RecruitmentLine.Modify;
                    until RecruitmentLine.Next = 0;
            end;
            Recruitment."Posting Date" := Today;
            Recruitment.Posted := true;
            Recruitment.Modify;
            Message('Recruitment Memo has been posted');
            TempRecruLine.DeleteAll;
        end;
    end;

    procedure LookupSalaryLevel(SalLevelText: Text): Text
    var
        PageSalaryLevel: Page "Salary Levels";
        SalaryLevel: Record "Salary Level";
    begin
        SalaryLevel.Reset;
        Clear(PageSalaryLevel);
        PageSalaryLevel.AssignShowSelected;
        PageSalaryLevel.InsertSalLevel(SalLevelText);
        PageSalaryLevel.SetRecord(SalaryLevel);
        PageSalaryLevel.SetTableView(SalaryLevel);
        if PageSalaryLevel.RunModal = ACTION::OK then
            exit(PageSalaryLevel.ReturnSalLevelText);
    end;

    procedure ValidateJobTitle(var VacaHeader: Record "Vacancy Header")
    var
        JobTitle: Record "Job Title";
        JobSpec: Record "Job Desc./Spec. Entry";
        JobTitleLine: Record "Job Title Line";
        LineNo: Integer;
    begin
        JobSpec.SetRange("Vacancy Code", VacaHeader."No.");
        if JobSpec.FindFirst then
            JobSpec.DeleteAll;
        LineNo := 0;
        if JobTitle.Get(VacaHeader."Salary Level Code", VacaHeader."Functional Title") then begin
            VacaHeader.Validate("Minimum Age", JobTitle."Minimum Age");
            VacaHeader.Validate("Banking Experience", JobTitle."Banking Experince");
            VacaHeader.Validate("Non-Banking Experience", JobTitle."Non-Banking Experince");
            JobTitleLine.SetRange("Functional Title", JobTitle."Functional Title");
            JobTitleLine.SetRange("Salary Level Code", VacaHeader."Salary Level Code");
            if JobTitleLine.FindFirst then
                repeat
                    LineNo += 10000;
                    JobSpec.Init;
                    JobSpec.Validate("Vacancy Code", VacaHeader."No.");
                    JobSpec.Validate("Line No.", LineNo);
                    JobSpec.Validate(Type, JobTitleLine."Job Type");
                    JobSpec.Validate("Job Description Code", JobTitleLine.Code);
                    JobSpec.Validate("Job Description", JobTitleLine.Description);
                    JobSpec.Insert;
                until JobTitleLine.Next = 0;
            VacaHeader.Modify;
        end else begin
            Clear(VacaHeader."Minimum Age");
            Clear(VacaHeader."Non-Banking Experience");
            Clear(VacaHeader."Banking Experience");
        end;
    end;

    procedure SelectionCommitteeApproval(VacancyCode: Code[20])
    var
        SelectionComimttee: Record "Selection Commitee";
        SelectionComimttee2: Record "Selection Commitee";
        VacancyHead: Record "Vacancy Header";
    begin
        SelectionComimttee.Reset;
        VacancyHead.Get(VacancyCode);
        if VacancyHead.Type = VacancyHead.Type::External then begin
            VacancyHead.TestField(Description);
            VacancyHead.TestField("Vacancy Published Date");
            VacancyHead.TestField("Notice Period");
            VacancyHead.TestField("Vacancy Expiry Date");
        end;
        SelectionComimttee.SetRange("Vacancy Code", VacancyCode);
        if not IsSaaS() then
            SelectionComimttee.SetRange("Employee No", GetEmployeeNo);
        if not VacancyHead."Selection Committee Approved" then begin
            if SelectionComimttee.FindFirst then begin
                if SelectionComimttee.Approved then
                    Error('You have already approved.')
                else begin
                    SelectionComimttee.Approved := true;
                    SelectionComimttee.Modify;
                    Message('Approved.');
                end;
                SelectionComimttee2.Reset;
                SelectionComimttee2.SetRange("Vacancy Code", VacancyCode);
                SelectionComimttee2.SetRange(Approved, false);
                SelectionComimttee.SetFilter("Employee No", '<>%1', SelectionComimttee."Employee No");
                if not SelectionComimttee2.FindFirst then begin
                    VacancyHead."Selection Committee Approved" := true;
                    VacancyHead."Selection Com. Approved Date" := CurrentDateTime;
                    VacancyHead.Modify;
                end;
            end else
                Message('You are not eligible to approve.');
        end else
            Message('Already Approved.');
    end;

    procedure ExportCandidateXML(VacancyCode: Code[20])
    var
        Candidate: Record Candidate;
        TestFile: File;
        TestStream: OutStream;
    begin
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        XMLPORT.Run(50000, false, false, Candidate);
    end;

    procedure ImportCandidateXML(VacancyCode: Code[20])
    var
        Candidate: Record Candidate;
        TestFile: File;
        TestStream: OutStream;
        Vacancy: Record "Vacancy Header";
    begin
        if Vacancy.Get(VacancyCode) then begin
            Vacancy.TestField(Status, Vacancy.Status::" ");
            XMLPORT.Run(50003, false, true);
            Vacancy.Status := Vacancy.Status::Applied;
            Vacancy.Modify;
        end;
    end;

    procedure ShowCandidateList(VacancyCode: Code[20])
    var
        Candidate: Record Candidate;
        CandidateList: Page "Candidate List";
    begin
        Clear(CandidateList);
        Candidate.Reset;
        Candidate.FilterGroup(2);
        Candidate.SetRange("Vacancy Code", VacancyCode);
        Candidate.FilterGroup(0);
        CandidateList.SetRecord(Candidate);
        CandidateList.SetTableView(Candidate);
        CandidateList.LookupMode(true);
        if CandidateList.RunModal = ACTION::LookupOK then;
    end;

    procedure ShowPotentialCandidate(VacancyCode: Code[20])
    var
        PotentialCandidate: Record "Potential Candidates";
    begin
        PotentialCandidate.Reset;
        PotentialCandidate.FilterGroup(2);
        PotentialCandidate.SetRange("Vacancy Code", VacancyCode);
        PotentialCandidate.FilterGroup(0);
        //IF PAGE.RUNMODAL(PAGE::"Transfer Claim Form",PotentialCandidate) = ACTION::LookupOK THEN;
    end;

    procedure SystemScreen(VacancyCode: Code[20])
    var
        VacancyHeader: Record "Vacancy Header";
        Candidate: Record Candidate;
        counter: Integer;
        Success: Label '%1 Potential Candidate has been selected as shortlisted candidates.';
        Text001: Label 'None of the Potential Candidate has been shortlisted.';
        VacancyLine: Record "Vacancy Line";
    begin
        counter := 0;
        Candidate.Reset;
        VacancyHeader.Get(VacancyCode);
        VacancyHeader.TestField(Type, VacancyHeader.Type::External);
        if not (VacancyHeader.Status in [VacancyHeader.Status::Applied, VacancyHeader.Status::" "]) then
            Error('Status must be applied.');
        Candidate.SetFilter(Status, '%1|%2', Candidate.Status::Applied, Candidate.Status::" ");
        Candidate.SetRange("Vacancy Code", VacancyCode);
        if Candidate.Find('-') then
            repeat
                VacancyLine.Get(VacancyCode, Candidate."Applied Salary Level", VacancyHeader."Functional Title");
                if ((Candidate.Age >= VacancyLine."Minimum Age") and (Candidate."Commercial Banking Experience" >= VacancyLine."Banking Experince")
                  and (Candidate."Development Banking Experience" >= VacancyLine."Non Banking Experince")
                and (Candidate.Rank >= VacancyLine.Rank)) then begin
                    Candidate.Status := Candidate.Status::"System Screeened";
                    counter += 1;
                    Candidate.Modify;
                end;
            until Candidate.Next = 0;
        if counter <> 0 then begin
            VacancyHeader.Status := VacancyHeader.Status::"System Screened";
            VacancyHeader.Modify;
            Message(Success, counter)
        end else
            Message(Text001);
    end;


    procedure SelectFinalCandidates(VacancyCode: Code[20])
    var
        InterviewEvaluationEntry: Record "Evaluation Entry";
        Interview1: Decimal;
        Interview2: Decimal;
        Interview3: Decimal;
        Candidate: Record Candidate;
        i: Integer;
        VacancyHeader: Record "Vacancy Header";
    begin
        /* Candidate.Reset;
         Candidate.SetRange("Vacancy Code",VacancyCode);
         IF Candidate.FindFirst() THEN
         repeat
         InterviewEvaluationEntry.Reset;
         //InterviewEvaluationEntry.SetRange("Vacancy Code",Candidate."Vacancy Code");
         InterviewEvaluationEntry.SetRange("No.",Candidate."No.");
         IF InterviewEvaluationEntry.FindFirst() THEN
           repeat
             Interview1:=0;
             Interview2:=0;
             Interview3:=0;
             Interview1+=InterviewEvaluationEntry."Interviewer Code";
             Interview2+=InterviewEvaluationEntry."Interviewer Name";
             Interview3+=InterviewEvaluationEntry.Marks;
         until InterviewEvaluationEntry.NEXT =0;
         Candidate."Total Inverview Score":=Interview1+Interview2+Interview3;
         Candidate.MODIFY;
         until Candidate.NEXT =0;
         VacancyHeader.GET(VacancyCode);
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code",VacancyCode);
        IF Candidate.FindFirst() THEN
          FOR i:=1 TO VacancyHeader."No of Vacancy" DO begin
            Candidate.Type:=Candidate.Type::"Final Selection";
            Candidate.MODIFY;
         end;*/
    end;

    procedure ShowWrittenExamEntries(VacancyCode: Code[20]; CandidateFilter: Text)
    var
        EvaluationEntires: Record "Evaluation Entry";
    begin
        EvaluationEntires.Reset;
        EvaluationEntires.FilterGroup(2);
        EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
        EvaluationEntires.SetRange(Type, EvaluationEntires.Type::"Written Exam");
        EvaluationEntires.SetFilter("No.", CandidateFilter);
        EvaluationEntires.FilterGroup(0);
        PAGE.Run(PAGE::"Wrtitten/Group Dis. Marks", EvaluationEntires);
    end;

    procedure GenerateWrittenExamEntries(VacancyCode: Code[20]; CandidateFilter: Text)
    var
        Candidate: Record Candidate;
        EvaluationEntires: Record "Evaluation Entry";
        EvaAttribute: Record "Evaluation Attribute";
    begin
        EvaAttribute.Reset;
        EvaAttribute.SetRange("Attribute Type", EvaAttribute."Attribute Type"::"Written Exam");
        if EvaAttribute.Find('-') then
            repeat
                Candidate.Reset;
                Candidate.SetRange("Vacancy Code", VacancyCode);
                Candidate.SetRange(Status, Candidate.Status::"Manual Shortlist");
                Candidate.SetFilter("No.", CandidateFilter);
                if Candidate.Find('-') then
                    repeat
                        EvaluationEntires.Reset;
                        EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
                        EvaluationEntires.SetRange(Type, EvaluationEntires.Type::"Written Exam");
                        EvaluationEntires.SetRange("No.", Candidate."No.");
                        if not EvaluationEntires.FindFirst then begin
                            EvaluationEntires.Init;
                            EvaluationEntires.Validate("Vacancy Code", VacancyCode);
                            EvaluationEntires.Validate(Type, EvaluationEntires.Type::"Written Exam");
                            EvaluationEntires.Validate("No.", Candidate."No.");
                            EvaluationEntires.Validate("Attribute Code", EvaAttribute.Code);
                            EvaluationEntires.Validate(Name, Candidate."Full Name");
                            EvaluationEntires.Validate(Marks, Candidate."Written Score");
                            EvaluationEntires.Insert(true);
                        end;
                    until Candidate.Next = 0;
            until EvaAttribute.Next = 0;
    end;

    procedure ShowGroupDiscussionEntries(VacancyCode: Code[20]; CandidateFilter: Text)
    var
        EvaluationEntires: Record "Evaluation Entry";
    begin
        EvaluationEntires.Reset;
        EvaluationEntires.FilterGroup(2);
        EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
        EvaluationEntires.SetRange(Type, EvaluationEntires.Type::"Group Discussion");
        EvaluationEntires.SetFilter("No.", CandidateFilter);
        EvaluationEntires.FilterGroup(0);
        PAGE.Run(PAGE::"Wrtitten/Group Dis. Marks", EvaluationEntires);
    end;

    procedure GenerateGroupDiscussionEntries(VacancyCode: Code[20]; CandidateFilter: Text)
    var
        Candidate: Record Candidate;
        EvaluationEntires: Record "Evaluation Entry";
        EvaAttribute: Record "Evaluation Attribute";
        VacancyHeader: Record "Vacancy Header";
    begin
        EvaAttribute.Reset;
        VacancyHeader.Get(VacancyCode);
        EvaAttribute.SetRange("Attribute Type", EvaAttribute."Attribute Type"::"Group Discussion");
        if EvaAttribute.Find('-') then
            repeat
                Candidate.Reset;
                Candidate.SetRange("Vacancy Code", VacancyCode);
                Candidate.SetFilter("No.", CandidateFilter);
                if VacancyHeader.Type = VacancyHeader.Type::External then
                    Candidate.SetRange(Status, Candidate.Status::"System Screeened")
                else
                    Candidate.SetRange(Status, Candidate.Status::Recommended);
                if Candidate.Find('-') then
                    repeat
                        EvaluationEntires.Reset;
                        EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
                        EvaluationEntires.SetRange(Type, EvaluationEntires.Type::"Group Discussion");
                        EvaluationEntires.SetRange("No.", Candidate."No.");
                        if not EvaluationEntires.FindFirst then begin
                            EvaluationEntires.Init;
                            EvaluationEntires.Validate("Vacancy Code", VacancyCode);
                            EvaluationEntires.Validate(Type, EvaluationEntires.Type::"Group Discussion");
                            EvaluationEntires.Validate("No.", Candidate."No.");
                            EvaluationEntires.Validate("Attribute Code", EvaAttribute.Code);
                            EvaluationEntires.Validate(Name, Candidate."Full Name");
                            EvaluationEntires.Validate(Marks, Candidate."Written Score");
                            EvaluationEntires.Insert(true);
                        end;
                    until Candidate.Next = 0;
            until EvaAttribute.Next = 0;
    end;

    procedure ShortlistViaWrittenExam(VacancyCode: Code[20])
    var
        VacancyHeader: Record "Vacancy Header";
        Candidate: Record Candidate;
        counter: Integer;
        Success: Label '%1 Potential Candidate has been selected as shortlisted candidates.';
        Text001: Label 'None of the Potential Candidate has been shortlisted.';
        EvaluationAttribute: Record "Evaluation Attribute";
        EvaluationEntry: Record "Evaluation Entry";
    begin
        counter := 0;
        Candidate.Reset;
        VacancyHeader.Get(VacancyCode);
        VacancyHeader.TestField(Status, VacancyHeader.Status::"Manual Shortlist");
        Candidate.SetRange(Status, Candidate.Status::"Manual Shortlist");
        Candidate.SetRange("Vacancy Code", VacancyCode);
        if Candidate.Find('-') then
            repeat
                EvaluationEntry.Reset;
                EvaluationEntry.SetRange("Vacancy Code", VacancyCode);
                EvaluationEntry.SetRange("No.", Candidate."No.");
                EvaluationEntry.SetRange(Type, EvaluationEntry.Type::"Written Exam");
                EvaluationEntry.CalcSums(Marks);
                EvaluationAttribute.Reset;
                EvaluationAttribute.SetRange("Attribute Type", EvaluationAttribute."Attribute Type"::"Written Exam");
                EvaluationAttribute.CalcSums(PassMarks);
                if Round(EvaluationAttribute.PassMarks / EvaluationAttribute.Count, 0.01, '=') <= Round(EvaluationEntry.Marks / EvaluationEntry.Count, 0.01, '=')
                  then begin
                    Candidate.Status := Candidate.Status::"Written/GD Passed";
                    counter += 1;
                end;
                Candidate."Written Score" := Round(EvaluationEntry.Marks / EvaluationEntry.Count, 0.01, '=');
                Candidate.Modify;
            until Candidate.Next = 0;
        if counter <> 0 then begin
            VacancyHeader.Status := VacancyHeader.Status::"Written/GD Passed";
            VacancyHeader.Modify;
            Message(Success, counter);
        end else
            Message(Text001);
    end;

    procedure ShowInterviewerEntries(VacancyCode: Code[20]; CandidateFilter: Text)
    var
        EvaluationEntires: Record "Evaluation Entry";
        Interviewer: Record Interviewer;
    begin
        //Interviewer.Reset;
        //Interviewer.SetRange(Interviewer,GetEmployeeNo);
        //IF Interviewer.FindFirst() THEN begin
        EvaluationEntires.Reset;
        EvaluationEntires.FilterGroup(2);
        EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
        EvaluationEntires.SetRange(Type, EvaluationEntires.Type::Interview);
        // EvaluationEntires.SETFILTER("No.",CandidateFilter);
        //EvaluationEntires.SetRange("Interviewer Code",Interviewer.Interviewer);
        EvaluationEntires.FilterGroup(0);
        PAGE.Run(PAGE::"Interview Evaluation Entries", EvaluationEntires);
        //END ELSE
        //MESSAGE('You are not eligible to open interviewer entries');
    end;

    procedure GenerateInterviewerEntries(VacancyCode: Code[20]; CandidateFilter: Text)
    var
        Candidate: Record Candidate;
        EvaluationEntires: Record "Evaluation Entry";
        Interviewer: Record Interviewer;
        EvaluationAttribute: Record "Evaluation Attribute";
        LineNo: Integer;
    begin
        Interviewer.Reset;
        if not IsSaaS() then
            Interviewer.SetRange(Interviewer, GetEmployeeNo);
        Interviewer.SetRange("Vacancy Code", VacancyCode);
        if Interviewer.Find('-') then begin
            Candidate.Reset;
            Candidate.SetRange("Vacancy Code", VacancyCode);
            Candidate.SetRange(Status, Candidate.Status::"Interview Scheduled");
            Candidate.SetFilter("No.", CandidateFilter);
            if Candidate.Find('-') then
                repeat
                    EvaluationAttribute.Reset;
                    EvaluationAttribute.SetRange("Attribute Type", EvaluationAttribute."Attribute Type"::Interview);
                    if EvaluationAttribute.Find('-') then
                        repeat
                            EvaluationEntires.Reset;
                            EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
                            EvaluationEntires.SetRange("Interviewer Code", Interviewer.Interviewer);
                            EvaluationEntires.SetRange("Attribute Code", EvaluationAttribute.Code);
                            EvaluationEntires.SetRange(Type, EvaluationEntires.Type::Interview);
                            EvaluationEntires.SetRange("No.", Candidate."No.");
                            if not EvaluationEntires.FindFirst then begin
                                EvaluationEntires.Init;
                                EvaluationEntires.Validate("Vacancy Code", VacancyCode);
                                EvaluationEntires.Validate(Type, EvaluationEntires.Type::Interview);
                                EvaluationEntires.Validate("Interviewer Code", Interviewer.Interviewer);
                                EvaluationEntires."Interviewer Name" := Interviewer."Interviewer Fullname";
                                EvaluationEntires.Validate("No.", Candidate."No.");
                                EvaluationEntires.Validate("Attribute Code", EvaluationAttribute.Code);
                                EvaluationEntires.Validate("User ID", UserId);
                                EvaluationEntires.Insert(true);
                            end;
                        until EvaluationAttribute.Next = 0;
                until Candidate.Next = 0;
        end
        else
            Error('Employee %1 is not an interviewer for this Vacancy.', Employee."Full Name");
    end;

    procedure GenerateInterviewerEntriesAPI(VacancyCode: Code[20]; CandidateFilter: Text; employeeCode: Code[20])
    var
        Candidate: Record Candidate;
        EvaluationEntires: Record "Evaluation Entry";
        Interviewer: Record Interviewer;
        EvaluationAttribute: Record "Evaluation Attribute";
        LineNo: Integer;
    begin
        Interviewer.Reset;
        Interviewer.SetRange(Interviewer, employeeCode);
        Interviewer.SetRange("Vacancy Code", VacancyCode);
        if Interviewer.Find('-') then begin
            Candidate.Reset;
            Candidate.SetRange("Vacancy Code", VacancyCode);
            Candidate.SetRange(Status, Candidate.Status::"Interview Scheduled");
            Candidate.SetFilter("No.", CandidateFilter);
            if Candidate.Find('-') then
                repeat
                    EvaluationAttribute.Reset;
                    EvaluationAttribute.SetRange("Attribute Type", EvaluationAttribute."Attribute Type"::Interview);
                    if EvaluationAttribute.Find('-') then
                        repeat
                            EvaluationEntires.Reset;
                            EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
                            EvaluationEntires.SetRange("Interviewer Code", Interviewer.Interviewer);
                            EvaluationEntires.SetRange("Attribute Code", EvaluationAttribute.Code);
                            EvaluationEntires.SetRange(Type, EvaluationEntires.Type::Interview);
                            EvaluationEntires.SetRange("No.", Candidate."No.");
                            if not EvaluationEntires.FindFirst then begin
                                EvaluationEntires.Init;
                                EvaluationEntires.Validate("Vacancy Code", VacancyCode);
                                EvaluationEntires.Validate(Type, EvaluationEntires.Type::Interview);
                                EvaluationEntires.Validate("Interviewer Code", Interviewer.Interviewer);
                                EvaluationEntires."Interviewer Name" := Interviewer."Interviewer Fullname";
                                EvaluationEntires.Validate("No.", Candidate."No.");
                                EvaluationEntires.Validate("Attribute Code", EvaluationAttribute.Code);
                                EvaluationEntires.Validate("User ID", UserId);
                                EvaluationEntires.Insert(true);
                            end;
                        until EvaluationAttribute.Next = 0;
                until Candidate.Next = 0;
        end
        else
            Error('Employee %1 is not an interviewer for this Vacancy.', Employee."Full Name");
    end;

    procedure GenerateInterviewedCandidate(VacancyCode: Code[20])
    var
        Candidate: Record Candidate;
        EvaluationEntry: Record "Evaluation Entry";
        Vacancy: Record "Vacancy Header";
    begin
        /*Vacancy.GET(VacancyCode);
        Vacancy.TestField(Status,Vacancy.Status::"Interview Scheduled");
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code",VacancyCode);
        Candidate.SetRange(Status,Candidate.Status::"Interview Scheduled");
        IF Candidate.FIND('-') THEN repeat
          EvaluationEntry.Reset;
          EvaluationEntry.SetRange("Vacancy Code",VacancyCode);
          EvaluationEntry.SetRange("No.",Candidate."No.");
          EvaluationEntry.SetRange(Type,EvaluationEntry.Type::Interview);
          EvaluationEntry.SETFILTER(Marks,'<>%1',0);
          IF EvaluationEntry.FindFirst() THEN begin
            Candidate.Status := Candidate.Status::Interviewed;
            Candidate.MODIFY;
          end;
        until Candidate.NEXT = 0;
        Vacancy.Status := Vacancy.Status::Interviewed;
        Vacancy.MODIFY;
        */
        ShortlistInterviewedCandidate(VacancyCode);
    end;

    procedure ShortlistInterviewedCandidate(VacancyCode: Code[20])
    var
        Candidate: Record Candidate;
        Vacancy: Record "Vacancy Header";
    begin
        Vacancy.Get(VacancyCode);
        //Vacancy.TestField(Status,Vacancy.Status::"Interview Scheduled");
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        Candidate.SetRange(Status, Candidate.Status::"Interview Scheduled");
        Candidate.SetFilter("Total Marks", '<>%1', 0);
        if Candidate.Find('-') then
            repeat
                Interviewer.Reset;
                Interviewer.SetRange("Vacancy Code", VacancyCode);
                InterviewerCount := Interviewer.Count;
                if Candidate."Interviewer Count" <> InterviewerCount then
                    Error('Candidate %1 Marks has not submitted by All Interviewer.', Candidate."No.");
                if Candidate."Interviewer Count" = InterviewerCount then begin
                    Candidate.Status := Candidate.Status::Interviewed;
                    Candidate.Modify;
                end;
            until Candidate.Next = 0;
        Vacancy.Status := Vacancy.Status::Interviewed;
        Vacancy.Modify;
        /*
        CandidateRec.Reset;
        CandidateRec.SetRange("Vacancy Code",VacancyCode);
        CandidateRec.SetRange(Status,Candidate.Status::"Interview Scheduled");
        CandidateRec.SETFILTER("Total Marks",'<>%1',0);
        Interviewer.Reset;
        Interviewer.SetRange("Vacancy Code",VacancyCode);
        InterviewerCount := Interviewer.COUNT;
        IF CandidateRec."Interviewer Count" <> InterviewerCount THEN
          ERROR('Candidate Marks has not submitted by All Interviewer.');*/
    end;

    procedure ShowVacancyFromRecruitement(MemoNo: Code[20])
    var
        PageVacancyList: Page "Vacancy List";
        VacaHeadaer: Record "Vacancy Header";
    begin
        Clear(PageVacancyList);
        VacaHeadaer.Reset;
        VacaHeadaer.FilterGroup(2);
        VacaHeadaer.SetRange("Memo No.", MemoNo);
        VacaHeadaer.FilterGroup(0);
        PageVacancyList.FromRecruitment;
        PageVacancyList.SetRecord(VacaHeadaer);
        PageVacancyList.SetTableView(VacaHeadaer);
        PageVacancyList.Run;
    end;

    local procedure CalculateCandidateAvgMarks(VacancyCode: Code[20])
    var
        EvaluationEntry: Record "Evaluation Entry";
        EvaluationAttribute: Record "Evaluation Attribute";
        Counter: Integer;
        InterviewMarks: Decimal;
        Candidate: Record Candidate;
        i: Decimal;
        TotalFullMarks: Decimal;
    begin
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        Candidate.SetFilter(Status, '%1|%2', Candidate.Status::"Interview Scheduled", Candidate.Status::Interviewed);
        if Candidate.Find('-') then
            repeat
                Counter := 0;
                InterviewMarks := 0;
                TotalFullMarks := 0;
                EvaluationEntry.Reset();
                EvaluationEntry.SetRange("No.", Candidate."No.");
                EvaluationEntry.SetRange("Vacancy Code", VacancyCode);
                EvaluationEntry.SetRange("Attribute Code", 'WRITTEN');
                if EvaluationEntry.FindFirst then
                    Candidate."Written Score" := EvaluationEntry.Marks;
                EvaluationEntry.Reset;
                EvaluationEntry.SetRange("Vacancy Code", VacancyCode);
                EvaluationEntry.SetRange("No.", Candidate."No.");
                EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
                EvaluationEntry.SetRange("Is Remarks", false);
                EvaluationEntry.SetFilter(Marks, '>0');
                //EvaluationEntry.SetRange(Posted,TRUE);
                EvaluationEntry.CalcSums(Marks);
                EvaluationAttribute.Reset;
                EvaluationAttribute.SetRange("Attribute Type", EvaluationAttribute."Attribute Type"::Interview);
                EvaluationAttribute.CalcSums(PassMarks);
                if EvaluationEntry.Marks <> 0 then begin
                    Counter := EvaluationEntry.Count;
                    if EvaluationEntry.Find('-') then
                        repeat
                            //IF ROUND(EvaluationEntry.Marks/EvaluationEntry.COUNT,0.01,'=') >= ROUND(EvaluationAttribute.PassMarks/EvaluationAttribute.COUNT,0.01,'=') THEN begin
                            //end;
                            InterviewMarks += EvaluationEntry.Marks;
                            //InterviewMarks += EvaluationEntry.Marks *100/EvaluationEntry."Full Marks";
                            TotalFullMarks += EvaluationEntry."Full Marks";
                        until EvaluationEntry.Next = 0;
                    //Candidate.Status := Candidate.Status::Interviewed;
                    //Candidate."Avg. Inverview Score" := ROUND(InterviewMarks/Counter,0.01,'=');
                    Candidate."Avg. Inverview Score" := Round(InterviewMarks / TotalFullMarks, 0.01, '=') * 100;
                end;
                Counter := 0;
                Clear(EvaluationEntry);
                //EvaluationEntry.SetRange("Attribute Code", 'APTITUDE'); commented by Santosh
                EvaluationEntry.SetRange("No.", Candidate."No.");
                //EvaluationEntry.SetRange(Posted,TRUE);
                EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
                EvaluationEntry.SetFilter(Marks, '>0');
                Candidate."Interviewer Count" := EvaluationEntry.Count;
                i := 1;
                if EvaluationEntry.Find('-') then
                    repeat
                        case i of
                            1:
                                Candidate."Interviewer 1" := EvaluationEntry."Interviewer Name";
                            2:
                                Candidate."Interviewer 2" := EvaluationEntry."Interviewer Name";
                            3:
                                Candidate."Interviewer 3" := EvaluationEntry."Interviewer Name";
                            4:
                                Candidate."Interviewer 4" := EvaluationEntry."Interviewer Name";
                            5:
                                Candidate."Interviewer 5" := EvaluationEntry."Interviewer Name";
                        end;
                        i += 1;
                    until EvaluationEntry.Next = 0;
                Clear(EvaluationEntryRec);
                EvaluationEntryRec.SetRange("No.", Candidate."No.");
                EvaluationEntryRec.SetRange("Attribute Code", 'REMARKS');
                EvaluationEntryRec.SetRange(Type, EvaluationEntryRec.Type::Interview);
                EvaluationEntryRec.SetFilter(Remarks, '<>%1', '');
                j := 1;
                if EvaluationEntryRec.Find('-') then
                    repeat
                        case j of
                            1:
                                Candidate."Interviewer 1 Remarks" := EvaluationEntryRec.Remarks;
                            2:
                                Candidate."Interviewer 2 Remarks" := EvaluationEntryRec.Remarks;
                            3:
                                Candidate."Interviewer 3 Remarks" := EvaluationEntryRec.Remarks;
                            4:
                                Candidate."Interviewer 4 Remarks" := EvaluationEntryRec.Remarks;
                            5:
                                Candidate."Interviewer 5 Remarks" := EvaluationEntryRec.Remarks;
                        end;
                        j += 1;
                    until EvaluationEntryRec.Next = 0;
                Candidate.Modify;
            until Candidate.Next = 0;
    end;

    procedure CalculateCandidateTotalMarks(VacancyCode: Code[20])
    var
        Candidate: Record Candidate;
        HRSetup: Record "Human Resources Setup";
        FunctionalTitle: Record "Functional Title";
    begin
        CalculateCandidateAvgMarks(VacancyCode);
        HRSetup.Get;
        HRSetup.TestField("Interview Weightage");
        HRSetup.TestField("Written Exam Weightage");
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        Candidate.SetFilter(Status, '%1|%2', Candidate.Status::Interviewed, Candidate.Status::"Interview Scheduled");
        if Candidate.Find('-') then
            repeat
                // FunctionalTitle.GET(Candidate."Functional Title");
                //IF FunctionalTitle."Written Exam" THEN begin
                if Candidate."Avg. Inverview Score" <> 0 then begin
                    if (HRSetup."Interview Weightage" + HRSetup."Written Exam Weightage") <> 0 then begin
                        Candidate."Total Marks" := (Candidate."Avg. Inverview Score" * HRSetup."Interview Weightage" + Candidate."Written Score" * HRSetup."Written Exam Weightage") /
                                           (HRSetup."Interview Weightage" + HRSetup."Written Exam Weightage");
                        Candidate.Modify;
                    end;
                    /*end;
                    END ELSE begin
                      IF (HRSetup."Interview Weightage"<>0 ) THEN begin
                        Candidate."Total Marks" := Candidate."Avg. Inverview Score" ;
                        Candidate.MODIFY;
                      end;*/
                end;
            until Candidate.Next = 0;
        Message('Marks Calculated.');
    end;

    procedure SubmitEvaluationEntry(CandidateCode: Code[20]; EvaluationEntry: Record "Evaluation Entry")
    var
        Candidate: Record Candidate;
    begin
        /*Candidate.GET(CandidateCode);
        Candidate.Status := Candidate.Status::Interviewed;
        Candidate."Interviewed Date" := TODAY;
        Candidate.MODIFY;*/
        EvaluationEntry.Submitted := true;
        EvaluationEntry.Modify;
    end;

    procedure GenerateEligibleCandidate(SalaryRank: Integer; ProvinceCode: Code[20]; VacancyLine: Record "Vacancy Line")
    var
        SalaryLevel: Record "Salary Level";
        Candidate: Record Candidate;
        Appraisal: Record Appraisal;
        AppraisalRating: Record "Rating Setup";
    begin
        SalaryLevel.Reset;
        SalaryLevel.SetRange(Rank, SalaryRank - 1);
        if SalaryLevel.FindFirst then begin
            Employee.Reset;
            Employee.SetRange("Salary Level", SalaryLevel.Code);
            Employee.SetRange("Province Code", ProvinceCode);
            if Employee.Find('-') then
                repeat
                    Appraisal.Reset;
                    Appraisal.SetRange("Employee Code", Employee."No.");
                    Appraisal.SetRange("Fiscal Year", ReturnFiscalYear(Today));
                    Appraisal.SetRange("Appraisal Type", Appraisal."Appraisal Type"::Annually);
                    if Appraisal.FindFirst then begin
                        AppraisalRating.Reset;
                        AppraisalRating.SetRange(Type, AppraisalRating.Type::Appraisal);
                        AppraisalRating.SetRange(Rating, Appraisal."Final Grading");
                        if AppraisalRating.FindFirst then;
                        if AppraisalRating.From > 4 then begin
                            Candidate.Init;
                            Candidate.Validate("Employee No.", Employee."No.");
                            Candidate.Validate("Vacancy Code", VacancyLine."Vacancy No.");
                            Candidate.Validate("Functional Title", VacancyLine."Functional Title");
                            Candidate.Insert(true);
                        end;
                    end;
                until Employee.Next = 0;
        end;
    end;

    local procedure "----------VacancyForm-----------"()
    begin
        //>>pradhan IMERemit1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure AddVacancyWorkflowCategoriesToLibrary()
    begin
        InsertWorkflowCategory(VacancyDocCategoryTxt, CustVacancyCategoryDescTxt);
    end;

    local procedure InsertVacancyApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow, VacancyApprWorkflowCodeTxt, VacancyApprWorkflowDescTxt, VacancyDocCategoryTxt);
        InsertVacancyApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertVacancyApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        Vacancy: Record "Vacancy Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, true);
        InsertVacancyDocApprovalWorkflowSteps(Workflow,
          BuildVacancyConditions(Vacancy."Approval Status"::open),
          OnVacancyDocSendForApprovalCode,
          BuildVacancyConditions(Vacancy."Approval Status"::Pending),
          OnVacancyDocCancelForApprovalCode,
          WorkflowStepArgument, true);
    end;

    procedure BuildVacancyConditions(Status: Option): Text
    var
        Vacancy: Record "Vacancy Header";
    begin
        Vacancy.SetRange("Approval Status", Status);
        exit(StrSubstNo(VacancyTypeCondnTxt, Encode(Vacancy.GetView(false))));
        //<<Pradhan IMERemit1.00
    end;

    local procedure InsertWorkflowCategory("Code": Code[20]; Description: Text[100])
    var
        WorkflowCategory: Record "Workflow Category";
    begin
        WorkflowCategory.Init;
        WorkflowCategory.Code := Code;
        WorkflowCategory.Description := Description;
        if WorkflowCategory.Insert then;
    end;

    local procedure InsertWorkflowTemplate(var Workflow: Record Workflow; WorkflowCode: Code[17]; WorkflowDescription: Text[100]; CategoryCode: Code[20])
    begin
        Workflow.Init;
        Workflow.Code := GetWorkflowTemplateCode(WorkflowCode);
        Workflow.Description := WorkflowDescription;
        Workflow.Category := CategoryCode;
        Workflow.Enabled := false;
        if Workflow.Insert then;
    end;

    procedure GetWorkflowTemplateCode(WorkflowCode: Code[17]): Code[20]
    begin
        exit(CustomTemplateTok + WorkflowCode);
    end;

    local procedure MarkWorkflowAsTemplate(var Workflow: Record Workflow)
    begin
        Workflow.Validate(Template, true);
        Workflow.Modify(true);
    end;

    local procedure PopulateWorkflowStepArgument(var WorkflowStepArgument: Record "Workflow Step Argument"; ApproverType: Option; ApproverLimitType: Option; ApprovalEntriesPage: Integer; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; ShowConfirmationMessage: Boolean)
    begin
        WorkflowStepArgument.Init;
        WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
        WorkflowStepArgument."Approver Type" := ApproverType;
        WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
        WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
        WorkflowStepArgument."Due Date Formula" := DueDateFormula;
        WorkflowStepArgument."Link Target Page" := ApprovalEntriesPage;
        WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
    end;

    local procedure Encode(Text: Text): Text
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
    begin
        exit(XMLDOMManagement.XMLEscape(Text));
    end;

    [EventSubscriber(ObjectType::Codeunit, 2, 'OnCompanyInitialize', '', false, false)]
    procedure InsertWorkflowTemplates()
    begin
        InsertVacancyApprovalWorkflowTemplate;
        InsertTrainingApprovalWorkflowTemplate;   //>>training
        InsertFacilitatorApprovalWorkflowTemplate; //>>Facilitator
    end;

    local procedure "--------Vacancy Workflow-----------"()
    begin
        //>>pradhan IMERemit1.00
    end;

    procedure OnVacancyDocSendForApprovalCode(): Code[128]
    begin
        exit(UpperCase('OnVacancyDocSendForApproval'));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vacancy Header", 'OnSendVacancyDocForApproval', '', false, false)]
    local procedure OnVacancyDocSendForApproval(var Vacancy: Record "Vacancy Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(OnVacancyDocSendForApprovalCode, Vacancy);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddVacancyEventToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(OnVacancyDocSendForApprovalCode, DATABASE::"Vacancy Header", VacancySendForApproval, 0, false);
        WorkflowEventHandling.AddEventToLibrary(OnVacancyDocCancelForApprovalCode, DATABASE::"Vacancy Header", VacancyCancelForApproval, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure AddVacancyWorkflowEventResponseCombinationsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, OnVacancyDocSendForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            OnVacancyDocCancelForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(OnVacancyDocCancelForApprovalCode, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
    local procedure AddVacancyWorkflowTableRelationsToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Vacancy Header", 0, DATABASE::"Approval Entry", 22);
    end;

    procedure OnVacancyDocCancelForApprovalCode(): Code[128]
    begin
        exit(UpperCase('OnVacancyDocCancelForApproval'));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vacancy Header", 'OnCancelVacancyDocForApproval', '', false, false)]
    local procedure OnVacancyDocCancelForApproval(var Vacancy: Record "Vacancy Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(OnVacancyDocCancelForApprovalCode, Vacancy);
        //<<Pradhan IMERemit1.00
    end;

    local procedure "-------------RecruitementMemo--------------------------"()
    begin
        //>>Pradhan IMERemit1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddVacancyResponseToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(VacancyReleaseDocumentCode, 0, ReleaseVacancyTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(VacancyOpenDocumentCode, 0, OpenDocumentVacancyTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(VacancySetStatusToPendingApprovalCode, 0, SetVacancyToPendingApprovalTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(VacancyCreateAndApproveApprovalRequestAutomaticallyCode, 0, CreateVacancyApproveApprovalRequestAutomaticallyTxt, 'Group 50000');
    end;

    procedure VacancySetStatusToPendingApprovalCode(): Code[128]
    begin
        exit(UpperCase('VacancySetStatusToPendingApproval'));
    end;

    procedure VacancySetStatusToPendingApproval(var Variant: Variant)
    begin
        SetStatusToPendingApproval(Variant);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddVacancyWorkflowsEventResponseCombinationsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, OnVacancyDocSendForApprovalCode);
            WorkflowResponseHandling.RestrictRecordUsageCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RestrictRecordUsageCode, OnVacancyDocSendForApprovalCode);
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, OnVacancyDocSendForApprovalCode);
            WorkflowResponseHandling.AllowRecordUsageCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.AllowRecordUsageCode, OnVacancyDocCancelForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.AllowRecordUsageCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
                end;
            WorkflowResponseHandling.ShowMessageCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ShowMessageCode, OnVacancyDocCancelForApprovalCode);
            WorkflowResponseHandling.ApproveAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ApproveAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, OnVacancyDocCancelForApprovalCode);
            VacancyOpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(VacancyOpenDocumentCode, OnVacancyDocCancelForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(VacancyOpenDocumentCode, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
                end;
            VacancyReleaseDocumentCode:
                WorkflowResponseHandling.AddResponsePredecessor(VacancyReleaseDocumentCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            VacancySetStatusToPendingApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(VacancySetStatusToPendingApprovalCode, OnVacancyDocSendForApprovalCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure ExecuteVacancyWorkflowResponses(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                VacancyReleaseDocumentCode:
                    begin
                        VacancyReleaseDocument(Variant);
                        ResponseExecuted := true;
                    end;
                VacancyOpenDocumentCode:
                    begin
                        VacancyOpenDocument(Variant);
                        ResponseExecuted := true;
                    end;
                VacancyCreateAndApproveApprovalRequestAutomaticallyCode:
                    begin
                        VacancyCreateAndApproveApprovalRequestAutomatically(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
                VacancySetStatusToPendingApprovalCode:
                    begin
                        SetStatusToPendingApproval(Variant);
                        ResponseExecuted := true;
                    end;
                VacancyCreateApprovalRequestsCode:
                    begin
                        VacancyCreateApprovalRequests(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
            end;
    end;

    procedure VacancyReleaseDocumentCode(): Code[128]
    begin
        exit(UpperCase('VacancyReleaseDocument'));
    end;

    procedure VacancyOpenDocumentCode(): Code[128]
    begin
        exit(UpperCase('VacancyOpenDocument'));
    end;

    local procedure VacancyReleaseDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        Vacancy: Record "Vacancy Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    if not TargetRecRef.Get(ApprovalEntry."Record ID to Approve") then
                        exit;
                    Variant := TargetRecRef;
                    VacancyReleaseDocument(Variant);
                end;
            DATABASE::"Vacancy Header":
                Vacancy.UpdateApprovalStatus(Variant, Vacancy."Approval Status"::released);
            //MESSAGE('nothing');   //to be removed
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    local procedure VacancyOpenDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        Vacancy: Record "Vacancy Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    if not TargetRecRef.Get(ApprovalEntry."Record ID to Approve") then
                        exit;
                    Variant := TargetRecRef;
                    VacancyOpenDocument(Variant);
                end;
            DATABASE::"Vacancy Header":
                Vacancy.UpdateApprovalStatus(Variant, Vacancy."Approval Status"::open);
            //MESSAGE('nothing'); //to be removed
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    procedure VacancyCreateApprovalRequestsCode(): Code[128]
    begin
        exit(UpperCase('VacancyCreateApprovalRequests'));
    end;

    local procedure VacancyCreateApprovalRequests(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmt.CreateApprovalRequests(RecRef, WorkflowStepInstance);
    end;

    procedure VacancyCreateAndApproveApprovalRequestAutomaticallyCode(): Code[128]
    begin
        exit(UpperCase('VacancyFromCreateAndApproveApprovalRequestAutomatically'));
    end;

    local procedure VacancyCreateAndApproveApprovalRequestAutomatically(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, WorkflowStepInstance);
        //<<Pradhan IMERemit1.00
    end;

    procedure SetStatusToPendingApproval(var Variant: Variant)
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        IncomingDocument: Record "Incoming Document";
        RecRef: RecordRef;
        ServiceLine: Record "Service Line";
        ServiceHeader: Record "Service Header";
        Vacancy: Record "Vacancy Header";
        TrainHead: Record "Training Header";
        Facilitator: Record "Facilitator Pool";
        Facilitator1: Record "Facilitator Pool";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Vacancy Header":
                begin
                    RecRef.SetTable(Vacancy);
                    Vacancy.Validate("Approval Status", Vacancy."Approval Status"::Pending);
                    Vacancy.Modify;
                end;
            DATABASE::"Training Header":
                begin
                    RecRef.SetTable(TrainHead);
                    TrainHead.Validate("Approval Status", Vacancy."Approval Status"::Pending);
                    TrainHead.Modify;
                end;
            DATABASE::"Facilitator Pool":
                begin
                    RecRef.SetTable(Facilitator);
                    Facilitator1.Reset;
                    Facilitator1.SetRange("Fiscal Year", Facilitator."Fiscal Year");
                    Facilitator1.SetFilter("Approval Status", '<>%1|%2', Facilitator1."Approval Status"::rejected, Facilitator1."Approval Status"::released);
                    Facilitator1.ModifyAll("Approval Status", Facilitator1."Approval Status"::Pending);
                    //Facilitator.VALIDATE("Approval Status",Facilitator."Approval Status"::Pending);
                    //Facilitator.MODIFY;
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    local procedure "---------------Training--------------"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure AddTrainingWorkflowCategoriesToLibrary()
    begin
        InsertWorkflowCategory(TrainingDocCategoryTxt, CustTrainingCategoryDescTxt);
    end;

    local procedure InsertTrainingApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow, TrainingApprWorkflowCodeTxt, TrainingApprWorkflowDescTxt, TrainingDocCategoryTxt);
        InsertTrainingApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertTrainingApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        TrainHead: Record "Training Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, true);
        InsertTrainingDocApprovalWorkflowSteps(Workflow,
          BuildTrainingConditions(TrainHead."Approval Status"::Open),
          OnTrainingDocSendForApprovalCode,
          BuildTrainingConditions(TrainHead."Approval Status"::Pending),
          OnTrainingDocCancelForApprovalCode,
          WorkflowStepArgument, true);
    end;

    procedure BuildTrainingConditions(Status: Option): Text
    var
        TrainHead: Record "Training Header";
    begin
        TrainHead.SetRange("Approval Status", Status);
        exit(StrSubstNo(TrainingTypeCondnTxt, Encode(TrainHead.GetView(false))));
    end;

    procedure OnTrainingDocSendForApprovalCode(): Code[128]
    begin
        exit(UpperCase('OnTrainingDocSendForApproval'));
    end;

    procedure OnTrainingDocCancelForApprovalCode(): Code[128]
    begin
        exit(UpperCase('OnTrainingDocCancelForApproval'));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Training Header", 'OnSendTrainingDocForApproval', '', false, false)]
    local procedure OnTrainingDocSendForApproval(var TrainHead: Record "Training Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(OnTrainingDocSendForApprovalCode, TrainHead);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddTrainingEventToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(OnTrainingDocSendForApprovalCode, DATABASE::"Training Header", TrainingSendForApproval, 0, false);
        WorkflowEventHandling.AddEventToLibrary(OnTrainingDocCancelForApprovalCode, DATABASE::"Training Header", TrainingCancelForApproval, 0, false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Training Header", 'OnCancelTrainingDocForApproval', '', false, false)]
    local procedure OnTrainingDocCancelForApproval(var TrainHead: Record "Training Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(OnTrainingDocCancelForApprovalCode, TrainHead);
        //<<Pradhan IMERemit1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure AddTrainingWorkflowEventResponseCombinationsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, OnTrainingDocSendForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            OnTrainingDocCancelForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(OnTrainingDocCancelForApprovalCode, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
    local procedure AddTrainingWorkflowTableRelationsToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Training Header", 0, DATABASE::"Approval Entry", 22);
    end;

    local procedure "-------------------"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddTrainingResponseToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(TrainingReleaseDocumentCode, 0, ReleaseTrainingTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(TrainingOpenDocumentCode, 0, OpenDocumentTrainingTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(TrainingSetStatusToPendingApprovalCode, 0, SetTrainingToPendingApprovalTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(TrainingCreateAndApproveApprovalRequestAutomaticallyCode, 0, CreateTrainingApproveApprovalRequestAutomaticallyTxt, 'Group 50000');
    end;

    procedure TrainingSetStatusToPendingApprovalCode(): Code[128]
    begin
        exit(UpperCase('TrainingSetStatusToPendingApproval'));
    end;

    procedure TrainingSetStatusToPendingApproval(var Variant: Variant)
    begin
        SetStatusToPendingApproval(Variant);
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddTrainingWorkflowsEventResponseCombinationsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, OnTrainingDocSendForApprovalCode);
            WorkflowResponseHandling.RestrictRecordUsageCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RestrictRecordUsageCode, OnTrainingDocSendForApprovalCode);
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, OnTrainingDocSendForApprovalCode);
            WorkflowResponseHandling.AllowRecordUsageCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.AllowRecordUsageCode, OnTrainingDocCancelForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.AllowRecordUsageCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
                end;
            WorkflowResponseHandling.ShowMessageCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ShowMessageCode, OnTrainingDocCancelForApprovalCode);
            WorkflowResponseHandling.ApproveAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ApproveAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, OnTrainingDocCancelForApprovalCode);
            TrainingOpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(TrainingOpenDocumentCode, OnTrainingDocCancelForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(TrainingOpenDocumentCode, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
                end;
            TrainingReleaseDocumentCode:
                WorkflowResponseHandling.AddResponsePredecessor(TrainingReleaseDocumentCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            TrainingSetStatusToPendingApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(TrainingSetStatusToPendingApprovalCode, OnTrainingDocSendForApprovalCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure ExecuteTrainingWorkflowResponses(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                TrainingReleaseDocumentCode:
                    begin
                        TrainingReleaseDocument(Variant);
                        ResponseExecuted := true;
                    end;
                TrainingOpenDocumentCode:
                    begin
                        TrainingOpenDocument(Variant);
                        ResponseExecuted := true;
                    end;
                TrainingCreateAndApproveApprovalRequestAutomaticallyCode:
                    begin
                        TrainingCreateAndApproveApprovalRequestAutomatically(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
                TrainingSetStatusToPendingApprovalCode:
                    begin
                        SetStatusToPendingApproval(Variant);
                        ResponseExecuted := true;
                    end;
                TrainingCreateApprovalRequestsCode:
                    begin
                        TrainingCreateApprovalRequests(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
            end;
    end;

    procedure TrainingOpenDocumentCode(): Code[128]
    begin
        exit(UpperCase('TrainingOpenDocument'));
    end;

    procedure TrainingReleaseDocumentCode(): Code[128]
    begin
        exit(UpperCase('TrainingReleaseDocument'));
    end;

    local procedure TrainingReleaseDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        TrainHead: Record "Training Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    if not TargetRecRef.Get(ApprovalEntry."Record ID to Approve") then
                        exit;
                    Variant := TargetRecRef;
                    TrainingReleaseDocument(Variant);
                end;
            DATABASE::"Training Header":
                TrainHead.UpdateApprovalStatus(Variant, TrainHead."Approval Status"::Released);
            //MESSAGE('nothing');   //to be removed
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    local procedure TrainingOpenDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        TrainHead: Record "Training Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    if not TargetRecRef.Get(ApprovalEntry."Record ID to Approve") then
                        exit;
                    Variant := TargetRecRef;
                    TrainingOpenDocument(Variant);
                end;
            DATABASE::"Training Header":
                TrainHead.UpdateApprovalStatus(Variant, TrainHead."Approval Status"::Open);
            //MESSAGE('nothing'); //to be removed
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    procedure TrainingCreateApprovalRequestsCode(): Code[128]
    begin
        exit(UpperCase('TrainingCreateApprovalRequests'));
    end;

    local procedure TrainingCreateApprovalRequests(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmt.CreateApprovalRequests(RecRef, WorkflowStepInstance);
    end;

    procedure TrainingCreateAndApproveApprovalRequestAutomaticallyCode(): Code[128]
    begin
        exit(UpperCase('TrainingFromCreateAndApproveApprovalRequestAutomatically'));
    end;

    local procedure TrainingCreateAndApproveApprovalRequestAutomatically(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, WorkflowStepInstance);
        //<<Pradhan IMERemit1.00
    end;

    local procedure "--------------Facilitator Pool(Training)--------------"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure AddFacilitatorWorkflowCategoriesToLibrary()
    begin
        InsertWorkflowCategory(FacilitatorDocCategoryTxt, CustFacilitatorCategoryDescTxt);
    end;

    local procedure InsertFacilitatorApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow, FacilitatorApprWorkflowCodeTxt, FacilitatorApprWorkflowDescTxt, FacilitatorDocCategoryTxt);
        InsertFacilitatorApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertFacilitatorApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        Facilitator: Record "Facilitator Pool";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, true);
        InsertFacilitatorDocApprovalWorkflowSteps(Workflow,
          BuildFacilitatorConditions(Facilitator."Approval Status"::open),
          OnFacilitatorDocSendForApprovalCode,
          BuildFacilitatorConditions(Facilitator."Approval Status"::Pending),
          OnFacilitatorDocCancelForApprovalCode,
          WorkflowStepArgument, true);
    end;

    procedure BuildFacilitatorConditions(Status: Option): Text
    var
        Facilitator: Record "Facilitator Pool";
    begin
        Facilitator.SetRange("Approval Status", Status);
        exit(StrSubstNo(FacilitatorTypeCondnTxt, Encode(Facilitator.GetView(false))));
    end;

    procedure OnFacilitatorDocSendForApprovalCode(): Code[128]
    begin
        exit(UpperCase('OnFacilitatorDocSendForApproval'));
    end;

    procedure OnFacilitatorDocCancelForApprovalCode(): Code[128]
    begin
        exit(UpperCase('OnFacilitatorDocCancelForApproval'));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Facilitator Pool", 'OnSendFacilitatorDocForApproval', '', false, false)]
    local procedure OnFacilitatorDocSendForApproval(var Facilitator: Record "Facilitator Pool")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(OnFacilitatorDocSendForApprovalCode, Facilitator);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddFacilitatorEventToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(OnFacilitatorDocSendForApprovalCode, DATABASE::"Facilitator Pool", FacilitatorSendForApproval, 0, false);
        WorkflowEventHandling.AddEventToLibrary(OnFacilitatorDocCancelForApprovalCode, DATABASE::"Facilitator Pool", FacilitatorCancelForApproval, 0, false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Facilitator Pool", 'OnCancelFacilitatorDocForApproval', '', false, false)]
    local procedure OnFacilitatorDocCancelForApproval(var Facilitator: Record "Facilitator Pool")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(OnFacilitatorDocCancelForApprovalCode, Facilitator);
        //<<Pradhan IMERemit1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure AddFacilitatorWorkflowEventResponseCombinationsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, OnFacilitatorDocSendForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            OnFacilitatorDocCancelForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(OnFacilitatorDocCancelForApprovalCode, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
    local procedure AddFacilitatorWorkflowTableRelationsToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Facilitator Pool", 0, DATABASE::"Approval Entry", 22);
    end;

    local procedure "--------------------------------------"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddFacilitatorResponseToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(FacilitatorReleaseDocumentCode, 0, ReleaseFacilitatorTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(FacilitatorOpenDocumentCode, 0, OpenDocumentFacilitatorTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(FacilitatorSetStatusToPendingApprovalCode, 0, SetFacilitatorToPendingApprovalTxt, 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(FacilitatorCreateAndApproveApprovalRequestAutomaticallyCode, 0, CreateFacilitatorApproveApprovalRequestAutomaticallyTxt, 'Group 50000');
    end;

    procedure FacilitatorSetStatusToPendingApprovalCode(): Code[128]
    begin
        exit(UpperCase('FacilitatorSetStatusToPendingApproval'));
    end;

    procedure FacilitatorSetStatusToPendingApproval(var Variant: Variant)
    begin
        SetStatusToPendingApproval(Variant);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddFacilitatorWorkflowsEventResponseCombinationsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, OnFacilitatorDocSendForApprovalCode);
            WorkflowResponseHandling.RestrictRecordUsageCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RestrictRecordUsageCode, OnFacilitatorDocSendForApprovalCode);
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, OnFacilitatorDocSendForApprovalCode);
            WorkflowResponseHandling.AllowRecordUsageCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.AllowRecordUsageCode, OnFacilitatorDocCancelForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.AllowRecordUsageCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
                end;
            WorkflowResponseHandling.ShowMessageCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ShowMessageCode, OnFacilitatorDocCancelForApprovalCode);
            WorkflowResponseHandling.ApproveAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ApproveAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, OnFacilitatorDocCancelForApprovalCode);
            FacilitatorOpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(FacilitatorOpenDocumentCode, OnFacilitatorDocCancelForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(FacilitatorOpenDocumentCode, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode);
                end;
            FacilitatorReleaseDocumentCode:
                WorkflowResponseHandling.AddResponsePredecessor(FacilitatorReleaseDocumentCode, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode);
            FacilitatorSetStatusToPendingApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(FacilitatorSetStatusToPendingApprovalCode, OnFacilitatorDocSendForApprovalCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure ExecuteFacilitatorWorkflowResponses(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                FacilitatorReleaseDocumentCode:
                    begin
                        FacilitatorReleaseDocument(Variant);
                        ResponseExecuted := true;
                    end;
                FacilitatorOpenDocumentCode:
                    begin
                        FacilitatorOpenDocument(Variant);
                        ResponseExecuted := true;
                    end;
                FacilitatorCreateAndApproveApprovalRequestAutomaticallyCode:
                    begin
                        FacilitatorCreateAndApproveApprovalRequestAutomatically(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
                FacilitatorSetStatusToPendingApprovalCode:
                    begin
                        SetStatusToPendingApproval(Variant);
                        ResponseExecuted := true;
                    end;
                FacilitatorCreateApprovalRequestsCode:
                    begin
                        FacilitatorCreateApprovalRequests(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
            end;
    end;

    procedure FacilitatorOpenDocumentCode(): Code[128]
    begin
        exit(UpperCase('FacilitatorOpenDocument'));
    end;

    procedure FacilitatorReleaseDocumentCode(): Code[128]
    begin
        exit(UpperCase('FacilitatorReleaseDocument'));
    end;

    local procedure FacilitatorReleaseDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        Facilitator: Record "Facilitator Pool";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    if not TargetRecRef.Get(ApprovalEntry."Record ID to Approve") then
                        exit;
                    Variant := TargetRecRef;
                    FacilitatorReleaseDocument(Variant);
                end;
            DATABASE::"Facilitator Pool":
                Facilitator.UpdateApprovalStatus(Variant, Facilitator."Approval Status"::released);
            //MESSAGE('nothing');   //to be removed
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    local procedure FacilitatorOpenDocument(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        Facilitator: Record "Facilitator Pool";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    if not TargetRecRef.Get(ApprovalEntry."Record ID to Approve") then
                        exit;
                    Variant := TargetRecRef;
                    FacilitatorOpenDocument(Variant);
                end;
            DATABASE::"Facilitator Pool":
                Facilitator.UpdateApprovalStatus(Variant, Facilitator."Approval Status"::open);
            //MESSAGE('nothing'); //to be removed
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    procedure FacilitatorCreateApprovalRequestsCode(): Code[128]
    begin
        exit(UpperCase('FacilitatorCreateApprovalRequests'));
    end;

    local procedure FacilitatorCreateApprovalRequests(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmt.CreateApprovalRequests(RecRef, WorkflowStepInstance);
    end;

    procedure FacilitatorCreateAndApproveApprovalRequestAutomaticallyCode(): Code[128]
    begin
        exit(UpperCase('FacilitatorFromCreateAndApproveApprovalRequestAutomatically'));
    end;

    local procedure FacilitatorCreateAndApproveApprovalRequestAutomatically(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, WorkflowStepInstance);
        //<<Pradhan IMERemit1.00
    end;

    local procedure "-------HR Mgt--------"()
    begin
    end;

    procedure getDateinFormat(DateVar: Date): Text
    var
        Day: Text;
        Month: Text;
        Year: Text;
    begin
        //day
        if Date2DMY(DateVar, 1) < 10 then
            Day := '0' + Format(Date2DMY(DateVar, 1))
        else
            Day := Format(Date2DMY(DateVar, 1));
        //month
        if Date2DMY(DateVar, 2) < 10 then
            Month := '0' + Format(Date2DMY(DateVar, 2))
        else
            Month := Format(Date2DMY(DateVar, 2));
        //year
        Year := Format(Date2DMY(DateVar, 3));
        exit(Day + '-' + Month + '-' + Year);
    end;

    procedure getTimeInFormat(varTime: Time): Text
    var
        Milliseconds: Integer;
        Hours: Integer;
        Minutes: Integer;
        Seconds: Integer;
        HoursText: Text;
        MinutesText: Text;
        SecondsText: Text;
        TimeText: Text;
    begin
        if varTime = 0T then
            exit('');
        Milliseconds := varTime - 000000T;
        Hours := Round(Milliseconds div 1000 div 60 div 60, 1, '=');
        if Hours < 10 then
            HoursText := '0' + Format(Hours)
        else
            HoursText := Format(Hours);
        Milliseconds -= Hours * 1000 * 60 * 60;
        TimeText := 'AM';
        Minutes := Round(Milliseconds div 1000 div 60, 1, '=');
        if Minutes < 10 then
            MinutesText := '0' + Format(Minutes)
        else
            MinutesText := Format(Minutes);
        if Hours = 12 then
            TimeText := 'PM';
        Milliseconds -= Minutes * 1000 * 60;
        Seconds := Round(Milliseconds div 1000, 1, '=');
        if Seconds < 10 then
            SecondsText := '0' + Format(Seconds)
        else
            SecondsText := Format(Seconds);
        Milliseconds -= Seconds * 1000;
        if Hours > 12 then begin
            Hours := Hours mod 12;
            TimeText := 'PM';
            if Hours < 10 then
                HoursText := '0' + Format(Hours)
            else
                HoursText := Format(Hours);
        end;
        exit(HoursText + ':' + MinutesText + ' ' + TimeText);
    end;

    procedure CheckForCitizen(CitizenNo: Code[30]; CitizenPlace: Code[20])
    var
        ErrorCitizenError: Label 'Citizenship No %1 of issed place %2 already exist.';
    begin
        Employee.Reset;
        Employee.SetRange("Citizen Number", CitizenNo);
        Employee.SetRange("Citizenship Issue Place Code", CitizenPlace);
        if Employee.FindFirst then
            Error(ErrorCitizenError, CitizenNo, CitizenPlace);
    end;

    procedure GetChoraChori(Gender: Enum "Employee Gender"): Text
    var
        Relative: Record Relative;
    begin
        Clear(Relative);
        Relative.SetRange(Relation, Relative.Relation::Father);
        if Relative.FindFirst then begin
            case Gender of
                Employee.Gender::Male:
                    exit(Relative."Male Corres. Relation (Nepali)");
                Employee.Gender::Female:
                    exit(Relative."FemaleCorres. Relation(Nepali)");
            end;
        end;
    end;

    procedure GetNatiNatini(Gender: Enum "Employee Gender"): Text
    var
        Relative: Record Relative;
    begin
        Clear(Relative);
        Relative.SetRange(Relation, Relative.Relation::GrandFather);
        if Relative.FindFirst then begin
            case Gender of
                Employee.Gender::Male:
                    exit(Relative."Male Corres. Relation (Nepali)");
                Employee.Gender::Female:
                    exit(Relative."FemaleCorres. Relation(Nepali)");
            end;
        end;
    end;

    procedure CheckDistrictName(DistrictName: Text)
    var
        DistrictVar: Record District;
        ErrorDistrict: Label 'District Name %1 Not found';
    begin
        DistrictVar.Reset;
        DistrictVar.SetRange("District Name", DistrictName);
        if not DistrictVar.FindFirst then
            Error(ErrorDistrict, DistrictName);
    end;

    procedure CheckCountryName(CountryName: Text)
    var
        Country: Record "Country/Region";
        ErrorDistrict: Label 'Country Name %1 Not found';
    begin
        Country.Reset;
        Country.SetRange("Name", CountryName);
        if not Country.FindFirst then
            Error(ErrorDistrict, CountryName);
    end;

    procedure LookupCountry(): Text
    var
        PageCountry: Page "Countries/Regions";
        Country: Record "Country/Region";
    begin
        Clear(PageCountry);
        Country.Reset;
        PageCountry.LookupMode(true);
        if PageCountry.RunModal = ACTION::LookupOK then begin
            PageCountry.GetRecord(Country);
            exit(Country.Name);
        end;
    end;

    procedure LookupCountryOtherThenNepalAndSAARC(): Text
    var
        PageCountry: Page "Countries/Regions";
        Country: Record "Country/Region";
    begin
        Clear(PageCountry);
        Country.Reset;
        Country.SetRange("Is SAARC", false);
        Country.SetRange("Is Nepal", false);
        PageCountry.SetRecord(Country);
        PageCountry.SetTableView(Country);
        PageCountry.LookupMode(true);
        if PageCountry.RunModal = ACTION::LookupOK then begin
            PageCountry.GetRecord(Country);
            exit(Country.Name);
        end;
    end;

    procedure LookupCountrySAARC(IsSAARC: Boolean): Text
    var
        PageCountry: Page "Countries/Regions";
        Country: Record "Country/Region";
    begin
        Clear(PageCountry);
        Country.Reset;
        Country.SetRange("Is SAARC", IsSAARC);
        PageCountry.SetRecord(Country);
        PageCountry.SetTableView(Country);
        PageCountry.LookupMode(true);
        if PageCountry.RunModal = ACTION::LookupOK then begin
            PageCountry.GetRecord(Country);
            exit(Country.Name);
        end;
    end;

    procedure LookupDistrict(ProvienceName: Text; xDisTxt: Text): Text
    var
        PageDistrict: Page "District";
        DistrictVar: Record District;
    begin
        Clear(PageDistrict);
        DistrictVar.Reset;
        DistrictVar.SetRange("Province Name", ProvienceName);
        PageDistrict.SetRecord(DistrictVar);
        PageDistrict.SetTableView(DistrictVar);
        PageDistrict.LookupMode(true);
        if PageDistrict.RunModal = ACTION::LookupOK then begin
            PageDistrict.GetRecord(DistrictVar);
            exit(DistrictVar."District Name");
        end;
        exit(xDisTxt);
    end;

    procedure LookupAllDistrict(): Text
    var
        PageDistrict: Page "District";
        DistrictVar: Record District;
    begin
        Clear(PageDistrict);
        DistrictVar.Reset;
        PageDistrict.LookupMode(true);
        if PageDistrict.RunModal = ACTION::LookupOK then begin
            PageDistrict.GetRecord(DistrictVar);
            exit(DistrictVar."District Name");
        end;
    end;

    procedure CheckMunicipalityName(MunicipalityName: Text[50])
    var
        Municipality: Record Municipality;
        ErrorDistrict: Label 'Municipality Name %1 Not found';
    begin
        Municipality.Reset;
        Municipality.SetRange("Municipality Name", MunicipalityName);
        if not Municipality.FindFirst then
            Error(ErrorDistrict, MunicipalityName);
    end;

    procedure LookupMunicipalityName(DistrictName: Text[50]; MunicipalityName: Text): Text
    var
        PageMunicipality: Page "Municipalities";
        Municipality: Record Municipality;
    begin
        Clear(PageMunicipality);
        Municipality.Reset;
        Municipality.SetRange("District Name", DistrictName);
        PageMunicipality.SetRecord(Municipality);
        PageMunicipality.SetTableView(Municipality);
        PageMunicipality.LookupMode(true);
        if PageMunicipality.RunModal = ACTION::LookupOK then begin
            PageMunicipality.GetRecord(Municipality);
            exit(Municipality."Municipality Name");
        end;
        exit(MunicipalityName);
    end;

    procedure CheckProvience(ProvienceName: Text)
    var
        ProvienceVar: Record Province;
        ErrorProvience: Label 'Provience Name %1 not found.';
    begin
        Clear(ProvienceVar);
        ProvienceVar.SetRange(Description, ProvienceName);
        if not ProvienceVar.FindFirst then
            Error(ErrorProvience, ProvienceName);
    end;

    procedure LookupProvience(xProvTxt: Text): Text
    var
        PageProvience: Page "Provinces List";
        ProvienceZone: Record Province;
    begin
        Clear(ProvienceZone);
        Clear(PageProvience);
        PageProvience.SetRecord(ProvienceZone);
        PageProvience.SetTableView(ProvienceZone);
        PageProvience.LookupMode(true);
        if PageProvience.RunModal = ACTION::LookupOK then begin
            PageProvience.GetRecord(ProvienceZone);
            exit(ProvienceZone.Description);
        end;
        exit(xProvTxt);
    end;

    procedure LookupProvinceOrganization(): Text[500]
    var
        ProvienceOrganizationList: Record "Organization Structure List";
        ProvienceOrganizationPage: Page "Organization Structure list";
        ConcatenatedValues: Text;
    begin
        Clear(ProvienceOrganizationList);
        Clear(ProvienceOrganizationPage);
        ProvienceOrganizationList.SetRange(Type, ProvienceOrganizationList.Type::Province);
        ProvienceOrganizationPage.SetRecord(ProvienceOrganizationList);
        ProvienceOrganizationPage.SetTableView(ProvienceOrganizationList);
        ProvienceOrganizationPage.LookupMode(true);
        if ProvienceOrganizationPage.RunModal = ACTION::LookupOK then begin
            ProvienceOrganizationPage.SetSelectionFilter(ProvienceOrganizationList);
            if ProvienceOrganizationList.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += ProvienceOrganizationList.code;
                until ProvienceOrganizationList.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupBranch(Province: Text): Text[500]
    var
        OrganizationStructureList: Record "Organization Structure List";
        OrganizationStructureListPage: Page "Organization Structure list";
        ConcatenatedValues: Text;
    begin
        Clear(OrganizationStructureList);
        Clear(OrganizationStructureListPage);
        if Province <> '' then
            OrganizationStructureList.SetRange("Province Code", Province);
        OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Branch);
        OrganizationStructureListPage.SetRecord(OrganizationStructureList);
        OrganizationStructureListPage.SetTableView(OrganizationStructureList);
        OrganizationStructureListPage.LookupMode(true);
        if OrganizationStructureListPage.RunModal = ACTION::LookupOK then begin
            OrganizationStructureListPage.SetSelectionFilter(OrganizationStructureList);
            if OrganizationStructureList.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += OrganizationStructureList.code;
                until OrganizationStructureList.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupMultipleDistrict(): Text[500]
    var
        District: Record District;
        DistrictPage: Page District;
        ConcatenatedValues: Text;
    begin
        Clear(District);
        Clear(DistrictPage);
        DistrictPage.SetRecord(District);
        DistrictPage.SetTableView(District);
        DistrictPage.LookupMode(true);
        if DistrictPage.RunModal = ACTION::LookupOK then begin
            DistrictPage.SetSelectionFilter(District);
            if District.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += District."District Name";
                until District.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupMultipleMunicipality(): Text[500]
    var
        Municipality: Record Municipality;
        MunicipalityPage: Page Municipalities;
        ConcatenatedValues: Text;
    begin
        Clear(Municipality);
        Clear(MunicipalityPage);
        MunicipalityPage.SetRecord(Municipality);
        MunicipalityPage.SetTableView(Municipality);
        MunicipalityPage.LookupMode(true);
        if MunicipalityPage.RunModal = ACTION::LookupOK then begin
            MunicipalityPage.SetSelectionFilter(Municipality);
            if Municipality.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += Municipality.Code;
                until Municipality.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupEmployee(): Text[500]
    var
        Employee: Record Employee;
        EmployeePage: Page "Employee List";
        ConcatenatedValues: Text;
    begin
        Clear(Employee);
        Clear(EmployeePage);
        EmployeePage.SetRecord(Employee);
        EmployeePage.SetTableView(Employee);
        EmployeePage.LookupMode(true);
        if EmployeePage.RunModal = ACTION::LookupOK then begin
            EmployeePage.SetSelectionFilter(Employee);
            if Employee.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += Employee."No.";
                until Employee.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupDepartment(Province: Text; Branch: Text): Text[500]
    var
        OrganizationStructureList: Record "Organization Structure List";
        OrganizationStructureListPage: Page "Organization Structure list";
        ConcatenatedValues: Text;
    begin
        Clear(OrganizationStructureList);
        Clear(OrganizationStructureListPage);
        if Province <> '' then
            OrganizationStructureList.SetRange("Province Code", Province);
        OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Department);
        OrganizationStructureListPage.SetRecord(OrganizationStructureList);
        OrganizationStructureListPage.SetTableView(OrganizationStructureList);
        OrganizationStructureListPage.LookupMode(true);
        if OrganizationStructureListPage.RunModal = ACTION::LookupOK then begin
            OrganizationStructureListPage.SetSelectionFilter(OrganizationStructureList);
            if OrganizationStructureList.FindSet() then begin
                repeat
                    if ConcatenatedValues <> '' then
                        ConcatenatedValues += '|';
                    ConcatenatedValues += OrganizationStructureList.code;
                until OrganizationStructureList.Next() = 0;
            end;
            exit(ConcatenatedValues);
        end;
    end;

    procedure LookupFunctionalTitile(FunctTitleText: Text): Text
    var
        PageFunctTitle: Page "Functional Title List";
        FunctTitle: Record "Functional Title";
    begin
        FunctTitle.Reset;
        Clear(PageFunctTitle);
        PageFunctTitle.AssignShowSelected;
        PageFunctTitle.InsertFunctTitle(FunctTitleText);
        PageFunctTitle.SetRecord(FunctTitle);
        PageFunctTitle.SetTableView(FunctTitle);
        if PageFunctTitle.RunModal = ACTION::OK then
            exit(PageFunctTitle.ReturnFunctTitleText);
    end;

    procedure ValidateTaxCode(Gender: Enum "Employee Gender"; MaritalStatus: Enum "Marital Status"): Code[20]
    var
        TaxCodeVar: Record "Tax Setup Header";
    begin
        TaxCodeVar.Reset;
        TaxCodeVar.SetRange(Gender, Gender);
        TaxCodeVar.SetRange("Marital Status", MaritalStatus);
        if TaxCodeVar.FindFirst then
            exit(TaxCodeVar.Code);
    end;

    procedure ReturnCurrencyCode(CurrCode: Code[20]): Text
    begin
        if CurrCode <> '' then
            exit(' (' + CurrCode + ')');
    end;

    procedure SetCalendarHolidayProvience(xProviencetext: Text[150]): Text[150]
    var
        PageProvicence: Page "Provinces List";
        ProvienceVar: Record Province;
    begin
        Clear(PageProvicence);
        Clear(ProvienceVar);
        PageProvicence.ForBaseCalendar;
        PageProvicence.InitProvinText(xProviencetext);
        PageProvicence.SetRecord(ProvienceVar);
        PageProvicence.SetTableView(ProvienceVar);
        if PageProvicence.RunModal = ACTION::OK then begin
            if PageProvicence.ReturnProvText = '' then
                exit(xProviencetext)
            else
                exit(PageProvicence.ReturnProvText);
        end;
    end;

    procedure ReturnSelectedEmployeeCode(xEmployeeCode: Text): Text
    var
        PageEmployeeList: Page "Select Employee List";
    begin
        Clear(PageEmployeeList);
        Clear(Employee);
        PageEmployeeList.ForTransferNotify;
        PageEmployeeList.InitEmployeeText(xEmployeeCode);
        PageEmployeeList.SetRecord(Employee);
        PageEmployeeList.SetTableView(Employee);
        if PageEmployeeList.RunModal = ACTION::OK then begin
            exit(PageEmployeeList.ReturnEmployeeText);
        end;
    end;

    procedure ReturnFiscalYear(EngDate: Date): Text
    var
        EngNep: Record "English-Nepali Date";
    begin
        EngNep.SetLoadFields("English Date", "Fiscal Year");
        EngNep.SetRange("English Date", EngDate);
        if EngNep.FindFirst then
            exit(EngNep."Fiscal Year");
    end;

    // procedure ReturnEndDateFY(FiscalYear: Text) EndDateFY: Date
    // var
    //     EngNep: Record "English-Nepali Date";
    // begin
    //     EngNep.Reset;
    //     EngNep.SetRange("Fiscal Year", FiscalYear);
    //     EngNep.SetCurrentKey("English Date");
    //     if EngNep.FindLast then
    //         exit(EngNep."English Date");
    // end;

    procedure ReturnEmpName(EmpCode: Code[20]): Text
    begin
        if Employee.Get(EmpCode) then
            exit(Employee."Full Name");
    end;

    procedure GetNoDaysInMonth(): Decimal
    begin
        PRSetup.Get;
        exit(Round((PRSetup."Payroll Fiscal Year End Date" - PRSetup."Payroll Fiscal Year Start Date" + 1) / 12, 0.01, '='));
    end;

    local procedure "-----Training-------"()
    begin
    end;

    procedure CaluateDuration(StartTime: Time; EndTime: Time; NoOfDays: Decimal): Duration
    var
        ErrorTime: Label 'Start time cannot be greater than end time';
    begin
        if NoOfDays = 1 then
            if StartTime > EndTime then
                Error(ErrorTime);
        exit((EndTime - StartTime) * NoOfDays);
    end;

    procedure CheckAgeAndBirthday(BirthdayDate: Date; CheckAgeDate: Date; var AgeYears: Integer; var AgeDays: Integer; var IsBirthDayDate: Boolean)
    var
        TestDate: Date;
    begin
        AgeYears := 0;
        repeat
            AgeYears += 1;
            TestDate := CalcDate(StrSubstNo('<+%1Y>', AgeYears), BirthdayDate);
        until TestDate >= CheckAgeDate;
        AgeYears -= 1;
        AgeDays := CheckAgeDate - BirthdayDate;
        IsBirthDayDate := TestDate = CheckAgeDate;
    end;

    procedure InsertEmployeeWiseTrainingQuestion(TrainingNo: Code[20]; EmployeeNo: Code[20])
    var
        SubQuet: Record "Employee Question Setup";
        QATrain: Record "Employee Feedback";
        LineNo: Integer;
    begin
        SubQuet.Reset;
        SubQuet.SetRange(Type, SubQuet.Type::Training);
        if SubQuet.Find('-') then
            repeat
                QATrain.Reset;
                QATrain.SetRange("Question Code", SubQuet."Question Code");
                QATrain.SetRange("Employee No.", EmployeeNo);
                QATrain.SetRange(Code, TrainingNo);
                QATrain.SetRange("Line No.", SubQuet."Line No.");
                QATrain.SetRange(Type, QATrain.Type::Training);
                if not QATrain.FindFirst then begin
                    QATrain.Init;
                    QATrain.Validate(Code, TrainingNo);
                    QATrain.Validate(Type, QATrain.Type::Training);
                    QATrain.Validate("Sub Type", SubQuet."Sub Type");
                    QATrain.Validate("Employee No.", EmployeeNo);
                    QATrain.Validate(Type, QATrain.Type::Training);
                    QATrain.Validate(Question, SubQuet.Question);
                    QATrain.Validate("Question Code", SubQuet."Question Code");
                    QATrain.Validate("Line No.", SubQuet."Line No.");
                    QATrain.Insert;
                end;
            until SubQuet.Next = 0;
    end;

    procedure ShowTrainerList(TrainingNo: Code[20]; EmployeeNo: Code[20])
    var
        QATrain: Record "Employee Feedback";
    begin
        QATrain.Reset;
        QATrain.FilterGroup(2);
        QATrain.SetRange(Code, TrainingNo);
        QATrain.SetRange("Employee No.", EmployeeNo);
        QATrain.SetRange(Type, QATrain.Type::Training);
        QATrain.SetRange("Sub Type", QATrain."Sub Type"::Trainer);
        QATrain.FilterGroup(0);
        PAGE.Run(PAGE::"Employee Training Feedback", QATrain);
    end;

    procedure ShowTrainingList(TrainingNo: Code[20]; EmployeeNo: Code[20])
    var
        QATrain: Record "Employee Feedback";
    begin
        QATrain.Reset;
        QATrain.FilterGroup(2);
        QATrain.SetRange(Code, TrainingNo);
        QATrain.SetRange("Employee No.", EmployeeNo);
        QATrain.SetRange("Sub Type", QATrain."Sub Type"::Training);
        QATrain.SetRange(Type, QATrain.Type::Training);
        QATrain.FilterGroup(0);
        PAGE.Run(PAGE::"Employee Training Feedback", QATrain);
    end;

    local procedure CalculateTrainingMarks(TrainNo: Code[20]; EmpNo: Code[20]): Decimal
    var
        QATrain: Record "Employee Feedback";
        TotalMarks: Decimal;
    begin
        QATrain.Reset;
        QATrain.SetRange(Code, TrainNo);
        QATrain.SetRange("Employee No.", EmpNo);
        QATrain.SetRange("Sub Type", QATrain."Sub Type"::Training);
        QATrain.SetRange(Type, QATrain.Type::Training);
        QATrain.CalcSums(Marks);
        TotalMarks := QATrain.Marks;
        if QATrain.Count <> 0 then
            exit(TotalMarks / QATrain.Count);
    end;

    local procedure CalculateTrainerMarks(TrainNo: Code[20]; EmpNo: Code[20]): Decimal
    var
        QATrain: Record "Employee Feedback";
        TotalMarks: Decimal;
    begin
        QATrain.Reset;
        QATrain.SetRange(Code, TrainNo);
        QATrain.SetRange("Employee No.", EmpNo);
        QATrain.SetRange("Sub Type", QATrain."Sub Type"::Trainer);
        QATrain.SetRange(Type, QATrain.Type::Training);
        QATrain.CalcSums(Marks);
        TotalMarks := QATrain.Marks;
        if QATrain.Count <> 0 then
            exit(TotalMarks / QATrain.Count);
    end;

    procedure CalTraineeRemarksTraining(TrainNo: Code[20]; EmpNo: Code[20])
    var
        TrainLine: Record "Training Line";
    begin
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainNo);
        TrainLine.SetRange(Type, TrainLine.Type::Trainee);
        TrainLine.SetRange("Employee Code", EmpNo);
        if TrainLine.FindFirst then begin
            TrainLine.Validate("Training Marks", CalculateTrainingMarks(TrainNo, EmpNo));
            TrainLine.Validate("Trainer Marks", CalculateTrainerMarks(TrainNo, EmpNo));
            TrainLine.Modify;
        end;
    end;

    procedure CalTrainingMarks(TrainNo: Code[20])
    var
        TrainHead: Record "Training Header";
        TrainLine: Record "Training Line";
    begin
        if TrainHead.Get(TrainNo) then begin
            TrainLine.Reset;
            TrainLine.SetRange("Training No.", TrainNo);
            TrainLine.SetRange(Type, TrainLine.Type::Trainee);
            TrainHead.CalcFields("Total No. of Participant");
            TrainLine.CalcSums("Trainer Marks", "Training Marks");
            if TrainHead."Total No. of Participant" <> 0 then begin
                TrainHead.Validate("Total Trainer Marks", TrainLine."Trainer Marks" / TrainHead."Total No. of Participant");
                TrainHead.Validate("Total Training Marks", TrainLine."Training Marks" / TrainHead."Total No. of Participant");
                TrainHead.Validate("Trainer Percent", TrainHead."Total Trainer Marks" / 5 * 100);
                TrainHead.Validate("Training Percent", TrainHead."Total Training Marks" / 5 * 100);
                TrainHead.Modify;
            end;
        end;
    end;

    procedure GenerateTraineeForTraining(TrainNo: Code[20])
    var
        TrainHead: Record "Training Header";
        TrainLine: Record "Training Line";
        TrainerCode: Text;
        LineNo: Integer;
    begin
        Clear(TrainerCode);
        TrainHead.Get(TrainNo);
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainNo);
        //TrainLine.SetRange(Type,TrainLine.Type::Trainer);
        TrainLine.SetFilter("Trainer Type", '<>%1', TrainLine."Trainer Type"::External);
        if TrainLine.Find('-') then
            repeat
                if TrainerCode = '' then
                    TrainerCode := '<>' + TrainLine."Employee Code"
                else
                    TrainerCode += '|<>' + TrainLine."Employee Code";
            until TrainLine.Next = 0;
        Clear(TrainLine);
        TrainLine.SetRange("Training No.", TrainNo);
        TrainLine.SetRange(Type, TrainLine.Type::Trainee);
        TrainLine.SetCurrentKey("Training No.", "Line No", Type);
        if TrainLine.FindLast then
            LineNo := TrainLine."Line No";
        Employee.Reset;
        Employee.SetFilter("No.", TrainerCode);
        Employee.SetFilter("Global Dimension 1 Code", TrainHead."Branch Code");
        Employee.SetFilter("Department Code", TrainHead.Department);
        if Employee.Find('-') then
            repeat
                LineNo := TrainLine."Line No" + 10000;
                TrainLine.Init;
                TrainLine.Validate("Training No.", TrainNo);
                TrainLine.Validate(Type, TrainLine.Type::Trainee);
                TrainLine.Validate("Line No", LineNo);
                TrainLine.Validate("Employee Code", Employee."No.");
                TrainLine.Insert(true);
            until Employee.Next = 0;
    end;


    procedure ExportTrainee(TrainingHeader: Record "Training Header")
    var
        TrainingLine: Record "Training Line";
        CellType: Option Number,Text,Date,Time;
    begin
        ExcelBuffer.Reset;
        ExcelBuffer.DeleteAll;
        MakeExcelDataHeader(TrainingLine.FieldCaption("Training No."), CellType::Text);
        MakeExcelDataHeader(TrainingLine.FieldCaption("Employee Code"), CellType::Text);
        MakeExcelDataHeader(TrainingLine.FieldCaption(Name), CellType::Text);
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TrainingHeader."No.");
        if TrainingLine.FindFirst then begin
            repeat
                ExcelBuffer.NewRow;
                MakeExcelDataBody(TrainingLine."Training No.", CellType::Text);
                MakeExcelDataBody(TrainingLine."Employee Code", CellType::Text);
                MakeExcelDataBody(TrainingLine.Name, CellType::Text);
            until TrainingLine.Next = 0;
        end;
        CreateExcelBook(ExportTraineeTxt);
    end;

    procedure ExportTraineeAttendance(TrainingHeader: Record "Training Header")
    var
        TrainingAttendance: Record "Training Attendance";
        CellType: Option Number,Text,Date,Time;
    begin
        ExcelBuffer.Reset;
        ExcelBuffer.DeleteAll;
        MakeExcelDataHeader(TrainingAttendance.FieldCaption("Training No"), CellType::Text);
        MakeExcelDataHeader(TrainingAttendance.FieldCaption("Employee No."), CellType::Text);
        MakeExcelDataHeader(TrainingAttendance.FieldCaption("Attended Date"), CellType::Text);
        TrainingAttendance.Reset;
        TrainingAttendance.SetRange("Training No", TrainingHeader."No.");
        if TrainingAttendance.FindFirst then begin
            repeat
                ExcelBuffer.NewRow;
                MakeExcelDataBody(TrainingAttendance."Training No", CellType::Text);
                MakeExcelDataBody(TrainingAttendance."Employee No.", CellType::Text);
                MakeExcelDataBody(TrainingAttendance."Attended Date", CellType::Text);
            until TrainingAttendance.Next = 0;
        end;
        CreateExcelBook(ExportAttendanceTxt);
    end;

    local procedure MakeExcelDataHeader(HeadingCaption: Text; CellType: Option Number,Text,Date,Time)
    begin
        ExcelBuffer.AddColumn(HeadingCaption, false, '', true, false, true, '', CellType);
    end;

    local procedure MakeExcelDataBody(BodyValue: Variant; CellType: Option Number,Text,Date,Time)
    begin
        ExcelBuffer.AddColumn(BodyValue, false, '', false, false, false, '', CellType);
    end;

    local procedure CreateExcelBook(SheetName: Text)
    begin
        ExcelBuffer.CreateNewBook(SheetName);
        ExcelBuffer.OpenExcel();
        // ExcelBuffer.CreateBookAndOpenExcel('', SheetName, '', '', UserId);
        Error('');
    end;

    procedure ImportTrainee(TrainingHeader: Record "Training Header")
    var
        TotalRows: Integer;
        TrainingLine: Record "Training Line";
        LineNo: Integer;
    begin
        ExcelBuffer.Reset;
        LineNo := 0;
        OpenReadExcelBook;
        GetLastRowandColumn(TotalRows);
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TrainingHeader."No.");
        if TrainingLine.FindLast then
            LineNo := TrainingLine."Line No";
        for i := 2 to TotalRows do begin
            LineNo += 10000;
            InsertTrainee(i, TrainingHeader."No.", LineNo);
        end;
        ExcelBuffer.DeleteAll;
        Message('Trainees imported successfully.');
    end;

    local procedure OpenReadExcelBook()
    var
        ServerFileName: Text;
        SheetName: Text;
        tmpBlob: Codeunit "Temp Blob";
        InStr: InStream;
        File: File;
    begin
        UploadExcelFileToImport(ServerFileName, SheetName);
        ExcelBuffer.Reset;
        ExcelBuffer.LockTable;
        InStr.ReadText(ServerFileName);
        tmpBlob.CreateInStream(InStr);
        ExcelBuffer.OpenBookStream(InStr, SheetName);
        ExcelBuffer.ReadSheet;
    end;

    local procedure GetLastRowandColumn(var TotalRows: Integer)
    begin
        TotalRows := ExcelBuffer.Count;
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure InsertTrainee(RowNo: Integer; TrainingNo: Code[20]; LineNo: Integer)
    var
        TrainingLine: Record "Training Line";
    begin
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TrainingNo);
        TrainingLine.SetRange("Employee Code", GetValueAtCell(RowNo, 2));
        if not TrainingLine.FindFirst then begin
            TrainingLine.Init;
            TrainingLine."Training No." := TrainingNo;
            TrainingLine."Line No" := LineNo;
            TrainingLine.Validate("Employee Code", GetValueAtCell(RowNo, 2));
            TrainingLine.Type := TrainingLine.Type::Trainee;
            if TrainingLine."Employee Code" <> '' then
                TrainingLine.Insert(true);
        end;
    end;

    procedure ImportTraineeAttendance(TrainingHeader: Record "Training Header")
    var
        TotalRows: Integer;
        TrainingAttendance: Record "Training Attendance";
        LineNo: Integer;
    begin
        ExcelBuffer.Reset;
        LineNo := 0;
        OpenReadExcelBook;
        GetLastRowandColumn(TotalRows);
        TrainingAttendance.Reset;
        TrainingAttendance.SetRange("Training No", TrainingHeader."No.");
        if TrainingAttendance.FindLast then
            LineNo := TrainingAttendance."Line No.";
        for i := 2 to TotalRows do begin
            LineNo += 10000;
            InsertTraineeAttendance(i, TrainingHeader."No.", LineNo);
        end;
        ExcelBuffer.DeleteAll;
        Message('Attendance imported successfully.');
    end;

    local procedure InsertTraineeAttendance(RowNo: Integer; TrainingNo: Code[20]; LineNo: Integer)
    var
        TrainingAttendance: Record "Training Attendance";
        AttendedDate: Date;
    begin
        AttendedDate := 0D;
        TrainingAttendance.Reset;
        TrainingAttendance.SetRange("Training No", TrainingNo);
        TrainingAttendance.SetRange("Employee No.", GetValueAtCell(RowNo, 2));
        TrainingAttendance.SetFilter("Attended Date", GetValueAtCell(RowNo, 3));
        if not TrainingAttendance.FindFirst then begin
            TrainingAttendance.Init;
            TrainingAttendance."Training No" := TrainingNo;
            TrainingAttendance."Line No." := LineNo;
            TrainingAttendance.Validate("Employee No.", GetValueAtCell(RowNo, 2));
            Evaluate(AttendedDate, GetValueAtCell(RowNo, 3));
            TrainingAttendance.Validate("Attended Date", AttendedDate);
            if TrainingAttendance."Employee No." <> '' then
                TrainingAttendance.Insert(true);
        end;
    end;

    local procedure UploadExcelFileToImport(var ServerFileName: Text; var SheetName: Text)
    var
        FileManagement: Codeunit "File Management";
        InStr: InStream;
        tmpBlob: Codeunit "Temp Blob";
        File: File;
        Filebool: Boolean;
    begin
        Filebool := UploadIntoStream(UploadFileTxt, InStr);
        // ServerFileName := FileManagement.UploadFile(UploadFileTxt, ExlExt);
        // InStr.ReadText(ServerFileName);
        // tmpBlob.CreateInStream(InStr);
        SheetName := ExcelBuffer.SelectSheetsNameStream(InStr);
    end;

    procedure GetEmployeeName(EmpCode: Code[20]; var EmpName: Text)
    var
        Temp: Text;
    begin
        Clear(Temp);
        Employee.Reset;
        if EmpCode <> '' then begin
            Employee.SetFilter("No.", EmpCode);
            if Employee.FindFirst then
                repeat
                    if Temp <> '' then
                        Temp += '|' + Employee."Full Name"
                    else
                        Temp := Employee."Full Name";
                until Employee.Next = 0;
        end;
        EmpName := CopyStr(Temp, 1, 50);
    end;

    procedure GetEmployeeNo(): Code[20]
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        exit(Employee."No.");
    end;

    procedure GetBranchCode(): Code[20]
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        exit(Employee."Branch Code");
    end;

    procedure GetEmployeeDeputationDistrictName(DeputationType: Enum "Deputation Type"; DeputaionOnCode: code[20]): text[50]
    begin
        if OrgStructureList.Get(DeputationType, DeputaionOnCode) then
            exit(OrgStructureList."District Name")
    end;

    procedure GetEmployeeDeputationMunicipalityCode(DeputationType: Enum "Deputation Type"; DeputaionOnCode: code[20]): text[50]
    begin
        if OrgStructureList.Get(DeputationType, DeputaionOnCode) then
            exit(OrgStructureList."Municipality Code")
    end;

    procedure GetEmployeeName(EmployeeCode: Code[20]): Text[50]
    begin
        Employee.Reset;
        if Employee.Get(EmployeeCode) then
            exit(Employee."Full Name");
    end;

    procedure GetFunctionalTitleCode(EmployeeCode: Code[20]): Text[20]
    begin
        Employee.Reset;
        if Employee.Get(EmployeeCode) then
            exit(Employee."Functional Title");
    end;

    procedure GetHrHead(): Code[20]
    begin
        HRSetup.Get;
        HRSetup.TestField("HR Head Functional Title");
        HRSetup.TestField("HR Department Code");
        Employee.Reset;
        Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee.SetRange("Department Code", HRSetup."HR Department Code");
        Employee.SetRange(Status, Employee.Status::Active);
        if Employee.FindFirst then
            exit(Employee."No.");
    end;

    procedure InsertAttachmentLines(DocumentNo: Code[20]; employeeAct: Enum "Employee Activity Type"; employeeNo: Code[20])
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        AttachmentMandatory.Reset;
        AttachmentMandatory.SetFilter(Type, Format(employeeAct));
        if AttachmentMandatory.FindFirst then
            repeat
                IncomingDocument.Reset;
                IncomingDocument.SetRange("No.", DocumentNo);
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := DocumentNo;
                    IncomingDocument."Employee Activity Type" := employeeAct;
                    IncomingDocument."Employee Code" := employeeNo;
                    IncomingDocument.Insert(true);
                end;
            until AttachmentMandatory.Next = 0;
    end;

    local procedure GetCandidateBody(var Candidate: Record Candidate)
    var
        BodyText1: Text;
    begin
    end;

    local procedure "--------------FOR REPORTS---------------"()
    begin
    end;

    procedure WorkStationFunction(EmployeeRec: Record Employee): Text
    var
        HRSetUp: Record "Human Resources Setup";
        SalaryLevel: Record "Salary Level";
        WorkStation: text;
    begin
        case EmployeeRec."Deputation on" of
            EmployeeRec."Deputation on"::Province:
                begin
                    WorkStation := EmployeeRec."Province Name";
                end;
            EmployeeRec."Deputation on"::Department:
                begin
                    if EmployeeRec."Unit Code" <> '' then
                        WorkStation := EmployeeRec."Unit Name"
                    else if EmployeeRec."Department Code" <> '' then begin
                        WorkStation := EmployeeRec."Department Name";
                    end;
                end;
            EmployeeRec."Deputation on"::Branch:
                begin
                    if EmployeeRec."Extension Counter Code" <> '' then
                        WorkStation := EmployeeRec."Extension Counter Name"
                    else if EmployeeRec."Branch Code" <> '' then begin
                        WorkStation := EmployeeRec."Branch Name";
                    end;
                end;
        end;
        OnAfterWorkStation(EmployeeRec, WorkStation);
        exit(WorkStation);
    end;

    procedure getDeputation(empCode: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(empCode) then
            exit(employee."Deputation On Code");
    end;

    procedure ReturnCalendarDescription(): Text
    begin
        exit(CalendarDescription);
    end;

    procedure IsWinter(CheckDate: Date; EmployeeWorkShift: Record "Employee Work Shift"): Boolean
    begin
        if (CheckDate >= EmployeeWorkShift."Winter Start Date") and (CheckDate <= EmployeeWorkShift."Winter End Date") then
            exit(true)
        else
            exit(false)
    end;

    procedure IsFriday(CheckDate: Date): Boolean
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", CheckDate);
        EngNep.FindFirst;
        exit(EngNep.Week = EngNep.Week::Friday);
    end;

    procedure GetNepaliDate(EnglishDate: Date): Text
    begin
        Clear(EngNep);
        EngNep.SetRange("English Date", EnglishDate);
        if EngNep.FindFirst then
            exit(EngNep."Nepali Date");
    end;

    procedure IsDashinTihar(CheckDate: date): Boolean
    var
        BaseCalenderchanges: Record "Base Calendar Change";
    begin
        BaseCalenderchanges.Reset();
        BaseCalenderchanges.SetRange(Date, CheckDate);
        BaseCalenderchanges.SetRange("Holiday Type", BaseCalenderchanges."Holiday Type"::"Dashain Tihar");
        exit(BaseCalenderchanges.FindFirst());
    end;

    procedure CheckEligibilityBeforeEmploymentDate(ActivityDate: Date; EmployeeNo: Code[20])
    begin
        Employee.get(EmployeeNo);
        if ActivityDate <> 0D then begin
            if ActivityDate < Employee."Employment Date" then
                Error('Cannot apply before your employment date');
        end;
    end;

    procedure UpdateInsuranceFromHomeLoan(EmployeeLoanAdvance: Record "Employee Loan/Advance")
    var
        EmployeeInsuranceInformation: Record "Employee Insurance Information";
        EmployeeInsuranceInfoPage: Page "Employee Insurance Card";
    begin
        if not Confirm('Do you want to update insurance detail ?', false) then
            exit;
        EmployeeInsuranceInformation.Reset;
        EmployeeInsuranceInformation.SetRange("Linked Home Loan Account No.", EmployeeLoanAdvance."No.");
        if not EmployeeInsuranceInformation.FindFirst then begin
            EmployeeInsuranceInformation.Init;
            EmployeeInsuranceInformation."Employee No." := EmployeeLoanAdvance."Employee No.";
            EmployeeInsuranceInformation."Employee Name" := EmployeeLoanAdvance."Employee Name";
            EmployeeInsuranceInformation."Linked Home Loan Account No." := EmployeeLoanAdvance."No.";
            EmployeeInsuranceInformation."Is Home Loan TieUp" := true;
            EmployeeInsuranceInformation.Insert(true);
            EmployeeInsuranceInfoPage.SetTableView(EmployeeInsuranceInformation);
            EmployeeInsuranceInfoPage.Run;
        end else begin
            EmployeeInsuranceInfoPage.SetTableView(EmployeeInsuranceInformation);
            EmployeeInsuranceInfoPage.Run;
        end;
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
        IsHandled: Boolean;
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
        TempRetirementFund.Validate("Fiscal Year", ReturnFiscalYear(Today));
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
            else
                TempRetirementFund."Projection Month" := PayrollReportMgt.GetLastPayCycleForEmployee(empcode, PayCyclePeriod."Pay Cycle Term");
        end
        else begin
            if (PRSetup."Payroll Fiscal Year Start Date" < Employee."Employment Date") and
                            (PRSetup."Payroll Fiscal Year End Date" > Employee."Employment Date") then
                TempRetirementFund."Projection Month" := PayrollReportMgt.GetFirstPayCycleForEmployee(empcode, PayCyclePeriod."Pay Cycle Term");
        end;
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
                        PayrollReportMgt.SetEmployeeCode(Employee."No.");
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

    procedure CalculateValueNegtiveOrPostive(Amount: Decimal): Decimal
    begin
        if Amount >= 0 then
            exit(Amount)
        else
            exit(0);
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

    procedure ScreenRF(var RetirementFund: Record "Retirement Fund")
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
    begin
        PRSetup.Get;
        RetirementFund.TestField("Approval Status", RetirementFund."Approval Status"::Pending);
        RetirementFund."Approval Status" := RetirementFund."Approval Status"::Screened;
        RetirementFund."Screened Date" := Today;
        RetirementFund."Screened By" := UserId;
        Employee.Get(RetirementFund."Employee No.");
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", RetirementFund."Employee No.");
        PayrollAttributesUsage.SetFilter(Subtype, '%1|%2', PayrollAttributesUsage.Subtype::CIT, PayrollAttributesUsage.Subtype::RF);
        if PayrollAttributesUsage.FindSet then
            repeat
                PayrollAttributesUsage.CalcFields(Subtype);
                if PayrollAttributesUsage.Subtype = PayrollAttributesUsage.Subtype::CIT then
                    if RetirementFund."CIT Amount (Month)" <> 0 then
                        if RetirementFund.Cancelled then
                            PayrollAttributesUsage.Validate(Amount, 0)
                        else
                            PayrollAttributesUsage.Validate(Amount, RetirementFund."CIT Amount (Month)");
                if PayrollAttributesUsage.Subtype = PayrollAttributesUsage.Subtype::RF then
                    if RetirementFund."RTF Amount (Month)" <> 0 then
                        if RetirementFund.Cancelled then
                            PayrollAttributesUsage.Validate(Amount, 0)  //reversing the changes
                        else
                            PayrollAttributesUsage.Validate(Amount, RetirementFund."RTF Amount (Month)");
                PayrollAttributesUsage.Modify(true);
                Employee.Modify;
            until PayrollAttributesUsage.Next = 0;
    end;

    procedure ApplyForRetirementFund(TempRetirementFund: Record "Retirement Fund"): Boolean
    var
        RFContibution: Record "RF Contribution";
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

    procedure ScreenAllRetirementFund()
    var
        RetirementFund: Record "Retirement Fund";
        Counter: Integer;
    begin
        Employee.Reset();
        Employee.SetRange(Status, Employee.Status::Active);
        //Employee.SetRange("No.",'PB4113');
        if Employee.FindFirst then
            repeat
                Counter := 1;
                RetirementFund.Reset();
                RetirementFund.SetRange("Employee No.", Employee."No.");
                RetirementFund.SetRange("Approval Status", RetirementFund."Approval Status"::Pending);
                RetirementFund.SetCurrentKey("Requested Date");
                if RetirementFund.FindLast then
                    repeat
                        if Counter = 1 then begin
                            ScreenRF(RetirementFund);
                            RetirementFund.Modify;
                        end else begin
                            RetirementFund."Approval Status" := RetirementFund."Approval Status"::Rejected;
                            RetirementFund.Modify;
                        end;
                        Counter += 1;
                    until RetirementFund.Next(-1) = 0;
            until Employee.Next = 0;
        Message('Completed.');
    end;

    procedure UpdateEmploymentDate(EmpCode: Code[20])
    var
        EmpPageBuilder: FilterPageBuilder;
        UpdateEmploymentDate: Label 'Update Employment Date';
        EmploymentDate: Date;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
        Counter: Integer;
        ServiceHistory: Record "Employee Service History";
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("Is Admin");
        EmpPageBuilder.AddTable(UpdateEmploymentDate, DATABASE::Employee);
        EmpPageBuilder.ADdField(UpdateEmploymentDate, Employee1."Employment Date");
        if EmpPageBuilder.RunModal then begin
            Employee1.SetView(EmpPageBuilder.GetView(UpdateEmploymentDate));
            Evaluate(EmploymentDate, Employee1.GetFilter("Employment Date"));
            if EmploymentDate = 0D then
                Error('Employment date must have value.');
            Employee.Get(EmpCode);
            if EmploymentDate > Employee."Employment Date" then begin
                EmpAttendanceActivity.Reset;
                EmpAttendanceActivity.SetRange("Employee No.", EmpCode);
                EmpAttendanceActivity.SetFilter("Attendance Date", '<%1', EmploymentDate);
                EmpAttendanceActivity.DeleteAll;
            end else if EmploymentDate < Employee."Employment Date" then begin
                for Counter := 1 to (Employee."Employment Date" - EmploymentDate) do begin
                    EmpAttendanceActivity.Init;
                    EmpAttendanceActivity.Validate("Employee No.", EmpCode);
                    EmpAttendanceActivity.Validate("Attendance Date", EmploymentDate + Counter - 1);
                    EmpAttendanceActivity.Validate("Absent Day", 1);
                    EmpAttendanceActivity.Insert;
                end;
            end;
            ServiceHistory.Reset;
            ServiceHistory.SetRange("Employee No.", EmpCode);
            ServiceHistory.SetRange("Service Event", ServiceHistory."Service Event"::Appointment);
            if ServiceHistory.FindFirst then begin
                ServiceHistory.Validate("Effective Date", EmploymentDate);
                ServiceHistory.Modify;
            end;
            Employee.Validate("Employment Date", EmploymentDate);
            Employee.Modify;
            Message('Update.');
        end;
    end;

    procedure GetEmpName(): Text
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        exit(Employee."Full Name");
    end;

    procedure GetEmpNameSaas(EmployeeNo: code[20]): Text
    begin
        Employee.Reset;
        Employee.SetRange("No.", EmployeeNo);
        Employee.FindFirst;
        exit(Employee."Full Name");
    end;


    // local procedure ValidateKRAInEmployeeKPIAnnually(AppraisalRec: Record Appraisal)
    // var
    //     KRAMaster: Record "KRA Master Setup";
    //     EmployeeKPI: Record "KPI Employee";
    //     LineNo: Integer;
    // begin
    //     KRAMaster.Reset;
    //     KRAMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
    //     KRAMaster.SetRange("Deputation on", AppraisalRec."Deputation on");
    //     KRAMaster.SetFilter(Description, '<>%1', '');
    //     KRAMaster.SetFilter("Key Result Area", '<>%1', 'CAPACITY');
    //     if AppraisalRec."Deputation on" in [AppraisalRec."Deputation on"::Branch, AppraisalRec."Deputation on"::"Extension Counter"] then
    //         KRAMaster.SetRange("Sol Id", AppraisalRec."Sol Id")
    //     else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::Province then
    //         KRAMaster.SetRange("Province Code", AppraisalRec.Province)
    //     else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::"Sub Province" then
    //         KRAMaster.SetRange("Sub Province Code", AppraisalRec."Sub-Province");
    //     if KRAMaster.FindFirst then
    //         repeat
    //             EmployeeKPI.Reset;
    //             LineNo += 10000;
    //             EmployeeKPI.Init;
    //             EmployeeKPI.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
    //             EmployeeKPI."Line No." := LineNo;
    //             EmployeeKPI.Validate("Key Result Area", KRAMaster."Key Result Area");
    //             EmployeeKPI.Validate("KRA Category", KRAMaster."KRA Category");
    //             EmployeeKPI.Validate(Description, KRAMaster.Description);
    //             EmployeeKPI.Validate("Weightage(%)", KRAMaster."Weightage Percent");
    //             EmployeeKPI.Validate("Target Assigned", KRAMaster."Target Assigned");
    //             EmployeeKPI.Validate("Actual Achievement", KRAMaster."Actual Achievement");
    //             EmployeeKPI.Validate("Employee Code", AppraisalRec."Employee Code");
    //             EmployeeKPI.Validate("Deputation on", KRAMaster."Deputation on");
    //             EmployeeKPI."From Setup" := true;
    //             EmployeeKPI.Insert;
    //         until KRAMaster.Next = 0;
    // end;
    // local procedure ValidateKRAInEmployeeSATKPIAnnually(AppraisalRec: Record Appraisal)
    // var
    //     KRAMaster: Record "KRA Master Setup";
    //     EmployeeKPI: Record "KPI Employee";
    //     LineNo: Integer;
    // begin
    //     KRAMaster.Reset;
    //     KRAMaster.SetRange("Employee Code", AppraisalRec."Employee Code");
    //     KRAMaster.SetFilter("Key Result Area", 'CAPACITY');
    //     if KRAMaster.FindFirst then
    //         repeat
    //             EmployeeKPI.Reset;
    //             LineNo += 10000;
    //             EmployeeKPI.Init;
    //             EmployeeKPI.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
    //             EmployeeKPI."Line No." := LineNo;
    //             EmployeeKPI.Validate("Key Result Area", KRAMaster."Key Result Area");
    //             EmployeeKPI.Validate("KRA Category", KRAMaster."KRA Category");
    //             EmployeeKPI.Validate(Description, KRAMaster.Description);
    //             EmployeeKPI.Validate("Weightage(%)", KRAMaster."Weightage Percent");
    //             EmployeeKPI.Validate("Target Assigned", KRAMaster."Target Assigned");
    //             EmployeeKPI.Validate("Actual Achievement", KRAMaster."Actual Achievement");
    //             EmployeeKPI.Validate("Employee Code", AppraisalRec."Employee Code");
    //             EmployeeKPI.Validate("Deputation on", AppraisalRec."Deputation on");
    //             EmployeeKPI."From Setup" := true;
    //             EmployeeKPI.Insert;
    //         until KRAMaster.Next = 0;
    // end;
    // local procedure ValidateKRAInEmployeeKRAAnnually(AppraisalRec: Record Appraisal)
    // var
    //     KRAMaster: Record "KRA Master Setup";
    //     KRASubform: Record "KRA Subform List";
    // begin
    //     KRAMaster.Reset;
    //     KRAMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
    //     KRAMaster.SetRange("Deputation on", AppraisalRec."Deputation on");
    //     if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::Branch then
    //         KRAMaster.SetRange("Sol Id", AppraisalRec."Sol Id")
    //     else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::"Extension Counter" then
    //         KRAMaster.SetRange("Sol Id", AppraisalRec."Sol Id")
    //     else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::Province then
    //         KRAMaster.SetRange("Province Code", AppraisalRec.Province)
    //     else if AppraisalRec."Deputation on" = AppraisalRec."Deputation on"::"Sub Province" then
    //         KRAMaster.SetRange("Sub Province Code", AppraisalRec."Sub-Province");
    //     if KRAMaster.FindFirst then
    //         repeat
    //             KRASubform.Reset;
    //             KRASubform.Init;
    //             KRASubform.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
    //             KRASubform.Validate("KRA Category", KRAMaster."KRA Category");
    //             KRASubform.Validate(Description, KRAMaster."KRA Master Name");
    //             KRASubform.Validate("Key Result Area", KRAMaster."Key Result Area");
    //             KRASubform.Validate("Weightage (%)", KRAMaster.Weightage);
    //             KRASubform.Validate("Employee Code", AppraisalRec."Employee Code");
    //             KRASubform.Insert;
    //         until KRAMaster.Next = 0;
    //     KRASubform.Reset;
    //     KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //     KRASubform.CalcSums("Weightage (%)");
    //     if KRASubform."Weightage (%)" <> 100 then
    //         Error('Sum of KRA (%1)weightage must be 100. Please contact admin.', AppraisalRec."KRA Category");
    // end;
    // procedure InsertEmployeeKPIAnnually(AppraisalRec: Record Appraisal)
    // var
    //     KPIMaster: Record "KPI Master";
    //     KPIEmpRec: Record "KPI Employee";
    //     KRASubform: Record "KRA Subform List";
    //     KPIWeightage: Decimal;
    // begin
    //     AppraisalRec.TestField("KRA Category");
    //     KPIMaster.Reset;
    //     KPIMaster.SetRange("Fiscal Year", AppraisalRec."Fiscal Year");
    //     KPIMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
    //     KPIMaster.SetRange("Appraisal Type", AppraisalRec."Appraisal Type");
    //     if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Monthly then
    //         KPIMaster.SetRange("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly")
    //     else if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Quarterly then
    //         KPIMaster.SetRange("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");
    //     KPIEmpRec.Reset;
    //     KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //     KPIEmpRec.SetRange("Employee Code", AppraisalRec."Employee Code");
    //     if KPIMaster.Find('-') then
    //         repeat
    //         begin
    //             KPIEmpRec.Validate("Employee Code", AppraisalRec."Employee Code");
    //             KPIEmpRec.Validate("Fiscal Year", AppraisalRec."Fiscal Year");
    //             KPIEmpRec.Validate("Appraisal Type", KPIMaster."Appraisal Type");
    //             KPIEmpRec.Validate("Appraisal Subtype Monthly", KPIMaster."Appraisal Subtype Monthly");
    //             KPIEmpRec.Validate("Appraisal Subtype Quarterly", KPIMaster."Appraisal Subtype Quarterly");
    //             KPIEmpRec.Validate("KPI No.", KPIMaster."KPI No.");
    //             KPIEmpRec.Validate("Target Assigned", KPIMaster."Target Assigned");
    //             KPIEmpRec.Validate("From Setup", true);
    //             KPIEmpRec.Modify;
    //         end;
    //         until KPIMaster.Next = 0;
    // end;


    procedure LookUpMunicipalityKPI(xMunicipalityTxt: Text[50]): Text[50]
    var
        PageMunicipality: Page Municipalities;
        Municipality: Record Municipality;
    begin
        Clear(Municipality);
        Clear(PageMunicipality);
        PageMunicipality.SetRecord(Municipality);
        PageMunicipality.SetTableView(Municipality);
        PageMunicipality.LookupMode(true);
        if PageMunicipality.RunModal = ACTION::LookupOK then begin
            PageMunicipality.GetRecord(Municipality);
            exit(Municipality."Municipality Name");
        end;
        exit(xMunicipalityTxt);
    end;

    procedure InsertFacilitatorDocApprovalWorkflowSteps(Workflow: Record Workflow; DocSendForApprovalConditionString: Text; DocSendForApprovalEventCode: Code[128]; DocCanceledConditionString: Text; DocCanceledEventCode: Code[128]; WorkflowStepArgument: Record "Workflow Step Argument"; ShowConfirmationMessage: Boolean);
    VAR
        SentForApprovalEventID: Integer;
        SetStatusToPendingApprovalResponseID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        RestrictRecordUsageResponseID: Integer;
        AllowRecordUsageResponseID: Integer;
        OpenDocumentResponceID: Integer;
        ShowMessageResponseID: Integer;
        WorkFlowSetup: Codeunit "Workflow Setup";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ApprovalRequestCanceledMsg: label 'ENU=The approval request for the record has been canceled.';
    begin
        SentForApprovalEventID := WorkFlowSetup.InsertEntryPointEventStep(Workflow, DocSendForApprovalEventCode);
        WorkFlowSetup.InsertEventArgument(SentForApprovalEventID, DocSendForApprovalConditionString);
        RestrictRecordUsageResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.RestrictRecordUsageCode,
            SentForApprovalEventID);
        SetStatusToPendingApprovalResponseID := WorkFlowSetup.InsertResponseStep(Workflow, FacilitatorSetStatusToPendingApprovalCode(),
            RestrictRecordUsageResponseID);
        CreateApprovalRequestResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.CreateApprovalRequestsCode,
            SetStatusToPendingApprovalResponseID);
        WorkFlowSetup.InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type", WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code", WorkflowStepArgument."Approver User ID", WorkflowStepArgument."Due Date Formula", ShowConfirmationMessage);
        SendApprovalRequestResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        WorkFlowSetup.InsertNotificationArgument(SendApprovalRequestResponseID, false, '', 0, '');
        OnAllRequestsApprovedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnAllRequestsApprovedEventID, WorkFlowSetup.BuildNoPendingApprovalsConditions);
        AllowRecordUsageResponseID :=
          WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode, OnAllRequestsApprovedEventID);
        WorkFlowSetup.InsertResponseStep(Workflow, FacilitatorReleaseDocumentCode, AllowRecordUsageResponseID);
        OnRequestApprovedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnRequestApprovedEventID, WorkFlowSetup.BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);
        WorkFlowSetup.SetNextStep(Workflow, SendApprovalRequestResponseID2, SendApprovalRequestResponseID);
        OnRequestRejectedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            OnRequestRejectedEventID);
        WorkFlowSetup.InsertNotificationArgument(RejectAllApprovalsResponseID, false, '', WorkflowStepArgument."Link Target Page", '');
        WorkFlowSetup.InsertResponseStep(Workflow, FacilitatorOpenDocumentCode, RejectAllApprovalsResponseID);
        OnRequestCanceledEventID := WorkFlowSetup.InsertEventStep(Workflow, DocCanceledEventCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnRequestCanceledEventID, DocCanceledConditionString);
        CancelAllApprovalsResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.CancelAllApprovalRequestsCode,
            OnRequestCanceledEventID);
        WorkFlowSetup.InsertNotificationArgument(CancelAllApprovalsResponseID, false, '', WorkflowStepArgument."Link Target Page", '');
        AllowRecordUsageResponseID :=
          WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode, CancelAllApprovalsResponseID);
        OpenDocumentResponceID := WorkFlowSetup.InsertResponseStep(Workflow, FacilitatorOpenDocumentCode, AllowRecordUsageResponseID);//pram
        ShowMessageResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.ShowMessageCode, OpenDocumentResponceID);
        WorkFlowSetup.InsertMessageArgument(ShowMessageResponseID, ApprovalRequestCanceledMsg);
        OnRequestDelegatedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);
        WorkFlowSetup.SetNextStep(Workflow, SentApprovalRequestResponseID3, SendApprovalRequestResponseID);
    end;

    procedure InsertTrainingDocApprovalWorkflowSteps(Workflow: Record Workflow; DocSendForApprovalConditionString: Text; DocSendForApprovalEventCode: Code[128]; DocCanceledConditionString: Text; DocCanceledEventCode: Code[128]; WorkflowStepArgument: Record "Workflow Step Argument"; ShowConfirmationMessage: Boolean);
    VAR
        SentForApprovalEventID: Integer;
        SetStatusToPendingApprovalResponseID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        RestrictRecordUsageResponseID: Integer;
        AllowRecordUsageResponseID: Integer;
        OpenDocumentResponceID: Integer;
        ShowMessageResponseID: Integer;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ApprovalRequestCanceledMsg: label 'ENU=The approval request for the record has been canceled.';
        WorkFlowSetup: Codeunit "Workflow Setup";
    begin
        SentForApprovalEventID := WorkFlowSetup.InsertEntryPointEventStep(Workflow, DocSendForApprovalEventCode);
        WorkFlowSetup.InsertEventArgument(SentForApprovalEventID, DocSendForApprovalConditionString);
        RestrictRecordUsageResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.RestrictRecordUsageCode,
            SentForApprovalEventID);
        SetStatusToPendingApprovalResponseID := WorkFlowSetup.InsertResponseStep(Workflow, TrainingSetStatusToPendingApprovalCode,
            RestrictRecordUsageResponseID);
        CreateApprovalRequestResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.CreateApprovalRequestsCode,
            SetStatusToPendingApprovalResponseID);
        WorkFlowSetup.InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type", WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code", WorkflowStepArgument."Approver User ID", WorkflowStepArgument."Due Date Formula", ShowConfirmationMessage);
        SendApprovalRequestResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        WorkFlowSetup.InsertNotificationArgument(SendApprovalRequestResponseID, false, '', 0, '');
        OnAllRequestsApprovedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnAllRequestsApprovedEventID, WorkFlowSetup.BuildNoPendingApprovalsConditions);
        AllowRecordUsageResponseID :=
          WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode, OnAllRequestsApprovedEventID);
        WorkFlowSetup.InsertResponseStep(Workflow, TrainingReleaseDocumentCode, AllowRecordUsageResponseID);
        OnRequestApprovedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnRequestApprovedEventID, WorkFlowSetup.BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);
        WorkFlowSetup.SetNextStep(Workflow, SendApprovalRequestResponseID2, SendApprovalRequestResponseID);
        OnRequestRejectedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            OnRequestRejectedEventID);
        WorkFlowSetup.InsertNotificationArgument(RejectAllApprovalsResponseID, false, '', WorkflowStepArgument."Link Target Page", '');
        WorkFlowSetup.InsertResponseStep(Workflow, TrainingOpenDocumentCode, RejectAllApprovalsResponseID);
        OnRequestCanceledEventID := WorkFlowSetup.InsertEventStep(Workflow, DocCanceledEventCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnRequestCanceledEventID, DocCanceledConditionString);
        CancelAllApprovalsResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.CancelAllApprovalRequestsCode,
            OnRequestCanceledEventID);
        WorkFlowSetup.InsertNotificationArgument(CancelAllApprovalsResponseID, false, '', WorkflowStepArgument."Link Target Page", '');
        AllowRecordUsageResponseID :=
          WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode, CancelAllApprovalsResponseID);
        OpenDocumentResponceID := WorkFlowSetup.InsertResponseStep(Workflow, TrainingOpenDocumentCode, AllowRecordUsageResponseID);//pram
        ShowMessageResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.ShowMessageCode, OpenDocumentResponceID);
        WorkFlowSetup.InsertMessageArgument(ShowMessageResponseID, ApprovalRequestCanceledMsg);
        OnRequestDelegatedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);
        WorkFlowSetup.SetNextStep(Workflow, SentApprovalRequestResponseID3, SendApprovalRequestResponseID);
    end;

    procedure InsertVacancyDocApprovalWorkflowSteps(Workflow: Record Workflow; DocSendForApprovalConditionString: Text; DocSendForApprovalEventCode: Code[128]; DocCanceledConditionString: Text; DocCanceledEventCode: Code[128]; WorkflowStepArgument: Record 1523; ShowConfirmationMessage: Boolean);
    VAR
        SentForApprovalEventID: Integer;
        SetStatusToPendingApprovalResponseID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        RestrictRecordUsageResponseID: Integer;
        AllowRecordUsageResponseID: Integer;
        OpenDocumentResponceID: Integer;
        ShowMessageResponseID: Integer;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ApprovalRequestCanceledMsg: label 'ENU=The approval request for the record has been canceled.';
        WorkFlowSetup: Codeunit "Workflow Setup";
    begin
        SentForApprovalEventID := WorkFlowSetup.InsertEntryPointEventStep(Workflow, DocSendForApprovalEventCode);
        WorkFlowSetup.InsertEventArgument(SentForApprovalEventID, DocSendForApprovalConditionString);
        RestrictRecordUsageResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.RestrictRecordUsageCode,
            SentForApprovalEventID);
        SetStatusToPendingApprovalResponseID := WorkFlowSetup.InsertResponseStep(Workflow, VacancySetStatusToPendingApprovalCode,
            RestrictRecordUsageResponseID);
        CreateApprovalRequestResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.CreateApprovalRequestsCode,
            SetStatusToPendingApprovalResponseID);
        WorkFlowSetup.InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type", WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code", WorkflowStepArgument."Approver User ID", WorkflowStepArgument."Due Date Formula", ShowConfirmationMessage);
        SendApprovalRequestResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        WorkFlowSetup.InsertNotificationArgument(SendApprovalRequestResponseID, false, '', 0, '');
        OnAllRequestsApprovedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnAllRequestsApprovedEventID, WorkFlowSetup.BuildNoPendingApprovalsConditions);
        AllowRecordUsageResponseID :=
          WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode, OnAllRequestsApprovedEventID);
        WorkFlowSetup.InsertResponseStep(Workflow, VacancyReleaseDocumentCode, AllowRecordUsageResponseID);
        OnRequestApprovedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnRequestApprovedEventID, WorkFlowSetup.BuildPendingApprovalsConditions);
        SendApprovalRequestResponseID2 := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestApprovedEventID);
        WorkFlowSetup.SetNextStep(Workflow, SendApprovalRequestResponseID2, SendApprovalRequestResponseID);
        OnRequestRejectedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.RejectAllApprovalRequestsCode,
            OnRequestRejectedEventID);
        WorkFlowSetup.InsertNotificationArgument(RejectAllApprovalsResponseID, false, '', WorkflowStepArgument."Link Target Page", '');
        WorkFlowSetup.InsertResponseStep(Workflow, VacancyOpenDocumentCode, RejectAllApprovalsResponseID);
        OnRequestCanceledEventID := WorkFlowSetup.InsertEventStep(Workflow, DocCanceledEventCode,
            SendApprovalRequestResponseID);
        WorkFlowSetup.InsertEventArgument(OnRequestCanceledEventID, DocCanceledConditionString);
        CancelAllApprovalsResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.CancelAllApprovalRequestsCode,
            OnRequestCanceledEventID);
        WorkFlowSetup.InsertNotificationArgument(CancelAllApprovalsResponseID, false, '', WorkflowStepArgument."Link Target Page", '');
        AllowRecordUsageResponseID :=
          WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode, CancelAllApprovalsResponseID);
        OpenDocumentResponceID := WorkFlowSetup.InsertResponseStep(Workflow, VacancyOpenDocumentCode, AllowRecordUsageResponseID);//pram
        ShowMessageResponseID := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.ShowMessageCode, OpenDocumentResponceID);
        WorkFlowSetup.InsertMessageArgument(ShowMessageResponseID, ApprovalRequestCanceledMsg);
        OnRequestDelegatedEventID := WorkFlowSetup.InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := WorkFlowSetup.InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
            OnRequestDelegatedEventID);
        WorkFlowSetup.SetNextStep(Workflow, SentApprovalRequestResponseID3, SendApprovalRequestResponseID);
    end;

    procedure CheckDateStatus(CalendarCode: Code[20];
                                TargetDate: Date;
                                VAR Description: Text[50];
                                VAR Proviences: Text[150];
                                VAR Gender: Enum "Employee Gender";
                                VAR InOutValley: Enum "Outside/Inside Valley";
                                VAR PostingRegion: enum Region;
                                VAR Branch: Text;
                                VAR Distict: Text;
                                var Municipality: text;
                                var Community: Enum "Community Type";
                                var EmployeeFilter: Text;
                                var Disabled: Boolean): Boolean
    var
        BaseCalChange: Record "Base Calendar Change";
    begin
        BaseCalChange.Reset;
        BaseCalChange.SetRange("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FindSet() THEN
            repeat
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN begin
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";
                            Branch := BaseCalChange."Branch Code";
                            Distict := BaseCalChange.District;
                            Municipality := BaseCalChange.Municipality;
                            Community := BaseCalChange.Community;
                            EmployeeFilter := BaseCalChange.Employee;
                            Disabled := BaseCalChange.Disabled;
                            exit(BaseCalChange.Nonworking);
                        end;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN begin
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";
                            Branch := BaseCalChange."Branch Code";
                            Distict := BaseCalChange.District;
                            Municipality := BaseCalChange.Municipality;
                            Community := BaseCalChange.Community;
                            EmployeeFilter := BaseCalChange.Employee;
                            Disabled := BaseCalChange.Disabled;
                            exit(BaseCalChange.Nonworking);
                        end;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN begin
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";
                            Branch := BaseCalChange."Branch Code";
                            Distict := BaseCalChange.District;
                            Municipality := BaseCalChange.Municipality;
                            Community := BaseCalChange.Community;
                            EmployeeFilter := BaseCalChange.Employee;
                            Disabled := BaseCalChange.Disabled;
                            exit(BaseCalChange.Nonworking);
                        end;
                end;
            until BaseCalChange.NEXT = 0;
        Description := '';
        Proviences := '';
        clear(Gender);
        clear(InOutValley);
        clear(PostingRegion);
        clear(Branch);
        Clear(Distict);
        Clear(Community);
        Clear(Disabled);
    end;

    procedure CheckSaturday(CheckDate: Date; CalCode: Code[10]): Boolean
    var
        BaseCalendarChange: Record "Base Calendar Change";
    begin
        BaseCalendarChange.Reset();
        BaseCalendarChange.SetRange("Base Calendar Code", CalCode);
        BaseCalendarChange.SetRange("Recurring System", BaseCalendarChange."Recurring System"::"Weekly Recurring");
        if BaseCalendarChange.FindFirst() then begin
            if Date2DWY(CheckDate, 1) = BaseCalendarChange.Day then
                exit(BaseCalendarChange.Nonworking);
        end;
    end;

    procedure GenerateActualMatrixData(VAR RecRef: RecordRef; SetWanted: Option; MaximumSetLength: Integer; CaptionFieldNo: Integer; VAR RecordPosition: Text; VAR CaptionSet: ARRAY[32] OF Text[80]; VAR CaptionRange: Text; VAR CurrSetLength: Integer; VAR DescCaptionSet: ARRAY[32] OF Text; DescCaptionFieldNo: Integer; ShowCaption: Boolean);
    VAR
        Steps: Integer;
        Caption: Text;
        MaxCaptionLength: Integer;
    begin
        clear(CaptionSet);
        clear(DescCaptionSet);
        CaptionRange := '';
        CurrSetLength := 0;
        IF RecRef.ISEMPTY THEN begin
            RecordPosition := '';
            exit;
        end;
        CASE SetWanted OF
            SetOption::Initial:
                RecRef.FindFirst();
            SetOption::Previous:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    Steps := RecRef.NEXT(-MaximumSetLength);
                    IF NOT (Steps IN [-MaximumSetLength, 0]) THEN
                        ERROR(Text001);
                end;
            SetOption::Same:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                end;
            SetOption::Next:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    IF NOT (RecRef.NEXT(MaximumSetLength) = MaximumSetLength) THEN begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    end;
                end;
            SetOption::PreviousColumn:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    Steps := RecRef.NEXT(-1);
                    IF NOT (Steps IN [-1, 0]) THEN
                        ERROR(Text001);
                end;
            SetOption::NextColumn:
                begin
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    IF NOT (RecRef.NEXT(1) = 1) THEN begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    end;
                end;
        end;
        RecordPosition := RecRef.GETPOSITION;
        repeat
            CurrSetLength := CurrSetLength + 1;
            Caption := FORMAT(RecRef.FIELD(CaptionFieldNo).VALUE);
            MaxCaptionLength := MAXSTRLEN(CaptionSet[CurrSetLength]);
            IF STRLEN(Caption) <= MaxCaptionLength THEN
                CaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength)
            ELSE
                CaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength - 3) + '...';
        until (CurrSetLength = MaximumSetLength) OR (RecRef.NEXT <> 1);
        IF CurrSetLength = 1 THEN
            CaptionRange := CaptionSet[1]
        ELSE
            CaptionRange := CaptionSet[1] + '..' + CaptionSet[CurrSetLength];
        IF ShowCaption THEN begin
            IF RecRef.ISEMPTY THEN begin
                RecordPosition := '';
                exit;
            end;
            CASE SetWanted OF
                SetOption::Initial:
                    RecRef.FindFirst();
                SetOption::Previous:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        Steps := RecRef.NEXT(-MaximumSetLength);
                        IF NOT (Steps IN [-MaximumSetLength, 0]) THEN
                            ERROR(Text001);
                    end;
                SetOption::Same:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    end;
                SetOption::Next:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        IF NOT (RecRef.NEXT(MaximumSetLength) = MaximumSetLength) THEN begin
                            RecRef.SETPOSITION(RecordPosition);
                            RecRef.GET(RecRef.RECORDID);
                        end;
                    end;
                SetOption::PreviousColumn:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        Steps := RecRef.NEXT(-1);
                        IF NOT (Steps IN [-1, 0]) THEN
                            ERROR(Text001);
                    end;
                SetOption::NextColumn:
                    begin
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        IF NOT (RecRef.NEXT(1) = 1) THEN begin
                            RecRef.SETPOSITION(RecordPosition);
                            RecRef.GET(RecRef.RECORDID);
                        end;
                    end;
            end;
            RecordPosition := RecRef.GETPOSITION;
            CurrSetLength := 0;
            repeat
                CurrSetLength := CurrSetLength + 1;
                Caption := FORMAT(RecRef.FIELD(DescCaptionFieldNo).VALUE);
                MaxCaptionLength := MAXSTRLEN(CaptionSet[CurrSetLength]);
                IF STRLEN(Caption) <= MaxCaptionLength THEN
                    DescCaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength)
                ELSE
                    DescCaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength - 3) + '...';
            until (CurrSetLength = MaximumSetLength) OR (RecRef.NEXT <> 1);
            IF CurrSetLength = 1 THEN
                CaptionRange := DescCaptionSet[1]
            ELSE
                CaptionRange := DescCaptionSet[1] + '..' + DescCaptionSet[CurrSetLength];
        end;
    end;

    procedure InitNoSeriesNew(SetupNoSeries: Code[20]; xRecNoSeries: Code[20]; DocDate: Date; var DocNo: Code[20]; var RecNoSeries: Code[20])
    var
        NoSeries: Codeunit "No. Series";
    begin
        If NoSeries.AreRelated(SetupNoSeries, xRecNoSeries) then
            RecNoSeries := xRecNoSeries
        else
            RecNoSeries := SetupNoSeries;
        DocNo := NoSeries.PeekNextNo(RecNoSeries, DocDate)
    end;

    procedure SetDefaultSeries(var NewNoSeriesCode: Code[20]; NoSeriesCode: Code[20])
    var
        GlobalNoSeries: record "No. Series";
    begin
        if NoSeriesCode <> '' then begin
            GlobalNoSeries.Get(NoSeriesCode);
            if GlobalNoSeries."Default Nos." then
                NewNoSeriesCode := GlobalNoSeries.Code;
        end;
    end;

    procedure getServicePeriodText(var Employee: Record Employee)
    var
        NewEmploymentDate: Date;
        LastDate: Date;
    begin
        if Employee."Employment Date" <> 0D then begin
            NewEmploymentDate := GetAdjustedEmploymentDate(Employee, Employee."Employment Date", Today);
            HRSetup.Get();
            LastDate := Employee."Termination Date";
            if Employee."Resignation Date" <> 0D then
                LastDate := Employee."Resignation Date";
            if HRSetup."Service Day without Last Date" then begin
                if LastDate <> 0D then
                    LastDate := LastDate - 1
                else
                    LastDate := Today - 1;
            end ELSE begin
                LastDate := Today;
            end;
            if HRSetup."Calculate Age using Nepali C." then begin
                Employee."Service Period text" := GetAgeBs(EngNep.getNepaliDate(NewEmploymentDate), EngNep.getNepaliDate(LastDate))
            end
            else begin
                if LastDate <> 0D then
                    Employee."Service Period text" := GetAge(NewEmploymentDate, LastDate);
            end;
        end;
    end;

    procedure GetAdjustedEmploymentDate(Employee: Record Employee; EmplymentDate: Date; EndDate: Date): Date
    var
        AdjustingDays: Integer;
        EmployeeInactiveLine: Record "Service Inactivity Ledger";
        NewEmploymentDate: Date;
        PreviousPeriod: DateFormula;
    begin
        AdjustingDays := 0;
        if EmplymentDate <> 0D then begin
            NewEmploymentDate := EmplymentDate;
            EmployeeInactiveLine.Reset();
            EmployeeInactiveLine.SetRange("Employee No.", Employee."No.");
            EmployeeInactiveLine.SetRange("Start Date", EmplymentDate, EndDate);
            if EmployeeInactiveLine.FindSet() then
                repeat
                    if not EmployeeInactiveLine."Counted In Service Period" then
                        if EmployeeInactiveLine."End Date" <> 0D then
                            AdjustingDays += EmployeeInactiveLine."End Date" - EmployeeInactiveLine."Start Date" + 1
                        else
                            AdjustingDays += WorkDate() - EmployeeInactiveLine."Start Date" + 1;
                until EmployeeInactiveLine.Next() = 0;
            NewEmploymentDate := NewEmploymentDate + AdjustingDays;
            //if there is previous service period add code hhere accordingly
            exit(NewEmploymentDate);
        end;
    end;

    procedure GetAge(BirthDate: Date; ToDate: Date) Age: Text
    var
        Year, Month, Days : Integer;
        YearText, MonthText, DayText, ReturnValue : Text;
    begin
        if ToDate < BirthDate then
            exit('-');
        GetAgeInteger(BirthDate, ToDate, Year, Month, Days);
        if Year = 1 then
            YearText := ' year'
        else
            YearText := ' years';
        if Month = 1 then
            MonthText := ' month'
        else
            MonthText := ' months';
        if Days = 1 then
            DayText := ' day'
        else
            DayText := ' days';
        Clear(ReturnValue);
        if Year > 0 then
            ReturnValue := Format(Year) + YearText + ' ';
        if Month > 0 then
            ReturnValue += Format(Month) + MonthText + ' ';
        if Days > 0 then
            ReturnValue += Format(Days) + DayText;
        exit(ReturnValue);
    end;

    procedure GetAgeInteger(BirthDate: Date; ToDate: Date; var year: Integer; var Month: Integer; var Days: Integer)
    begin
        year := Date2DMY(ToDate, 3) - Date2DMY(BirthDate, 3);
        Month := Date2DMY(ToDate, 2) - Date2DMY(BirthDate, 2);        //Total Service = Employment date - Today's date
        Days := Date2DMY(ToDate, 1) - Date2DMY(BirthDate, 1) + 1;  // include today
        if Days < 0 then begin
            Month := Month - 1;
            Days := Date2DMY(CalcDate('<CM>', BirthDate), 1) - Abs(Days);
        end;
        if Month < 0 then begin
            year := year - 1;
            Month := 12 - Abs(Month);
        end;
    end;

    procedure GetNextEntryNo(TableID: Integer): Integer
    var
        RecRef: RecordRef;
        FieldRefs: FieldRef;
        KeyRefs: KeyRef;
        NextEntryNo: Integer;
        PkIndex: Integer;
    begin
        NextEntryNo := 0;
        RecRef.Open(TableID);
        //check primary key is integer or not
        KeyRefs := RecRef.KeyIndex(1);
        FieldRefs := KeyRefs.FieldIndex(1);
        PkIndex := FieldRefs.Number; //Field number pf PK field
        if FieldRefs.Type <> FieldRefs.Type::Integer then
            Error('Invalid pk type');
        if RecRef.FindLast() then begin
            FieldRefs := RecRef.Field(PkIndex);
            NextEntryNo := FieldRefs.Value;
        end;
        exit(NextEntryNo + 1);
    end;

    procedure GetAgeBS(BirthDate: Code[20]; ToDate: Code[20]) Age: Text
    var
        Year, Month, Days : Integer;
        YearText, MonthText, DayText, ReturnValue : Text;
    begin
        if EngNep.getEngDate(ToDate) < EngNep.getEngDate(BirthDate) then
            exit('-');
        GetAgeIntegerBS(BirthDate, ToDate, Year, Month, Days);
        if Year = 1 then
            YearText := ' year'
        else
            YearText := ' years';
        if Month = 1 then
            MonthText := ' month'
        else
            MonthText := ' months';
        if Days = 1 then
            DayText := ' day'
        else
            DayText := ' days';
        Clear(ReturnValue);
        if Year > 0 then
            ReturnValue := Format(Year) + YearText + ' ';
        if Month > 0 then
            ReturnValue += Format(Month) + MonthText + ' ';
        if Days > 0 then
            ReturnValue += Format(Days) + DayText;
        exit(ReturnValue);
    end;

    procedure GetAgeIntegerBS(BirthDate: Code[20]; ToDate: Code[20]; var year: Integer; var Month: Integer; var Days: Integer)
    var
        EngNep: Record "English-Nepali Date";
        EngNep2: Record "English-Nepali Date";
    begin
        EngNep.SetRange("Nepali Date", BirthDate);
        if EngNep.FindFirst() then begin
            EngNep2.SetRange("Nepali Date", ToDate);
            if EngNep2.FindFirst() then begin
                year := EngNep2."Nepali year" - EngNep."Nepali Year";
                Month := EngNep2."Nepali Month".AsInteger() - EngNep."Nepali Month".AsInteger();
                Days := EngNep2."Nepali Day" - EngNep."Nepali Day" + 1;
            end;
        end;
        if Days < 0 then begin
            Month := Month - 1;
            Days := GetMonthEndDayNepali(EngNep2."Nepali Year", EngNep2."Nepali Month".AsInteger() - 1) - Abs(Days);
        end;
        if Month < 0 then begin
            year := year - 1;
            Month := 12 - Abs(Month);
        end;
    end;

    procedure GetMonthEndDayNepali(NepaliYear: Integer; NepaliMonth: Integer): Integer
    var
        EngNep2: Record "English-Nepali Date";
    begin
        EngNep2.SetRange("Nepali Year", NepaliYear);
        EngNep2.SetRange("Nepali Month", NepaliMonth);
        if EngNep2.findlast() then
            exit(EngNep2."Nepali Day");
    end;

    procedure GetLastPayDate(): Date
    var
        PayCyclePeriod: Record "Pay Cycle Period";
        PGSetUp: Record "Payroll General Setup";
    begin
        PGSetUp.Get();
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetFilter("Pay Cycle Code", PGSetUp."Pay Cycle Code");
        PayCyclePeriod.SetFilter("Pay Cycle Term", PGSetUp."Pay Cycle Term");
        PayCyclePeriod.SetRange(Posted, true);
        PayCyclePeriod.Findlast();
        exit(PayCyclePeriod."Pay Date");
    end;

    procedure GetPayCyclePeriod(StartDate: Date; Var PayCyclePeriod: Record "Pay Cycle Period"): Integer
    var
        PGSetUp: Record "Payroll General Setup";
    begin
        PGSetUp.Get();
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Term", PGSetUp."Pay Cycle Term");
        PayCyclePeriod.SetRange("Pay Cycle Code", PGSetUp."Pay Cycle Code");
        PayCyclePeriod.SetFilter("Start Date", '<=%1', StartDate);
        PayCyclePeriod.SetFilter("End Date", '>=%1', StartDate);
        PayCyclePeriod.FindFirst;
        exit(PayCyclePeriod.Period);
    end;


    procedure IsSaaS(): Boolean
    var
        EnvInfo: Codeunit "Environment Information";
    Begin
        exit(EnvInfo.IsSaaS());
    End;

    procedure CreateEmpActLedger(EmpActType: Enum "Employee Activity Type";
                                                 DocNo: Code[20];
                                                 EmpNo: Code[20];
                                                 ActDate: Date;
                                                 Cancelled: Boolean;
                                                 Days: Decimal)
    var
        EmpActLedgerEntry: Record "Emp. Act. Ledger Entry";
        Leave: Record Leave;
    begin
        if EmpActLedgerEntry.Get(EmpActType, DocNo, EmpNo, ActDate, Cancelled) then
            exit;
        EmpActLedgerEntry.init();
        EmpActLedgerEntry."Document Type" := EmpActType;
        EmpActLedgerEntry."Document No." := DocNo;
        EmpActLedgerEntry.Validate("Employee No.", EmpNo);
        EmpActLedgerEntry."Event Date" := ActDate;
        EmpActLedgerEntry."Cancellation Entry" := Cancelled;
        if Cancelled then
            EmpActLedgerEntry.Day := -Days
        else
            EmpActLedgerEntry.Day := Days;
        if EmpActType = EmpActType::"Leave Request" then
            if Leave.Get(DocNo) then begin
                EmpActLedgerEntry."Leave Type" := Leave."Leave Type";
                EmpActLedgerEntry."Leave Code" := Leave."Leave Code";
            end;
        OnBeforeInsertEmpActLedger(EmpActType, DocNo, EmpNo, ActDate, EmpActLedgerEntry);
        EmpActLedgerEntry.insert();
    end;

    procedure CancelEmpActLedgerForDateRange(EmpActType: Enum "Employee Activity Type";
                                                             DocNo: Code[20];
                                                             EmpNo: Code[20];
                                                             StartDate: Date;
                                                             EndDate: Date)
    var
        EmpActLedgerEntry: Record "Emp. Act. Ledger Entry";
        DateVar: Record Date;
    begin
        DateVar.SetRange("Period Type", DateVar."Period Type"::Date);
        DateVar.SetRange("Period Start", StartDate, EndDate);
        if DateVar.FindSet() then
            repeat
                Clear(EmpActLedgerEntry);
                if EmpActLedgerEntry.Get(EmpActType, DocNo, EmpNo, DateVar."Period Start", false) then
                    EmpActLedgerEntry.Rename(EmpActType, DocNo, EmpNo, DateVar."Period Start", true);
            until DateVar.Next() = 0;
    end;

    procedure CreateEmpActLedgerForDateRange(
                                    EmpActType: Enum "Employee Activity Type";
                                                    DocNo: Code[20];
                                                    EmpNo: Code[20];
                                                    StartDate: Date;
                                                    EndDate: Date)
    var
        DateRec: Record Date;
    begin
        DateRec.SetRange("Period Type", DateRec."Period Type"::Date);
        DateRec.SetRange("Period Start", StartDate, EndDate);
        if DateRec.FindSet() then
            repeat
                CreateEmpActLedger(
                    EmpActType,
                    DocNo,
                    EmpNo,
                    DateRec."Period Start",
                    false,
                    1
                );
            until DateRec.Next() = 0;
    end;

    procedure GetCompanyOneLineAddress(var CompanyName: Text[100]; var CompanyOneLineAddress: Text[250]; var CompanyCommunicationAddress: Text[250])
    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
    begin
        CompanyInfo.Get();
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyAddr[1] := CompanyInfo.Name;
        CompanyName := CompanyAddr[1];
        if CompanyInfo."Phone No." <> '' then
            CompanyOneLineAddress := OneLineAddress(CompanyAddr) + ', ' + CompanyInfo.FieldCaption("Phone No.") + ' : ' + CompanyInfo."Phone No."
        else
            CompanyOneLineAddress := OneLineAddress(CompanyAddr);
        if CompanyInfo."Fax No." <> '' then
            CompanyCommunicationAddress := CompanyInfo.FieldCaption("Fax No.") + ' : ' + CompanyInfo."Fax No.";
        if CompanyInfo."E-Mail" <> '' then begin
            if (CompanyCommunicationAddress <> '') then
                CompanyCommunicationAddress += ', ' + CompanyInfo.FieldCaption("E-Mail") + ' : ' + CompanyInfo."E-Mail"
            else
                CompanyCommunicationAddress += CompanyInfo.FieldCaption("E-Mail") + ' : ' + CompanyInfo."E-Mail";
        end;
    end;

    local procedure OneLineAddress(var AddrArray: array[8] of Text[50]) OneLineAddress: Text
    var
        i: Integer;
    begin
        CompressArray(AddrArray);
        for i := 2 to ArrayLen(AddrArray) do begin
            if AddrArray[i] <> '' then
                if OneLineAddress = '' then
                    OneLineAddress += AddrArray[i]
                else
                    OneLineAddress += ', ' + AddrArray[i];
        end;
        exit(OneLineAddress);
    end;

    procedure LookupEmployeeByOrgStructure(ProvinceCode: Code[20]; BranchCode: Code[20]; DepartmentCode: Code[20]; UnitCode: Code[20]; EmpCode: Code[20]): Code[20]
    var
        EmployeeRec: Record Employee;
        EmployeeListPage: Page "Employee List";
    begin
        if EmpCode <> '' then
            EmployeeRec.SetRange("No.", EmpCode);
        if ProvinceCode <> '' then
            EmployeeRec.SetRange("Province Code", ProvinceCode);
        if BranchCode <> '' then
            EmployeeRec.SetRange("Branch Code", BranchCode);
        if DepartmentCode <> '' then
            EmployeeRec.SetRange("Department Code", DepartmentCode);
        if UnitCode <> '' then
            EmployeeRec.SetRange("Unit Code", UnitCode);
        EmployeeRec.SetRange(Status, EmployeeRec.Status::Active);

        EmployeeListPage.LookupMode(true);
        EmployeeListPage.SetTableView(EmployeeRec);
        if EmployeeListPage.RunModal() = ACTION::LookupOK then begin
            EmployeeListPage.GetRecord(EmployeeRec);
            exit(EmployeeRec."No.");
        end;
    end;

    procedure AssignEmployeeSeniority()
    var
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
        EmployeeCount: Integer;
    begin
        SalaryLevel.Reset();
        SalaryLevel.SetFilter(Rank, '>%1', 0);
        if SalaryLevel.FindSet() then
            repeat

                EmployeeCount := 0;
                SalaryLevel.TestField(Rank);

                Employee.Reset();
                Employee.SetCurrentKey("Employment Date");
                Employee.SetRange("Salary Level", SalaryLevel.Code);
                Employee.SetRange(Status, Employee.Status::Active);
                Employee.SetAscending("Employment Date", false);
                if Employee.FindSet() then
                    repeat
                        EmployeeCount += 1;
                        Employee.Seniority := SalaryLevel.Rank * 1000 + EmployeeCount;
                        Employee.Modify();
                    until Employee.Next() = 0;

            until SalaryLevel.Next() = 0;
    end;
    //Appraisal Changes
    procedure ReturnEndDateFY(FiscalYear: Text) EndDateFY: Date
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Term", FiscalYear);
        PayCyclePeriod.SetCurrentKey("End Date");
        if PayCyclePeriod.FindLast then
            exit(PayCyclePeriod."End Date");
    end;

    procedure IsHRApprover(EmployeeNo: Code[20]): Boolean
    var
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
    begin
        if not HRSetup.Get() then
            exit(false);
        if not Employee.Get(EmployeeNo) then
            exit(false);
        if HRSetup."HR Department Code" <> '' then begin
            if HRSetup."HR Head Functional Title" = '' then begin
                if Employee."Department Code" = HRSetup."HR Department Code" then
                    exit(true);
            end else begin
                if (Employee."Functional Title" = HRSetup."HR Head Functional Title") and
                   (Employee."Department Code" = HRSetup."HR Department Code") then
                    exit(true);
            end;
        end;
        exit(false);
    end;

    procedure CheckforFiscalYearcontrol(IncomingDate: Date)
    var
        IsHandled: Boolean;
    begin
        OnBeforeCheckFiscalYearControl(IncomingDate, IsHandled);
        if IsHandled then
            exit;
        PayrollSetup.Get();
        if IncomingDate < PayrollSetup."Payroll Fiscal Year Start Date" then
            Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
    end;

    [IntegrationEvent(false, false)]
    local procedure CheckForSkipMail(Employee: Record Employee; var IsHandled: Boolean);
    begin
        //Can be Used to skp mail for paticular employee
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertEmpActLedger(EmpActType: Enum "Employee Activity Type"; DocNo: Code[20];
                                                               EmpNo: Code[20];
                                                               ActDate: Date; var EmpActLedgerEntry: Record "Emp. Act. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateEmailFromTemplate(var TableNo: Integer; var DocumentType: enum "Employee Activity Type";
                              var ApprovalStatus: Enum "approval status";
                              var EmployeeNo: Text;
                              var DocumentNo: Code[20];
                              var Cancelled: Boolean;
                              var IsHandled: Boolean);
    begin
        //Can be used to changes or modify any paramater before Create Email From Template
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckFiscalYearControl(IncomingDate: Date; var IsHandled: Boolean);
    begin
        //Can be Used to skp Fiscal year control on request
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertOfPayrollAttributeUsage(EmployeeNo: Code[20]; var IsHandled: Boolean);
    begin
        //To make specific checks before inserting Attributes in Attribute Usage.
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterWorkStation(Employee: Record Employee; WorkSation: Text);
    begin
        //Can be used to get Work Sation of Employee;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCalculationOfAcutalOrProjectedContribution(var RetirementFund: Record "Retirement Fund");
    begin
        //To add additional contribution if any
    end;
}
