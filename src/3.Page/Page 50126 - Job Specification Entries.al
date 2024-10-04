page 50126 "Job Specification Entries"
{
    // version HRM1.00

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Job Desc./Spec. Entry";
    SourceTableView = where(Type = const("Job Specification"));
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
                field("Job Specification Code"; Rec."Job Description Code")
                {
                    TableRelation = Qualification.Code where(Type = filter(Education));
                    ToolTip = 'Specifies the value of the Job Description Code field.';
                    ApplicationArea = All;
                }
                field("Job Specifiation"; Rec."Job Description")
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
