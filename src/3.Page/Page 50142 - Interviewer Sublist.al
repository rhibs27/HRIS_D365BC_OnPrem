page 50142 "Interviewer Sublist"
{
    PageType = ListPart;
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
                field("Interviewer Fullname"; Rec."Interviewer Fullname")
                {
                    ToolTip = 'Specifies the value of the Interviewer Fullname field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
