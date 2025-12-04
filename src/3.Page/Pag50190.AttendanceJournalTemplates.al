page 50190 "Attendance Journal Templates"
{
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
                field("Deputation Value (From)"; Rec."Deputation Value (From)")
                {
                    ToolTip = 'Specifies the value of the Deputation Value (From) field.';
                    ApplicationArea = All;
                }
                field("Created by"; Rec."Created by")
                {
                    ToolTip = 'Specifies the value of the Created by field.';
                    ApplicationArea = All;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ToolTip = 'Specifies the value of the Created DateTime field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000008; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1000000007; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("<Action1000000011>")
            {
                Caption = 'Te&mplate';
                action("<Action1000000012>")
                {
                    Caption = 'Batches';
                    RunObject = page "Attendance Journal Batches";
                    RunPageLink = "Fiscal Year" = field("Service History Code");
                    ToolTip = 'Executes the Batches action.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
