page 50123 "Posted Vacancy List"
{
    // version HRM1.00

    CardPageId = "Vacancy Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Candidate,Screen,Show Attribute Entries,Candidate Evaluation,Send Mails,Selection';
    SourceTable = "Vacancy Header";
    SourceTableView = where(Posted = const(true));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.';
                    ApplicationArea = All;
                }
                field("Date of Request"; Rec."Date of Request")
                {
                    ToolTip = 'Specifies the value of the Date of Request field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Requestor Employee Code"; Rec."Requestor Employee Code")
                {
                    ToolTip = 'Specifies the value of the Requestor Employee Code field.';
                    ApplicationArea = All;
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ToolTip = 'Specifies the value of the Requestor Name field.';
                    ApplicationArea = All;
                }
                field("Requestor Designation"; Rec."Requestor Designation")
                {
                    ToolTip = 'Specifies the value of the Requestor Designation field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Position to be filled field.';
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.';
                    ApplicationArea = All;
                }
                field("New Position"; Rec."New Position")
                {
                    ToolTip = 'Specifies the value of the New Position field.';
                    ApplicationArea = All;
                }
                field("Budget Salary / CTC"; Rec."Budget Salary / CTC")
                {
                    ToolTip = 'Specifies the value of the Budget Salary / CTC field.';
                    ApplicationArea = All;
                }
                field("Existing Salary"; Rec."Existing Salary")
                {
                    ToolTip = 'Specifies the value of the Existing Salary field.';
                    ApplicationArea = All;
                }
                field("New Position Salary"; Rec."New Position Salary")
                {
                    ToolTip = 'Specifies the value of the New Position Salary field.';
                    ApplicationArea = All;
                }
                field("Internal Candidate Identified"; Rec."Internal Candidate Identified")
                {
                    ToolTip = 'Specifies the value of the Internal Candidate Identified field.';
                    ApplicationArea = All;
                }
                field("Internal Candidate Code"; Rec."Internal Candidate Code")
                {
                    ToolTip = 'Specifies the value of the Internal Candidate Code field.';
                    ApplicationArea = All;
                }
                field("Internal Candidate Name"; Rec."Internal Candidate Name")
                {
                    ToolTip = 'Specifies the value of the Internal Candidate Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(Candidate)
            {
                action("Show Candidate List")
                {
                    Image = ShowSelected;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Show Candidate List action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ShowCandidateList(Rec."No.");
                    end;
                }
                action("Update Interview By")
                {
                    Image = ShowSelected;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Update Interview By action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Clear(EvaluationEntry); //Min
                        EvaluationEntry.SetRange("Attribute Code", 'APTITUDE');
                        EvaluationEntry.SetRange("Vacancy Code", 'VACANCY0005');
                        EvaluationEntry.SetRange(Posted, true);
                        EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
                        if EvaluationEntry.Find('-') then
                            repeat
                                CandidateRec.Reset;
                                CandidateRec.SetRange("Vacancy Code", EvaluationEntry."Vacancy Code");
                                CandidateRec.SetFilter(Status, '%1|%2', CandidateRec.Status::"Interview Scheduled", CandidateRec.Status::Interviewed);
                                if CandidateRec.Find('-') then
                                    repeat
                                        if CandidateRec."Interview By" = '' then
                                            CandidateRec."Interview By" := EvaluationEntry."Interviewer Code"
                                        else
                                            CandidateRec."Interview By" += '|' + EvaluationEntry."Interviewer Code";
                                        CandidateRec.Modify;
                                    until CandidateRec.Next = 0;
                            until EvaluationEntry.Next = 0;
                        Message('Done');
                    end;
                }
            }
            group(Screen)
            {
                action("System Screen")
                {
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec.Type = Rec.Type::External;
                    ToolTip = 'Executes the System Screen action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do your want the system to screen candidates?', false) then
                            HRMgt.SystemScreen(Rec."No.");
                    end;
                }
                action("Manual Screen")
                {
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Manual Screen action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::released);
                        if Rec.Type = Rec.Type::External then
                            Rec.TestField(Status, Rec.Status::"System Screened")
                        else
                            Rec.TestField(Status, Rec.Status::Applied);
                        Candidate.Reset;
                        Candidate.SetRange("Vacancy Code", Rec."No.");
                        if Rec.Type = Rec.Type::External then
                            Candidate.SetRange(Status, Candidate.Status::"System Screeened")
                        else
                            Candidate.SetRange(Status, Candidate.Status::Recommended);
                        if Page.RunModal(Page::"Candidate List", Candidate) = Action::OK then;
                    end;
                }
                action("Shortlist via marks")
                {
                    Image = ShowSelected;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Shortlist via marks action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ShortlistViaWrittenExam(Rec."No.");
                    end;
                }
            }
            group("Show Evaluation Entries")
            {
                action("Show Written Exam Entries")
                {
                    Image = WIPEntries;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Show Written Exam Entries action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ShowWrittenExamEntries(Rec."No.", '');
                    end;
                }
                action("Show Group Discussion Entires")
                {
                    Image = WIPEntries;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Show Group Discussion Entires action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ShowGroupDiscussionEntries(Rec."No.", '');
                    end;
                }
                action("Show Interview Entries")
                {
                    Image = LotInfo;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Show Interview Entries action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ShowInterviewerEntries(Rec."No.", '');
                    end;
                }
            }
            group("Candidate Evaluation")
            {
                action("Calculate Candidate Marks")
                {
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Calculate Candidate Marks action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.CalculateCandidateTotalMarks(Rec."No.");
                    end;
                }
                action("Generate Interviewed Candidate")
                {
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Generate Interviewed Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to generate interviewed candiddate?', false) then begin
                            HRMgt.GenerateInterviewedCandidate(Rec."No.");
                            Message('Candidated Generated.');
                        end;
                    end;
                }
                action("Create Interview Schedule")
                {
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Create Interview Schedule action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CreateInterviewSchedule(false);
                    end;
                }
                action("Reschedule Interview")
                {
                    ToolTip = 'Executes the Reschedule Interview action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CreateInterviewSchedule(true);
                    end;
                }
            }
            group("Send Mails")
            {
                action("Send Sch. Mail to Candidate")
                {
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Sch. Mail to Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send mail interview schedule email to candidates?', false) then
                            HRMgt.InterviewScheduleEmailToCandidate(Rec."No.", false);
                    end;
                }
                action("Send Sch. Mail to Interviewers ")
                {
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Send Sch. Mail to Interviewers  action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send mail interview schedule email to interview?', false) then
                            HRMgt.CandidateListmailToInterviewer(Rec."No.", false);
                    end;
                }
            }
            group(Selection)
            {
                action("Interviewed Candidate")
                {
                    Image = SuggestField;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Interviewed Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::released);
                        Rec.TestField(Status, Rec.Status::Interviewed);
                        Candidate.Reset;
                        Candidate.SetRange("Vacancy Code", Rec."No.");
                        Candidate.SetRange(Status, Candidate.Status::Interviewed);
                        if Page.RunModal(Page::"Candidate List", Candidate) = Action::OK then;
                    end;
                }
                action("Offer Letter Send Candidate")
                {
                    Image = SuggestField;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec.Type = Rec.Type::External;
                    ToolTip = 'Executes the Offer Letter Send Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::released);
                        Candidate.Reset;
                        Candidate.SetRange("Vacancy Code", Rec."No.");
                        Candidate.SetRange(Status, Candidate.Status::"Offer Letter Sent");
                        if Page.RunModal(Page::"Candidate List", Candidate) = Action::OK then;
                    end;
                }
                action("Offer Letter Accepted Candidate")
                {
                    Image = SuggestField;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec.Type = Rec.Type::External;
                    ToolTip = 'Executes the Offer Letter Accepted Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::released);
                        Candidate.Reset;
                        Candidate.SetRange("Vacancy Code", Rec."No.");
                        Candidate.SetRange(Status, Candidate.Status::"Offer Letter Accepted");
                        if Page.RunModal(Page::"Candidate List", Candidate) = Action::OK then;
                    end;
                }
                action("Appointment Letter Sent")
                {
                    Caption = 'Appointment Letter Sent Candidate';
                    Image = SuggestField;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Appointment Letter Sent Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::released);
                        Candidate.Reset;
                        Candidate.SetRange("Vacancy Code", Rec."No.");
                        Candidate.SetRange(Status, Candidate.Status::"Appointment Letter Sent");
                        if Page.RunModal(Page::"Candidate List", Candidate) = Action::OK then;
                    end;
                }
                action("Send Offer Letter")
                {
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Send Offer Letter action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send offer to final shortlisted candidate?') then begin
                            Rec.TestField(Status, Rec.Status::"Final Shortlisted");
                            Candidate.Reset;
                            Candidate.SetRange("Vacancy Code", Rec."No.");
                            Candidate.SetRange(Status, Candidate.Status::Eligible);
                            if Candidate.FindFirst then
                                repeat
                                    /*SendOfferLetter.ForOfferLetter;
                                    SendOfferLetter.SETTABLEVIEW(Candidate);
                                    SendOfferLetter.RUN;*/
                                    HRMgt.SendOfferLetter(Rec."No.", Candidate);
                                    Candidate.Validate(Status, Candidate.Status::"Offer Letter Sent");
                                    Candidate.Modify;
                                until Candidate.Next = 0;
                            Message('Offer letter has been sent to shortlisted candidates.');
                        end;
                    end;
                }
                action("Send Appointment Letter")
                {
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Send Appointment Letter action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send appointment letter to the candidate?') then begin
                            Candidate.Reset;
                            Candidate.SetRange("Vacancy Code", Rec."No.");
                            Candidate.SetRange(Status, Candidate.Status::"Offer Letter Accepted");
                            if Candidate.FindFirst then begin
                                /*SendOfferLetter.ForAppointmentLetter;
                                SendOfferLetter.SETTABLEVIEW(Candidate);
                                SendOfferLetter.RUN;*/
                                HRMgt.SendAppointmentLetter(Rec."No.", Candidate);
                                Candidate.Validate(Status, Candidate.Status::"Appointment Letter Sent");
                                Candidate.Modify;
                            end;
                            Message('Appointment letter has been sent to candidates.');
                        end;
                    end;
                }
                action("Export Candidate List")
                {
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    // Visible = false;
                    ToolTip = 'Executes the Export Candidate List action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you export the candidate list', false) then
                            HRMgt.ExportCandidateXML(Rec."No.");
                    end;
                }
                action("Import Candidate List")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    // Visible = false;
                    ToolTip = 'Executes the Import Candidate List action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you import the candidate list?', false) then
                            HRMgt.ImportCandidateXML(Rec."No.");
                    end;
                }
                action("Generate Employee Candidate")
                {
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec.Type = Rec.Type::Internal;
                    ToolTip = 'Executes the Generate Employee Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to generate the candidate for vacacny No. %1?', false, Rec."No.") then begin
                            HRMgt.SelectEligibleEmployee(Rec."No.");
                            Message('The candidates have been generated.');
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        SetVisibility;
    end;

    var
        StyleTxt: Text;
        HRMgt: Codeunit "HR Mgt.";

        IsGroupDiscussion: Boolean;

        IsWrittenExam: Boolean;
        Candidate: Record Candidate;
        ScheduleInterview: Report "Generate Can Schedule";
        FunctionalTitle: Record "Functional Title";
        EvaluationEntry: Record "Evaluation Entry";
        CandidateRec: Record Candidate;

    local procedure SetVisibility()
    var
        FunctionalTitle: Record "Functional Title";
    begin
        if FunctionalTitle.Get(Rec."Functional Title") then begin
            IsGroupDiscussion := FunctionalTitle."Group Discussion";
            IsWrittenExam := FunctionalTitle."Written Exam";
        end;
    end;

    procedure CreateInterviewSchedule(Reshedule: Boolean)
    begin
        Candidate.Reset;
        //TESTFIELD("Functional Title");
        if FunctionalTitle.Get(Rec."Functional Title") then;
        Candidate.SetRange("Vacancy Code", Rec."No.");
        if FunctionalTitle."Written Exam" then
            Candidate.SetRange(Status, Candidate.Status::"Written/GD Passed")
        else
            Candidate.SetRange(Status, Candidate.Status::"Manual Shortlist");
        Clear(ScheduleInterview);
        ScheduleInterview.GetVacancyNo(Rec."No.");
        if Reshedule then
            ScheduleInterview.IsReschedule();
        ScheduleInterview.SetTableView(Candidate);
        ScheduleInterview.Run;
    end;
}
