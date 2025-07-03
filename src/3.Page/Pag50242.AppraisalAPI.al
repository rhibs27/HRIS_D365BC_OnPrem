page 50242 "Appraisal API"
{

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
                field(appraisalCode; Rec."Appraisal Code") { }
                field(employeeCode; Rec."Employee Code") { }
                field(employeeName; Rec."Employee Name") { }
                field(dateOfEmployement; Rec."Date of Employement") { }
                field(appraisalType; Rec."Appraisal Type") { }
                field(finalScore; Rec."Final Score") { }
                field(finalGrade; Rec."Final Grade") { }
                field(reviewer; Rec.Reviewer) { }
                field(checkReviewer; Rec."Check Reviewer") { }
                field(reviewerIII; Rec."Reviewer III") { }
                field(postingDate; Rec."Posting Date") { }
                field(reviewedScoreI; Rec."Reviewed Score I") { }
                field(reviewedScoreII; Rec."Reviewed Score II") { }
                field(reviewedScoreIII; Rec."Reviewed Score III") { }
                field(department; Rec.Department) { }
                field(functionalTitle; Rec."Functional Title") { }
                field(code; Rec.Code) { }
                field(jobGrade; Rec."Job Grade") { }
                field(totalTenureInBank; Rec."Total Tenure in Bank") { }
                field(submissionDate; Rec."Submission Date") { }
                field(reviewedDateI; Rec."Reviewed Date I") { }
                field(reviewedDateII; Rec."Reviewed Date II") { }
                field(reviewedDateIII; Rec."Reviewed Date III") { }
                field(totalTenureInCrcPosition; Rec."Total Tenure in Crc Position") { }
                field(branch; Rec.Branch) { }
                field(branchName; Rec."Branch Name") { }
                field(posted; Rec.Posted) { }
                field(noSeries; Rec."No. Series") { }
                field(KRACategory; Rec."KRA Category") { }
                field(approvedDate; Rec."Approved Date") { }
                field(rating; Rec.Rating) { }
                field(status; Rec.Status) { }
                field(academicDegree; Rec."Academic Degree") { }
                field(writtenVerbalWarningIssued; Rec."Written Verbal Warning Issued") { }
                field(completionOfTraining; Rec."Completion of Training") { }
                field(disciplinaryActionsTaken; Rec."Disciplinary Actions Taken") { }
                field(commendationsOnFile; Rec."Commendations on File") { }
                field(frequentUntidyUniform; Rec."Frequent Untidy Uniform") { }
                field(uninformedAbsence; Rec."Uninformed Absence") { }
                field(noOfSickLeavesTaken; Rec."No of Sick Leaves Taken") { }
                field(developmentPlanRemarks; Rec."Development Plan Remarks") { }
                field(improvementTime; Rec."Improvement Time") { }
                field(reporteesComments; Rec."Reportees Comments") { }
                field(salesAndMarketingCorporate; Rec."Sales and Marketing Corporate") { }
                field(salesAndMarketingRetail; Rec."Sales and Marketing Retail") { }
                field(operations; Rec.Operations) { }
                field(financeOrAccounts; Rec."Finance or Accounts") { }
                field(administration; Rec.Administration) { }
                field(backOffice; Rec."Back Office") { }
                field(humanResource; Rec."Human Resource") { }
                field(reviewerComments; Rec."Reviewer Comments") { }
                field(checkReviewersComments; Rec."Check Reviewers Comments") { }
                field(userID; Rec."User ID") { }
                field(recommenderCode; Rec."Recommender Code") { }
                field(approverCode; Rec."Approver Code") { }
                field(recommenderName; Rec."Recommender Name") { }
                field(approverName; Rec."Approver Name") { }
                field(requestedDate; Rec."Requested Date") { }
                field(appraisalSubtypeMonthly; Rec."Appraisal Subtype Monthly") { }
                field(appraisalSubtypeQuarterly; Rec."Appraisal Subtype Quarterly") { }
                field(appraisalAttachmentExt; AppraisalAttachmentExt) { }
                field(appraisalAttachment; AppraisalAttachment)
                {
                    trigger OnValidate()
                    begin
                        if Rec."Appraisal Attachment" <> '' then
                            Clear(Rec."Appraisal Attachment");
                        AppraisalText := CreateGuid; //Min 6.25.2022
                        AppraisalText := DelChr(AppraisalText, '=', '{}-01');
                        AppraisalText := CopyStr(AppraisalText, 5, 4);
                        if AppraisalAttachment <> '' then begin
                            // Rec.Validate("Appraisal Attachment", AttachmentMgt.UploadAppraisal(AppraisalText, AppraisalAttachment, AppraisalAttachmentExt));
                        end;
                    end;
                }
                field(deputationOn; Rec."Deputation on") { }
                field(functionalTitleDesc; Rec."Functional Title Desc") { }
                field(hide; Rec.Hide) { }
                field(finalGrading; Rec."Final Grading") { }
            }
            part(attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("Appraisal Code"),
                              "Employee Code" = field("Employee Code");
                //"Table ID" = const(60058)
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
        AttachmentMgt: Codeunit "Attachment Mgt.";
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
