page 50013 "District"
{
    PageType = List;
    SourceTable = District;
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("District Code"; Rec."District Code")
                {
                    ToolTip = 'Specifies the value of the District Code field.';
                    ApplicationArea = All;
                }
                field("District Name"; Rec."District Name")
                {
                    ToolTip = 'Specifies the value of the District Name field.';
                    ApplicationArea = All;
                }
                field(Province; Rec.Province)
                {
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field(Region; Rec.Region)
                {
                    ToolTip = 'Specifies the value of the Region field.';
                    ApplicationArea = All;
                }
                field("InsideOutside Valley"; Rec."InsideOutside Valley")
                {
                    ToolTip = 'Specifies the value of the InsideOutside Valley field.';
                    ApplicationArea = All;
                }
                field("District Name(Nepali)"; Rec."District Name(Nepali)")
                {
                    ToolTip = 'Specifies the value of the District Name(Nepali) field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
