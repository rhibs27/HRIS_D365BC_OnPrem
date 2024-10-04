page 33020105 "Location Incentive Setup"
{
    // version KPI1.00

    SourceTable = "Human Resources Setup";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("Location Incentive 1"; Rec."Location Incentive 1")
            {
                Caption = 'Same Province And District, Different Municipality';
                ToolTip = 'Specifies the value of the Same Province And District, Different Municipality field.';
                ApplicationArea = All;
            }
            field("Location Incentive 2"; Rec."Location Incentive 2")
            {
                Caption = 'Same Province But Different District';
                ToolTip = 'Specifies the value of the Same Province But Different District field.';
                ApplicationArea = All;
            }
            field("Location Incentive 3"; Rec."Location Incentive 3")
            {
                Caption = 'Different Province';
                ToolTip = 'Specifies the value of the Different Province field.';
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
