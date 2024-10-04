page 50193 "Att. Journal Template List"
{
    // version AMS6.1.0

    Editable = false;
    PageType = List;
    SourceTable = "Employee Service History";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Service History Code"; Rec."Service History Code")
                {
                    ToolTip = 'Specifies the value of the Service History Code field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000005; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1000000004; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
