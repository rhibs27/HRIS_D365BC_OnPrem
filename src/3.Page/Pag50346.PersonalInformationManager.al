page 50346 "Personal Information Manager"
{
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
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
        area(embedding)
        {
            action(Employees)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employees';
                Image = List;
                RunObject = page "Employee List";
                ToolTip = 'Executes the Employees action.';
            }
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
            // action("Bulk Cash Transfers")
            // {
            //     Image = CashFlow;
            //     RunObject = page "Bulk Cash";
            //     Visible = BulkCashVisibility;
            //     ToolTip = 'Executes the Bulk Cash Transfers action.';
            //     ApplicationArea = All;
            // }
            action(Resignations)
            {
                Image = BookingsLogo;
                RunObject = page "Resignation List";
                Visible = Resignationvisibility;
                ToolTip = 'Executes the Resignations action.';
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
            }

            group("HR Reports")
            {
                action("Extra Mileage Calculation Report")
                {
                    Image = "Report";
                    RunObject = report "Overtime Calculation Report";
                    ToolTip = 'Executes the Extra Mileage Calculation Report action.';
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
        LeaveVisibility: Boolean;
        TravelVisibility: Boolean;
        TransferVisibility: Boolean;
        OvertimeVisibility: Boolean;
        Resignationvisibility: Boolean;
}
