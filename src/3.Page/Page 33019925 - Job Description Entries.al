page 33019925 "Job Description Entries"
{
    // version HRM1.00

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Job Desc./Spec. Entry";
    SourceTableView = where(Type = const("Job Description"));
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
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Job Description Code"; Rec."Job Description Code")
                {
                    ToolTip = 'Specifies the value of the Job Description Code field.';
                    ApplicationArea = All;
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
