page 33020094 "KPI Category"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Category";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Category Code"; Rec."Category Code")
                {
                    ToolTip = 'Specifies the value of the Category Code field.';
                    ApplicationArea = All;
                }
                field("Category Description"; Rec."Category Description")
                {
                    ToolTip = 'Specifies the value of the Category Description field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
