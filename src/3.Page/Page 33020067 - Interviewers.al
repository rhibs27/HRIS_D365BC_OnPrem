page 33020067 Interviewers
{
    PageType = List;
    SourceTable = Interviewer;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vacancy Code"; Rec."Vacancy Code")
                {
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
                field("Candidate No."; Rec."Candidate No.")
                {
                    ToolTip = 'Specifies the value of the Candidate No. field.';
                    ApplicationArea = All;
                }
                field("Interviewer Email Sent"; Rec."Interviewer Email Sent")
                {
                    ToolTip = 'Specifies the value of the Interviewer Email Sent field.';
                    ApplicationArea = All;
                }
                field("Interviewer Fullname"; Rec."Interviewer Fullname")
                {
                    ToolTip = 'Specifies the value of the Interviewer Fullname field.';
                    ApplicationArea = All;
                }
                field("Interviewer Email"; Rec."Interviewer Email")
                {
                    ToolTip = 'Specifies the value of the Interviewer Email field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
