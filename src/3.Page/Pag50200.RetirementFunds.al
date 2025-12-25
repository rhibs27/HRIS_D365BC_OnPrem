page 50200 "Retirement Funds"
{
    CardPageId = "Retirement Fund Card";
    PageType = List;
    SourceTable = "Retirement Fund";
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;

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
                field("Requested Date"; Rec."Requested Date")
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
                field("Annual Accessible Income"; Rec."Annual Assessable Income")
                {
                    ToolTip = 'Specifies the value of the Annual Accessible Income field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Eligible Amt"; Rec."RF Contribution Eligible Amt")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Eligible Amt field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Deposited"; Rec."Provident Fund Deposited")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Deposited field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Deposited"; Rec."RF Contribution Deposited")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Deposited field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Projected"; Rec."Provident Fund Projected")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Projected field.';
                    ApplicationArea = All;
                }
                field("Actual/Projected Contribution"; Rec."Actual/Projected Contribution")
                {
                    ToolTip = 'Specifies the value of the Actual/Projected Contribution field.';
                    ApplicationArea = All;
                }
                field("Additional Space for RF Cont."; Rec."Additional Space for RF Cont.")
                {
                    ToolTip = 'Specifies the value of the Additional Space for RF Cont. field.';
                    ApplicationArea = All;
                }
                field("RTF Amount (Month)"; Rec."RTF Amount (Month)")
                {
                    ToolTip = 'Specifies the value of the RTF Amount (Month) field.';
                    ApplicationArea = All;
                }
                field("CIT Amount (Month)"; Rec."CIT Amount (Month)")
                {
                    ToolTip = 'Specifies the value of the CIT Amount (Month) field.';
                    ApplicationArea = All;
                }
                field("Total Committed Contribution"; Rec."Total Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Total Committed Contribution field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump CIT"; Rec."Actual Lumpsump CIT")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump CIT field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump RTF"; Rec."Actual Lumpsump RTF")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump RTF field.';
                    ApplicationArea = All;
                }
                field("Lumpsum Committed Contribution"; Rec."Lumpsum Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Lumpsum Committed Contribution field.';
                    ApplicationArea = All;
                }
                field("CIT Contribution Deposited"; Rec."CIT Contribution Deposited")
                {
                    ToolTip = 'Specifies the value of the CIT Contribution Deposited field.';
                    ApplicationArea = All;
                }
                field("Lumpsum Space Max Benefit"; Rec."Lumpsum Space Max Benefit")
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
                    Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
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
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Pending);
                    Rec.FilterGroup(0);
                end;
            }
            action(Approved)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
                    Rec.FilterGroup(0);
                end;
            }
            action(Rejected)
            {
                Image = DeleteQtyToHandle;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Rejected action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Rejected);
                    Rec.FilterGroup(0);
                end;
            }
            action(WithDrawn)
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the withdrawn action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Withdrawn);
                    Rec.FilterGroup(0);
                end;
            }
            action("Clear Filter")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                Image = ClearFilter;
                ToolTip = 'Executes the Clear filter action.';
                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    rec.SetRange("Approval Status");
                    Rec.FilterGroup(0);
                end;
            }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
}
