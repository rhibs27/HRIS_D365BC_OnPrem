page 50275 "Active Employee"
{
    ApplicationArea = All;
    Caption = 'Active Employee';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            grid("Active Employees")
            {
                group("Active Employee")
                {
                    field("Contract Staff"; Rec."Contract Staff")
                    {
                        ToolTip = 'Specifies the value of the Contract Staff field.';
                        ApplicationArea = All;
                    }
                    field("Probation Staff"; Rec."Probation Staff")
                    {
                        ToolTip = 'Specifies the value of the Probation Staff field.';
                        ApplicationArea = All;
                    }
                    field("Permanent Staff"; Rec."Permanent Staff")
                    {
                        ToolTip = 'Specifies the value of the Permanent Staff field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}
