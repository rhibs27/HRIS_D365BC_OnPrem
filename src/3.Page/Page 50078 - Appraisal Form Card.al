page 50078 "Appraisal Form Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Appraisal;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = Rec.Status = Rec.Status::" ";
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Date of Employement"; Rec."Date of Employement")
                {
                    ToolTip = 'Specifies the value of the Date of Employement field.';
                    ApplicationArea = All;
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetLayout;
                    end;
                }
                field("Appraisal Subtype Monthly"; Rec."Appraisal Subtype Monthly")
                {
                    Editable = FieldEditable1;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Monthly field.';
                    ApplicationArea = All;
                }
                field("Appraisal Subtype Quarterly"; Rec."Appraisal Subtype Quarterly")
                {
                    Editable = FieldEditable2;
                    ToolTip = 'Specifies the value of the Appraisal Subtype Quarterly field.';
                    ApplicationArea = All;
                }
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field("Deputation on"; Rec."Deputation on")
                {
                    ToolTip = 'Specifies the value of the Deputation on field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field("Sub-Province Name"; Rec."Sub-Province Name")
                {
                    ToolTip = 'Specifies the value of the Sub-Province Name field.';
                    ApplicationArea = All;
                }
                field("Extension Counter Name"; Rec."Extension Counter Name")
                {
                    ToolTip = 'Specifies the value of the Extension Counter Name field.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ToolTip = 'Specifies the value of the Unit Name field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field(Reviewer; Rec.Reviewer)
                {
                    Caption = 'Reviewer';
                    ToolTip = 'Specifies the value of the Reviewer field.';
                    ApplicationArea = All;
                }
                field("Check Reviewer"; Rec."Check Reviewer")
                {
                    Caption = 'Check Reviewer';
                    ToolTip = 'Specifies the value of the Check Reviewer field.';
                    ApplicationArea = All;
                }
                field("Total Final Score"; Rec."Total Final Score")
                {
                    ToolTip = 'Specifies the value of the Total Final Score field.';
                    ApplicationArea = All;
                }
                field("Total Reviewers Score"; Rec."Total Reviewers Score")
                {
                    ToolTip = 'Specifies the value of the Total Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Total Check Reviewers Score"; Rec."Total Check Reviewers Score")
                {
                    ToolTip = 'Specifies the value of the Total Check Reviewers Score field.';
                    ApplicationArea = All;
                }
                field("Final Grading"; Rec."Final Grading")
                {
                    ToolTip = 'Specifies the value of the Final Grading field.';
                    ApplicationArea = All;
                }
                field("Confirmation Eligible"; Rec."Confirmation Eligible")
                {
                    ToolTip = 'Specifies the value of the Confirmation Eligible field.';
                    ApplicationArea = All;
                }
                field("Appraisal Attachment"; Rec."Appraisal Attachment")
                {
                    ToolTip = 'Specifies the value of the Appraisal Attachment field.';
                    ApplicationArea = All;
                }
                field("Sol Id"; Rec."Sol Id")
                {
                    ToolTip = 'Specifies the value of the Sol Id field.';
                    ApplicationArea = All;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.';
                    ApplicationArea = All;
                }
            }
            group("Appraisal's Details")
            {
                Visible = false;
                field("Reviewer III"; Rec."Reviewer III")
                {
                    ToolTip = 'Specifies the value of the Reviewer III field.';
                    ApplicationArea = All;
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    Caption = 'Initiator Performance Appraisal Submission Date';
                    ToolTip = 'Specifies the value of the Initiator Performance Appraisal Submission Date field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
            }
            part(Control24; "KRA Subform")
            {
                SubPageLink = "Appraisal Code" = field("Appraisal Code"),
                              "Employee Code" = field("Employee Code"),
                              "KRA Category" = field("KRA Category");
                Visible = FieldVisible;
                ApplicationArea = All;
            }
            group(Total)
            {
                Caption = 'Total';
                Visible = FieldVisible;
                field("Final Score"; Rec."Final Score")
                {
                    ToolTip = 'Specifies the value of the Final Score field.';
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ToolTip = 'Specifies the value of the Rating field.';
                    ApplicationArea = All;
                }
            }
            group("Other Information")
            {
                Caption = 'Other Information';
                Visible = FieldVisible;
                field("Academic Degree"; Rec."Academic Degree")
                {
                    Caption = 'Acquisition of an Acedemic Degree';
                    ToolTip = 'Specifies the value of the Acquisition of an Acedemic Degree field.';
                    ApplicationArea = All;
                }
                field("Written Verbal Warning Issued"; Rec."Written Verbal Warning Issued")
                {
                    Caption = 'Written/verbal warning issued';
                    ToolTip = 'Specifies the value of the Written/verbal warning issued field.';
                    ApplicationArea = All;
                }
                field("Completion of Training"; Rec."Completion of Training")
                {
                    Caption = 'Successful completion of job-related training';
                    ToolTip = 'Specifies the value of the Successful completion of job-related training field.';
                    ApplicationArea = All;
                }
                field("Disciplinary Actions Taken"; Rec."Disciplinary Actions Taken")
                {
                    Caption = 'Disciplinary Action(s) taken';
                    ToolTip = 'Specifies the value of the Disciplinary Action(s) taken field.';
                    ApplicationArea = All;
                }
                field("Commendations on File"; Rec."Commendations on File")
                {
                    Caption = 'Any commendations on file';
                    ToolTip = 'Specifies the value of the Any commendations on file field.';
                    ApplicationArea = All;
                }
                field("Frequent Untidy Uniform"; Rec."Frequent Untidy Uniform")
                {
                    Caption = 'Frequent untidy uniform';
                    ToolTip = 'Specifies the value of the Frequent untidy uniform field.';
                    ApplicationArea = All;
                }
                field("Uninformed Absence"; Rec."Uninformed Absence")
                {
                    Caption = 'Absence without information/ authorization and habitual tardiness';
                    ToolTip = 'Specifies the value of the Absence without information/ authorization and habitual tardiness field.';
                    ApplicationArea = All;
                }
                field("No of Sick Leaves Taken"; Rec."No of Sick Leaves Taken")
                {
                    Caption = 'No of day''s sick leave taken';
                    ToolTip = 'Specifies the value of the No of day''s sick leave taken field.';
                    ApplicationArea = All;
                }
            }
            group("Development Plan")
            {
                Caption = 'Development Plan';
                Visible = FieldVisible;
                field("Improvement Time"; Rec."Improvement Time")
                {
                    Caption = 'Time set for improvement to take place (in months)';
                    ToolTip = 'Specifies the value of the Time set for improvement to take place (in months) field.';
                    ApplicationArea = All;
                }
                field("Development Plan Remarks"; Rec."Development Plan Remarks")
                {
                    Caption = 'Remarks';
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
            group("Reportee's Comments")
            {
                Caption = 'Reportee''s Comments';
                Visible = FieldVisible;
                field("Reportees Comments"; Rec."Reportees Comments")
                {
                    Caption = 'Whether the reportee considers this report a fair performance assessment.';
                    ToolTip = 'Specifies the value of the Whether the reportee considers this report a fair performance assessment. field.';
                    ApplicationArea = All;
                }
            }
            group("Assessment of Potential")
            {
                Caption = 'Assessment of Potential';
                Visible = FieldVisible;
                field("Sales and Marketing Corporate"; Rec."Sales and Marketing Corporate")
                {
                    ToolTip = 'Specifies the value of the Sales and Marketing Corporate field.';
                    ApplicationArea = All;
                }
                field("Sales and Marketing Retail"; Rec."Sales and Marketing Retail")
                {
                    ToolTip = 'Specifies the value of the Sales and Marketing Retail field.';
                    ApplicationArea = All;
                }
                field(Operations; Rec.Operations)
                {
                    ToolTip = 'Specifies the value of the Operations field.';
                    ApplicationArea = All;
                }
                field("Finance or Accounts"; Rec."Finance or Accounts")
                {
                    ToolTip = 'Specifies the value of the Finance or Accounts field.';
                    ApplicationArea = All;
                }
                field(Administration; Rec.Administration)
                {
                    ToolTip = 'Specifies the value of the Administration field.';
                    ApplicationArea = All;
                }
                field("Back Office"; Rec."Back Office")
                {
                    ToolTip = 'Specifies the value of the Back Office field.';
                    ApplicationArea = All;
                }
                field("Human Resource"; Rec."Human Resource")
                {
                    ToolTip = 'Specifies the value of the Human Resource field.';
                    ApplicationArea = All;
                }
            }
            group("Reviewer's Comments")
            {
                Caption = 'Reviewer''s Comments';
                Visible = FieldVisible;
                field("Reviewer Comments"; Rec."Reviewer Comments")
                {
                    Caption = 'Comments of Report Officers Reviewer';
                    ToolTip = 'Specifies the value of the Comments of Report Officers Reviewer field.';
                    ApplicationArea = All;
                }
            }
            group("Check Reviewer's Comments")
            {
                Caption = 'Check Reviewer''s Comments';
                Visible = FieldVisible;
                field("Check Reviewers Comments"; Rec."Check Reviewers Comments")
                {
                    Caption = 'Comments of Report Officers Check Review';
                    ToolTip = 'Specifies the value of the Comments of Report Officers Check Review field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Post)
            {
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Post action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //HRMgt.CalcExtendDays(Rec,TRUE);
                    Appraisal.Reset;
                    Appraisal.SetRange("Appraisal Code", Rec."Appraisal Code");
                    if Appraisal.FindFirst then
                        repeat
                            Appraisal.Posted := true;
                            Appraisal."Posting Date" := Today;
                        until Appraisal.Next = 0;

                    CurrPage.Close;
                end;
            }
            action(ReOpen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the ReOpen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //HRMgt.CalcExtendDays(Rec,FALSE);
                    Appraisal.Reset;
                    Appraisal.SetRange("Appraisal Code", Rec."Appraisal Code");
                    if Appraisal.FindFirst then
                        repeat
                            Appraisal.Posted := false;
                            Appraisal."Posting Date" := 0D;
                        until Appraisal.Next = 0;
                    CurrPage.Close;
                end;
            }
            action("Request Appraisal")
            {
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Request Appraisal action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to send appraisal request?', false) then
                        exit;
                    Rec.TestField("Appraisal Type");
                    Rec.TestField(Status, Rec.Status::" ");
                    if Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly then
                        Rec.TestField("Appraisal Subtype Monthly")
                    else if Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly then
                        Rec.TestField("Appraisal Subtype Quarterly");
                    Rec.TestField("KRA Category");
                    Rec.TestField(Reviewer);
                    Rec.TestField("Check Reviewer");
                    Rec.Validate(Status, Rec.Status::Requested);
                    Message('Appraisal Request submitted.');
                end;
            }
            action("Cancel Appraisal Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Appraisal Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    AppraisalMgt.CancelAppraisalApproval(Rec);
                end;
            }
            action("Send Review Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Submitted;
                ToolTip = 'Executes the Send Review Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
            action("Approve Review")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec.Status = Rec.Status::Requested;
                ToolTip = 'Executes the Approve Review action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    AppraisalMgt.ApproveRejectAppraisal(true, Rec);
                end;
            }
            action("Send Check Review Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ReviewSent;
                ToolTip = 'Executes the Send Check Review Request action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    AppraisalMgt.AppraisalEmail(Rec."Appraisal Code", Rec."Check Reviewer");
                    CurrPage.Close();
                end;
            }
            action("Approve Check Review")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec.Status = Rec.Status::Reviewed;
                ToolTip = 'Executes the Approve Check Review action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    AppraisalMgt.ApproveRejectAppraisal(true, Rec);
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApprovalSent;
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    KRASubFormRec.Reset;
                    KRASubFormRec.SetRange("Appraisal Code", Rec."Appraisal Code");
                    KRASubFormRec.SetRange("Employee Code", Rec."Employee Code");
                    if KRASubFormRec.FindFirst then
                        repeat
                            KRASubFormRec.TestField(Remarks);
                        until KRASubFormRec.Next = 0;
                    AppraisalMgt.AppraisalEmail(Rec."Appraisal Code", Rec."Approver Code");
                    CurrPage.Close();
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CheckReviewSent;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    RatingSetup: Record "Rating Setup";
                begin
                    AppraisalMgt.ApproveRejectAppraisal(true, Rec);
                    RatingSetup.Reset;
                    RatingSetup.SetRange(Type, RatingSetup.Type::Appraisal);
                    RatingSetup.SetFilter(From, '<=%1', Rec."Final Score");
                    RatingSetup.SetFilter("To", '>=%1', Rec."Final Score");
                    if RatingSetup.FindFirst then
                        Rec.Validate(Rating, RatingSetup.Remarks);
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CheckReviewSent;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    AppraisalMgt.ApproveRejectAppraisal(false, Rec);
                end;
            }
            action("Calculate Final Marks")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Calculate Final Marks action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to calculate marks?', false) then
                        AppraisalMgt.CalculateFinalScore(Rec);
                end;
            }
            action("Download Appraisal Attachment")
            {
                Image = Document;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Download Appraisal Attachment action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.DownloadAttachment(Rec."Appraisal Attachment");
                end;
            }
            action("Change Reviewer / Check Reviewer")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Change Reviewer / Check Reviewer action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ChangeReviewerCheckReviewerAppraisal;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        //IF Posted THEN
        // CurrPage.EDITABLE(FALSE);
        if not (Rec.Status = Rec.Status::" ") then
            FieldVisible := true
        else
            FieldVisible := false;
        SetLayout();
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        AppraisalMgt: Codeunit "AppraisalMgt.";
        KRASubFormRec: Record "KRA Subform List";
        Appraisal: Record Appraisal;
        FieldVisible: Boolean;
        Submitted: Boolean;
        [InDataSet]
        DocumentEditable: Boolean;
        CheckReviewSent: Boolean;
        ReviewSent: Boolean;
        ApprovalSent: Boolean;
        RecommendationSent: Boolean;
        FieldEditable1: Boolean;
        FieldEditable2: Boolean;

    local procedure SetLayout()
    begin
        Submitted := Rec.Status in [Rec.Status::Submitted];
        ReviewSent := Rec.Status in [Rec.Status::Reviewed];
        CheckReviewSent := Rec.Status in [Rec.Status::"Check Reviewed"];
        ApprovalSent := Rec.Status in [Rec.Status::Approved];
        DocumentEditable := Rec.Status in [Rec.Status::Requested, Rec.Status::" "];
        RecommendationSent := Rec.Status in [Rec.Status::Recommended];
        FieldEditable1 := Rec."Appraisal Type" = Rec."Appraisal Type"::Monthly;
        FieldEditable2 := Rec."Appraisal Type" = Rec."Appraisal Type"::Quarterly;
    end;
}
