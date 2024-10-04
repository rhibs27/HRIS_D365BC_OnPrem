page 33019880 "Review Master List"
{
    PageType = List;
    SourceTable = "Review Master";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ToolTip = 'Specifies the value of the Value field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control7; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
