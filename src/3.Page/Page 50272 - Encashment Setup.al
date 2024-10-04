page 50272 "Encashment Setup"
{
    PageType = List;
    SourceTable = "OT Encashment Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Encashment Code"; Rec."Encashment Code")
                {
                    ToolTip = 'Specifies the value of the Encashment Code field.';
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
