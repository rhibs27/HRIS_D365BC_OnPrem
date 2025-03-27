page 50140 "Email Template Receipents"
{
    // version NP16.04

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Agile Email Recipient";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.';
                    ApplicationArea = All;
                }
                field("Email Recipients"; Rec."Email Recipients")
                {
                    ToolTip = 'Specifies the value of the Email Recipients field.';
                    ApplicationArea = All;
                }
                field("Recipient Type"; Rec."Recipient Type")
                {
                    ToolTip = 'Specifies the value of the Recipient Type field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                    ApplicationArea = All;
                }
                field(Region; Rec.Region)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Region field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
