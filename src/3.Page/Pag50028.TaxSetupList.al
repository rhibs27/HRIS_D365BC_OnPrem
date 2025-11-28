page 50028 "Tax Setup List"
{
    CardPageId = "Tax Setup Card";
    PageType = List;
    SourceTable = "Tax Setup Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Special Tax Exempt %"; Rec."Special Tax Exempt %")
                {
                    ToolTip = 'Specifies the value of the Special Tax Exempt % field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
