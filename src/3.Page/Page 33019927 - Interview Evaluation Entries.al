page 33019927 "Interview Evaluation Entries"
{
    // version HRM1.00

    PageType = ListPart;
    SourceTable = "Evaluation Entry";
    SourceTableView = where(Type = const(Interview));
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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Attribute Code field.';
                    ApplicationArea = All;
                }
                field("Attribute Description"; Rec."Attribute Description")
                {
                    ToolTip = 'Specifies the value of the Attribute Description field.';
                    ApplicationArea = All;
                }
                field("Interviewer Code"; Rec."Interviewer Code")
                {
                    CaptionClass = '3,' + Interviewer1Name;
                    ToolTip = 'Specifies the value of the Interviewer Code field.';
                    ApplicationArea = All;
                }
                field("Interviewer Name"; Rec."Interviewer Name")
                {
                    CaptionClass = '3,' + Interviewer2Name;
                    ToolTip = 'Specifies the value of the Interviewer Name field.';
                    ApplicationArea = All;
                }
                field("Full Marks"; Rec."Full Marks")
                {
                    ToolTip = 'Specifies the value of the Full Marks field.';
                    ApplicationArea = All;
                }
                field(Marks; Rec.Marks)
                {
                    CaptionClass = '3,' + Interviewer3Name;
                    ToolTip = 'Specifies the value of the Marks field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Is Remarks"; Rec."Is Remarks")
                {
                    ToolTip = 'Specifies the value of the Is Remarks field.';
                    ApplicationArea = All;
                }
                field("Is Remark Option"; Rec."Is Remark Option")
                {
                    ToolTip = 'Specifies the value of the Is Remark Option field.';
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Vacancy Code"; Rec."Vacancy Code")
                {
                    ToolTip = 'Specifies the value of the Vacancy Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
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
