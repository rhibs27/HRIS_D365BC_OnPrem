page 50117 "Candidate List"
{
    // version HRM1.00

    CardPageId = "Candidate Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Shortlist,Send Letter,Accept Letter,Convert/Promote Employee';
    SourceTable = Candidate;
    SourceTableView = sorting("Avg. Inverview Score")
                      order(descending);
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field(Initials; Rec.Initials)
                {
                    ToolTip = 'Specifies the value of the Initials field.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                }
                field("Applied Salary Level"; Rec."Applied Salary Level")
                {
                    ToolTip = 'Specifies the value of the Applied Salary Level field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Candidate Type"; Rec."Candidate Type")
                {
                    ToolTip = 'Specifies the value of the Candidate Type field.';
                    ApplicationArea = All;
                }
                field("Permanent Address"; Rec."Permanent Address")
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    ApplicationArea = All;
                }
                field(Venue; Rec.Venue)
                {
                    ToolTip = 'Specifies the value of the Venue field.';
                    ApplicationArea = All;
                }
                field("Interviewer Count"; Rec."Interviewer Count")
                {
                    ToolTip = 'Specifies the value of the Interviewer Count field.';
                    ApplicationArea = All;
                }
                field("Interviewer 1"; Rec."Interviewer 1")
                {
                    ToolTip = 'Specifies the value of the Interviewer 1 field.';
                    ApplicationArea = All;
                }
                field("Interviewer 1 Remarks"; Rec."Interviewer 1 Remarks")
                {
                    ToolTip = 'Specifies the value of the Interviewer 1 Remarks field.';
                    ApplicationArea = All;
                }
                field("Interviewer 2"; Rec."Interviewer 2")
                {
                    ToolTip = 'Specifies the value of the Interviewer 2 field.';
                    ApplicationArea = All;
                }
                field("Interviewer 2 Remarks"; Rec."Interviewer 2 Remarks")
                {
                    ToolTip = 'Specifies the value of the Interviewer 2 Remarks field.';
                    ApplicationArea = All;
                }
                field("Interviewer 3"; Rec."Interviewer 3")
                {
                    ToolTip = 'Specifies the value of the Interviewer 3 field.';
                    ApplicationArea = All;
                }
                field("Interviewer 3 Remarks"; Rec."Interviewer 3 Remarks")
                {
                    ToolTip = 'Specifies the value of the Interviewer 3 Remarks field.';
                    ApplicationArea = All;
                }
                field("Interviewer 4"; Rec."Interviewer 4")
                {
                    ToolTip = 'Specifies the value of the Interviewer 4 field.';
                    ApplicationArea = All;
                }
                field("Interviewer 4 Remarks"; Rec."Interviewer 4 Remarks")
                {
                    ToolTip = 'Specifies the value of the Interviewer 4 Remarks field.';
                    ApplicationArea = All;
                }
                field("Interviewer 5"; Rec."Interviewer 5")
                {
                    ToolTip = 'Specifies the value of the Interviewer 5 field.';
                    ApplicationArea = All;
                }
                field("Interviewer 5 Remarks"; Rec."Interviewer 5 Remarks")
                {
                    ToolTip = 'Specifies the value of the Interviewer 5 Remarks field.';
                    ApplicationArea = All;
                }
                field("Avg. Inverview Score"; Rec."Avg. Inverview Score")
                {
                    ToolTip = 'Specifies the value of the Avg. Inverview Score field.';
                    ApplicationArea = All;
                }
                field("Written Score"; Rec."Written Score")
                {
                    ToolTip = 'Specifies the value of the Written Score field.';
                    ApplicationArea = All;
                }
                field("Total Marks"; Rec."Total Marks")
                {
                    ToolTip = 'Specifies the value of the Total Marks field.';
                    ApplicationArea = All;
                }
                field("Interview By"; Rec."Interview By")
                {
                    ToolTip = 'Specifies the value of the Interview By field.';
                    ApplicationArea = All;
                }
                field("Commercial Banking Experience"; Rec."Commercial Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Commercial Banking Experience field.';
                    ApplicationArea = All;
                }
                field("Development Banking Experience"; Rec."Development Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Development Banking Experience field.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.';
                    ApplicationArea = All;
                }
                field("Current Job Position"; Rec."Current Job Position")
                {
                    ToolTip = 'Specifies the value of the Current Job Position field.';
                    ApplicationArea = All;
                }
                field("Current Functional Title"; Rec."Current Functional Title")
                {
                    ToolTip = 'Specifies the value of the Current Functional Title field.';
                    ApplicationArea = All;
                }
                field("Non-Banking Experience"; Rec."Non-Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Non-Banking Experience field.';
                    ApplicationArea = All;
                }
                field("Total Banking Experience"; Rec."Total Banking Experience")
                {
                    ToolTip = 'Specifies the value of the Total Banking Experience field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(Shortlist)
            {
                action("Manual Screen")
                {
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Manual Screen action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to manual screen the selected candidate?') then begin
                            Vacancy.Get(Rec."Vacancy Code");
                            Candidate.Reset;
                            CurrPage.SetSelectionFilter(Candidate);
                            if Candidate.Find('-') then
                                repeat
                                    if Candidate."Candidate Type" = Candidate."Candidate Type"::Internal then
                                        Candidate.TestField(Status, Candidate.Status::Recommended)
                                    else
                                        Candidate.TestField(Status, Candidate.Status::"System Screeened");
                                    Candidate.Status := Candidate.Status::"Manual Shortlist";
                                    Candidate.Modify;
                                until Candidate.Next = 0;
                            Vacancy.Status := Vacancy.Status::"Manual Shortlist";
                            Vacancy.Modify;
                            Message('Manaully Screened.');
                        end;
                    end;
                }
                action("Recommend Candidate")
                {
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec.Status = Rec.Status::Applied;
                    ToolTip = 'Executes the Recommend Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to recommend this candidate?', false) then begin
                            HRMgt.RecommendCandidate(Rec, true);
                            Message('Recommended');
                        end;
                    end;
                }
                action("Reject Candidate")
                {
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec.Status = Rec.Status::Applied;
                    ToolTip = 'Executes the Reject Candidate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to recommend this candidate?', false) then begin
                            HRMgt.RecommendCandidate(Rec, false);
                            Message('Rejected');
                        end;
                    end;
                }
                action("Final Shorlist")
                {
                    Image = SuggestField;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Final Shorlist action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to final shorlist the selected candidates?', false) then begin
                            Candidate.Reset;
                            Candidate.SetFilter("Interviewer 1 Remarks", 'Recommended|Can be considered');
                            Candidate.SetFilter("Interviewer 2 Remarks", 'Recommended|Can be considered');
                            Candidate.SetFilter("Interviewer 3 Remarks", 'Recommended|Can be considered');
                            CurrPage.SetSelectionFilter(Candidate);
                            if Candidate.Find('-') then
                                repeat
                                    Candidate.TestField(Status, Candidate.Status::Interviewed);
                                    Candidate.Status := Candidate.Status::"Final Shortlisted";
                                    EvaluationEntry.Reset;
                                    EvaluationEntry.SetRange("No.", Candidate."No.");
                                    EvaluationEntry.ModifyAll(Posted, true);
                                    Candidate.Modify;
                                until Candidate.Next = 0;
                            Vacancy.Reset;
                            Vacancy.Get(Rec."Vacancy Code");
                            Vacancy.Status := Vacancy.Status::"Final Shortlisted";
                            Vacancy.Modify;
                            Message('shorlisted');
                        end;
                    end;
                }
            }
            group("Send Letter")
            {

                action("Send Email For Offer Letter")
                {
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Send Email For Offer Letter action.';
                    ApplicationArea = All;
                    Visible = Rec."Candidate Type" = Rec."Candidate Type"::External;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send offer to final shortlisted candidate?') then begin
                            //TestField(Status,Status::"Final Shortlisted");
                            Candidate.Reset;
                            Candidate.SetRange("Vacancy Code", Rec."Vacancy Code");
                            Candidate.SetRange(Status, Candidate.Status::"Final Shortlisted");
                            if Candidate.FindFirst then
                                repeat
                                    /*SendOfferLetter.ForOfferLetter;
                                    SendOfferLetter.SETTABLEVIEW(Candidate);
                                    SendOfferLetter.RUN;*/
                                    EmailMgt.SendEmailOfferLetter(Rec."No.", Candidate);
                                    Candidate.Validate(Status, Candidate.Status::"Offer Letter Sent");
                                    Candidate.Modify;
                                until Candidate.Next = 0;
                            Message('Offer letter has been sent to shortlisted candidates.');
                        end;
                    end;
                }
                action("Send Offer Letter")
                {
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Send Offer Letter action.';
                    ApplicationArea = All;
                    // Visible = Rec."Candidate Type" = Rec."Candidate Type"::External;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send offer to final shortlisted candidate?') then begin
                            //TestField(Status,Status::"Final Shortlisted");
                            Candidate.Reset;
                            Candidate.SetRange("Vacancy Code", Rec."Vacancy Code");
                            Candidate.SetRange(Status, Candidate.Status::"Final Shortlisted");
                            if Candidate.FindFirst then
                                repeat
                                    /*SendOfferLetter.ForOfferLetter;
                                    SendOfferLetter.SETTABLEVIEW(Candidate);
                                    SendOfferLetter.RUN;*/
                                    EmailMgt.SendOfferLetter(Rec."No.", Candidate);
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
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    //Visible = false;
                    ToolTip = 'Executes the Send Appointment Letter action.';
                    ApplicationArea = All;
                    Visible = Rec."Candidate Type" = Rec."Candidate Type"::External;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send appointment to final shortlisted candidate?') then begin
                            //TestField(Status,Status::"Final Shortlisted");
                            Candidate.Reset;
                            Candidate.SetRange("Vacancy Code", Rec."Vacancy Code");
                            Candidate.SetRange(Status, Candidate.Status::"Offer Letter Accepted");
                            if Candidate.FindFirst then
                                repeat
                                    /*SendOfferLetter.ForOfferLetter;
                                    SendOfferLetter.SETTABLEVIEW(Candidate);
                                    SendOfferLetter.RUN;*/
                                    EmailMgt.SendAppointmentLetter(Rec."No.", Candidate);
                                    Candidate.Validate(Status, Candidate.Status::"Appointment Letter Sent");
                                    Candidate.Modify;
                                until Candidate.Next = 0;
                            Message('Appointment letter has been sent to shortlisted candidates.');
                        end;
                    end;
                }
            }
            group("Letter Accepted")
            {

                action("Offer Letter Accepted")
                {
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Offer Letter Accepted action.';
                    ApplicationArea = All;
                    Visible = Rec."Candidate Type" = Rec."Candidate Type"::External;

                    trigger OnAction()
                    begin
                        if Confirm('Did the candidate accepted offer letter?', false) then begin
                            Rec.TestField(Status, Rec.Status::"Offer Letter Sent");
                            Rec.Status := Rec.Status::"Offer Letter Accepted";
                            Rec.Modify;
                        end;
                    end;
                }
                action("Offer Appointement Accepted")
                {
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Offer Appointement Accepted action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Did the candidate accepted appointment letter?', false) then begin
                            Rec.TestField(Status, Rec.Status::"Appointment Letter Sent");
                            Rec.Status := Rec.Status::"Converted To Employee";
                            Rec.Modify;
                        end;
                    end;
                }
            }
            group("Convert/Promote Employee")
            {
                action("Convert To Employee")
                {
                    Image = AddContacts;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec."Candidate Type" = Rec."Candidate Type"::External;
                    ToolTip = 'Executes the Convert To Employee action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ConvertToEmployee;
                    end;
                }
                action(Promote)
                {
                    Image = Production;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = Rec."Candidate Type" = Rec."Candidate Type"::Internal;
                    ToolTip = 'Executes the Promote action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to promote the employee', false) then begin
                            HRMgt.PromoteEmployee(Rec."No.", Rec."Vacancy Code");
                        end;
                    end;
                }
                action(Offer_Letter)
                {
                    Caption = 'Offer Letter';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = Rec."Candidate Type" = Rec."Candidate Type"::External;
                    ToolTip = 'Executes the Offer Letter action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CandidateRec: Record Candidate;
                    begin
                        CandidateRec.Reset;
                        CandidateRec.SetRange("No.", Rec."No.");
                        if CandidateRec.FindFirst then
                            Report.Run(70028, true, false, CandidateRec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //SelectFinalCandidates;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Applied;
    end;

    var
        Candidate: Record Candidate;
        Vacancy: Record "Vacancy Header";
        HRMgt: Codeunit "HR Mgt.";
        EmailMgt: Codeunit "Email Mgt";
        EvaluationEntry: Record "Evaluation Entry";
}
