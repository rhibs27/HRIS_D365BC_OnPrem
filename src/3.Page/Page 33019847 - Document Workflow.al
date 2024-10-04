page 33019847 "Document Workflow"
{
    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Document Workflow";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Heading Type"; Rec."Heading Type")
                {
                    ToolTip = 'Specifies the value of the Heading Type field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
