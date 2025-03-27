page 50028 "Tax Setup List"
{
    // version PRM19.01.01

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
                field("Effective from"; Rec."Effective from")
                {
                    ToolTip = 'Specifies the value of the Effective from field.';
                    ApplicationArea = All;
                }
                field("Effective to"; Rec."Effective to")
                {
                    ToolTip = 'Specifies the value of the Effective to field.';
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
