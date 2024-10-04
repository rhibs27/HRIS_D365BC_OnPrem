page 33019920 "Vacancy Card"
{
    // version HRM1.00

    //The property 'EntityName' can only be set if the property 'PageType' is set to 'API'
    //EntityName = 'vacancyCardEntities';
    //The property 'EntitySetName' can only be set if the property 'PageType' is set to 'API'
    //EntitySetName = 'vacancyCardEntitiesSet';
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Request Approval,Candidate';
    RefreshOnActivate = true;
    SourceTable = "Vacancy Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    ApplicationArea = All;
                }
                field("Date of Request"; Rec."Date of Request")
                {
                    ToolTip = 'Specifies the value of the Date of Request field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    Visible = not ShowForInternal;
                    ToolTip = 'Specifies the value of the Position to be filled field.';
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.';
                    ApplicationArea = All;
                }
                field("Budget Salary / CTC"; Rec."Budget Salary / CTC")
                {
                    ToolTip = 'Specifies the value of the Budget Salary / CTC field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    Visible = ShowForInternal;
                    ToolTip = 'Specifies the value of the Position / Vacancy field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Vacancy Published Date"; Rec."Vacancy Published Date")
                {
                    ToolTip = 'Specifies the value of the Vacancy Published Date field.';
                    ApplicationArea = All;
                }
                field("Notice Period"; Rec."Notice Period")
                {
                    ToolTip = 'Specifies the value of the Notice Period field.';
                    ApplicationArea = All;
                }
                field("Vacancy Expiry Date"; Rec."Vacancy Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Vacancy Expiry Date field.';
                    ApplicationArea = All;
                }
                field(Newspaper; Rec.Newspaper)
                {
                    ToolTip = 'Specifies the value of the Newspaper field.';
                    ApplicationArea = All;
                }
            }
            part(Control7; "Vacancy Subforms")
            {
                SubPageLink = "Vacancy No." = field("No.");
                ApplicationArea = All;
            }
            part(Control44; "Selection Commitee Sublist")
            {
                SubPageLink = "Vacancy Code" = field("No.");
                ApplicationArea = All;
            }
            part(Control8; "Interviewer Sublist")
            {
                SubPageLink = "Vacancy Code" = field("No.");
                Visible = IsPosted;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
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
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if not ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId) then begin
                            if CheckSelectionComittee then begin
                                if (Rec."Approval Status" = Rec."Approval Status"::open) then begin
                                    if Rec.Type = Rec.Type::External then begin
                                        Rec.TestField(Description);
                                        Rec.TestField("Vacancy Published Date");
                                        Rec.TestField("Notice Period");
                                        Rec.TestField("Vacancy Expiry Date");
                                    end;
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
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.OnCancelVacancyDocForApproval(Rec);
                    end;
                }
                action("Selection Committee Approval")
                {
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Selection Committee Approval action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to approve this vacancy.', false) then begin
                            HRMgt.SelectionCommitteeApproval(Rec."No.");
                        end;
                    end;
                }
                action(Post)
                {
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Post action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to Post this vacancy.', false) then begin  //Min
                            Rec.Posted := true;
                            Rec."Approval Status" := Rec."Approval Status"::released;
                            Rec."Approved Date" := Today;
                            Rec.Modify;
                        end;
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
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
                    ToolTip = 'Executes the Re&open action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //ApprovalMgmt.OnReopenVacancyApproval(Rec);
                    end;
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
                    ToolTip = 'Executes the MRF action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        VacancyHdr: Record "Vacancy Header";
                    begin
                        VacancyHdr.Reset;
                        VacancyHdr.SetRange("No.", Rec."No.");
                        Report.Run(Report::"Manpower Request Form", true, false, VacancyHdr);
                    end;
                }
            }
            group(Candidate)
            {
                action("Show Candidate List")
                {
                    Image = ShowSelected;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    Visible = Rec.Posted;
                    ToolTip = 'Executes the Show Candidate List action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ShowCandidateList(Rec."No.");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        if Rec."Approval Status" <> Rec."Approval Status"::open then
            CurrPage.Editable(false);
    end;

    trigger OnOpenPage()
    begin
        SetControlAppearance;
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
        [InDataSet]
        OpenApprovalEntriesExistForCurrUser: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        IsPosted := Rec.Posted;
        if Rec.Type = Rec.Type::Internal then
            ShowForInternal := true
        else
            ShowForInternal := false;
    end;

    local procedure CheckSelectionComittee(): Boolean
    var
        SelectionCommitee: Record "Selection Commitee";
    begin
        SelectionCommitee.Reset;
        SelectionCommitee.SetRange("Vacancy Code", Rec."No.");
        SelectionCommitee.SetRange(Approved, false);
        if SelectionCommitee.FindFirst then
            exit(false)
        else
            exit(true);
    end;
}
