page 50345 "HR loan officer"
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
                part("loan & Advance"; "Loan & Advance cues")
                {
                    Caption = 'Loan & Advance Details';
                    ApplicationArea = All;
                }
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
            group("Loans Reports")
            {
                action("Salary Advances")
                {
                    Image = Payment;
                    RunObject = page "Employee Salary Advance List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Salary Advances action.';
                    ApplicationArea = All;
                }
                action("Personal Loans")
                {
                    Image = Loaners;
                    RunObject = page "Employee Personal Loan List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Personal Loans action.';
                    ApplicationArea = All;
                }
                action("Home Loans")
                {
                    Image = AddToHome;
                    RunObject = page "Employee Home Loan List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Home Loans action.';
                    ApplicationArea = All;
                }
                action("Vehicle Loans")
                {
                    Image = CalculateShipment;
                    RunObject = page "Employee Vehicle Loan List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Vehicle Loans action.';
                    ApplicationArea = All;
                }
                action("Change Reviewer Emp Attendance")
                {
                    Caption = 'Change Reviewer Emp Attendance';
                    Image = CalculateShipment;
                    RunObject = page "Employee Attendance & Activity";
                    ToolTip = 'Executes the Change Reviewer Emp Attendance action.';
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

    // procedure Setvisibility()
    // begin
    //     UserSetup.Reset;
    //     UserSetup.SetRange("User ID", UserId);
    //     if UserSetup.FindFirst then begin
    //         LeaveVisibility := UserSetup."For Leave-Dashboard";
    //         TravelVisibility := UserSetup."For Travel-Dashboard";
    //         TransferVisibility := UserSetup."For Transfer-Dashboard";
    //         OvertimeVisibility := UserSetup."For Overtime-Dashboard";
    //         BulkCashVisibility := UserSetup."For BulkCash-Dashboard";
    //         Resignationvisibility := UserSetup."For Resignation-Dashboard";
    //         SalaryAdvVisibility := UserSetup."For Salary Advance";
    //     end;
    // end;
}
