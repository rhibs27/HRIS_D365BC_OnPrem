page 33019924 "Interview Entries"
{
    // version HRM1.00,not used

    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = Interviewer;
    SourceTableView = sorting(Sequence);
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vacancy Code"; Rec."Vacancy Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Vacancy Code field.';
                    ApplicationArea = All;
                }
                field(Interviewer; Rec.Interviewer)
                {
                    ToolTip = 'Specifies the value of the Interviewer field.';
                    ApplicationArea = All;
                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the value of the Sequence field.';
                    ApplicationArea = All;
                }
                field("Interview Date"; Rec."Interview Date")
                {
                    ToolTip = 'Specifies the value of the Interview Date field.';
                    ApplicationArea = All;
                }
                field("Interview Time"; Rec."Interview Time")
                {
                    ToolTip = 'Specifies the value of the Interview Time field.';
                    ApplicationArea = All;
                }
                field("Interviewer Email Sent"; Rec."Interviewer Email Sent")
                {
                    ToolTip = 'Specifies the value of the Interviewer Email Sent field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Interview Evaluation")
            {
                Caption = 'Interview Evaluation';
            }
            action("Evaluation Form")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Evaluation Form action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.OnOpenEvaluationList;
                end;
            }
            action("Evaluation Report Print")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Evaluation Report Print action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    Candidates: Record Candidate;
                begin
                    Candidates.Reset;
                    //Candidates.SETRANGE("No.", "Candidate No.");
                    //REPORT.RUN(80001,TRUE, TRUE,Candidates);
                end;
            }
        }
    }
}
