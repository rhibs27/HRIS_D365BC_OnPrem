page 50152 "Employee Salary Advance List"
{
    CardPageId = "Employee Salary Advance Card";
    DataCaptionFields = "No.", "Employee Code", "Employee Name";
    PageType = List;
    SourceTable = "Employee Loan/Advance";
    SourceTableView = where("Loan Type" = const("Salary Advance"));
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
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                }
                field("Job Type"; Rec."Job Type")
                {
                    ToolTip = 'Specifies the value of the Job Type field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
                field("Confirmation Service Period"; Rec."Confirmation Service Period")
                {
                    ToolTip = 'Specifies the value of the Confirmation Service Period field.';
                    ApplicationArea = All;
                }
                field("Date of Joining"; Rec."Date of Joining")
                {
                    ToolTip = 'Specifies the value of the Date of Joining field.';
                    ApplicationArea = All;
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.';
                    ApplicationArea = All;
                }
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    Caption = 'Requested Date';
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Purpose of Advance Salary"; Rec."Purpose of Advance Salary")
                {
                    ToolTip = 'Specifies the value of the Purpose of Advance Salary field.';
                    ApplicationArea = All;
                }
                field(FY; Rec.FY)
                {
                    Caption = 'Fiscal Year';
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    ToolTip = 'Specifies the value of the Gross Salary field.';
                    ApplicationArea = All;
                }
                field("Eligible Loan/Advance"; Rec."Eligible Loan/Advance")
                {
                    ToolTip = 'Specifies the value of the Eligible Loan/Advance field.';
                    ApplicationArea = All;
                }
                field("Applied Loan/Advance"; Rec."Applied Loan/Advance")
                {
                    ToolTip = 'Specifies the value of the Applied Loan/Advance field.';
                    ApplicationArea = All;
                }
                field("Payback Months"; Rec."Payback Months")
                {
                    ToolTip = 'Specifies the value of the Payback Months field.';
                    ApplicationArea = All;
                }
                field("DBR Ratio"; Rec."DBR Ratio")
                {
                    ToolTip = 'Specifies the value of the DBR Ratio field.';
                    ApplicationArea = All;
                }
                field("Screened Date"; Rec."Screened Date")
                {
                    ToolTip = 'Specifies the value of the Screened Date field.';
                    ApplicationArea = All;
                }
                // field(Recommender; Rec.Recommender)
                // {
                //     ToolTip = 'Specifies the value of the Recommender field.';
                //     ApplicationArea = All;
                // }
                // field(Approver; Rec.Approver)
                // {
                //     Editable = false;
                //     ToolTip = 'Specifies the value of the Approver field.';
                //     ApplicationArea = All;
                // }
                // field("Recommender Name"; Rec."Recommender Name")
                // {
                //     ToolTip = 'Specifies the value of the Recommender Name field.';
                //     ApplicationArea = All;
                // }
                // field("Approver Name"; Rec."Approver Name")
                // {
                //     Editable = false;
                //     ToolTip = 'Specifies the value of the Approver Name field.';
                //     ApplicationArea = All;
                // }
                field("Screener Remarks"; Rec."Screener Remarks")
                {
                    ToolTip = 'Specifies the value of the Screener Remarks field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field(Screener; Rec.Screener)
                {
                    ToolTip = 'Specifies the value of the Screener field.';
                    ApplicationArea = All;
                }
                field(Settle; Rec.Settled)
                {
                    ToolTip = 'Specifies the value of the Settled field.';
                    ApplicationArea = All;
                }
                field("Settlement Date"; Rec."Settlement Date")
                {
                    ToolTip = 'Specifies the value of the Settlement Date field.';
                    ApplicationArea = All;
                }
                field("Settler User ID"; Rec."Settler User ID")
                {
                    ToolTip = 'Specifies the value of the Settler User ID field.';
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
    }

    actions
    {
        area(Processing)
        {
            action(Open)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
                    Rec.FilterGroup(0);
                end;
            }
            action(Verified)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Verified action.';
                ApplicationArea = All;
                Visible = true;

                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::Screened);
                    // Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Image = PendingApproval;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::"Pending");
                    //SETRANGE(Recommender, HRMgt.GetEmployeeNo());
                    Rec.FilterGroup(0);
                end;
            }
            action(Recommended)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Recommended action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    // Rec.FilterGroup(2);
                    // ClearAll();
                    // Rec.SetRange("Approval Status", Rec."Approval Status"::Recommended);
                    // //SETRANGE(Approver, HRMgt.GetEmployeeNo());
                    // Rec.FilterGroup(0);
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
            action(Settled)
            {
                ToolTip = 'Executes the Settled action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    Rec.SetRange(Settled, true);
                    Rec.FilterGroup(0);
                end;
            }
            action(Return)
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Return action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Rec.ReOpenDocument(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Rec.FilterGroup(2);
        // Rec.SetFilter("Approval Status", '<>%1', Rec."Approval Status"::Open);
        // Rec.FilterGroup(0);
    end;
}
