page 33019876 "Appraisal SubForm"
{
    // version Not Used

    AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "KRA Subform List";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                    ApplicationArea = All;
                }
                field("Weightage (%)"; Rec."Weightage (%)")
                {
                    ToolTip = 'Specifies the value of the Weightage (%) field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
