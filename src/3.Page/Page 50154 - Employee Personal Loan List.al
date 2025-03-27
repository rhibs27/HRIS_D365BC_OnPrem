page 50154 "Employee Personal Loan List"
{
    CardPageId = "Employee Personal Loan Card";
    DataCaptionFields = "No.", "Employee Code", "Employee Name";
    PageType = List;
    SourceTable = "Employee Loan/Advance";
    SourceTableView = where("Loan Type" = const("Personal Loan"));
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
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                // field("Job Title"; Rec."Job Title")
                // {
                //     ToolTip = 'Specifies the value of the Job Title field.';
                //     ApplicationArea = All;
                // }
                // field("Job Type"; Rec."Job Type")
                // {
                //     ToolTip = 'Specifies the value of the Job Type field.';
                //     ApplicationArea = All;
                // }
                // field(Gender; Rec.Gender)
                // {
                //     ToolTip = 'Specifies the value of the Gender field.';
                //     ApplicationArea = All;
                // }
                // field("Confirmation Service Period"; Rec."Confirmation Service Period")
                // {
                //     ToolTip = 'Specifies the value of the Confirmation Service Period field.';
                //     ApplicationArea = All;
                // }
                // field("Date of Joining"; Rec."Date of Joining")
                // {
                //     ToolTip = 'Specifies the value of the Date of Joining field.';
                //     ApplicationArea = All;
                // }
                // field(Age; Rec.Age)
                // {
                //     ToolTip = 'Specifies the value of the Age field.';
                //     ApplicationArea = All;
                // }
                field("Requested Loan Date"; Rec."Requested Loan Date")
                {
                    ToolTip = 'Specifies the value of the Requested Loan Date field.';
                    ApplicationArea = All;
                }
                // field("Date of Birth"; Rec."Date of Birth")
                // {
                //     ToolTip = 'Specifies the value of the Date of Birth field.';
                //     ApplicationArea = All;
                // }
                // field(Department; Rec.Department)
                // {
                //     ToolTip = 'Specifies the value of the Department field.';
                //     ApplicationArea = All;
                // }
                // field("Screened Date"; Rec."Screened Date")
                // {
                //     ToolTip = 'Specifies the value of the Screened Date field.';
                //     ApplicationArea = All;
                // }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.';
                    ApplicationArea = All;
                }
                // field("Gross Salary"; Rec."Gross Salary")
                // {
                //     ToolTip = 'Specifies the value of the Gross Salary field.';
                //     ApplicationArea = All;
                // }
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
                // field("DBR Ratio"; Rec."DBR Ratio")
                // {
                //     ToolTip = 'Specifies the value of the DBR Ratio field.';
                //     ApplicationArea = All;
                // }
                // field(Recommender; Rec.Recommender)
                // {
                //     ToolTip = 'Specifies the value of the Recommender field.';
                //     ApplicationArea = All;
                // }
                // field(Approver; Rec.Approver)
                // {
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
                //     ToolTip = 'Specifies the value of the Approver Name field.';
                //     ApplicationArea = All;
                // }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
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
                field("Applied Loan"; Rec."Applied Loan/Advance")
                {
                    ToolTip = 'Specifies the value of the Applied Loan/Advance field.';
                    ApplicationArea = All;
                }
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

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
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
                Visible = false;

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
            action("Email Documents")
            {
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Email Documents action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoanMgt.SendReportEmailAfterApproval(Rec);
                end;
            }
            action(Return)
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Return action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Rec.ReOpenDocument(Rec);
                end;
            }
        }
        area(Reporting)
        {
            action("Personal Loan Deed")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ToolTip = 'Executes the Personal Loan Deed action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Personal Loan Deed", true, false, Rec);
                end;
            }
            action("Offer Loan")
            {
                Image = Loaner;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ToolTip = 'Executes the Offer Loan action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Offer Letter Personal Loan", true, false, Rec);
                end;
            }
            action("Guarantee Personal Loan")
            {
                Image = Grid;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ToolTip = 'Executes the Guarantee Personal Loan action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Guarantee Personal Loan", true, false, Rec);
                end;
            }
            action("Promissory Note Personal Loan")
            {
                Image = Loaners;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ToolTip = 'Executes the Promissory Note Personal Loan action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Promissory Note Personal Loan", true, false, Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*FILTERGROUP(2);
        SETFILTER("Approval Status",'<>%1',"Approval Status"::Open);
        FILTERGROUP(0);*/ //Min Commented -- as requested by Sachin.
    end;

    var
        LoanMgt: Codeunit "Loan Mgt.";
}
