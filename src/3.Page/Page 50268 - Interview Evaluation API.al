page 50268 "Interview Evaluation API"
{
    // version HRM1.00

    PageType = API;
    SourceTable = "Evaluation Entry";
    SourceTableView = where(Type = const(Interview));
    EntityName = 'interviewEvaluationEntity';
    EntitySetName = 'interviewEvaluationEntities';
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(no; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(attributeCode; Rec."Attribute Code")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Attribute Code field.';
                    ApplicationArea = All;
                }
                field(attributeDescription; Rec."Attribute Description")
                {
                    ToolTip = 'Specifies the value of the Attribute Description field.';
                    ApplicationArea = All;
                }
                field(interviewerCode; Rec."Interviewer Code")
                {
                    CaptionClass = '3,' + Interviewer1Name;
                    ToolTip = 'Specifies the value of the Interviewer Code field.';
                    ApplicationArea = All;
                }
                field(interviewerName; Rec."Interviewer Name")
                {
                    CaptionClass = '3,' + Interviewer2Name;
                    ToolTip = 'Specifies the value of the Interviewer Name field.';
                    ApplicationArea = All;
                }
                field(fullMarks; Rec."Full Marks")
                {
                    ToolTip = 'Specifies the value of the Full Marks field.';
                    ApplicationArea = All;
                }
                field(marks; Rec.Marks)
                {
                    CaptionClass = '3,' + Interviewer3Name;
                    ToolTip = 'Specifies the value of the Marks field.';
                    ApplicationArea = All;
                }
                field(remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field(isRemarks; Rec."Is Remarks")
                {
                    ToolTip = 'Specifies the value of the Is Remarks field.';
                    ApplicationArea = All;
                }
                field(isRemarkOption; Rec."Is Remark Option")
                {
                    ToolTip = 'Specifies the value of the Is Remark Option field.';
                    ApplicationArea = All;
                }
                field(posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Post action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    EvaluationEntry: Record "Evaluation Entry";
                begin
                    EvaluationEntry.Reset;
                    EvaluationEntry.CopyFilters(Rec);
                    Rec.PostDocument(EvaluationEntry);
                end;
            }
            action(Reopen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Reopen action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    EvaluationEntry: Record "Evaluation Entry";
                begin
                    EvaluationEntry.Reset;
                    EvaluationEntry.CopyFilters(Rec);
                    Rec.PostDocument(EvaluationEntry);
                end;
            }
            action("Generate Interview Entries")
            {
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Generate Interview Entries action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    VacancyFilter := Rec.GetFilter("Vacancy Code");
                    CandidateFilter := Rec.GetFilter("No.");
                    Rec.FilterGroup(0);
                    HRMgt.GenerateInterviewerEntries(VacancyFilter, CandidateFilter);
                end;
            }
            action(Submit)
            {
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Submit action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRMgt.SubmitEvaluationEntry(Rec."No.", Rec);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.FilterGroup(2);
        VacancyFilter := Rec.GetFilter("Vacancy Code");
        CandidateFilter := Rec.GetFilter("No.");
        Rec.FilterGroup(0);
        if VacancyFilter <> '' then
            Rec."Vacancy Code" := VacancyFilter;
        if CandidateFilter <> '' then
            CandidateFilter := Rec."No.";
    end;

    trigger OnOpenPage()
    begin
        /*Interviewer.RESET;
        Interviewer.SETRANGE("Vacancy Code", VacancyCode);
        Interviewer.SETRANGE("Candidate No.", CandidateNo);
        IF Interviewer.FINDFIRST THEN
          REPEAT
            CASE Interviewer.Sequence OF
              1:
                BEGIN
                  IF Employee.GET(Interviewer."Employee Code") THEN
                    Interviewer1Name := Employee.FullName;
                END;
              2:
                BEGIN
                  IF Employee.GET(Interviewer."Employee Code") THEN
                    Interviewer2Name := Employee.FullName;
                END;
              3:
                BEGIN
                  IF Employee.GET(Interviewer."Employee Code") THEN
                    Interviewer3Name := Employee.FullName;
                END;
            END;
          UNTIL Interviewer.NEXT  = 0;
          */
    end;

    var
        Interviewer1Name: Text[100];
        Interviewer2Name: Text[100];
        Interviewer3Name: Text[100];
        VacancyCode: Code[20];
        CandidateNo: Code[20];
        HRMgt: Codeunit "HR Mgt.";
        CandidateFilter: Text;
        VacancyFilter: Text;

    procedure SetInterviewerName(VacancyCode_: Code[20]; CandidateNo_: Code[20])
    begin
        VacancyCode := VacancyCode_;
        CandidateNo := CandidateNo_;
    end;
}
