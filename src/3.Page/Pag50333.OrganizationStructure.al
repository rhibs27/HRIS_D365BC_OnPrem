page 50333 "Organization Structure"
{
    ApplicationArea = All;
    Caption = 'Organization Structure';
    PageType = List;
    SourceTable = "Organization structure";
    UsageCategory = Lists;
    CardPageId = "Organization Structure Card";
    Editable = false;
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
            }
        }
    }
}
