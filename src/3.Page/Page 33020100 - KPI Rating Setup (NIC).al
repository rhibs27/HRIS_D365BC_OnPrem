page 33020100 "KPI Rating Setup (NIC)"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Rating Setup";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Min Score"; Rec."Min Score")
                {
                    ToolTip = 'Specifies the value of the Min Score field.';
                    ApplicationArea = All;
                }
                field("Max Score"; Rec."Max Score")
                {
                    ToolTip = 'Specifies the value of the Max Score field.';
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ToolTip = 'Specifies the value of the Rating field.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                    ApplicationArea = All;
                }
                field("KPI Incentive Not Eligible"; Rec."KPI Incentive Not Eligible")
                {
                    ToolTip = 'Specifies the value of the KPI Incentive Not Eligible field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
