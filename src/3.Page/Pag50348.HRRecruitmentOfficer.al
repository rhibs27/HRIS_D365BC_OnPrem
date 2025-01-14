page 50348 "HR Recruitment Officer"
{
    ApplicationArea = All;
    Caption = 'HR Recruitment Officer';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control5; "Headline RC Order Processor")
            {
                ApplicationArea = Basic, Suite;
            }
            group("HRMS")
            {

                part("HR Overview"; "HR Overview")
                {
                    Caption = 'HR Overview';
                    ApplicationArea = All;
                }
                part("loan & Advance"; "Loan & Advance cues")
                {
                    Caption = 'Loan & Advance Details';
                    ApplicationArea = All;
                }
                part(HRCue; "HR Cue")
                {
                    Caption = 'HR Activities';
                    ApplicationArea = All;
                }
            }
        }
    }
}
