page 50399 "Loan Settlement List"
{
    Caption = 'Loan Settlement List';
    PageType = List;
    SourceTable = "Loan Settlement";
    ApplicationArea = All;
    CardPageId = "Loan Settlement Card";
    Editable = false;
    SourceTableView = sorting("No.") order(descending);
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the settlement document number.';
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the source loan document number.';
                    ApplicationArea = All;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the loan type.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the employee number.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the employee name.';
                    ApplicationArea = All;
                }
                field("Settlement Request Date"; Rec."Settlement Request Date")
                {
                    ToolTip = 'Specifies the settlement request date.';
                    ApplicationArea = All;
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ToolTip = 'Specifies whether Full or Partial settlement.';
                    ApplicationArea = All;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ToolTip = 'Specifies the outstanding loan balance.';
                    ApplicationArea = All;
                }
                field("Settlement Amount"; Rec."Settlement Amount")
                {
                    ToolTip = 'Specifies the amount to be settled.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the current approval status.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the branch.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the department.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the fiscal year.';
                    ApplicationArea = All;
                }
                field("Settled Date"; Rec."Settled Date")
                {
                    ToolTip = 'Specifies the date the loan was settled.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
