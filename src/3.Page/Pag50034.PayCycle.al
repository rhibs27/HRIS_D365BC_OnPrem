page 50034 "Pay Cycle"
{
    // version PRM19.01.01

    PageType = List;
    SourceTable = "Pay Cycle";
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
                field("Pay Frequency"; Rec."Pay Frequency")
                {
                    ToolTip = 'Specifies the value of the Pay Frequency field.';
                    ApplicationArea = All;
                }
                field("Payment Delay"; Rec."Payment Delay")
                {
                    ToolTip = 'Specifies the value of the Payment Delay field.';
                    ApplicationArea = All;
                }
                field("Annualizing Factor"; Rec."Annualizing Factor")
                {
                    ToolTip = 'Specifies the value of the Annualizing Factor field.';
                    ApplicationArea = All;
                }
                field("Monthly Factor"; Rec."Monthly Factor")
                {
                    ToolTip = 'Specifies the value of the Monthly Factor field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Pay Cycle")
            {
                Caption = '&Pay Cycle';
                action("&Terms")
                {
                    Caption = '&Terms';
                    Image = TaskList;
                    RunObject = page "Pay Cycle Term";
                    RunPageLink = "Pay Cycle Code" = field(Code);
                    ToolTip = 'Executes the &Terms action.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
