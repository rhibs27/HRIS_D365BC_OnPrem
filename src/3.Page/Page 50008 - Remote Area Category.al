page 50008 "Remote Area Category"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "Remote Area Category";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                    ApplicationArea = All;
                }
                field("Remote allowance Percentage"; Rec."Remote allowance Percentage")
                {
                    ToolTip = 'Specifies the value of the Remote allowance Percentage field.';
                    ApplicationArea = All;
                }
                field("Remote Allowance Amount"; Rec."Remote Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Remote Allowance Amount field.';
                    ApplicationArea = All;
                }
                field("BM Accomodation Amount"; Rec."BM Accomodation Amount")
                {
                    ToolTip = 'Specifies the value of the BM Accomodation Amount field.';
                    ApplicationArea = All;
                }
                field("Remote Area Deduction"; Rec."Remote Area Deduction")
                {
                    ToolTip = 'Specifies the value of the Remote Area Deduction field.';
                    ApplicationArea = All;
                }
                field("KPI Incentive %"; Rec."KPI Incentive %")
                {
                    ToolTip = 'Specifies the value of the KPI Incentive % field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
