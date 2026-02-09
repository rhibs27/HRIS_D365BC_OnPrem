page 50159 "Employee Home Loan List"
{
    CardPageId = "Employee Home Loan Card";
    DataCaptionFields = "No.", "Employee No.", "Employee Name";
    PageType = List;
    SourceTable = "Employee Loan/Advance";
    SourceTableView = where("Loan Type" = const("Home Loan"));
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
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    ToolTip = 'Specifies the value of the Requested Loan Date field.';
                    ApplicationArea = All;
                }

                field("Insurance Tieup"; Rec."Insurance Tieup")
                {
                    ToolTip = 'Specifies the value of the Insurance Tieup field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field(Settled; Rec.Settled)
                {
                    ToolTip = 'Specifies the value of the Settled field.';
                    ApplicationArea = All;
                }
                field("Settlement Date"; Rec."Settlement Date")
                {
                    ToolTip = 'Specifies the value of the Settlement Date field.';
                    ApplicationArea = All;
                }
                field(Disbursed; Rec.Disbursed)
                {
                    ToolTip = 'Specifies the value of the Disbursed field.';
                    ApplicationArea = All;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control26; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control27; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(Open)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;
                Image = Open;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
                    Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;
                Image = PendingApproval;
                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::"Pending");
                    Rec.FilterGroup(0);
                end;
            }
            action(Approved)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approved action.';
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
                PromotedCategory = Process;
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
}
