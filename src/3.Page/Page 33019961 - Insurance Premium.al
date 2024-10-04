page 33019961 "Insurance Premium"
{
    PageType = List;
    SourceTable = "Insurance Premium Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Insurance Company"; Rec."Insurance Company")
                {
                    ToolTip = 'Specifies the value of the Insurance Company field.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ToolTip = 'Specifies the value of the Value field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
