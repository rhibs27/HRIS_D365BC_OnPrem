page 50140 "Email Template Receipents"
{

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Email Template Recipient";
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
            }
        }
    }

    actions { }
}
