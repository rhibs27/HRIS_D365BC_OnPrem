page 50199 "HR Manager Role Center"
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
            part(Control32; "Report Inbox Part")
            {
                ApplicationArea = All;
            }
            part(Control33; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(General)
            {
                Caption = 'General';
                group("Employees1")
                {
                    Caption = 'Employees';
                    action("All Employees")
                    {
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Employee List";
                        ToolTip = 'Executes the Employee List action.';
                    }
                    group("As Per Status")
                    {
                        Caption = 'As Per Status';
                        action("Active")
                        {
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee List";
                            RunPageView = where(Status = const(Active));
                            ToolTip = 'Executes the Employee List action.';
                        }
                        action("Inactive")
                        {
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee List";
                            RunPageView = where(Status = const(Inactive));
                            ToolTip = 'Executes the Inactive Employee List action.';
                        }
                        action("Terminated")
                        {
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee List";
                            RunPageView = where(Status = const(Terminated));
                            ToolTip = 'Executes the Terminated Employee List action.';
                        }
                    }
                    group("As Per Employment")
                    {
                        Caption = 'As Per Employment';
                        action("Permanent")
                        {
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee List";
                            RunPageView = where("Employment Type" = filter(Permanent));
                            ToolTip = 'Executes the Regular Employee List action.';
                        }
                        action("Contract")
                        {
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee List";
                            RunPageView = where("Employment Type" = filter(Contract));
                            ToolTip = 'Executes the Contract Employee List action.';
                        }
                        action("Probation")
                        {
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee List";
                            RunPageView = where("Employment Type" = filter(Probation));
                            ToolTip = 'Executes the Probation Employee List action.';
                        }
                        action("Temporary")
                        {
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee List";
                            RunPageView = where("Employment Type" = filter("Temporary"));
                            ToolTip = 'Executes the Probation Employee List action.';
                        }
                    }
                }

            }
            group(Attendance)
            {
                Caption = 'Attendance';
                action("Attendacne Logs")
                {
                    Caption = 'Attendance Logs';
                    ApplicationArea = Basic, Suite;
                    Image = ListPage;
                    RunObject = page "Attendance Logs";
                    ToolTip = 'Executes the action of Attendance Logs';
                }
                action("Employee Attendacne")
                {
                    Caption = 'Attendance Detail';
                    ApplicationArea = Basic, Suite;
                    Image = ListPage;
                    RunObject = page "Employee Attendance & Activity";
                    ToolTip = 'Executes the action of Attendance';
                }
                group(Setup)
                {
                    Caption = 'Setup';
                    action("Attendance Setup")
                    {
                        Caption = 'Attendance Setup';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Attendance Setup";
                        ToolTip = 'Executes the action of Attendance Setup';
                    }

                    action("Employee Work Shift")
                    {
                        Caption = 'Employee Work Shifts';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Employee Work Shift";
                        ToolTip = 'Executes the action of Employee Work Shift';
                    }
                }

            }
            group("Employee Activities")
            {
                Caption = 'Employee Activities';
                group("Leave Request")
                {
                    Caption = 'Leaves';
                    action("Open Leaves")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Leave Requests";
                        RunPageView = where("Approval Status" = filter("Open"));
                        ToolTip = 'Executes the Open Leave Requests action.';
                    }
                    action("Pending Leaves")
                    {
                        Caption = 'Pending';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Leave Requests";
                        RunPageView = where("Approval Status" = filter("Pending"));
                        ToolTip = 'Executes the Pending Approval Leave Requests action.';
                    }
                    action("Approved Leaves")
                    {
                        Caption = 'Approved';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Leave Requests";
                        RunPageView = where("Approval Status" = filter("Approved"));
                        ToolTip = 'Executes the Approved Leave Requests action.';
                    }
                    action("Rejected Leaves")
                    {
                        Caption = 'Rejected';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Leave Requests";
                        RunPageView = where("Approval Status" = filter("Rejected"));
                        ToolTip = 'Executes the Rejected Leave Requests action.';
                    }
                    action("All Leaves")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Leave Requests";
                        ToolTip = 'Executes the All Leave Requests action.';
                    }

                }
                group("Travel Request")
                {
                    Caption = 'Travels';
                    action("Open Travels")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Requests";
                        RunPageView = where(Type = filter("Travel Request"), "Approval Status" = filter("Open"));
                        ToolTip = 'Executes the Open Travel Requests action.';
                    }
                    action("Pending Travels")
                    {
                        Caption = 'Pending';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Requests";
                        RunPageView = where(Type = filter("Travel Request"), "Approval Status" = filter("Pending"));
                        ToolTip = 'Executes the Pending Approval Travel Requests action.';
                    }
                    action("Approved Travels")
                    {
                        Caption = 'Approved';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Requests";
                        RunPageView = where(Type = filter("Travel Request"), "Approval Status" = filter("Approved"));
                        ToolTip = 'Executes the Approved Travel Requests action.';
                    }
                    action("Rejected Travels")
                    {
                        Caption = 'Rejected';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Requests";
                        RunPageView = where(Type = filter("Travel Request"), "Approval Status" = filter("Rejected"));
                        ToolTip = 'Executes the Rejected Travel Requests action.';
                    }
                    action("All Travels")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Requests";
                        RunPageView = where(Type = filter("Travel Request"));
                        ToolTip = 'Executes the All Travel Requests action.';
                    }
                }
                group("Travel Claim Request")
                {
                    Caption = 'Travel Claims';
                    action("Open Travel Claims")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Claim Lists";
                        RunPageView = where(Type = filter("Travel Claim"), "Approval Status" = filter("Open"));
                        ToolTip = 'Executes the Open Travel Claim Requests action.';
                    }
                    action("Pending Travel Claims")
                    {
                        Caption = 'Pending';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Claim Lists";
                        RunPageView = where(Type = filter("Travel Claim"), "Approval Status" = filter("Pending"));
                        ToolTip = 'Executes the Pending Approval Claim Travel Requests action.';
                    }
                    action("Approved Travel Claims")
                    {
                        Caption = 'Approved';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Claim Lists";
                        RunPageView = where(Type = filter("Travel Claim"), "Approval Status" = filter("Approved"));
                        ToolTip = 'Executes the Approved Travel Claim Requests action.';
                    }
                    action("Rejected Travel Claims")
                    {
                        Caption = 'Rejected';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Claim Lists";
                        RunPageView = where(Type = filter("Travel Claim"), "Approval Status" = filter("Rejected"));
                        ToolTip = 'Executes the Rejected Travel Claim Requests action.';
                    }
                    action("All Travel Claims")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Travel Claim Lists";
                        RunPageView = where(Type = filter("Travel Claim"));
                        ToolTip = 'Executes the All Travel Claim Requests action.';
                    }
                }
                group("Overtime Request")
                {
                    Caption = 'Overtimes';
                    group("Individual Overtime Request")
                    {
                        Caption = 'Individual';
                        action("Open Overtime Request")
                        {
                            Caption = 'Open';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtimes";
                            RunPageView = where(Type = filter("Overtime"), "Approval Status" = filter("Open"));
                            ToolTip = 'Executes the Open Overtime Requests action.';
                        }
                        action("Pending Overtime Request")
                        {
                            Caption = 'Pending';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtimes";
                            RunPageView = where(Type = filter("Overtime"), "Approval Status" = filter("Pending"));
                            ToolTip = 'Executes the Pending Overtime Requests action.';
                        }
                        action("Approved Overtime Request")
                        {
                            Caption = 'Approved';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtimes";
                            RunPageView = where(Type = filter("Overtime"), "Approval Status" = filter("Approved"));
                            ToolTip = 'Executes the Approved Overtime Requests action.';
                        }
                        action("Rejected Overtime Request")
                        {
                            Caption = 'Rejected';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtimes";
                            RunPageView = where(Type = filter("Overtime"), "Approval Status" = filter("Rejected"));
                            ToolTip = 'Executes the Rejected Overtime Requests action.';
                        }
                        action("All Overtime Request")
                        {
                            Caption = 'All';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtimes";
                            RunPageView = where(Type = filter("Overtime"), "Approval Status" = filter("Rejected"));
                            ToolTip = 'Executes the All Overtime Requests action.';
                        }
                    }
                    group("Bulk Overtime Request")
                    {
                        Caption = 'Bulk';
                        action("Open Bulk Overtime Request")
                        {
                            Caption = 'Open';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtime Bulk List";
                            RunPageView = where(Type = filter("Overtime Bulk"), "Approval Status" = filter("Open"));
                            ToolTip = 'Executes the Open Bulk Overtime Claim Requests action.';
                        }
                        action("Pending Bulk Overtime Request")
                        {
                            Caption = 'Pending';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtime Bulk List";
                            RunPageView = where(Type = filter("Overtime Bulk"), "Approval Status" = filter("Pending"));
                            ToolTip = 'Executes the Pending Bulk Overtime Requests action.';
                        }
                        action("Approved Bulk Overtime Request")
                        {
                            Caption = 'Approved';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtime Bulk List";
                            RunPageView = where(Type = filter("Overtime Bulk"), "Approval Status" = filter("Approved"));
                            ToolTip = 'Executes the Approved Bulk Overtime Requests action.';
                        }
                        action("Rejected Bulk Overtime Request")
                        {
                            Caption = 'Rejected';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtime Bulk List";
                            RunPageView = where(Type = filter("Overtime Bulk"), "Approval Status" = filter("Rejected"));
                            ToolTip = 'Executes the Rejected Bulk Overtime Requests action.';
                        }
                        action("All Bulk Overtime Request")
                        {
                            Caption = 'All';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Overtime Bulk List";
                            RunPageView = where(Type = filter("Overtime Bulk"));
                            ToolTip = 'Executes the All Bulk Overtime Requests action.';
                        }
                    }
                }
                group("Allowance Assignement")
                {
                    Caption = 'Allowance Assignment';
                    group("Assignment")
                    {
                        Caption = 'Assignment';
                        action("Open Assignment")
                        {
                            Caption = 'Open';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment"), "Approval Status" = filter("Open"));
                            ToolTip = 'Executes the Open Allowance Assignment Requests action.';
                        }
                        action("Pending Assignments")
                        {
                            Caption = 'Pending';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment"), "Approval Status" = filter("Pending"));
                            ToolTip = 'Executes the Pending Allowance Assignment Requests action.';
                        }
                        action("Approved Assignments")
                        {
                            Caption = 'Approved';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment"), "Approval Status" = filter("Approved"));
                            ToolTip = 'Executes the Approved Allowance Assignment Requests action.';
                        }
                        action("Rejected Assignments")
                        {
                            Caption = 'Rejected';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment"), "Approval Status" = filter("Rejected"));
                            ToolTip = 'Executes the Rejected Allowance Assignment Requests action.';
                        }
                        action("All Assignments")
                        {
                            Caption = 'All';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment"));
                            ToolTip = 'Executes the All Allowance Assignment Requests action.';
                        }
                    }
                    group("Claim")
                    {
                        Caption = 'Claim';
                        action("Open Claim")
                        {
                            Caption = 'Open';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments Claim";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment Claim"), "Approval Status" = filter("Open"));
                            ToolTip = 'Executes the Open Allowance Assignments Claim Requests action.';
                        }
                        action("Pending Claim")
                        {
                            Caption = 'Pending';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments Claim";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment Claim"), "Approval Status" = filter("Pending"));
                            ToolTip = 'Executes the Pending Allowance Assignments Claim Requests action.';
                        }
                        action("Approved Claim")
                        {
                            Caption = 'Approved';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments Claim";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment Claim"), "Approval Status" = filter("Approved"));
                            ToolTip = 'Executes the Approved Allowance Assignments Claim Requests action.';
                        }
                        action("Rejected Claim")
                        {
                            Caption = 'Rejected';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments Claim";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment Claim"), "Approval Status" = filter("Rejected"));
                            ToolTip = 'Executes the Rejected Allowance Assignments Claim Requests action.';
                        }
                        action("All Claim")
                        {
                            Caption = 'All';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Allowance Assignments Claim";
                            RunPageView = where("Activity Type" = filter("Allowance Assignment Claim"));
                            ToolTip = 'Executes the All Allowance Assignments Claim Requests action.';
                        }
                    }
                }
                group("EmployeeTransfers")
                {
                    Caption = 'Transfers';
                    group("HR Transfers")
                    {
                        Caption = 'HR  Transfers';
                        action("Open HR Transfers")
                        {
                            Caption = 'Open';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "HR Transfer Requests";
                            RunPageView = where("Type" = filter("HR Transfer"), "Approval Status" = filter("Open"));
                            ToolTip = 'Executes the Open HR Transfer Requests action.';
                        }
                        action("Pending HR Transfers")
                        {
                            Caption = 'Pending';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "HR Transfer Requests";
                            RunPageView = where("Type" = filter("HR Transfer"), "Approval Status" = filter("Pending"));
                            ToolTip = 'Executes the Pending HR Transfer Requests action.';
                        }
                        action("Approved HR Transfers")
                        {
                            Caption = 'Approved';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "HR Transfer Requests";
                            RunPageView = where("Type" = filter("HR Transfer"), "Approval Status" = filter("Approved"));
                            ToolTip = 'Executes the Approved HR Transfer Requests action.';
                        }
                        action("Rejected HR Transfers")
                        {
                            Caption = 'Rejected';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "HR Transfer Requests";
                            RunPageView = where("Type" = filter("HR Transfer"), "Approval Status" = filter("Rejected"));
                            ToolTip = 'Executes the Rejected HR Transfer Requests action.';
                        }
                        action("All HR Transfers")
                        {
                            Caption = 'All';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "HR Transfer Requests";
                            RunPageView = where("Type" = filter("HR Transfer"));
                            ToolTip = 'Executes the All HR Transfer Requests action.';
                        }
                    }
                    group("Employee Transfers")
                    {
                        Caption = 'Employee Transfers';
                        action("Open Employee Transfer")
                        {
                            Caption = 'Open';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee Transfer Requests";
                            RunPageView = where("Type" = filter("Employee Transfer"), "Approval Status" = filter("Open"));
                            ToolTip = 'Executes the Open Employee Transfer Requests action.';
                        }
                        action("Pending Employee Transfer")
                        {
                            Caption = 'Pending';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee Transfer Requests";
                            RunPageView = where("Type" = filter("Employee Transfer"), "Approval Status" = filter("Pending"));
                            ToolTip = 'Executes the Pending Employee Transfer Requests action.';
                        }
                        action("Approved Employee Transfer")
                        {
                            Caption = 'Approved';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee Transfer Requests";
                            RunPageView = where("Type" = filter("Employee Transfer"), "Approval Status" = filter("Approved"));
                            ToolTip = 'Executes the Approved Employee Transfer Requests action.';
                        }
                        action("Rejected Employee Transfer")
                        {
                            Caption = 'Rejected';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee Transfer Requests";
                            RunPageView = where("Type" = filter("Employee Transfer"), "Approval Status" = filter("Rejected"));
                            ToolTip = 'Executes the Rejected Employee Transfer Requests action.';
                        }
                        action("All Employee Transfer")
                        {
                            Caption = 'All';
                            ApplicationArea = Basic, Suite;
                            Image = ListPage;
                            RunObject = page "Employee Transfer Requests";
                            RunPageView = where("Type" = filter("Employee Transfer"));
                            ToolTip = 'Executes the All Employee Transfer Requests action.';
                        }
                    }
                }
                group("Transfer Claim")
                {
                    Caption = 'Transfer Claims';
                    action("Open Transfer Claims")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Employee Transfer Claim";
                        RunPageView = where("Type" = filter("Transfer Claim"), "Approval Status" = filter("Open"));
                        ToolTip = 'Executes the Open Transfer Claim Requests action.';
                    }
                    action("Pending Transfer Claims")
                    {
                        Caption = 'Pending';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Employee Transfer Claim";
                        RunPageView = where("Type" = filter("Transfer Claim"), "Approval Status" = filter("Pending"));
                        ToolTip = 'Executes the Pending Transfer Claim Requests action.';
                    }
                    action("Approved Transfer Claims")
                    {
                        Caption = 'Approved';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Employee Transfer Claim";
                        RunPageView = where("Type" = filter("Transfer Claim"), "Approval Status" = filter("Approved"));
                        ToolTip = 'Executes the Approved Transfer Claim Requests action.';
                    }
                    action("Rejected Transfer Claims")
                    {
                        Caption = 'Rejected';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Employee Transfer Claim";
                        RunPageView = where("Type" = filter("Transfer Claim"), "Approval Status" = filter("Rejected"));
                        ToolTip = 'Executes the Rejected Transfer Claim Requests action.';
                    }
                    action("All Transfer Claims")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Employee Transfer Claim";
                        RunPageView = where("Type" = filter("Transfer Claim"));
                        ToolTip = 'Executes the All Transfer Claim Requests action.';
                    }
                }
            }
            group("Payroll")
            {
                Caption = 'Payroll';
                group("Monthly Payroll Plan")
                {
                    Caption = 'Monthly Payroll';
                    action("Open Payroll")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Payroll Plan List";
                        RunPageView = where("Type" = filter("Payroll"));
                        ToolTip = 'Executes the Payroll Plan action.';
                    }
                    action("Posted Payroll")
                    {
                        Caption = 'Posted';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Posted Payroll Plan List";
                        RunPageView = where("Type" = filter("Payroll"));
                        ToolTip = 'Executes the Posted Payroll Plan action.';
                    }
                }
                group("Adjustment Payroll Plan")
                {
                    Caption = 'Adjustment Plan';
                    action("Open Adjustment Plan")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Payroll Plan List";
                        RunPageView = where("Type" = filter("Adjustment"));
                        ToolTip = 'Executes the Adjustment Payroll Plan action.';
                    }
                    action("Posted Adjustment Payroll")
                    {
                        Caption = 'Posted';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Posted Payroll Plan List";
                        RunPageView = where("Type" = filter("Adjustment"));
                        ToolTip = 'Executes the Posted Adjustment Payroll Plan action.';
                    }


                }
                group("Resignation Payroll Plan")
                {
                    Caption = 'Resignation Plan';
                    action("Open Resignation Plan")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Payroll Plan List";
                        RunPageView = where("Type" = filter("Resignation"));
                        ToolTip = 'Executes the Resignation Payroll Plan action.';
                    }
                    action("Posted Resignation Payroll")
                    {
                        Caption = 'Posted';
                        ApplicationArea = Basic, Suite;
                        Image = ListPage;
                        RunObject = page "Posted Payroll Plan List";
                        RunPageView = where("Type" = filter("Resignation"));
                        ToolTip = 'Executes the Posted Resignation Payroll Plan action.';
                    }
                }
            }
            group(Requests)
            {
                action("Request To Approve")
                {
                    Caption = 'Request To Approve';
                    ApplicationArea = Basic, Suite;
                    Image = ListPage;
                    RunObject = page "Request to Approve HRIS";
                    ToolTip = 'Executes the Request To Approve action.';
                }
            }
            group("HR Journals")
            {

            }
        }
        area(embedding)
        {
            // action("Employee Lite")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Image = List;
            //     ToolTip = 'Executes the Employee Lite action.';
            // }
            action("Employee Attendance Activity")
            {
                ApplicationArea = Basic, Suite;
                Image = List;
                RunObject = page "Employee Attendance & Activity";
                ToolTip = 'Executes the Employee Attendance Activity action.';
            }
            action("Adjustment Plan List")
            {
                ApplicationArea = Basic, Suite;
                Image = List;
                RunObject = page "Adjustment Plan List";
                ToolTip = 'Executes the Adjustment Plan List action.';
            }
            action("Leave Requests")
            {
                Image = MiniForm;
                RunObject = page "Leave Requests";
                Visible = LeaveVisibility;
                ToolTip = 'Executes the Leave Requests action.';
                ApplicationArea = All;
            }
            action("Travel Requests")
            {
                Image = Travel;
                RunObject = page "Travel Requests";
                Visible = TravelVisibility;
                ToolTip = 'Executes the Travel Requests action.';
                ApplicationArea = All;
            }
            action("Travel Claims")
            {
                Image = Check;
                RunObject = page "Travel Claim Lists";
                Visible = TravelVisibility;
                ToolTip = 'Executes the Travel Claims action.';
                ApplicationArea = All;
            }
            action(Transfers)
            {
                Image = TransferReceipt;
                RunObject = page "Employee Transfer Requests";
                Visible = TransferVisibility;
                ToolTip = 'Executes the Transfers action.';
                ApplicationArea = All;
            }
            action(Overtimes)
            {
                Image = PhysicalInventory;
                RunObject = page Overtimes;
                Visible = OvertimeVisibility;
                ToolTip = 'Executes the Overtimes action.';
                ApplicationArea = All;
            }
            action("Bulk Cash Transfers")
            {
                Image = CashFlow;
                RunObject = page "Bulk Cash";
                Visible = BulkCashVisibility;
                ToolTip = 'Executes the Bulk Cash Transfers action.';
                ApplicationArea = All;
            }
            action(Resignations)
            {
                Image = BookingsLogo;
                RunObject = page "Resignation List";
                Visible = Resignationvisibility;
                ToolTip = 'Executes the Resignations action.';
                ApplicationArea = All;
            }
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
        area(Reporting)
        {
            group("HRIS Reports")
            {
                action("Employee Leave Balance")
                {
                    Image = AllLines;
                    RunObject = report "Employee Leave Balance";
                    ToolTip = 'Executes the Employee Leave Balance action.';
                    ApplicationArea = All;
                }
                action("Transfer Reports")
                {
                    Image = "Report";
                    RunObject = report "Transfer Reports";
                    ToolTip = 'Executes the Transfer Reports action.';
                    ApplicationArea = All;
                }
                action("HRIS Report - All Staff")
                {
                    Image = "Report";
                    RunObject = report "HRIS Report - All Staff";
                    ToolTip = 'Executes the HRIS Report - All Staff action.';
                    ApplicationArea = All;
                }
                action("HRIS Report - Service Period")
                {
                    Image = "Report";
                    RunObject = report "HRIS Report - Service Period";
                    ToolTip = 'Executes the HRIS Report - Service Period action.';
                    ApplicationArea = All;
                }
                action("Employee All Leave Balance")
                {
                    Image = "Report";
                    RunObject = report "Employee All Leave Balance";
                    ToolTip = 'Executes the Employee All Leave Balance action.';
                    ApplicationArea = All;
                }
                action("Employee Profile Details Report")
                {
                    Image = "Report";
                    RunObject = report "Employee Profile Details";
                    ToolTip = 'Executes the Employee Profile Details Report action.';
                    ApplicationArea = All;
                }
                action("Employee Appraisal Report")
                {
                    Image = "Report";
                    RunObject = report "Appraisal Check Review Report";
                    ToolTip = 'Executes the Employee Appraisal Report action.';
                    ApplicationArea = All;
                }
            }
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
            group("HR Reports")
            {
                action("Extra Mileage Calculation Report")
                {
                    Image = "Report";
                    RunObject = report "Overtime Calculation Report";
                    ToolTip = 'Executes the Extra Overtime Calculation Report action.';
                    ApplicationArea = All;
                }
                action("Training Attendance Report")
                {
                    Image = "Report";
                    RunObject = report "Training Attendance Report";
                    ToolTip = 'Executes the Training Attendance Report action.';
                    ApplicationArea = All;
                }
                action("Salary Certificate Regular")
                {
                    Image = AllLines;
                    RunObject = report "Salary certificate (regular)";
                    ToolTip = 'Executes the Salary Certificate Regular action.';
                    ApplicationArea = All;
                }
                action("Salary Certificate Contract")
                {
                    Image = AllLines;
                    RunObject = report "Salary certificate (contract)";
                    ToolTip = 'Executes the Salary Certificate Contract action.';
                    ApplicationArea = All;
                }
                action("Salary Certificate Probation")
                {
                    Image = AllLines;
                    RunObject = report "Sal Cert (Probation)";
                    ToolTip = 'Executes the Salary Certificate Probation action.';
                    ApplicationArea = All;
                }
                action("Annual Certificate Regular")
                {
                    Image = AllLines;
                    RunObject = report "Annual Salary Certificate(reg)";
                    ToolTip = 'Executes the Annual Certificate Regular action.';
                    ApplicationArea = All;
                }
                action("Annual Certificate Probation")
                {
                    Image = AllLines;
                    RunObject = report "Annual Salary Certificate(pro)";
                    ToolTip = 'Executes the Annual Certificate Probation action.';
                    ApplicationArea = All;
                }
                action("Sal Certie Incl Vehicle Allo")
                {
                    Caption = 'Salary Certificate Including Vehicle Allowance';
                    Image = AllLines;
                    RunObject = report "Salary certi(inc vehicle allo)";
                    ToolTip = 'Executes the Salary Certificate Including Vehicle Allowance action.';
                    ApplicationArea = All;
                }
                action("Experience Letter regular")
                {
                    Caption = 'Experience Letter (Regular)';
                    Image = AllLines;
                    RunObject = report "Experience letter (Regular)";
                    ToolTip = 'Executes the Experience Letter (Regular) action.';
                    ApplicationArea = All;
                }
                action("Experience Letter with Fun Title")
                {
                    Caption = 'Experience Letter with Functional Title Regular';
                    Image = AllLines;
                    RunObject = report "Exp letter functional title";
                    ToolTip = 'Executes the Experience Letter with Functional Title Regular action.';
                    ApplicationArea = All;
                }
                action("Experience Letter Probation")
                {
                    Caption = 'Experience Letter Probation';
                    Image = AllLines;
                    RunObject = report "Experience letter(prob)";
                    ToolTip = 'Executes the Experience Letter Probation action.';
                    ApplicationArea = All;
                }
                action("Exp Letter with Fun Title Prob")
                {
                    Caption = 'Experience Letter with Functional Title Probation';
                    Image = AllLines;
                    RunObject = report "Exp letter funcl title(prob)";
                    ToolTip = 'Executes the Experience Letter with Functional Title Probation action.';
                    ApplicationArea = All;
                }
                action("Experience Letter Contract")
                {
                    Caption = 'Expericence Letter Contract';
                    Image = AllLines;
                    RunObject = report "Exp letter work(contract)";
                    ToolTip = 'Executes the Expericence Letter Contract action.';
                    ApplicationArea = All;
                }
                action("Sal Cert Reg Staff (ForCurr)")
                {
                    Caption = 'Salary Certificate Regular Staff (ForCurr)';
                    Image = AllLines;
                    RunObject = report "Salary certificate (reg-Forei)";
                    ToolTip = 'Executes the Salary Certificate Regular Staff (ForCurr) action.';
                    ApplicationArea = All;
                }
                action("Sal Cert Pro Staff (ForCurr)")
                {
                    Caption = 'Salary Certificate Probation Staff (ForCurr)';
                    Image = AllLines;
                    RunObject = report "Salary certificate (Prob-Fore)";
                    ToolTip = 'Executes the Salary Certificate Probation Staff (ForCurr) action.';
                    ApplicationArea = All;
                }
                action("Annual Salary Cert Reg (ForCurr)")
                {
                    Caption = 'Annual Salary Cert Reg (ForCurr)';
                    Image = AllLines;
                    RunObject = report "Annual Sal Cert(reg-Foreign)";
                    ToolTip = 'Executes the Annual Salary Cert Reg (ForCurr) action.';
                    ApplicationArea = All;
                }
                action("Annual Sal Cert prob (ForCurr)")
                {
                    Caption = 'Annual Salary Cert Prob (ForCurr)';
                    Image = AllLines;
                    RunObject = report "Annual Sal Cert(pro-Foreign)";
                    ToolTip = 'Executes the Annual Salary Cert Prob (ForCurr) action.';
                    ApplicationArea = All;
                }
                action("Sal Certie Incl Vehicle AlloForCurr")
                {
                    Caption = 'Salary Certificate Including Vehicle Allowance (ForCurr)';
                    Image = AllLines;
                    RunObject = report "Sal Cert veh Allownce(Foreign)";
                    ToolTip = 'Executes the Salary Certificate Including Vehicle Allowance (ForCurr) action.';
                    ApplicationArea = All;
                }
                action("No Objection Letter Regular")
                {
                    Caption = 'No Objection Letter';
                    Image = AllLines;
                    RunObject = report "No objection letter(reg)";
                    ToolTip = 'Executes the No Objection Letter action.';
                    ApplicationArea = All;
                }
                action("No Objection Letter Probation")
                {
                    Caption = 'No Objection Letter Probation';
                    Image = AllLines;
                    RunObject = report "No objection letter(pro)";
                    ToolTip = 'Executes the No Objection Letter Probation action.';
                    ApplicationArea = All;
                }
                action("No Objection Letter Loan Used")
                {
                    Caption = 'No Objection Letter Loan Used';
                    Image = AllLines;
                    RunObject = report "No objection letter";
                    ToolTip = 'Executes the No Objection Letter Loan Used action.';
                    ApplicationArea = All;
                }
                action("Leave Approve Letter")
                {
                    Caption = 'Leave Approve Letter';
                    Image = AllLines;
                    RunObject = report "Leave Approve Letter";
                    ToolTip = 'Executes the Leave Approve Letter action.';
                    ApplicationArea = All;
                }
                action("Leave Balance Letter")
                {
                    Caption = 'Leave balance Letter';
                    Image = AllLines;
                    RunObject = report "Leave Balance Letter";
                    ToolTip = 'Executes the Leave balance Letter action.';
                    ApplicationArea = All;
                }
                action("TDS Cert of Reg Employee")
                {
                    Caption = 'TDS certificate of Regular Employee';
                    Image = AllLines;
                    RunObject = report "TDS cert reg emp";
                    ToolTip = 'Executes the TDS certificate of Regular Employee action.';
                    ApplicationArea = All;
                }
                action("TDS Cert of Retire Reg Emp")
                {
                    Caption = 'TDS certificate of Retire Regular Employee';
                    Image = AllLines;
                    RunObject = report "TDS cert Retire reg emp";
                    ToolTip = 'Executes the TDS certificate of Retire Regular Employee action.';
                    ApplicationArea = All;
                }
                action("TDS Cert of  Prob Emp")
                {
                    Caption = 'TDS certificate of Employee under Probation';
                    Image = AllLines;
                    RunObject = report "TDS cert Probation emp";
                    ToolTip = 'Executes the TDS certificate of Employee under Probation action.';
                    ApplicationArea = All;
                }
                action("TDS Cert of Retire Prob Emp")
                {
                    Caption = 'TDS certificate of Retire Prob Employee';
                    Image = AllLines;
                    RunObject = report "TDS cert retire probation emp";
                    ToolTip = 'Executes the TDS certificate of Retire Prob Employee action.';
                    ApplicationArea = All;
                }
                action("TDS Cert of Contract Emp")
                {
                    Caption = 'TDS certificate of Contract Employee';
                    Image = AllLines;
                    RunObject = report "TDS cert Contract emp";
                    ToolTip = 'Executes the TDS certificate of Contract Employee action.';
                    ApplicationArea = All;
                }
                action("TDS Cert of Retire Contr Emp")
                {
                    Caption = 'TDS certificate of Retire Contract Employee';
                    Image = AllLines;
                    RunObject = report "TDS cert Retire Contract emp";
                    ToolTip = 'Executes the TDS certificate of Retire Contract Employee action.';
                    ApplicationArea = All;
                }
                action("TAX Clearance Letter To IRD")
                {
                    Caption = 'TAX Clearance Letter To IRD';
                    Image = AllLines;
                    RunObject = report "Tax Clearance Letter";
                    ToolTip = 'Executes the TAX Clearance Letter To IRD action.';
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
