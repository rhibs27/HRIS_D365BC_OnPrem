page 33019931 "Interview Schedule"
{
    // version HRM1.00,not used

    Editable = true;
    PageType = List;
    SourceTable = Interviewer;
    SourceTableView = sorting(Sequence);
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                begin
                end;
            }
        }
    }
}
