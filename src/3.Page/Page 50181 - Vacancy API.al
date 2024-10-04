page 50181 "Vacancy API"
{
    // version HRM1.00,APINICASIA1.00

    EntityName = 'vacancyEntity';
    EntitySetName = 'vacancyEntities';
    InsertAllowed = false;
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Vacancy Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = not IsPosted;
                field(No; Rec."No.")
                {
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description) { }
                field(ReferenceNo; Rec."Reference No.") { }
                field(Type; Rec.Type) { }
                field(DateofRequest; Rec."Date of Request") { }
                field(FunctionalTitle; Rec."Functional Title")
                {
                    Visible = not ShowForInternal;
                }
                field(Location; Rec.Location) { }
                field(BudgetSalaryCTC; Rec."Budget Salary / CTC") { }
                field(ApprovalStatus; Rec."Approval Status")
                {
                    Editable = false;
                }
                field(ApprovedDate; Rec."Approved Date") { }
                field(SalaryLevelCode; Rec."Salary Level Code")
                {
                    Visible = ShowForInternal;
                }
                field(Status; Rec.Status) { }
                field(VacancyPublishedDate; Rec."Vacancy Published Date") { }
                field(NoticePeriod; Rec."Notice Period") { }
                field(VacancyExpiryDate; Rec."Vacancy Expiry Date") { }
                field(Newspaper; Rec.Newspaper) { }
            }
            part(Control7; "Vacancy Subforms")
            {
                EntityName = 'vacancySubformEntity';
                EntitySetName = 'vacancySubformEntities';
                SubPageLink = "Vacancy No." = field("No.");
            }
            part(Control44; "Selection Commitee Sublist")
            {
                EntityName = 'selectionCommitteeEntities';
                EntitySetName = 'selectionCommitteeEntitiesSet';
                SubPageLink = "Vacancy Code" = field("No.");
            }
            part(Control8; "Interviewer Sublist")
            {
                EntityName = 'interviewerEntities';
                EntitySetName = 'interviewerEntitiesSet';
                SubPageLink = "Vacancy Code" = field("No.");
                Visible = IsPosted;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Visible = false;
                action("Send Approval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if not ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId) then begin
                            if Rec."Selection Committee Approved" then begin
                                if (Rec."Approval Status" = Rec."Approval Status"::open) then begin
                                    Rec.OnSendVacancyDocForApproval(Rec);
                                    Rec."Date of Request" := Today;
                                end;
                            end else
                                Message('All Committee has to approve to send for approval.');
                        end else
                            Message('Workflow for Vacancy has not been enabled.');
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.OnCancelVacancyDocForApproval(Rec);
                    end;
                }
                action("Selection Committee Approval")
                {
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to approve this vacancy.', false) then begin
                            HRMgt.SelectionCommitteeApproval(Rec."No.");
                        end;
                    end;
                }
            }
            group(Release)
            {
                Caption = 'Release';
                action(Reopen)
                {
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    begin
                        //ApprovalMgmt.OnReopenVacancyApproval(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortcutKey = 'F9';

                    trigger OnAction()
                    begin
                        //IF OnPost THEN
                        CurrPage.Close;
                    end;
                }
                action("Send Email")
                {
                    Enabled = IsPosted;
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;
                }
            }
            group(Form)
            {
                Caption = 'Form';
                action(MRF)
                {
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VacancyHdr: Record "Vacancy Header";
                    begin
                        VacancyHdr.Reset;
                        VacancyHdr.SetRange("No.", Rec."No.");
                        Report.Run(70021, true, false, VacancyHdr);
                    end;
                }
            }
            action("Show Candidate List")
            {
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Rec.Posted;

                trigger OnAction()
                begin
                    HRMgt.ShowCandidateList(Rec."No.");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetControlAppearanceInterviewer; //Min
        //SetControlAppearance;
        //SETRANGE("No.",'VCAN-0027');
        Rec.SetRange(Status, Rec.Status::"Interview Scheduled"); //Min
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        [InDataSet]
        OpenApprovalEntriesExist: Boolean;
        [InDataSet]
        IsPosted: Boolean;
        HRMgt: Codeunit "HR Mgt.";
        [InDataSet]
        ShowForInternal: Boolean;

    local procedure SetControlAppearance()
    var
        Employee: Record Employee;
        SelectionCommittee: Record "Selection Commitee";
        VacancyNoFiliter: Text;
    begin
        Employee.Reset;
        Clear(VacancyNoFiliter);
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then;
        SelectionCommittee.Reset;
        SelectionCommittee.SetRange("Employee No", Employee."No.");
        if SelectionCommittee.Find('-') then
            repeat
                if VacancyNoFiliter = '' then
                    VacancyNoFiliter := SelectionCommittee."Vacancy Code"
                else
                    VacancyNoFiliter += '|' + SelectionCommittee."Vacancy Code";
            until SelectionCommittee.Next = 0;
        if VacancyNoFiliter = '' then
            Rec.SetRange("No.", VacancyNoFiliter)
        else
            Rec.SetFilter("No.", VacancyNoFiliter);
    end;

    local procedure SetControlAppearanceInterviewer()
    var
        Employee: Record Employee;
        Interviewer: Record Interviewer;
        VacancyNoFiliter: Text;
    begin
        Employee.Reset;
        Clear(VacancyNoFiliter);
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then;
        Interviewer.Reset;
        Interviewer.SetRange(Interviewer, Employee."No.");
        if Interviewer.Find('-') then
            repeat
                if VacancyNoFiliter = '' then
                    VacancyNoFiliter := Interviewer."Vacancy Code"
                else
                    VacancyNoFiliter += '|' + Interviewer."Vacancy Code";
            until Interviewer.Next = 0;
        if VacancyNoFiliter <> '' then
            Rec.SetFilter("No.", VacancyNoFiliter)
        else
            Rec.SetRange("No.", VacancyNoFiliter);
    end;
}
