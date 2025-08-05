page 50347 "HR Payroll Manager"
{
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Control5; "Headline RC Order Processor")
            {
                ApplicationArea = Basic, Suite;
            }
            group("HRMS")
            {

                part("HR Overview"; "HR Overview")
                {
                    Caption = 'HR Overview';
                    ApplicationArea = All;
                }
                // part("loan & Advance"; "Loan & Advance cues")
                // {
                //     Caption = 'Loan & Advance Details';
                //     ApplicationArea = All;
                // }
            }
            part(HRCue; "HR Cue")
            {
                Caption = 'HR Activities';
                ApplicationArea = All;
            }


            part(Control15; "Employee Leave Days-HR Cue")
            {
                Visible = false;
                ApplicationArea = All;
            }
            // part(Control32; "Report Inbox Part")
            // {
            //     ApplicationArea = All;
            // }
            part(Control33; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

        area(Reporting)
        {

            group("Payroll Reports")
            {
                action("Salary Sheet Monthwise")
                {
                    Image = "Report";
                    RunObject = report "Salary Sheet Monthwise";
                    ToolTip = 'Executes the Salary Sheet Monthwise action.';
                    ApplicationArea = All;
                }
                action("Salary Sheet Documentwise")
                {
                    Image = "Report";
                    RunObject = report "Salary Sheet Doc Monthwise";
                    ToolTip = 'Executes the Salary Sheet Documentwise action.';
                    ApplicationArea = All;
                }
                action("Tax Deduction Info")
                {
                    Image = "Report";
                    RunObject = report "Tax Deduction Information";
                    ToolTip = 'Executes the Tax Deduction Info action.';
                    ApplicationArea = All;
                }
                action("TDS Deposit Record")
                {
                    Image = "Report";
                    RunObject = report "TDS Deposit Record";
                    ToolTip = 'Executes the TDS Deposit Record action.';
                    ApplicationArea = All;
                }
                action("Tax Audit Sheet")
                {
                    Image = "Report";
                    RunObject = report "Tax Audit Sheet";
                    ToolTip = 'Executes the Tax Audit Sheet action.';
                    ApplicationArea = All;
                }
                action("Employee Tax Info Details")
                {
                    Image = "Report";
                    RunObject = report "Employee Tax Info Detail";
                    ToolTip = 'Executes the Employee Tax Info Details action.';
                    ApplicationArea = All;
                }
                action("Payroll Details")
                {
                    Image = "Report";
                    RunObject = report "Payroll Details";
                    ToolTip = 'Executes the Payroll Details action.';
                    ApplicationArea = All;
                }
                action("Payroll Detail Yearly Report")
                {
                    Image = "Report";
                    RunObject = report "Payroll Details Yearly";
                    ToolTip = 'Executes the Payroll Detail Yearly Report action.';
                    ApplicationArea = All;
                }
                action("Tax Details For IRD monthly")
                {
                    Image = "Report";
                    RunObject = report "Tax Detail For IRD Monthly";
                    ToolTip = 'Executes the Tax Details For IRD monthly action.';
                    ApplicationArea = All;
                }
                action("Employee TDS Certificate")
                {
                    ToolTip = 'Executes the Employee TDS Certificate action.';
                    ApplicationArea = All;
                }
                action("TDS Withholding Certificate")
                {
                    Image = "Report";
                    RunObject = report "TDS WithHolding Cert";
                    ToolTip = 'Executes the TDS Withholding Certificate action.';
                    ApplicationArea = All;
                }
                action("Income and Tax Calculation")
                {
                    Caption = 'Income and Tax Calculation Details';
                    Image = "Report";
                    RunObject = report "Income Tax and Details";
                    ToolTip = 'Executes the Income and Tax Calculation Details action.';
                    ApplicationArea = All;
                }
                action("Posted Payroll Summary")
                {
                    Image = "Report";
                    RunObject = report "Posted Payroll Summary";
                    ToolTip = 'Executes the Posted Payroll Summary action.';
                    ApplicationArea = All;
                }
            }

        }
    }

    var
        UserSetup: Record "User Setup";
        LeaveVisibility: Boolean;
        TravelVisibility: Boolean;
        TransferVisibility: Boolean;
        BulkCashVisibility: Boolean;
        OvertimeVisibility: Boolean;
        Resignationvisibility: Boolean;
        SalaryAdvVisibility: Boolean;
}
