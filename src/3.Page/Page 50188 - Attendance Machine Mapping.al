page 50188 "Attendance Machine Mapping"
{
    // version AMS6.1.0

    PageType = List;
    SourceTable = "Attendance Machine Mapping";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Machine Code"; Rec."Machine Code")
                {
                    ToolTip = 'Specifies the value of the Machine Code field.';
                    ApplicationArea = All;
                }
                field("Machine Name"; Rec."Machine Name")
                {
                    ToolTip = 'Specifies the value of the Machine Name field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                }
                field("IP Address"; Rec."IP Address")
                {
                    ToolTip = 'Specifies the value of the IP Address field.';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
