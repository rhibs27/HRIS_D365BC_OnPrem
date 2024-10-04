page 33019836 "Pay Cycle Period"
{
    // version PRM19.01.01

    PageType = List;
    SourceTable = "Pay Cycle Period";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                    ApplicationArea = All;
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    ToolTip = 'Specifies the value of the Nepali Year field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ToolTip = 'Specifies the value of the Nepali Month field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ToolTip = 'Specifies the value of the Pay Date field.';
                    ApplicationArea = All;
                }
                field("Allowance Start Date"; Rec."Allowance Start Date")
                {
                    ToolTip = 'Specifies the value of the Allowance Start Date field.';
                    ApplicationArea = All;
                }
                field("Allowance End Date"; Rec."Allowance End Date")
                {
                    ToolTip = 'Specifies the value of the Allowance End Date field.';
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    ApplicationArea = All;
                }
                field("Tax Payment Date"; Rec."Tax Payment Date")
                {
                    ToolTip = 'Specifies the value of the Tax Payment Date field.';
                    ApplicationArea = All;
                }
                field("Income Tax Voucher No."; Rec."Income Tax Voucher No.")
                {
                    ToolTip = 'Specifies the value of the Income Tax Voucher No. field.';
                    ApplicationArea = All;
                }
                field("SST Voucher No."; Rec."SST Voucher No.")
                {
                    ToolTip = 'Specifies the value of the SST Voucher No. field.';
                    ApplicationArea = All;
                }
                field("E-TDS Transaction Number"; Rec."E-TDS Transaction Number")
                {
                    ToolTip = 'Specifies the value of the E-TDS Transaction Number field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
