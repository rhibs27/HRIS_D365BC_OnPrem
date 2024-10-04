page 33020107 "KPI Appraisals Department"
{
    // version KPI1.00

    CardPageId = "Extension Counter Entity";
    PageType = List;
    SourceTable = "KPI Appraisal Header NIC";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Department);
        Rec.FilterGroup(2);
    end;
}
