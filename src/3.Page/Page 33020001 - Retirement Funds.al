page 33020001 "Retirement Funds"
{
    CardPageId = "Retirement Fund Card";
    PageType = List;
    SourceTable = "Retirement Fund";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Width = 20;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
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
                field("Requested Date"; "Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Payroll Month"; Rec."Payroll Month")
                {
                    ToolTip = 'Specifies the value of the Payroll Month field.';
                    ApplicationArea = All;
                }
                field("Annual Accessible Income"; Rec."Annual Accessible Income")
                {
                    ToolTip = 'Specifies the value of the Annual Accessible Income field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Eligible Amt"; "RF Contribution Eligible Amt")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Eligible Amt field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Deposited"; "Provident Fund Deposited")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Deposited field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Deposited"; "RF Contribution Deposited")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Deposited field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Projected"; "Provident Fund Projected")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Projected field.';
                    ApplicationArea = All;
                }
                field("Actual/Projected Contribution"; "Actual/Projected Contribution")
                {
                    ToolTip = 'Specifies the value of the Actual/Projected Contribution field.';
                    ApplicationArea = All;
                }
                field("Additional Space for RF Cont."; "Additional Space for RF Cont.")
                {
                    ToolTip = 'Specifies the value of the Additional Space for RF Cont. field.';
                    ApplicationArea = All;
                }
                field("NICA RTF Amount (Month)"; "NICA RTF Amount (Month)")
                {
                    ToolTip = 'Specifies the value of the NICA RTF Amount (Month) field.';
                    ApplicationArea = All;
                }
                field("CIT Amount (Month)"; "CIT Amount (Month)")
                {
                    ToolTip = 'Specifies the value of the CIT Amount (Month) field.';
                    ApplicationArea = All;
                }
                field("Total Committed Contribution"; "Total Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Total Committed Contribution field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; "Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump CIT"; "Actual Lumpsump CIT")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump CIT field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump RTF"; "Actual Lumpsump RTF")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump RTF field.';
                    ApplicationArea = All;
                }
                field("Lumpsum Committed Contribution"; "Lumpsum Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Lumpsum Committed Contribution field.';
                    ApplicationArea = All;
                }
                field("CIT Contribution Deposited"; "CIT Contribution Deposited")
                {
                    ToolTip = 'Specifies the value of the CIT Contribution Deposited field.';
                    ApplicationArea = All;
                }
                field("Lumpsum Space Max Benefit"; "Lumpsum Space Max Benefit")
                {
                    ToolTip = 'Specifies the value of the Lumpsum Space Max Benefit field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Open)
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetFilter("Approval Status", '%1|%2', "Approval Status"::" ", "Approval Status"::Open);
                    Rec.FilterGroup(0);
                end;
            }
            action(Screened)
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Screened action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", "Approval Status"::Screened);
                    Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Image = PickLines;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", "Approval Status"::"Pending Approval");
                    Rec.FilterGroup(0);
                end;
            }
            action(ScreenAll)
            {
                Caption = 'Screen All Valid Request';
                Image = ServiceItem;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Screen All Valid Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to screeen all valid retirement funds?') then
                        HRMgt.ScreenAllRetirementFund();
                end;
            }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
}
