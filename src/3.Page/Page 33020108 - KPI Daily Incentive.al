page 33020108 "KPI Daily Incentive"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Daily Incentive";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Location Incentive"; Rec."Location Incentive")
                {
                    ToolTip = 'Specifies the value of the Location Incentive field.';
                    ApplicationArea = All;
                }
                field("Role Incentive"; Rec."Role Incentive")
                {
                    ToolTip = 'Specifies the value of the Role Incentive field.';
                    ApplicationArea = All;
                }
                field("Net KPI Score"; Rec."Net KPI Score")
                {
                    ToolTip = 'Specifies the value of the Net KPI Score field.';
                    ApplicationArea = All;
                }
                field("KPI Score"; Rec."KPI Score")
                {
                    ToolTip = 'Specifies the value of the KPI Score field.';
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ToolTip = 'Specifies the value of the Rating field.';
                    ApplicationArea = All;
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ToolTip = 'Specifies the value of the Entry Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Employee);
        Rec.FilterGroup(2);
    end;
}
