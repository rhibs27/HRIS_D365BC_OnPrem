page 33019929 "Rating Scale"
{
    // version HRM1.00

    DelayedInsert = true;
    PageType = List;
    SourceTable = "Rating Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(From; Rec.From)
                {
                    ToolTip = 'Specifies the value of the From field.';
                    ApplicationArea = All;
                }
                field("To"; Rec."To")
                {
                    ToolTip = 'Specifies the value of the To field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
