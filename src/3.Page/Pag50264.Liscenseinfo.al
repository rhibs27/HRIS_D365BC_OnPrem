page 50264 "License info"
{
    ApplicationArea = All;
    Caption = 'License info';
    PageType = List;
    SourceTable = "Permission Range";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(From; Rec.From)
                {
                    ToolTip = 'Specifies the value of the From field.', Comment = '%';
                }
                field("To"; Rec."To")
                {
                    ToolTip = 'Specifies the value of the To field.', Comment = '%';
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    ToolTip = 'Specifies the value of the Read Permission field.', Comment = '%';
                }
                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies the value of the Object Type field.', Comment = '%';
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    ToolTip = 'Specifies the value of the Modify Permission field.', Comment = '%';
                }
                field("Limited Usage Permission"; Rec."Limited Usage Permission")
                {
                    ToolTip = 'Specifies the value of the Limited Usage Permission field.', Comment = '%';
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    ToolTip = 'Specifies the value of the Insert Permission field.', Comment = '%';
                }
                field(Index; Rec.Index)
                {
                    ToolTip = 'Specifies the value of the Index field.', Comment = '%';
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    ToolTip = 'Specifies the value of the Execute Permission field.', Comment = '%';
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    ToolTip = 'Specifies the value of the Delete Permission field.', Comment = '%';
                }
            }
        }
    }
}
