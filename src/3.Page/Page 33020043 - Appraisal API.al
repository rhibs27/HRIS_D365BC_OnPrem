page 33020043 "Appraisal API"
{
    // version APINICASIA1.00

    DelayedInsert = true;
    EntityName = 'appraisalEntity';
    EntitySetName = 'appraisalEntities';
    PageType = API;
    APIVersion = 'v2.0';
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = Appraisal;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(AppraisalCode; Rec."Appraisal Code") { }
                field(EmployeeCode; Rec."Employee Code") { }
                field(EmployeeName; Rec."Employee Name") { }
                field(DateofEmployement; Rec."Date of Employement") { }
                field(AppraisalType; Rec."Appraisal Type") { }
                field(FinalScore; Rec."Final Score") { }
                field(FinalGrade; Rec."Final Grade") { }
                field(Reviewer; Rec.Reviewer) { }
                field(CheckReviewer; Rec."Check Reviewer") { }
                field(ReviewerIII; Rec."Reviewer III") { }
                field(PostingDate; Rec."Posting Date") { }
                field(ReviewedScoreI; Rec."Reviewed Score I") { }
                field(ReviewedScoreII; Rec."Reviewed Score II") { }
                field(ReviewedScoreIII; Rec."Reviewed Score III") { }
                field(Department; Rec.Department) { }
                field(FunctionalTitle; Rec."Functional Title") { }
                field("Code"; Rec.Code) { }
                field(JobGrade; Rec."Job Grade") { }
                field(TotalTenureinBank; Rec."Total Tenure in Bank") { }
                field(SubmissionDate; Rec."Submission Date") { }
                field(ReviewedDateI; Rec."Reviewed Date I") { }
                field(ReviewedDateII; Rec."Reviewed Date II") { }
                field(ReviewedDateIII; Rec."Reviewed Date III") { }
                field(TotalTenureinCrcPosition; Rec."Total Tenure in Crc Position") { }
                field(Branch; Rec.Branch) { }
                field(BranchName; Rec."Branch Name") { }
                field(Posted; Rec.Posted) { }
                field(NoSeries; Rec."No. Series") { }
                field(KRACategory; Rec."KRA Category") { }
                field(ApprovedDate; Rec."Approved Date") { }
                field(Rating; Rec.Rating) { }
                field(Status; Rec.Status) { }
                field(AcademicDegree; Rec."Academic Degree") { }
                field(WrittenVerbalWarningIssued; Rec."Written Verbal Warning Issued") { }
                field(CompletionofTraining; Rec."Completion of Training") { }
                field(DisciplinaryActionsTaken; Rec."Disciplinary Actions Taken") { }
                field(CommendationsonFile; Rec."Commendations on File") { }
                field(FrequentUntidyUniform; Rec."Frequent Untidy Uniform") { }
                field(UninformedAbsence; Rec."Uninformed Absence") { }
                field(NoofSickLeavesTaken; Rec."No of Sick Leaves Taken") { }
                field(DevelopmentPlanRemarks; Rec."Development Plan Remarks") { }
                field(ImprovementTime; Rec."Improvement Time") { }
                field(ReporteesComments; Rec."Reportees Comments") { }
                field(SalesandMarketingCorporate; Rec."Sales and Marketing Corporate") { }
                field(SalesandMarketingRetail; Rec."Sales and Marketing Retail") { }
                field(Operations; Rec.Operations) { }
                field(FinanceorAccounts; Rec."Finance or Accounts") { }
                field(Administration; Rec.Administration) { }
                field(BackOffice; Rec."Back Office") { }
                field(HumanResource; Rec."Human Resource") { }
                field(ReviewerComments; Rec."Reviewer Comments") { }
                field(CheckReviewersComments; Rec."Check Reviewers Comments") { }
                field(UserID; Rec."User ID") { }
                field(RecommenderCode; Rec."Recommender Code") { }
                field(ApproverCode; Rec."Approver Code") { }
                field(RecommenderName; Rec."Recommender Name") { }
                field(ApproverName; Rec."Approver Name") { }
                field(RequestedDate; Rec."Requested Date") { }
                field(AppraisalSubtypeMonthly; Rec."Appraisal Subtype Monthly") { }
                field(AppraisalSubtypeQuarterly; Rec."Appraisal Subtype Quarterly") { }
                field(AppraisalAttachmentExt; AppraisalAttachmentExt) { }
                field(AppraisalAttachment; AppraisalAttachment)
                {
                    trigger OnValidate()
                    begin
                        if Rec."Appraisal Attachment" <> '' then
                            Clear(Rec."Appraisal Attachment");
                        AppraisalText := CreateGuid; //Min 6.25.2022
                        AppraisalText := DelChr(AppraisalText, '=', '{}-01');
                        AppraisalText := CopyStr(AppraisalText, 5, 4);
                        if AppraisalAttachment <> '' then begin
                            Rec.Validate("Appraisal Attachment", LoanMgt.UploadAppraisal(AppraisalText, AppraisalAttachment, AppraisalAttachmentExt));
                        end;
                    end;
                }
                field(Deputationon; Rec."Deputation on") { }
                field(FunctionalTitleDesc; Rec."Functional Title Desc") { }
                field(Hide; Rec.Hide) { }
                field(FinalGrading; Rec."Final Grading") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("Appraisal Code"),
                              "Employee Code" = field("Employee Code"),
                              "Table ID" = const(60058);
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        if Rec."Appraisal Attachment" <> '' then begin  //Min 6.17.2022
            AppraisalAttachmentExt := returnAppraisalAttachmentExtBase64(Rec."Appraisal Code");
            AppraisalAttachment := returnAppraisalAttachmentBase64(Rec."Appraisal Code");
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Requested;
    end;

    trigger OnOpenPage()
    begin
        //ERROR('Appraisal has been disabled for certain time.'); //Min
    end;

    var
        AppraisalAttachment: Text;
        AppraisalAttachmentExt: Text;
        AppraisalText: Text;
        LoanMgt: Codeunit "Loan Mgt.";
        FileManagement: Codeunit "File Management";

    procedure returnAppraisalAttachmentExtBase64(docNo: Code[20]): Text
    var
        AppraisalRec: Record Appraisal;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        AppraisalRec.Reset;
        if docNo <> '' then
            AppraisalRec.SetRange("Appraisal Code", docNo);
        if AppraisalRec.FindFirst then begin
            FileName := AppraisalRec."Appraisal Attachment";
            FileManagement.BLOBImport(TempBlob, FileName);
            AppraisalAttachmentExt := CopyStr(FileName, StrPos(FileName, '.') + 1, StrLen(FileName));
            exit(AppraisalAttachmentExt);
        end else
            exit('not found');
    end;

    procedure returnAppraisalAttachmentBase64(docNo: Code[20]): Text
    var
        AppraisalRec: Record Appraisal;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        Base64: Codeunit "Base64 Convert";
    begin
        AppraisalRec.Reset;
        if docNo <> '' then
            AppraisalRec.SetRange("Appraisal Code", docNo);
        if AppraisalRec.FindFirst then begin
            FileName := AppraisalRec."Appraisal Attachment";
            FileManagement.BLOBImport(TempBlob, FileName);
            exit(Base64.ToBase64(TempBlob.CreateInStream()));
        end else
            exit('not found');
    end;
}
