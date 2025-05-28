page 50334 "Organization Structure list"
{
    ApplicationArea = All;
    Caption = 'Organization Structure list';
    PageType = List;
    SourceTable = "Organization Structure list";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Province; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province field.', Comment = '%';
                }
                field("Region"; Rec."Region")
                {
                    ToolTip = 'Specifies the value of the Region field.', Comment = '%';
                }
                field("InsideOutside Valley"; Rec."InsideOutside Valley")
                {
                    ToolTip = 'Specifies the value of the InsideOutside Valley field.', Comment = '%';
                }
                field("District code"; Rec."District code")
                {
                    ToolTip = 'Specifies the value of the District code field.', Comment = '%';
                }
                field("District Name"; Rec."District Name")
                {
                    ToolTip = 'Specifies the value of the District Name field.', Comment = '%';
                }
                field("Municipality Code"; Rec."Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Municipality field.', Comment = '%';
                }
                field("Municipality Name"; Rec."Municipality Name")
                {
                    ToolTip = 'Specifies the value of the Municipality field.', Comment = '%';
                }
                field("Remote Area Category"; Rec."Remote Area Category")
                {
                    ToolTip = 'Specifies the value of the Remote Area Category field.', Comment = '%';
                }
                field("Remote Area Reduction"; Rec."Remote Area Reduction")
                {
                    ToolTip = 'Specifies the value of the Remote Area Category field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Remote Area Category field.', Comment = '%';
                }
            }
        }
    }
}
