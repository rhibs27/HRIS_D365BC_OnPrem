page 50204 "Training Overall Remarks"
{
    Caption = 'Training Overall Remarks';
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
                field(Remarks; Rec.Rating)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
