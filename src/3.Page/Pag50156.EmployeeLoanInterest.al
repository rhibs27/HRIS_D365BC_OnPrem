page 50156 "Employee Loan Interest"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Loan Interest";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the value of the Loan Type field.';
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                    ApplicationArea = All;
                }
                field("Loan Amount Threshold"; Rec."Loan Amount Threshold")
                {
                    ToolTip = 'Specifies the loan amount boundary for tiered interest. Loans at or below this amount use the Below Threshold Rate; loans above use Cost of Fund Rate + Above Threshold Spread.';
                    ApplicationArea = All;
                }
                field("Below Threshold Rate"; Rec."Below Threshold Rate")
                {
                    ToolTip = 'Specifies the flat interest rate (%) applied to loans at or below the Loan Amount Threshold.';
                    ApplicationArea = All;
                }
                field("Above Threshold Spread"; Rec."Above Threshold Spread")
                {
                    ToolTip = 'Specifies the spread (%) added to the Cost of Fund Rate for loans above the Loan Amount Threshold.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
