page 50388 "Score Detail Subform"
{
    ApplicationArea = All;
    Caption = 'Score Detail Subform';
    PageType = ListPart;
    SourceTable = "Score Detail";
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Appraisal Template"; Rec."Appraisal Template")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reviewer Type"; Rec."Reviewer Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Score/Rating By"; Rec."Score/Rating By")
                {
                    ApplicationArea = All;
                    Editable = ScoreRatingEditable;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Weightage; Rec.Weightage)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Submitted; Rec.Submitted)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Submitted Date"; Rec."Submitted Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Caption = 'Submit Scores';
                Image = Approval;
                ToolTip = 'Submit all scores for this appraisal';

                trigger OnAction()
                begin
                    SubmitAllScores();

                end;
            }
        }
    }
    var
        ScoreRatingEditable: Boolean;
        SubmittedEditable: Boolean;
        ReviewerSetup: Record "Reviewer Setup";
        AppraisalHdr: Record Appraisal;
        HRMgt: Codeunit "HR Mgt.";

    trigger OnAfterGetRecord()
    begin
        UpdateEditability();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ScoreRatingEditable := true;
        SubmittedEditable := true;
    end;

    local procedure UpdateEditability()
    begin
        ScoreRatingEditable := true;
        SubmittedEditable := true;

        if not AppraisalHdr.Get(Rec."Appraisal Code") then
            exit;
        if AppraisalHdr."Approval Status" = AppraisalHdr."Approval Status"::Approved then begin
            ScoreRatingEditable := false;
            SubmittedEditable := false;
            exit;
        end;

        if Rec."Reviewer Type" = '' then
            exit;

        if ReviewerSetup.Get(Rec."Reviewer Type") then
            ScoreRatingEditable :=
                not (ReviewerSetup."Is Self Review" or ReviewerSetup."Is Group Based");
    end;

    local procedure SubmitAllScores()
    var
        ScoreDetail: Record "Score Detail";
        ScoreDetailCheck: Record "Score Detail";
        CurrentEmployeeNo: Code[20];
        IsHRUser: Boolean;
        CanSubmit: Boolean;
        LinesSubmitted: Integer;
        ErrorMessages: Text;
        AppraisalCode: Code[20];
        ReviewerType: Code[20];
    begin
        AppraisalCode := Rec."Appraisal Code";
        ReviewerType := Rec."Reviewer Type";
        CurrentEmployeeNo := HRMgt.GetEmployeeNo();
        IsHRUser := IsHRApprover(CurrentEmployeeNo);
        CanSubmit := false;
        ScoreDetailCheck.Reset();
        ScoreDetailCheck.SetRange("Appraisal Code", AppraisalCode);
        ScoreDetailCheck.SetRange("Reviewer Type", ReviewerType);
        ScoreDetailCheck.SetRange(Submitted, false);
        if not ScoreDetailCheck.FindSet() then begin
            Message('All score details are already submitted.');
            exit;
        end;
        if IsHRUser then begin
            CanSubmit := true;
        end else begin
            CanSubmit := true;
            ErrorMessages := '';
            repeat
                if ScoreDetailCheck."Score/Rating By" <> CurrentEmployeeNo then begin
                    CanSubmit := false;
                    if ErrorMessages <> '' then
                        ErrorMessages += '\';
                    ErrorMessages += StrSubstNo('Line %1: Score/Rating By (%2) does not match current user (%3)',
                        ScoreDetailCheck."Line No.", ScoreDetailCheck."Score/Rating By", CurrentEmployeeNo);
                end;
            until ScoreDetailCheck.Next() = 0;
        end;
        if not CanSubmit then begin
            if ErrorMessages <> '' then
                Error(ErrorMessages)
            else
                Error('Cannot submit scores. You are not authorized to submit these records.');
            exit;
        end;
        ScoreDetail.Reset();
        ScoreDetail.SetRange("Appraisal Code", AppraisalCode);
        ScoreDetail.SetRange("Reviewer Type", ReviewerType);
        ScoreDetail.SetRange(Submitted, false);
        LinesSubmitted := 0;

        if ScoreDetail.FindSet() then begin
            repeat
                ScoreDetail.Submitted := true;
                ScoreDetail."Submitted Date" := Today;
                ScoreDetail.Modify();
                LinesSubmitted += 1;
            until ScoreDetail.Next() = 0;

            Message('%1 score detail(s) submitted successfully.', LinesSubmitted);
            CurrPage.Update(false);
        end;
    end;

    local procedure IsHRApprover(EmployeeNo: Code[20]): Boolean
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
}
