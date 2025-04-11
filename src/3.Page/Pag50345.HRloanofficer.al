page 50345 "HR loan officer"
{
    PageType = RoleCenter;
    PromotedActionCategories = 'New,Process,Report,Employee Activity,Employee Loan';
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
        area(embedding)
        {
            // action("Salary Advances")
            // {
            //     Image = Payment;
            //     Promoted = true;
            //     PromotedCategory = Category5;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     RunObject = page "Employee Salary Advance List";
            //     Visible = SalaryAdvVisibility;
            //     ToolTip = 'Executes the Salary Advances action.';
            //     ApplicationArea = All;
            // }
            // action("Personal Loans")
            // {
            //     Image = Loaners;
            //     Promoted = true;
            //     PromotedCategory = Category5;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     RunObject = page "Employee Personal Loan List";
            //     Visible = SalaryAdvVisibility;
            //     ToolTip = 'Executes the Personal Loans action.';
            //     ApplicationArea = All;
            // }
            // action("Home Loans")
            // {
            //     Image = AddToHome;
            //     Promoted = true;
            //     PromotedCategory = Category5;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     RunObject = page "Employee Home Loan List";
            //     Visible = SalaryAdvVisibility;
            //     ToolTip = 'Executes the Home Loans action.';
            //     ApplicationArea = All;
            // }
            // action("Vehicle Loans")
            // {
            //     Image = CalculateShipment;
            //     Promoted = true;
            //     PromotedCategory = Category5;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     RunObject = page "Employee Vehicle Loan List";
            //     Visible = SalaryAdvVisibility;
            //     ToolTip = 'Executes the Vehicle Loans action.';
            //     ApplicationArea = All;
            // }
            // action("Change Reviewer Emp Attendance")
            // {
            //     Caption = 'Change Reviewer Emp Attendance';
            //     Image = CalculateShipment;
            //     Promoted = true;
            //     PromotedCategory = Category5;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     RunObject = page "Employee Attendance & Activity";
            //     ToolTip = 'Executes the Change Reviewer Emp Attendance action.';
            //     ApplicationArea = All;
            // }
        }
        area(Reporting)
        {
            group("Loans Reports")
            {
                action("Salary Advances")
                {
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Employee Salary Advance List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Salary Advances action.';
                    ApplicationArea = All;
                }
                action("Personal Loans")
                {
                    Image = Loaners;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Employee Personal Loan List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Personal Loans action.';
                    ApplicationArea = All;
                }
                action("Home Loans")
                {
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Employee Home Loan List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Home Loans action.';
                    ApplicationArea = All;
                }
                action("Vehicle Loans")
                {
                    Image = CalculateShipment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Employee Vehicle Loan List";
                    Visible = SalaryAdvVisibility;
                    ToolTip = 'Executes the Vehicle Loans action.';
                    ApplicationArea = All;
                }
                action("Change Reviewer Emp Attendance")
                {
                    Caption = 'Change Reviewer Emp Attendance';
                    Image = CalculateShipment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Employee Attendance & Activity";
                    ToolTip = 'Executes the Change Reviewer Emp Attendance action.';
                    ApplicationArea = All;
                }
            }
            //     group("Payroll Reports")
            //     {
            //         action("Salary Sheet Monthwise")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Salary Sheet Monthwise";
            //             ToolTip = 'Executes the Salary Sheet Monthwise action.';
            //             ApplicationArea = All;
            //         }
            //         action("Salary Sheet Documentwise")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Salary Sheet Doc Monthwise";
            //             ToolTip = 'Executes the Salary Sheet Documentwise action.';
            //             ApplicationArea = All;
            //         }
            //         action("Tax Deduction Info")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             RunObject = report "Tax Deduction Information";
            //             ToolTip = 'Executes the Tax Deduction Info action.';
            //             ApplicationArea = All;
            //         }
            //         action("TDS Deposit Record")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "TDS Deposit Record";
            //             ToolTip = 'Executes the TDS Deposit Record action.';
            //             ApplicationArea = All;
            //         }
            //         action("Tax Audit Sheet")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Tax Audit Sheet";
            //             ToolTip = 'Executes the Tax Audit Sheet action.';
            //             ApplicationArea = All;
            //         }
            //         action("Employee Tax Info Details")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Employee Tax Info Detail";
            //             ToolTip = 'Executes the Employee Tax Info Details action.';
            //             ApplicationArea = All;
            //         }
            //         action("Payroll Details")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Payroll Details";
            //             ToolTip = 'Executes the Payroll Details action.';
            //             ApplicationArea = All;
            //         }
            //         action("Payroll Detail Yearly Report")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Payroll Details Yearly";
            //             ToolTip = 'Executes the Payroll Detail Yearly Report action.';
            //             ApplicationArea = All;
            //         }
            //         action("Tax Details For IRD monthly")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Tax Detail For IRD Monthly";
            //             ToolTip = 'Executes the Tax Details For IRD monthly action.';
            //             ApplicationArea = All;
            //         }
            //         action("Employee TDS Certificate")
            //         {
            //             ToolTip = 'Executes the Employee TDS Certificate action.';
            //             ApplicationArea = All;
            //         }
            //         action("TDS Withholding Certificate")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "TDS WithHolding Cert";
            //             ToolTip = 'Executes the TDS Withholding Certificate action.';
            //             ApplicationArea = All;
            //         }
            //         action("Income and Tax Calculation")
            //         {
            //             Caption = 'Income and Tax Calculation Details';
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Income Tax and Details";
            //             ToolTip = 'Executes the Income and Tax Calculation Details action.';
            //             ApplicationArea = All;
            //         }
            //         action("Posted Payroll Summary")
            //         {
            //             Image = "Report";
            //             Promoted = true;
            //             PromotedCategory = "Report";
            //             PromotedIsBig = true;
            //             PromotedOnly = true;
            //             RunObject = report "Posted Payroll Summary";
            //             ToolTip = 'Executes the Posted Payroll Summary action.';
            //             ApplicationArea = All;
            //         }
            //     }
            // group("HR Reports")
            // {
            //     action("Extra Mileage Calculation Report")
            //     {
            //         Image = "Report";
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Extramileage Calculation Repor";
            //         ToolTip = 'Executes the Extra Mileage Calculation Report action.';
            //         ApplicationArea = All;
            //     }
            //     action("Training Attendance Report")
            //     {
            //         Image = "Report";
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Training Attendance Report";
            //         ToolTip = 'Executes the Training Attendance Report action.';
            //         ApplicationArea = All;
            //     }
            //     action("Salary Certificate Regular")
            //     {
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Salary certificate (regular)";
            //         ToolTip = 'Executes the Salary Certificate Regular action.';
            //         ApplicationArea = All;
            //     }
            //     action("Salary Certificate Contract")
            //     {
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Salary certificate (contract)";
            //         ToolTip = 'Executes the Salary Certificate Contract action.';
            //         ApplicationArea = All;
            //     }
            //     action("Salary Certificate Probation")
            //     {
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Sal Cert (Probation)";
            //         ToolTip = 'Executes the Salary Certificate Probation action.';
            //         ApplicationArea = All;
            //     }
            //     action("Annual Certificate Regular")
            //     {
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Annual Salary Certificate(reg)";
            //         ToolTip = 'Executes the Annual Certificate Regular action.';
            //         ApplicationArea = All;
            //     }
            //     action("Annual Certificate Probation")
            //     {
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Annual Salary Certificate(pro)";
            //         ToolTip = 'Executes the Annual Certificate Probation action.';
            //         ApplicationArea = All;
            //     }
            //     action("Sal Certie Incl Vehicle Allo")
            //     {
            //         Caption = 'Salary Certificate Including Vehicle Allowance';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Salary certi(inc vehicle allo)";
            //         ToolTip = 'Executes the Salary Certificate Including Vehicle Allowance action.';
            //         ApplicationArea = All;
            //     }
            //     action("Experience Letter regular")
            //     {
            //         Caption = 'Experience Letter (Regular)';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Experience letter (Regular)";
            //         ToolTip = 'Executes the Experience Letter (Regular) action.';
            //         ApplicationArea = All;
            //     }
            //     action("Experience Letter with Fun Title")
            //     {
            //         Caption = 'Experience Letter with Functional Title Regular';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Exp letter functional title";
            //         ToolTip = 'Executes the Experience Letter with Functional Title Regular action.';
            //         ApplicationArea = All;
            //     }
            //     action("Experience Letter Probation")
            //     {
            //         Caption = 'Experience Letter Probation';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Experience letter(prob)";
            //         ToolTip = 'Executes the Experience Letter Probation action.';
            //         ApplicationArea = All;
            //     }
            //     action("Exp Letter with Fun Title Prob")
            //     {
            //         Caption = 'Experience Letter with Functional Title Probation';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Exp letter funcl title(prob)";
            //         ToolTip = 'Executes the Experience Letter with Functional Title Probation action.';
            //         ApplicationArea = All;
            //     }
            //     action("Experience Letter Contract")
            //     {
            //         Caption = 'Expericence Letter Contract';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Exp letter work(contract)";
            //         ToolTip = 'Executes the Expericence Letter Contract action.';
            //         ApplicationArea = All;
            //     }
            //     action("Sal Cert Reg Staff (ForCurr)")
            //     {
            //         Caption = 'Salary Certificate Regular Staff (ForCurr)';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Salary certificate (reg-Forei)";
            //         ToolTip = 'Executes the Salary Certificate Regular Staff (ForCurr) action.';
            //         ApplicationArea = All;
            //     }
            //     action("Sal Cert Pro Staff (ForCurr)")
            //     {
            //         Caption = 'Salary Certificate Probation Staff (ForCurr)';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Salary certificate (Prob-Fore)";
            //         ToolTip = 'Executes the Salary Certificate Probation Staff (ForCurr) action.';
            //         ApplicationArea = All;
            //     }
            //     action("Annual Salary Cert Reg (ForCurr)")
            //     {
            //         Caption = 'Annual Salary Cert Reg (ForCurr)';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Annual Sal Cert(reg-Foreign)";
            //         ToolTip = 'Executes the Annual Salary Cert Reg (ForCurr) action.';
            //         ApplicationArea = All;
            //     }
            //     action("Annual Sal Cert prob (ForCurr)")
            //     {
            //         Caption = 'Annual Salary Cert Prob (ForCurr)';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Annual Sal Cert(pro-Foreign)";
            //         ToolTip = 'Executes the Annual Salary Cert Prob (ForCurr) action.';
            //         ApplicationArea = All;
            //     }
            //     action("Sal Certie Incl Vehicle AlloForCurr")
            //     {
            //         Caption = 'Salary Certificate Including Vehicle Allowance (ForCurr)';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Sal Cert veh Allownce(Foreign)";
            //         ToolTip = 'Executes the Salary Certificate Including Vehicle Allowance (ForCurr) action.';
            //         ApplicationArea = All;
            //     }
            //     action("No Objection Letter Regular")
            //     {
            //         Caption = 'No Objection Letter';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "No objection letter(reg)";
            //         ToolTip = 'Executes the No Objection Letter action.';
            //         ApplicationArea = All;
            //     }
            //     action("No Objection Letter Probation")
            //     {
            //         Caption = 'No Objection Letter Probation';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "No objection letter(pro)";
            //         ToolTip = 'Executes the No Objection Letter Probation action.';
            //         ApplicationArea = All;
            //     }
            //     action("No Objection Letter Loan Used")
            //     {
            //         Caption = 'No Objection Letter Loan Used';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "No objection letter";
            //         ToolTip = 'Executes the No Objection Letter Loan Used action.';
            //         ApplicationArea = All;
            //     }
            //     action("Leave Approve Letter")
            //     {
            //         Caption = 'Leave Approve Letter';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Leave Approve Letter";
            //         ToolTip = 'Executes the Leave Approve Letter action.';
            //         ApplicationArea = All;
            //     }
            //     action("Leave Balance Letter")
            //     {
            //         Caption = 'Leave balance Letter';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Leave Balance Letter";
            //         ToolTip = 'Executes the Leave balance Letter action.';
            //         ApplicationArea = All;
            //     }
            //     action("TDS Cert of Reg Employee")
            //     {
            //         Caption = 'TDS certificate of Regular Employee';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "TDS cert reg emp";
            //         ToolTip = 'Executes the TDS certificate of Regular Employee action.';
            //         ApplicationArea = All;
            //     }
            //     action("TDS Cert of Retire Reg Emp")
            //     {
            //         Caption = 'TDS certificate of Retire Regular Employee';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "TDS cert Retire reg emp";
            //         ToolTip = 'Executes the TDS certificate of Retire Regular Employee action.';
            //         ApplicationArea = All;
            //     }
            //     action("TDS Cert of  Prob Emp")
            //     {
            //         Caption = 'TDS certificate of Employee under Probation';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "TDS cert Probation emp";
            //         ToolTip = 'Executes the TDS certificate of Employee under Probation action.';
            //         ApplicationArea = All;
            //     }
            //     action("TDS Cert of Retire Prob Emp")
            //     {
            //         Caption = 'TDS certificate of Retire Prob Employee';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "TDS cert retire probation emp";
            //         ToolTip = 'Executes the TDS certificate of Retire Prob Employee action.';
            //         ApplicationArea = All;
            //     }
            //     action("TDS Cert of Contract Emp")
            //     {
            //         Caption = 'TDS certificate of Contract Employee';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "TDS cert Contract emp";
            //         ToolTip = 'Executes the TDS certificate of Contract Employee action.';
            //         ApplicationArea = All;
            //     }
            //     action("TDS Cert of Retire Contr Emp")
            //     {
            //         Caption = 'TDS certificate of Retire Contract Employee';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "TDS cert Retire Contract emp";
            //         ToolTip = 'Executes the TDS certificate of Retire Contract Employee action.';
            //         ApplicationArea = All;
            //     }
            //     action("TAX Clearance Letter To IRD")
            //     {
            //         Caption = 'TAX Clearance Letter To IRD';
            //         Image = AllLines;
            //         Promoted = true;
            //         PromotedCategory = "Report";
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         RunObject = report "Tax Clearance Letter";
            //         ToolTip = 'Executes the TAX Clearance Letter To IRD action.';
            //         ApplicationArea = All;
            //     }
            // }
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

    procedure Setvisibility()
    begin
        UserSetup.Reset;
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst then begin
            LeaveVisibility := UserSetup."For Leave-Dashboard";
            TravelVisibility := UserSetup."For Travel-Dashboard";
            TransferVisibility := UserSetup."For Transfer-Dashboard";
            OvertimeVisibility := UserSetup."For Overtime-Dashboard";
            BulkCashVisibility := UserSetup."For BulkCash-Dashboard";
            Resignationvisibility := UserSetup."For Resignation-Dashboard";
            SalaryAdvVisibility := UserSetup."For Salary Advance";
        end;
    end;
}
