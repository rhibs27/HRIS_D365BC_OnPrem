page 50002 "Employee Payroll Opening"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Employee Payroll Opening";
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = '';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Total Benefit Opening"; Rec."Total Benefit Opening")
                {
                    ToolTip = 'Specifies the value of the Total Benefit Opening field.';
                    ApplicationArea = All;
                }
                field("Total RF Opening"; Rec."Total RF Opening")
                {
                    ToolTip = 'Specifies the value of the Total RF Opening field.';
                    ApplicationArea = All;
                }
                field("Total Social Security Opening"; Rec."Total Social Security Opening")
                {
                    ToolTip = 'Specifies the value of the Total Social Security Opening field.';
                    ApplicationArea = All;
                }
                field("Total Tax Remuneration Opening"; Rec."Total Tax Remuneration Opening")
                {
                    ToolTip = 'Specifies the value of the Total Tax Remuneration Opening field.';
                    ApplicationArea = All;
                }
                field("Opening LWP Days"; Rec."Opening LWP Days")
                {
                    ToolTip = 'Specifies the value of the Opening LWP Days field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
