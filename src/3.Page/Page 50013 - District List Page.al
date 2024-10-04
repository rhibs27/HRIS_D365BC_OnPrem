page 50013 "District List Page"
{
    // version NIC Asia1.0

    PageType = List;
    SourceTable = District;
    ApplicationArea = All;

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
                field("Sub-Province Code"; Rec."Sub-Province Code")
                {
                    ToolTip = 'Specifies the value of the Sub-Province Code field.';
                    ApplicationArea = All;
                }
                field("Sub-Province Name"; Rec."Sub-Province Name")
                {
                    ToolTip = 'Specifies the value of the Sub-Province Name field.';
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
