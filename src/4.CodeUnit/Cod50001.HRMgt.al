codeunit 50001 "HR Mgt."
{
    // //Min 1.2 -- Added ServiceEvent Parameter Option String of AddtoServiceHistory function same as ServiceEvent option of Employee Activity table.
    // //Min 1.1 >> -- Commented,No Need to update information in its employee card and "Employee Service history" Table during Acknowledge -- as per "Tulasi" Didi.
    // //Min 1.4 >> -- Update in Employee Card and "Employee Service history" Table during Approved -- as per "Tulasi" Didi.
    // //Min 1.4 >> -- Issues occurred in earlier approved document, so commented later and update data via "Daily Attendance update" Report Job Queue.
    // //Min 4.11.2022 -- For Donot allow to leave request in Present Day.
    // //Min 4.27.2022 -- For Update Transfer Effective Date in Portal DB Employee Table.
    // //Min 4.28.2022 -- Regination Submit Email Send.
    // //Min 6.9.2022 -- Commented for no need to apply condition in Retirement Fund Screen
    // //Min 9.15.2022 -- 1) Prov. Wise Email Send to HR Team. 2) Skip CC email for Doc.Type :: Transfer.
    // //Min 10.13.2022 -- For restriction multiple time leave cancel of same document.
    // //Abhiral 12.20.2022 -- Resignation Rejection Email Send.

    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd;

    trigger OnRun()
    var
        texttest: BigText;
        Candidate: Record Candidate;
    begin
        //CreateHR;
        //ValidatePayrollcomponent;
        //ClearComponent;
        //UpdateDimension;
        //updatedaymonth;
        //printsalaryslipweb(5,FALSE,'EMP00002',texttest);
        //GetEmployeePictureweb('EMP00001',texttest);
        //MESSAGE(FORMAT(texttest));
        //InsertWorkflowCategory(VacancyDocCategoryTxt,CustVacancyCategoryDescTxt);
        //InsertVacancyApprovalWorkflowTemplate;
        //InsertWorkflowCategory(TrainingDocCategoryTxt,CustTrainingCategoryDescTxt);
        //InsertTrainingApprovalWorkflowTemplate
        //InsertWorkflowCategory(FacilitatorDocCategoryTxt,CustFacilitatorCategoryDescTxt);
        //InsertFacilitatorApprovalWorkflowTemplate;
        //CheckOvertimeEligibility(TODAY,'EMP-008',TRUE,FALSE);
    end;

    var
        HrPermission: Record "Rolewise Job Description";
        // SMTPMail: Codeunit "SMTP Mail"; todo
        // SMTPSetup: Record "SMTP Mail Setup";
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
        // "---------------------": ;
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
        // "------------------------": ;
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
        // SQLConnection: DotNet SqlConnection;
        // SQLCommand: DotNet SqlCommand;
        // SQLParameter: DotNet SqlParameter;
        // SQLDataReader: DotNet SqlDataReader;
        SQLCommandType: Option StoredProcedure,TableDirect,Text;
        commandtext: Text;
        reader: Text;
        InputStream: InStream;
        SQLstr: Text;
        // "----------------------": ;
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
        if Candidate."Employee No." <> GetEmployeeNo then
            Error('You are not elgible to apply this candidate');
        Candidate.Validate(Status, Candidate.Status::Applied);
        Candidate.Modify;
    end;

    procedure UpdatePromotion(EmpNo: Code[20])
    var
        PromotionPageBuilder: FilterPageBuilder;
        PromotionHistory: Record "Promotion History";
        PromoHis: Record "Promotion History";
        LineNo: Integer;
        PromotedDate: Date;
        ServiceHistory: Record "Employee Service History";
        ServiceHistoryCode: Code[20];
        PreviousServiceHistory: Record "Employee Service History";
    begin
        Employee.Get(EmpNo);

        PromotionPageBuilder.AddRecord('Promote Employee', PromotionHistory);
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Salary Level Code");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Salary Grade");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Date");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory."Promoted Functional Title");
        PromotionPageBuilder.ADdField('Promote Employee', PromotionHistory.Remarks);  //Min

        if PromotionPageBuilder.RunModal then begin
            PromotionHistory.SetView(PromotionPageBuilder.GetView('Promote Employee'));

            PromoHis.Reset;
            PromoHis.SetRange("Employee No.", EmpNo);
            if PromoHis.FindLast then
                LineNo := PromoHis."Line No." + 10000
            else
                LineNo := 10000;

            Evaluate(PromotedDate, PromotionHistory.GetFilter("Promoted Date"));
            Clear(PromoHis);
            PromoHis.Init;
            PromoHis.Validate("Employee No.", EmpNo);
            PromoHis.Validate("Promoted Date", PromotedDate);
            PromoHis.Validate("Promoted Salary Level Code", PromotionHistory.GetFilter("Promoted Salary Level Code"));
            PromoHis.Validate("Promoted Salary Grade", PromotionHistory.GetFilter("Promoted Salary Grade"));
            PromoHis.Validate("Promoted Functional Title", PromotionHistory.GetFilter("Promoted Functional Title"));
            PromoHis.Validate(Remarks, PromotionHistory.GetFilter(Remarks)); //Min
            PromoHis.Validate("Line No.", LineNo);
            PromoHis.Insert(true);

            ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(EmpNo, ServiceHistory."Service Event"::"Internal Appointment", 'Promoted', PromotedDate);

            Employee.Validate("Salary Level", PromotionHistory.GetFilter("Promoted Salary Level Code"));
            Employee.Validate("Salary Grade", PromotionHistory.GetFilter("Promoted Salary Grade"));
            Employee.Validate("Functional Title", PromotionHistory.GetFilter("Promoted Functional Title"));
            Employee.Validate("Promotion Date", PromotedDate); //Min -- for update promotion date in employee table
            Employee.Modify;

            if ServiceHistory.Get(ServiceHistoryCode) then begin
                ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
                ServiceHistory.Validate("Salary Grade (To)", Employee."Salary Grade");
                ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
                ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
                ServiceHistory.Validate("Deputation Code (To)", ServiceHistoryMgt.ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate("Deputation Value (To)", ServiceHistoryMgt.ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
                ServiceHistory.Validate(Remarks, PromotionHistory.GetFilter(Remarks)); //Min
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
                    Appraisal.SetRange(Status, Appraisal.Status::Approved);
                    Appraisal.SetRange("Fiscal Year", ReturnFiscalYear(CalcDate('<-1Y>')));
                    if Appraisal.FindLast then begin
                        ServiceHistory.Reset;
                        ServiceHistory.SetRange("Employee No.", Employee."No.");
                        ServiceHistory.SetFilter("Service Event", '%1|%2', ServiceHistory."Service Event"::"Internal Appointment", ServiceHistory."Service Event"::Appointment);
                        ServiceHistory.SetRange("Salary Level (To)", Employee."Salary Level");
                        if ServiceHistory.FindFirst then begin
                            case Appraisal.Rating of
                                Appraisal.Rating::Excellent:
                                    begin
                                        if CalcDate(StrSubstNo('<%1Y>', HRSetup."Excellent Serivce Period"), ServiceHistory."Effective Date") <= VacancyHeader."Date of Request" then
                                            InsertPromotionCandidate(VacancyHeader);
                                    end;

                                Appraisal.Rating::"Very Good":
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
        EmpAct: Record "Employee Activity";
    begin
        VacancyHead.Get(VacancyNo);
        VacancyHead.TestField(Type, VacancyHead.Type::Internal);
        Employee.Get(CandidateNo);
        Candidate.Get(CandidateNo, VacancyNo);
        EmpAct.Reset;
        EmpAct.Init;
        EmpAct.Type := EmpAct.Type::Promotion;
        EmpAct.Validate("No.", Employee."No.");
        EmpAct.Validate("Employee Name", Employee."Full Name");
        EmpAct.Validate("Requested Date", Today);
        EmpAct.Validate("Functional Title", Employee."Functional Title");
        EmpAct.Validate("Salary Level Code", Employee."Salary Level");
        EmpAct.Validate("Salary Level Code(To)", Candidate."Applied Salary Level");
        EmpAct.Validate("Functional Title (To)", Candidate."Functional Title");
        EmpAct.Insert(true);
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
        NoMgt: Codeunit "NoSeriesManagement";
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
                            //VacaHeadaer.RESET;
                            //VacaHeadaer.SETRANGE("Memo No.","Memo No.");
                            //VacaHeadaer.SETRANGE("Salary Level Code",RecruitmentLine."Salary Level Code");
                            //IF VacaHeadaer.FINDFIRST THEN BEGIN
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

    procedure InterviewScheduleEmailToCandidate(VacancyCode: Code[20]; IsReschedule: Boolean)
    var
        Candidate: Record Candidate;
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        CodeunitEmailMessage: Codeunit "Email Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
        CCReceipientEmail: List of [Text];
        BCCReciepientEmail: List of [Text];
        Email: Codeunit Email;
    begin

        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        Candidate.Reset;
        Counter := 0;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        if IsReschedule then begin
            HRSetup.TestField("Reschedule Vacancy Mail Cand.");
            EmailTemplate.Get(HRSetup."Reschedule Vacancy Mail Cand.");
        end else begin
            HRSetup.TestField("Interview Schedule Candidate");
            EmailTemplate.Get(HRSetup."Interview Schedule Candidate");
        end;
        if Candidate.FindFirst then
            repeat

                Clear(Footer);
                Clear(Header);
                Clear(Body);
                // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
                CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate."Subject", '');
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
                CodeunitEmailMessage.AppendToBody(Body);
                CodeunitEmailMessage.AppendToBody('<br><br>');
                CodeunitEmailMessage.AppendToBody(Candidate.FieldCaption("Interview Date") + Colon + Format(Candidate."Interview Date"));
                CodeunitEmailMessage.AppendToBody(Candidate.FieldCaption("Interview Time") + Colon + Format(Candidate."Interview Time"));
                CodeunitEmailMessage.AppendToBody('<br><br>');
                CodeunitEmailMessage.AppendToBody(Footer);
                if Email.Send(CodeunitEmailMessage) then
                    Counter += 1;

            until Candidate.Next = 0;
        if Counter <> 0 then
            Message('Mail Sent');
    end;

    procedure CandidateListmailToInterviewer(VacancyCode: Code[20]; Reschedule: Boolean)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Interviewer: Record Interviewer;
        SendMailTo: Text;
        InterviewerEmail: Report "Interviewer Email";
        Filename: Text;
        VacancyHeader: Record "Vacancy Header";
        // FileMgt: Codeunit "File Management";
        Candidate: Record Candidate;
        OutStr: OutStream;
        InStr: InStream;
        TempBlob: Codeunit "Temp Blob";
        // tmpBlob: Codeunit "Temp Blob";
        recRef: RecordRef;
        format: ReportFormat;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        inStreamReport: InStream;

    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(inStreamReport);
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        VacancyHeader.Get(VacancyCode);

        Candidate.Reset;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        Candidate.SetRange(Status, Candidate.Status::"Interview Scheduled");
        //Filename:='C:\Business Central\Setup\interviewerlist.pdf';
        recRef.GetTable(Candidate);
        TempBlob.CreateOutStream(OutStr);
        Filename := VacancyCode + '.pdf';
        REPORT.SaveAs(REPORT::"Interviewer Email", '', format::Pdf, OutStr, recRef);

        Interviewer.Reset;
        Interviewer.SetRange("Vacancy Code", VacancyCode);

        if Interviewer.FindFirst then
            repeat
                if SendMailTo = '' then
                    SendMailTo += Interviewer."Interviewer Email"
                else
                    SendMailTo += ';' + Interviewer."Interviewer Email";
            until Interviewer.Next = 0;

        if Reschedule then begin
            HRSetup.TestField("ReSchedule Vancacy Mail Int.");
            EmailTemplate.Get(HRSetup."ReSchedule Vancacy Mail Int.");
        end else begin
            HRSetup.TestField("Interview Schedule Interviewer");
            EmailTemplate.Get(HRSetup."Interview Schedule Interviewer");
        end;
        Clear(Footer);
        Clear(Header);
        Clear(Body);
        // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", SendMailTo, EmailTemplate.Subject, '', true);
        CodeunitEmailMessage.Create(SendMailTo, EmailTemplate.Subject, '');
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
        CodeunitEmailMessage.AppendToBody(Body);
        CodeunitEmailMessage.AppendToBody('<br><br>');
        CodeunitEmailMessage.AppendToBody(Footer);
        TempBlob.CreateInStream(InStr);
        CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
        // SMTPMail.AddAttachment(Filename, 'interviewerlist');
        if Email.send(CodeunitEmailMessage) then
            Message('Successfully Sent')
        else
            Message('Not Sent');

        Clear(Filename);
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
        /* Candidate.RESET;
         Candidate.SETRANGE("Vacancy Code",VacancyCode);
         IF Candidate.FINDFIRST THEN
         REPEAT
         InterviewEvaluationEntry.RESET;
         //InterviewEvaluationEntry.SETRANGE("Vacancy Code",Candidate."Vacancy Code");
         InterviewEvaluationEntry.SETRANGE("No.",Candidate."No.");
         IF InterviewEvaluationEntry.FINDFIRST THEN
           REPEAT
             Interview1:=0;
             Interview2:=0;
             Interview3:=0;

             Interview1+=InterviewEvaluationEntry."Interviewer Code";
             Interview2+=InterviewEvaluationEntry."Interviewer Name";
             Interview3+=InterviewEvaluationEntry.Marks;
         UNTIL InterviewEvaluationEntry.NEXT =0;
         Candidate."Total Inverview Score":=Interview1+Interview2+Interview3;
         Candidate.MODIFY;
         UNTIL Candidate.NEXT =0;

         VacancyHeader.GET(VacancyCode);
        Candidate.RESET;
        Candidate.SETRANGE("Vacancy Code",VacancyCode);
        IF Candidate.FINDFIRST THEN
          FOR i:=1 TO VacancyHeader."No of Vacancy" DO BEGIN
            Candidate.Type:=Candidate.Type::"Final Selection";
            Candidate.MODIFY;
         END;*/

    end;

    procedure SendOfferLetter(VacancyCode: Code[20]; Candidate: Record Candidate)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Filename: Text;
        OfferLetter: Report "Offer Letter2";
        Cand: Record Candidate;
        tmpBlob: Codeunit "Temp Blob";
        recRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        format: ReportFormat;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        Clear(InStr);
        HRSetup.Get;
        //Candidate.RESET;
        //Candidate.SETRANGE("Vacancy Code",VacancyCode);
        //IF Candidate.GET(CandidateNo) THEN BEGIN
        //IF Candidate.FINDFIRST THEN BEGIN
        /*REPEAT
          IF SendMailTo='' THEN
          SendMailTo+=Interviewer."Interviewer Email"
          ELSE
            SendMailTo+=Interviewer."Interviewer Email"+';'
        UNTIL Interviewer.NEXT =0;
        */

        if EmailTemplate.Get(HRSetup."Offer Letter Sent") then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
            CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate.Subject, '');
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
            CodeunitEmailMessage.AppendToBody(Body);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);
            Filename := 'C:\Business Central\Setup\offerletter.pdf';
            Cand.Reset;
            Cand.SetRange("No.", Candidate."No.");
            recRef.GetTable(Candidate);
            tmpBlob.CreateOutStream(OutStr);
            REPORT.SaveAs(REPORT::"Offer Letter", '', format::Pdf, OutStr, recRef);
            tmpBlob.CreateInStream(InStr);
            CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
            //    OfferLetter.SAVEASPDF(Filename);
            // SMTPMail.AddAttachment(Filename, 'offerletter.pdf');
            if Email.send(CodeunitEmailMessage) then
                Message('Successfully Sent')
            else
                Message('Not Sent');
        end;
        //  END;

    end;

    procedure SendAppointmentLetter(VacancyCode: Code[20]; Candidate: Record Candidate)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Filename: Text;
        OfferLetter: Report "Offer Letter2";
        Cand: Record Candidate;
        tmpBlob: Codeunit "Temp Blob";
        recRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        format: ReportFormat;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        Clear(InStr);
        HRSetup.Get;
        //Candidate.RESET;
        //Candidate.SETRANGE("Vacancy Code",VacancyCode);
        //IF Candidate.GET(CandidateNo) THEN BEGIN
        //IF Candidate.FINDFIRST THEN BEGIN
        /*REPEAT
          IF SendMailTo='' THEN
          SendMailTo+=Interviewer."Interviewer Email"
          ELSE
            SendMailTo+=Interviewer."Interviewer Email"+';'
        UNTIL Interviewer.NEXT =0;
        */

        if EmailTemplate.Get(HRSetup."Appointment Letter Sent") then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
            CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate.Subject, '');
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
            CodeunitEmailMessage.AppendToBody(Body);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);
            Filename := 'C:\Business Central\Setup\appointmentletter.pdf';
            Cand.Reset;
            Cand.SetRange("No.", Candidate."No.");
            recRef.GetTable(Candidate);
            tmpBlob.CreateOutStream(OutStr);
            REPORT.SaveAs(REPORT::"Appointment Letter", '', format::Pdf, OutStr, recRef);
            tmpBlob.CreateInStream(InStr);
            CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
            //    OfferLetter.SAVEASPDF(Filename);
            // SMTPMail.AddAttachment(Filename, 'appointmentletter.pdf');
            if Email.Send(CodeunitEmailMessage) then
                Message('Successfully Sent')
            else
                Message('Not Sent');
        end;
        //  END;

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
                            EvaluationEntires.Validate(Name, Candidate."Full Name"); //Min 7.4.2022
                            EvaluationEntires.Validate(Marks, Candidate."Written Score"); //Min 7.6.2022
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
                            EvaluationEntires.Validate(Name, Candidate."Full Name"); //Min 7.4.2022
                            EvaluationEntires.Validate(Marks, Candidate."Written Score"); //Min 7.6.2022
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
        //Interviewer.RESET;
        //Interviewer.SETRANGE(Interviewer,GetEmployeeNo);
        //IF Interviewer.FINDFIRST THEN BEGIN
        EvaluationEntires.Reset;
        EvaluationEntires.FilterGroup(2);
        EvaluationEntires.SetRange("Vacancy Code", VacancyCode);
        EvaluationEntires.SetRange(Type, EvaluationEntires.Type::Interview);
        // EvaluationEntires.SETFILTER("No.",CandidateFilter);
        //EvaluationEntires.SETRANGE("Interviewer Code",Interviewer.Interviewer);
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
        Vacancy.TESTFIELD(Status,Vacancy.Status::"Interview Scheduled");
        Candidate.RESET;
        Candidate.SETRANGE("Vacancy Code",VacancyCode);
        Candidate.SETRANGE(Status,Candidate.Status::"Interview Scheduled");
        IF Candidate.FIND('-') THEN REPEAT
          EvaluationEntry.RESET;
          EvaluationEntry.SETRANGE("Vacancy Code",VacancyCode);
          EvaluationEntry.SETRANGE("No.",Candidate."No.");
          EvaluationEntry.SETRANGE(Type,EvaluationEntry.Type::Interview);
          EvaluationEntry.SETFILTER(Marks,'<>%1',0);
          IF EvaluationEntry.FINDFIRST THEN BEGIN
            Candidate.Status := Candidate.Status::Interviewed;
            Candidate.MODIFY;
          END;
        UNTIL Candidate.NEXT = 0;
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
        //Vacancy.TESTFIELD(Status,Vacancy.Status::"Interview Scheduled");
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        Candidate.SetRange(Status, Candidate.Status::"Interview Scheduled");
        Candidate.SetFilter("Total Marks", '<>%1', 0);
        if Candidate.Find('-') then
            repeat
                Interviewer.Reset; //Min -- For add control incase of interviwer missing to submit marks.
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
        CandidateRec.RESET;
        CandidateRec.SETRANGE("Vacancy Code",VacancyCode);
        CandidateRec.SETRANGE(Status,Candidate.Status::"Interview Scheduled");
        CandidateRec.SETFILTER("Total Marks",'<>%1',0);
        Interviewer.RESET; //Min -- For add control incase of interviwer missing to submit marks.
        Interviewer.SETRANGE("Vacancy Code",VacancyCode);
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
                EvaluationEntry.SetFilter(Marks, '>0'); //Min 7.4.2022
                                                        //EvaluationEntry.SETRANGE(Posted,TRUE); //Min commented -- not required during calculate marks
                EvaluationEntry.CalcSums(Marks);
                EvaluationAttribute.Reset;
                EvaluationAttribute.SetRange("Attribute Type", EvaluationAttribute."Attribute Type"::Interview);
                EvaluationAttribute.CalcSums(PassMarks);

                if EvaluationEntry.Marks <> 0 then begin
                    Counter := EvaluationEntry.Count;
                    if EvaluationEntry.Find('-') then
                        repeat
                            //IF ROUND(EvaluationEntry.Marks/EvaluationEntry.COUNT,0.01,'=') >= ROUND(EvaluationAttribute.PassMarks/EvaluationAttribute.COUNT,0.01,'=') THEN BEGIN
                            //END;
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
                //EvaluationEntry.SETRANGE(Posted,TRUE); //Min commented -- not required during Interviewer Name Update
                EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
                EvaluationEntry.SetFilter(Marks, '>0'); //Min 7.4.2022
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
                                Candidate."Interviewer 4" := EvaluationEntry."Interviewer Name"; //Min 7.3.2022
                            5:
                                Candidate."Interviewer 5" := EvaluationEntry."Interviewer Name"; //Min 7.3.2022
                        end;
                        i += 1;
                    until EvaluationEntry.Next = 0;
                Clear(EvaluationEntryRec); //Min -- For candiate remarks
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
                //IF FunctionalTitle."Written Exam" THEN BEGIN
                if Candidate."Avg. Inverview Score" <> 0 then begin
                    if (HRSetup."Interview Weightage" + HRSetup."Written Exam Weightage") <> 0 then begin
                        Candidate."Total Marks" := (Candidate."Avg. Inverview Score" * HRSetup."Interview Weightage" + Candidate."Written Score" * HRSetup."Written Exam Weightage") /
                                           (HRSetup."Interview Weightage" + HRSetup."Written Exam Weightage");
                        Candidate.Modify;
                    end;
                    /*END;
                    END ELSE BEGIN
                      IF (HRSetup."Interview Weightage"<>0 ) THEN BEGIN
                        Candidate."Total Marks" := Candidate."Avg. Inverview Score" ;
                        Candidate.MODIFY;
                      END;*/
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
                        AppraisalRating.SetRange(Remarks, Appraisal.Rating);
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
        InsertVacancyApprovalWorkflowTemplate;    //Pradhan IMERemit1.00
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

    procedure CheckDistrictName(DistrictName: Text[30])
    var
        DistrictVar: Record District;
        ErrorDistrict: Label 'District Name %1 Not found';
    begin
        DistrictVar.Reset;
        DistrictVar.SetRange("District Name", DistrictName);
        if not DistrictVar.FindFirst then
            Error(ErrorDistrict, DistrictName);
    end;

    procedure CheckCountryName(CountryName: Text[30])
    var
        Country: Record "Country/Region";
        ErrorDistrict: Label 'Country Name %1 Not found';
    begin
        Country.Reset;
        Country.SetRange("Name", CountryName);
        if not Country.FindFirst then
            Error(ErrorDistrict, CountryName);
    end;

    procedure LookupCountry(): Text[30]
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

    procedure LookupCountryOtherThenNepalAndSAARC(): Text[30]
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

    procedure LookupCountrySAARC(IsSAARC: Boolean): Text[30]
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

    procedure LookupDistrict(ProvienceName: Text[30]; xDisTxt: Text[30]): Text[30]
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

    procedure LookupAllDistrict(): Text[30]
    var
        PageDistrict: Page "District";
        DistrictVar: Record District;
    begin
        Clear(PageDistrict);
        DistrictVar.Reset;
        // DistrictVar.SetRange("Province Name", ProvienceName);
        // PageDistrict.SetRecord(DistrictVar);
        // PageDistrict.SetTableView(DistrictVar);
        PageDistrict.LookupMode(true);
        if PageDistrict.RunModal = ACTION::LookupOK then begin
            PageDistrict.GetRecord(DistrictVar);
            exit(DistrictVar."District Name");
        end;
    end;

    procedure CheckMunicipalityName(MunicipalityName: Text[30])
    var
        Municipality: Record Municipality;
        ErrorDistrict: Label 'Municipality Name %1 Not found';
    begin
        Municipality.Reset;
        Municipality.SetRange("Municipality Name", MunicipalityName);
        if not Municipality.FindFirst then
            Error(ErrorDistrict, MunicipalityName);
    end;

    procedure LookupMunicipalityName(DistrictName: Text[30]; MunicipalityName: Text[30]): Text[30]
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

    procedure CheckProvience(ProvienceName: Text[30])
    var
        ProvienceVar: Record Province;
        ErrorProvience: Label 'Provience Name %1 not found.';
    begin
        Clear(ProvienceVar);
        ProvienceVar.SetRange(Description, ProvienceName);
        if not ProvienceVar.FindFirst then
            Error(ErrorProvience, ProvienceName);
    end;

    procedure LookupProvience(xProvTxt: Text[30]): Text[30]
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

    // procedure CheckSubProvience(SubProvienceName: Text[30])
    // var
    //     // SubProvienceVar: Record "Sub Province";
    //     ErrorSubProvience: Label 'Sub-Provience Name %1 not found.';
    // begin
    //     Clear(SubProvienceVar);
    //     SubProvienceVar.SetRange(City, SubProvienceName);
    //     if not SubProvienceVar.FindFirst then
    //         Error(ErrorSubProvience, SubProvienceName);
    // end;

    // procedure LookupSubProvience(ProvienceName: Text[30]; xSubProvTxt: Text[30]): Text[30]
    // var
    //     SubProvienceVar: Record "Sub Province";
    //     PageSubProvience: Page "SubProvinceList";
    // begin
    //     Clear(SubProvienceVar);
    //     Clear(PageSubProvience);
    //     SubProvienceVar.SetRange("Province Name", ProvienceName);
    //     PageSubProvience.SetRecord(SubProvienceVar);
    //     PageSubProvience.SetTableView(SubProvienceVar);
    //     PageSubProvience.LookupMode(true);
    //     if PageSubProvience.RunModal = ACTION::LookupOK then begin
    //         PageSubProvience.GetRecord(SubProvienceVar);
    //         exit(SubProvienceVar.City);
    //     end;
    //     exit(xSubProvTxt);
    // end;

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
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", EngDate);
        if EngNep.FindFirst then
            exit(EngNep."Fiscal Year");
    end;

    procedure ReturnEndDateFY(FiscalYear: Text) EndDateFY: Date
    var
        EngNep: Record "English-Nepali Date";
    begin
        EngNep.Reset;
        EngNep.SetRange("Fiscal Year", FiscalYear);
        EngNep.SetCurrentKey("English Date");
        if EngNep.FindLast then
            exit(EngNep."English Date");
    end;

    procedure ReturnEmpName(EmpCode: Code[20]): Text
    begin
        if Employee.Get(EmpCode) then
            exit(Employee."Full Name");
    end;

    procedure SendMailFromTemplate(TableNo: Integer; DocumentType: enum "Employee Activity Type"; TypeOpt: Enum "approval status"; Remarks: Text; EmployeeNo: Code[20]; DocumentNo: Code[20]; SubType: Option " ","Transfer Effective Date Exceeded","Document Approver")
    var
        EmailTemplate: Record "Email Template";
        Footer: Text;
        Header: Text;
        Body: Text;
        EmailMessage: Record "Email Template Message";
        EmailReceipent: Record "Email Template Recipient";
        Employee: Record Employee;
        EmployeeActivity: Record "Employee Activity";
        EmailReceipientText: List of [Text];
        EmpLoan: Record "Employee Loan/Advance";
        TrainLine: Record "Training Line";
        TrainHead: Record "Training Header";
        Candidate: Record Candidate;
        EmpAct: Record "Employee Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        AddEmailReceipentFromTemplate: Boolean;
        EmailCCReceipent: List of [Text];
        EmailBCCReceipent: List of [Text];
        RegardsMessage: Label 'Thanks and Regards,<br>DNA and Talent Management Department<br><br>NIC ASIA Bank Ltd.<br>Trade Tower, Thapathali, Kathmandu<br>Tel: +977-1-5111177/78/79<br>Fax: +977-1-5111180M<br>Swift: NICENPKA<br>www.nicasiabank.com';
        AllowanceHeader: Record "Allowance Assignment Header";
        AllowanceBodyText: Label '<br>The allowance assignment from %1 Branch/Extension Counter for the week %2 of month %3 has not been recorded till date.<br>Request you to assign it till EOD.<br>';
        FunctionalTitle: Record "Functional Title";
        FileName: Text;
        // FileMgt: Codeunit "File Management";
        CalcuationDate: Date;
        Week: Integer;
        PGSetup: Record "Payroll General Setup";
        OutStr: OutStream;
        InStr: InStream;
        tmpBlob: Codeunit "Temp Blob";
        recRef: RecordRef;
        format: ReportFormat;
        Email: Codeunit Email;
        CodeunitEmailMessage: Codeunit "Email Message";
    begin
        Clear(EmailReceipientText);
        Clear(InStr);
        HRSetup.Get;

        AddEmailReceipentFromTemplate := true;

        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        EmailTemplate.Reset;
        EmailTemplate.SetRange("Document Type", DocumentType);
        EmailTemplate.SetRange("Sub Type", SubType);
        //EmailTemplate.SETRANGE(Type,TypeOpt);
        EmailTemplate.SetFilter("Approval Status", Format(TypeOpt));
        if TableNo = DATABASE::"Employee Loan/Advance" then begin
            // EVALUATE(TempInt, DocumentNo);
            if EmpLoan.Get(DocumentNo) then
                EmailTemplate.SetRange("Loan Type", EmpLoan."Loan Type");
        end;

        if EmailTemplate.FindFirst then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);

            // training header
            if (DocumentNo <> '') and (TableNo = DATABASE::"Training Header") then begin
                TrainHead.Get(DocumentNo);
                TrainLine.Reset;
                TrainLine.SetRange("Training No.", TrainHead."No.");
                TrainLine.SetFilter("Trainer Type", '<>%1', TrainLine."Trainer Type"::External);
                TrainLine.SetFilter(Type, '<>%1', TrainLine.Type::Vendor);
                if TrainLine.Find('-') then
                    repeat
                        Employee.Get(TrainLine."Employee Code");
                        Employee.TestField("Company E-Mail");
                        // if EmailReceipientText = '' then
                        EmailReceipientText.add(Employee."Company E-Mail");
                    // else
                    // EmailReceipientText += ';' + Employee."Company E-Mail";
                    until TrainLine.Next = 0;
            end;

            //employee activities
            if (DocumentNo <> '') and (TableNo = DATABASE::"Employee Activity") then begin
                EmployeeActivity.Get(DocumentNo);
                //if EmployeeActivity.Type = EmployeeActivity.Type::"Access Control" then
                //EmailReceipientText.add(GetAddressAccessControl(EmployeeActivity))
                if (DocumentType = DocumentType::"Employee Transfer") and (TypeOpt in [TypeOpt::"On Hold", TypeOpt::Canceled, TypeOpt::Approved, TypeOpt::Acknowledged]) then begin
                    EmailCCReceipent.Add('');
                    Employee.Reset;
                    EmployeeActivity.TestField("Incoming Supervisior");
                    EmployeeActivity.TestField("Outgoing Branch Rep. Person");
                    Employee.SetFilter("No.", '%1|%2|%3', EmployeeActivity."Employee No.", EmployeeActivity."Incoming Supervisior", EmployeeActivity."Outgoing Branch Rep. Person");
                    if Employee.Find('-') then
                        repeat
                            if EmployeeActivity."Employee No." = Employee."No." then begin
                                // if EmailReceipientText = '' then
                                EmailReceipientText.add(Employee."Company E-Mail");
                                // else
                                //     EmailReceipientText += ';' + Employee."Company E-Mail";
                            end else begin
                                // EmailCCReceipent := Employee."Company E-Mail"
                                EmailCCReceipent.Add(Employee."Company E-Mail");
                            end;
                        until Employee.Next = 0;

                    if EmployeeActivity."Notify to" <> '' then begin
                        Employee1.Reset;
                        Employee1.SetFilter("No.", EmployeeActivity."Notify to");
                        if Employee1.Find('-') then
                            repeat
                                Employee1.TestField("Company E-Mail");
                                //  if EmailCCReceipent = '' then
                                EmailCCReceipent.Add(Employee1."Company E-Mail");
                            // else
                            //     EmailCCReceipent += ';' + Employee1."Company E-Mail";
                            until Employee1.Next = 0;
                    end;
                    EmailReceipent.Reset; //Min 9.15.2022
                    EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
                    EmailReceipent.SetFilter("Province Code", '%1|%2', EmployeeActivity."Province Code", EmployeeActivity."Province Code (To)");
                    EmailReceipent.SetRange("Recipient Type", EmailReceipent."Recipient Type"::Cc);
                    if EmailReceipent.Find('-') then
                        repeat
                            EmailCCReceipent.add(EmailReceipent."Email Recipients");
                        until EmailReceipent.Next = 0;
                end else if (TypeOpt = TypeOpt::Recommended) and (DocumentType = DocumentType::Resignation) then begin
                    if SubType = SubType::" " then begin
                        Employee.Get(EmployeeActivity."Employee No.");
                        EmailReceipientText.add(Employee."Company E-Mail");
                    end else if SubType = SubType::"Document Approver" then begin
                        Employee.Reset;
                        Employee.SetRange("Resignation Approver", true);
                        if Employee.Find('-') then
                            repeat
                                // if EmailReceipientText = '' then
                                EmailReceipientText.add(Employee."Company E-Mail");
                            // else
                            //     EmailReceipientText += ';' + Employee."Company E-Mail";
                            until Employee.Next = 0;
                    end;
                end else begin
                    case TypeOpt of
                        TypeOpt::Open:
                            begin
                                Employee.Reset;
                                Employee.SetFilter("No.", '%1|%2|%3|%4', EmployeeActivity."Recommender Code", EmployeeActivity."Approver Code",
                                                    EmployeeActivity."Outgoing Branch Rep. Person", EmployeeActivity."Transfer Claim Reviewer");
                                if Employee.FindFirst then
                                    repeat
                                        Employee.TestField("Company E-Mail");
                                        // if EmailReceipientText = '' then
                                        EmailReceipientText.add(Employee."Company E-Mail");
                                    // else
                                    //     EmailReceipientText += ';' + Employee."Company E-Mail";
                                    until Employee.Next = 0;
                                ResignationMgt.SetResignationApprover(EmpAct, EmailReceipientText); //pram
                            end;
                        TypeOpt::Rejected, TypeOpt::Approved:
                            begin
                                Employee.Get(EmployeeActivity."Employee No.");
                                Employee.TestField("Company E-Mail");
                                EmailReceipientText.add(Employee."Company E-Mail");
                                if EmployeeActivity.Type = EmployeeActivity.Type::"Leave Request" then begin
                                    LeaveTypeSetup.Get(EmployeeActivity."Leave Code");
                                    if LeaveTypeSetup.Email <> '' then
                                        // if EmailReceipientText = '' then
                                            EmailReceipientText.add(LeaveTypeSetup.Email);
                                    // else
                                    //     EmailReceipientText += ';' + LeaveTypeSetup.Email;
                                end;
                            end;
                    end;
                end;
            end;

            //loan
            if TableNo = DATABASE::"Employee Loan/Advance" then begin
                // EVALUATE(TempInt, DocumentNo);
                if EmpLoan.Get(DocumentNo) then begin
                    Employee.Reset;
                    if EmpLoan."Approval Status" in [EmpLoan."Approval Status"::Approved, EmpLoan."Approval Status"::Rejected] then
                        Employee.SetRange("No.", EmpLoan."Employee Code")
                    else
                        // Employee.SetFilter("No.", '%1|%2', EmpLoan.Recommender, EmpLoan.Approver); santosh
                        if Employee.FindFirst then
                            repeat
                                Employee.TestField("Company E-Mail");
                                // if EmailReceipientText = '' then
                                EmailReceipientText.add(Employee."Company E-Mail");
                            // else
                            //     EmailReceipientText += ';' + Employee."Company E-Mail";
                            until Employee.Next = 0;
                end;
            end;

            //allowance assignment
            if TableNo = DATABASE::"Allowance Assignment Header" then begin
                FunctionalTitle.Reset;
                FunctionalTitle.SetRange("Allowance Reminder Mail", true);
                if FunctionalTitle.FindFirst then begin
                    repeat
                        Employee1.Reset;
                        Employee1.SetRange("Global Dimension 1 Code", DocumentNo);
                        Employee1.SetRange("Functional Title", FunctionalTitle.Code);
                        if Employee1.FindFirst then
                            repeat
                                // if EmailReceipientText = '' then
                                EmailReceipientText.add(Employee1."Company E-Mail");
                            // else
                            //     EmailReceipientText += ';' + Employee1."Company E-Mail";
                            until Employee1.Next = 0;
                    until FunctionalTitle.Next = 0;
                end else
                    exit;
            end;


            if (DocumentNo <> '') and (TableNo = DATABASE::Candidate) then begin
                Candidate.Get(DocumentNo, Remarks);
                EmailReceipientText.add(Candidate."E-Mail");
            end;

            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", EmailReceipientText, EmailTemplate.Subject, '', true);
            CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, '', true, EmailCCReceipent, EmailBCCReceipent);
            // if EmailCCReceipent <> '' then
            //     CodeunitEmailMessage.AddCC(EmailCCReceipent);
            EmailMessage.Reset;
            EmailMessage.SetRange("Template Code", EmailTemplate.Code);
            if EmailMessage.FindFirst then
                repeat
                    case EmailMessage.Type of
                        EmailMessage.Type::Header:
                            Header := Header + EmailMessage."Body Message" + '<br>';

                        EmailMessage.Type::Body:
                            Body := Body + EmailMessage."Body Message" + '<br>';

                        EmailMessage.Type::Footer:
                            Footer := Footer + EmailMessage."Body Message" + '<br>';
                    end;
                until EmailMessage.Next = 0;

            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            if (DATABASE::"Allowance Assignment Header" <> TableNo) then
                if Body <> '' then begin
                    CodeunitEmailMessage.AppendToBody(Body);
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                end;
            if (Remarks <> '') and (DocumentType <> DocumentType::"Allowance Assignment") then begin
                CodeunitEmailMessage.AppendToBody(Remarks);
            end;

            case TableNo of
                DATABASE::"Employee Activity":
                    begin
                        if (DocumentNo <> '') then begin //pram
                            case DocumentType of
                                DocumentType::"Leave Request":
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Leave Type") + Colon + Format(EmployeeActivity."Leave Description") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Date") + Colon + Format(EmployeeActivity."Start Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Date") + Colon + Format(EmployeeActivity."End Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("No. of Days") + Colon + Format(EmployeeActivity."No. of Days") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption(Remarks) + Colon + Format(EmployeeActivity.Remarks) + '<br>');
                                    end;

                                DocumentType::"Travel Request":
                                    begin
                                        EmployeeActivity.SetRange("No.", DocumentNo);
                                        EmployeeActivity.SetRange(Type, EmployeeActivity.Type::"Travel Request");
                                        EmployeeActivity.FindFirst;
                                        //EmployeeActivity.GET(DocumentNo);
                                        AddEmailReceipentFromTemplate := (EmployeeActivity."Advance Cash Required") and (TypeOpt = TypeOpt::Approved);
                                        if EmployeeActivity."Travel Order No." <> '' then
                                            CodeunitEmailMessage.AppendToBody('Extension of ' + EmployeeActivity.FieldCaption("Travel Order No.") + Colon + EmployeeActivity."Travel Order No." + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Type Of Visit") + Colon + Format(EmployeeActivity."Type Of Visit") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Date") + Colon + Format(EmployeeActivity."Start Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Date") + Colon + Format(EmployeeActivity."End Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("No. of Days") + Colon + Format(EmployeeActivity."No. of Days") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Depature From") + Colon + EmployeeActivity."Depature From" + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption(Destination) + Colon + EmployeeActivity.Destination + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Purpose of Travel") + Colon + EmployeeActivity."Purpose of Travel" + '<br>');
                                        if AddEmailReceipentFromTemplate then begin
                                            CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Advance Cash") + Colon + Format(EmployeeActivity."Advance Cash") + '<br>');
                                            CodeunitEmailMessage.AppendToBody(Employee.FieldCaption("Bank Account No.") + Colon + EmployeeActivity."Auth. Account No." + '<br>');

                                            //FileName := FileMgt.ClientTempFileName('pdf');
                                            FileName := StrSubstNo('C:/temp/%1.pdf', EmployeeActivity."No.");
                                            recRef.GetTable(EmployeeActivity);
                                            tmpBlob.CreateOutStream(OutStr);
                                            REPORT.SaveAs(DATABASE::"Employee Activity", '', format::Pdf, OutStr, recRef);
                                            tmpBlob.CreateInStream(InStr);
                                            CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
                                            // CodeunitEmailMessage.AddAttachment(FileName, 'pdf');
                                        end;
                                    end;

                                DocumentType::"Travel Claim":
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Type Of Visit") + Colon + Format(EmployeeActivity."Type Of Visit") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Date") + Colon + Format(EmployeeActivity."Start Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Date") + Colon + Format(EmployeeActivity."End Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("No. of Days") + Colon + Format(EmployeeActivity."No. of Days") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Depature From") + Colon + EmployeeActivity."Depature From" + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption(Destination) + Colon + EmployeeActivity.Destination + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Purpose of Travel") + Colon + EmployeeActivity."Purpose of Travel" + '<br>');
                                    end;

                                DocumentType::Overtime:
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody('Date ' + Colon + Format(EmployeeActivity."Start Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody('Purpose ' + Colon + Format(EmployeeActivity.Remarks) + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Time") + Colon + Format(EmployeeActivity."Start Time") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Time") + Colon + Format(EmployeeActivity."End Time") + '<br>');
                                    end;

                                DocumentType::"Out of Office":
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody('Date ' + Colon + Format(EmployeeActivity."Start Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody('Purpose ' + Colon + Format(EmployeeActivity.Remarks) + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Time") + Colon + Format(EmployeeActivity."Start Time") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Time") + Colon + Format(EmployeeActivity."End Time") + '<br>');
                                    end;

                                DocumentType::"Bulk Cash":
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody('Date ' + Colon + Format(EmployeeActivity."Start Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody('Purpose ' + Colon + Format(EmployeeActivity.Remarks) + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Time") + Colon + Format(EmployeeActivity."Start Time") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Time") + Colon + Format(EmployeeActivity."End Time") + '<br>');
                                    end;

                                DocumentType::"Medical Insurance Claim":
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody('Medical Claim No' + Colon + Format(DocumentNo));
                                        CodeunitEmailMessage.AppendToBody('Claim Option' + Colon + Format(EmployeeActivity."Insurance Claim"));
                                        CodeunitEmailMessage.AppendToBody('Claim forwarded to Insurance Company Date' + Colon);
                                        CodeunitEmailMessage.AppendToBody('Amount received from Insurance Company Date' + Colon);
                                        CodeunitEmailMessage.AppendToBody('Insurance Amount Reimbursed Date' + Colon);
                                        CodeunitEmailMessage.AppendToBody('Total Amount Reimbursed Date' + Colon);
                                        CodeunitEmailMessage.AppendToBody('Reason for variation in claim amount' + Colon);
                                    end;

                                DocumentType::Resignation:
                                    begin
                                        if SubType = SubType::"Document Approver" then
                                            CodeunitEmailMessage.AppendToBody(StrSubstNo('Please approve document for resignation of employee %1(%2)', EmployeeActivity."Employee No.", EmployeeActivity."Employee Name"));
                                    end;

                                DocumentType::"Employee Transfer":
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        GetTransferBody(EmployeeActivity);
                                    end;

                                // DocumentType::"Access Control":
                                //     begin
                                //         EmployeeActivity.Get(DocumentNo);
                                //         // GetAccessControlBody(EmployeeActivity);
                                //     end;
                                DocumentType::"Attendance Missed":
                                    begin
                                        EmployeeActivity.Get(DocumentNo);
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee No.") + Colon + Format(EmployeeActivity."Employee No.") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee Name") + Colon + Format(EmployeeActivity."Employee Name") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Date") + Colon + Format(EmployeeActivity."Start Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Date") + Colon + Format(EmployeeActivity."End Date") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("No. of Days") + Colon + Format(EmployeeActivity."No. of Days") + '<br>');
                                        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption(Remarks) + Colon + Format(EmployeeActivity.Remarks) + '<br>');
                                        if EmployeeActivity."Rejection Remarks" <> '' then
                                            CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Rejection Remarks") + Colon + Format(EmployeeActivity."Rejection Remarks") + '<br>');
                                    end;

                            end; //document type case end
                        end; //document no end
                    end; //employee activity end

                DATABASE::"Employee Loan/Advance":
                    begin
                        loanMgt.GetLoanBody(EmpLoan);
                    end;

                //training header
                DATABASE::"Training Header":
                    begin
                        GetTrainingBody(TrainHead);
                    end;

                //vacancy header
                DATABASE::Candidate:
                    begin
                        GetCandidateBody(Candidate);
                    end;

                DATABASE::"Allowance Assignment Header":
                    begin
                        PGSetup.Get;
                        EngNep.Reset;
                        EngNep.SetRange("English Date", Today - PGSetup."Allowance Email Days");
                        if EngNep.FindFirst then
                            CalcuationDate := CalcDate('-CM', Today - PGSetup."Allowance Email Days");
                        Week := Round(((Today - PGSetup."Allowance Email Days" - CalcuationDate) + 1) / 7, 1, '>');
                        if Week > 4 then
                            Week := 4;
                        CodeunitEmailMessage.AppendToBody(StrSubstNo(AllowanceBodyText, Remarks, Week, EngNep."English Month"));
                    end;
            end;

            if (DATABASE::"Allowance Assignment Header" = TableNo) then
                if Body <> '' then begin
                    CodeunitEmailMessage.AppendToBody(Body);
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                end;
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);

            if EmployeeNo <> '' then begin
                Employee.Get(EmployeeNo);
                CodeunitEmailMessage.AppendToBody('<br>');
                CodeunitEmailMessage.AppendToBody(Employee."Full Name");
            end else begin

                CodeunitEmailMessage.AppendToBody('<br>' + RegardsMessage + '<br>');
            end;
            if DocumentType <> DocumentType::"Employee Transfer" then begin //Min 9.15.2022
                if AddEmailReceipentFromTemplate then begin
                    EmailReceipent.Reset;
                    EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
                    if EmailReceipent.FindFirst then
                        repeat
                            if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" then
                                EmailReceipientText.Add(EmailReceipent."Email Recipients");
                            if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Bcc then
                                EmailBCCReceipent.Add(EmailReceipent."Email Recipients");
                            if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Cc then
                                EmailCCReceipent.Add(EmailReceipent."Email Recipients");
                        until EmailReceipent.Next = 0;
                end;
            end;
            CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, '', true, EmailCCReceipent, EmailBCCReceipent);
            Email.Send(CodeunitEmailMessage);
            //MESSAGE('Success');
            if FileName <> '' then
                CLEAR(FileName);
        end;
    end;

    procedure ApprovedRejectApprovalAPI(Approved: Boolean; EmpActCode: Code[20]; employeeNo: Code[20])
    var

        EmpAct: Record "Employee Activity";
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        EmpAct2: Record "Employee Activity";
    begin
        EmpAct.Get(EmpActCode);
        if EmpAct.Type = EmpAct.Type::"Leave Request" then begin
            if Approved then begin
                LeaveMgt.CheckForLeaveCriteria(EmpAct."Leave Code", EmpAct."Start Date", EmpAct."End Date", EmpAct."Employee No.", EmpAct."No. of Days");
                EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Recommended);
                CheckEmployeeActivityApproval(EmpAct);
                EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Approved);
                LeaveEarn.Init;
                LeaveEarn.Validate("Leave Code", EmpAct."Leave Code");
                LeaveEarn.Validate(EmpNo, EmpAct."Employee No.");
                LeaveEarn.Validate(Type, LeaveEarn.Type::Used);
                LeaveEarn.Validate("Fiscal year", EmpAct."Fiscal Year");
                LeaveEarn.Validate("Posted Date", Today);
                LeaveEarn.Validate("Balancing Days", -EmpAct."No. of Days");
                LeaveEarn.Validate("Leave Request No", EmpAct."No.");
                LeaveEarn.Insert(true);

                //changes in employee attendance and activity
                EmpAttendActivity.Reset;
                EmpAttendActivity.SetRange("Employee No.", EmpAct."Employee No.");
                EmpAttendActivity.SetRange("Attendance Date", EmpAct."Start Date", EmpAct."End Date");
                if EmpAttendActivity.Find('-') then
                    repeat
                        LeaveTypeSetup.Get(EmpAct."Leave Code");
                        EmpAttendActivity."Absent Day" := 0;
                        EmpAttendActivity."Present Day" := 0;
                        if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then begin
                            if not LeaveTypeSetup."Exclude Non Working Days" then begin
                                EmpAttendActivity."Day Type" := EmpAttendActivity."Day Type"::"Working Day";
                                EmpAttendActivity."Week Off Day" := 0;
                                if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                    EmpAttendActivity."Present Day" := 1;
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                                end else begin
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                    EmpAttendActivity."Absent Day" := 1;
                                end;
                                EmpAttendActivity."Leave Day" := 1;
                            end;
                        end else if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::"Working Day" then begin
                            if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                EmpAttendActivity."Present Day" := 1;
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                            end else begin
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                EmpAttendActivity."Absent Day" := 1;
                            end;
                            EmpAttendActivity."Leave Day" := 1;
                        end;
                        EmpAttendActivity."Tour Day" := 0;
                        EmpAttendActivity."Employee Activity Found" := true;
                        EmpAttendActivity."Source No." := EmpAct."No.";
                        EmpAttendActivity.Validate("Leave Description", EmpAct."Leave Description");
                        EmpAttendActivity."Created Datetime" := CurrentDateTime;
                        EmpAttendActivity.Modify;
                    until EmpAttendActivity.Next = 0;
                AttendanceSetup.Get;
                Employee.Get(EmpAct."Employee No.");
                Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                    if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                    else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                end else
                    Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                Employee.Modify;

                SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::"Leave Request", EmpAct."Approval Status"::Approved, '', EmpAct."Approver Code", EmpAct."No.", 0);   //For email
            end else begin
                EmpAct.TestField("Rejection Remarks");
                if not (EmpAct."Approval Status" in [EmpAct."Approval Status"::Recommended, EmpAct."Approval Status"::Pending]) then
                    Error(ApprovalStatusError, EmpAct."Approval Status"::Recommended, EmpAct."Approval Status"::Pending);
                CheckEmployeeActivityApproval(EmpAct);
                if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then
                    SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::"Leave Request", EmpAct."Approval Status"::Rejected, '', EmpAct."Recommender Code", EmpAct."No.", 0)   //For email
                else
                    SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::"Leave Request", EmpAct."Approval Status"::Rejected, '', EmpAct."Approver Code", EmpAct."No.", 0);   //For email
                EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Rejected);
                EmpAct.TestField("Rejection Remarks");
                Message('The leave request has been rejected.');
            end;
        end else begin
            if Approved then begin
                EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Recommended);
                CheckEmployeeActivityApproval(EmpAct);
                EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Approved);
                if EmpAct.Type = EmpAct.Type::"Travel Request" then begin
                    //changes in employee attendance and activity
                    EmpAttendActivity.Reset;
                    EmpAttendActivity.SetRange("Employee No.", EmpAct."Employee No.");
                    EmpAttendActivity.SetRange("Attendance Date", EmpAct."Start Date", EmpAct."End Date");
                    if EmpAttendActivity.Find('-') then
                        repeat
                            EmpAttendActivity."Absent Day" := 0;
                            EmpAttendActivity."Present Day" := 1;
                            EmpAttendActivity."Tour Day" := 1;
                            EmpAttendActivity."Leave Day" := 0;
                            EmpAttendActivity."Source No." := EmpAct."No.";
                            EmpAttendActivity."Employee Activity Found" := true;
                            EmpAttendActivity."Created Datetime" := CurrentDateTime;

                            EmpAttendActivity.Modify;
                        until EmpAttendActivity.Next = 0;
                    Employee.Get(EmpAct."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    AttendanceSetup.Get;
                    Employee.Get(EmpAct."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                        if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                        else
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    end else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    Employee.Modify;
                end;

                SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type, EmpAct."Approval Status"::Approved, '', EmpAct."Approver Code", EmpAct."No.", 0);   //For email
                Message('The document has been approved.');
            end else
                if (EmpAct."Approval Status" in [EmpAct."Approval Status"::Pending, EmpAct."Approval Status"::Recommended]) then begin
                    EmpAct.TestField("Rejection Remarks");
                    if EmpAct.Type = EmpAct.Type::"Travel Claim" then begin
                        EmpAct.TestField("Travel Order No.");
                        EmpAct2.Get(EmpAct."Travel Order No.");
                        EmpAct2.Validate("Travel Claimed", false);
                        EmpAct2.Modify;
                    end;
                    CheckEmployeeActivityApproval(EmpAct);
                    if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then
                        SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type, EmpAct."Approval Status"::Rejected, '', EmpAct."Recommender Code", EmpAct."No.", 0)  //For email
                    else
                        SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type, EmpAct."Approval Status"::Rejected, '', EmpAct."Approver Code", EmpAct."No.", 0);   //For email
                    EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Rejected);
                    Message('The document has been rejected.');
                end else
                    Error('Cannot reject the document.');
        end;
        EmpAct.Posted := true;
        EmpAct."Approved Date" := Today;
        EmpAct.Modify;
    end;

    procedure ApprovedRejectApproval(Approved: Boolean; EmpActCode: Code[20])
    var

        EmpAct: Record "Employee Activity";
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        EmpAct2: Record "Employee Activity";
    begin
        EmpAct.Get(EmpActCode);
        if EmpAct.Type = EmpAct.Type::"Leave Request" then begin
            if Approved then begin
                LeaveMgt.CheckForLeaveCriteria(EmpAct."Leave Code", EmpAct."Start Date", EmpAct."End Date", EmpAct."Employee No.", EmpAct."No. of Days");
                EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Recommended);
                CheckEmployeeActivityApproval(EmpAct);
                EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Approved);
                LeaveEarn.Init;
                LeaveEarn.Validate("Leave Code", EmpAct."Leave Code");
                LeaveEarn.Validate(EmpNo, EmpAct."Employee No.");
                LeaveEarn.Validate(Type, LeaveEarn.Type::Used);
                LeaveEarn.Validate("Fiscal year", EmpAct."Fiscal Year");
                LeaveEarn.Validate("Posted Date", Today);
                LeaveEarn.Validate("Balancing Days", -EmpAct."No. of Days");
                LeaveEarn.Validate("Leave Request No", EmpAct."No.");
                LeaveEarn.Insert(true);

                //changes in employee attendance and activity
                EmpAttendActivity.Reset;
                EmpAttendActivity.SetRange("Employee No.", EmpAct."Employee No.");
                EmpAttendActivity.SetRange("Attendance Date", EmpAct."Start Date", EmpAct."End Date");
                if EmpAttendActivity.Find('-') then
                    repeat
                        LeaveTypeSetup.Get(EmpAct."Leave Code");
                        EmpAttendActivity."Absent Day" := 0;
                        EmpAttendActivity."Present Day" := 0;
                        if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then begin
                            if not LeaveTypeSetup."Exclude Non Working Days" then begin
                                EmpAttendActivity."Day Type" := EmpAttendActivity."Day Type"::"Working Day";
                                EmpAttendActivity."Week Off Day" := 0;
                                if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                    EmpAttendActivity."Present Day" := 1;
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                                end else begin
                                    EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                    EmpAttendActivity."Absent Day" := 1;
                                end;
                                EmpAttendActivity."Leave Day" := 1;
                            end;
                        end else if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::"Working Day" then begin
                            if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                                EmpAttendActivity."Present Day" := 1;
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Paid;
                            end else begin
                                EmpAttendActivity."Pay Type" := EmpAttendActivity."Pay Type"::Unpaid;
                                EmpAttendActivity."Absent Day" := 1;
                            end;
                            EmpAttendActivity."Leave Day" := 1;
                        end;
                        EmpAttendActivity."Tour Day" := 0;
                        EmpAttendActivity."Employee Activity Found" := true;
                        EmpAttendActivity."Source No." := EmpAct."No.";
                        EmpAttendActivity.Validate("Leave Description", EmpAct."Leave Description");
                        EmpAttendActivity."Created Datetime" := CurrentDateTime;
                        EmpAttendActivity.Modify;
                    until EmpAttendActivity.Next = 0;
                AttendanceSetup.Get;
                Employee.Get(EmpAct."Employee No.");
                Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                    if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                    else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                end else
                    Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                Employee.Modify;

                SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::"Leave Request", EmpAct."Approval Status"::Approved, '', EmpAct."Approver Code", EmpAct."No.", 0);  //For email
                Message('The document has been approved.');
            end else begin
                EmpAct.TestField("Rejection Remarks");
                if not (EmpAct."Approval Status" in [EmpAct."Approval Status"::Recommended, EmpAct."Approval Status"::Pending]) then
                    Error(ApprovalStatusError, EmpAct."Approval Status"::Recommended, EmpAct."Approval Status"::Pending);
                CheckEmployeeActivityApproval(EmpAct);
                if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then
                    SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::"Leave Request", EmpAct."Approval Status"::Rejected, '', EmpAct."Recommender Code", EmpAct."No.", 0)   //For email
                else
                    SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::"Leave Request", EmpAct."Approval Status"::Rejected, '', EmpAct."Approver Code", EmpAct."No.", 0);   //For email
                EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Rejected);
                EmpAct.TestField("Rejection Remarks");
                Message('The leave request has been rejected.');
            end;
        end else begin
            if Approved then begin
                EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Recommended);
                CheckEmployeeActivityApproval(EmpAct);
                EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Approved);
                if EmpAct.Type = EmpAct.Type::"Travel Request" then begin
                    //changes in employee attendance and activity
                    EmpAttendActivity.Reset;
                    EmpAttendActivity.SetRange("Employee No.", EmpAct."Employee No.");
                    EmpAttendActivity.SetRange("Attendance Date", EmpAct."Start Date", EmpAct."End Date");
                    if EmpAttendActivity.Find('-') then
                        repeat
                            EmpAttendActivity."Absent Day" := 0;
                            EmpAttendActivity."Present Day" := 1;
                            EmpAttendActivity."Tour Day" := 1;
                            EmpAttendActivity."Leave Day" := 0;
                            EmpAttendActivity."Source No." := EmpAct."No.";
                            EmpAttendActivity."Employee Activity Found" := true;
                            EmpAttendActivity."Created Datetime" := CurrentDateTime;

                            EmpAttendActivity.Modify;
                        until EmpAttendActivity.Next = 0;
                    Employee.Get(EmpAct."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    AttendanceSetup.Get;
                    Employee.Get(EmpAct."Employee No.");
                    Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                    if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                        if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                        else
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    end else
                        Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                    Employee.Modify;
                end;

                SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type, EmpAct."Approval Status"::Approved, '', EmpAct."Approver Code", EmpAct."No.", 0);   //For email
                Message('The document has been approved.');
            end else
                if (EmpAct."Approval Status" in [EmpAct."Approval Status"::Pending, EmpAct."Approval Status"::Recommended]) then begin
                    EmpAct.TestField("Rejection Remarks");
                    if EmpAct.Type = EmpAct.Type::"Travel Claim" then begin
                        EmpAct.TestField("Travel Order No.");
                        EmpAct2.Get(EmpAct."Travel Order No.");
                        EmpAct2.Validate("Travel Claimed", false);
                        EmpAct2.Modify;
                    end;
                    CheckEmployeeActivityApproval(EmpAct);
                    if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then
                        SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type, EmpAct."Approval Status"::Rejected, '', EmpAct."Recommender Code", EmpAct."No.", 0)  //For email
                    else
                        SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type, EmpAct."Approval Status"::Rejected, '', EmpAct."Approver Code", EmpAct."No.", 0);   //For email
                    EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Rejected);
                    Message('The document has been rejected.');
                end else
                    Error('Cannot reject the document.');
        end;
        EmpAct.Posted := true;
        EmpAct."Approved Date" := Today;
        EmpAct.Modify;
    end;

    procedure GetNoDaysInMonth(): Decimal
    begin
        PRSetup.Get;
        exit(Round((PRSetup."Payroll Fiscal Year End Date" - PRSetup."Payroll Fiscal Year Start Date" + 1) / 12, 0.01, '='));
    end;

    local procedure "-----Leave------"()
    begin
    end;
    //Procedure tranfer to Leave Mgt. by santosh 

    // procedure OpenLeaveRequest(EmpCode: Code[20])
    // var
    //     EmpAct: Record "Employee Activity" temporary;
    //     EmployeeActivity: Record "Employee Activity";
    // begin
    //     Clear(Employee);
    //     Employee.Get(EmpCode);

    //     EmpAct.Init;
    //     EmpAct.Validate("Functional Title", Employee."Functional Title");
    //     EmpAct.Validate("Employee No.", EmpCode);
    //     EmpAct.Validate(Type, EmpAct.Type::"Leave Request");
    //     EmpAct.Validate("Fiscal Year", ReturnFiscalYear(Today));
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Open);
    //     EmpAct.Validate("Employee Work Shift", Employee."Employee Work Shift");
    //     EmpAct.Validate("Leave Type", EmpAct."Leave Type"::"Full Day");
    //     EmpAct.Validate("Requested Date", Today);
    //     EmpAct.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
    //     EmpAct.Validate(Department, Employee."Department Code");
    //     EmpAct.Insert;
    //     if GuiAllowed then //NICASIA SM for Web Portal
    //         PAGE.Run(PAGE::"Leave Request", EmpAct);
    // end;

    // procedure CalculateNoOfDays(StartDate: Date; EndDate: Date; LeaveCode: Code[20]; Type: Option " ","Leave Request","Travel Request",Settlement; LeaveType: Option "Full Day","First Half","Second Half"; Empcode: Code[20]): Decimal
    // var
    //     DateError: Label 'Start Date (%1) must be less than End Date (%2).';
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     Difference: Decimal;
    // begin
    //     if StartDate > EndDate then
    //         Error(DateError, StartDate, EndDate);
    //     if Type = Type::"Leave Request" then begin
    //         LeaveTypeSetup.Get(LeaveCode);
    //         if LeaveType = LeaveType::"Full Day" then
    //             Difference := 1
    //         else
    //             Difference := 0.5;
    //         if LeaveTypeSetup."Exclude Non Working Days" then
    //             exit(EndDate - StartDate + Difference - GetNonWokingDays(StartDate, EndDate, Empcode))
    //         else
    //             exit(EndDate - StartDate + Difference);
    //     end else
    //         exit(EndDate - StartDate + 1);
    // end;

    // procedure GetNonWokingDays(StartDate: Date; EndDate: Date; EmpCode: Code[20]): Integer
    // var
    //     Description: Text;
    //     Proviences: Text;
    //     Gender: Enum "Employee Gender";
    //     ProviencesVar: Record Province;
    //     CalendarDate: Record Date;
    //     CalendarMgmt: Codeunit "Calendar Management";
    //     Counter: Integer;
    //     AlreadyAdded: Boolean;
    //     BaseCalendar: Record "Base Calendar";
    //     InOutValley: Option " ",Outside,Inside;
    //     PostingRegion: Enum Region;
    //     Branch: Text;
    //     DimValue: Record "Dimension Value";
    //     GLSetup: Record "General Ledger Setup";
    // // AttendanceMgt: Codeunit "Attendance Management";
    // begin
    //     Counter := 0;
    //     PayrollSetup.Get;
    //     Employee.Get(EmpCode);
    //     BaseCalendar.Reset;
    //     BaseCalendar.FindFirst;
    //     CalendarDate.SetRange("Period Type", CalendarDate."Period Type"::Date);
    //     CalendarDate.SetRange("Period Start", StartDate, EndDate);
    //     if CalendarDate.Find('-') then
    //         repeat
    //             Clear(AlreadyAdded);
    //             if CheckDateStatus(BaseCalendar.Code, CalendarDate."Period Start", Description, Proviences, Gender, InOutValley, PostingRegion, Branch) then begin
    //             CalendarDescription := Description;
    //             if (Proviences = '') and (Gender = Gender::" ") and (InOutValley = InOutValley::" ") and (PostingRegion = PostingRegion::" ") and (Branch = '') then
    //                     Counter += 1
    //             else begin
    //             if Proviences <> '' then begin
    //                     ProviencesVar.Reset;
    //                     ProviencesVar.SetFilter(Code, Proviences);
    //                     if ProviencesVar.Find('-') then
    //                         repeat
    //                             if (Employee."Province Code" = ProviencesVar.Code) and (not AlreadyAdded) then begin
    //                                 Counter += 1;
    //                                 AlreadyAdded := true;
    //                                 break;
    //                             end;
    //                         until ProviencesVar.Next = 0;
    //             end;

    //                     if (Gender = Employee.Gender) and (Gender <> Gender::" ") and (not AlreadyAdded) then begin
    //                         Counter += 1;
    //                         AlreadyAdded := true;
    //                         // BREAK;
    //                     end;

    //                     if (PostingRegion = Employee."Posting Region") and (PostingRegion <> PostingRegion::" ") and (not AlreadyAdded) then begin
    //                         Counter += 1;
    //                         AlreadyAdded := true;
    //                         //BREAK;
    //                     end;

    //                     if (Branch <> '') and (not AlreadyAdded) then begin
    //                         GLSetup.Get;
    //                         DimValue.Reset;
    //                         DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
    //                         DimValue.SetFilter(Code, Branch);
    //                         if DimValue.Find('-') then
    //                             repeat
    //                                 if (DimValue.Code = Employee."Global Dimension 1 Code") and (not AlreadyAdded) then begin
    //                                     Counter += 1;
    //                                     AlreadyAdded := true;
    //                                     break;
    //                                 end;
    //                             until DimValue.Next = 0;
    //                     end;


    //                     if (InOutValley = Employee."Inside/Outisde Valley") and (InOutValley <> InOutValley::" ") and (not AlreadyAdded) then begin
    //                         Counter += 1;
    //                         AlreadyAdded := true;
    //                     end;

    //                 end;

    //             end;
    //         until CalendarDate.Next = 0;

    //     exit(Counter);
    // end;

    // procedure CheckLeaveConflict(EmpCode: Code[20]; StartDate: Date; EndDate: Date)
    // var
    //     EmpAct: Record "Employee Activity";
    //     NoOfRecrod: Integer;
    //     EmpAttendanceActivity: Record "Employee Attendance & Activity";
    // begin
    //     // check for leave conflict..
    //     EmpAct.Reset;
    //     EmpAct.SetRange("Employee No.", EmpCode);
    //     //EmpAct.SETRANGE(Type,EmpAct.Type::"Leave Request");
    //     EmpAct.SetFilter(Type, '%1|%2', EmpAct.Type::"Leave Request", EmpAct.Type::"Attendance Missed");
    //     EmpAct.SetFilter("Approval Status", '<>%1', EmpAct."Approval Status"::Rejected);
    //     EmpAct.SetRange("Cancelled No.", '');
    //     EmpAct.SetRange(Cancelled, false);
    //     EmpAct.FilterGroup(-1);
    //     EmpAct.SetRange("Start Date", StartDate, EndDate);
    //     EmpAct.SetRange("End Date", StartDate, EndDate);
    //     EmpAct.FilterGroup(0);

    //     NoOfRecrod := EmpAct.Count;
    //     if NoOfRecrod <> 0 then
    //         Error('Leave has already been request between %1 to %2', StartDate, EndDate);
    //     EngNep.Reset;
    //     EngNep.SetRange("English Date", Today);
    //     if EngNep.FindFirst then;

    //     EmpAct.Reset;
    //     EmpAct.SetRange("Employee No.", EmpCode);
    //     //EmpAct.SETRANGE(Type,EmpAct.Type::"Leave Request");
    //     EmpAct.SetFilter(Type, '%1|%2', EmpAct.Type::"Leave Request", EmpAct.Type::"Attendance Missed");
    //     EmpAct.SetRange("Fiscal Year", EngNep."Fiscal Year");
    //     EmpAct.SetRange("Cancelled No.", '');
    //     EmpAct.SetRange(Cancelled, false);
    //     EmpAct.SetFilter("Approval Status", '<>%1', EmpAct."Approval Status"::Rejected);
    //     if EmpAct.Find('-') then
    //         repeat
    //             if ((StartDate > EmpAct."Start Date") and (StartDate < EmpAct."End Date")) or
    //                 ((EndDate > EmpAct."Start Date") and (EndDate < EmpAct."End Date")) then
    //                 Error('Leave has already been request between %1 to %2', StartDate, EndDate);
    //         until EmpAct.Next = 0;
    //     EmpAttendanceActivity.Reset; //Min 4.11.2022
    //     EmpAttendanceActivity.SetRange("Employee No.", EmpCode);
    //     EmpAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
    //     if EmpAttendanceActivity.FindFirst then
    //         repeat
    //             if EmpAttendanceActivity."Present Day" = 1 then
    //                 Error(LeaveError, EmpAttendanceActivity."Attendance Date");
    //         until EmpAttendanceActivity.Next = 0;
    // end;

    // procedure CheckForLeaveCriteria(LeaveCode: Code[20]; StartDate: Date; EndDate: Date; EmpCode: Code[20]; NoofDays: Decimal)
    // var
    //     EmpAct: Record "Employee Activity";
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     NoLeaveDaysError: Label 'You do not have enough leave Days.';
    //     LeaveEarn: Record "Leave Earn";
    // begin
    //     //check leave criteria
    //     LeaveTypeSetup.Get(LeaveCode);
    //     Employee.Get(EmpCode);
    //     if LeaveTypeSetup."Services Period" then begin
    //         EmpAct.Reset;
    //         EmpAct.SetRange("Employee No.", EmpCode);
    //         EmpAct.SetRange("Leave Code", LeaveCode);
    //         EmpAct.SetFilter("Approval Status", '<>%1&<>%2', EmpAct."Approval Status"::Rejected, EmpAct."Approval Status"::Cancelled);
    //         EmpAct.SetRange(Posted, true);
    //         if EmpAct.Count >= LeaveTypeSetup."Times Per Service Period" then
    //             Error('You cannot apply for %1 leave anymore.', LeaveTypeSetup.Description);
    //     end;


    //     if not (LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::" ") then begin
    //         if LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::Permanent then
    //             Employee.TestField("Employment Type", Employee."Employment Type"::Permanent);
    //         if LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::Probation then
    //             Employee.TestField("Employment Type", Employee."Employment Type"::Probation);
    //         if LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::Contract then
    //             Employee.TestField("Employment Type", Employee."Employment Type"::Contract);
    //     end;

    //     if not (LeaveTypeSetup.Gender = LeaveTypeSetup.Gender::" ") then
    //         Employee.TestField(Gender, LeaveTypeSetup.Gender);

    //     if LeaveTypeSetup."Leave at Once" then begin
    //         LeaveEarn.Reset;
    //         LeaveEarn.SetRange("Leave Code", LeaveTypeSetup.Code);
    //         LeaveEarn.SetRange("Fiscal year", ReturnFiscalYear(StartDate));
    //         LeaveEarn.SetRange(EmpNo, Employee."No.");
    //         LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
    //         if LeaveEarn.FindLast then;
    //         if not (LeaveEarn."Balancing Days" = NoofDays) then
    //             Error('Please select correct date as requested days must be equal to leave balance. Requested Days : %1 and Balance Days : %2', NoofDays, LeaveEarn."Balancing Days");
    //     end;

    //     LeaveTypeSetup.SetRange("Employee No. Filter", EmpCode);
    //     LeaveTypeSetup.SetRange(Code, LeaveCode);
    //     if LeaveTypeSetup.FindFirst then
    //         LeaveTypeSetup.CalcFields("Remaining Days");
    //     if (not LeaveTypeSetup.Compensatory) and (not LeaveTypeSetup."Skip Balance Check") then
    //         if LeaveTypeSetup."Remaining Days" < NoofDays then
    //             Error(NoLeaveDaysError + EmpCode);
    // end;

    // procedure CheckForMulipleRequest(LeaveCode: Code[20]; EmpCode: Code[20]; StartDate: Date; EndDate: Date; NoOfDays: Decimal)
    // var
    //     EmpAct: Record "Employee Activity";
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     ErrorforConsecutive: Label 'Your %1 Leave has exceeded maximum days limit as %1 cannot exceed %2 consecutive days.';
    // begin
    //     LeaveTypeSetup.Get(LeaveCode);
    //     if LeaveTypeSetup."Limit Max. Leave at Once" then begin
    //         EmpAct.Reset;
    //         EmpAct.SetRange("Leave Code", LeaveCode);
    //         EmpAct.SetRange("Employee No.", EmpCode);
    //         EmpAct.SetRange("Approval Status", EmpAct."Approval Status"::Approved);
    //         EmpAct.SetRange("End Date", StartDate - 1);
    //         if EmpAct.FindFirst then begin
    //             if LeaveTypeSetup."Maximum Leave at once" < NoOfDays + EmpAct."No. of Days" then
    //                 Error(ErrorforConsecutive, LeaveCode, LeaveTypeSetup."Maximum Leave at once")
    //             else
    //                 CheckForMulipleRequest(LeaveCode, EmpCode, StartDate - 1, EndDate, NoOfDays + EmpAct."No. of Days");
    //         end;
    //         Clear(EmpAct);
    //         EmpAct.SetRange("Leave Code", LeaveCode);
    //         EmpAct.SetRange("Employee No.", EmpCode);
    //         EmpAct.SetRange("Start Date", EndDate + 1);
    //         if EmpAct.FindFirst then begin
    //             if LeaveTypeSetup."Maximum Leave at once" < NoOfDays + EmpAct."No. of Days" then
    //                 Error(ErrorforConsecutive, LeaveCode, LeaveTypeSetup."Maximum Leave at once")
    //             else
    //                 CheckForMulipleRequest(LeaveCode, EmpCode, StartDate, EndDate + 1, NoOfDays + EmpAct."No. of Days");
    //         end;
    //     end;
    // end;

    // procedure UpdateLeaveEmployee(EmpCode: Code[20];
    // JoiningDate: Date;
    // EmployeeType: enum "Employee Type";
    // Gender: Enum "Employee Gender";
    // MaritalStatus: Enum "Marital Status")
    // var
    //     LeaveEarn: Record "Leave Earn";
    //     LeavetypSetup: Record "Leave Type Setup";
    // begin
    //     CheckBetweenFiscalYear;
    //     PRSetup.Get;
    //     Employee.Get(EmpCode);
    //     if Employee."Employment Type" = Employee."Employment Type"::Permanent then
    //         Employee.TestField("Confirmation Date");
    //     EngNep.Reset;
    //     EngNep.SetRange("English Date", Today);
    //     if EngNep.FindFirst then;
    //     UpdatePreviousYearleave;
    //     LeavetypSetup.Reset;
    //     LeavetypSetup.SetFilter("Leave For Employee Type", '%1|%2', EmployeeType, LeavetypSetup."Leave For Employee Type"::" ");
    //     LeavetypSetup.SetFilter(Gender, '%1|%2', Gender, LeavetypSetup.Gender::" ");
    //     LeavetypSetup.SetFilter("Marital Status", '%1|%2', LeavetypSetup."Marital Status"::" ", MaritalStatus);
    //     LeavetypSetup.SetRange(Compensatory, false);
    //     LeavetypSetup.SetRange("Needed HR Permission", false);
    //     LeavetypSetup.SetRange("Skip Balance Check", false);
    //     if LeavetypSetup.Find('-') then
    //         repeat
    //             Clear(LeaveEarn);
    //             LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
    //             LeaveEarn.SetRange(EmpNo, EmpCode);
    //             LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
    //             if not LeavetypSetup."Services Period" then
    //                 LeaveEarn.SetRange("Fiscal year", EngNep."Fiscal Year");
    //             if not LeaveEarn.FindFirst then begin
    //                 LeaveEarn.Init;
    //                 LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
    //                 LeaveEarn.Validate(EmpNo, EmpCode);
    //                 LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
    //                 LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
    //                 LeaveEarn.Validate("Posted Date", Today);
    //                 if LeavetypSetup."AML Eligible" then begin
    //                     if Employee."Confirmation Date" <= PRSetup."Payroll Fiscal Year Start Date" then begin
    //                         if not LeavetypSetup."Calculate Proratawise" then
    //                             LeaveEarn.Validate("Balancing Days", LeavetypSetup."Days Earned Per Year")
    //                         else
    //                             LeaveEarn.Validate("Balancing Days", CalculateProDataLeave(LeavetypSetup.Code, Employee."Confirmation Date"));
    //                         if LeaveEarn."Balancing Days" <> 0 then
    //                             LeaveEarn.Insert(true);
    //                     end;
    //                 end else begin
    //                     if not LeavetypSetup."Calculate Proratawise" then
    //                         LeaveEarn.Validate("Balancing Days", LeavetypSetup."Days Earned Per Year")
    //                     else
    //                         LeaveEarn.Validate("Balancing Days", CalculateProDataLeave(LeavetypSetup.Code, JoiningDate));
    //                     if LeaveEarn."Balancing Days" <> 0 then
    //                         LeaveEarn.Insert(true);
    //                 end;
    //             end;
    //         until LeavetypSetup.Next = 0;
    // end;

    // local procedure UpdatePreviousYearleave()
    // var
    //     LeaveEarn: Record "Leave Earn";
    //     LeavetypSetup: Record "Leave Type Setup";
    //     EnglishNepaliDate: Record "English-Nepali Date";
    //     DocNo: Code[20];
    //     NoSeriesMgt: Codeunit NoSeriesManagement;
    // begin
    //     EnglishNepaliDate.Reset;
    //     EnglishNepaliDate.SetRange("English Date", CalcDate('-1Y+1M', Today));
    //     if EnglishNepaliDate.FindFirst then;
    //     LeavetypSetup.Reset;
    //     LeavetypSetup.SetRange(Compensatory, false);
    //     LeavetypSetup.SetRange("Needed HR Permission", false);
    //     LeavetypSetup.SetRange("Skip Balance Check", false);
    //     LeavetypSetup.SetRange("Employee No. Filter", Employee."No.");
    //     if LeavetypSetup.Find('-') then
    //         repeat
    //             LeavetypSetup.CalcFields("Remaining Days");
    //             HRSetup.Get; //Min 7.11.2022
    //             if LeavetypSetup."Remaining Days" > 0 then begin
    //                 if not LeavetypSetup."Carry Forwardable" then begin
    //                     LeaveEarn.Init;
    //                     LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
    //                     LeaveEarn.Validate(EmpNo, Employee."No.");
    //                     LeaveEarn.Validate(Type, LeaveEarn.Type::"Balance via Fiscal Year");
    //                     LeaveEarn.Validate("Fiscal year", EnglishNepaliDate."Fiscal Year");
    //                     LeaveEarn.Validate("Posted Date", Today);
    //                     LeaveEarn.Validate("Balancing Days", -LeavetypSetup."Remaining Days");
    //                     DocNo := NoSeriesMgt.GetNextNo(HRSetup."Leave Earn No.", Today, true);
    //                     LeaveEarn.Validate("Entry No.", DocNo);
    //                     LeaveEarn.Insert();
    //                 end else if LeavetypSetup."Encashable Limit" <= LeavetypSetup."Remaining Days" then begin
    //                     LeaveEarn.Init;
    //                     LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
    //                     LeaveEarn.Validate(EmpNo, Employee."No.");
    //                     LeaveEarn.Validate(Type, LeaveEarn.Type::Encashed);
    //                     LeaveEarn.Validate("Fiscal year", EnglishNepaliDate."Fiscal Year");
    //                     LeaveEarn.Validate("Posted Date", Today);
    //                     LeaveEarn.Validate("Balancing Days", -LeavetypSetup."Encashable Limit");
    //                     DocNo := NoSeriesMgt.GetNextNo(HRSetup."Leave Earn No.", Today, true);
    //                     LeaveEarn.Validate("Entry No.", DocNo);
    //                     LeaveEarn.Insert();
    //                 end;
    //             end;
    //         until LeavetypSetup.Next = 0;
    // end;

    // procedure UpdateLeaveEmployeeContract(EmpCode: Code[20]; JoiningDate: Date; EmployeeType: enum "Employee Type"; Gender: Enum "Employee Gender";
    //                                                                                               MaritalStatus: Enum "Marital Status")
    // var
    //     LeaveEarn: Record "Leave Earn";
    //     LeavetypSetup: Record "Leave Type Setup";
    //     HRSetup: Record "Human Resources Setup";
    //     SalaryLevel: Record "Salary Level";
    //     EmployeeRec: Record Employee;
    // begin
    //     CheckBetweenFiscalYear;
    //     EngNep.Reset;
    //     EngNep.SetRange("English Date", Today);
    //     if EngNep.FindFirst then;

    //     CheckBetweenFiscalYear;
    //     EmployeeRec.Get(EmpCode);
    //     EmployeeRec.TestField("Salary Level");
    //     SalaryLevel.Get(EmployeeRec."Salary Level");

    //     LeavetypSetup.Reset;
    //     LeavetypSetup.SetFilter("Leave For Employee Type", '%1|%2', EmployeeType, LeavetypSetup."Leave For Employee Type"::" ");
    //     LeavetypSetup.SetFilter(Gender, '%1|%2', Gender, LeavetypSetup.Gender::" ");
    //     LeavetypSetup.SetFilter("Marital Status", '%1|%2', LeavetypSetup."Marital Status"::" ", MaritalStatus);
    //     LeavetypSetup.SetRange(Compensatory, false);
    //     LeavetypSetup.SetRange("Needed HR Permission", false);
    //     LeavetypSetup.SetRange("Skip Balance Check", false);
    //     if LeavetypSetup.Find('-') then
    //         repeat
    //             Clear(LeaveEarn);
    //             LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
    //             LeaveEarn.SetRange(EmpNo, EmpCode);
    //             LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
    //             if not LeaveEarn.FindFirst then begin
    //                 LeaveEarn.Init;
    //                 LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
    //                 LeaveEarn.Validate(EmpNo, EmpCode);
    //                 LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
    //                 LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
    //                 LeaveEarn.Validate("Posted Date", Today);
    //                 if not LeavetypSetup."Calculate Proratawise" then
    //                     LeaveEarn.Validate("Balancing Days", SalaryLevel."Leave Balance (Contract Staff)");
    //                 if LeaveEarn."Balancing Days" <> 0 then
    //                     LeaveEarn.Insert(true);
    //             end;
    //         until LeavetypSetup.Next = 0;
    // end;

    // procedure CheckBetweenFiscalYear()
    // begin
    //     PayrollSetup.Get;
    //     if (Today < PayrollSetup."Payroll Fiscal Year Start Date") or (Today > PayrollSetup."Payroll Fiscal Year End Date") then
    //         Error('Date must between %1 and %2', PayrollSetup."Payroll Fiscal Year Start Date", PayrollSetup."Payroll Fiscal Year End Date");
    // end;

    // procedure CalculateProDataLeave(LeaveCode: Code[20]; JoiningDate: Date): Decimal
    // var
    //     TotalRemainingMonth: Decimal;
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     PayorllSetup: Record "Payroll General Setup";
    // begin
    //     PayrollSetup.Get;
    //     LeaveTypeSetup.Get(LeaveCode);
    //     if JoiningDate > PayrollSetup."Payroll Fiscal Year Start Date" then begin
    //         //TotalRemainingMonth:=ROUND((PayrollSetup."Payroll Fiscal Year End Date"-JoiningDate)/30.5,0.01,'=');
    //         exit(Round((PayrollSetup."Payroll Fiscal Year End Date" - JoiningDate + 1) / 365 * LeaveTypeSetup."Days Earned Per Year", 1, '<'));
    //     end else
    //         exit(LeaveTypeSetup."Days Earned Per Year");
    // end;

    // local procedure CheckRemainingLeaveDays(LeaveCode: Code[20]; EmpCode: Code[20]; NoofDays: Decimal)
    // var
    //     LeaveTypeSetup: Record "Leave Type Setup";
    // begin
    //     //check remaining leave days
    //     LeaveTypeSetup.Reset;
    //     LeaveTypeSetup.SetRange(Code, LeaveCode);
    //     LeaveTypeSetup.SetFilter("Employee No. Filter", EmpCode);
    //     if LeaveTypeSetup.FindFirst then
    //         LeaveTypeSetup.CalcFields("Remaining Days");

    //     if not LeaveTypeSetup."Skip Balance Check" then
    //         if LeaveTypeSetup."Remaining Days" < NoofDays then
    //             Error('You do not have enough remaining days for leave %1', LeaveTypeSetup.Description);
    // end;

    // procedure CheckForEmployeeLimit(LeaveCode: Code[20]; EmpCode: Code[20])
    // var
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     DateExpr: Text;
    // begin
    //     LeaveTypeSetup.Get(LeaveCode);
    //     Clear(Employee);
    //     Employee.Get(EmpCode);

    //     if LeaveTypeSetup."Employment Limit" <> 0 then begin
    //         DateExpr := '<' + Format(LeaveTypeSetup."Employment Limit") + 'Y>';
    //         if Today < CalcDate(DateExpr, Employee."Employment Date") then
    //             Error('You are not eligible to apply for leave %1', LeaveTypeSetup.Description);
    //     end;
    // end;

    // procedure CheckForLimitDays(LeaveCode: Code[20]; NoOfDays: Decimal)
    // var
    //     LeaveTypeSetup: Record "Leave Type Setup";
    // begin
    //     LeaveTypeSetup.Get(LeaveCode);
    //     if LeaveTypeSetup."Limit Max. Leave at Once" then
    //         if NoOfDays > LeaveTypeSetup."Maximum Leave at once" then
    //             Error('Applied Leave Days for %1 cannot exceed %2.', LeaveTypeSetup.Description, LeaveTypeSetup."Maximum Leave at once");
    // end;

    // procedure LookupDependability(LeaveCode: Code[20]): Text[100]
    // var
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     PageLeaveTypeSetup: Page "Leave Type Setup";
    //     PrevLeaveCode: Text[100];
    //     LeaveTypeSetup2: Record "Leave Type Setup";
    // begin
    //     Clear(PageLeaveTypeSetup);
    //     Clear(LeaveTypeSetup);
    //     LeaveTypeSetup.SetFilter("Depending Leave", '<>%1', '');
    //     if LeaveTypeSetup.Find('-') then
    //         repeat
    //             Clear(LeaveTypeSetup2);
    //             LeaveTypeSetup2.SetFilter(Code, LeaveTypeSetup."Depending Leave");
    //             if LeaveTypeSetup2.Find('-') then
    //                 repeat
    //                     if LeaveTypeSetup2.Code = LeaveCode then
    //                         exit('');
    //                 until LeaveTypeSetup2.Next = 0;
    //         until LeaveTypeSetup.Next = 0;
    //     if LeaveTypeSetup.Get(LeaveCode) then
    //         PrevLeaveCode := LeaveTypeSetup."Depending Leave";
    //     Clear(LeaveTypeSetup);
    //     LeaveTypeSetup.Reset;
    //     LeaveTypeSetup.FilterGroup(2);
    //     LeaveTypeSetup.SetFilter(Code, '<>%1', LeaveCode);
    //     LeaveTypeSetup.FilterGroup(0);
    //     PageLeaveTypeSetup.LookedUpped;
    //     PageLeaveTypeSetup.SetRecord(LeaveTypeSetup);
    //     PageLeaveTypeSetup.SetTableView(LeaveTypeSetup);
    //     PageLeaveTypeSetup.LookupMode(true);
    //     if PageLeaveTypeSetup.RunModal = ACTION::LookupOK then
    //         exit(PageLeaveTypeSetup.ExitLeaveCodes)
    //     else
    //         exit(PrevLeaveCode);
    // end;

    // procedure CheckDependability(LeaveCode: Code[20]; EmpCode: Code[20])
    // var
    //     EmpLeaveEarn: Record "Leave Earn";
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     LeaveTypeSetup2: Record "Leave Type Setup";
    //     Description: Text;
    // begin
    //     LeaveTypeSetup.Get(LeaveCode);
    //     if LeaveTypeSetup."Depending Leave" <> '' then begin
    //         LeaveTypeSetup2.Reset;
    //         LeaveTypeSetup2.SetFilter(Code, LeaveTypeSetup."Depending Leave");
    //         if LeaveTypeSetup2.Find('-') then
    //             repeat
    //                 if Description = '' then
    //                     Description := LeaveTypeSetup2.Description
    //                 else
    //                     Description += ' or ' + LeaveTypeSetup2.Description;
    //             until LeaveTypeSetup2.Next = 0;
    //         EmpLeaveEarn.SetRange(EmpNo, EmpCode);
    //         EmpLeaveEarn.SetFilter("Leave Code", LeaveTypeSetup."Depending Leave");
    //         EmpLeaveEarn.CalcSums("Balancing Days");
    //         if EmpLeaveEarn."Balancing Days" > 0 then
    //             Error('Your leave (%1) are unavailable. Please use another leave (%2).', LeaveTypeSetup.Description, Description);
    //     end;
    // end;

    // procedure CalculateRemainingDays(EmpCode: Code[20]; LeaveTypecode: Code[20]; PostDate: Date): Decimal
    // var
    //     LeaveEarn: Record "Leave Earn";
    // begin
    //     LeaveEarn.Reset;
    //     LeaveEarn.SetRange(EmpNo, EmpCode);
    //     LeaveEarn.SetRange("Leave Code", LeaveTypecode);
    //     LeaveEarn.SetRange("Posted Date", 0D, PostDate);
    //     LeaveEarn.CalcSums("Balancing Days");
    //     exit(LeaveEarn."Balancing Days");
    // end;

    // procedure CheckForCompensatory(LeaveCode: Code[20]; EmpCode: Code[20]; CompensatoryDate: Date; NoOfDays: Decimal): Boolean
    // var
    //     LeaveType: Record "Leave Type Setup";
    //     ErrorNoOfDays: Label 'No. days must be 1.';
    //     ErrorNonWokDays: Label 'There wasn''t a holiday on %1.';
    //     EmpAttendActivity: Record "Employee Attendance & Activity";
    //     ErrorPresent: Label 'Cannot apply compenstory leave for %1.';
    //     EmpActivity: Record "Employee Activity";
    // begin
    //     LeaveType.Get(LeaveCode);
    //     PayrollSetup.Get; //Min
    //     if LeaveType.Compensatory then begin
    //         if NoOfDays <> 1 then
    //             Error(ErrorNoOfDays);
    //         if not (CompensatoryDate in [PayrollSetup."Payroll Fiscal Year Start Date" .. PayrollSetup."Payroll Fiscal Year End Date"]) then
    //             Error('Cannot apply for previous fiscal year');
    //         //IF GetNonWokingDays(CompensatoryDate,CompensatoryDate,EmpCode) <> 1 THEN
    //         //ERROR(ErrorNonWokDays,CompensatoryDate);
    //         //check for compensatory
    //         EmpActivity.Reset;
    //         EmpActivity.SetRange("Employee No.", EmpCode);
    //         EmpActivity.SetRange(Type, EmpActivity.Type::"Leave Request");
    //         EmpActivity.SetRange("Compensatory Date", CompensatoryDate);
    //         EmpActivity.SetRange("Cancelled No.", '');
    //         EmpActivity.SetFilter("Approval Status", '<>%1', EmpActivity."Approval Status"::Rejected);
    //         if EmpActivity.FindFirst then
    //             Error('Compensatory leave already applied for compensatory date %1', CompensatoryDate);

    //         EmpActivity.Reset;
    //         EmpActivity.SetRange("Employee No.", EmpCode);
    //         EmpActivity.SetRange(Type, EmpActivity.Type::Overtime);
    //         EmpActivity.SetRange("Compensatory Date", CompensatoryDate);
    //         EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Approved);
    //         if EmpActivity.FindFirst then
    //             Error('Overtime already approved on %1 so you are not eligible for compensatory leave.', CompensatoryDate);



    //         EmpAttendActivity.Reset;
    //         EmpAttendActivity.SetRange("Employee No.", EmpCode);
    //         ;
    //         EmpAttendActivity.SetRange("Attendance Date", CompensatoryDate);
    //         if EmpAttendActivity.FindFirst then begin
    //             Clear(LeaveType);
    //             if EmpAttendActivity."Source No." <> '' then
    //                 if not EmpActivity.Get(EmpAttendActivity."Source No.") then
    //                     Error('Compensatory leave is not eligible for compnesatory date %1.', CompensatoryDate);
    //             if LeaveType.Get(EmpActivity."Leave Code") then;
    //             if (EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday) and
    //                 (LeaveType."AML Eligible") then
    //                 exit(true);
    //             if ((EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday) or
    //               (LeaveType."AML Eligible") or (LeaveType."Skip Balance Check")) and (EmpAttendActivity."Check In Time" <> 0T) then
    //                 exit(true)
    //             else
    //                 Error(ErrorPresent, CompensatoryDate);
    //         end;
    //         //EXIT(TRUE);
    //     end;
    // end;

    // procedure UpdateLeaveForEmpTypeChanged(Empcode: Code[20]; xJobType: Option; JobType: Option)
    // var
    //     LeaveType: Record "Leave Type Setup";
    //     LeaveEarn: Record "Leave Earn";
    //     NoMgmt: Codeunit NoSeriesManagement;
    //     ServiceHistory: Record "Employee Service History";
    //     ServiceHistoryCode: Code[20];
    // begin
    //     Employee.Get(Empcode);
    //     Employee.TestField("Confirmation Date");
    //     HRSetup.Get;
    //     LeaveType.Reset;
    //     LeaveType.SetFilter("Employee No. Filter", Empcode);
    //     LeaveType.SetRange("Leave For Employee Type", xJobType);
    //     if LeaveType.Find('-') then
    //         repeat
    //             LeaveType.CalcFields("Remaining Days");
    //             if LeaveType."Remaining Days" <> 0 then begin
    //                 LeaveEarn.Init;
    //                 LeaveEarn.Validate("Entry No.", NoMgmt.GetNextNo(HRSetup."Leave Earn No.", Today, true));
    //                 LeaveEarn.Validate("Leave Code", LeaveType.Code);
    //                 LeaveEarn.Validate(EmpNo, Empcode);
    //                 LeaveEarn.Validate("Leave Description", LeaveType.Description);
    //                 LeaveEarn.Validate(Type, LeaveEarn.Type::EmpTypeChanged);
    //                 EngNep.Reset;
    //                 EngNep.SetRange("English Date", Today);
    //                 if EngNep.FindFirst then;
    //                 LeaveEarn.Validate("Posted Date", Today);
    //                 LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
    //                 LeaveEarn.Validate("Balancing Days", -LeaveType."Remaining Days");
    //                 LeaveEarn.Insert(true);
    //             end;
    //         until LeaveType.Next = 0;

    //     Clear(LeaveType);
    //     LeaveType.Reset;
    //     LeaveType.SetFilter("Employee No. Filter", Empcode);
    //     LeaveType.SetFilter("Leave For Employee Type", '%1|%2', JobType, LeaveType."Leave For Employee Type"::" ");
    //     LeaveType.SetFilter(Gender, '%1|%2', Employee.Gender, LeaveType.Gender::" ");
    //     LeaveType.SetFilter("Marital Status", '%1|%2', LeaveType."Marital Status"::" ", Employee."Marital Status");
    //     LeaveType.SetRange(Compensatory, false);
    //     LeaveType.SetRange("Needed HR Permission", false);
    //     LeaveType.SetRange("Skip Balance Check", false);
    //     if LeaveType.Find('-') then
    //         repeat
    //             LeaveEarn.Init;
    //             LeaveEarn.Validate("Entry No.", NoMgmt.GetNextNo(HRSetup."Leave Earn No.", Today, true));
    //             LeaveEarn.Validate("Leave Code", LeaveType.Code);
    //             LeaveEarn.Validate(EmpNo, Empcode);
    //             LeaveEarn.Validate("Leave Description", LeaveType.Description);
    //             LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
    //             EngNep.Reset;
    //             EngNep.SetRange("English Date", Today);
    //             if EngNep.FindFirst then;
    //             LeaveEarn.Validate("Posted Date", Today);
    //             LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
    //             if LeaveType."Calculate Proratawise" then
    //                 LeaveEarn.Validate("Balancing Days", CalculateProDataLeave(LeaveType.Code, Employee."Confirmation Date"))
    //             else
    //                 LeaveEarn.Validate("Balancing Days", LeaveType."Days Earned Per Year");
    //             if LeaveEarn."Balancing Days" <> 0 then
    //                 LeaveEarn.Insert(true);
    //         until LeaveType.Next = 0;

    //     ServiceHistoryCode := AddToServiceHistory(Employee."No.", ServiceHistory."Service Event"::Confirmation, 'Confirmed', Employee."Confirmation Date");
    //     if ServiceHistory.Get(ServiceHistoryCode) then begin
    //         ServiceHistory.Validate("Functional Title (To)", Employee."Functional Title");
    //         ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
    //         ServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
    //         ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //         ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //         ServiceHistory.Modify;
    //     end;
    // end;

    procedure RecommendEmployeeActivity(EmpActCode: Code[20])
    var
        EmpAct: Record "Employee Activity";
    begin
        EmpAct.Get(EmpActCode);
        EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Pending);
        CheckEmployeeActivityApproval(EmpAct);
        EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Recommended);
        EmpAct.Modify;
        Message('The document has been recommended.');
    end;

    procedure RecommendEmployeeActivityAPI(EmpActCode: Code[20]; employeeNo: Code[20])
    var
        EmpAct: Record "Employee Activity";
    begin
        EmpAct.Get(EmpActCode);
        EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Pending);
        CheckEmployeeActivityApprovalAPI(EmpAct, employeeNo);
        EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Recommended);
        EmpAct.Modify;
        Message('The document has been recommended.');
    end;

    // local procedure AddLeaveAttachment(EmpActNo: Code[20]; EmpNo: Code[20]; LeaveCode: Code[20])
    // var
    //     TempIncomingDoc: Record "Incoming Document";
    //     AttachmentSetup: Record "Attachment Setup";
    // begin
    //     TempIncomingDoc.Reset;
    //     TempIncomingDoc.SetRange("Employee Code", EmpNo);
    //     TempIncomingDoc.SetRange("Leave Type Code", LeaveCode);
    //     TempIncomingDoc.SetRange("No.", '');
    //     if TempIncomingDoc.Find('-') then
    //         repeat
    //             AttachmentSetup.Reset;
    //             AttachmentSetup.SetRange("Attachment Code", TempIncomingDoc."Attachment Code");
    //             AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
    //             AttachmentSetup.SetRange("Leave Type Code", TempIncomingDoc."Leave Type Code");
    //             if AttachmentSetup.FindFirst then begin
    //                 if AttachmentSetup.Mandatory then
    //                     if TempIncomingDoc."File Name" = '' then      //attachment mandatory for leave
    //                         Error('Attachment must be uploaded');
    //             end;
    //             TempIncomingDoc.Validate("No.", EmpActNo);
    //             TempIncomingDoc.Modify;
    //         until TempIncomingDoc.Next = 0;
    // end;

    // procedure ApplyForLeave(Leave: Record "Leave" temporary): Boolean
    // var
    //     leaveMgt: Codeunit "Leave Mgt.";
    //     Leavevar: Record "Leave";
    //     ConfirmLeave: Label 'Do you want to send leave request ?';
    //     ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     LeaveTable: Record "Leave";
    //     LeaveRequestError: Label 'Your leave request no. %1 of code %2 has not been approved. Please make sure it is approved';
    // begin
    //     LeaveTypeSetup.Get(Leave."Leave Code");
    //     LeaveTable.Reset;
    //     LeaveTable.SetRange("Employee No.", Leave."Employee No.");
    //     LeaveTable.SetRange(Type, LeaveTable.Type::"Leave Request");
    //     LeaveTable.SetRange("Leave Code", LeaveTypeSetup.Code);
    //     LeaveTable.SetFilter("Approval Status", '%1|%2|%3', LeaveTable."Approval Status"::Recommended, LeaveTable."Approval Status"::Pending, LeaveTable."Approval Status"::Open);
    //     if LeaveTable.FindFirst then
    //         Error(LeaveRequestError, LeaveTable."No.", LeaveTable."Leave Code");
    //     if GuiAllowed then begin
    //         if not Confirm(ConfirmLeave, false) then
    //             exit;
    //     end else begin
    //         leaveMgt.CheckForLimitDays(Leave."Leave Code", Leave."No. of Days");
    //         if not LeaveTypeSetup.Compensatory then
    //             leaveMgt.CheckLeaveConflict(Leave."Employee No.", Leave."Start Date", Leave."End Date");
    //         leaveMgt.CheckForLeaveCriteria(Leave."Leave Code", Leave."Start Date", Leave."End Date", Leave."Employee No.", Leave."No. of Days");
    //         leaveMgt.CheckForMulipleRequest(Leave."Leave Code", Leave."Employee No.", Leave."Start Date", Leave."End Date", Leave."No. of Days");
    //     end;


    //     PayrollSetup.Get;
    //     //check for fisal year start date
    //     if (Leave."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date") or
    //       (Leave."End Date" > PayrollSetup."Payroll Fiscal Year End Date") then
    //         Error('Leave Start date must be within %1 - %2', PayrollSetup."Payroll Fiscal Year Start Date", PayrollSetup."Payroll Fiscal Year End Date");

    //     //Bereavement Leave
    //     if LeaveTypeSetup."Bereavement Leave" then
    //         Leave.TestField("For Death Of");
    //     //maternity and paternity leave
    //     if LeaveTypeSetup."Maternity/Paternity Leave" then
    //         Leave.TestField("Child's Gender");
    //     Leave.TestField("Start Date");
    //     Leave.TestField("End Date");
    //     Leave.TestField(Remarks);
    //     if Leave."No. of Days" <= 0 then
    //         Error(ErrorNoOfDays);
    //     Leave.TestField("Leave Code");

    //     //IF NOT CheckForCompensatory(TempEmpAct."Leave Code",TempEmpAct."Employee No.",TempEmpAct."Compensatory Date",TempEmpAct."No. of Days") THEN //Min 12.19.2022 -- Commented,Compensatory Leave route through OT Lines.
    //     leaveMgt.CheckRemainingLeaveDays(Leave."Leave Code", Leave."Employee No.", Leave."No. of Days");

    //     leaveMgt.CheckDependability(Leave."Leave Code", Leave."Employee No.");
    //     leaveMgt.CheckForEmployeeLimit(Leave."Leave Code", Leave."Employee No.");
    //     Leavevar.Init;
    //     Leavevar.TransferFields(Leave);
    //     Leavevar.TestField("Approver Code");
    //     if Leavevar."Recommender Code" <> '' then
    //         Leavevar.Validate("Approval Status", Leavevar."Approval Status"::Pending)
    //     else
    //         Leavevar.Validate("Approval Status", Leavevar."Approval Status"::Recommended);
    //     Leavevar.Validate("User ID", UserId);

    //     Leavevar.Insert(true);
    //     leaveMgt.AddLeaveAttachment(Leavevar."No.", Leavevar."Employee No.", Leavevar."Leave Code");
    //     SendMailFromTemplate(DATABASE::"Employee Activity", Leavevar.Type::"Leave Request", Leavevar."Approval Status"::Open, '', Leavevar."Employee No.", Leavevar."No.", 0);   //For email

    //     exit(true);
    // end;

    // // procedure CreateLeaveEarnContract(Employee: Record Employee)
    // // var
    // //     TempLeaveEarn: Record "Leave Earn" temporary;
    // //     LeaveEarn: Record "Leave Earn";
    // // begin
    // //     Employee.TestField("Employment Type", Employee."Employment Type"::Contract);
    // //     Employee.TestField("Employment Date");

    // //     if not Confirm('Do you want to add leave balance for contract employee ?', false) then
    // //         exit;
    // //     /*LeaveEarn.RESET;
    // //     LeaveEarn.SETRANGE(EmpNo,"No.");
    // //     LeaveEarn.SETRANGE("Fiscal year",ReturnFiscalYear(TODAY));
    // //     LeaveEarn.SETRANGE(Type,LeaveEarn.Type::Earned);
    // //     IF LeaveEarn.FINDFIRST THEN
    // //       ERROR('Leave Earn has already been carried out for this fiscal year');
    // //       */
    // //     TempLeaveEarn.Init;
    // //     TempLeaveEarn.Validate(EmpNo, Employee."No.");
    // //     TempLeaveEarn.Insert;
    // //     PAGE.RunModal(60238, TempLeaveEarn);

    // // end;

    local procedure "--travel"()
    begin
    end;

    // procedure OpenTravelRequest(EmpCode: Code[20]; ToExtend: Boolean; TravelNo: Code[20])
    // var
    //     EmpAct: Record "Employee Activity" temporary;
    //     EmpAct2: Record "Employee Activity";
    // begin
    //     EmpAct.Init;
    //     EmpAct.Validate("Employee No.", EmpCode);
    //     EmpAct.Validate("Functional Title", Employee."Functional Title");
    //     EmpAct.Validate(Type, EmpAct.Type::"Travel Request");
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Open);
    //     EmpAct.Validate("Requested Date", Today);
    //     Employee.Get(EmpCode);
    //     EmpAct.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
    //     EmpAct.Validate(Department, Employee."Department Code");
    //     if ToExtend then begin
    //         Clear(EmpAct2);
    //         EmpAct2.Get(TravelNo);
    //         EmpAct.Validate("Travel Order No.", TravelNo);
    //         EmpAct.Validate("Start Date", EmpAct2."End Date" + 1);
    //     end;
    //     EmpAct.Insert;
    //     PAGE.Run(PAGE::"Travel Request Form", EmpAct);
    // end;

    // procedure CalcExtendDays(NoOfDays: Decimal; TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    // begin
    //     if EmpAct.Get(TravelOrderNo) then
    //         exit(EmpAct."Total No. of Days");
    // end;

    // procedure ApplyForTravel(TravelReq: Record "Travel Request" temporary): Boolean
    // var
    //     TravelRequest: Record "Travel Request";
    //     ConfirmTravel: Label 'Do you want to send travel request ?';
    //     ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
    //     TravelRequest2: Record "Travel Request";
    //     Date: Record Date;
    // begin
    //     if GuiAllowed then
    //         if not Confirm(ConfirmTravel, false) then
    //             exit;
    //     TravelReq.TestField("Start Date");
    //     TravelReq.TestField("End Date");
    //     //TempEmpAct.TESTFIELD("Travel Countries");
    //     TravelReq.TestField("Type Of Visit");
    //     TravelReq.TestField("Depature Time");
    //     TravelReq.TestField("Arrival Time");
    //     TravelReq.TestField("Depature From");
    //     TravelReq.TestField(Destination);
    //     TravelReq.TestField("Purpose of Travel");
    //     //CheckLeaveConflict(TempEmpAct."Employee No.",TempEmpAct."Start Date",TempEmpAct."End Date");

    //     TravelRequest.Reset;
    //     TravelRequest.SetRange("Employee No.", TravelReq."Employee No.");
    //     TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Request");
    //     TravelRequest.SetFilter("Approval Status", '<>%1', TravelRequest."Approval Status"::Rejected);
    //     TravelRequest.SetRange("Cancelled No.", '');
    //     TravelRequest.SetRange(Cancelled, false);
    //     TravelRequest.FilterGroup(-1);
    //     TravelRequest.SetRange("Start Date", TravelReq."Start Date", TravelReq."End Date");
    //     TravelRequest.SetRange("End Date", TravelReq."Start Date", TravelReq."End Date");
    //     TravelRequest.FilterGroup(0);

    //     if TravelRequest.Count <> 0 then
    //         Error('Travel request has already been requested between %1 to %2', TravelReq."Start Date", TravelReq."End Date");

    //     if TravelReq."No. of Days" <= 0 then
    //         Error(ErrorNoOfDays);

    //     TravelRequest.Init;
    //     TravelRequest.TransferFields(TravelReq);
    //     TravelRequest.TestField("Approver Code");
    //     TravelRequest.Validate("Total No. of Days", TravelRequest."No. of Days" + CalcExtendDays(TravelRequest."No. of Days", TravelRequest."Travel Order No."));
    //     //api>>
    //     if not GuiAllowed then
    //         if TravelRequest."Advance Cash" > 0 then
    //             TravelRequest."Advance Cash Required" := true;
    //     //<<api



    //     if TravelRequest."Recommender Code" = '' then
    //         TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Recommended)
    //     else
    //         TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Pending);
    //     TravelRequest.Validate("User ID", UserId);
    //     TravelRequest.Insert(true);
    //     if not (TravelReq."Travel Order No." = '') then begin
    //         TravelRequest2.Get(TravelReq."Travel Order No.");
    //         TravelRequest2.TestField("Approval Status", TravelRequest2."Approval Status"::Approved);
    //         if TravelRequest2.Extended then
    //             Error('Travel order no. %1 has already been extended.', TravelRequest2."No.");
    //         TravelRequest2.Validate(Extended, true);
    //         TravelRequest2.Modify;
    //     end;
    //     SendMailFromTemplate(DATABASE::"Employee Activity", TravelRequest.Type::"Travel Request", TravelRequest."Approval Status"::Open, '', TravelRequest."Employee No.", TravelRequest."No.", 0);   //For email
    //     Message('Travel Request has been sent for apporval.');
    //     exit(true);
    // end;

    // procedure CheckLodgingAmtNepal(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWith: Code[20])
    // var
    //     SalaryLevel: Record "Salary Level";
    //     ErrorLodgingError: Label 'Lodging Amount cannot be greater than %1.';
    //     SalaryLevel1: Record "Salary Level";
    // begin
    //     Employee.Get(Empcode);
    //     SalaryLevel.Get(Employee."Salary Level");

    //     if Employee1.Get(TravelWith) then;
    //     if not SalaryLevel."Travel With Not Eligible" then
    //         if SalaryLevel1.Get(Employee1."Salary Level") then;
    //     if TravelWith <> '' then begin//AT

    //         if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin
    //             if SalaryLevel1."Nepal Lodging Allowance" * NoOfDays < Amt then
    //                 Error(ErrorLodgingError, SalaryLevel1."Nepal Lodging Allowance" * NoOfDays);
    //         end
    //         else
    //             if SalaryLevel."Nepal Lodging Allowance" * NoOfDays < Amt then
    //                 Error(ErrorLodgingError, SalaryLevel."Nepal Lodging Allowance" * NoOfDays);
    //     end else
    //         if SalaryLevel."Nepal Lodging Allowance" * NoOfDays < Amt then
    //             Error(ErrorLodgingError, SalaryLevel."Nepal Lodging Allowance" * NoOfDays);
    // end;

    // procedure CheckFoodingAmtNepal(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWithEmp: Code[20])
    // var
    //     SalaryLevel: Record "Salary Level";
    //     ErrorFoodingError: Label 'Fooding Amount cannot be greater than %1.';
    //     SalaryLevel1: Record "Salary Level";
    // begin
    //     Employee.Get(Empcode);
    //     SalaryLevel.Get(Employee."Salary Level");
    //     if Employee1.Get(TravelWithEmp) then//AT
    //         if not SalaryLevel."Travel With Not Eligible" then
    //             if SalaryLevel1.Get(Employee1."Salary Level") then;
    //     if TravelWithEmp <> '' then begin

    //         if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin
    //             if SalaryLevel1."Nepal Fooding Allowance" * NoOfDays < Amt then
    //                 Error(ErrorFoodingError, SalaryLevel1."Nepal Fooding Allowance" * NoOfDays);
    //         end
    //         else
    //             if SalaryLevel."Nepal Fooding Allowance" * NoOfDays < Amt then
    //                 Error(ErrorFoodingError, SalaryLevel."Nepal Fooding Allowance" * NoOfDays);
    //     end
    //     else
    //         if SalaryLevel."Nepal Fooding Allowance" * NoOfDays < Amt then
    //             Error(ErrorFoodingError, SalaryLevel."Nepal Fooding Allowance" * NoOfDays);
    // end;

    // procedure CheckLodgingAmtIndia(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWith: Code[20])
    // var
    //     SalaryLevel: Record "Salary Level";
    //     ErrorLodgingError: Label 'Lodging Amount cannot be greater than %1.';
    //     SalaryLevel1: Record "Salary Level";
    // begin
    //     Employee.Get(Empcode);
    //     SalaryLevel.Get(Employee."Salary Level");
    //     if TravelWith <> '' then begin//AT
    //         Employee1.Get(TravelWith);
    //         if not SalaryLevel."Travel With Not Eligible" then
    //             SalaryLevel1.Get(Employee1."Salary Level");
    //         if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin
    //             if SalaryLevel1."India Lodging Allowance" * NoOfDays < Amt then
    //                 Error(ErrorLodgingError, SalaryLevel1."India Lodging Allowance" * NoOfDays);
    //         end
    //         else
    //             if SalaryLevel."India Lodging Allowance" * NoOfDays < Amt then
    //                 Error(ErrorLodgingError, SalaryLevel."India Lodging Allowance" * NoOfDays);
    //     end
    //     else begin
    //         if SalaryLevel."India Lodging Allowance" * NoOfDays < Amt then
    //             Error(ErrorLodgingError, SalaryLevel."India Lodging Allowance" * NoOfDays);
    //     end;
    // end;

    // procedure CheckFoodingAmtIndia(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWithEmp: Code[20])
    // var
    //     SalaryLevel: Record "Salary Level";
    //     ErrorFoodingError: Label 'Fooding Amount cannot be greater than %1.';
    //     SalaryLevel1: Record "Salary Level";
    // begin
    //     Employee.Get(Empcode);
    //     SalaryLevel.Get(Employee."Salary Level");
    //     if TravelWithEmp <> '' then begin
    //         if Employee1.Get(TravelWithEmp) then//AT
    //             if not SalaryLevel."Travel With Not Eligible" then
    //                 SalaryLevel1.Get(Employee1."Salary Level");
    //         if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin
    //             if SalaryLevel1."India Fooding Allowance" * NoOfDays < Amt then
    //                 Error(ErrorFoodingError, SalaryLevel1."India Fooding Allowance" * NoOfDays);
    //         end
    //         else
    //             if SalaryLevel."India Fooding Allowance" * NoOfDays < Amt then
    //                 Error(ErrorFoodingError, SalaryLevel."India Fooding Allowance" * NoOfDays);
    //     end
    //     else begin
    //         if SalaryLevel."India Fooding Allowance" * NoOfDays < Amt then
    //             Error(ErrorFoodingError, SalaryLevel."India Fooding Allowance" * NoOfDays);
    //     end;
    // end;

    local procedure "-----Travel Claimed-----"()
    begin
    end;

    // procedure OpenTravelClaimed(EmpCode: Code[20]; TravelOrderNo: Code[20]; TravelWith: Code[20]; TravelCountry: Option Nepal,India,"Other Countries")
    // var
    //     EmpAct: Record "Employee Activity" temporary;
    //     SalaryLevel: Record "Salary Level";
    //     Employee1: Record Employee;
    //     SalaryLevel1: Record "Salary Level";
    //     EmpAct2: Record "Employee Activity";
    // begin
    //     EmpAct.Init;
    //     Employee.Get(EmpCode);
    //     SalaryLevel.Get(Employee."Salary Level");
    //     if TravelWith <> '' then begin//AT
    //         Employee1.Get(TravelWith);
    //         if not SalaryLevel."Travel With Not Eligible" then
    //             SalaryLevel1.Get(Employee1."Salary Level");
    //     end;
    //     EmpAct2.Get(TravelOrderNo);
    //     EmpAct.TransferFields(EmpAct2);
    //     EmpAct."No." := '';
    //     EmpAct.Validate("Employee No.", EmpCode);
    //     EmpAct.Validate("Functional Title", Employee."Functional Title");
    //     EmpAct.Validate(Type, EmpAct.Type::"Travel Claim");
    //     EmpAct.Validate("Travel Countries", TravelCountry);
    //     EmpAct.Validate("Claimed Country", Format(TravelCountry));
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Open);
    //     EmpAct.Validate("Start Date", GetTravelStartDate(TravelOrderNo));
    //     EmpAct.Validate("End Date", GetTravelEndDate(TravelOrderNo));
    //     EmpAct.Validate("Requested Date", Today);
    //     EmpAct.Validate("Travel Order No.", TravelOrderNo);
    //     EmpAct.Validate("No. of Days", CalculateTotalNoDays(TravelOrderNo));
    //     EmpAct."Travel With" := TravelWith;
    //     //EmpAct.VALIDATE("Claimed Country", );
    //     EmpAct.Validate("Estimated Conveyance Expense", CalculateTotalEstimatedConv(TravelOrderNo));
    //     EmpAct.Validate("Estimated Fooding Cost", CalculateTotalFooding(TravelOrderNo));
    //     EmpAct.Validate("Estimated Lodging Cost", CalculateTotalLodging(TravelOrderNo));
    //     EmpAct.Validate("Estimated Transportation Cost", CalculateTotalTransport(TravelOrderNo));
    //     EmpAct.Validate("Other Estimated Cost", CalculateTotalOtherExpense(TravelOrderNo));
    //     EmpAct.Validate("Total Estimated Cost", CalculateTotalEstimatedCost(TravelOrderNo));
    //     EmpAct.Validate("Advance Cash", CalculateTotalAdvance(TravelOrderNo));
    //     if EmpAct."Travel Countries" = EmpAct."Travel Countries"::Nepal then begin
    //         if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin//AT
    //             EmpAct.Validate("Fooding Allowance", SalaryLevel1."Nepal Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Allowance Limit", SalaryLevel1."Nepal Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Per Day Limit", SalaryLevel1."Nepal Fooding Allowance");
    //         end else begin
    //             EmpAct.Validate("Fooding Allowance", SalaryLevel."Nepal Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Allowance Limit", SalaryLevel."Nepal Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Per Day Limit", SalaryLevel."Nepal Fooding Allowance");
    //         end;
    //         if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin//AT
    //             EmpAct.Validate("Lodging Allowance", SalaryLevel1."Nepal Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Allowance Limit", SalaryLevel1."Nepal Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Per Day Limit", SalaryLevel1."Nepal Lodging Allowance");
    //         end else begin
    //             EmpAct.Validate("Lodging Allowance", SalaryLevel."Nepal Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Allowance Limit", SalaryLevel."Nepal Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Per Day Limit", SalaryLevel."Nepal Lodging Allowance");
    //         end;
    //     end
    //     else if EmpAct."Travel Countries" = EmpAct."Travel Countries"::India then begin
    //         if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin//AT
    //             EmpAct.Validate("Fooding Allowance", SalaryLevel1."India Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Allowance Limit", SalaryLevel1."India Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Per Day Limit", SalaryLevel1."India Fooding Allowance");

    //         end else begin
    //             EmpAct.Validate("Fooding Allowance", SalaryLevel."India Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Allowance Limit", SalaryLevel."India Fooding Allowance" * EmpAct."No. of Days");
    //             EmpAct.Validate("Fooding Per Day Limit", SalaryLevel."India Fooding Allowance");

    //         end;
    //         if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin//AT
    //             EmpAct.Validate("Lodging Allowance", SalaryLevel1."India Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Allowance Limit", SalaryLevel1."India Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Per Day Limit", SalaryLevel1."India Lodging Allowance");

    //         end else begin
    //             EmpAct.Validate("Lodging Allowance", SalaryLevel."India Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Allowance Limit", SalaryLevel."India Lodging Allowance" * (EmpAct."No. of Days" - 1));
    //             EmpAct.Validate("Lodging Per Day Limit", SalaryLevel."India Lodging Allowance");

    //         end;
    //     end;
    //     EmpAct."Arrival Time" := GetArrivalTime(TravelOrderNo);
    //     EmpAct."Depature Time" := GetDepatureTime(TravelOrderNo);
    //     EmpAct."Actual Travel Start Date" := GetTravelStartDate(TravelOrderNo);
    //     EmpAct."Actual Travel End Date" := GetTravelEndDate(TravelOrderNo);
    //     EmpAct."Actual Travel Start Time" := GetDepatureTime(TravelOrderNo);
    //     EmpAct."Actual Travel End Time" := GetArrivalTime(TravelOrderNo);
    //     EmpAct.Validate("Out of Pocket Expense", (SalaryLevel."Out of Pocket Expense" *
    //           GetOutofExpneseDuration(EmpAct."Actual Travel Start Time", EmpAct."Actual Travel End Time", EmpAct."Start Date", EmpAct."End Date")));

    //     if EmpAct."Advance Cash" <> 0 then
    //         EmpAct."Advance Cash Required" := true;
    //     EmpAct.Insert;
    //     PAGE.RunModal(PAGE::"Request Travel Claim", EmpAct);
    // end;

    // procedure CalculateTotalNoDays(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalNoDays(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."No. of Days");
    //     end;
    // end;

    // procedure CalculateTotalEstimatedConv(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalEstimatedConv(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."Estimated Conveyance Expense");
    //     end;
    // end;

    // procedure CalculateTotalFooding(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalFooding(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."Estimated Fooding Cost");
    //     end;
    // end;

    // procedure CalculateTotalAdvance(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalAdvance(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."Advance Cash");
    //     end;
    // end;

    // procedure CalculateTotalLodging(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalLodging(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."Estimated Lodging Cost");
    //     end;
    // end;

    // procedure CalculateTotalOtherExpense(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalOtherExpense(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."Other Estimated Cost");
    //     end;
    // end;

    // procedure CalculateTotalTransport(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalTransport(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."Estimated Transportation Cost");
    //     end;
    // end;

    // procedure CalculateTotalEstimatedCost(TravelOrderNo: Code[20]): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     AdvAmt: Decimal;
    // begin
    //     Clear(AdvAmt);
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             AdvAmt := CalculateTotalEstimatedCost(EmpAct."Travel Order No.");
    //         exit(AdvAmt + EmpAct."Total Estimated Cost");
    //     end;
    // end;

    // procedure GetTravelStartDate(TravelOrderNo: Code[20]): Date
    // var
    //     EmpAct: Record "Employee Activity";
    // begin
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             exit(GetTravelStartDate(EmpAct."Travel Order No."))
    //         else
    //             exit(EmpAct."Start Date");
    //     end;
    // end;

    // procedure GetTravelEndDate(TravelOrderNo: Code[20]): Date
    // var
    //     EmpAct: Record "Employee Activity";
    // begin
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         exit(EmpAct."End Date");
    //     end;
    // end;

    // procedure GetOutofExpneseDuration(DepatureTime: Time; ArrivalTime: Time; DepartureDate: Date; ArrivalDate: Date): Decimal
    // var
    //     EmpAct: Record "Employee Activity";
    //     Duration1: Duration;
    //     Duration2: Duration;
    //     TotalDuration: Decimal;
    //     NoofDays: Integer;
    // begin
    //     if (DepartureDate = 0D) or (ArrivalDate = 0D) then
    //         exit;
    //     HRSetup.Get;
    //     //Duration1 :=(CREATEDATETIME(TODAY,0T) - CREATEDATETIME(TODAY-1,DepatureTime));
    //     //Duration2 := (CREATEDATETIME(TODAY,ArrivalTime) - (CREATEDATETIME(TODAY,0T)));
    //     TotalDuration := (CreateDateTime(ArrivalDate, ArrivalTime) - CreateDateTime(DepartureDate, DepatureTime)) / 1000 / 60 / 60;

    //     NoofDays := Round(TotalDuration / 24, 1, '<');

    //     TotalDuration := TotalDuration mod 24;

    //     if TotalDuration >= HRSetup."Full Limit (out expense)" then
    //         exit(NoofDays + HRSetup."Full Limit Value")
    //     else if TotalDuration >= HRSetup."Half Limit (out expense)" then
    //         exit(NoofDays + HRSetup."Half Limit Value")
    //     else
    //         exit(NoofDays);
    // end;

    // procedure GetDepatureTime(TravelOrderNo: Code[20]): Time
    // var
    //     EmpAct: Record "Employee Activity";
    // begin
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         if not (EmpAct."Travel Order No." = '') then
    //             exit(GetDepatureTime(EmpAct."Travel Order No."))
    //         else
    //             exit(EmpAct."Depature Time");
    //     end;
    // end;

    // procedure GetArrivalTime(TravelOrderNo: Code[20]): Time
    // var
    //     EmpAct: Record "Employee Activity";
    // begin
    //     if EmpAct.Get(TravelOrderNo) then begin
    //         exit(EmpAct."Arrival Time");
    //     end;
    // end;

    // procedure ApplyForTravelClaim(TravelReq: Record "Travel Request" temporary): Boolean
    // var
    //     TravelRequest: Record "Travel Request";
    //     ConfirmTravel: Label 'Do you want to send travel request ?';
    //     ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
    //     TravelRequest2: Record "Travel Request";
    //     SalaryLevel1: Record "Salary Level";
    //     SalaryLevel: Record "Salary Level";
    // begin
    //     if GuiAllowed then
    //         if not Confirm(ConfirmTravel, false) then
    //             exit(false);
    //     TravelReq.TestField("Start Date");
    //     TravelReq.TestField("End Date");
    //     TravelReq.TestField("Claim Type");
    //     if TravelRequest2.Get(TravelReq."Travel Order No.") then
    //         if (TravelRequest2."Travel Claimed") then
    //             Error('Travel order no. %1 has already been claimed.', TravelRequest2."No.");

    //     TravelReq.TestField("Purpose of Travel");
    //     if TravelReq."No. of Days" <= 0 then
    //         Error(ErrorNoOfDays);
    //     Employee.Get(TravelReq."Employee No.");
    //     Clear(TravelRequest);
    //     SalaryLevel.Get(Employee."Salary Level");
    //     if TravelReq."Travel With" <> '' then begin//AT
    //         Employee1.Get(TravelReq."Travel With");
    //         if not SalaryLevel."Travel With Not Eligible" then
    //             SalaryLevel1.Get(Employee1."Salary Level");
    //     end;


    //     TravelRequest.Init;
    //     TravelRequest.TransferFields(TravelReq);
    //     TravelRequest.Validate("Travel With", TravelRequest2."Travel With");
    //     TravelRequest.Validate("Type Of Visit", TravelRequest2."Type Of Visit");
    //     TravelRequest.Validate(Destination, TravelRequest2.Destination);
    //     TravelRequest.Validate("Depature From", TravelRequest2."Depature From");
    //     TravelRequest.Validate(Description, TravelRequest2.Description);
    //     TravelRequest.Validate("Mode Of Travel", TravelRequest2."Mode Of Travel");
    //     TravelRequest.Validate("Estimated Conveyance Expense", CalculateTotalEstimatedConv(TravelRequest2."No."));
    //     TravelRequest.Validate("Estimated Fooding Cost", CalculateTotalFooding(TravelRequest2."No."));
    //     TravelRequest.Validate("Estimated Lodging Cost", CalculateTotalLodging(TravelRequest2."No."));
    //     TravelRequest.Validate("Estimated Transportation Cost", CalculateTotalTransport(TravelRequest2."No."));
    //     TravelRequest.Validate("Total Estimated Cost", CalculateTotalEstimatedCost(TravelRequest2."No."));
    //     TravelRequest.Validate("Other Estimated Cost", CalculateTotalOtherExpense(TravelRequest2."No."));

    //     if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::Nepal then begin
    //         if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin//AT
    //             TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."Nepal Fooding Allowance" * TravelRequest."No. of Days");
    //             TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."Nepal Fooding Allowance");
    //         end else begin
    //             TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."Nepal Fooding Allowance" * TravelRequest."No. of Days");
    //             TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."Nepal Fooding Allowance");
    //         end;
    //         if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin//AT
    //             TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
    //             TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."Nepal Lodging Allowance");
    //         end else begin
    //             TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
    //             TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."Nepal Lodging Allowance");
    //         end;
    //     end
    //     else if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::India then begin
    //         if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin//AT
    //             TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."India Fooding Allowance" * TravelRequest."No. of Days");
    //             TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."India Fooding Allowance");

    //         end else begin
    //             TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."India Fooding Allowance" * TravelRequest."No. of Days");
    //             TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."India Fooding Allowance");

    //         end;
    //         if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin//AT
    //             TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
    //             TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."India Lodging Allowance");

    //         end else begin
    //             TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
    //             TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."India Lodging Allowance");

    //         end;
    //     end;

    //     HRSetup.Get;
    //     Employee1.Reset;
    //     Employee1.SetRange("Functional Title", HRSetup."HR Head Functional Title");
    //     Employee1.SetRange(Status, Employee1.Status::Active); //Min
    //     if Employee1.FindFirst then
    //         TravelRequest.Validate("Final Approver", Employee1."No.");

    //     TravelRequest.Validate("Requested Date", Today);
    //     TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Pending);
    //     TravelRequest.Validate("User ID", UserId);
    //     TravelRequest.TestField("Approver Code");
    //     if TravelRequest."Recommender Code" = '' then
    //         TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Recommended)
    //     else
    //         TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Pending);
    //     TravelRequest.Validate("Total Claimed Amount");
    //     TravelRequest.Insert(true);
    //     SendMailFromTemplate(DATABASE::"Employee Activity", TravelRequest.Type::"Travel Claim", TravelRequest."Approval Status"::Open, '', TravelRequest."Employee No.", TravelRequest."No.", 0);   //For email
    //     Message('Travel Claim has been sent for apporval.');
    //     TravelRequest2."Travel Claimed" := true;
    //     TravelRequest2.Modify;
    //     exit(true);
    // end;

    // procedure FinalApprove(var EmpAct: Record "Employee Activity")
    // var
    //     ConfirmScreen: Label 'Do you want to confirm screen this document?';
    //     FunctionalTitle: Record "Functional Title";
    // begin
    //     //check authorized user
    //     if EmpAct.Type = EmpAct.Type::"Travel Claim" then begin
    //         HRSetup.Get;
    //         if Employee.Get(GetEmployeeNo) then;

    //         if Employee."No." <> EmpAct."Final Approver" then
    //             Error('Not authorized Approver.');//AT
    //         EmpAct.TestField(EmpAct."Approval Status", EmpAct."Approval Status"::Screened);
    //         if not Confirm('Do you want to final approve this document?', false) then
    //             exit;

    //         EmpAct.Validate("Approval Status", EmpAct."Approval Status"::"Final Approved & Forwarded to Finance Department");
    //         EmpAct.Modify;
    //     end;
    // end;

    // procedure FinalApproveForTravel(var Travel: Record "Travel Request")
    // var
    //     ConfirmScreen: Label 'Do you want to confirm screen this document?';
    //     FunctionalTitle: Record "Functional Title";
    // begin
    //     //check authorized user
    //     if Travel.Type = Travel.Type::"Travel Claim" then begin
    //         HRSetup.Get;
    //         if Employee.Get(GetEmployeeNo) then;

    //         if Employee."No." <> Travel."Final Approver" then
    //             Error('Not authorized Approver.');//AT
    //         Travel.TestField(Travel."Approval Status", Travel."Approval Status"::Screened);
    //         if not Confirm('Do you want to final approve this document?', false) then
    //             exit;

    //         Travel.Validate("Approval Status", Travel."Approval Status"::"Final Approved & Forwarded to Finance Department");
    //         Travel.Modify;
    //     end;
    // end;

    // procedure PopUpChangingApprover(EmployeeActivity: Record "Employee Activity")
    // var
    //     TravelClaimPageBuilder: FilterPageBuilder;
    //     EmpAct: Record "Employee Activity";
    // begin
    //     TravelClaimPageBuilder.AddRecord('Change Approver', EmpAct);
    //     TravelClaimPageBuilder.ADdField('Change Approver', EmpAct."Final Approver");
    //     if TravelClaimPageBuilder.RunModal then begin
    //         EmpAct.SetView(TravelClaimPageBuilder.GetView('Change Approver'));

    //         if EmpAct.GetFilter("Final Approver") = '' then
    //             Error('Approver Code cannot be blank.');

    //         EmployeeActivity.Validate("Final Approver", EmpAct.GetFilter("Final Approver"));
    //         EmployeeActivity.Modify;
    //         Message('Updated');
    //     end;
    // end;

    // procedure ReturnTravelClaim(EmpActivity: Record "Employee Activity")
    // var
    //     EmpActivityRec: Record "Employee Activity";
    // begin
    //     // TESTFIELD("Approval Status","Approval Status"::"Forwarded To HR");
    //     if EmpActivity."Approval Status" = EmpActivity."Approval Status"::"Final Approved & Forwarded to Finance Department" then
    //         Error('Cannot return approved docuement');
    //     Employee.Reset;
    //     Employee.SetRange("NAV Login ID", UserId);
    //     Employee.FindFirst;
    //     if not Employee.Screener then
    //         Error('You are not eligible to return this document.');
    //     if Confirm('Do you want to return travel claim?', false) then begin
    //         EmpActivity.Validate("Approval Status", EmpActivity."Approval Status"::Open);
    //         EmpActivityRec.Reset; //Min -- For re-initiate returned travel claim.
    //         EmpActivityRec.SetRange("No.", EmpActivity."Travel Order No.");
    //         EmpActivityRec.SetRange(Type, EmpActivity.Type::"Travel Request");
    //         if EmpActivityRec.FindFirst then begin
    //             EmpActivityRec."Travel Claimed" := false;
    //             EmpActivityRec.Modify;
    //         end;
    //         EmpActivity.Modify;
    //         Message('Travel Claimed Retruned.');
    //     end;
    // end;

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

    procedure LookupBranch(DimValueText: Text; Province: Text; SubProvince: Text): Text
    var
        // PageDimValue: Page "Dimension Values";
        // DimValue: Record "Dimension Value";
        // GLSetup: Record "General Ledger Setup";
        OrganizationStructureList: Record "Organization Structure List";
        OrganizationStructureListPage: Page "Organization Structure list";
    begin
        // OrganizationStructureList.Reset;
        // Clear(OrganizationStructureListPage);
        // OrganizationStructureList.FilterGroup(2);
        // OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Branch);
        // OrganizationStructureList.SetFilter(Province, Province);
        // OrganizationStructureList.SetFilter("Sub-Province", SubProvince);
        // OrganizationStructureList.FilterGroup(0);
        // OrganizationStructureListPage.AssignShowSelected;
        // OrganizationStructureListPage.InsertTempDimValue(DimValueText);
        // OrganizationStructureListPage.SetRecord(OrganizationStructureList);
        // OrganizationStructureListPage.SetTableView(OrganizationStructureList);
        // if OrganizationStructureListPage.RunModal = ACTION::OK then
        // exit(OrganizationStructureListPage.ReturnDimText);
    end;

    // procedure LookupDepartment(DepartText: Text): Text
    // var
    //     PageDepart: Page Departments;
    //     Depart: Record Department;
    // begin
    //     Depart.Reset;
    //     Clear(PageDepart);
    //     PageDepart.AssignShowSelected;
    //     PageDepart.InsertTempDepart(DepartText);
    //     PageDepart.SetRecord(Depart);
    //     PageDepart.SetTableView(Depart);
    //     if PageDepart.RunModal = ACTION::OK then
    //         exit(PageDepart.ReturnDepartText);
    // end;

    // procedure LookupSubProvinceTraining(SubProvText: Text; ProvText: Text): Text
    // var
    //     PageSubProv: Page "SubProvinceList";
    //     SubProv: Record "Sub Province";
    // begin
    //     SubProv.Reset;
    //     Clear(PageSubProv);
    //     SubProv.FilterGroup(2);
    //     SubProv.SetFilter("Province Code", ProvText);
    //     SubProv.FilterGroup(0);
    //     PageSubProv.AssignShowSelected;
    //     PageSubProv.InsertTempSubProv(SubProvText);
    //     PageSubProv.SetRecord(SubProv);
    //     PageSubProv.SetTableView(SubProv);
    //     if PageSubProv.RunModal = ACTION::OK then
    //         exit(PageSubProv.ReturnSubProvText);
    // end;

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

    procedure GetEmailReceipents(TraininNo: Code[20]): Text
    var
        TrainingLine: Record "Training Line";
        ReceipentText: Text;
    begin
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TraininNo);
        TrainingLine.SetRange(Type, TrainingLine.Type::Trainee);
        if TrainingLine.Find('-') then
            repeat
                Employee.Get(TrainingLine."Employee Code");
                if ReceipentText = '' then
                    ReceipentText := Employee."Company E-Mail"
                else
                    ReceipentText += ';' + Employee."Company E-Mail";
            until TrainingLine.Next = 0;
        exit(ReceipentText);
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
        //TrainLine.SETRANGE(Type,TrainLine.Type::Trainer);
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

    local procedure GetTrainingBody(var TrainHeader: Record "Training Header")
    var
        BodyText1: Text;
        TrainLine: Record "Training Line";
    begin
        BodyText1 := '<table style="width:100%">' +
               '<tr>' +
                 '<td><strong>' + TrainLine.FieldCaption(Name) + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("Trainer Date") + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("Name of Organization") + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("Start Time") + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("End Time") + '</strong></td>' +
               '</tr>';

        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainHeader."No.");
        TrainLine.SetRange(Type, TrainLine.Type::Trainer);
        if TrainLine.Find('-') then
            repeat
                BodyText1 += '<tr>' +
                                '<td>' + TrainLine.Name + '</td>' +
                                '<td>' + Format(TrainLine."Trainer Date") + '</td>' +
                                '<td>' + TrainLine."Name of Organization" + '</td>' +
                                '<td>' + Format(TrainLine."Start Time") + '</td>' +
                                '<td>' + Format(TrainLine."End Time") + '</td>' +
                              '</tr>';
            until TrainLine.Next = 0;
        BodyText1 += '</table>';

        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption(Description) + Colon + Format(TrainHeader.Description) + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption("Start Date") + Colon + Format(TrainHeader."Start Date") + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption("End Date") + Colon + Format(TrainHeader."End Date") + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption("Start Time") + Colon + Format(TrainHeader."Start Time") + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption(Venue) + Colon + Format(TrainHeader.Venue) + '<br>');
        CodeunitEmailMessage.AppendToBody('<br>' + BodyText1 + '<br>');
    end;

    local procedure GetTransferBody(var EmployeeActivity: Record "Employee Activity")
    var
        BodyText1: Text;
        TrainLine: Record "Training Line";
        ProvinceVar: Record Province;
        // SubProvinceVar: Record "Sub Province";
        // DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        // Depart: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        OrganizationStructureList: Record "Organization Structure List";
        FunctionalTitle: Record "Functional Title";
        Email: Codeunit Email;
        CodeunitEmailMessage: Codeunit "Email Message";
    begin
        // Clear(CodeunitEmailMessage);

        GLSetup.Get;
        //Outgoing Placement
        //CodeunitEmailMessage.AppendToBody(FIELDCAPTION("Employee No.") + Colon + "Employee No." + '<br>');
        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Employee Name") + Colon + EmployeeActivity."Employee Name" + '<br>');
        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Transfer Effective Date") + Colon + getDateinFormat(EmployeeActivity."Transfer Effective Date") + '<br>');
        CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Transfer Category") + Colon + Format(EmployeeActivity."Transfer Category") + '<br>');
        if (EmployeeActivity."Start Date" <> 0D) and (EmployeeActivity."End Date" <> 0D) then begin //Min 12.9.2022 -- for cover general transfer
            CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("Start Date") + Colon + Format(EmployeeActivity."Start Date") + '<br>');
            CodeunitEmailMessage.AppendToBody(EmployeeActivity.FieldCaption("End Date") + Colon + Format(EmployeeActivity."End Date") + '<br>');
        end;
        /*IF EmployeeActivity."Transfer Category" IN //Min 12.9.2022 -- Commented
          [EmployeeActivity."Transfer Category"::Officiating,EmployeeActivity."Transfer Category"::"Temporary"] THEN BEGIN
          CodeunitEmailMessage.AppendToBody(FIELDCAPTION("Start Date") + Colon + FORMAT("Start Date") +'<br>');
          CodeunitEmailMessage.AppendToBody(FIELDCAPTION("End Date") + Colon + FORMAT("End Date") +'<br>');
        END;*/
        CodeunitEmailMessage.AppendToBody('<br><br>' + 'Current Placement ' + Colon + '<br>');

        CodeunitEmailMessage.AppendToBody('Deputation on' + Colon + Format(EmployeeActivity."Deputation On") + '<br>');
        Clear(OrganizationStructureList);
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::"Extension Counter", EmployeeActivity."Extension Counter Code") then
            CodeunitEmailMessage.AppendToBody('Extension Counter' + Colon + OrganizationStructureList.Name + '<br>');
        // EmpHie.SetRange(Code, EmployeeActivity."Extension Counter Code");
        // if EmpHie.FindFirst then
        // Clear(DimValue);
        if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, EmployeeActivity."Shortcut Dimension 1 Code") then
            CodeunitEmailMessage.AppendToBody('Branch' + Colon + OrganizationStructureList.Name + '<br>');

        // Clear(SubProvinceVar);
        // SubProvinceVar.SetRange(Code, EmployeeActivity."Sub Province Code");
        // if SubProvinceVar.FindFirst then
        //     CodeunitEmailMessage.AppendToBody('Sub Province' + Colon + SubProvinceVar.City + '<br>');

        // Clear(EmpHie);
        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::Unit);
        // EmpHie.SetRange(Code, EmployeeActivity."Unit Code");
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::unit, EmployeeActivity."Unit Code") then
            CodeunitEmailMessage.AppendToBody('Unit' + Colon + OrganizationStructureList.Name + '<br>');

        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::Department, EmployeeActivity.Department) then
            CodeunitEmailMessage.AppendToBody('Department' + Colon + OrganizationStructureList.Name + '<br>');

        Clear(ProvinceVar);
        if ProvinceVar.Get(EmployeeActivity."Province Code") then
            CodeunitEmailMessage.AppendToBody('Province' + Colon + ProvinceVar.Description + '<br>');


        Clear(FunctionalTitle);
        if FunctionalTitle.Get(EmployeeActivity."Functional Title") then
            CodeunitEmailMessage.AppendToBody('Functional Title' + Colon + FunctionalTitle.Description + '<br><br>');

        CodeunitEmailMessage.AppendToBody('Current Reporting Person<br>');
        Clear(Employee1);
        if Employee1.Get(EmployeeActivity."Outgoing Branch Rep. Person") then begin
            CodeunitEmailMessage.AppendToBody('Employee Name ' + Colon + Employee1."Full Name" + '<br>');
            CodeunitEmailMessage.AppendToBody('Employee No. ' + Colon + Employee1."No." + '<br>');
            Clear(FunctionalTitle);
            if FunctionalTitle.Get(Employee1."Functional Title") then
                CodeunitEmailMessage.AppendToBody('Functional title ' + Colon + FunctionalTitle.Description + '<br>');
        end;


        //Incoming Placement
        CodeunitEmailMessage.AppendToBody('<br>' + 'Reporting Placement ' + Colon + '<br>');
        CodeunitEmailMessage.AppendToBody('Deputation on' + Colon + Format(EmployeeActivity."Deputation On (To)") + '<br>');

        // Clear(EmpHie);
        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        // EmpHie.SetRange(Code, EmployeeActivity."Extension Counter (To)");
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::"Extension Counter", EmployeeActivity."Extension Counter (To)") then
            CodeunitEmailMessage.AppendToBody('Extension Counter' + Colon + OrganizationStructureList.Name + '<br>');

        // Clear(DimValue);
        // if DimValue.Get(GLSetup."Global Dimension 1 Code", EmployeeActivity."Shortcut Dimension 1 Code (To)") then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::Branch, EmployeeActivity."Shortcut Dimension 1 Code (To)") then
            CodeunitEmailMessage.AppendToBody('Branch' + Colon + OrganizationStructureList.Name + '<br>');

        // Clear(SubProvinceVar);
        // SubProvinceVar.SetRange(Code, EmployeeActivity."Sub Province Code (To)");
        // if SubProvinceVar.FindFirst then
        //     CodeunitEmailMessage.AppendToBody('Sub Province' + Colon + SubProvinceVar.City + '<br>');

        // Clear(EmpHie);
        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::Unit);
        // EmpHie.SetRange(Code, EmployeeActivity."Unit (To)");
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::unit, EmployeeActivity."Unit (To)") then
            CodeunitEmailMessage.AppendToBody('Unit' + Colon + OrganizationStructureList.Name + '<br>');

        // Clear(Depart);
        // if Depart.Get(EmployeeActivity."Department Code (To)") then
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::Department, EmployeeActivity."Department Code (To)") then
            CodeunitEmailMessage.AppendToBody('Department' + Colon + OrganizationStructureList.Name + '<br>');

        Clear(ProvinceVar);
        if ProvinceVar.Get(EmployeeActivity."Province Code (To)") then
            CodeunitEmailMessage.AppendToBody('Province' + Colon + ProvinceVar.Description + '<br>');

        Clear(FunctionalTitle);
        if FunctionalTitle.Get(EmployeeActivity."Functional Title (To)") then
            CodeunitEmailMessage.AppendToBody('Functional Title' + Colon + FunctionalTitle.Description + '<br><br>');

        CodeunitEmailMessage.AppendToBody('Incoming Reporting Person<br>');
        Clear(Employee1);
        if Employee1.Get(EmployeeActivity."Incoming Supervisior") then begin
            CodeunitEmailMessage.AppendToBody('Employee Name ' + Colon + Employee1."Full Name" + '<br>');
            CodeunitEmailMessage.AppendToBody('Employee No. ' + Colon + Employee1."No." + '<br>');
            Clear(FunctionalTitle);
            if FunctionalTitle.Get(Employee1."Functional Title") then
                CodeunitEmailMessage.AppendToBody('Functional title ' + Colon + FunctionalTitle.Description + '<br>');
        end;

    end;

    procedure CreateNewLine(): Text
    begin
        CodeunitEmailMessage.AppendToBody('<br><br>');
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

    local procedure "-----Transfer----"()
    begin
    end;

    // procedure OpenTransferRequest(EmpCode3: Code[20])
    // var
    //     EmpAct4: Record "Employee Activity" temporary;
    //     RequestError: Label 'You are not eligible to request for a transfer.';
    // begin
    //     Clear(Employee);
    //     Employee.Get(EmpCode3);
    //     Employee.TestField("Confirmation Date");
    //     if Today > CalcDate('<2Y>', Employee."Confirmation Date") then
    //         Error(RequestError);

    //     HRSetup.Get;
    //     Employee1.Reset;
    //     Employee1.SetRange("Functional Title", HRSetup."HR Head Functional Title");
    //     Employee1.SetRange(Status, Employee1.Status::Active); //Min
    //     if Employee.FindFirst then;
    //     EmpAct4.Init;
    //     EmpAct4.Validate(Type, EmpAct4.Type::"Employee Transfer");
    //     EmpAct4.Validate("Employee No.", EmpCode3);
    //     EmpAct4.Validate("Approval Status", EmpAct4."Approval Status"::Open);
    //     EmpAct4.Insert;
    //     PAGE.Run(PAGE::"Transfer Card", EmpAct4);
    // end;

    // procedure OpenOTForms(EmpCode: Code[20])
    // var
    //     EmpAct: Record "Employee Activity" temporary;
    //     SalaryLevel: Record "Salary Level";
    //     OTEligibleError: Label 'Employee %1 is not eligible for OT.';
    // begin
    //     Clear(Employee);
    //     Employee.Get(EmpCode);
    //     SalaryLevel.Get(Employee."Salary Level");
    //     if not SalaryLevel."OT Eligible" then
    //         Error(OTEligibleError, Employee.FullName);
    //     EmpAct.Init;
    //     EmpAct.Validate("Employee No.", EmpCode);
    //     EmpAct.Validate("Functional Title", Employee."Functional Title");
    //     EmpAct.Validate(Type, EmpAct.Type::Overtime);
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Open);
    //     EmpAct.Validate("Requested Date", Today);
    //     EmpAct.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
    //     EmpAct.Validate(Department, Employee."Department Code");
    //     EmpAct.Insert;
    //     PAGE.Run(PAGE::"Overtime Card", EmpAct);
    // end;

    // procedure OpenOutofOfficeForms(EmpCode: Code[20])
    // var
    //     EmpAct: Record "Employee Activity" temporary;
    // begin
    //     Clear(Employee);
    //     Employee.Get(EmpCode);
    //     EmpAct.Init;
    //     EmpAct.Validate("Employee No.", EmpCode);
    //     EmpAct.Validate("Functional Title", Employee."Functional Title");
    //     EmpAct.Validate(Type, EmpAct.Type::"Out of Office");
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Open);
    //     EmpAct.Validate("Requested Date", Today);
    //     EmpAct.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
    //     EmpAct.Validate(Department, Employee."Department Code");
    //     EmpAct.Insert;
    //     PAGE.Run(PAGE::"Overtime Card", EmpAct);
    // end;

    procedure OpenBulkCash(EmpCode: Code[20])
    var
        EmpAct: Record "Employee Activity" temporary;
    begin
        Clear(Employee);
        Employee.Get(EmpCode);
        EmpAct.Init;
        EmpAct.Validate("Employee No.", EmpCode);
        EmpAct.Validate(Type, EmpAct.Type::"Bulk Cash");
        EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Open);
        EmpAct.Validate("Requested Date", Today);
        EmpAct.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
        EmpAct.Validate("Functional Title", Employee."Functional Title");
        EmpAct.Validate(Department, Employee."Department Code");
        EmpAct.Insert;
        PAGE.Run(PAGE::"Bulk Cash Card", EmpAct);
    end;

    procedure ApplyForApprovalForms(TempEmpActivity: Record "Employee Activity" temporary): Boolean
    var
        EmpOvertime: Record "OverTime";
        EmpActivity: Record "Employee Activity";
        ConfirmForm: Label 'Do you want to send request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        EmpOvertime2: Record "Overtime";
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        SalaryLevel: Record "Salary Level";
    begin
        if GuiAllowed then
            if not Confirm(ConfirmForm, false) then
                exit;
        // TempEmpActivity.TestField("Start Date");
        // TempEmpActivity.TestField("End Date");
        // TempEmpActivity.TestField("Estimated Hours");
        //TempEmpAct.TESTFIELD(Remarks);
        // PayrollSetup.Get;
        // PayrollSetup.TestField("Friday Counter");
        // PayrollSetup.TestField("Holiday Counter");
        // PayrollSetup.TestField("Evening Counter");

        // case TempOvertime.Type of
        //     TempOvertime.Type::Overtime:
        //         begin
        //             EmpOvertime.Reset;
        //             EmpOvertime.SetRange(Type, EmpOvertime.Type::Overtime);
        //             EmpOvertime.SetRange("Employee No.", TempOvertime."Employee No.");
        //             EmpOvertime.SetRange("Start Date", TempOvertime."Start Date");
        //             EmpOvertime.SetFilter("Approval Status", '<>%1', TempOvertime."Approval Status"::Rejected); //Min 8.7.2022
        //             if EmpOvertime.FindFirst then
        //                 Error('Overtime already submitted for %1', TempOvertime."Start Date");

        //             AllowanceAssignmentLine.Reset;
        //             AllowanceAssignmentLine.SetRange("Employee Code", TempOvertime."Employee No.");
        //             AllowanceAssignmentLine.SetRange("From Date", TempOvertime."Start Date");
        //             AllowanceAssignmentLine.SetFilter("Allowance Type", '%1|%2|%3', PayrollSetup."Friday Counter",
        //                                               PayrollSetup."Evening Counter", PayrollSetup."Holiday Counter");
        //             AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
        //             if AllowanceAssignmentLine.FindFirst then
        //                 Error('%1 is already approved for the date %2. Overtime submission not allowed.',
        //                             AllowanceAssignmentLine."Allowance Type", TempOvertime."Start Date");
        //             if TempOvertime.Remarks = '' then
        //                 Error('Please enter reason for OT before submitting.');
        //         end;
        // end;

        // if TempOvertime."No. of Days" <= 0 then
        //     Error(ErrorNoOfDays);

        EmpActivity.Init;
        EmpActivity.TransferFields(TempEmpActivity);
        EmpActivity.Validate("Approval Status", TempEmpActivity."Approval Status"::Pending);
        EmpActivity.Validate("User ID", UserId);
        EmpActivity.Insert(true);
        // AddOvertimeAttachment(EmpOvertime."No.", EmpOvertime."Employee No.");
        Message('Document has been sent for apporval.');

        case EmpOvertime.Type of
            EmpOvertime.Type::"Out of Office":
                SendMailFromTemplate(DATABASE::"Employee Activity", EmpOvertime.Type::"Out of Office", EmpOvertime."Approval Status"::Open, '', EmpOvertime."Employee No.", EmpOvertime."No.", 0);   //For email
            EmpOvertime.Type::Overtime:
                SendMailFromTemplate(DATABASE::"Employee Activity", EmpOvertime.Type::Overtime, EmpOvertime."Approval Status"::Open, '', EmpOvertime."Employee No.", EmpOvertime."No.", 0);   //For email
            EmpOvertime.Type::"Bulk Cash":
                SendMailFromTemplate(DATABASE::"Employee Activity", EmpOvertime.Type::"Bulk Cash", EmpOvertime."Approval Status"::Open, '', EmpOvertime."Employee No.", EmpOvertime."No.", 0);   //For email
        end;
        exit(true);
    end;

    // procedure SendTransferApproval(TempEmphrtransfer: Record "Employee Transfer" temporary): Boolean
    // var
    //     EmphrTransfer: Record "Employee Transfer";
    //     ConfirmTransfer: Label 'Do you want to send transfer request ?';
    //     ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
    //     TransferSent: Label 'Transfer request approval has been sent.';
    //     NoRecommender: Label 'No Recommender Code.';
    //     NoApprover: Label 'No Approver Code.';
    //     IncomingDoc: Record "Incoming Document";
    //     AttachSetup: Record "Attachment Setup";
    // begin
    //     if not GuiAllowed then
    //         TempEmphrtransfer."Transfer Category" := TempEmphrtransfer."Transfer Category"::General;
    //     TempEmphrtransfer.TestField(Description);
    //     TempEmphrtransfer.TestField("Reason for Resignation"); //here reason for transfer
    //     TempEmphrtransfer.TestField("Transfer Category");

    //     if TempEmphrtransfer."Transfer Category" = TempEmphrtransfer."Transfer Category"::"Temporary" then begin
    //         TempEmphrtransfer.TestField("Start Date");
    //         TempEmphrtransfer.TestField("End Date");
    //     end;
    //     EmphrTransfer.Reset;
    //     EmphrTransfer.SetRange(Type, EmphrTransfer.Type::"HR Transfer");
    //     EmphrTransfer.SetFilter("Approval Status", '<>%1', EmphrTransfer."Approval Status"::Acknowledged);
    //     EmphrTransfer.SetRange("Employee No.", TempEmphrtransfer."Employee No.");
    //     EmphrTransfer.SetFilter("No.", '<>%1', TempEmphrtransfer."No.");
    //     if EmphrTransfer.FindFirst then
    //         Error('Transfer card of employee %1 is still open or pending.', EmphrTransfer."Employee Name");

    //     EmphrTransfer.Reset;
    //     EmphrTransfer.Init;
    //     EmphrTransfer.Validate("Requested Date", Today);
    //     EmphrTransfer.TransferFields(TempEmphrtransfer);
    //     EmphrTransfer.Validate("Approval Status", EmphrTransfer."Approval Status"::Pending);
    //     EmphrTransfer.Validate("User ID", UserId);
    //     Employee.Get(EmphrTransfer."Employee No.");
    //     //EmpAct.VALIDATE("Recommender Code", Employee."Approver Code");
    //     HRSetup.Get;
    //     HRSetup.TestField("HR Head Functional Title");
    //     HRSetup.TestField("HR Department Code");

    //     Employee.Reset;
    //     Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
    //     Employee.SetRange("Department Code", HRSetup."HR Department Code");
    //     Employee.SetRange(Status, Employee.Status::Active); //Min
    //     if Employee.FindFirst then
    //         EmphrTransfer.Validate("Approver Code", Employee."No.");
    //     if EmphrTransfer.Type = EmphrTransfer.Type::"Employee Transfer" then
    //         if EmphrTransfer."Recommender Code" = '' then
    //             Error(NoRecommender);
    //     if EmphrTransfer."Approver Code" = '' then
    //         Error(NoApprover);

    //     EmphrTransfer.Insert(true);

    //     SendMailFromTemplate(DATABASE::"Employee Activity", EmphrTransfer.Type::"Employee Transfer", EmphrTransfer."Approval Status"::Open, '', EmphrTransfer."Employee No.", EmphrTransfer."No.", 0);   //For email
    //     Message(TransferSent);
    //     exit(true);
    // end;

    // procedure RecommendTransfer(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    // begin
    //     if StrPos(EmpHrTransfer."Recommender Code", GetEmployeeNo) = 0 then
    //         Error('You are not eligible to recommend this document');
    //     EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Pending);
    //     EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
    //     EmpHrTransfer.Modify;
    //     Message('Document has been recommended');
    // end;
    // procedure RecommendTransferAPI(var EmpHrTransfer: Record "Employee Transfer"; employeeNo: Code[20])
    // begin
    //     // if StrPos(EmpHrTransfer."Recommender Code", employeeNo) = 0 then
    //     //     Error('You are not eligible to recommend this document');
    //     // EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Pending);
    //     // EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
    //     // EmpHrTransfer.Modify;
    //     // Message('Document has been recommended');
    // end;

    // procedure ReviewTransfer(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    // begin
    //     if EmpHrTransfer.Reviewer <> GetEmployeeNo then
    //         Error('You are not elibile to review this document');
    //     EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
    //     EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Reviewed);
    //     EmpHrTransfer.Modify;
    //     Message('Document has been reviewed.');
    // end;
    // procedure ReviewTransferAPI(var EmpHrTransfer: Record "Employee Transfer"; employeeNo: Code[20])
    // begin
    // if EmpHrTransfer.Reviewer <> employeeNo then
    //     Error('You are not elibile to review this document');
    // EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
    // EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Reviewed);
    // EmpHrTransfer.Modify;
    // Message('Document has been reviewed.');
    // end;

    // procedure ScreenTransfer(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    // begin
    //     EmpHrTransfer.TestField("Transfer Category");
    //     EmpHrTransfer.TestField("Transfer Effective Date");
    //     EmpHrTransfer.TestField("Functional Title (To)");
    //     EmpHrTransfer.TestField("Deputation On (To)");
    //     EmpHrTransfer.TestField(Description);
    //     EmpHrTransfer.TestField("Transfer Type");
    //     EmpHrTransfer.TestField("Reason for Resignation");
    //     EmpHrTransfer.TestField("Notify to"); //Min
    //     if EmpHrTransfer."Transfer Category" in [EmpHrTransfer."Transfer Category"::"Temporary", EmpHrTransfer."Transfer Category"::Officiating] then begin
    //         EmpHrTransfer.TestField("Start Date");
    //         EmpHrTransfer.TestField("End Date");
    //     end;
    //     Employee.Get(GetEmployeeNo);
    //     case EmpHrTransfer."Deputation On (To)" of
    //         EmpHrTransfer."Deputation On (To)"::Branch:
    //             EmpHrTransfer.TestField("Shortcut Dimension 1 Code (To)");
    //         EmpHrTransfer."Deputation On (To)"::Department:
    //             EmpHrTransfer.TestField("Department Code (To)");
    //         EmpHrTransfer."Deputation On (To)"::"Extension Counter":
    //             EmpHrTransfer.TestField("Extension Counter (To)");
    //         EmpHrTransfer."Deputation On (To)"::Province:
    //             EmpHrTransfer.TestField("Province Code (To)");
    //         EmpHrTransfer."Deputation On (To)"::"Sub Province":
    //             EmpHrTransfer.TestField("Sub Province Code (To)");
    //         EmpHrTransfer."Deputation On (To)"::Unit:
    //             EmpHrTransfer.TestField("Unit (To)");
    //     end;
    //     if not Employee.Screener then
    //         Error('You are not eligible to screen this document');
    //     if EmpHrTransfer.Type = EmpHrTransfer.Type::"Employee Transfer" then
    //         EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Reviewed)
    //     else if EmpHrTransfer.Type = EmpHrTransfer.Type::"HR Transfer" then
    //         EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Open);
    //     EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Screened);
    //     EmpHrTransfer.Modify;
    //     Message('Document has been screened');
    // end;


    //         ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
    //     ServiceHistory.MODIFY;
    //   END;*/
    //     SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTransfer.Type::"Employee Transfer", EmpHrTransfer."Approval Status"::Approved, EmpHrTransfer.Remarks, '', EmpHrTransfer."No.", 0);
    //     //UpdatePortalTransferEffDate("Transfer Effective Date","Employee No."); //Min 4.27.2022
    // if EmpHrTransfer."Transfer Effective Date" <= Today then begin //Min -- For Disable Punchin
    //     if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin
    //         EmployeeRec."Disable Punch in" := true;
    //         EmployeeRec.Modify;
    //     end;
    // end;
    //     Message('Document has been approved.');

    // end;

    // procedure HoldTransfer(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    //     TransferPageBuilder: FilterPageBuilder;
    //     EmpHrTrsfer: Record "Employee Transfer";
    //     GetDate: Date;
    //     EmpServiceActivityRec: Record "Employee Service History";
    // begin
    //     Employee.Get(GetEmployeeNo);
    //     if not Employee.Screener then
    //         Error('You are not eligible to put this document on hold');
    //     EmpHrTrsfer.TestField("Approval Status", EmpHrTrsfer."Approval Status"::Approved);

    //     TransferPageBuilder.AddRecord('Transfer Document', EmpHrTrsfer);
    //     TransferPageBuilder.ADdField('Transfer Document', EmpHrTrsfer."On Hold Date");
    //     TransferPageBuilder.ADdField('Transfer Document', EmpHrTrsfer."Reason For Hold");
    //     if TransferPageBuilder.RunModal then begin
    //         EmpHrTrsfer.SetView(TransferPageBuilder.GetView('Transfer Document'));
    //         //IF EmpActivity.FINDFIRST THEN;
    //         Evaluate(GetDate, EmpHrTrsfer.GetFilter("On Hold Date"));
    //         if GetDate = 0D then
    //             Error('Please enter on hold date.');
    //         if EmpHrTrsfer.GetFilter("Reason For Hold") = '' then
    //             Error('Please enter reason.');
    //         EmpHrTrsfer.Validate("On Hold Date", GetDate);
    //         EmpHrTrsfer.Validate("Transfer Effective Date", GetDate);
    //         EmpHrTrsfer.Validate("Reason For Hold", EmpHrTrsfer.GetFilter("Reason For Hold"));
    //         EmpHrTrsfer.Validate("Approval Status", EmpHrTrsfer."Approval Status"::"On Hold");
    //         EmpHrTrsfer.Modify;
    //         SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTrsfer.Type::"Employee Transfer", EmpHrTrsfer."Approval Status"::"On Hold", EmpHrTrsfer.Remarks, '', EmpHrTrsfer."No.", 0);
    //         ReinstateCancelTransfer(EmpHrTrsfer); //Min -- Reinstate while Hold transfer
    //         EmpServiceActivityRec.Reset; //Min 3.13.2022 -- For Remove Transfer Hold Doc. line
    //         EmpServiceActivityRec.SetRange("Document No.", EmpHrTrsfer."No.");
    //         if EmpServiceActivityRec.FindFirst then
    //             EmpServiceActivityRec.Delete;
    //         if EmployeeRec.Get(EmpHrTrsfer."Employee No.") then begin //Min -- For Enable Punchin
    //             EmployeeRec."Disable Punch in" := false;
    //             EmployeeRec.Modify;
    //         end;
    //         Message('Document has been put on hold.');
    //     end;
    // end;

    // procedure CancelTransfer(var EmphrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    //     TransferPageBuilder: FilterPageBuilder;
    //     EmpHrTrnsferVar: Record "Employee Transfer";
    //     GetDate: Date;
    //     EmpServiceActivity: Record "Employee Service History";
    // begin
    //     Employee.Get(GetEmployeeNo);
    //     if not Employee.Screener then
    //         Error('You are not eligible to cancel this document.');
    //     EmpHrTrnsferVar.TestField("Approval Status", EmpHrTrnsferVar."Approval Status"::Approved);
    //     TransferPageBuilder.AddRecord('Transfer Document', EmpHrTrnsferVar);
    //     TransferPageBuilder.ADdField('Transfer Document', EmpHrTrnsferVar."Cancelled Date");
    //     TransferPageBuilder.ADdField('Transfer Document', EmpHrTrnsferVar."Reason For Cancel");
    //     if TransferPageBuilder.RunModal then begin
    //         EmpHrTrnsferVar.SetView(TransferPageBuilder.GetView('Transfer Document'));

    //         Evaluate(GetDate, EmpHrTrnsferVar.GetFilter("Cancelled Date"));
    //         if GetDate = 0D then
    //             Error('Please enter on cancel date.');
    //         if EmpHrTrnsferVar.GetFilter("Reason For Cancel") = '' then
    //             Error('Please enter reason.');
    //         EmpHrTrnsferVar.Validate("Cancelled Date", GetDate);
    //         EmpHrTrnsferVar.Validate("Reason For Cancel", EmpHrTrnsferVar.GetFilter("Reason For Cancel"));
    //         EmpHrTrnsferVar.Validate("Approval Status", EmpHrTrnsferVar."Approval Status"::Cancelled);
    //         EmpHrTrnsferVar.Modify;
    //         SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTrnsferVar.Type::"Employee Transfer", EmpHrTrnsferVar."Approval Status"::Cancelled, EmpHrTrnsferVar.Remarks, '', EmpHrTrnsferVar."No.", 0);
    //         ReinstateCancelTransfer(EmpHrTrnsferVar); //Min -- Reinstate while cancel transfer
    //         EmpServiceActivity.Reset; //Min 3.13.2022 -- For Remove cancel Doc. line
    //         EmpServiceActivity.SetRange("Document No.", EmpHrTrnsferVar."No.");
    //         if EmpServiceActivity.FindFirst then
    //             EmpServiceActivity.Delete;
    //         EmpServiceActivity.Reset;//Min 3.13.2022 -- For Update Last Placement Date in Employee Table.
    //         EmpServiceActivity.SetCurrentKey("Effective Date");
    //         EmpServiceActivity.SetRange("Employee No.", EmpHrTrnsferVar."Employee No.");
    //         EmpServiceActivity.SetRange("Service Event", EmpServiceActivity."Service Event"::Transfer);
    //         if EmpServiceActivity.FindLast then begin
    //             if EmployeeRec.Get(EmpHrTrnsferVar."Employee No.") then begin
    //                 EmployeeRec."Last Placement Date" := EmpServiceActivity."Effective Date";
    //                 EmployeeRec.Modify;
    //             end;
    //         end;
    //         if EmployeeRec.Get(EmpHrTrnsferVar."Employee No.") then begin //Min -- For Enable Punchin
    //             EmployeeRec."Disable Punch in" := false;
    //             EmployeeRec.Modify;
    //         end;
    //         Message('Document has been Cancelled.');
    //     end;
    // end;

    // procedure RejectTransfer(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    // begin
    //     EmpHrTransfer.TestField("Rejection Remarks");
    //     case EmpHrTransfer."Approval Status" of
    //         EmpHrTransfer."Approval Status"::Pending:
    //             begin
    //                 if StrPos(EmpHrTransfer."Recommender Code", GetEmployeeNo) = 0 then
    //                     Error('You are not eligible to reject this document');
    //             end;

    //         EmpHrTransfer."Approval Status"::Recommended:
    //             begin
    //                 if EmpHrTransfer.Reviewer <> GetEmployeeNo then
    //                     Error('You are not eligible to reject this document.');
    //             end;

    //         EmpHrTransfer."Approval Status"::Reviewed, EmpHrTransfer."Approval Status"::"On Hold":
    //             begin
    //                 Employee.Get(GetEmployeeNo);
    //                 if not Employee.Screener then
    //                     Error('You are not eligible to reject this document.');
    //             end;

    //         EmpHrTransfer."Approval Status"::Screened:
    //             begin
    //                 if EmpHrTransfer."Approver Code" <> GetEmployeeNo then
    //                     Error('You are eligible to reject this document.');
    //             end;
    //     end; // 
    // end;

    // procedure ApproveTransfer(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    //     ServiceHistoryCode: Code[20];
    //     ServiceHistory: Record "Employee Service History";
    //     PreviousServiceHistory: Record "Employee Service History";
    // begin
    //     if EmpHrTransfer."Approver Code" <> GetEmployeeNo then
    //         Error('You are not eligible to approved this document');
    //     if Today > EmpHrTransfer."Transfer Effective Date" then //Min 8.7.2022 + 1
    //         Error(TransferError, EmpHrTransfer."Transfer Effective Date", Today);
    //     EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Screened);
    //     EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Approved);
    //     EmpHrTransfer.Validate("Approved Date", Today);
    //     IF EmpHrTransfer."Transfer Category" = EmpHrTransfer."Transfer Category"::"Temporary" THEN //Min 1.4 >>
    //         ServiceHistoryCode := AddToServiceHistory(EmpHrTransfer."Employee No.", ServiceHistory."Service Event"::"Temporary Deputation", EmpHrTransfer.Remarks, EmpHrTransfer."Transfer Effective Date");
    //     IF EmpHrTransfer."Transfer Category" = EmpHrTransfer."Transfer Category"::Officiating THEN
    //         ServiceHistoryCode := AddToServiceHistory(EmpHrTransfer."Employee No.", ServiceHistory."Service Event"::"Officiating Arrangement", EmpHrTransfer.Remarks, EmpHrTransfer."Transfer Effective Date");
    //     IF EmpHrTransfer."Transfer Category" = EmpHrTransfer."Transfer Category"::General THEN
    //         ServiceHistoryCode := AddToServiceHistory(EmpHrTransfer."Employee No.", ServiceHistory."Service Event"::Transfer, EmpHrTransfer.Remarks, EmpHrTransfer."Transfer Effective Date");
    //     EmpHrTransfer.Modify;
    //     //ValidateTransferField(EmpHrTransfer); //Min 1.4 >> commented by santosh
    //     IF ServiceHistory.GET(ServiceHistoryCode) THEN BEGIN //Min 1.4 >>
    //         ServiceHistory.VALIDATE("Functional Title (To)", EmpHrTransfer."Functional Title (To)");
    //         ServiceHistory.VALIDATE("Salary Level (To)", Employee."Salary Level");
    //         ServiceHistory.VALIDATE("Deputation On (To)", EmpHrTransfer."Deputation On (To)");
    //         ServiceHistory.VALIDATE("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //         ServiceHistory.VALIDATE("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //         ServiceHistory.VALIDATE("Document No.", EmpHrTransfer."No.");
    //         PreviousServiceHistory.RESET;
    //         PreviousServiceHistory.SETRANGE("Employee No.", ServiceHistory."Employee No.");
    //         PreviousServiceHistory.SETFILTER("Service History Code", '<>%1', ServiceHistoryCode);
    //         PreviousServiceHistory.SETCURRENTKEY("Effective Date");
    //         IF (PreviousServiceHistory.FINDLAST) THEN
    //             IF (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") OR
    //               (EmpHrTransfer."Transfer Category" IN [EmpHrTransfer."Transfer Category"::Officiating, EmpHrTransfer."Transfer Category"::"Temporary"]) THEN
    //                 EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Rejected);
    //         EmpHrTransfer.Modify;
    //         if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin //Min -- For Enable Punchin
    //             EmployeeRec."Disable Punch in" := false;
    //             EmployeeRec.Modify;
    //         end;
    //         Message('Document has been rejected.');

    //     end;
    // end;

    // procedure RequestTransferAllowanceClaim(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     BMandOutStationError: Label 'You cannot apply for both BM Accomodation Allowance and Outstation/Discomfort Allowance.';
    //     UnauthorizedApprover: Label 'You are not authorized to approve.';
    // begin

    //     EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Acknowledged);
    //     if (EmpHrTransfer."Outstation/Discomfort Allow." <> 0) and (EmpHrTransfer."BM Accomodation Allow." <> 0) then
    //         Error(BMandOutStationError);

    //     //IF GetEmployeeNo <> "Transfer Claim Recommender" THEN
    //     //ERROR(UnauthorizedApprover);
    //     if EmpHrTransfer."Transfer Claim Recommender" = '' then
    //         EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Recommended)
    //     else
    //         EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval");
    //     EmpHrTransfer.Modify(true);
    // end;

    // local procedure CheckTransferClaimApproval(EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    //     RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    //     AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    // begin
    //     Employee.Reset;
    //     Employee.SetRange("NAV Login ID", UserId);
    //     Employee.FindFirst;
    //     if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval" then
    //         if StrPos(EmpHrTransfer."Transfer Claim Recommender", Employee."No.") = 0 then
    //             Error(RecommendNotEligibleError);
    //     if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Recommended then
    //         if StrPos(EmpHrTransfer."Transfer Claim Reviewer", Employee."No.") = 0 then
    //             Error(ApproveNotEligibleError);
    //     if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Reviewed then
    //         if not Employee.Screener then
    //             Error(ApproveNotEligibleError);
    // end;

    // procedure ApproveRejectTransferClaim(Approve: Boolean; var EmpHrTransfer: Record "Employee Transfer"; remarksText: Text)
    // var
    //     ServiceHistory: Record "Employee Service History";
    //     ReasonCode: Record "Reason Code";
    // begin
    //     CheckTransferClaimApproval(EmpHrTransfer);
    //     //CheckEmployeeActivityApproval(EmpAct);
    //     if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval" then begin
    //         if ReasonCode.Get(EmpHrTransfer."No.") then begin
    //             ReasonCode.Validate("Transf. Claim Recomm. Remarks", remarksText);
    //             ReasonCode.Modify;
    //         end else begin
    //             ReasonCode.Init;
    //             ReasonCode.Validate("Transf. Claim Recomm. Remarks", remarksText);
    //             ReasonCode.Validate(Code, EmpHrTransfer."No.");
    //             ReasonCode.Insert;
    //         end;
    //     end else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Recommended then begin
    //         if ReasonCode.Get(EmpHrTransfer."No.") then begin
    //             ReasonCode.Validate("Transf. Claim Reviewer Remarks", remarksText);
    //             ReasonCode.Modify;
    //         end else begin
    //             ReasonCode.Init;
    //             ReasonCode.Validate("Transf. Claim Reviewer Remarks", remarksText);
    //             ReasonCode.Validate(Code, EmpHrTransfer."No.");
    //             ReasonCode.Insert;
    //         end;
    //     end else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Reviewed then begin
    //         if ReasonCode.Get(EmpHrTransfer."No.") then begin
    //             ReasonCode.Validate("Transf. Claim Apporver Remarks", remarksText);
    //             ReasonCode.Modify;
    //         end else begin
    //             ReasonCode.Init;
    //             ReasonCode.Validate("Transf. Claim Apporver Remarks", remarksText);
    //             ReasonCode.Validate(Code, EmpHrTransfer."No.");
    //             ReasonCode.Insert;
    //         end;
    //     end;

    //     if Approve then begin
    //         if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval" then
    //             EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Recommended)
    //         else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Recommended then
    //             EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Reviewed)

    //         else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Reviewed then begin
    //             EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Approved);
    //             ServiceHistory.Reset;
    //             ServiceHistory.SetRange("Document No.", EmpHrTransfer."No.");
    //             if ServiceHistory.FindFirst then begin
    //                 if EmpHrTransfer."Outstation/Discomfort Allow." <> 0 then
    //                     ServiceHistory."Outstation Eligible" := true;
    //                 ServiceHistory.Modify;
    //             end;
    //         end;
    //     end
    //     else begin
    //         EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Open);
    //     end;

    //     EmpHrTransfer.Modify;
    // end;

    // procedure ReturnTransfer(EmpHrTransfer: Record "Employee Transfer")
    // begin

    //     if EmpHrTransfer.Type in [EmpHrTransfer.Type::"HR Transfer", EmpHrTransfer.Type::"Employee Transfer"] then
    //         Error('It is not transfer document.');
    //     EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Screened);
    //     Employee.Get(GetEmployeeNo);
    //     if not Employee.Screener then
    //         Error('You are not authorized to return this document.');
    //     EmpHrTransfer."Approval Status" := EmpHrTransfer."Approval Status"::Open;
    //     EmpHrTransfer.Modify;
    //     Message('Document Returned.');
    // end;



    local procedure CheckEmployeeActivityApproval(EmpAct: Record "Employee Activity")
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
        AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then
            if StrPos(EmpAct."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if EmpAct."Approval Status" = EmpAct."Approval Status"::Recommended then
            if StrPos(EmpAct."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        //IF EmpAct."Approval Status" = EmpAct."Approval Status"::Approved THEN
        //IF STRPOS(EmpAct."Incoming Branch Rep. Person", Employee."No.") = 0 THEN
        //ERROR(AcknowledgeError);
    end;

    local procedure CheckEmployeeActivityApprovalAPI(EmpAct: Record "Employee Activity"; employeeNo: Code[20])
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    begin
        Employee.Reset;
        Employee.SetRange("No.", employeeNo);
        Employee.FindFirst;
        if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then
            if StrPos(EmpAct."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if EmpAct."Approval Status" = EmpAct."Approval Status"::Recommended then
            if StrPos(EmpAct."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        //IF EmpAct."Approval Status" = EmpAct."Approval Status"::Approved THEN
        //IF STRPOS(EmpAct."Incoming Branch Rep. Person", Employee."No.") = 0 THEN
        //ERROR(AcknowledgeError);
    end;

    // procedure CalculateAllowance(var EmpTransfer: Record "Employee Transfer")
    // var
    //     Employee: Record Employee;
    //     TotalDays: Integer;
    //     GrossSalary: Decimal;
    //     SalaryLevel1: Record "Salary Level";
    //     RemoteArea: Record "Remote Area Category";
    //     DimensionValue: Record "Dimension Value";
    //     SalaryLevel: Record "Salary Level";
    //     SalaryGrade: Record "Salary Grade";
    // begin
    //     EmpTransfer.TestField("Transfer Effective Date");

    //     TotalDays := CalcDate('CM', EmpTransfer."Transfer Effective Date") - EmpTransfer."Transfer Effective Date";

    //     EmpTransfer."Relocation Allow." := 0;
    //     EmpTransfer."Outstation/Discomfort Allow." := 0;
    //     EmpTransfer."BM Accomodation Allow." := 0;
    //     EmpTransfer."Remote Area Allow." := 0;
    //     EmpTransfer."Officiating Allow." := 0;
    //     //"transfer claim approver" := '';

    //     //  GetTransferClaimApprover(EmpAct);

    //     CalculateRelocationAllowance(EmpTransfer);

    //     CalculateOutstationAllowance(EmpTransfer);

    //     CalculateBMAccomodationAllowance(EmpTransfer);

    //     CalculateOfficiatingAllowance(EmpTransfer);

    //     CalculateRemoteAreaAllowance(EmpTransfer);

    //     EmpTransfer.Modify;
    // end;

    // local procedure CalculateRelocationAllowance(var EmpTransfer: Record "Employee Transfer")
    // var
    //     DimensionValueCurrent: Record "Dimension Value";
    //     LevelWiseAttribute: Record "Level Wise Attributes";
    // begin

    //     HRSetup.Get;
    //     HRSetup.TestField("Relocation Dist. Criteria (H)");
    //     HRSetup.TestField("Relocation Dist. Criteria (T)");
    //     Employee.Get(EmpTransfer."Employee No.");
    //     LevelWiseAttribute.Get(Employee."Salary Grade", Employee."Salary Level");
    //     if EmpTransfer."Relocation Distance" = 0 then begin
    //         EmpTransfer."Relocation Allow." := 0;
    //         exit;
    //     end;
    //     if Employee."Inside/Outisde Valley" = Employee."Inside/Outisde Valley"::Outside then begin

    //         if Employee."Posting Region" = Employee."Posting Region"::Hilly then begin
    //             if EmpTransfer."Relocation Distance" >= HRSetup."Relocation Dist. Criteria (H)" then
    //                 EmpTransfer."Relocation Allow." := LevelWiseAttribute."Total Basic Salary";
    //         end else if Employee."Posting Region" = Employee."Posting Region"::Terai then begin
    //             if EmpTransfer."Relocation Distance" >= HRSetup."Relocation Dist. Criteria (T)" then
    //                 EmpTransfer."Relocation Allow." := LevelWiseAttribute."Total Basic Salary";
    //         end;
    //     end;
    // end;

    // local procedure CalculateOutstationAllowance(var EmpTransfer: Record "Employee Transfer")
    // var
    //     DimensionValueCurrent: Record "Dimension Value";
    //     LevelWiseAttribute: Record "Level Wise Attributes";
    // begin
    //     if EmpTransfer."Outstation Distance" = 0 then begin
    //         EmpTransfer."Outstation/Discomfort Allow." := 0;
    //         exit;
    //     end;
    //     Employee.Get(EmpTransfer."Employee No.");
    //     if Employee."Employment Type" = Employee."Employment Type"::Contract then
    //         exit;


    //     HRSetup.Get;
    //     HRSetup.TestField("Outstation Dist. Criteria (H)");
    //     HRSetup.TestField("Outstation Dist. Criteria (T)");
    //     LevelWiseAttribute.Get(Employee."Salary Grade", Employee."Salary Level");

    //     // TESTFIELD("Outstation Distance");
    //     if Employee."Posting Region" = Employee."Posting Region"::Hilly then begin
    //         if EmpTransfer."Outstation Distance" >= HRSetup."Outstation Dist. Criteria (H)" then
    //             EmpTransfer."Outstation/Discomfort Allow." := LevelWiseAttribute."Total Basic Salary" * 25 / 100;
    //     end else if Employee."Posting Region" = Employee."Posting Region"::Terai then begin
    //         if EmpTransfer."Outstation Distance" >= HRSetup."Outstation Dist. Criteria (T)" then
    //             EmpTransfer."Outstation/Discomfort Allow." := LevelWiseAttribute."Total Basic Salary" * 25 / 100;
    //     end;
    // end;

    // local procedure CalculateBMAccomodationAllowance(var EmpTransfer: Record "Employee Transfer")
    // var
    //     DimensionValueCurrent: Record "Dimension Value";
    //     RemoteArea: Record "Remote Area Category";
    //     PGSetup: Record "Payroll General Setup";
    // begin
    //     if EmpTransfer."BMAF Distance" = 0 then begin
    //         EmpTransfer."BM Accomodation Allow." := 0;
    //         exit;
    //     end;
    //     PGSetup.Get;
    //     PGSetup.TestField("BM Functional Title");
    //     if EmpTransfer."Functional Title (To)" <> PGSetup."BM Functional Title" then
    //         exit;
    //     if DimensionValueCurrent.Get('BRANCH', EmpTransfer."Shortcut Dimension 1 Code") then
    //         if not DimensionValue.Get('BRANCH', EmpTransfer."Shortcut Dimension 1 Code (To)") then
    //             exit;
    //     if DimensionValueCurrent."Inside/Outisde Valley" = DimensionValueCurrent."Inside/Outisde Valley"::Inside then
    //         if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Inside then
    //             exit;

    //     HRSetup.Get;
    //     HRSetup.TestField("BMAF Dist. Criteria (H)");
    //     HRSetup.TestField("BMAF Dist. Criteria (T)");
    //     if RemoteArea.Get(DimensionValue."Remote Area Category") then begin
    //         if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Outside then begin
    //             //  TESTFIELD("BMAF Distance");
    //             if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Hilly then begin
    //                 if EmpTransfer."BMAF Distance" >= HRSetup."BMAF Dist. Criteria (H)" then
    //                     EmpTransfer."BM Accomodation Allow." := RemoteArea."BM Accomodation Amount";
    //             end else if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Terai then begin
    //                 if EmpTransfer."BMAF Distance" >= HRSetup."BMAF Dist. Criteria (T)" then
    //                     EmpTransfer."BM Accomodation Allow." := RemoteArea."BM Accomodation Amount";
    //             end;
    //         end;
    //     end;
    // end;

    // local procedure CalculateOfficiatingAllowance(var EmpTransfer: Record "Employee Transfer")
    // var
    //     DimensionValueCurrent: Record "Dimension Value";
    //     SalaryLevel1: Record "Salary Level";
    //     GrossSalary: Decimal;
    //     SalaryLevel: Record "Salary Level";
    //     SalaryGrade: Record "Salary Grade";
    // begin
    //     Employee.Get(EmpTransfer."Employee No.");
    //     if Employee."Employment Type" = Employee."Employment Type"::Contract then
    //         exit;
    //     if EmpTransfer."Transfer Type" <> EmpTransfer."Transfer Type"::"Intra Provincial" then
    //         exit;
    //     Employee.Get(EmpTransfer."Employee No.");
    //     SalaryLevel.Get(Employee."Salary Level");

    //     SalaryLevel1.Reset;
    //     SalaryLevel1.SetCurrentKey(Rank);
    //     SalaryLevel1.SetFilter(Rank, '>%1', SalaryLevel.Rank);
    //     if SalaryLevel1.FindFirst then begin
    //         SalaryGrade.Get(0);
    //         GrossSalary := SalaryLevel1."Basic Salary" +
    //                         SalaryLevel1.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel1."Basic Salary";
    //         EmpTransfer."Officiating Allow." := GrossSalary;
    //     end;
    // end;

    // local procedure CalculateRemoteAreaAllowance(var EmpTransfer: Record "Employee Transfer")
    // var
    //     DimensionValueCurrent: Record "Dimension Value";
    //     SalaryLevel1: Record "Salary Level";
    //     GrossSalary: Decimal;
    //     SalaryLevel: Record "Salary Level";
    //     SalaryGrade: Record "Salary Grade";
    //     RemoteArea: Record "Remote Area Category";
    // begin
    //     if DimensionValue.Get('BRANCH', EmpTransfer."Shortcut Dimension 1 Code (To)") then begin
    //         if RemoteArea.Get(DimensionValue."Remote Area Category") then begin
    //             Employee.Get(EmpTransfer."Employee No.");
    //             SalaryLevel.Get(Employee."Salary Level");
    //             SalaryGrade.Get(Employee."Salary Grade");
    //             GrossSalary := SalaryLevel."Basic Salary" +
    //                               SalaryLevel.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel."Basic Salary";
    //             EmpTransfer."Remote Area Allow." := RemoteArea."Remote allowance Percentage" / 100 * GrossSalary;
    //             if RemoteArea."Remote Allowance Amount" < EmpTransfer."Remote Area Allow." then
    //                 EmpTransfer."Remote Area Allow." := RemoteArea."Remote Allowance Amount";

    //         end;
    //     end;
    // end;

    // local procedure GetTransferClaimApprover(var EmpAct: Record "Employee Activity")
    // begin

    //     /*HRSetup.GET;
    //     HRSetup.TESTFIELD("Transfer Claim Approver");

    //     */

    // end;

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

    procedure GetEmployeeName(EmployeeCode: Code[20]): Text[50]
    begin
        Employee.Reset;
        if Employee.Get(EmployeeCode) then
            exit(Employee."Full Name");
    end;

    procedure GetHrHead(): Code[20]
    begin
        HRSetup.Get;
        HRSetup.TestField("HR Head Functional Title");
        HRSetup.TestField("HR Department Code");
        Employee.Reset;
        Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee.SetRange("Department Code", HRSetup."HR Department Code");
        Employee.SetRange(Status, Employee.Status::Active); //Min
        if Employee.FindFirst then
            exit(Employee."No.");
    end;

    // procedure AcknowledgeTransfer(var EmpHrTransfer: Record "Employee Transfer")
    // var
    //     ConfirmAcknowledge: Label 'Do you want to acknowledge this transfer?';
    //     Acknowledged: Label 'Acknowledged.';
    //     IncomingDoc: Record "Incoming Document";
    //     AttachmentSetup: Record "Attachment Setup";
    //     Province: Record Province;
    //     GLSetup: Record "General Ledger Setup";
    //     FunctionalTitle: Record "Functional Title";
    //     SubProv: Record "Sub Province";
    //     EmpHie: Record "Employee Hierarchy Master";
    //     Depart: Record Department;
    //     ServiceHistoryCode: Code[20];
    //     ServiceHistory: Record "Employee Service History";
    //     PreviousServiceHistory: Record "Employee Service History";
    // begin
    //     if not (EmpHrTransfer."Approval Status" in [EmpHrTransfer."Approval Status"::Approved, EmpHrTransfer."Approval Status"::"On Hold"]) then
    //         Error('Approval Status must be approved or on hold');
    //     EmpHrTransfer.TestField("Date of Joining Of Transfer");
    //     EmpHrTransfer.TestField("Transfer Remarks");
    //     EmpHrTransfer.Validate("Acknowledged Date", Today);
    //     /*IF "Transfer Category" = "Transfer Category"::"Temporary" THEN //Min 1.1 >>
    //         ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Temporary Deputation",EmpAct.Remarks,"Date of Joining Of Transfer");
    //     IF "Transfer Category" = "Transfer Category"::Officiating THEN
    //       ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Officiating Arrangement",EmpAct.Remarks,"Date of Joining Of Transfer");
    //     IF "Transfer Category" = "Transfer Category"::General THEN
    //       ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::Transfer,EmpAct.Remarks,"Date of Joining Of Transfer");*/
    //     GLSetup.Get;
    //     //checking for attachment mandatory
    //     AttachmentSetup.Reset;
    //     AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Transfer);
    //     AttachmentSetup.SetRange("Transfer Category", EmpHrTransfer."Transfer Category");
    //     AttachmentSetup.SetRange(Mandatory, true);
    //     if AttachmentSetup.Find('-') then
    //         repeat
    //             IncomingDoc.Reset;
    //             IncomingDoc.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
    //             IncomingDoc.SetRange("No.", EmpHrTransfer."No.");
    //             IncomingDoc.SetRange("File Name", '');
    //             if IncomingDoc.FindFirst then
    //                 Error('Please upload file for attachment %1', AttachmentSetup."Attachment Code");
    //         until AttachmentSetup.Next = 0;

    //     //  CheckEmployeeActivityApproval(EmpAct);
    //     /*Employee1.GET(GetEmployeeNo);
    //     IF ("Incoming Supervisior" <> Employee1."No.") AND (NOT Employee1.Screener) THEN
    //       ERROR('You are not eligible to acknowledge this transfer');*/
    //     if Employee1.Screener then
    //         EmpHrTransfer."Transfer Remarks" += 'by screener (' + Employee1."No." + ')';
    //     if GuiAllowed then
    //         if not Confirm(ConfirmAcknowledge, false) then
    //             exit;
    //     EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Acknowledged);
    //     EmpHrTransfer.Modify;

    //     /*ValidateTransferField(EmpAct); //Min 1.1 >>

    //      IF ServiceHistory.GET(ServiceHistoryCode) THEN BEGIN
    //        ServiceHistory.VALIDATE("Functional Title (To)","Functional Title (To)");
    //        ServiceHistory.VALIDATE("Salary Level (To)",Employee."Salary Level");
    //        ServiceHistory.VALIDATE("Deputation On (To)","Deputation On (To)");
    //        ServiceHistory.VALIDATE("Deputation Code (To)",ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
    //        ServiceHistory.VALIDATE("Deputation Value (To)",ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
    //        ServiceHistory.VALIDATE("Document No.","No.");
    //          PreviousServiceHistory.RESET;
    //          PreviousServiceHistory.SETRANGE("Employee No.",ServiceHistory."Employee No.");
    //          PreviousServiceHistory.SETFILTER("Service History Code",'<>%1',ServiceHistoryCode);
    //          PreviousServiceHistory.SETCURRENTKEY("Effective Date");
    //          IF (PreviousServiceHistory.FINDLAST) THEN
    //            IF (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") OR
    //              ("Transfer Category" IN ["Transfer Category"::Officiating,"Transfer Category"::"Temporary"]) THEN
    //            ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
    //        ServiceHistory.MODIFY;
    //      END;*/ //Min 1.1 >>
    //             //UpdatePortalTransferEffDate(0D,"Employee No."); //Min 4.27.2022
    //     if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin //Min -- For Enable Punchin
    //         EmployeeRec."Disable Punch in" := false;
    //         EmployeeRec.Modify;
    //     end;
    //     Message(Acknowledged);
    //     SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTransfer.Type::"Employee Transfer", EmpHrTransfer."Approval Status"::Acknowledged, '', EmpHrTransfer."Incoming Supervisior", EmpHrTransfer."No.", 0);
    //     /*IF "Transfer Category" IN ["Transfer Category"::Officiating, "Transfer Category"::"Temporary"] THEN BEGIN
    //       IF "End Date" < TODAY THEN
    //         ReinstateTransfer(EmpAct);
    //     END;*/ //Min 1.1 >>

    // end;

    // procedure PopUpChangingTransferApprover(EmployeehrTransfer: Record "Employee Transfer")
    // var
    //     EmpActPageBuilder: FilterPageBuilder;
    //     EmpAct: Record "Employee Activity";
    // begin
    //     EmpActPageBuilder.AddRecord('Change Approver', EmpAct);
    //     EmpActPageBuilder.ADdField('Change Approver', EmpAct."Approver Code");
    //     if EmpActPageBuilder.RunModal then begin
    //         EmpAct.SetView(EmpActPageBuilder.GetView('Change Approver'));

    //         if EmployeehrTransfer."Approval Status" <> EmployeehrTransfer."Approval Status"::Screened then
    //             Error('Approval Status must be screened.');
    //         Employee.Get(GetEmployeeNo);
    //         if not Employee.Screener then
    //             Error('Only Screener can change approver');
    //         if EmpAct.GetFilter("Approver Code") = '' then
    //             Error('Approver Code cannot be blank.');

    //         EmployeehrTransfer.Validate("Approver Code", EmpAct.GetFilter("Approver Code"));
    //         EmployeehrTransfer.Modify;
    //         Message('Updated');
    //     end;
    // end;

    local procedure "----Loan----"()
    begin
    end;

    // procedure DisbursementEmailToEmployee(EmpLoanAdvCode: Code[20])
    // var
    //     EmpAdvLoan: Record "Employee Loan/Advance";
    //     CompanyInfo: Record "Company Information";
    //     // SMTPSetup: Record "SMTP Mail Setup";
    //     EmailTemplate: Record "Email Template";
    //     HRSetup: Record "Human Resources Setup";
    //     EmailMessage: Record "Agile Email Message";
    //     Header: Text;
    //     Body: Text;
    //     Footer: Text;
    //     Counter: Integer;
    //     EmployeeRec: Record Employee;
    // begin
    //     CompanyInfo.Get;
    //     // SMTPSetup.Get;
    //     Clear(CodeunitEmailMessage);
    //     HRSetup.Get;
    //     EmpAdvLoan.Reset;
    //     Counter := 0;
    //     EmpAdvLoan.SetRange("No.", EmpLoanAdvCode);
    //     if EmpAdvLoan.FindFirst then
    //         repeat
    //             if EmailTemplate.Get(HRSetup."Loan Disbursement Email") then begin
    //                 Clear(Footer);
    //                 Clear(Header);
    //                 Clear(Body);
    //                 EmployeeRec.Get(EmpAdvLoan."Employee Code");
    //                 // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", EmployeeRec."E-Mail(Personal)", EmailTemplate.Subject, '', true);

    //                 EmailMessage.SetRange("Template Code", EmailTemplate.Code);
    //                 if EmailMessage.FindFirst then
    //                     repeat
    //                         case EmailMessage.Type of
    //                             EmailMessage.Type::Header:
    //                                 Header := Header + EmailMessage."Body Message";

    //                             EmailMessage.Type::Body:
    //                                 Body := Body + EmailMessage."Body Message";

    //                             EmailMessage.Type::Footer:
    //                                 Footer := Footer + EmailMessage."Body Message";
    //                         end;
    //                     until EmailMessage.Next = 0;
    //                 CodeunitEmailMessage.AppendToBody(Header);
    //                 CodeunitEmailMessage.AppendToBody('<br><br>');
    //                 CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Employee Name") + Colon + Format(EmpAdvLoan."Employee Name"));
    //                 CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Loan Type") + Colon + Format(EmpAdvLoan."Loan Type"));
    //                 CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Total Loan Amount") + Colon + Format(EmpAdvLoan."Total Loan Amount"));
    //                 CodeunitEmailMessage.AppendToBody(EmpAdvLoan.FieldCaption("Disbursement Date") + Colon + Format(EmpAdvLoan."Disbursement Date"));
    //                 CodeunitEmailMessage.AppendToBody('<br><br>');
    //                 CodeunitEmailMessage.AppendToBody(Footer);
    //                 if Email.Send(CodeunitEmailMessage) then
    //                     Counter += 1;
    //             end;
    //         until EmpAdvLoan.Next = 0;
    //     if Counter <> 0 then
    //         Message('Mail Sent');
    // end;

    // local procedure GetLoanBody(var Emploan: Record "Employee Loan/Advance")
    // begin
    //     case Emploan."Loan Type" of
    //         Emploan."Loan Type"::"Salary Advance":
    //             begin
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
    //             end;

    //         Emploan."Loan Type"::"Home Loan":
    //             begin
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
    //             end;


    //         Emploan."Loan Type"::"Personal Loan":
    //             begin
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
    //             end;

    //         Emploan."Loan Type"::"Vehicle Loan":
    //             begin
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Code") + Colon + Format(Emploan."Employee Code") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Employee Name") + Colon + Format(Emploan."Employee Name") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Loan Type") + Colon + Format(Emploan."Loan Type") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Job Title") + Colon + Format(Emploan."Job Title") + '<br>');

    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Eligible Loan/Advance") + Colon + Format(Emploan."Eligible Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Requested Loan Date") + Colon + Format(Emploan."Requested Loan Date") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("Applied Loan/Advance") + Colon + Format(Emploan."Applied Loan/Advance") + '<br>');
    //                 CodeunitEmailMessage.AppendToBody(Emploan.FieldCaption("DBR Ratio") + Colon + Format(Emploan."DBR Ratio") + '<br>');
    //             end;

    //     end;
    // end;

    local procedure "---Resignation----"()
    begin
    end;

    // procedure OpenResignationRequest(EmpCode3: Code[20])
    // var
    //     EmpAct4: Record "Employee Activity" temporary;
    //     RequestError: Label 'You are not eligible to request for a transfer.';
    //     EmpAct: Record "Employee Activity";
    // begin
    //     EmpAct.Reset;
    //     EmpAct.SetRange("Employee No.", EmpCode3);
    //     EmpAct.SetRange(Type, EmpAct.Type::Resignation);
    //     EmpAct.SetFilter("Approval Status", '<>%1&<>%2', EmpAct."Approval Status"::Cancelled, EmpAct."Approval Status"::Rejected);
    //     if EmpAct.FindLast then begin
    //         PAGE.Run(PAGE::"Resignation Card", EmpAct);
    //         exit;
    //     end;

    //     Clear(Employee);
    //     Employee.Get(EmpCode3);

    //     EmpAct4.Init;
    //     EmpAct4.Validate(Type, EmpAct4.Type::Resignation);
    //     EmpAct4.Validate("Employee No.", EmpCode3);
    //     EmpAct4.Insert;
    //     PAGE.Run(PAGE::"Resignation Card", EmpAct4);
    // end;

    // procedure SendResignationApproval(TempEmpAct: Record "Employee Activity" temporary): Boolean
    // var
    //     //Resignation: Record "Resignation";
    //     EmpAct: record "Employee Activity";
    //     ConfirmResign: Label 'Do you want to send resignation request?';
    //     ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
    //     ApprovalRequestSent: Label 'Resignation request approval has been sent.';
    //     NoRecommender: Label 'No %1.';
    //     ResignationDays: Integer;
    // begin
    //     if GuiAllowed then
    //         if not Confirm(ConfirmResign, false) then
    //             exit;
    //     EmpAct.Reset;
    //     EmpAct.SetRange("Employee No.", TempEmpAct."Employee No.");
    //     EmpAct.SetRange(Type, EmpAct.Type::Resignation);
    //     EmpAct.SetFilter("Approval Status", '<>%1&<>%2', EmpAct."Approval Status"::Cancelled, EmpAct."Approval Status"::Rejected);
    //     if EmpAct.FindFirst then
    //         Error('Employee %1 has already send request for resignation', EmpAct."Employee Name");

    //     TempEmpAct.TestField("Proposed Date of Resignation");
    //     TempEmpAct.TestField("Reason for Resignation");
    //     TempEmpAct.TestField("Reason Code");

    //     Clear(EmpAct);
    //     EmpAct.Reset;
    //     EmpAct.Init;
    //     EmpAct.TransferFields(TempEmpAct);
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Pending);
    //     EmpAct.Validate("User ID", UserId);

    //     Employee.Get(EmpAct."Employee No.");
    //     //EmpAct.VALIDATE("Recommender Code", Employee."Recommender Code");
    //     EmpAct.Validate("Approver Code", GetHrHead());

    //     if EmpAct."Recommender Code" = '' then
    //         Error(NoRecommender, EmpAct.FieldCaption("Recommender Code"));

    //     if EmpAct."Requested Date" = 0D then
    //         EmpAct."Requested Date" := Today;

    //     EmpAct."Supervisor Proposed Date" := EmpAct."Proposed Date of Resignation";
    //     EmpAct."HR Proposed Date" := EmpAct."Proposed Date of Resignation";

    //     EmpAct.Insert(true);

    //     InsertAttachmentLines(EmpAct."No.", Format(EmpAct.Type));//attachment
    //     //InsertResignationApprover(Resignation); //resignation approver

    //     SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::Resignation, EmpAct."Approval Status"::Open, '', EmpAct."Employee No.", EmpAct."No.", 0);   //For email
    //     if (EmpAct.Type = EmpAct.Type::Resignation) and (EmpAct."Approval Status" = EmpAct."Approval Status"::Pending) then
    //         ResignationEmailSend(EmpAct."Employee No."); //Min 4.28.2022
    //     Message(ApprovalRequestSent);
    //     exit(true);
    // end;

    // procedure CancelResignationApproval(var Resignation: Record "Resignation")
    // var
    //     ConfirmCancel: Label 'Do you want to confirm cancel resignation request?';
    // begin
    //     Resignation.TestField("Approval Status", Resignation."Approval Status"::Pending);
    //     if not Confirm(ConfirmCancel, false) then
    //         exit;
    //     Resignation.Validate("Approval Status", Resignation."Approval Status"::Cancelled);
    //     Resignation.Modify(true);
    // end;

    // procedure ApproveRejectResignation(Approve: Boolean; var Resignation: Record "Resignation")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    //     EmailTemplate: Record "Email Template";
    //     ServiceHistory: Record "Employee Service History";
    //     ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    //     RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    //     AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    // begin
    //     //CheckEmployeeActivityApproval(EmpAct); //check authorized user
    //     Employee.Get(GetEmployeeNo);

    //     if Resignation."Approval Status" = Resignation."Approval Status"::Pending then
    //         if StrPos(Resignation."Recommender Code", Employee."No.") = 0 then
    //             Error(RecommendNotEligibleError);

    //     if Resignation."Approval Status" = Resignation."Approval Status"::Recommended then begin
    //         if not Employee.Screener then
    //             Error('You are not eligible to reject this document.');
    //     end;
    //     if Resignation."Approval Status" = Resignation."Approval Status"::Screened then
    //         if StrPos(Resignation."Approver Code", Employee."No.") = 0 then
    //             Error(ApproveNotEligibleError);

    //     if Approve then begin
    //         if GuiAllowed then
    //             if not Confirm(ConfirmApprove, false) then
    //                 exit;
    //         if Resignation."Approval Status" = Resignation."Approval Status"::Pending then begin
    //             Resignation.Validate("Approval Status", Resignation."Approval Status"::Recommended);
    //             SendMailFromTemplate(DATABASE::"Employee Activity", EmailTemplate."Document Type"::Resignation, Resignation."Approval Status"::Recommended, '', '', Resignation."No.", 0);
    //             SendMailFromTemplate(DATABASE::"Employee Activity", EmailTemplate."Document Type"::Resignation, Resignation."Approval Status"::Recommended, '', '', Resignation."No.", 2);
    //         end else if Resignation."Approval Status" = Resignation."Approval Status"::Screened then begin
    //             if Resignation."Approver Code" <> GetEmployeeNo then
    //                 Error('Your are not eligible to approve this document.');
    //             Resignation.Validate("Approval Status", Resignation."Approval Status"::Approved);
    //             AddToServiceHistory(Resignation."Employee No.", ServiceHistory."Service Event"::Resignation, Resignation.Remarks, Resignation."HR Proposed Date");
    //         end else if Resignation."Approval Status" = Resignation."Approval Status"::"Forwarded To HR" then
    //                 Message('Document must be screened');
    //     end
    //     else begin
    //         if GuiAllowed then
    //             if not Confirm(ConfirmReject, false) then
    //                 exit;
    //         Resignation.Validate("Approval Status", Resignation."Approval Status"::Rejected);
    //         ResignationRejectEmailSend(Resignation."Employee No.");//Abhiral 12.20.2022
    //     end;
    //     Resignation.Modify;
    // end;
    // procedure ApproveRejectResignationAPI(Approve: Boolean; var EmpAct: Record "Employee Activity"; employeeNo: Code[20])
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    //     EmailTemplate: Record "Email Template";
    //     ServiceHistory: Record "Employee Service History";
    //     ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    //     RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    // begin
    //     //CheckEmployeeActivityApproval(EmpAct); //check authorized user
    //     Employee.Get(employeeNo);

    //     if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then
    //         if StrPos(EmpAct."Recommender Code", Employee."No.") = 0 then
    //             Error(RecommendNotEligibleError);

    //     if EmpAct."Approval Status" = EmpAct."Approval Status"::Recommended then begin
    //         // if not Employee.Screener then
    //         //     Error('You are not eligible to reject this document.');
    //     end;
    //     if EmpAct."Approval Status" = EmpAct."Approval Status"::Screened then
    //         if StrPos(EmpAct."Approver Code", Employee."No.") = 0 then
    //             Error(ApproveNotEligibleError);

    //     if Approve then begin
    //         if GuiAllowed then
    //             if not Confirm(ConfirmApprove, false) then
    //                 exit;
    //         if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then begin
    //             EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Recommended);
    //             SendMailFromTemplate(Database::"Employee Activity", EmailTemplate."Document Type"::Resignation, EmpAct."Approval Status"::Recommended, '', '', EmpAct."No.", 0);
    //             SendMailFromTemplate(Database::"Employee Activity", EmailTemplate."Document Type"::Resignation, EmpAct."Approval Status"::Recommended, '', '', EmpAct."No.", 2);
    //         end else if EmpAct."Approval Status" = EmpAct."Approval Status"::Screened then begin
    //             if EmpAct."Approver Code" <> employeeNo then
    //                 Error('Your are not eligible to approve this document.');
    //             EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Approved);
    //             ServiceHistoryMgt.AddToServiceHistory(EmpAct."Employee No.", ServiceHistory."Service Event"::Resignation, EmpAct.Remarks, EmpAct."HR Proposed Date");
    //         end else if EmpAct."Approval Status" = EmpAct."Approval Status"::"Forwarded To HR" then
    //                 Message('Document must be screened');
    //     end
    //     else begin
    //         if GuiAllowed then
    //             if not Confirm(ConfirmReject, false) then
    //                 exit;
    //         EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Rejected);
    //         ResignationRejectEmailSend(EmpAct."Employee No.");//Abhiral 12.20.2022
    //     end;
    //     EmpAct.Modify;
    // end;

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

    // local procedure InsertResignationApprover(var Resignation: Record "Resignation")
    // var
    //     ResignationApprover: Record "Document Approver";
    //     Employee: Record Employee;
    //     EmpFieldRef: FieldRef;
    //     EmpRecordRef: RecordRef;
    // begin
    //     Employee.Reset;
    //     Employee.SetRange("Resignation Approver", true);
    //     if Employee.FindFirst then
    //         repeat
    //             ResignationApprover.Reset;
    //             ResignationApprover.SetRange("Document No.", Resignation."No.");
    //             ResignationApprover.SetRange("Employee No.", Employee."No.");
    //             //ResignationApprover.SETRANGE("Approver Type", ResignationApprover."Approver Type"::"Finance & Accounts");
    //             if not ResignationApprover.FindFirst then begin
    //                 ResignationApprover.Init;
    //                 ResignationApprover."Document Type" := ResignationApprover."Document Type"::Resignation;
    //                 ResignationApprover."Document No." := Resignation."No.";
    //                 ResignationApprover.Validate("Employee No.", Employee."No.");
    //                 ResignationApprover."Approval Status" := ResignationApprover."Approval Status"::Open;
    //                 ResignationApprover.Validate("Functional Title", Employee."Functional Title");
    //                 ResignationApprover.Insert(true);
    //             end;

    //         until Employee.Next = 0;
    // end;

    // local procedure SetResignationApprover(var EmpAct: Record "Employee Activity"; var Receipient: List of [Text])
    // var
    //     DocumentApprover: Record "Document Approver";
    // begin
    //     DocumentApprover.Reset;
    //     DocumentApprover.SetRange("Document No.", EmpAct."No.");
    //     DocumentApprover.SetFilter("Employee No.", '<>%1', '');
    //     if DocumentApprover.FindFirst then
    //         repeat
    //             Employee.Get(DocumentApprover."Employee No.");
    //             if Employee."Company E-Mail" <> '' then begin
    //                 // if Receipient <> '' then
    //                 //     Receipient += ';' + Employee."Company E-Mail"
    //                 // else
    //                 Receipient.add(Employee."Company E-Mail");
    //             end;

    //         until DocumentApprover.Next = 0;
    // end;

    procedure CheckDocumentApprover(DocumentNo: Code[20])
    var
        DocumentApproverRec: Record "Document Approver";
    begin
        DocumentApproverRec.Reset;
        DocumentApproverRec.SetRange("Document No.", DocumentNo);
        DocumentApproverRec.SetFilter("Employee Type", '<>%1', DocumentApproverRec."Employee Type"::"Initiated By");
        DocumentApproverRec.SetFilter("Employee No.", '<>%1', '');
        if DocumentApproverRec.FindFirst then
            repeat
                DocumentApproverRec.TestField("Approval Status", DocumentApproverRec."Approval Status"::Approved);
            until DocumentApproverRec.Next = 0;
    end;

    // procedure ScreenResignationforTravel(var TravelReq: Record "Travel Request")
    // var
    //     ConfirmScreen: Label 'Do you want to screen this document?';
    //     FunctionalTitle: Record "Functional Title";
    // begin
    //     //check authorized user
    //     Employee.Get(GetEmployeeNo());
    //     if TravelReq.Type = TravelReq.Type::Resignation then begin
    //         if not Employee.Screener then           //resignation approver replaced with screener
    //             Error('Not authorized screener.');
    //         TravelReq.TestField("Approval Status", TravelReq."Approval Status"::"Forwarded To HR");
    //         //  EmpAct.TESTFIELD("Screener Remarks");
    //         CheckDocumentApprover(TravelReq."No.");
    //         CheckResignationAttachmentMandatoryforTravel(TravelReq);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
    //         TravelReq.Modify;
    //     end
    //     else if TravelReq.Type = TravelReq.Type::"Travel Claim" then begin
    //         /*HRSetup.GET;
    //         Employee.RESET;
    //         Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
    //         Employee.SETRANGE("NAV Login ID", USERID);
    //         IF NOT Employee.FINDFIRST THEN
    //             ERROR('Not authorized screener.');*///AT
    //         if not (TravelReq."Approval Status" = TravelReq."Approval Status"::Approved) then
    //             Error('Approval Status must be approved before screening.');
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
    //         TravelReq.Modify;
    //     end else if TravelReq.Type = TravelReq.Type::Overtime then begin
    //         TravelReq.TestField("Approval Status", TravelReq."Approval Status"::Approved);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
    //         TravelReq.Modify;
    //     end;

    // end;

    // procedure ScreenResignation(var EmpAcctivity: Record "Employee Activity")
    // var
    //     ConfirmScreen: Label 'Do you want to screen this document?';
    //     FunctionalTitle: Record "Functional Title";
    // begin
    //     //check authorized user
    //     Employee.Get(GetEmployeeNo());
    //     if EmpAcctivity.Type = EmpAcctivity.Type::Resignation then begin
    //         if not Employee.Screener then           //resignation approver replaced with screener
    //             Error('Not authorized screener.');
    //         EmpAcctivity.TestField("Approval Status", EmpAcctivity."Approval Status"::"Forwarded To HR");
    //         //  EmpAct.TESTFIELD("Screener Remarks");
    //         CheckDocumentApprover(EmpAcctivity."No.");
    //         CheckResignationAttachmentMandatory(EmpAcctivity);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         EmpAcctivity.Validate("Approval Status", EmpAcctivity."Approval Status"::Screened);
    //         EmpAcctivity.Modify;
    //     end
    //     else if EmpAcctivity.Type = EmpAcctivity.Type::"Travel Claim" then begin
    //         /*HRSetup.GET;
    //         Employee.RESET;
    //         Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
    //         Employee.SETRANGE("NAV Login ID", USERID);
    //         IF NOT Employee.FINDFIRST THEN
    //             ERROR('Not authorized screener.');*///AT
    //         if not (EmpAcctivity."Approval Status" = EmpAcctivity."Approval Status"::Approved) then
    //             Error('Approval Status must be approved before screening.');
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         EmpAcctivity.Validate("Approval Status", EmpAcctivity."Approval Status"::Screened);
    //         EmpAcctivity.Modify;
    //     end else if EmpAcctivity.Type = EmpAcctivity.Type::Overtime then begin
    //         EmpAcctivity.TestField("Approval Status", EmpAcctivity."Approval Status"::Approved);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         EmpAcctivity.Validate("Approval Status", EmpAcctivity."Approval Status"::Screened);
    //         EmpAcctivity.Modify;
    //     end;

    // end;

    // procedure ScreenResignationFoResignation(var Resignation: Record "Resignation")
    // var
    //     ConfirmScreen: Label 'Do you want to screen this document?';
    //     FunctionalTitle: Record "Functional Title";
    // begin
    //     //check authorized user
    //     Employee.Get(GetEmployeeNo());
    //     if Resignation.Type = Resignation.Type::Resignation then begin
    //         if not Employee.Screener then           //resignation approver replaced with screener
    //             Error('Not authorized screener.');
    //         Resignation.TestField("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
    //         //  EmpAct.TESTFIELD("Screener Remarks");
    //         CheckDocumentApprover(Resignation."No.");
    //         CheckResignationAttachmentMandatoryForResignation(Resignation);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
    //         Resignation.Modify;
    //     end
    //     else if Resignation.Type = Resignation.Type::"Travel Claim" then begin
    //         /*HRSetup.GET;
    //         Employee.RESET;
    //         Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
    //         Employee.SETRANGE("NAV Login ID", USERID);
    //         IF NOT Employee.FINDFIRST THEN
    //             ERROR('Not authorized screener.');*///AT
    //         if not (Resignation."Approval Status" = Resignation."Approval Status"::Approved) then
    //             Error('Approval Status must be approved before screening.');
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
    //         Resignation.Modify;
    //     end else if Resignation.Type = Resignation.Type::Overtime then begin
    //         Resignation.TestField("Approval Status", Resignation."Approval Status"::Approved);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         Resignation.Validate("Approval Status", Resignation."Approval Status"::Screened);
    //         Resignation.Modify;
    //     end;

    // end;

    // procedure ScreenResignationForOvertime(var Overtime: Record "OverTime")
    // var
    //     ConfirmScreen: Label 'Do you want to screen this document?';
    //     FunctionalTitle: Record "Functional Title";
    // begin
    //     //check authorized user
    //     Employee.Get(GetEmployeeNo());
    //     if Overtime.Type = Overtime.Type::Resignation then begin
    //         if not Employee.Screener then           //resignation approver replaced with screener
    //             Error('Not authorized screener.');
    //         Overtime.TestField("Approval Status", Overtime."Approval Status"::"Forwarded To HR");
    //         //  EmpAct.TESTFIELD("Screener Remarks");
    //         CheckDocumentApprover(Overtime."No.");
    //         CheckResignationAttachmentMandatoryForOvertime(Overtime);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         Overtime.Validate("Approval Status", Overtime."Approval Status"::Screened);
    //         Overtime.Modify;
    //     end
    //     else if Overtime.Type = Overtime.Type::"Travel Claim" then begin
    //         /*HRSetup.GET;
    //         Employee.RESET;
    //         Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
    //         Employee.SETRANGE("NAV Login ID", USERID);
    //         IF NOT Employee.FINDFIRST THEN
    //             ERROR('Not authorized screener.');*///AT
    //         if not (Overtime."Approval Status" = Overtime."Approval Status"::Approved) then
    //             Error('Approval Status must be approved before screening.');
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         Overtime.Validate("Approval Status", Overtime."Approval Status"::Screened);
    //         Overtime.Modify;
    //     end else if Overtime.Type = Overtime.Type::Overtime then begin
    //         Overtime.TestField("Approval Status", Overtime."Approval Status"::Approved);
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //         Overtime.Validate("Approval Status", Overtime."Approval Status"::Screened);
    //         Overtime.Modify;
    //     end;

    // end;

    // procedure ForwardToHRforTravel(var TravelReq: Record "Travel Request")
    // var
    //     ConfirmScreen: Label 'Do you want to confirm screen this document?';
    // begin
    //     //check authorized user
    //     Employee.Get(GetEmployeeNo());
    //     if not (Employee."No." = TravelReq."Employee No.") then
    //         Error('Only employee %1 can forward this document to HR.', TravelReq."Employee Name");
    //     CheckDocumentApprover(TravelReq."No.");
    //     TravelMgt.CheckResignationAttachmentMandatoryforTravel(TravelReq);
    //     if GuiAllowed then
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //     TravelReq.Validate("Approval Status", TravelReq."Approval Status"::"Forwarded To HR");
    //     TravelReq.Modify;
    // end;

    procedure ForwardToHR(var Resignation: Record Resignation)
    var
        ConfirmScreen: Label 'Do you want to confirm screen this document?';
    begin
        //check authorized user
        Employee.Get(GetEmployeeNo());
        if not (Employee."No." = Resignation."Employee No.") then
            Error('Only employee %1 can forward this document to HR.', Resignation."Employee Name");
        CheckDocumentApprover(Resignation."No.");
        ResignationMgt.CheckResignationAttachmentMandatory(Resignation);
        if GuiAllowed then
            if not Confirm(ConfirmScreen, false) then
                exit;

        //Resignation.Validate("Approval Status", Resignation."Approval Status"::"Forwarded To HR"); <<Santosh Commented
        Resignation.Modify;
    end;

    // procedure ForwardToHRForResignation(var Resignation: Record "Resignation")
    // var
    //     ConfirmScreen: Label 'Do you want to confirm screen this document?';
    // begin
    //     //check authorized user
    //     Employee.Get(GetEmployeeNo());
    //     if not (Employee."No." = Resignation."Employee No.") then
    //         Error('Only employee %1 can forward this document to HR.', Resignation."Employee Name");
    //     CheckDocumentApprover(Resignation."No.");
    //     CheckResignationAttachmentMandatoryForResignation(Resignation);
    //     if GuiAllowed then
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;

    //     Resignation.Validate("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
    //     Resignation.Modify;
    // end;

    // procedure UpdateResignationWaiver(var Resignation: Record "Resignation")
    // var
    //     ResignationDays: Integer;
    // begin
    //     HRSetup.Get;
    //     Employee.Get(Resignation."Employee No.");
    //     case Employee."Employment Type" of
    //         Employee."Employment Type"::Contract:
    //             begin
    //                 HRSetup.TestField("Resignation Period Contract");
    //                 ResignationDays := HRSetup."Resignation Period Contract";
    //             end;
    //         Employee."Employment Type"::Probation:
    //             begin
    //                 HRSetup.TestField("Resignation Period Probation");
    //                 ResignationDays := HRSetup."Resignation Period Probation";
    //             end;

    //         Employee."Employment Type"::Permanent:
    //             begin
    //                 HRSetup.TestField("Resignation Period Permanent");
    //                 ResignationDays := HRSetup."Resignation Period Permanent";
    //             end;
    //     end;

    //     if Resignation."Requested Date" = 0D then
    //         Resignation."Requested Date" := Today;

    //     if (Resignation."Proposed Date of Resignation" - Resignation."Requested Date" + 1) >= ResignationDays then
    //         Resignation.Validate("Waiver Case", Resignation."Waiver Case"::Normal)
    //     else
    //         Resignation.Validate("Waiver Case", Resignation."Waiver Case"::Recovery);
    // end;

    // local procedure CheckResignationAttachmentMandatoryforTravel(var TravelReq: Record "Travel Request")
    // var
    //     AttachmentSetup: Record "Attachment Setup";
    //     IncomingDocument: Record "Incoming Document";
    // begin

    //     IncomingDocument.Reset;
    //     IncomingDocument.SetRange("No.", TravelReq."No.");
    //     IncomingDocument.SetRange("File Name", '');
    //     if IncomingDocument.FindFirst then
    //         repeat
    //             AttachmentSetup.Reset;
    //             AttachmentSetup.SetRange(Mandatory, true);
    //             AttachmentSetup.SetFilter(Type, Format(TravelReq.Type));
    //             AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
    //             if AttachmentSetup.FindFirst then
    //                 Error('Upload attachment for %1', IncomingDocument."Attachment Code");

    //         until IncomingDocument.Next = 0;
    // end;

    // local procedure CheckResignationAttachmentMandatory(var EmpAct: Record "Employee Activity")
    // var
    //     AttachmentSetup: Record "Attachment Setup";
    //     IncomingDocument: Record "Incoming Document";
    // begin

    //     IncomingDocument.Reset;
    //     IncomingDocument.SetRange("No.", EmpAct."No.");
    //     IncomingDocument.SetRange("File Name", '');
    //     if IncomingDocument.FindFirst then
    //         repeat
    //             AttachmentSetup.Reset;
    //             AttachmentSetup.SetRange(Mandatory, true);
    //             AttachmentSetup.SetFilter(Type, Format(EmpAct.Type));
    //             AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
    //             if AttachmentSetup.FindFirst then
    //                 Error('Upload attachment for %1', IncomingDocument."Attachment Code");

    //         until IncomingDocument.Next = 0;
    // end;

    // local procedure CheckResignationAttachmentMandatoryForResignation(var Resignation: Record "Resignation")
    // var
    //     AttachmentSetup: Record "Attachment Setup";
    //     IncomingDocument: Record "Incoming Document";
    // begin

    //     IncomingDocument.Reset;
    //     IncomingDocument.SetRange("No.", Resignation."No.");
    //     IncomingDocument.SetRange("File Name", '');
    //     if IncomingDocument.FindFirst then
    //         repeat
    //             AttachmentSetup.Reset;
    //             AttachmentSetup.SetRange(Mandatory, true);
    //             AttachmentSetup.SetFilter(Type, Format(Resignation.Type));
    //             AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
    //             if AttachmentSetup.FindFirst then
    //                 Error('Upload attachment for %1', IncomingDocument."Attachment Code");

    //         until IncomingDocument.Next = 0;
    // end;

    // local procedure CheckResignationAttachmentMandatoryForOvertime(var OverTime: Record "OverTime")
    // var
    //     AttachmentSetup: Record "Attachment Setup";
    //     IncomingDocument: Record "Incoming Document";
    // begin

    //     IncomingDocument.Reset;
    //     IncomingDocument.SetRange("No.", OverTime."No.");
    //     IncomingDocument.SetRange("File Name", '');
    //     if IncomingDocument.FindFirst then
    //         repeat
    //             AttachmentSetup.Reset;
    //             AttachmentSetup.SetRange(Mandatory, true);
    //             AttachmentSetup.SetFilter(Type, Format(OverTime.Type));
    //             AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
    //             if AttachmentSetup.FindFirst then
    //                 Error('Upload attachment for %1', IncomingDocument."Attachment Code");

    //         until IncomingDocument.Next = 0;
    // end;

    local procedure GetCandidateBody(var Candidate: Record Candidate)
    var
        BodyText1: Text;
    begin

    end;

    procedure AddRemoveDocApprover(EmpCode: Code[20]; IsDocApprover: Boolean)
    var
        DocApporver: Record "Document Approver";
        EmployeeAct: Record "Employee Activity";
        LineNo: Integer;
    begin
        EmployeeAct.Reset;
        EmployeeAct.SetRange(Type, EmployeeAct.Type::Resignation);
        EmployeeAct.SetFilter("Approval Status", '<>%1&<>%2&<>%3', EmployeeAct."Approval Status"::Approved, EmployeeAct."Approval Status"::Rejected, EmployeeAct."Approval Status"::Canceled);
        if EmployeeAct.Find('-') then
            repeat
                if not IsDocApprover then begin
                    DocApporver.Reset;
                    DocApporver.SetRange("Document No.", EmployeeAct."No.");
                    DocApporver.SetRange("Employee No.", EmpCode);
                    //DocApporver.SETFILTER("Approval Status",'<>%1',DocApporver."Approval Status"::Approved);
                    if DocApporver.FindFirst then
                        DocApporver.Delete;
                end else begin
                    DocApporver.Reset;
                    DocApporver.SetRange("Document Type", DocApporver."Document Type"::Resignation);
                    DocApporver.SetRange("Document No.", EmployeeAct."No.");
                    DocApporver.SetCurrentKey("Line No.");
                    if LineNo = 0 then
                        if DocApporver.FindLast then
                            LineNo := DocApporver."Line No.";
                    Clear(DocApporver);
                    DocApporver.Init;
                    DocApporver.Validate("Document No.", EmployeeAct."No.");
                    DocApporver.Validate("Employee No.", EmpCode);
                    DocApporver.Validate("Document Type", DocApporver."Document Type"::Resignation);
                    DocApporver."Approval Status" := DocApporver."Approval Status"::Open;
                    DocApporver.Validate("Line No.", LineNo + 10000);
                    LineNo += 10000;
                    DocApporver.Insert;
                end;
            until EmployeeAct.Next = 0;
    end;

    // procedure UpdateResign(EmpCode: Code[20])
    // var
    //     ResignPageBuilder: FilterPageBuilder;
    //     ResignDate: Date;
    // begin
    //     Employee1.Get(EmpCode);
    //     if Employee1.Status <> Employee1.Status::Active then
    //         Error('Employee %1 status must be active', Employee1."Full Name");
    //     ResignPageBuilder.AddRecord('Update to Employee Resignation', Employee);
    //     ResignPageBuilder.ADdField('Update to Employee Resignation', Employee."Termination Date");
    //     ResignPageBuilder.RunModal;
    //     Employee.SetView(ResignPageBuilder.GetView('Update to Employee Resignation'));
    //     Evaluate(ResignDate, Employee.GetFilter("Termination Date"));
    //     Employee1.Status := Employee1.Status::Inactive;
    //     Employee1."Termination Date" := ResignDate;
    //     Employee1."Resignation Date" := ResignDate;
    //     Employee1.Modify;
    //     Message('Employee has been terminated.');
    // end;

    // procedure ReturnResignation(Resignation: Record "Resignation")
    // begin
    //     Resignation.TestField("Approval Status", Resignation."Approval Status"::"Forwarded To HR");
    //     if Confirm('Do you want to return resignation?', false) then begin
    //         Resignation.Validate("Approval Status", Resignation."Approval Status"::Open);
    //         Resignation.Modify;
    //         Message('Resignation Returned.');
    //     end;
    // end;

    local procedure "--------------FOR REPORTS---------------"()
    begin
    end;

    procedure WorkStationFunction(EmployeeRec: Record Employee) WorkStation: Text
    var
        // DimensionValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        // Dept: Record Department;
        HRSetUp: Record "Human Resources Setup";
        SalaryLevel: Record "Salary Level";
    begin
        GLSetup.Get;

        if EmployeeRec."Global Dimension 2 Code" <> '' then begin
            // DimensionValue.Get(GLSetup."Global Dimension 2 Code", EmployeeRec."Global Dimension 2 Code");
            WorkStation := EmployeeRec."Branch Name";
        end
        else begin
            if EmployeeRec."Province Name" <> '' then
                WorkStation := EmployeeRec."Province Name"
            else if EmployeeRec."Unit Code" <> '' then
                WorkStation := EmployeeRec."Unit Code"
            else if EmployeeRec."Department Code" <> '' then begin
                // Dept.Get(EmployeeRec."Department Code");
                WorkStation := EmployeeRec."Department Name";
            end
            // else if EmployeeRec."Reporting Line 1" <> '' then
            //     WorkStation := EmployeeRec."Reporting Line 1"
            // else if EmployeeRec."Reporting Line 2" <> '' then
            //     WorkStation := EmployeeRec."Reporting Line 2"
            // else if EmployeeRec."Eco-System" <> '' then
            //     WorkStation := EmployeeRec."Eco-System"
            // else if EmployeeRec.Office <> '' then
            //     WorkStation := EmployeeRec.Office;
        end;
        /*IF (EmployeeRec."Employment Type" <> EmployeeRec."Employment Type"::Contract) OR
            (EmployeeRec."Employment Type" <> EmployeeRec."Employment Type"::" ") THEN
            IF SalaryLevel.GET(EmployeeRec."Salary Level") THEN
          WorkStation += ' in the internal job grade of '+ SalaryLevel.Description;*/

    end;

    local procedure "------Medical Insurance---------"()
    begin
    end;

    // procedure OpenMedicalInsuranePage(EmployeeCode: Code[20])
    // var
    //     EmployeeAct: Record "Employee Activity";
    // begin
    //     EmployeeAct.Reset;
    //     EmployeeAct.SetRange("Employee No.", EmployeeCode);
    //     EmployeeAct.SetRange(Type, EmployeeAct.Type::"Medical Insurance Claim");
    //     EmployeeAct.SetFilter("Approval Status", '<>%1', EmployeeAct."Approval Status"::Pending);
    //     if not EmployeeAct.FindFirst then begin
    //         EmployeeAct.Init;
    //         EmployeeAct.Validate(Type, EmployeeAct.Type::"Medical Insurance Claim");
    //         EmployeeAct.Validate("Employee No.", EmployeeCode);
    //         EmployeeAct.Insert(true);
    //         PAGE.Run(PAGE::"Medical Insurance Claim", EmployeeAct);
    //     end
    //     else
    //         PAGE.Run(PAGE::"Medical Insurance Claim", EmployeeAct);
    // end;

    // procedure SendMedicalInsuranceApproval(TempEmpAct: Record "Employee Activity" temporary): Boolean
    // var
    //     EmpAct: Record "Employee Activity";
    //     ConfirmResign: Label 'Do you want to send resignation request?';
    //     ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
    //     ApprovalRequestSent: Label 'Resignation request approval has been sent.';
    //     NoRecommender: Label 'No Recommender Code.';
    //     NoApprover: Label 'No Approver Code.';
    //     ResignationDays: Integer;
    // begin
    //     if not Confirm(ConfirmResign, false) then
    //         exit;


    //     EmpAct.Reset;
    //     EmpAct.Init;
    //     EmpAct.TransferFields(TempEmpAct);
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Pending);
    //     EmpAct.Validate("User ID", UserId);
    //     Employee.Get(EmpAct."Employee No.");
    //     EmpAct.Validate("Recommender Code", Employee."Approver Code");
    //     EmpAct.Validate("Approver Code", GetHrHead());

    //     if EmpAct."Recommender Code" = '' then
    //         Error(NoRecommender);
    //     if EmpAct."Approver Code" = '' then
    //         Error(NoApprover);

    //     if EmpAct."Requested Date" = 0D then
    //         EmpAct."Requested Date" := Today;




    //     EmpAct.Insert(true);

    //     InsertAttachmentLines(EmpAct."No.", Format(EmpAct.Type));//attachment
    //     ResignationMgt.InsertResignationApprover(EmpAct); //resignation approver

    //     SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::Resignation, EmpAct."Approval Status"::Open, '', EmpAct."Employee No.", EmpAct."No.", 0);   //For email
    //     Message(ApprovalRequestSent);
    //     exit(true);
    // end;

    // procedure CancelMedicalInsuranceApproval(var EmpAct: Record "Employee Activity")
    // var
    //     ConfirmCancel: Label 'Do you want to confirm cancel resignation request?';
    // begin
    //     EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Pending);
    //     if not Confirm(ConfirmCancel, false) then
    //         exit;
    //     EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Cancelled);
    //     EmpAct.Modify(true);
    // end;

    // procedure ApproveRejectMedicalInsurance(Approve: Boolean; var MedicalInsurance: Record "Medical Insurance Claim")
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    // begin
    //     if Approve then begin
    //         if not Confirm(ConfirmApprove, false) then
    //             exit;
    //         if MedicalInsurance."Insurance Status" = MedicalInsurance."Insurance Status"::"Forwarded to Insurance Co." then begin
    //             MedicalInsurance.Validate("Insurance Status", MedicalInsurance."Insurance Status"::Reimbursed);
    //             SendMailFromTemplate(DATABASE::"Employee Activity", MedicalInsurance.Type::"Medical Insurance Claim", MedicalInsurance."Approval Status"::Open, '', MedicalInsurance."Employee No.", MedicalInsurance."No.", 0);   //For email
    //             Message('Insurance Claim reimbursement email has been sent.');
    //         end;
    //     end
    //     else begin
    //         if not Confirm(ConfirmReject, false) then
    //             exit;
    //         MedicalInsurance.Validate("Insurance Status", MedicalInsurance."Insurance Status"::Rejected);
    //     end;

    //     MedicalInsurance.Modify;
    // end;

    // local procedure InsertAttachmentLinesMedicalInsurance(var EmpAct: Record "Employee Activity")
    // var
    //     IncomingDocument: Record "Incoming Document";
    //     AttachmentMandatory: Record "Attachment Setup";
    // begin
    //     AttachmentMandatory.Reset;
    //     //AttachmentMandatory.SETRANGE("Table ID", DATABASE::"Employee Activity");
    //     AttachmentMandatory.SetFilter(Type, Format(EmpAct.Type));
    //     if AttachmentMandatory.FindFirst then
    //         repeat
    //             IncomingDocument.Reset;
    //             IncomingDocument.SetRange("Table ID", DATABASE::"Employee Activity");
    //             IncomingDocument.SetRange("Order No.", EmpAct."No.");
    //             IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
    //             if not IncomingDocument.FindFirst then begin
    //                 IncomingDocument.Reset;
    //                 IncomingDocument.Init;
    //                 IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
    //                 IncomingDocument.Description := EmpAct.TableName;
    //                 IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
    //                 IncomingDocument."No." := EmpAct."No.";
    //                 IncomingDocument."Order No." := EmpAct."Employee No.";
    //                 IncomingDocument."Table ID" := DATABASE::"Employee Activity";
    //                 IncomingDocument.Insert(true);

    //             end;
    //         until AttachmentMandatory.Next = 0;
    // end;

    // local procedure InsertMedicalInsuranceApprover(var EmpAct: Record "Employee Activity")
    // var
    //     ResignationApprover: Record "Document Approver";
    //     Employee: Record Employee;
    //     EmpFieldRef: FieldRef;
    //     EmpRecordRef: RecordRef;
    // begin
    //     Employee.Reset;
    //     Employee.SetRange("Resignation Approver", true);
    //     if Employee.FindFirst then
    //         repeat
    //             ResignationApprover.Reset;
    //             ResignationApprover.SetRange("Document No.", EmpAct."No.");
    //             ResignationApprover.SetRange("Employee No.", Employee."No.");
    //             //ResignationApprover.SETRANGE("Approver Type", ResignationApprover."Approver Type"::"Finance & Accounts");
    //             if not ResignationApprover.FindFirst then begin
    //                 ResignationApprover.Init;
    //                 ResignationApprover."Document No." := EmpAct."No.";
    //                 ResignationApprover.Validate("Employee No.", Employee."No.");
    //                 ResignationApprover."Approval Status" := ResignationApprover."Approval Status"::Open;
    //                 ResignationApprover.Validate("Functional Title", Employee."Functional Title");
    //                 ResignationApprover.Insert(true);
    //             end;

    //         until Employee.Next = 0;
    // end;

    // local procedure SetMedicalInsuranceApprover(var EmpAct: Record "Employee Activity"; var Receipient: Text)
    // var
    //     DocumentApprover: Record "Document Approver";
    // begin
    //     DocumentApprover.Reset;
    //     DocumentApprover.SetRange("Document No.", EmpAct."No.");
    //     DocumentApprover.SetFilter("Employee No.", '<>%1', '');
    //     if DocumentApprover.FindFirst then
    //         repeat
    //             Employee.Get(DocumentApprover."Employee No.");
    //             if Employee."Company E-Mail" <> '' then begin
    //                 if Receipient <> '' then
    //                     Receipient += ';' + Employee."Company E-Mail"
    //                 else
    //                     Receipient := Employee."Company E-Mail";
    //             end;

    //         until DocumentApprover.Next = 0;
    // end;

    // procedure ScreenMedicalInsurance(var Medicalinsurance: Record "Medical Insurance Claim")
    // var
    //     ConfirmScreen: Label 'Do you want to confirm screen this document?';
    // begin
    //     //check authorized user
    //     if Medicalinsurance."Insurance Status" = Medicalinsurance."Insurance Status"::"Request to DTMD" then begin
    //         Employee.Get(GetEmployeeNo());
    //         if not Confirm(ConfirmScreen, false) then
    //             exit;
    //         Medicalinsurance.Validate("Insurance Status", Medicalinsurance."Insurance Status"::"Forwarded to Insurance Co.");
    //         Medicalinsurance.Modify;
    //     end;
    // end;

    procedure getDeputation(empCode: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(empCode) then
            exit(employee."Deputation On Code");
    end;

    // local procedure "------Appraisal---------"()
    // begin
    // end;

    // procedure AppraisalEmail(AppraisalCode: Code[20]; EmployeeCode: Code[20])
    // var
    //     AppraisalRec: Record Appraisal;
    //     CompanyInfo: Record "Company Information";
    //     // SMTPSetup: Record "SMTP Mail Setup";
    //     EmailTemplate: Record "Email Template";
    //     HRSetup: Record "Human Resources Setup";
    //     EmailMessage: Record "Agile Email Message";
    //     Header: Text;
    //     Body: Text;
    //     Footer: Text;
    //     Counter: Integer;
    // begin
    //     CompanyInfo.Get;
    //     // SMTPSetup.Get;
    //     Clear(CodeunitEmailMessage);
    //     HRSetup.Get;
    //     HRSetup.TestField("Email Appraisal");
    //     AppraisalRec.Reset;
    //     Counter := 0;
    //     AppraisalRec.SetRange("Appraisal Code", AppraisalCode);
    //     if AppraisalRec.FindFirst then
    //         repeat
    //             if EmailTemplate.Get(HRSetup."Email Appraisal") then begin
    //                 Clear(Footer);
    //                 Clear(Header);
    //                 Clear(Body);
    //                 Employee.Get(EmployeeCode);
    //                 // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Employee."E-Mail(Personal)", EmailTemplate.Subject, '', true);
    //                 CodeunitEmailMessage.Create(Employee."E-Mail", EmailTemplate.Subject, '');
    //                 EmailMessage.SetRange("Template Code", EmailTemplate.Code);
    //                 if EmailMessage.FindFirst then
    //                     repeat
    //                         case EmailMessage.Type of
    //                             EmailMessage.Type::Header:
    //                                 Header := Header + EmailMessage."Body Message";

    //                             EmailMessage.Type::Body:
    //                                 Body := Body + EmailMessage."Body Message";

    //                             EmailMessage.Type::Footer:
    //                                 Footer := Footer + EmailMessage."Body Message";
    //                         end;
    //                     until EmailMessage.Next = 0;
    //                 CodeunitEmailMessage.AppendToBody(Header);
    //                 CodeunitEmailMessage.AppendToBody('<br><br>');
    //                 CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("Appraisal Code") + Colon + Format(AppraisalRec."Appraisal Code"));
    //                 CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("Employee Name") + Colon + Format(AppraisalRec."Employee Name"));
    //                 CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("Appraisal Type") + Colon + Format(AppraisalRec."Appraisal Type"));
    //                 CodeunitEmailMessage.AppendToBody(AppraisalRec.FieldCaption("KRA Category") + Colon + Format(AppraisalRec."KRA Category"));
    //                 CodeunitEmailMessage.AppendToBody('<br><br>');
    //                 CodeunitEmailMessage.AppendToBody(Footer);
    //                 if Email.Send(CodeunitEmailMessage) then
    //                     Counter += 1;
    //             end;
    //         until AppraisalRec.Next = 0;
    //     if Counter <> 0 then
    //         Message('Mail Sent');
    // end;

    // procedure CancelAppraisalApproval(var Appraisal: Record Appraisal)
    // var
    //     ConfirmCancel: Label 'Do you want to confirm cancel appraisal request?';
    // begin
    //     Appraisal.TestField(Status, Appraisal.Status::Submitted);
    //     if not Confirm(ConfirmCancel, false) then
    //         exit;
    //     Appraisal.Validate(Status, Appraisal.Status::Cancelled);
    //     Appraisal.Modify(true);
    // end;

    // procedure ApproveRejectAppraisal(Approve: Boolean; var Appraisal: Record Appraisal)
    // var
    //     ConfirmApprove: Label 'Confirm Approve?';
    //     ConfirmReject: Label 'Confirm Reject?';
    // begin
    //     CheckAppraisalApproval(Appraisal); //check authorized
    //     if Approve then begin
    //         if not Confirm(ConfirmApprove, false) then
    //             exit;
    //         if Appraisal.Status = Appraisal.Status::Requested then
    //             Appraisal.Validate(Status, Appraisal.Status::Reviewed)
    //         else if Appraisal.Status = Appraisal.Status::Reviewed then
    //             Appraisal.Validate(Status, Appraisal.Status::"Check Reviewed")
    //         else if Appraisal.Status = Appraisal.Status::"Check Reviewed" then
    //             Appraisal.Validate(Status, Appraisal.Status::Approved);
    //     end
    //     else begin
    //         if not Confirm(ConfirmReject, false) then
    //             exit;
    //         Appraisal.Validate(Status, Appraisal.Status::Requested);
    //     end;

    //     Appraisal.Modify;
    // end;

    // local procedure CheckAppraisalApproval(Appraisal: Record Appraisal)
    // var
    //     ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
    //     RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
    //     AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    //     ReviewNotEligibleError: Label 'You are not Eligible to review this document.';
    //     CheckReviewNotEligibleError: Label 'You are not Eligible to check review this document.';
    // begin
    //     Employee.Reset;
    //     Employee.SetRange("NAV Login ID", UserId);
    //     Employee.FindFirst;
    //     if Appraisal.Status = Appraisal.Status::Requested then
    //         if StrPos(Appraisal.Reviewer, Employee."No.") = 0 then
    //             Error(ReviewNotEligibleError);
    //     if Appraisal.Status = Appraisal.Status::Reviewed then
    //         if StrPos(Appraisal."Check Reviewer", Employee."No.") = 0 then
    //             Error(CheckReviewNotEligibleError);
    //     if Appraisal.Status = Appraisal.Status::"Check Reviewed" then
    //         if StrPos(Appraisal."Approver Code", Employee."No.") = 0 then
    //             Error(ApproveNotEligibleError);
    // end;

    // procedure OnValidateKRACategory(AppraisalRec: Record Appraisal)
    // var
    //     KRASubform: Record "KRA Subform List";
    // begin
    //     KRASubform.Reset;
    //     KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //     KRASubform.SetRange("Employee Code", AppraisalRec."Employee Code");
    //     KRASubform.DeleteAll;

    //     if AppraisalRec."Appraisal Type" = AppraisalRec."Appraisal Type"::Annually then begin //Min 7.26.2022
    //         ValidateKRAInEmployeeKRAAnnually(AppraisalRec);
    //         ValidateKRAInEmployeeKPIAnnually(AppraisalRec);
    //         ValidateKRAInEmployeeSATKPIAnnually(AppraisalRec);
    //         InsertEmployeeKPIAnnually(AppraisalRec);
    //     end else begin
    //         ValidateKRAInEmployeeKRA(AppraisalRec);
    //         InsertEmployeeKPI(AppraisalRec);
    //     end;
    // end;

    // local procedure ValidateKRAInEmployeeKRA(AppraisalRec: Record Appraisal)
    // var
    //     KRAMaster: Record "KRA Master Setup";
    //     KRASubform: Record "KRA Subform List";
    // begin
    //     KRAMaster.Reset;
    //     KRAMaster.SetRange("KRA Category", AppraisalRec."KRA Category");
    //     KRAMaster.SetRange("Deputation on", KRAMaster."Deputation on"::" ");
    //     KRAMaster.SetFilter(Weightage, '>%1', 0);
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

    // procedure InsertEmployeeKPI(AppraisalRec: Record Appraisal)
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
    //     KPIEmpRec.DeleteAll;
    //     if KPIMaster.Find('-') then
    //         repeat
    //         begin
    //             KPIEmpRec.Init;
    //             KPIEmpRec.Validate("Appraisal Code", AppraisalRec."Appraisal Code");
    //             KPIEmpRec.Validate("Employee Code", AppraisalRec."Employee Code");
    //             KPIEmpRec.Validate("KRA Category", KPIMaster."KRA Category");
    //             KPIEmpRec.Validate("Fiscal Year", AppraisalRec."Fiscal Year");
    //             KPIEmpRec.Validate("Appraisal Type", KPIMaster."Appraisal Type");
    //             KPIEmpRec.Validate("Appraisal Subtype Monthly", KPIMaster."Appraisal Subtype Monthly");
    //             KPIEmpRec.Validate("Appraisal Subtype Quarterly", KPIMaster."Appraisal Subtype Quarterly");
    //             KPIEmpRec.Validate(Description, KPIMaster.Description);
    //             KPIEmpRec.Validate("KPI No.", KPIMaster."KPI No.");
    //             KPIEmpRec.Validate(Description, KPIMaster.Description);
    //             KPIEmpRec.Validate("Key Result Area", KPIMaster."Key Result Area");
    //             KPIEmpRec.Validate("Weightage(%)", KPIMaster."Weightage (%)");
    //             KPIEmpRec.Validate("Target Assigned", KPIMaster."Target Assigned");
    //             KPIEmpRec.Validate("From Setup", true);
    //             KPIEmpRec.Insert(true);
    //         end;
    //         until KPIMaster.Next = 0;
    //     KRASubform.Reset;
    //     KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //     if KRASubform.Find('-') then
    //         repeat
    //             Clear(KPIWeightage);
    //             KPIEmpRec.Reset;
    //             KPIEmpRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //             KPIEmpRec.SetRange("Key Result Area", KRASubform."Key Result Area");
    //             KPIEmpRec.CalcSums("Weightage(%)");
    //             KPIWeightage := KPIEmpRec."Weightage(%)";
    //             if (KPIEmpRec.FindFirst) and (KPIWeightage <> 100) then
    //                 Error('Total weightage of KPIs in KRA (%1) must be 100', KRASubform.Description);
    //         until KRASubform.Next = 0;
    // end;

    // procedure CalculateKPIMarks(AppraisalRec: Record Appraisal)
    // var
    //     KRASubform: Record "KRA Subform List";
    //     TotalWeight: Decimal;
    //     TotalMarks: Decimal;
    //     KPIRec: Record "KPI Employee";
    //     KRAWeight: Decimal;
    // begin
    //     Clear(KRAWeight);
    //     KRASubform.Reset;
    //     KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //     KRASubform.CalcSums("Weightage (%)");
    //     KRAWeight := KRASubform."Weightage (%)";
    //     if KRASubform.Find('-') then
    //         repeat
    //             KPIRec.Reset;
    //             KPIRec.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //             KPIRec.SetRange("Employee Code", AppraisalRec."Employee Code");
    //             KPIRec.SetRange("Key Result Area", KRASubform."Key Result Area");
    //             if KPIRec.Find('-') then
    //                 repeat
    //                     TotalWeight += KPIRec."Weightage(%)";
    //                     TotalMarks += (KPIRec."Weightage(%)" * KPIRec.Score);
    //                 until KPIRec.Next = 0;
    //             KRASubform.Validate(Score, Round(TotalMarks / TotalWeight, 0.01, '='));
    //             if KRAWeight <> 0 then
    //                 KRASubform.Validate("Final Score", Round(TotalMarks * KRASubform."Weightage (%)" / KRAWeight));
    //             KRASubform.Modify;
    //         until KRASubform.Next = 0;
    // end;

    // procedure CalculateFinalScore(AppraisalRec: Record Appraisal)
    // var
    //     KRASubform: Record "KRA Subform List";
    //     TotalWeight: Decimal;
    //     TotalMarks: Decimal;
    // begin
    //     Clear(TotalMarks);
    //     Clear(TotalWeight);
    //     KRASubform.Reset;
    //     KRASubform.SetRange("Appraisal Code", AppraisalRec."Appraisal Code");
    //     if KRASubform.Find('-') then
    //         repeat
    //             TotalWeight += KRASubform."Weightage (%)";
    //             TotalMarks += (KRASubform."Weightage (%)" * KRASubform."HR Score");
    //         until KRASubform.Next = 0;
    //     if TotalWeight > 0 then
    //         AppraisalRec.Validate("Final Score", Round(TotalMarks / TotalWeight, 0.01, '='));
    //     AppraisalRec.Modify;
    // end;

    local procedure "----------Cancel-----------"()
    begin
    end;

    // procedure OpenCancelEmpActivity(EmpActivity: Record "Employee Activity")
    // var
    //     //Leave: Record "Leave" temporary;
    //     TempEmpActivity: Record "Employee Activity" temporary;
    // begin
    //     if not Confirm('Do you want to cancel document?', false) then
    //         exit;
    //     EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Approved);
    //     EmpActivity.TestField("Cancelled Document No.", '');
    //     TempEmpActivity.Init;
    //     TempEmpActivity.Validate(Cancelled, true);
    //     TempEmpActivity.Validate("Employee No.", EmpActivity."Employee No.");
    //     TempEmpActivity.Validate("Employee Name", EmpActivity."Employee Name");
    //     TempEmpActivity.Validate("Approval Status", TempEmpActivity."Approval Status"::Open);
    //     TempEmpActivity.Validate(Type, EmpActivity.Type);
    //     TempEmpActivity.Validate("Leave Code", EmpActivity."Leave Code");
    //     TempEmpActivity.Validate("Requested Date", Today);
    //     TempEmpActivity.Validate("Start Date", EmpActivity."Start Date");
    //     TempEmpActivity.Validate("End Date", EmpActivity."End Date");
    //     TempEmpActivity.Validate("No. of Days", EmpActivity."No. of Days");
    //     TempEmpActivity.Validate("Recommender Code", EmpActivity."Recommender Code");
    //     TempEmpActivity.Validate("Approver Code", EmpActivity."Approver Code");
    //     TempEmpActivity."Cancelled Document No." := EmpActivity."No.";
    //     TempEmpActivity.Insert;
    //     if PAGE.RunModal(PAGE::"Cancel Document", TempEmpActivity) = ACTION::LookupOK then;
    // end;

    // procedure ApplyCancelEmployeeActivity(TempEmpActivity: Record "Employee Activity" temporary)
    // var
    //     EmployeeActivity: Record "Employee Activity";
    //     EmployeeActivity2: Record "Employee Activity";
    //     EmpAct: Record "Employee Activity";
    //     LeaveCancelError: Label 'Your leave request no. %1 of code %2 has been already cancelled.';
    // begin
    //     if GuiAllowed then
    //         if not Confirm('Do you want to apply the document?', false) then
    //             exit;
    //     if TempEmpActivity.Type = TempEmpActivity.Type::"Leave Request" then begin //Min 10.13.2022
    //         EmpAct.Reset;
    //         EmpAct.SetRange("Cancelled Document No.", TempEmpActivity."Cancelled Document No.");
    //         EmpAct.SetFilter("Approval Status", '<>%1', EmpAct."Approval Status"::Rejected);
    //         if EmpAct.FindFirst then
    //             Error(LeaveCancelError, EmpAct."No.", EmpAct."Leave Code");
    //     end;
    //     PayrollSetup.Get;
    //     if TempEmpActivity.Type = TempEmpActivity.Type::"Attendance Missed" then
    //         CheckForLeaveOnAttendanceMissed(TempEmpActivity."Start Date", TempEmpActivity."End Date", TempEmpActivity."Employee No.");
    //     if TempEmpActivity."No." = '' then begin
    //         TempEmpActivity.TestField("Start Date");
    //         if (TempEmpActivity."Start Date" >= Today) or (TempEmpActivity."End Date" >= Today) then
    //             Error('Cannot apply for future date.Please check the date.');
    //         if TempEmpActivity."Start Date" < PayrollSetup."Payroll Fiscal Year Start Date" then
    //             Error('Cannot apply before fiscal year start date %1.', PayrollSetup."Payroll Fiscal Year Start Date");
    //         TempEmpActivity.TestField("End Date");
    //         TempEmpActivity.TestField(Remarks);
    //         EmployeeActivity.Init;
    //         EmployeeActivity.TransferFields(TempEmpActivity);
    //         if TempEmpActivity."Recommender Code" <> '' then
    //             EmployeeActivity.Validate("Approval Status", EmployeeActivity."Approval Status"::Pending)
    //         else
    //             EmployeeActivity.Validate("Approval Status", EmployeeActivity."Approval Status"::Recommended);

    //         EmployeeActivity."Cancelled No." := '';
    //         EmployeeActivity.Insert(true);
    //     end else begin
    //         EmployeeActivity.Get(TempEmpActivity."No.");
    //         if EmployeeActivity."Recommender Code" <> '' then
    //             EmployeeActivity.Validate("Approval Status", EmployeeActivity."Approval Status"::Pending)
    //         else
    //             EmployeeActivity.Validate("Approval Status", EmployeeActivity."Approval Status"::Recommended);
    //         EmployeeActivity.Modify(true);
    //     end;


    //     if EmployeeActivity.Type = EmployeeActivity.Type::"Leave Request" then begin
    //         Clear(EmployeeActivity2);
    //         EmployeeActivity2.Get(TempEmpActivity."Cancelled Document No.");
    //         EmployeeActivity2."Cancelled No." := EmployeeActivity."No.";
    //         EmployeeActivity2.Modify;

    //         if (EmployeeActivity."Start Date" < EmployeeActivity2."Start Date") or (EmployeeActivity."End Date" < EmployeeActivity2."Start Date") then
    //             Error('Date must be between %1 and %2', EmployeeActivity2."Start Date", EmployeeActivity2."End Date");

    //         if (EmployeeActivity."Start Date" > EmployeeActivity2."End Date") or (EmployeeActivity."End Date" > EmployeeActivity2."End Date") then
    //             Error('Date must be between %1 and %2', EmployeeActivity2."Start Date", EmployeeActivity2."End Date");

    //     end;
    // end;


    // procedure ScreenCancelledLeave(EmpAct: Record "Employee Activity")
    // var
    //     LeaveEarn: Record "Leave Earn";
    //     EmpAttendActivity: Record "Employee Attendance & Activity";
    // begin
    //     EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Approved);
    //     EmpAct.TestField(Type, EmpAct.Type::"Leave Request");
    //     Employee.Get(GetEmployeeNo);
    //     // if not Employee.Screener then
    //     //     Error('You are not eligible to screen this document.');
    //     if EmpAct.Type = EmpAct.Type::"Leave Request" then begin
    //         //LeaveEarn.RESET;
    //         LeaveEarn.Init;
    //         LeaveEarn.Validate("Leave Code", EmpAct."Leave Code");
    //         LeaveEarn.Validate("Leave Description", EmpAct."Leave Description");
    //         LeaveEarn.Validate("Leave Request No", EmpAct."No.");
    //         LeaveEarn.Validate(EmpNo, EmpAct."Employee No.");
    //         LeaveEarn.Validate("Employee Full Name", EmpAct."Employee Name");
    //         LeaveEarn.Validate("Fiscal year", ReturnFiscalYear(Today));
    //         LeaveEarn.Validate("Posted Date", Today);
    //         LeaveEarn.Validate("Balancing Days", EmpAct."No. of Days");
    //         LeaveEarn.Validate(Type, LeaveEarn.Type::Cancelled);
    //         LeaveEarn.Insert(true);

    //         EmpAttendActivity.Reset;
    //         EmpAttendActivity.SetRange("Employee No.", EmpAct."Employee No.");
    //         EmpAttendActivity.SetRange("Attendance Date", EmpAct."Start Date", EmpAct."End Date");
    //         if EmpAttendActivity.Find('-') then
    //             repeat
    //                 if EmpAttendActivity."Check In Time" <> 0T then begin
    //                     EmpAttendActivity."Absent Day" := 0;
    //                     EmpAttendActivity."Present Day" := 1;
    //                 end else begin
    //                     EmpAttendActivity."Present Day" := 0;
    //                     EmpAttendActivity."Absent Day" := 1;
    //                 end;
    //                 if LeaveMgt.GetNonWokingDays(EmpAttendActivity."Attendance Date", EmpAttendActivity."Attendance Date", EmpAttendActivity."Employee No.") <> 0 then begin
    //                     EmpAttendActivity."Absent Day" := 0;
    //                 end;
    //                 EmpAttendActivity."Leave Day" := 0;
    //                 //EmpAttendActivity."Week Off Day" := 0;
    //                 EmpAttendActivity."Tour Day" := 0;
    //                 EmpAttendActivity."Source No." := EmpAct."No.";
    //                 EmpAttendActivity."Employee Activity Found" := true;
    //                 EmpAttendActivity."Leave Description" := '';
    //                 EmpAttendActivity."Created Datetime" := CurrentDateTime;
    //                 EmpAttendActivity.Modify;
    //             until EmpAttendActivity.Next = 0;
    //     end;
    //     EmpAct."Approval Status" := EmpAct."Approval Status"::Screened;
    //     EmpAct.Modify;
    // end;

    procedure ApproveRejectCancelAttendanceMissed(EmpAct: Record "Employee Activity"; IsApproved: Boolean)
    var
        LeaveEarn: Record "Leave Earn";
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then begin
            if StrPos(EmpAct."Recommender Code", GetEmployeeNo) = 0 then
                Error('You are not eligible')
            else begin
                if IsApproved then begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Recommended;
                    Message('Document has been recommeded');
                end else begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Rejected;
                    Message('Document has been rejected.');
                end;
            end;
        end else if EmpAct."Approval Status" = EmpAct."Approval Status"::Recommended then begin
            if StrPos(EmpAct."Approver Code", GetEmployeeNo) = 0 then
                Error('You are not eligible')
            else begin
                if IsApproved then begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Approved;

                    if EmpAct.Type = EmpAct.Type::"Attendance Missed" then begin
                        EmpAttendActivity.Reset;
                        EmpAttendActivity.SetRange("Employee No.", EmpAct."Employee No.");
                        EmpAttendActivity.SetRange("Attendance Date", EmpAct."Start Date", EmpAct."End Date");
                        if EmpAttendActivity.Find('-') then
                            repeat
                                EmpAttendActivity."Absent Day" := 0;
                                EmpAttendActivity."Present Day" := 1;
                                EmpAttendActivity."Leave Day" := 0;
                                if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then
                                    EmpAttendActivity."Week Off Day" := 1
                                else
                                    EmpAttendActivity."Week Off Day" := 0;
                                EmpAttendActivity."Tour Day" := 0;
                                EmpAttendActivity."Source No." := EmpAct."No.";
                                EmpAttendActivity."Employee Activity Found" := true;
                                EmpAttendActivity."Created Datetime" := CurrentDateTime;
                                EmpAttendActivity.Modify;
                            until EmpAttendActivity.Next = 0;
                        AttendanceSetup.Get;
                        Employee.Get(EmpAct."Employee No.");
                        Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                        if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                            if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                                Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                            else
                                Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                        end else
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                        Employee.Modify;
                    end;
                    Message('Document has been approved.');
                end else begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Rejected;
                    Message('Document has been rejected.');
                end;
            end;
        end;
        EmpAct.Modify;
    end;

    procedure ApproveRejectCancelAttendanceMissedAPI(EmpAct: Record "Employee Activity"; IsApproved: Boolean; employeeNo: Code[20])
    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        if EmpAct."Approval Status" = EmpAct."Approval Status"::Pending then begin
            if StrPos(EmpAct."Recommender Code", employeeNo) = 0 then
                Error('You are not eligible')
            else begin
                if IsApproved then begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Recommended;
                    Message('Document has been recommeded');
                end else begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Rejected;
                    Message('Document has been rejected.');
                end;
            end;
        end else if EmpAct."Approval Status" = EmpAct."Approval Status"::Recommended then begin
            if StrPos(EmpAct."Approver Code", employeeNo) = 0 then
                Error('You are not eligible')
            else begin
                if IsApproved then begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Approved;

                    if EmpAct.Type = EmpAct.Type::"Attendance Missed" then begin
                        EmpAttendActivity.Reset;
                        EmpAttendActivity.SetRange("Employee No.", EmpAct."Employee No.");
                        EmpAttendActivity.SetRange("Attendance Date", EmpAct."Start Date", EmpAct."End Date");
                        if EmpAttendActivity.Find('-') then
                            repeat
                                EmpAttendActivity."Absent Day" := 0;
                                EmpAttendActivity."Present Day" := 1;
                                EmpAttendActivity."Leave Day" := 0;
                                if EmpAttendActivity."Day Type" = EmpAttendActivity."Day Type"::Holiday then
                                    EmpAttendActivity."Week Off Day" := 1
                                else
                                    EmpAttendActivity."Week Off Day" := 0;
                                EmpAttendActivity."Tour Day" := 0;
                                EmpAttendActivity."Source No." := EmpAct."No.";
                                EmpAttendActivity."Employee Activity Found" := true;
                                EmpAttendActivity."Created Datetime" := CurrentDateTime;
                                EmpAttendActivity.Modify;
                            until EmpAttendActivity.Next = 0;
                        AttendanceSetup.Get;
                        Employee.Get(EmpAct."Employee No.");
                        Employee.Validate("Attendance Missed On", CheckLeaveCount(Employee."No."));
                        if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                            if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                                Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                            else
                                Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                        end else
                            Employee.Validate("Attendance Missed Count", ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
                        Employee.Modify;
                    end;
                    Message('Document has been approved.');
                end else begin
                    EmpAct."Approval Status" := EmpAct."Approval Status"::Rejected;
                    Message('Document has been rejected.');
                end;
            end;
        end;
        EmpAct.Modify;
    end;


    // procedure OpenAttendanceMissed(EmpCode: Code[20])
    // var
    //     //TempEmpActivity: Record "Employee Activity" temporary;
    //     //CancelDocument: Record "Cancel Document" temporary;
    //     AttendanceMissed: Record "Attendance Missed" temporary;
    //     ApprovalEntry: Record "Approval HRMS";
    // begin
    //     if not Confirm('Do you want to apply for attendance missed?', false) then
    //         exit;
    //     ApprovalEntry.Reset();
    //     ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Attendance Missed");
    //     ApprovalEntry.SetRange("Employee No", EmpCode);
    //     ApprovalEntry.SetRange("Document No.", '');
    //     ApprovalEntry.DeleteAll();
    //     Employee.Get(EmpCode);
    //     AttendanceMissed.Init;
    //     AttendanceMissed.Validate("Employee No.", EmpCode);
    //     AttendanceMissed.Validate("Employee Name", Employee."Full Name");
    //     AttendanceMissed.Validate("Approval Status", AttendanceMissed."Approval Status"::Open);
    //     AttendanceMissed.Validate(Type, AttendanceMissed.Type::"Attendance Missed");
    //     AttendanceMissed.Validate("Requested Date", Today);
    //     // CancelDocument.Validate("Recommender Code", Employee."KPI Deputation Value");
    //     // CancelDocument.Validate("Approver Code", Employee."Approver Code");
    //     AttendanceMissed.Insert;
    //     PAGE.Run(PAGE::"Attendance Missed", AttendanceMissed);
    // end;

    local procedure CheckForLeaveOnAttendanceMissed(StartDate: Date; EndDate: Date; EmpCode: Code[20])
    var
        EmployeeAttendance: Record "Employee Attendance & Activity";
    begin
        if (StartDate > Today) or (EndDate > Today) then
            Error('Start date or end date cannot be greater than today');
        Employee.Get(EmpCode);
        EmployeeAttendance.Reset;
        EmployeeAttendance.SetRange("Employee No.", EmpCode);
        EmployeeAttendance.SetRange("Attendance Date", StartDate, EndDate);
        EmployeeAttendance.FilterGroup(-1);
        EmployeeAttendance.SetRange("Present Day", 1);
        EmployeeAttendance.SetRange("Leave Day", 1);
        EmployeeAttendance.FilterGroup(0);
        if EmployeeAttendance.FindFirst then
            Error('You were present or on a leave on date %1.', EmployeeAttendance."Attendance Date");
    end;

    local procedure "-----AttendanceQuestionSync----"()
    begin
    end;

    procedure SyncAttendanceQuestion()
    var
        DailyAttendanceQuestion: Record "Daily Attendance Question";
    begin
        // ConnectSQL();
        DailyAttendanceQuestion.Reset;
        //DailyAttendanceQuestion.SetRange("Sync to Portal", true);
        if DailyAttendanceQuestion.FindFirst then
            repeat
                DailyAttendanceQuestion.TestField(Question);
                DailyAttendanceQuestion.TestField(Option1);
                DailyAttendanceQuestion.TestField(Option2);
                DailyAttendanceQuestion.TestField(Option3);
                DailyAttendanceQuestion.TestField(Option4);
                DailyAttendanceQuestion.TestField("Correct Option");
                DailyAttendanceQuestion.TestField("Question Date");

                ReadAttendanceQuestionFromHRportal(DailyAttendanceQuestion."Question Date", DailyAttendanceQuestion."Is Punch In Question");
                // if SQLDataReader.HasRows then begin
                //     DisconnectSQL;
                //     UpdateAttendanceQuestion(DailyAttendanceQuestion);
                // end else begin
                //     DisconnectSQL;
                //     InsertAttendanceQuestion(DailyAttendanceQuestion);
                // end;

                DailyAttendanceQuestion."Sync to Portal" := false;
                DailyAttendanceQuestion.Modify;
            until DailyAttendanceQuestion.Next = 0;

        // DisconnectSQL;
    end;

    local procedure UpdateAttendanceQuestion(var DailyAttendanceQuestion: Record "Daily Attendance Question")
    begin
        Clear(commandtext);

        // ConnectSQL();
        if DailyAttendanceQuestion."Is Punch In Question" then
            IsPunchQuestion := '1'
        else
            IsPunchQuestion := '0';
        commandtext := UpdateTxt + 'Attendancequestions' + SpaceTxt + SetTxt +
                       'Question = @Question,' +
                       'Option1 = @Option1,' +
                       'Option2 = @Option2,' +
                       'Option3 = @Option3,' +
                       'Option4 = @Option4,' +
                       'Correct_Answer = @Correct_Answer,' +
                       'Date = @Date,' +
                       'IsPunchInQuestion = @IsPunchInQuestion' +
                       SpaceTxt + WhereTxt + 'Date ' + ' = ''' + Format(DailyAttendanceQuestion."Question Date") + '''' + SpaceTxt + AndText +
                       SpaceTxt + 'IsPunchInQuestion' + '=''' + IsPunchQuestion + ''''
                       ;

        // SetupSQLCommand;

        // SQLCommand.Parameters.AddWithValue('@Question', Format(DailyAttendanceQuestion.Question));
        // SQLCommand.Parameters.AddWithValue('@Option1', DailyAttendanceQuestion.Option1);
        // SQLCommand.Parameters.AddWithValue('@Option2', DailyAttendanceQuestion.Option2);
        // SQLCommand.Parameters.AddWithValue('@Option3', DailyAttendanceQuestion.Option3);
        // SQLCommand.Parameters.AddWithValue('@Option4', DailyAttendanceQuestion.Option4);
        // SQLCommand.Parameters.AddWithValue('@Correct_Answer', Format(DailyAttendanceQuestion."Correct Option"));
        // SQLCommand.Parameters.AddWithValue('@Date', Format(DailyAttendanceQuestion."Question Date"));
        // SQLCommand.Parameters.AddWithValue('@IsPunchInQuestion', DailyAttendanceQuestion."Is Punch In Question");
        // SQLCommand.ExecuteNonQuery;
    end;

    local procedure InsertAttendanceQuestion(var DailyAttendanceQuestion: Record "Daily Attendance Question")
    begin
        Clear(commandtext);

        // ConnectSQL();

        commandtext :=
          InsertTxt + 'AttendanceQuestions' + SpaceTxt + '(Question,Option1,Option2, ' +
            'Option3,Option4,Correct_Answer,Date,IsPunchInQuestion) ' +
            ValuesTxt +
            '(@Question,@Option1,@Option2, ' +
            '@Option3,@Option4,@Correct_Answer,@Date,@IsPunchInQuestion)';

        // SetupSQLCommand;
        // SQLCommand.Parameters.AddWithValue('@Entry_No', FORMAT(DailyAttendanceQuestion."Entry No."));
        // SQLCommand.Parameters.AddWithValue('@Question', Format(DailyAttendanceQuestion.Question));
        // SQLCommand.Parameters.AddWithValue('@Option1', DailyAttendanceQuestion.Option1);
        // SQLCommand.Parameters.AddWithValue('@Option2', DailyAttendanceQuestion.Option2);
        // SQLCommand.Parameters.AddWithValue('@Option3', DailyAttendanceQuestion.Option3);
        // SQLCommand.Parameters.AddWithValue('@Option4', DailyAttendanceQuestion.Option4);
        // SQLCommand.Parameters.AddWithValue('@Correct_Answer', Format(DailyAttendanceQuestion."Correct Option"));
        // SQLCommand.Parameters.AddWithValue('@Date', Format(DailyAttendanceQuestion."Question Date"));
        // SQLCommand.Parameters.AddWithValue('@IsPunchInQuestion', DailyAttendanceQuestion."Is Punch In Question");
        // SQLCommand.ExecuteNonQuery;
    end;

    // local procedure ConnectSQL()
    // begin
    //     SQLConnectionMgt.SetupSQLConnection(SQLConnection);
    // end;

    // local procedure DisconnectSQL()
    // begin
    //     SQLConnectionMgt.CloseSQLConnection(SQLConnection);
    // end;

    // local procedure ClearSQLCommand()
    // begin
    //     Clear(commandtext);
    // end;

    // local procedure SetupSQLCommand()
    // begin
    //     SQLConnectionMgt.SetupSQLCommand(SQLConnection, SQLCommand, commandtext, SQLCommandType::Text);
    // end;

    local procedure ReadAttendanceQuestionFromHRportal(QuestionDate: Date; IsPuchInQuest: Boolean)
    begin
        // ClearSQLCommand;
        if IsPuchInQuest then
            IsPunchQuestion := '1'
        else
            IsPunchQuestion := '0';
        commandtext := ReadCommandTxt + 'AttendanceQuestions' + SpaceTxt + WhereTxt + 'Date' + ' = ''' + Format(QuestionDate) + '''' +
                        SpaceTxt + AndText + SpaceTxt + 'IsPunchInQuestion' + '=''' + IsPunchQuestion + '''';

        // SetupSQLCommand;
        // SQLDataReader := SQLCommand.ExecuteReader;
        // SQLDataReader.Read;
    end;

    procedure SyncEmployee()
    begin
        DeletePortalEmployee();
        Employee.Reset;
        Employee.SetRange(Status, Employee.Status::Active);
        if Employee.Find('-') then
            repeat
                // DisconnectSQL();
                InsertPortalEmployee();
            until Employee.Next = 0;
    end;

    local procedure InsertPortalEmployee()
    begin
        Clear(commandtext);

        // ConnectSQL();

        commandtext :=
          InsertTxt + 'Employees' + SpaceTxt + '(EmployeeID,EmployeeName,EmployeeBOD) ' +
            ValuesTxt +
            '(@EmployeeID,@EmployeeName,@EmployeeBOD)';

        // SetupSQLCommand;
        // SQLCommand.Parameters.AddWithValue('@EmployeeID', Employee."No.");
        // SQLCommand.Parameters.AddWithValue('@EmployeeName', Employee."Full Name");
        // SQLCommand.Parameters.AddWithValue('@EmployeeBOD', Format(Employee."Birth Date")); //Min --Birth Date add
        // SQLCommand.ExecuteNonQuery;
    end;

    local procedure DeletePortalEmployee()
    begin
        Clear(commandtext);
        // ConnectSQL();

        commandtext := DeleteCommandTxt + 'Employees';
        // SetupSQLCommand;
        // SQLCommand.ExecuteNonQuery;
    end;

    // procedure SyncUpdateEmployeeAttendance();
    // var
    //     AttenSetup: Record "Attendance Setup";
    // begin
    //     AttenSetup.Get();
    //     //CompInfo.Get;
    //     SQLConnectionMgt.SetupSQLConnection(SQLConnection);

    //     if FromDate = 0D then
    //         FromDate := CalcDate(AttenSetup."Sync Attendance From", Today);
    //     if (ToDate = 0D) and (DeviceID = 0) then
    //         ReadRecords(StrSubstNo('%1 where %2 >= ''%3''', '[AttendanceLogs]', 'InputDate', FromDate))
    //     else
    //         if (ToDate <> 0D) and (DeviceID = 0) then
    //             ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4''', '[AttendanceLogs]', 'InputDate', FromDate, ToDate))
    //         else
    //             if (ToDate = 0D) and (DeviceID <> 0) then
    //                 ReadRecords(StrSubstNo('%1 where %2 >= ''%3'' and %4 = ''%5''', '[AttendanceLogs]', 'InputDate', FromDate, 'DeviceID', DeviceID))
    //             else
    //                 if (ToDate <> 0D) and (DeviceID <> 0) then
    //                     ReadRecords(StrSubstNo('%1 where %2 between ''%3'' and ''%4'' and %5 = ''%6''', '[AttendanceLogs]', 'InputDate', FromDate, ToDate, 'DeviceID', DeviceID));

    //     InsertUpdateEmpAttendance;
    //     CloseSQLConnection(SQLConnection);
    // end;

    // local procedure InsertUpdateEmpAttendance();
    // var
    //     AttendanceLog: Record "Attendance Log";
    //     AttendanceLog1: Record "Attendance Log";
    //     MachineId: Integer;
    //     MachineIdCode: Text;
    // begin
    //     while SQLDataReader.Read do begin
    //         MachineIdCode := SQLDataReader.GetValue(2);
    //         MachineId := 0;
    //         Evaluate(MachineId, MachineIdCode);
    //         if not AttendanceLog1.Get(MachineId, DT2Date(SQLDataReader.GetValue(3)), DT2Time(SQLDataReader.GetValue(3))) then
    //             if MachineId <> 0 then begin
    //                 Clear(AttendanceLog);
    //                 AttendanceLog.Init;
    //                 AttendanceLog.Validate("Machine Emp. Code", format(MachineId));
    //                 AttendanceLog.Validate("Attendance Date", DT2DATE(SQLDataReader.GetValue(3)));
    //                 AttendanceLog.Validate("Attendance Time", DT2TIME(SQLDataReader.GetValue(3)));
    //                 AttendanceLog.Validate("Device ID", SQLDataReader.GetValue(1));
    //                 AttendanceLog."Biometrics Attendance" := true;
    //                 if AttendanceLog.Insert then;
    //             end

    //             else
    //                 if AttendanceLog1.Get(MachineId, DT2Date(SQLDataReader.GetValue(3)), DT2Time(SQLDataReader.GetValue(3))) then begin

    //                     AttendanceLog1.Validate("Device ID", SQLDataReader.GetValue(1));
    //                     AttendanceLog1.Modify();
    //                 end;
    //     end;
    //     Commit;
    // end;

    // local procedure "-----Access Control----"()
    // begin
    // end;

    // procedure OpenGrantAccessControl(EmpCode: Code[20])
    // var
    //     EmpActivity: Record "Employee Activity";
    // begin
    //     Employee.Get(EmpCode);
    //     EmpActivity.Init;
    //     EmpActivity.Validate(Type, EmpActivity.Type::"Access Control");
    //     EmpActivity.Validate("Approval Status", EmpActivity."Approval Status"::Open);
    //     EmpActivity."Requested Date" := Today;
    //     EmpActivity.Validate("Employee No.", EmpCode);
    //     EmpActivity."User ID" := UserId;
    //     EmpActivity.Validate("Recommender Code", Employee."KPI Deputation Value");
    //     EmpActivity.Insert(true);
    //     PAGE.Run(PAGE::"Access Control Employee", EmpActivity);
    // end;

    // procedure GenerateAccessControl(EmpActivity: Record "Employee Activity")
    // var
    //     AccessControlDetails: Record "Access Control Details";
    //     AccessControlLine: Record "Access Control Request Line";
    //     LineNo: Integer;
    // begin
    //     EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Open);
    //     Employee.Get(EmpActivity."Employee No.");
    //     AccessControlLine.Reset;
    //     AccessControlLine.SetRange("Document No.", EmpActivity."No.");
    //     AccessControlLine.DeleteAll;
    //     Clear(AccessControlLine);
    //     AccessControlDetails.Reset;
    //     AccessControlDetails.SetRange(Type, AccessControlDetails.Type::"Funtional Title");
    //     AccessControlDetails.SetRange(Code, Employee."Functional Title");
    //     LineNo := 0;
    //     if AccessControlDetails.Find('-') then
    //         repeat
    //             LineNo += 10000;
    //             AccessControlLine.Init;
    //             AccessControlLine.Validate("Document No.", EmpActivity."No.");
    //             AccessControlLine.Validate("Line No.", LineNo);
    //             AccessControlLine.Validate("Employee No.", EmpActivity."Employee No.");
    //             AccessControlLine.Validate("Employee Name", EmpActivity."Employee Name");
    //             AccessControlLine.Validate(Status, AccessControlLine.Status::open);
    //             AccessControlLine.Validate("System Type", AccessControlDetails."System Type Code");
    //             AccessControlLine.Insert;
    //         until AccessControlDetails.Next = 0;
    // end;

    // procedure SendAccessControlApproval(EmpActivity: Record "Employee Activity")
    // var
    //     AccessControlLine: Record "Access Control Request Line";
    // begin
    //     EmpActivity.TestField("Request Case");
    //     EmpActivity.TestField("Recommender Code");

    //     AccessControlLine.Reset;
    //     AccessControlLine.SetRange("Document No.", EmpActivity."No.");
    //     AccessControlLine.SetRange("Access Type", AccessControlLine."Access Type"::" ");
    //     if AccessControlLine.FindFirst then
    //         Error('Access type cannot be blank');


    //     EmpActivity."Approval Status" := EmpActivity."Approval Status"::Pending;
    //     EmpActivity.Modify;

    //     Message('Document has been sent for approval');
    // end;

    // procedure RecommendAccessControl(EmpActivity: Record "Employee Activity")
    // begin
    //     EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Pending);
    //     if EmpActivity."Recommender Code" <> GetEmployeeNo then
    //         Error('You are not eligible to recommend this document');

    //     EmpActivity.Validate("Approval Status", EmpActivity."Approval Status"::Recommended);
    //     EmpActivity.Modify;
    //     Message('Doucment has been recommended.');
    // end;

    // procedure RejectAccessControl(EmpActivity: Record "Employee Activity")
    // var
    //     AccessControlLine: Record "Access Control Request Line";
    // begin
    //     Employee.Get(GetEmployeeNo);
    //     if EmpActivity."Approval Status" = EmpActivity."Approval Status"::Pending then
    //         if EmpActivity."Recommender Code" <> Employee."No." then
    //             Error('You are not eligible to reject this document');
    //     EmpActivity.TestField("Rejection Remarks");
    //     if EmpActivity."Approval Status" = EmpActivity."Approval Status"::Recommended then
    //         if not Employee.Screener then
    //             Error('You are not eligible to reject this document.');

    //     EmpActivity.Validate("Approval Status", EmpActivity."Approval Status"::Rejected);
    //     EmpActivity.Modify;
    //     Clear(AccessControlLine);
    //     AccessControlLine.SetRange("Document No.", EmpActivity."No.");
    //     AccessControlLine.ModifyAll(Status, AccessControlLine.Status::Pending);
    // end;

    // procedure ScreenAccessControl(EmpActivity: Record "Employee Activity")
    // var
    //     AccessControlLine: Record "Access Control Request Line";
    //     EmailTemplate: Record "Email Template";
    // begin
    //     EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Recommended);
    //     Employee.Get(GetEmployeeNo);
    //     if not Employee.Screener then
    //         Error('You are not eligible to recommend this document');

    //     Clear(AccessControlLine);
    //     AccessControlLine.SetRange("Document No.", EmpActivity."No.");
    //     AccessControlLine.ModifyAll(Status, AccessControlLine.Status::Pending);

    //     EmpActivity.Validate("Approval Status", EmpActivity."Approval Status"::Screened);
    //     EmpActivity.Modify;

    //     SendMailFromTemplate(DATABASE::"Employee Activity", EmailTemplate."Document Type"::"Access Control", EmailTemplate.Type::" ", '', '', EmpActivity."No.", 0);
    //     Message('Doucment has been screened.');
    // end;

    // procedure ApproveRejectScreenAccessControl(AccessControlLine: Record "Access Control Request Line"; IsApproved: Boolean)
    // var
    //     AccessControlDetails: Record "Access Control Details";
    //     EmpActivity: Record "Employee Activity";
    //     AccessControlLine2: Record "Access Control Request Line";
    //     SystemAccess: Record "System Access Control";
    //     LineNo: Integer;
    // begin
    //     Employee.Get(GetEmployeeNo);
    //     SystemAccess.Reset;
    //     SystemAccess.SetRange("Type of Masters", SystemAccess."Type of Masters"::"System Control Setup");
    //     SystemAccess.SetRange(Code, AccessControlLine."System Type");
    //     SystemAccess.SetRange("System Department Owner", Employee."Department Code");
    //     if (not SystemAccess.FindFirst) or (not Employee."System Owner") then
    //         Error('You are not eligible to approve or reject ');
    //     EmpActivity.Get(AccessControlLine."Document No.");
    //     EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Screened);
    //     if IsApproved then begin
    //         AccessControlLine.Status := AccessControlLine.Status::approved;
    //         if AccessControlLine."Access Type" = AccessControlLine."Access Type"::Grant then begin
    //             AccessControlDetails.Reset;
    //             AccessControlDetails.SetRange(Type, AccessControlDetails.Type::Employee);
    //             AccessControlDetails.SetRange(Code, AccessControlLine."Employee No.");
    //             if AccessControlDetails.FindLast then
    //                 LineNo := AccessControlDetails."Line No." + 10000;

    //             AccessControlDetails.Reset;
    //             AccessControlDetails.Init;
    //             AccessControlDetails.Validate(Type, AccessControlDetails.Type::Employee);
    //             AccessControlDetails.Validate(Code, AccessControlLine."Employee No.");
    //             AccessControlDetails.Validate(Description, AccessControlLine."Employee Name");
    //             AccessControlDetails.Validate("System Type Code", SystemAccess.Code);
    //             AccessControlDetails.Validate("System Type Name", SystemAccess.Name);
    //             AccessControlDetails.Validate("System Category Code", SystemAccess."System Category Code");
    //             AccessControlDetails.Validate("System Category Name", SystemAccess."System Category Name");
    //             AccessControlDetails.Validate("Line No.", LineNo);
    //             AccessControlDetails.Validate("Granted Date", Today);
    //             AccessControlDetails.Insert;
    //         end else if AccessControlLine."Access Type" = AccessControlLine."Access Type"::Remove then begin
    //             AccessControlDetails.Reset;
    //             AccessControlDetails.SetRange(Type, AccessControlDetails.Type::Employee);
    //             AccessControlDetails.SetRange(Code, AccessControlLine."Employee No.");
    //             AccessControlDetails.SetRange("System Type Code", AccessControlLine."System Type");
    //             if AccessControlDetails.FindFirst then
    //                 AccessControlDetails.Delete;
    //         end;
    //     end else
    //         AccessControlLine.Status := AccessControlLine.Status::rejected;

    //     AccessControlLine."Approved By" := GetEmployeeNo;
    //     AccessControlLine."Approved Date" := Today;
    //     AccessControlLine.Modify;
    //     AccessControlLine2.Reset;
    //     AccessControlLine2.SetRange("Document No.", AccessControlLine."Document No.");
    //     AccessControlLine2.SetFilter("Line No.", '<>%1', AccessControlLine."Line No.");
    //     AccessControlLine2.SetRange(Status, AccessControlLine2.Status::Pending);
    //     if not AccessControlLine2.FindFirst then begin
    //         EmpActivity."Approval Status" := EmpActivity."Approval Status"::Approved;
    //         EmpActivity.Modify;
    //     end;
    // end;

    // procedure AccessControlEmployeeSelection(EmpActivity: Record "Employee Activity")
    // var
    //     AccessControlLine: Record "Access Control Request Line";
    //     PageSelectionAccessControl: Page "Access Control Selection";
    // begin
    //     EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Open);
    //     AccessControlLine.Reset;
    //     AccessControlLine.SetRange("Document No.", EmpActivity."No.");
    //     AccessControlLine.DeleteAll;
    //     Commit;
    //     Clear(PageSelectionAccessControl);
    //     PageSelectionAccessControl.SetDocNo(EmpActivity."No.");
    //     PageSelectionAccessControl.RunModal;
    // end;

    // procedure GetAddressAccessControl(EmpActivity: Record "Employee Activity") EmailAddress: Text
    // var
    //     AccessControlLine: Record "Access Control Request Line";
    //     TempEmployee: Record Employee temporary;
    //     SystemAccess: Record "System Access Control";
    // begin
    //     TempEmployee.Reset;
    //     TempEmployee.DeleteAll;
    //     Clear(EmailAddress);
    //     AccessControlLine.Reset;
    //     AccessControlLine.SetRange("Document No.", EmpActivity."No.");
    //     if AccessControlLine.Find('-') then
    //         repeat
    //             SystemAccess.Reset;
    //             SystemAccess.SetRange("Type of Masters", SystemAccess."Type of Masters"::"System Control Setup");
    //             SystemAccess.SetRange(Code, AccessControlLine."System Type");
    //             if SystemAccess.FindFirst then;
    //             Employee.Reset;
    //             Employee.SetRange("System Owner", true);
    //             Employee.SetRange("Department Code", SystemAccess."System Department Owner");
    //             if Employee.Find('-') then
    //                 repeat
    //                     TempEmployee.Reset;
    //                     if not TempEmployee.Get(Employee."No.") then begin
    //                         TempEmployee.Init;
    //                         TempEmployee.Validate("No.", Employee."No.");
    //                         TempEmployee.Insert(true);
    //                         if EmailAddress = '' then
    //                             EmailAddress := Employee."Company E-Mail"
    //                         else
    //                             EmailAddress += ';' + Employee."Company E-Mail";
    //                     end;
    //                 until Employee.Next = 0;
    //         until AccessControlLine.Next = 0;
    // end;

    // local procedure GetAccessControlBody(EmpActivity: Record "Employee Activity")
    // var
    //     BodyText1: Text;
    //     AccessControlLine: Record "Access Control Request Line";
    // begin
    //     BodyText1 := '<table style="width:100%">' +
    //            '<tr>' +
    //              '<td><strong>' + AccessControlLine.FieldCaption("Employee No.") + '</strong></td>' +
    //              '<td><strong>' + AccessControlLine.FieldCaption("Employee Name") + '</strong></td>' +
    //              '<td><strong>' + AccessControlLine.FieldCaption("System Type Name") + '</strong></td>' +
    //              '<td><strong>' + AccessControlLine.FieldCaption("System Category Name") + '</strong></td>' +
    //              '<td><strong>' + AccessControlLine.FieldCaption("Access Type") + '</strong></td>' +
    //            '</tr>';

    //     AccessControlLine.Reset;
    //     AccessControlLine.SetRange("Document No.", EmpActivity."No.");
    //     if AccessControlLine.Find('-') then
    //         repeat
    //             BodyText1 += '<tr>' +
    //                             '<td>' + AccessControlLine."Employee No." + '</td>' +
    //                             '<td>' + AccessControlLine."Employee Name" + '</td>' +
    //                             '<td>' + AccessControlLine."System Type Name" + '</td>' +
    //                             '<td>' + AccessControlLine."System Category Name" + '</td>' +
    //                             '<td>' + Format(AccessControlLine."Access Type") + '</td>' +
    //                           '</tr>';
    //         until AccessControlLine.Next = 0;
    //     BodyText1 += '</table>';
    //     CodeunitEmailMessage.AppendToBody(EmpActivity.FieldCaption("Request Case") + Colon + Format(EmpActivity."Request Case") + '<br>');
    //     CodeunitEmailMessage.AppendToBody(EmpActivity.FieldCaption("Requested Date") + Colon + Format(EmpActivity."Requested Date") + '<br>');
    //     CodeunitEmailMessage.AppendToBody('<br>' + BodyText1 + '<br>');
    // end;

    // procedure OpenGrantAccessControlFromTransfer(EmpActNo: Code[20])
    // var
    //     EmpActivity: Record "Employee Activity";
    //     TransferEmpActivity: Record "Employee Activity";
    //     AccessControlDetail: Record "Access Control Details";
    //     AccessControlLine: Record "Access Control Request Line";
    //     LineNo: Integer;
    // begin
    //     TransferEmpActivity.Get(EmpActNo);
    //     TransferEmpActivity.TestField(Type, TransferEmpActivity.Type::"Employee Transfer");
    //     EmpActivity.Reset;
    //     EmpActivity.SetRange("Travel Order No.", EmpActNo);
    //     if not EmpActivity.FindFirst then begin
    //         Employee.Get(TransferEmpActivity."Employee No.");
    //         EmpActivity.Init;
    //         EmpActivity.Validate(Type, EmpActivity.Type::"Access Control");
    //         EmpActivity.Validate("Approval Status", EmpActivity."Approval Status"::Open);
    //         EmpActivity."Requested Date" := Today;
    //         EmpActivity.Validate("Request Case", EmpActivity."Request Case"::Transfer);
    //         EmpActivity.Validate("Employee No.", TransferEmpActivity."Employee No.");
    //         EmpActivity."Travel Order No." := TransferEmpActivity."No.";    //transfer no. tracking
    //         EmpActivity."User ID" := UserId;
    //         EmpActivity.Validate("Recommender Code", Employee."KPI Deputation Value");
    //         EmpActivity.Insert(true);
    //         LineNo := 0;

    //         AccessControlDetail.Reset;
    //         AccessControlDetail.SetRange(Type, AccessControlDetail.Type::Employee);
    //         AccessControlDetail.SetRange(Code, Employee."No.");
    //         if AccessControlDetail.FindFirst then
    //             repeat
    //                 LineNo += 10000;
    //                 AccessControlLine.Init;
    //                 AccessControlLine.Validate("Document No.", EmpActivity."No.");
    //                 AccessControlLine.Validate("Line No.", LineNo);
    //                 AccessControlLine.Validate("Employee No.", EmpActivity."Employee No.");
    //                 AccessControlLine.Validate("Employee Name", EmpActivity."Employee Name");
    //                 AccessControlLine.Validate(Status, AccessControlLine.Status::open);
    //                 AccessControlLine.Validate("System Type", AccessControlDetail."System Type Code");
    //                 AccessControlLine.Validate("Access Type", AccessControlLine."Access Type"::Remove);
    //                 AccessControlLine.Insert;
    //             until AccessControlDetail.Next = 0;

    //         AccessControlDetail.Reset;
    //         AccessControlDetail.SetRange(Type, AccessControlDetail.Type::"Funtional Title");
    //         AccessControlDetail.SetRange(Code, TransferEmpActivity."Functional Title (To)");
    //         if AccessControlDetail.FindFirst then
    //             repeat
    //                 LineNo += 10000;
    //                 AccessControlLine.Init;
    //                 AccessControlLine.Validate("Document No.", EmpActivity."No.");
    //                 AccessControlLine.Validate("Line No.", LineNo);
    //                 AccessControlLine.Validate("Employee No.", EmpActivity."Employee No.");
    //                 AccessControlLine.Validate("Employee Name", EmpActivity."Employee Name");
    //                 AccessControlLine.Validate(Status, AccessControlLine.Status::open);
    //                 AccessControlLine.Validate("System Type", AccessControlDetail."System Type Code");
    //                 AccessControlLine.Validate("Access Type", AccessControlLine."Access Type"::Grant);
    //                 AccessControlLine.Insert;
    //             until AccessControlDetail.Next = 0;
    //     end;
    //     PAGE.Run(PAGE::"Access Control Employee", EmpActivity);
    // end;

    procedure sendChangeforEmpforApproval(TempEmpActivity: Record "Employee Activity" temporary)
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Init;
        EmpActivity.TransferFields(TempEmpActivity);
        EmpActivity."Approval Status" := EmpActivity."Approval Status"::Pending;
        EmpActivity.Insert(true);
    end;

    procedure ApproveRejctChangeforEmp(EmpActivity: Record "Employee Activity"; IsApproved: Boolean)
    begin
        Employee.Get(GetEmployeeNo);
        EmpActivity.TestField("Approval Status", EmpActivity."Approval Status"::Pending);

        // if not Employee.Screener then
        //     Error('You are not eligible to approve');
        if IsApproved then begin
            EmpActivity."Approval Status" := EmpActivity."Approval Status"::Approved;
            Employee."Address 2" := EmpActivity."Temporary Address";
            Employee."Mobile Phone No." := EmpActivity."Mobile No.";
            Employee."Marital Status" := EmpActivity."Marital Status";
            Employee."E-Mail" := EmpActivity."Email (Personal)";
            Employee."Passport Number" := EmpActivity."Passport No.";
            Employee.Disabled := EmpActivity."Differently Able";
            Employee."Vehicle Type" := EmpActivity."Vehicle Type";
            Employee."Temporary VDC" := EmpActivity.VDC;
            Employee."Temporary District" := EmpActivity."Temporary District";
            Employee."Temporary Province" := EmpActivity."Temporary Province";
            Employee."Temporary House" := EmpActivity.House;
            Employee."Temporary Ward No" := EmpActivity."Temporary Ward No";
            Employee."Blood Group" := EmpActivity."Blood Group";
            Employee.Extension := EmpActivity.Extension;//Min -- For Extension no. editable in portal emp. profile
            Employee.Modify;
        end else
            EmpActivity."Approval Status" := EmpActivity."Approval Status"::Rejected;
        EmpActivity.Modify;
    end;

    procedure CheckLeaveCount(EmployeeNo: Code[20]) CountStartDate: Date
    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        CountStartDate := 0D;
        EmpAttendActivity.Reset;
        EmpAttendActivity.SetRange("Employee No.", EmployeeNo);
        EmpAttendActivity.SetRange("Day Type", EmpAttendActivity."Day Type"::"Working Day");
        EmpAttendActivity.SetRange("Present Day", 0);
        EmpAttendActivity.SetRange("Leave Day", 0);
        EmpAttendActivity.SetCurrentKey("Attendance Date");
        if EmpAttendActivity.FindFirst then
            exit(EmpAttendActivity."Attendance Date")
        else
            exit(Today);
    end;

    procedure ReturnLeaveCount(EmpNo: Code[20]; FromDate: Date): Integer
    var
        EmpAttendActivity: Record "Employee Attendance & Activity";
    begin
        EmpAttendActivity.Reset;
        EmpAttendActivity.SetRange("Employee No.", EmpNo);
        //EmpAttendActivity.SETRANGE("Day Type",EmpAttendActivity."Day Type"::"Working Day");
        EmpAttendActivity.SetRange("Present Day", 1);
        EmpAttendActivity.SetFilter("Attendance Date", '>%1', FromDate);
        exit(EmpAttendActivity.Count);
    end;

    procedure ReturnCalendarDescription(): Text
    begin
        exit(CalendarDescription);
    end;

    local procedure "------Overtime-----"()
    begin
    end;

    // procedure CheckApprovedOvertimeExists(AllowanceAssignmentLine: Record "Allowance Assignment Line")
    // var
    //     EmployeeActivity: Record "Employee Activity";
    // begin
    //     EmployeeActivity.Reset;
    //     EmployeeActivity.SetRange("Employee No.", AllowanceAssignmentLine."Employee Code");
    //     EmployeeActivity.SetRange("Start Date", AllowanceAssignmentLine."From Date");
    //     EmployeeActivity.SetRange("Approval Status", EmployeeActivity."Approval Status"::Approved);
    //     EmployeeActivity.SetFilter("Actual Hours", '<>%1', 0);
    //     if EmployeeActivity.FindFirst then
    //         Error('Approved Overtime exists. You cannot choose this employee.');
    // end;

    // procedure CheckOvertimeEligibility(EmployeeActivity: Record "Employee Activity"; StartTime: Time; EndTime: Time; StandardWorkingHrs: Decimal; var TotalOTHrs: Decimal; var RejectionRemarks: Text): Boolean
    // var
    //     Workshift: Record "Employee Work Shift";
    //     AttendanceLog: Record "Attendance Log";
    //     MorningOTHrs: Decimal;
    //     EveningOTHrs: Decimal;
    //     CheckInDifference: Decimal;
    // begin
    //     HRSetup.Get;
    //     HRSetup.TestField("OT eligible hour");

    //     MorningOTHrs := 0;
    //     EveningOTHrs := 0;
    //     TotalOTHrs := 0;
    //     CheckInDifference := 0;

    //     AttendanceLog.Reset;
    //     AttendanceLog.SetRange("Employee ID", EmployeeActivity."Employee No.");
    //     AttendanceLog.SetRange(Date, EmployeeActivity."Start Date");
    //     if AttendanceLog.FindFirst then begin
    //         if (AttendanceLog."Check In Time" = 0T) or (AttendanceLog."Check Out Time" = 0T) then begin
    //             RejectionRemarks := 'System rejected. No punch in or punch out found.';
    //             exit(false);
    //         end;

    //         if LeaveMgt.GetNonWokingDays(EmployeeActivity."Start Date", EmployeeActivity."End Date", EmployeeActivity."Employee No.") = 0 then begin
    //             if AttendanceLog."Check Out Time" >= EndTime then begin
    //                 if (AttendanceLog."Check Out Time" - AttendanceLog."Check In Time") < StandardWorkingHrs then begin
    //                     RejectionRemarks := StrSubstNo('System rejected. Working hrs is less than %1 hrs.', StandardWorkingHrs);
    //                     exit(false);
    //                 end;

    //                 if (AttendanceLog."Check In Time" <> 0T) and (AttendanceLog."Check In Time" <= StartTime) then
    //                     MorningOTHrs := Round((StartTime - AttendanceLog."Check In Time") / 3600000, 1, '<');

    //                 if MorningOTHrs < HRSetup."OT eligible hour" then
    //                     MorningOTHrs := 0;

    //                 if (AttendanceLog."Check Out Time" <> 0T) and (AttendanceLog."Check Out Time" > EndTime) then
    //                     EveningOTHrs := Round((AttendanceLog."Check Out Time" - EndTime) / 3600000, 1, '<');

    //                 if AttendanceLog."Check In Time" > StartTime then begin
    //                     CheckInDifference := Round((AttendanceLog."Check In Time" - StartTime) / 3600000, 1, '<');
    //                     EveningOTHrs -= CheckInDifference;
    //                 end;

    //                 if EveningOTHrs < HRSetup."OT eligible hour" then
    //                     EveningOTHrs := 0;

    //                 TotalOTHrs := MorningOTHrs + EveningOTHrs;

    //             end else begin
    //                 RejectionRemarks := 'System rejected. Punch out does not exceed standard punch out time.';
    //                 exit(false);
    //             end;
    //         end else begin
    //             TotalOTHrs := (AttendanceLog."Check Out Time" - AttendanceLog."Check In Time") / 3600000;
    //             if TotalOTHrs < HRSetup."OT eligible hour" then
    //                 TotalOTHrs := 0;
    //         end;
    //     end else begin
    //         RejectionRemarks := 'System rejected. Attendance Log not found.';
    //         exit(false);
    //     end;

    //     if TotalOTHrs <> 0 then
    //         exit(true)
    //     else begin
    //         RejectionRemarks := 'System rejected. OT hours does not meet OT eligible hour.';
    //         exit(false);
    //     end;
    // end;

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

    // procedure AddOvertimeAttachment(EmpActNo: Code[20]; EmpNo: Code[20])
    // var
    //     TempIncomingDoc: Record "Incoming Document";
    //     Employee: Record Employee;
    //     SalaryLevel: Record "Salary Level";
    // begin
    //     Employee.Get(EmpNo);
    //     SalaryLevel.Get(Employee."Salary Level");
    //     if not SalaryLevel."OT Attachment Mandatory" then
    //         exit;

    //     TempIncomingDoc.Reset;
    //     TempIncomingDoc.SetRange("Employee Code", EmpNo);
    //     TempIncomingDoc.SetRange("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::Overtime);
    //     TempIncomingDoc.SetRange("No.", '');
    //     if TempIncomingDoc.Find('-') then
    //         repeat
    //             if TempIncomingDoc."File Name" = '' then      //attachment mandatory for leave
    //                 Error('Attachment must be uploaded');
    //             TempIncomingDoc.Validate("No.", EmpActNo);
    //             TempIncomingDoc.Modify;
    //         until TempIncomingDoc.Next = 0;
    // end;

    procedure GetNepaliDate(EnglishDate: Date): Text
    begin
        Clear(EngNep);
        EngNep.SetRange("English Date", EnglishDate);
        if EngNep.FindFirst then
            exit(EngNep."Nepali Date");
    end;

    local procedure "------Service History--------"()
    begin
    end;

    // procedure AddToServiceHistory(DocNo: Code[20]; ServiceEvent: Enum "Service Event"; RemarksVar: Text; EffectiveDate: Date): Code[20]
    // var
    //     EmpServiceHis: Record "Employee Service History";
    //     Candidate: Record Candidate;
    // begin
    //     case ServiceEvent of
    //         ServiceEvent::Appointment:
    //             begin
    //                 Candidate.Get(DocNo);
    //                 EmpServiceHis.Init;
    //                 EmpServiceHis.Validate("Service Event", EmpServiceHis."Service Event"::Appointment);
    //                 EmpServiceHis.Validate("Employee No.", Candidate."Employee No.");
    //                 EmpServiceHis.Validate("Functional Title (To)", Candidate."Functional Title");
    //                 EmpServiceHis.Validate("Salary Level (To)", Candidate."Job Title");
    //                 EmpServiceHis.Validate("Salary Grade (From)", Candidate."Salary Grade");
    //                 EmpServiceHis.Validate("Salary Grade (To)", Candidate."Salary Grade");
    //                 EmpServiceHis.Validate("Effective Date", EffectiveDate);
    //                 EmpServiceHis.Validate(Remarks, RemarksVar);
    //                 EmpServiceHis.Insert(true);
    //             end;
    //         //Min 1.2 -- Added option String "Temporary Deputation","Back From Deputation" and "Officiating Arrangement".
    //         ServiceEvent::Confirmation, ServiceEvent::"Contract Renew", ServiceEvent::"Addition in Job Function",
    //         ServiceEvent::"Assignment in Job Function", ServiceEvent::"Formation of Department/Unit/Functional Title",
    //         ServiceEvent::"Internal Appointment", ServiceEvent::Transfer, ServiceEvent::"Temporary Deputation", ServiceEvent::"Back From Deputation", ServiceEvent::"Officiating Arrangement":
    //             begin
    //                 Employee.Get(DocNo);
    //                 EmpServiceHis.Init;
    //                 EmpServiceHis.Validate("Service Event", ServiceEvent);
    //                 EmpServiceHis.Validate("Employee No.", Employee."No.");
    //                 EmpServiceHis.Validate("Functional Title (From)", Employee."Functional Title");
    //                 EmpServiceHis.Validate("Salary Level (From)", Employee."Salary Level");
    //                 EmpServiceHis.Validate("Effective Date", EffectiveDate);
    //                 EmpServiceHis.Validate("Deputation On(From)", Employee."Deputation on");
    //                 EmpServiceHis.Validate("Deputation Code (From)", ExitTransferDeputationWiseCode(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
    //                 EmpServiceHis.Validate("Deputation Value (From)", ExitTransferDeputationWiseValue(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
    //                 EmpServiceHis.Validate(Remarks, RemarksVar);
    //                 EmpServiceHis.Validate("Salary Grade (From)", Employee."Salary Grade");
    //                 if ServiceEvent <> ServiceEvent::"Internal Appointment" then
    //                     EmpServiceHis.Validate("Salary Grade (To)", Employee."Salary Grade");
    //                 EmpServiceHis.Insert(true);
    //             end;

    //     end;
    //     exit(EmpServiceHis."Service History Code");
    // end;

    // procedure AddToServiceHistoryAppointment(DocNo: Code[20]; ServiceEvent: Enum "Service Event"; RemarksVar: Text; EffectiveDate: Date; VacanyNo: Code[20]; EmployeeNo: Code[20]): Code[20]
    // var
    //     EmpServiceHis: Record "Employee Service History";
    //     Candidate: Record Candidate;
    // begin
    //     case ServiceEvent of
    //         ServiceEvent::Appointment:
    //             begin
    //                 Candidate.Get(DocNo, VacanyNo);
    //                 EmpServiceHis.Init;
    //                 EmpServiceHis.Validate("Service Event", EmpServiceHis."Service Event"::Appointment);
    //                 EmpServiceHis.Validate("Employee No.", EmployeeNo);
    //                 EmpServiceHis.Validate("Functional Title (To)", Candidate."Functional Title");
    //                 EmpServiceHis.Validate("Salary Level (To)", Candidate."Job Title");
    //                 EmpServiceHis.Validate("Salary Grade (From)", Candidate."Salary Grade");
    //                 EmpServiceHis.Validate("Salary Grade (To)", Candidate."Salary Grade");
    //                 EmpServiceHis.Validate("Effective Date", EffectiveDate);
    //                 EmpServiceHis.Validate(Remarks, RemarksVar);
    //                 EmpServiceHis.Insert(true);
    //             end;
    //         //Min 1.2 -- Added option String "Temporary Deputation","Back From Deputation" and "Officiating Arrangement".
    //         ServiceEvent::Confirmation, ServiceEvent::"Contract Renew", ServiceEvent::"Addition in Job Function",
    //         ServiceEvent::"Assignment in Job Function", ServiceEvent::"Formation of Department/Unit/Functional Title",
    //         ServiceEvent::"Internal Appointment", ServiceEvent::Transfer, ServiceEvent::"Temporary Deputation", ServiceEvent::"Back From Deputation", ServiceEvent::"Officiating Arrangement":
    //             begin
    //                 Employee.Get(DocNo);
    //                 EmpServiceHis.Init;
    //                 EmpServiceHis.Validate("Service Event", ServiceEvent);
    //                 EmpServiceHis.Validate("Employee No.", Employee."No.");
    //                 EmpServiceHis.Validate("Functional Title (From)", Employee."Functional Title");
    //                 EmpServiceHis.Validate("Salary Level (From)", Employee."Salary Level");
    //                 EmpServiceHis.Validate("Effective Date", EffectiveDate);
    //                 EmpServiceHis.Validate("Deputation On(From)", Employee."Deputation on");
    //                 EmpServiceHis.Validate("Deputation Code (From)", ExitTransferDeputationWiseCode(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
    //                 EmpServiceHis.Validate("Deputation Value (From)", ExitTransferDeputationWiseValue(EmpServiceHis."Deputation On(From)", EmpServiceHis."Employee No."));
    //                 EmpServiceHis.Validate(Remarks, RemarksVar);
    //                 EmpServiceHis.Validate("Salary Grade (From)", Employee."Salary Grade");
    //                 if ServiceEvent <> ServiceEvent::"Internal Appointment" then
    //                     EmpServiceHis.Validate("Salary Grade (To)", Employee."Salary Grade");
    //                 EmpServiceHis.Insert(true);
    //             end;

    //     end;
    //     exit(EmpServiceHis."Service History Code");
    // end;

    // procedure ExitTransferDeputationWiseValue(DeputationOn: Enum "Deputation Type"; EmpCode: Code[20]): Text
    // var
    //     // DimValue: Record "Dimension Value";
    //     // Depart: Record Department;
    //     // EmpHie: Record "Employee Hierarchy Master";
    //     // SubProvince: Record "Sub Province";
    //     Province: Record Province;
    //     GLSetup: Record "General Ledger Setup";
    //     OrganizationStructureList: Record "Organization Structure List";
    // begin
    //     // Clear(DimValue);
    //     // Clear(Depart);
    //     // Clear(EmpHie);
    //     // Clear(SubProvince);
    //     Clear(Province);
    //     GLSetup.Get;
    //     Employee.Get(EmpCode);
    //     case DeputationOn of
    //         DeputationOn::Branch:
    //             begin
    //                 if OrganizationStructureList.Get(OrganizationStructureList.type::Branch, Employee."Global Dimension 1 Code") then
    //                     exit(OrganizationStructureList.Name);
    //             end;

    //         DeputationOn::Department:
    //             begin
    //                 if OrganizationStructureList.Get(OrganizationStructureList.type::Department, Employee."Department Code") then
    //                     exit(OrganizationStructureList.Name);

    //             end;

    //         DeputationOn::"Extension Counter":
    //             begin
    //                 // EmpHie.Reset;
    //                 // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
    //                 // EmpHie.SetRange(Code, Employee."Extension Counter Code");
    //                 // if EmpHie.FindFirst then
    //                 if OrganizationStructureList.Get(OrganizationStructureList.type::"Extension Counter", Employee."Extension Counter Code") then
    //                     exit(OrganizationStructureList.Name);
    //             end;

    //         // DeputationOn::"Sub Province":
    //         //     begin
    //         //         SubProvince.Reset;
    //         //         SubProvince.SetRange(Code, Employee."Sub Province Code");
    //         //         if SubProvince.FindFirst then
    //         //             exit(SubProvince.City);
    //         //     end;

    //         DeputationOn::Unit:
    //             begin
    //                 // EmpHie.Reset;
    //                 // EmpHie.SetRange(Type, EmpHie.Type::Unit);
    //                 // EmpHie.SetRange(Code, Employee."Unit Code");
    //                 // if EmpHie.FindFirst then
    //                 //     exit(EmpHie.Description);
    //                 if OrganizationStructureList.Get(OrganizationStructureList.type::"Extension Counter", Employee."Union Code") then
    //                     exit(OrganizationStructureList.Name);
    //             end;

    //         DeputationOn::Province:
    //             begin
    //                 if Province.Get(Employee."Province Code") then
    //                     exit(Province.Description);
    //             end;
    //     end;
    // end;

    // procedure ExitTransferDeputationWiseCode(DeputationOn: Enum "Deputation Type"; EmpCode: Code[20]): Text
    // var
    //     // DimValue: Record "Dimension Value";
    //     // Depart: Record Department;
    //     // EmpHie: Record "Employee Hierarchy Master";
    //     // SubProvince: Record "Sub Province";
    //     Province: Record Province;
    //     GLSetup: Record "General Ledger Setup";
    //     OrganizationStructureList: Record "Organization Structure List";
    // begin
    //     // Clear(DimValue);
    //     // Clear(Depart);
    //     // Clear(EmpHie);
    //     // Clear(SubProvince);
    //     Clear(Province);
    //     GLSetup.Get;
    //     Employee.Get(EmpCode);
    //     case DeputationOn of
    //         DeputationOn::Branch:
    //             begin
    //                 if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Employee."Global Dimension 1 Code") then
    //                     exit(OrganizationStructureList.Code);
    //             end;

    //         DeputationOn::Department:
    //             begin
    //                 if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, Employee."Department Code") then
    //                     exit(OrganizationStructureList.Code);

    //             end;

    //         DeputationOn::"Extension Counter":
    //             begin
    //                 // EmpHie.Reset;
    //                 // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
    //                 // EmpHie.SetRange(Code, Employee."Extension Counter Code");
    //                 // if EmpHie.FindFirst then
    //                 //     exit(EmpHie.Code);
    //                 OrganizationStructureList.reset();
    //                 if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Employee."Extension Counter Code") then
    //                     exit(OrganizationStructureList.Code);
    //             end;

    //         // DeputationOn::"Sub Province":
    //         //     begin
    //         //         SubProvince.Reset;
    //         //         SubProvince.SetRange(Code, Employee."Sub Province Code");
    //         //         if SubProvince.FindFirst then
    //         //             exit(SubProvince.Code);
    //         //     end;

    //         DeputationOn::Unit:
    //             begin
    //                 // EmpHie.Reset;
    //                 // EmpHie.SetRange(Type, EmpHie.Type::Unit);
    //                 // EmpHie.SetRange(Code, Employee."Unit Code");
    //                 // if EmpHie.FindFirst then
    //                 //     exit(EmpHie.Code);
    //                 OrganizationStructureList.reset();
    //                 if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, Employee."Unit Code") then
    //                     exit(OrganizationStructureList.Code);
    //             end;

    //         DeputationOn::Province:
    //             begin
    //                 if Province.Get(Employee."Province Code") then
    //                     exit(Province.Code);
    //             end;
    //     end;
    // end;

    // procedure PopUpForJobAssignment(EmpVar: Record Employee)
    // var
    //     JobAssignmentPageBuilder: FilterPageBuilder;
    //     ServiceHistory: Record "Employee Service History";
    //     DateVar: Date;
    //     EmpActivity: Record "Employee Activity";
    //     ServiceCode: Code[20];
    // begin

    //     JobAssignmentPageBuilder.AddRecord('Assignment in Job Function', EmpActivity);
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Deputation On");
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Province Code");
    //     // JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Sub Province Code");
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Shortcut Dimension 1 Code");
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity.Department);
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Extension Counter Code");
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Unit Code");
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Functional Title");
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity."Start Date");
    //     JobAssignmentPageBuilder.ADdField('Assignment in Job Function', EmpActivity.Remarks);

    //     if JobAssignmentPageBuilder.RunModal then begin
    //         EmpActivity.SetView(JobAssignmentPageBuilder.GetView('Assignment in Job Function'));

    //         if EmpActivity.GetFilter("Functional Title") = '' then
    //             Error('Functional Title cannot be blank.');
    //         if EmpActivity.GetFilter("Deputation On") = Format(EmpActivity."Deputation On"::" ") then
    //             Error('Deputation on must have value.');
    //         Evaluate(DateVar, EmpActivity.GetFilter("Start Date"));
    //         if EmpActivity.GetFilter(Remarks) = '' then
    //             Error('Remarks cannot be blank.');

    //         if DateVar = 0D then
    //             Error('Date must have value.');
    //         ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::"Assignment in Job Function", EmpActivity.GetFilter(Remarks), DateVar);

    //         case EmpActivity.GetFilter("Deputation On") of
    //             Format(EmpActivity."Deputation On"::Province):
    //                 begin
    //                     if EmpActivity.GetFilter("Province Code") = '' then
    //                         Error('Province Code must have value.');
    //                     EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Province);
    //                     EmpVar.Validate("Province Code", EmpActivity.GetFilter("Province Code"));
    //                 end;

    //             // Format(EmpActivity."Deputation On"::"Sub Province"):
    //             //     begin
    //             //         if EmpActivity.GetFilter("Sub Province Code") = '' then
    //             //             Error('Sub-province Code must have value.');
    //             //         EmpVar.Validate("Deputation on", EmpVar."Deputation on"::"Sub Province");
    //             //         EmpVar.Validate("Sub Province Code", EmpActivity.GetFilter("Sub Province Code"));
    //             //     end;

    //             Format(EmpActivity."Deputation On"::Branch):
    //                 begin
    //                     if EmpActivity.GetFilter("Shortcut Dimension 1 Code") = '' then
    //                         Error('Branch Code must have value.');
    //                     EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Branch);
    //                     EmpVar.Validate("Global Dimension 1 Code", EmpActivity.GetFilter("Shortcut Dimension 1 Code"));
    //                 end;

    //             Format(EmpActivity."Deputation On"::Department):
    //                 begin
    //                     if EmpActivity.GetFilter(Department) = '' then
    //                         Error('Department Code must have value.');
    //                     EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Department);
    //                     EmpVar.Validate("Department Code", EmpActivity.GetFilter(Department));
    //                 end;

    //             Format(EmpActivity."Deputation On"::Unit):
    //                 begin
    //                     if EmpActivity.GetFilter("Unit Code") = '' then
    //                         Error('Unit Code must have value.');
    //                     EmpVar.Validate("Deputation on", EmpVar."Deputation on"::Unit);
    //                     EmpVar.Validate("Unit Code", EmpActivity.GetFilter("Unit Code"));
    //                 end;

    //             Format(EmpActivity."Deputation On"::"Extension Counter"):
    //                 begin
    //                     if EmpActivity.GetFilter("Province Code") = '' then
    //                         Error('Extension Counter Code must have value.');
    //                     EmpVar.Validate("Deputation on", EmpVar."Deputation on"::"Extension Counter");
    //                     EmpVar.Validate("Extension Counter Code", EmpActivity.GetFilter("Extension Counter Code"));
    //                 end;

    //         end;

    //         EmpVar.Validate("Functional Title", EmpActivity.GetFilter("Functional Title"));
    //         EmpVar.Modify;

    //         if ServiceHistory.Get(ServiceCode) then begin
    //             ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
    //             ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
    //             ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
    //             ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Modify;
    //         end;

    //         Message('Updated');
    //     end;
    // end;

    // procedure PopUpForJobAddition(EmpVar: Record Employee)
    // var
    //     JobAdditionPageBuilder: FilterPageBuilder;
    //     ServiceHistory: Record "Employee Service History";
    //     DateVar: Date;
    //     EmpActivity: Record "Employee Activity";
    //     ServiceCode: Code[20];
    // begin

    //     JobAdditionPageBuilder.AddRecord('Assignment in Job Addition', EmpActivity);
    //     JobAdditionPageBuilder.ADdField('Assignment in Job Addition', EmpActivity."Functional Title");
    //     JobAdditionPageBuilder.ADdField('Assignment in Job Addition', EmpActivity."Start Date");
    //     JobAdditionPageBuilder.ADdField('Assignment in Job Addition', EmpActivity.Remarks);

    //     if JobAdditionPageBuilder.RunModal then begin
    //         EmpActivity.SetView(JobAdditionPageBuilder.GetView('Assignment in Job Addition'));

    //         if EmpActivity.GetFilter("Functional Title") = '' then
    //             Error('Functional Title cannot be blank.');
    //         Evaluate(DateVar, EmpActivity.GetFilter("Start Date"));
    //         if EmpActivity.GetFilter(Remarks) = '' then
    //             Error('Remarks cannot be blank.');

    //         if DateVar = 0D then
    //             Error('Date must have value.');
    //         ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::"Addition in Job Function", EmpActivity.GetFilter(Remarks), DateVar);



    //         EmpVar.Validate("Functional Title", EmpActivity.GetFilter("Functional Title"));
    //         EmpVar.Modify;
    //         if ServiceHistory.Get(ServiceCode) then begin
    //             ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
    //             ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
    //             ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
    //             ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Modify;
    //         end;
    //         Message('Updated');
    //     end;
    // end;

    // procedure PopUpForContractRenew(EmpVar: Record Employee)
    // var
    //     JobAdditionPageBuilder: FilterPageBuilder;
    //     ServiceHistory: Record "Employee Service History";
    //     DateVar: Date;
    //     EmpActivity: Record "Employee Activity";
    //     ServiceCode: Code[20];
    //     ContractRenewDate: Date;
    // begin
    //     EmpVar.TestField("Employment Type", EmpVar."Employment Type"::Contract);
    //     JobAdditionPageBuilder.AddRecord('Assignment in Contract Renews', Employee1);
    //     JobAdditionPageBuilder.ADdField('Assignment in Contract Renews', Employee1."Contract Renew Date");
    //     JobAdditionPageBuilder.ADdField('Assignment in Contract Renews', Employee1."Contract Expiry Month");
    //     JobAdditionPageBuilder.AddRecord('Assignment in Contract Renew', EmpActivity);
    //     JobAdditionPageBuilder.ADdField('Assignment in Contract Renew', EmpActivity.Remarks);

    //     if JobAdditionPageBuilder.RunModal then begin
    //         Employee1.SetView(JobAdditionPageBuilder.GetView('Assignment in Contract Renews'));
    //         EmpActivity.SetView(JobAdditionPageBuilder.GetView('Assignment in Contract Renew'));

    //         Evaluate(ContractRenewDate, Employee1.GetFilter("Contract Renew Date"));
    //         if ContractRenewDate = 0D then
    //             Error('Contract Renew Date must have value.');


    //         if EmpActivity.GetFilter(Remarks) = '' then
    //             Error('Remarks cannot be blank.');

    //         //check for pending leave request
    //         EmpActivity.Reset;
    //         EmpActivity.SetRange("Employee No.", EmpVar."No.");
    //         EmpActivity.SetRange(Type, EmpActivity.Type::"Leave Request");
    //         EmpActivity.SetFilter("Approval Status", '%1|%2|%3', EmpActivity."Approval Status"::Open,
    //                               EmpActivity."Approval Status"::Recommended, EmpActivity."Approval Status"::Pending);
    //         if EmpActivity.FindFirst then
    //             Error('Leave request of employee %1 is still pending', EmpVar."Full Name");

    //         ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::"Contract Renew", EmpActivity.GetFilter(Remarks), ContractRenewDate);

    //         EmpVar.Validate("Contract Renew Date", ContractRenewDate);
    //         Evaluate(EmpVar."Contract Expiry Month", Employee1.GetFilter("Contract Expiry Month"));
    //         EmpVar.Validate("Contract Expiry Date", CalcDate(StrSubstNo('<%1>', Employee1.GetFilter("Contract Expiry Month")), ContractRenewDate));
    //         EmpVar.Validate(Status, EmpVar.Status::Active);
    //         EmpVar.Modify;
    //         CollapseLeaveRequest(EmpVar."No.");
    //         if ServiceHistory.Get(ServiceCode) then begin
    //             ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
    //             ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
    //             ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
    //             ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Modify;
    //         end;
    //         Message('Updated');
    //     end;
    // end;

    // local procedure CollapseLeaveRequest(EmpCode: Code[20])
    // var
    //     LeaveTypeSetup: Record "Leave Type Setup";
    //     LeaveEarn: Record "Leave Earn";
    // begin
    //     LeaveTypeSetup.Reset;
    //     LeaveTypeSetup.SetRange("Leave For Employee Type", LeaveTypeSetup."Leave For Employee Type"::Contract);
    //     LeaveTypeSetup.SetRange("Employee No. Filter", EmpCode);
    //     if LeaveTypeSetup.FindFirst then
    //         repeat
    //             LeaveTypeSetup.CalcFields("Remaining Days");
    //             if LeaveTypeSetup."Remaining Days" > 0 then begin
    //                 LeaveEarn.Reset;
    //                 LeaveEarn.Init;
    //                 LeaveEarn.Validate("Leave Code", LeaveTypeSetup.Code);
    //                 LeaveEarn.Validate(EmpNo, EmpCode);
    //                 LeaveEarn.Validate("Fiscal year", ReturnFiscalYear(Today));
    //                 LeaveEarn.Validate("Posted Date", Today);
    //                 LeaveEarn.Validate("Balancing Days", -LeaveTypeSetup."Remaining Days");
    //                 LeaveEarn.Validate(Remarks, 'Leave Collapsed.');
    //                 LeaveEarn.Validate(Type, LeaveEarn.Type::Collapsed);
    //                 LeaveEarn.Insert(true);
    //             end;
    //         until LeaveTypeSetup.Next = 0;
    // end;

    // local procedure ValidateTransferField(EmployeeTransferRec: Record "Employee Transfer")
    // var
    //     FunctionalTitle: Record "Functional Title";
    // begin
    //     Employee.Get(EmployeeTransferRec."Employee No.");
    //     Employee."Deputation on" := EmployeeTransferRec."Deputation On (To)";
    //     case Employee."Deputation on" of
    //         Employee."Deputation on"::Province:
    //             Employee.Validate("Province Code", EmployeeTransferRec."Province Code (To)");
    //         // Employee."Deputation on"::"Sub Province":
    //         //     Employee.Validate("Sub Province Code", EmployeeTransferRec."Sub Province Code (To)");
    //         Employee."Deputation on"::Branch:
    //             Employee.Validate("Global Dimension 1 Code", EmployeeTransferRec."Shortcut Dimension 1 Code (To)");
    //         Employee."Deputation on"::Department:
    //             Employee.Validate("Department Code", EmployeeTransferRec."Department Code (To)");
    //         Employee."Deputation on"::"Extension Counter":
    //             Employee.Validate("Extension Counter Code", EmployeeTransferRec."Extension Counter (To)");
    //         Employee."Deputation on"::Unit:
    //             Employee.Validate("Unit Code", EmployeeTransferRec."Unit (To)");
    //     end;
    //     Employee."Functional Title" := EmployeeTransferRec."Functional Title (To)";
    //     if FunctionalTitle.Get(EmployeeTransferRec."Functional Title (To)") then;
    //     Employee."Functional Title Desc" := FunctionalTitle.Description;
    //     Employee."Last Placement Date" := EmployeeTransferRec."Transfer Effective Date"; //Min -- Assign "Transfer Effective Date".
    //     Employee.Modify;
    // end;

    // local procedure ReinstateTransfer(EmpAct: Record "Employee Activity")
    // var
    //     EmpVar: Record Employee;
    //     ServiceCode: Code[20];
    //     ServiceHistory: Record "Employee Service History";
    // begin
    //     EmpVar.Get(EmpAct."Employee No.");
    //     ServiceCode := AddToServiceHistory(EmpVar."No.", ServiceHistory."Service Event"::Transfer, 'Reinstating Transfer', EmpAct."End Date");
    //     EmpVar.Validate("Functional Title", EmpAct."Functional Title");
    //     EmpVar.Validate("Deputation on", EmpAct."Deputation On");
    //     case EmpVar."Deputation on" of
    //         EmpVar."Deputation on"::Branch:
    //             EmpVar.Validate("Global Dimension 1 Code", EmpAct."Shortcut Dimension 1 Code");
    //         EmpVar."Deputation on"::Province:
    //             EmpVar.Validate("Province Code", EmpAct."Province Code");
    //         // EmpVar."Deputation on"::"Sub Province":
    //         //     EmpVar.Validate("Sub Province Code", EmpAct."Sub Province Code");
    //         EmpVar."Deputation on"::Unit:
    //             EmpVar.Validate("Unit Code", EmpAct."Unit Code");
    //         EmpVar."Deputation on"::"Extension Counter":
    //             EmpVar.Validate("Extension Counter Code", EmpAct."Extension Counter Code");
    //         EmpVar."Deputation on"::Department:
    //             EmpVar.Validate("Department Code", EmpAct.Department);
    //     end;
    //     EmpVar.Modify;
    //     if ServiceHistory.Get(ServiceCode) then begin
    //         ServiceHistory.Validate("Functional Title (To)", EmpVar."Functional Title");
    //         ServiceHistory.Validate("Salary Level (To)", EmpVar."Salary Level");
    //         ServiceHistory.Validate("Deputation On (To)", EmpVar."Deputation on");
    //         ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //         ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //         ServiceHistory.Modify;
    //     end;
    // end;

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
            EmployeeInsuranceInformation."Employee No." := EmployeeLoanAdvance."Employee Code";
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

    procedure OpenRFRequest(EmpCode: Code[20]; var RF: Record "Retirement Fund" temporary)
    var
        PostedPayrollHdr: Record "Posted Payroll Header";
        PostedPayrollLine: Record "Posted Payroll Line";
        PostedDocFound: Boolean;
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        TotalDeduction: Decimal;
        PayrollAttribute: Record "Payroll Attributes";
        LevelWiseAttributes: Record "Level Wise Attributes";
    begin
        Clear(Employee);
        Employee.Get(EmpCode);
        PRSetup.Get;
        PRSetup.TestField("Tax Ex. Amt Divsion");

        RF.Init;
        RF.Validate("Employee No.", EmpCode);
        RF.Validate("Fiscal Year", ReturnFiscalYear(Today));
        RF.Validate("Approval Status", RF."Approval Status"::Open);
        RF.Validate("Created Date", CurrentDateTime);
        RF.Validate("Requested Date", CurrentDateTime);
        RF.Insert;

        PostedPayrollHdr.Reset;
        PostedPayrollHdr.SetRange("From Date", PRSetup."Payroll Fiscal Year Start Date", PRSetup."Payroll Fiscal Year End Date");
        PostedPayrollHdr.SetRange(Reversed, false);
        if PostedPayrollHdr.FindLast then begin
            repeat
                PostedPayrollLine.Reset;
                PostedPayrollLine.SetRange("Document No.", PostedPayrollHdr."No.");
                PostedPayrollLine.SetRange("Employee No.", EmpCode);
                if PostedPayrollLine.FindLast then
                    PostedDocFound := true;
            until (PostedPayrollHdr.Next(-1) = 0) or PostedDocFound;
            if PostedPayrollHdr.Get(PostedPayrollLine."Document No.") then;

            if PostedPayrollHdr."Nepali Month" = PostedPayrollHdr."Nepali Month"::Chaitra then
                RF."Payroll Month" := RF."Payroll Month"::Baisakh
            else
                RF."Payroll Month" := PostedPayrollHdr."Nepali Month" + 1;
        end;

        if not PostedDocFound then begin
            EngNep.Reset;
            if Employee."Employment Date" > PRSetup."Payroll Fiscal Year Start Date" then begin
                EngNep.SetRange("English Date", Employee."Employment Date");
            end else begin
                EngNep.SetRange("English Date", PRSetup."Payroll Fiscal Year Start Date");
            end;
            EngNep.FindFirst;
            RF."Payroll Month" := EngNep."Nepali Month";
        end;

        WITH RF DO BEGIN
            "Projection Month" := PostedPayrollLine."Projection Month";
            Employee.SetFilter("Date Filter", '%1..%2', PRSetup."Payroll Fiscal Year Start Date", PRSetup."Payroll Fiscal Year End Date");
            Employee.CalcFields("PF Contribution", "CIT Deposit", "RF Deposit", "Total Retirement Contribution");
            RF."Annual Accessible Income" := PostedPayrollLine."Assessable Income";
            if RF."Annual Accessible Income" / PRSetup."Tax Ex. Amt Divsion" < PRSetup."Tax Ex. Amt. not Exceeding" then
                "RF Contribution Eligible Amt" := Round(RF."Annual Accessible Income" / PRSetup."Tax Ex. Amt Divsion", 0.01, '=')
            else
                "RF Contribution Eligible Amt" := PRSetup."Tax Ex. Amt. not Exceeding";
            "Provident Fund Deposited" := Employee."PF Contribution" * 2;
            "RF Contribution Deposited" := Employee."RF Deposit";
            "CIT Contribution Deposited" := Employee."Total Retirement Contribution"; //Min -- For CIT Contribution Deposited
            PayrollAttributesUsage.Reset;
            PayrollAttributesUsage.SetRange("Employee Code", EmpCode);
            PayrollAttributesUsage.SetRange(Subtype, PayrollAttributesUsage.Subtype::"Employee Contribution");
            if PayrollAttributesUsage.FindFirst then begin
                LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level");
                "Provident Fund Projected" := LevelWiseAttributes."Total Basic Salary" * 0.1 * 2 * ("Projection Month");
            end;

            RF."Actual/Projected Contribution" := RF."Provident Fund Deposited" + RF."RF Contribution Deposited" + RF."Provident Fund Projected" + RF."CIT Contribution Deposited"; //Min -- Added "CIT Contribution Deposited"
            RF."Additional Space for RF Cont." := Round(RF."RF Contribution Eligible Amt" - RF."Actual/Projected Contribution", 0.01, '=');
            //RF."Lumpsum Committed Contribution" := RF."RTF Amount (Lumpsum)" + RF."CIT Amount( Lumpsum)"; //Min
            CalculateRetirementFund(RF, RF."Projection Month");
            RF.Difference := Round(RF."RF Contribution Eligible Amt" - RF."Total Deduction", 0.01, '=');
            RF.Modify;

            if GuiAllowed then //NICASIA SM for Web Portal
                PAGE.Run(PAGE::"Retirement Fund Card", RF)
        end;
    end;

    procedure CalculateRetirementFund(var RF: Record "Retirement Fund"; ProjectionMonth: Integer)
    begin
        RF."Total Committed Contribution" := (RF."RTF Amount (Month)" * (ProjectionMonth)) +
                           RF."RTF Amount (Lumpsum)" + (RF."CIT Amount (Month)" * (ProjectionMonth)) +
                           RF."CIT Amount( Lumpsum)";

        RF."Total Deduction" := RF."Total Committed Contribution" + RF."Actual/Projected Contribution";

        RF.Difference := Round(RF."RF Contribution Eligible Amt" - RF."Total Deduction", 0.01, '=');

        RF."Lumpsum Committed Contribution" := RF."RTF Amount (Lumpsum)" + RF."CIT Amount( Lumpsum)"; //Min -- Calc for lumpsum comm. contri.

        RF."Lumpsum Space Max Benefit" := Round(RF."Additional Space for RF Cont." - (RF."RTF Amount (Month)" + RF."CIT Amount (Month)") * ProjectionMonth, 0.01, '='); //Min -- Lumpsum space Max benefit calc.
        if RF."Lumpsum Space Max Benefit" < 0 then
            RF."Lumpsum Space Max Benefit" := 0;
    end;

    procedure ScreenRF(var RetirementFund: Record "Retirement Fund")
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
    begin
        PRSetup.Get;
        // RetirementFund.TestField("Approval Status", RetirementFund."Approval Status"::Pending);
        // RetirementFund."Approval Status" := RetirementFund."Approval Status"::Screened;
        RetirementFund."Screened Date" := CurrentDateTime;
        RetirementFund."Screened By" := UserId;
        Employee.Get(RetirementFund."Employee No.");
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", RetirementFund."Employee No.");
        PayrollAttributesUsage.SetFilter(Code, '%1|%2|%3|%4', PRSetup."CIT (Monthly)", PRSetup."CIT (Lumpsum)", PRSetup."RTF (Monthly)", PRSetup."RTF (Lumpsum)");  //use payroll subtype
        if PayrollAttributesUsage.FindSet then
            repeat
                case PayrollAttributesUsage.Code of
                    PRSetup."CIT (Monthly)":
                        begin
                            //IF RetirementFund."CIT Amount (Month)" <> 0 THEN //Min 6.9.2022
                            PayrollAttributesUsage.Amount := RetirementFund."CIT Amount (Month)";
                        end;
                    PRSetup."CIT (Lumpsum)":
                        begin
                            if RetirementFund."CIT Amount( Lumpsum)" <> 0 then
                                Employee."Lumpsum CIT (Not Actual)" := RetirementFund."CIT Amount( Lumpsum)";
                        end;

                    PRSetup."RTF (Monthly)":
                        begin
                            //IF RetirementFund."RTF Amount (Month)" <> 0 THEN //Min 6.9.2022
                            PayrollAttributesUsage.Amount := RetirementFund."RTF Amount (Month)";
                        end;

                    PRSetup."RTF (Lumpsum)":
                        begin
                            if RetirementFund."RTF Amount (Lumpsum)" <> 0 then
                                Employee."Lumpsum RF (Not Actual)" := RetirementFund."RTF Amount (Lumpsum)";
                        end;
                end;
                PayrollAttributesUsage.Modify(true);
                Employee.Modify;
            until PayrollAttributesUsage.Next = 0;
    end;

    procedure ApplyForRetirementFund(TempRetirementFund: Record "Retirement Fund" temporary): Boolean
    var
        ConfirmTravel: Label 'Do you want to send travel request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        RetirementFund: Record "Retirement Fund";
        LoanMgt: Codeunit "Loan Mgt.";
    begin
        if GuiAllowed then
            if not Confirm('Do you want to send retirement fund for approval ?', false) then
                exit;

        TempRetirementFund.TestField("Fiscal Year");
        TempRetirementFund.TestField("Payroll Month");
        TempRetirementFund.TestField("Employee No.");


        RetirementFund.Init;
        RetirementFund.TransferFields(TempRetirementFund);
        RetirementFund.Validate("Approval Status", RetirementFund."Approval Status"::Pending);
        RetirementFund.Insert(true);

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
        //Employee.SETRANGE("No.",'PB4113');
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

    // procedure PopUpChangingTravelApprover(TravelRequest: Record "Travel Request")
    // var
    //     TravelRequestPageBuilder: FilterPageBuilder;
    //     EmpTravel: Record "Employee Activity";
    // begin
    //     TravelRequestPageBuilder.AddRecord('Change Approver', EmpTravel);
    //     TravelRequestPageBuilder.ADdField('Change Approver', EmpTravel."Approver Code");
    //     if TravelRequestPageBuilder.RunModal then begin
    //         EmpTravel.SetView(TravelRequestPageBuilder.GetView('Change Approver'));
    //         if EmpTravel.GetFilter("Approver Code") = '' then
    //             Error('Approver Code cannot be blank.');
    //         TravelRequest.Validate("Approver Code", EmpTravel.GetFilter("Approver Code"));
    //         TravelRequest.Modify;
    //         Message('Approver updated.');
    //     end;
    // end;

    // procedure PopUpChangingTravelRecommender(TravelRequest: Record "Travel Request")
    // var
    //     TravelRequestPageBuilder: FilterPageBuilder;
    //     EmpTravel: Record "Employee Activity";
    // begin
    //     TravelRequestPageBuilder.AddRecord('Change Recommender', EmpTravel);
    //     TravelRequestPageBuilder.ADdField('Change Recommender', EmpTravel."Recommender Code");
    //     if TravelRequestPageBuilder.RunModal then begin
    //         EmpTravel.SetView(TravelRequestPageBuilder.GetView('Change Recommender'));
    //         if EmpTravel.GetFilter("Recommender Code") = '' then
    //             Error('Recommender Code cannot be blank.');
    //         TravelRequest.Validate("Recommender Code", EmpTravel.GetFilter("Recommender Code"));
    //         TravelRequest.Modify;
    //         Message('Recommender updated.');
    //     end;
    // end;

    //     procedure PopUpChangingJobPositionEmployee(EmployeeRec: Record Employee)
    //     var
    //         EmployeePageBuilder: FilterPageBuilder;
    //         EmpRec: Record Employee;
    //     begin
    //         EmployeePageBuilder.AddRecord('Change Salary Level', EmpRec);
    //         EmployeePageBuilder.ADdField('Change Salary Level', EmpRec."Salary Level");
    //         if EmployeePageBuilder.RunModal then begin
    //             EmpRec.SetView(EmployeePageBuilder.GetView('Change Salary Level'));
    //             if EmpRec.GetFilter("Salary Level") = '' then
    //                 Error('Salary Level cannot be blank.');
    //             EmployeeRec.Validate("Salary Level", EmpRec.GetFilter("Salary Level"));
    //             EmployeeRec.Modify;
    //             Message('Job Position updated.');
    //         end;
    //     end;

    //     procedure ReinstateCancelTransfer(EmpHrTransfer: Record "Employee Transfer")
    //     var
    //         EmpVar: Record Employee;
    //         ServiceCode: Code[20];
    //         ServiceHistory: Record "Employee Service History";
    //     begin
    //         EmpVar.Get(EmpHrTransfer."Employee No.");
    //         //ServiceCode := AddToServiceHistory(EmpVar."No.",ServiceHistory."Service Event"::Transfer,'Reinstating Transfer',EmpAct."Transfer Effective Date");
    //         EmpVar.Validate("Functional Title", EmpHrTransfer."Functional Title");
    //         EmpVar.Validate("Deputation on", EmpHrTransfer."Deputation On");
    //         case EmpVar."Deputation on" of
    //             EmpVar."Deputation on"::Branch:
    //                 EmpVar.Validate("Global Dimension 1 Code", EmpHrTransfer."Shortcut Dimension 1 Code");
    //             EmpVar."Deputation on"::Province:
    //                 EmpVar.Validate("Province Code", EmpHrTransfer."Province Code");
    //             // EmpVar."Deputation on"::"Sub Province":
    //             //     EmpVar.Validate("Sub Province Code", EmpHrTransfer."Sub Province Code");
    //             EmpVar."Deputation on"::Unit:
    //                 EmpVar.Validate("Unit Code", EmpHrTransfer."Unit Code");
    //             EmpVar."Deputation on"::"Extension Counter":
    //                 EmpVar.Validate("Extension Counter Code", EmpHrTransfer."Extension Counter Code");
    //             EmpVar."Deputation on"::Department:
    //                 EmpVar.Validate("Department Code", EmpHrTransfer.Department);
    //         end;
    //         EmpVar.Modify;
    //         /*IF ServiceHistory.GET(ServiceCode) THEN BEGIN
    //           ServiceHistory.VALIDATE("Functional Title (To)",EmpVar."Functional Title");
    //           ServiceHistory.VALIDATE("Salary Level (To)",EmpVar."Salary Level");
    //           ServiceHistory.VALIDATE("Deputation On (To)",EmpVar."Deputation on");
    //           ServiceHistory.VALIDATE("Deputation Code (To)",ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
    //           ServiceHistory.VALIDATE("Deputation Value (To)",ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
    //           ServiceHistory.MODIFY;
    //         END;*/

    //     end;

    //     procedure UpdateMissedTransfer(var EmployeeTransferRec: Record "Employee Transfer")
    //     var
    //         ConfirmApprove: Label 'Confirm Approve?';
    //         ConfirmReject: Label 'Confirm Reject?';
    //         ServiceHistoryCode: Code[20];
    //         ServiceHistory: Record "Employee Service History";
    //         PreviousServiceHistory: Record "Employee Service History";
    //     begin
    //         /*IF "Approver Code" <> GetEmployeeNo THEN
    //   ERROR('You are not eligible to approved this document');*/
    //         /*TESTFIELD("Approval Status","Approval Status"::Screened);
    //         VALIDATE("Approval Status", "Approval Status"::Approved);
    //         VALIDATE("Approved Date",TODAY);*/
    //         if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::"Temporary" then
    //             ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Temporary Deputation", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
    //         if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::Officiating then
    //             ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Officiating Arrangement", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
    //         if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::General then
    //             ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::Transfer, EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
    //         EmployeeTransferRec.Modify;
    //         ValidateTransferField(EmployeeTransferRec);

    //         if ServiceHistory.Get(ServiceHistoryCode) then begin
    //             ServiceHistory.Validate("Functional Title (To)", EmployeeTransferRec."Functional Title (To)");
    //             ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
    //             ServiceHistory.Validate("Deputation On (To)", EmployeeTransferRec."Deputation On (To)");
    //             ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Validate("Document No.", EmployeeTransferRec."No.");
    //             PreviousServiceHistory.Reset;
    //             PreviousServiceHistory.SetRange("Employee No.", ServiceHistory."Employee No.");
    //             PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceHistoryCode);
    //             PreviousServiceHistory.SetCurrentKey("Effective Date");
    //             if (PreviousServiceHistory.FindLast) then
    //                 if (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") or
    //                   (EmployeeTransferRec."Transfer Category" in [EmployeeTransferRec."Transfer Category"::Officiating, EmployeeTransferRec."Transfer Category"::"Temporary"]) then
    //                     ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
    //             ServiceHistory.Modify;
    //         end;
    //         //SendMailFromTemplate(DATABASE::"Employee Activity",Type::"Employee Transfer","Approval Status"::Approved,Remarks,'',"No.",0);
    //         Message('Document has been updated.');

    //     end;

    //     procedure ApprovedTransferUpdate(var EmployeeTransferRec: Record "Employee Transfer")
    //     var
    //         ConfirmApprove: Label 'Confirm Approve?';
    //         ConfirmReject: Label 'Confirm Reject?';
    //         ServiceHistoryCode: Code[20];
    //         ServiceHistory: Record "Employee Service History";
    //         PreviousServiceHistory: Record "Employee Service History";
    //     begin
    //         if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::"Temporary" then
    //             ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Temporary Deputation", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
    //         if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::Officiating then
    //             ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::"Officiating Arrangement", EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
    //         if EmployeeTransferRec."Transfer Category" = EmployeeTransferRec."Transfer Category"::General then
    //             ServiceHistoryCode := AddToServiceHistory(EmployeeTransferRec."Employee No.", ServiceHistory."Service Event"::Transfer, EmployeeTransferRec.Remarks, EmployeeTransferRec."Transfer Effective Date");
    //         EmployeeTransferRec.Modify;
    //         ValidateTransferField(EmployeeTransferRec);
    //         if ServiceHistory.Get(ServiceHistoryCode) then begin
    //             ServiceHistory.Validate("Functional Title (To)", EmployeeTransferRec."Functional Title (To)");
    //             ServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
    //             ServiceHistory.Validate("Deputation On (To)", EmployeeTransferRec."Deputation On (To)");
    //             ServiceHistory.Validate("Deputation Code (To)", ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Validate("Deputation Value (To)", ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)", ServiceHistory."Employee No."));
    //             ServiceHistory.Validate("Document No.", EmployeeTransferRec."No.");
    //             PreviousServiceHistory.Reset;
    //             PreviousServiceHistory.SetRange("Employee No.", ServiceHistory."Employee No.");
    //             PreviousServiceHistory.SetFilter("Service History Code", '<>%1', ServiceHistoryCode);
    //             PreviousServiceHistory.SetCurrentKey("Effective Date");
    //             if (PreviousServiceHistory.FindLast) then
    //                 if (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") or
    //                   (EmployeeTransferRec."Transfer Category" in [EmployeeTransferRec."Transfer Category"::Officiating, EmployeeTransferRec."Transfer Category"::"Temporary"]) then
    //                     ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
    //             ServiceHistory.Modify;
    //         end;
    //     end;

    procedure ResignationEmailSend(EmployeeNo: Code[20])
    var
        EmpRec: Record Employee;
        EmailMessage: Record "Email Template Message";
        EmailReceipientText: Text;
        ListEmailReceipientText: List of [Text];
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
        EmailReceipent: Record "Email Template Recipient";
        EmailReceipentRec: Record "Email Template Recipient";
        EmailccReceipientText: List of [Text];
        EmailbccReceipientText: List of [Text];

    begin
        HRSetup.Get;
        clear(CodeunitEmailMessage);
        // SMTPSetup.Get;
        CompanyInfo.Get;
        if EmpRec.Get(EmployeeNo) then begin
            EmailReceipientText := EmpRec."Company E-Mail";
            EmailTemplate.Reset;
            EmailTemplate.SetRange(Code, HRSetup."Resignation Submit Email Temp");
            if EmailTemplate.FindFirst then begin
                Clear(Footer);
                Clear(Header);
                Clear(Body);
                // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", EmailReceipientText, EmailTemplate.Subject, '', true);
                CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, '');
                EmailMessage.Reset;
                EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                if EmailMessage.FindFirst then
                    repeat
                        case EmailMessage.Type of
                            EmailMessage.Type::Header:
                                Header := Header + EmailMessage."Body Message" + '<br>';

                            EmailMessage.Type::Body:
                                Body := Body + EmailMessage."Body Message" + '<br>';

                            EmailMessage.Type::Footer:
                                Footer := Footer + EmailMessage."Body Message" + '<br>';
                        end;
                    until EmailMessage.Next = 0;
            end;

            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Body);
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Full Name") + Colon + EmpRec."Full Name");
            CodeunitEmailMessage.AppendToBody(', ');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("No.") + Colon + EmpRec."No.");
            CodeunitEmailMessage.AppendToBody(', ');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Province Code") + Colon + EmpRec."Province Code");
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);

            EmailReceipent.Reset;
            EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipent.SetRange("Province Code", EmpRec."Province Code");
            EmailReceipent.SetRange("Recipient Type", EmailReceipent."Recipient Type"::"To");
            if EmailReceipent.FindFirst then
                repeat
                    //IF EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" THEN
                    ListEmailReceipientText.Add(EmailReceipent."Email Recipients");
                until EmailReceipent.Next = 0;

            EmailReceipentRec.Reset;
            EmailReceipentRec.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipentRec.SetFilter("Province Code", '');
            EmailReceipentRec.SetRange("Recipient Type", EmailReceipentRec."Recipient Type"::Cc);
            if EmailReceipentRec.FindFirst then
                repeat
                    EmailccReceipientText.Add(EmailReceipentRec."Email Recipients");
                until EmailReceipentRec.Next = 0;
            CodeunitEmailMessage.Create(ListEmailReceipientText, EmailTemplate.Subject, '', true, EmailccReceipientText, EmailbccReceipientText);
            Email.send(CodeunitEmailMessage);
            //MESSAGE('Success');
        end;
    end;

    local procedure UpdatePortalTransferEffDate(TransferEffectiveDate: Date; EmployeeID: Code[20])
    begin
        Clear(commandtext);
        // ConnectSQL();
        //commandtext := 'UPDATE Employees SET TransferEffectiveDate = NULL WHERE EmployeeID = @EmployeeID';
        commandtext := 'UPDATE Employees SET TransferEffectiveDate = @TransferEffectiveDate WHERE EmployeeID = @EmployeeID';
        // SetupSQLCommand;
        // SQLCommand.Parameters.AddWithValue('@TransferEffectiveDate', TransferEffectiveDate);
        //SQLCommand.Parameters.AddWithValue('@TransferEffectiveDate', 'NULL');
        // SQLCommand.Parameters.AddWithValue('@EmployeeID', EmployeeID);
        // SQLCommand.ExecuteNonQuery;
        // DisconnectSQL();
    end;

    procedure GetEmpName(): Text
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        exit(Employee."Full Name");
    end;

    procedure SendTransferSubmitBy(TempEmpAct: Record "Employee Activity" temporary): Boolean
    var
        EmpAct: Record "Employee Activity";
        ConfirmTransfer: Label 'Do you want to send transfer request ?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        TransferSent: Label 'Transfer request approval has been sent.';
        NoRecommender: Label 'No Recommender Code.';
        NoApprover: Label 'No Approver Code.';
        IncomingDoc: Record "Incoming Document";
        AttachSetup: Record "Attachment Setup";
    begin
        if not GuiAllowed then
            TempEmpAct."Transfer Category" := TempEmpAct."Transfer Category"::General;
        //TempEmpAct.TESTFIELD(Description);
        //TempEmpAct.TESTFIELD("Reason for Resignation"); //here reason for transfer
        TempEmpAct.TestField("Transfer Category");

        if TempEmpAct."Transfer Category" = TempEmpAct."Transfer Category"::"Temporary" then begin
            TempEmpAct.TestField("Start Date");
            TempEmpAct.TestField("End Date");
        end;
        EmpAct.Reset;
        EmpAct.SetRange(Type, EmpAct.Type::"HR Transfer");
        EmpAct.SetFilter("Approval Status", '<>%1', EmpAct."Approval Status"::Acknowledged);
        EmpAct.SetRange("Employee No.", TempEmpAct."Employee No.");
        EmpAct.SetFilter("No.", '<>%1', TempEmpAct."No.");
        if EmpAct.FindFirst then
            Error('Transfer card of employee %1 is still open or pending.', EmpAct."Employee Name");

        EmpAct.Reset;
        EmpAct.Init;
        EmpAct.Validate("Requested Date", Today);
        EmpAct.TransferFields(TempEmpAct);
        EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Pending);
        EmpAct.Validate("User ID", UserId);
        Employee.Get(EmpAct."Employee No.");
        //EmpAct.VALIDATE("Recommender Code", Employee."Approver Code");
        HRSetup.Get;
        HRSetup.TestField("HR Head Functional Title");
        HRSetup.TestField("HR Department Code");

        Employee.Reset;
        Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee.SetRange("Department Code", HRSetup."HR Department Code");
        Employee.SetRange(Status, Employee.Status::Active); //Min
        if Employee.FindFirst then
            EmpAct.Validate("Approver Code", Employee."No.");
        /*IF EmpAct.Type = EmpAct.Type::"Employee Transfer" THEN
          IF EmpAct."Recommender Code" = '' THEN
            ERROR(NoRecommender);*/
        if EmpAct."Approver Code" = '' then
            Error(NoApprover);

        EmpAct.Insert(true);

        SendMailFromTemplate(DATABASE::"Employee Activity", EmpAct.Type::"Employee Transfer", EmpAct."Approval Status"::Open, '', EmpAct."Employee No.", EmpAct."No.", 0);   //For email
        Message(TransferSent);
        exit(true);

    end;

    procedure SendEmailOfferLetter(VacancyCode: Code[20]; Candidate: Record Candidate)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Filename: Text;
        EmailReceipent: List of [Text];
        OfferLetter: Report "Offer Letter2";
        Cand: Record Candidate;
        EmailReceipentRec: Record "Email Template Recipient";
        CC: List of [Text];
        bCC: List of [Text];
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        if EmailTemplate.Get(HRSetup."Offer Letter Sent") then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
            // CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate.Subject, '');nilesh
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
            CodeunitEmailMessage.AppendToBody(Body);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);

            EmailReceipentRec.Reset;
            EmailReceipentRec.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipentRec.SetRange("Recipient Type", EmailReceipentRec."Recipient Type"::Cc);
            if EmailReceipentRec.FindFirst then
                repeat
                    cc.Add(EmailReceipentRec."Email Recipients");
                until EmailReceipentRec.Next = 0;
            EmailReceipent.add(Candidate."E-Mail");
            CodeunitEmailMessage.Create(EmailReceipent, EmailTemplate.Subject, '', true, CC, bcc);
            if Email.Send(CodeunitEmailMessage) then
                Message('Successfully Sent')
            else
                Message('Not Sent');
        end;
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

    procedure ResignationRejectEmailSend(EmployeeNo: Code[20])
    var
        EmpRec: Record Employee;
        EmailMessage: Record "Email Template Message";
        EmailReceipientText: Text;
        ListEmailReceipientText: List of [Text];
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
        EmailReceipent: Record "Email Template Recipient";
        EmailReceipentRec: Record "Email Template Recipient";
        cc: List of [Text];
        bcc: List of [Text];
    begin
        HRSetup.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        CompanyInfo.Get;
        if EmpRec.Get(EmployeeNo) then begin
            EmailReceipientText := EmpRec."Company E-Mail";
            EmailTemplate.Reset;
            EmailTemplate.SetRange(Code, HRSetup."Resignation Reject Email Temp");
            if EmailTemplate.FindFirst then begin
                Clear(Footer);
                Clear(Header);
                Clear(Body);
                // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", EmailReceipientText, EmailTemplate.Subject, '', true);
                CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, '');
                EmailMessage.Reset;
                EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                if EmailMessage.FindFirst then
                    repeat
                        case EmailMessage.Type of
                            EmailMessage.Type::Header:
                                Header := Header + EmailMessage."Body Message" + '<br>';

                            EmailMessage.Type::Body:
                                Body := Body + EmailMessage."Body Message" + '<br>';

                            EmailMessage.Type::Footer:
                                Footer := Footer + EmailMessage."Body Message" + '<br>';
                        end;
                    until EmailMessage.Next = 0;
            end;

            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Body);
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Full Name") + Colon + EmpRec."Full Name");
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("No.") + Colon + EmpRec."No.");
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Province Code") + Colon + EmpRec."Province Code");
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);

            EmailReceipent.Reset;
            EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipent.SetRange("Province Code", EmpRec."Province Code");
            EmailReceipent.SetRange("Recipient Type", EmailReceipent."Recipient Type"::"To");
            if EmailReceipent.FindFirst then
                repeat
                    //IF EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" THEN
                    ListEmailReceipientText.Add(EmailReceipent."Email Recipients");
                until EmailReceipent.Next = 0;

            EmailReceipentRec.Reset;
            EmailReceipentRec.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipentRec.SetFilter("Province Code", '');
            EmailReceipentRec.SetRange("Recipient Type", EmailReceipentRec."Recipient Type"::Cc);
            if EmailReceipentRec.FindFirst then
                repeat
                    cc.Add(EmailReceipentRec."Email Recipients");
                    CodeunitEmailMessage.Create(ListEmailReceipientText, EmailTemplate.Subject, '', true, cc, bcc);
                until EmailReceipentRec.Next = 0;

            Email.Send(CodeunitEmailMessage);
            //MESSAGE('Success');
        end;
    end;

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
        //>>Aakrista KPI1.0
    end;


    // trigger SQLCommand::Disposed(sender: Variant; e: DotNet EventArgs)
    // begin
    // end;

    // trigger SQLConnection::InfoMessage(sender: Variant; e: DotNet SqlInfoMessageEventArgs)
    // begin
    // end;

    // trigger SQLConnection::StateChange(sender: Variant; e: DotNet StateChangeEventArgs)
    // begin
    // end;

    // trigger SQLConnection::Disposed(sender: Variant; e: DotNet EventArgs)
    // begin
    // end;
    PROCEDURE InsertFacilitatorDocApprovalWorkflowSteps(Workflow: Record Workflow; DocSendForApprovalConditionString: Text; DocSendForApprovalEventCode: Code[128]; DocCanceledConditionString: Text; DocCanceledEventCode: Code[128]; WorkflowStepArgument: Record "Workflow Step Argument"; ShowConfirmationMessage: Boolean);
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
        HRMgt: Codeunit "HR Mgt.";
        WorkFlowSetup: Codeunit "Workflow Setup";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ApprovalRequestCanceledMsg: label 'ENU=The approval request for the record has been canceled.';

    BEGIN
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
    END;

    PROCEDURE InsertTrainingDocApprovalWorkflowSteps(Workflow: Record Workflow; DocSendForApprovalConditionString: Text; DocSendForApprovalEventCode: Code[128]; DocCanceledConditionString: Text; DocCanceledEventCode: Code[128]; WorkflowStepArgument: Record "Workflow Step Argument"; ShowConfirmationMessage: Boolean);
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
        HRMgt: Codeunit "HR Mgt.";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ApprovalRequestCanceledMsg: label 'ENU=The approval request for the record has been canceled.';
        WorkFlowSetup: Codeunit "Workflow Setup";

    BEGIN
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
    END;

    PROCEDURE InsertVacancyDocApprovalWorkflowSteps(Workflow: Record Workflow; DocSendForApprovalConditionString: Text; DocSendForApprovalEventCode: Code[128]; DocCanceledConditionString: Text; DocCanceledEventCode: Code[128]; WorkflowStepArgument: Record 1523; ShowConfirmationMessage: Boolean);
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
        HRMgt: Codeunit "HR Mgt.";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ApprovalRequestCanceledMsg: label 'ENU=The approval request for the record has been canceled.';
        WorkFlowSetup: Codeunit "Workflow Setup";

    BEGIN
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
    END;

    procedure CheckDateStatus(CalendarCode: Code[20]; TargetDate: Date; VAR Description: Text[50]; VAR Proviences: Text[150]; VAR Gender: Option; VAR InOutValley: Option; VAR PostingRegion: Option; VAR Branch: Text): Boolean
    var
        BaseCalChange: Record "Base Calendar Change";
    begin
        BaseCalChange.RESET;
        BaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FINDSET THEN
            REPEAT
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN BEGIN
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";             // returning provience
                            Gender := BaseCalChange."Gender Filter";                     //returning gender
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";
                            Branch := BaseCalChange."Shortcut Dimension 1 Code";
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN BEGIN
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";           // returning provience
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";                  //returning gender
                            Branch := BaseCalChange."Shortcut Dimension 1 Code";
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN BEGIN
                            Description := BaseCalChange.Description;
                            Proviences := BaseCalChange."Province Filter";         // returning provience
                            Gender := BaseCalChange."Gender Filter";
                            InOutValley := BaseCalChange."Inside/Outside Valley";
                            PostingRegion := BaseCalChange."Posting Region";            //returning gender
                            Branch := BaseCalChange."Shortcut Dimension 1 Code";
                            EXIT(BaseCalChange.Nonworking);
                        END;
                END;
            UNTIL BaseCalChange.NEXT = 0;
        Description := '';
        Proviences := '';                                       // returning provience
        CLEAR(Gender);                                          //returning gender
        CLEAR(InOutValley);
        CLEAR(PostingRegion);
        CLEAR(Branch);
    end;

    PROCEDURE GenerateActualMatrixData(VAR RecRef: RecordRef; SetWanted: Option; MaximumSetLength: Integer; CaptionFieldNo: Integer; VAR RecordPosition: Text; VAR CaptionSet: ARRAY[32] OF Text[80]; VAR CaptionRange: Text; VAR CurrSetLength: Integer; VAR DescCaptionSet: ARRAY[32] OF Text; DescCaptionFieldNo: Integer; ShowCaption: Boolean);
    VAR
        Steps: Integer;
        Caption: Text;
        MaxCaptionLength: Integer;
    BEGIN
        CLEAR(CaptionSet);
        CLEAR(DescCaptionSet);
        CaptionRange := '';
        CurrSetLength := 0;

        IF RecRef.ISEMPTY THEN BEGIN
            RecordPosition := '';
            EXIT;
        END;

        CASE SetWanted OF
            SetOption::Initial:
                RecRef.FINDFIRST;
            SetOption::Previous:
                BEGIN
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    Steps := RecRef.NEXT(-MaximumSetLength);
                    IF NOT (Steps IN [-MaximumSetLength, 0]) THEN
                        ERROR(Text001);
                END;
            SetOption::Same:
                BEGIN
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                END;
            SetOption::Next:
                BEGIN
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    IF NOT (RecRef.NEXT(MaximumSetLength) = MaximumSetLength) THEN BEGIN
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    END;
                END;
            SetOption::PreviousColumn:
                BEGIN
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    Steps := RecRef.NEXT(-1);
                    IF NOT (Steps IN [-1, 0]) THEN
                        ERROR(Text001);
                END;
            SetOption::NextColumn:
                BEGIN
                    RecRef.SETPOSITION(RecordPosition);
                    RecRef.GET(RecRef.RECORDID);
                    IF NOT (RecRef.NEXT(1) = 1) THEN BEGIN
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    END;
                END;
        END;

        RecordPosition := RecRef.GETPOSITION;
        REPEAT
            CurrSetLength := CurrSetLength + 1;
            Caption := FORMAT(RecRef.FIELD(CaptionFieldNo).VALUE);
            MaxCaptionLength := MAXSTRLEN(CaptionSet[CurrSetLength]);
            IF STRLEN(Caption) <= MaxCaptionLength THEN
                CaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength)
            ELSE
                CaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength - 3) + '...';
        UNTIL (CurrSetLength = MaximumSetLength) OR (RecRef.NEXT <> 1);

        IF CurrSetLength = 1 THEN
            CaptionRange := CaptionSet[1]
        ELSE
            CaptionRange := CaptionSet[1] + '..' + CaptionSet[CurrSetLength];

        IF ShowCaption THEN BEGIN
            IF RecRef.ISEMPTY THEN BEGIN
                RecordPosition := '';
                EXIT;
            END;

            CASE SetWanted OF
                SetOption::Initial:
                    RecRef.FINDFIRST;
                SetOption::Previous:
                    BEGIN
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        Steps := RecRef.NEXT(-MaximumSetLength);
                        IF NOT (Steps IN [-MaximumSetLength, 0]) THEN
                            ERROR(Text001);
                    END;
                SetOption::Same:
                    BEGIN
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                    END;
                SetOption::Next:
                    BEGIN
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        IF NOT (RecRef.NEXT(MaximumSetLength) = MaximumSetLength) THEN BEGIN
                            RecRef.SETPOSITION(RecordPosition);
                            RecRef.GET(RecRef.RECORDID);
                        END;
                    END;
                SetOption::PreviousColumn:
                    BEGIN
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        Steps := RecRef.NEXT(-1);
                        IF NOT (Steps IN [-1, 0]) THEN
                            ERROR(Text001);
                    END;
                SetOption::NextColumn:
                    BEGIN
                        RecRef.SETPOSITION(RecordPosition);
                        RecRef.GET(RecRef.RECORDID);
                        IF NOT (RecRef.NEXT(1) = 1) THEN BEGIN
                            RecRef.SETPOSITION(RecordPosition);
                            RecRef.GET(RecRef.RECORDID);
                        END;
                    END;
            END;

            RecordPosition := RecRef.GETPOSITION;
            CurrSetLength := 0;
            REPEAT
                CurrSetLength := CurrSetLength + 1;
                Caption := FORMAT(RecRef.FIELD(DescCaptionFieldNo).VALUE);
                MaxCaptionLength := MAXSTRLEN(CaptionSet[CurrSetLength]);
                IF STRLEN(Caption) <= MaxCaptionLength THEN
                    DescCaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength)
                ELSE
                    DescCaptionSet[CurrSetLength] := COPYSTR(Caption, 1, MaxCaptionLength - 3) + '...';
            UNTIL (CurrSetLength = MaximumSetLength) OR (RecRef.NEXT <> 1);

            IF CurrSetLength = 1 THEN
                CaptionRange := DescCaptionSet[1]
            ELSE
                CaptionRange := DescCaptionSet[1] + '..' + DescCaptionSet[CurrSetLength];
        END;
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
}

