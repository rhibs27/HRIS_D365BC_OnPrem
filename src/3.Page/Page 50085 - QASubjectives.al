page 50085 QASubjectives
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Feedback";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Question; Rec.Question)
                {
                    ToolTip = 'Specifies the value of the Question field.';
                    ApplicationArea = All;
                }
                field("Answers Text"; Rec."Answers Text")
                {
                    ToolTip = 'Specifies the value of the Answers Text field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
