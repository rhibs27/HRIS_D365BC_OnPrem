page 50072 "Emp. Staff Social Loan Lists"
{
    ApplicationArea = All;
    InsertAllowed = false;
    ModifyAllowed = false;
    Caption = 'Emp. Staff Social Loan Lists';
    PageType = List;
    SourceTable = "Employee Loan/Advance";
    UsageCategory = Lists;
    CardPageId = "Emp Staff Social Loan Card";
    SourceTableView = sorting("No.") order(descending) where("Loan Type" = const("Staff Social Loan"));


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field(Settled; Rec.Settled)
                {
                    ToolTip = 'Specifies the value of the Settled field.';
                }
                field(Disbursed; Rec.Disbursed)
                {
                    ToolTip = 'Specifies the value of the Disbursed field.';
                }
            }
        }
    }
}
