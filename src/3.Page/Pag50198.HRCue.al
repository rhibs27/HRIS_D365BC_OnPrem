page 50198 "HR Cue"
{
    // version KPI1.00

    PageType = CardPart;
    SourceTable = "HR Cue";
    ApplicationArea = All;
    Caption = 'HR Cue';
    layout
    {
        area(Content)
        {
            cuegroup("Pending Tasks")
            {
                field("Request to Approve"; Rec."Request to Approve")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Request to Approve HRIS";
                }
            }
            cuegroup("Attendance Missed")
            {
                Visible = AttendanceMissedVisibility;
                field("To Recommend Attendance Missed"; Rec."To Recommend Attendance Missed")
                {
                    Caption = 'To Recommend';
                    DrillDownPageID = "Attendance Missed Lists";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Recommend field.';
                    ApplicationArea = All;
                }
                field("To Approve Attendance Missed"; Rec."To Approve Attendance Missed")
                {
                    Caption = 'To Approve';
                    DrillDownPageID = "Attendance Missed Lists";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Approve field.';
                    ApplicationArea = All;
                }
                field("Approved Attendance Missed"; Rec."Approved Attendance Missed")
                {
                    Caption = 'Approved';
                    DrillDownPageID = "Attendance Missed Lists";
                    ToolTip = 'Specifies the value of the Approved field.';
                    ApplicationArea = All;
                }
            }





            cuegroup("Leave Request")
            {
                Visible = LeaveVisibility;
                field("To Recommend Leave Req"; Rec."To Recommend Leave Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    DrillDownPageID = "Leave Requests";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Recommend field.';
                }
                field("To Approve Leave Request"; Rec."To Approve Leave Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageID = "Leave Requests";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Approve field.';
                }
                field("Approved Leave Request"; Rec."Approved Leave Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    DrillDownPageID = "Leave Requests";
                    ToolTip = 'Specifies the value of the Approved field.';
                }
                field("Rejected Leave Request"; Rec."Rejected Leave Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageID = "Leave Requests";
                    ToolTip = 'Specifies the value of the Rejected field.';
                }

            }
            cuegroup("Cancelled Leave")
            {
                field("To Screen Cancel Leave"; Rec."To Screen Cancel Leave")
                {
                    DrillDownPageID = "Cancelled Leave List";
                    ToolTip = 'Specifies the value of the To Screen Cancel Leave field.';
                    ApplicationArea = All;
                }
            }
            cuegroup("Travel Request")
            {
                Caption = 'Travel';
                Visible = TravelVisibility;
                field("To Recommend Travel Req"; Rec."To Recommend Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    DrillDownPageID = "Travel Requests";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Recommend field.';
                }
                field("To Approve Travel Req"; Rec."To Approve Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageID = "Travel Requests";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Approve field.';
                }
                field("Approved Travel Req"; Rec."Approved Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    DrillDownPageID = "Travel Requests";
                    ToolTip = 'Specifies the value of the Approved field.';
                }
                field("Rejected Travel Req"; Rec."Rejected Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageID = "Travel Requests";
                    ToolTip = 'Specifies the value of the Rejected field.';
                }
            }
            cuegroup("Travel Claim")
            {
                Caption = 'Travel Settlement';
                Visible = TravelVisibility;
                field("To Recommend Travel Claim"; Rec."To Recommend Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    DrillDownPageID = "Travel Claim Lists";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Recommend field.';
                }
                field("To Approve Travel Claim"; Rec."To Approve Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageID = "Travel Claim Lists";
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Approve field.';
                }
                field("To Screen Travel Claim"; Rec."To Screen Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Screen';
                    DrillDownPageID = "Travel Claim Lists";
                    ToolTip = 'Specifies the value of the To Screen field.';
                }
                field("To Final Approved Travel Claim"; Rec."To Final Approved Travel Claim")
                {
                    Caption = 'To Final Approve';
                    DrillDownPageID = "Travel Claim Lists";
                    ToolTip = 'Specifies the value of the To Final Approve field.';
                    ApplicationArea = All;
                }
                field("Final Approved Travel Claim"; Rec."Final Approved Travel Claim")
                {
                    Caption = 'Final Approved';
                    DrillDownPageID = "Travel Claim Lists";
                    ToolTip = 'Specifies the value of the Final Approved field.';
                    ApplicationArea = All;
                }
                field("Rejected Travel Claim"; Rec."Rejected Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageID = "Travel Claim Lists";
                    ToolTip = 'Specifies the value of the Rejected field.';
                }
            }
            cuegroup(Transfer)
            {
                Visible = TransferVisibility;
                field("To Recommend  Transfer"; Rec."To Recommend  Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    ToolTip = 'Specifies the value of the To Recommend field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        EmpActivity.Reset;
                        EmpActivity.SetFilter(Type, '%1|%2', EmpActivity.Type::"HR Transfer", EmpActivity.Type::"Employee Transfer");
                        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Pending);
                        EmpActivity.SetRange("Recommender Code", HRMgt.GetEmployeeNo);
                        Clear(PageTransferList);
                        PageTransferList.ForHistoryPage;
                        PageTransferList.SetRecord(EmpActivity);
                        PageTransferList.SetTableView(EmpActivity);
                        PageTransferList.Run;
                    end;
                }
                field("To Approve Transfer"; Rec."To Approve Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    ToolTip = 'Specifies the value of the To Approve field.';

                    trigger OnDrillDown()
                    begin
                        EmpActivity.Reset;
                        EmpActivity.SetFilter(Type, '%1|%2', EmpActivity.Type::"HR Transfer", EmpActivity.Type::"Employee Transfer");
                        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Screened);
                        EmpActivity.SetRange("Approver Code", HRMgt.GetEmployeeNo);
                        Clear(PageTransferList);
                        PageTransferList.ForHistoryPage;
                        PageTransferList.SetRecord(EmpActivity);
                        PageTransferList.SetTableView(EmpActivity);
                        PageTransferList.Run;
                    end;
                }
                field("To Screen Transfer"; Rec."To Screen Transfer")
                {
                    Caption = 'To Screen';
                    ToolTip = 'Specifies the value of the To Screen field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        EmpActivity.Reset;
                        EmpActivity.SetFilter(Type, '%1|%2', EmpActivity.Type::"HR Transfer", EmpActivity.Type::"Employee Transfer");
                        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Reviewed);
                        Clear(PageTransferList);
                        PageTransferList.ForHistoryPage;
                        PageTransferList.SetRecord(EmpActivity);
                        PageTransferList.SetTableView(EmpActivity);
                        PageTransferList.Run;
                    end;
                }
                field("Approved  Transfer"; Rec."Approved  Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    ToolTip = 'Specifies the value of the Approved field.';

                    trigger OnDrillDown()
                    begin
                        EmpActivity.Reset;
                        EmpActivity.SetFilter(Type, '%1|%2', EmpActivity.Type::"HR Transfer", EmpActivity.Type::"Employee Transfer");
                        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Approved);
                        EmpActivity.SetRange("Approver Code", HRMgt.GetEmployeeNo);
                        Clear(PageTransferList);
                        PageTransferList.ForHistoryPage;
                        PageTransferList.SetRecord(EmpActivity);
                        PageTransferList.SetTableView(EmpActivity);
                        PageTransferList.Run;
                    end;
                }
                field("Rejected  Transfer"; Rec."Rejected  Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    ToolTip = 'Specifies the value of the Rejected field.';

                    trigger OnDrillDown()
                    begin
                        EmpActivity.Reset;
                        EmpActivity.SetFilter(Type, '%1|%2', EmpActivity.Type::"HR Transfer", EmpActivity.Type::"Employee Transfer");
                        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Rejected);
                        Clear(PageTransferList);
                        PageTransferList.ForHistoryPage;
                        PageTransferList.SetRecord(EmpActivity);
                        PageTransferList.SetTableView(EmpActivity);
                        PageTransferList.Run;
                    end;
                }
                field("Acknowledged Transfer"; Rec."Acknowledged Transfer")
                {
                    Caption = 'Acknowledged';
                    ToolTip = 'Specifies the value of the Acknowledged field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        EmpActivity.Reset;
                        EmpActivity.SetFilter(Type, '%1|%2', EmpActivity.Type::"HR Transfer", EmpActivity.Type::"Employee Transfer");
                        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Acknowledged);
                        Clear(PageTransferList);
                        PageTransferList.ForHistoryPage;
                        PageTransferList.SetRecord(EmpActivity);
                        PageTransferList.SetTableView(EmpActivity);
                        PageTransferList.Run;
                    end;
                }
            }
            // GridLayout = Rows;

            cuegroup("Transfer Claim")
            {
                field("To Recommend Transfer Claim"; Rec."To Recommend Transfer Claim")
                {
                    DrillDownPageId = "HR Transfer Requests";
                    ToolTip = 'Specifies the value of the To Recommend Transfer Claim field.';
                    ApplicationArea = All;
                }
                field("To Review Transfer Claim"; Rec."To Review Transfer Claim")
                {
                    DrillDownPageId = "HR Transfer Requests";
                    ToolTip = 'Specifies the value of the To Review Transfer Claim field.';
                    ApplicationArea = All;
                }


                field("To Approve Transfer Claim"; Rec."To Approve Transfer Claim")
                {
                    DrillDownPageId = "HR Transfer Requests";
                    ToolTip = 'Specifies the value of the To Approve Transfer Claim field.';
                    ApplicationArea = All;
                }


            }


            cuegroup(Overtime)
            {
                Visible = OvertimeVisibility;
                field("To Approve Overtime"; Rec."To Approve Overtime")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageID = Overtimes;
                    Visible = false;
                    ToolTip = 'Specifies the value of the To Approve field.';
                }
                field("To Screen Overtime"; Rec."To Screen Overtime")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Screen';
                    DrillDownPageID = Overtimes;
                    ToolTip = 'Specifies the value of the To Screen field.';
                }
                field("Screened Overtime"; Rec."Screened Overtime")
                {
                    Caption = 'Screened';
                    DrillDownPageID = Overtimes;
                    ToolTip = 'Specifies the value of the Screened field.';
                    ApplicationArea = All;
                }
                field("Rejected  Overtime"; Rec."Rejected  Overtime")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageID = Overtimes;
                    ToolTip = 'Specifies the value of the Rejected field.';
                }
            }
            cuegroup("Bulk Cash")
            {
                Visible = BulkCashVisibility;
                field("To Approve Bulk Cash"; Rec."To Approve Bulk Cash")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageID = "Bulk Cash";
                    ToolTip = 'Specifies the value of the To Approve field.';
                }
                field("Approved  Bulk Cash"; Rec."Approved  Bulk Cash")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    DrillDownPageID = "Bulk Cash";
                    ToolTip = 'Specifies the value of the Approved field.';
                }
            }
            cuegroup(Resignation)
            {
                Caption = 'Resignation';
                Visible = Resignationvisibility;
                field("Resignation By Age"; Rec."Resignation By Age")
                {
                    DrillDownPageID = "Resignation List";
                    ToolTip = 'Specifies the value of the Resignation By Age field.';
                    ApplicationArea = All;
                }
                field("Resignation By Service"; Rec."Resignation By Service")
                {
                    DrillDownPageID = "Resignation List";
                    ToolTip = 'Specifies the value of the Resignation By Service field.';
                    ApplicationArea = All;
                }
            }
            // cuegroup("Salary Advance")
            // {
            //     Visible = SalaryAdvVisibility;
            //     field("To Screen Salary Advance"; Rec."To Screen Salary Advance")
            //     {
            //         Caption = 'To Screen';
            //         DrillDownPageID = "Employee Salary Advance List";
            //         ToolTip = 'Specifies the value of the To Screen field.';
            //         ApplicationArea = All;
            //     }
            //     field("To Approve Salary Advance"; Rec."To Approve Salary Advance")
            //     {
            //         Caption = 'To Approve';
            //         DrillDownPageID = "Employee Salary Advance List";
            //         ToolTip = 'Specifies the value of the To Approve field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approved Salary Advance"; Rec."Approved Salary Advance")
            //     {
            //         Caption = 'Approved';
            //         DrillDownPageID = "Employee Salary Advance List";
            //         ToolTip = 'Specifies the value of the Approved field.';
            //         ApplicationArea = All;
            //     }
            //     field("Rejected Salary Advance"; Rec."Rejected Salary Advance")
            //     {
            //         Caption = 'Rejected';
            //         DrillDownPageID = "Employee Salary Advance List";
            //         ToolTip = 'Specifies the value of the Rejected field.';
            //         ApplicationArea = All;
            //     }
            // }
            // cuegroup("Personal Loan")
            // {
            //     Visible = SalaryAdvVisibility;
            //     field("To Screen Personal Loan"; Rec."To Screen Personal Loan")
            //     {
            //         Caption = 'To Screen';
            //         DrillDownPageID = "Employee Personal Loan List";
            //         ToolTip = 'Specifies the value of the To Screen field.';
            //         ApplicationArea = All;
            //     }
            //     field("To Approve Persoanl Loan"; Rec."To Approve Persoanl Loan")
            //     {
            //         Caption = 'To Approve';
            //         DrillDownPageID = "Employee Personal Loan List";
            //         ToolTip = 'Specifies the value of the To Approve field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approved Persoanl Loan"; Rec."Approved Persoanl Loan")
            //     {
            //         Caption = 'Approved';
            //         DrillDownPageID = "Employee Personal Loan List";
            //         ToolTip = 'Specifies the value of the Approved field.';
            //         ApplicationArea = All;
            //     }
            //     field("Rejected Personal Loan"; Rec."Rejected Personal Loan")
            //     {
            //         Caption = 'Rejected';
            //         DrillDownPageID = "Employee Personal Loan List";
            //         ToolTip = 'Specifies the value of the Rejected field.';
            //         ApplicationArea = All;
            //     }
            // }
            // cuegroup("Home Loan")
            // {
            //     Visible = SalaryAdvVisibility;
            //     field("To Screen Home Loan"; Rec."To Screen Home Loan")
            //     {
            //         Caption = 'To Screen';
            //         DrillDownPageID = "Employee Home Loan List";
            //         ToolTip = 'Specifies the value of the To Screen field.';
            //         ApplicationArea = All;
            //     }
            //     field("To Approve Home Loan"; Rec."To Approve Home Loan")
            //     {
            //         Caption = 'To Approve';
            //         DrillDownPageID = "Employee Home Loan List";
            //         ToolTip = 'Specifies the value of the To Approve field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approved Home Loan"; Rec."Approved Home Loan")
            //     {
            //         Caption = 'Approved';
            //         DrillDownPageID = "Employee Home Loan List";
            //         ToolTip = 'Specifies the value of the Approved field.';
            //         ApplicationArea = All;
            //     }
            //     field("Rejected Home Loan"; Rec."Rejected Home Loan")
            //     {
            //         Caption = 'Rejected';
            //         DrillDownPageID = "Employee Home Loan List";
            //         ToolTip = 'Specifies the value of the Rejected field.';
            //         ApplicationArea = All;
            //     }
            // }
            // cuegroup("Vehicle Loan")
            // {
            //     Visible = SalaryAdvVisibility;
            //     field("To Screen Vehicle Loan"; Rec."To Screen Vehicle Loan")
            //     {
            //         Caption = 'To Screen';
            //         DrillDownPageID = "Employee Vehicle Loan List";
            //         ToolTip = 'Specifies the value of the To Screen field.';
            //         ApplicationArea = All;
            //     }
            //     field("To Approve Vehicle Loan"; Rec."To Approve Vehicle Loan")
            //     {
            //         Caption = 'To Approve';
            //         DrillDownPageID = "Employee Vehicle Loan List";
            //         ToolTip = 'Specifies the value of the To Approve field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approved Vehicle Loan"; Rec."Approved Vehicle Loan")
            //     {
            //         Caption = 'Approved';
            //         DrillDownPageID = "Employee Vehicle Loan List";
            //         ToolTip = 'Specifies the value of the Approved field.';
            //         ApplicationArea = All;
            //     }
            //     field("Rejected Vehicle Loan"; Rec."Rejected Vehicle Loan")
            //     {
            //         Caption = 'Rejected';
            //         DrillDownPageID = "Employee Vehicle Loan List";
            //         ToolTip = 'Specifies the value of the Rejected field.';
            //         ApplicationArea = All;
            //     }
            // }
            // cuegroup("Tranfer Claim")
            // {
            //     field("To Recommend Tranfer Claim"; Rec."To Recommend Tranfer Claim")
            //     {
            //         DrillDownPageID = "HR Transfer Requests";
            //         ToolTip = 'Specifies the value of the To Recommend Tranfer Claim field.';
            //         ApplicationArea = All;
            //     }
            //     field("To Review Transfer Claim"; Rec."To Review Transfer Claim")
            //     {
            //         DrillDownPageID = "HR Transfer Requests";
            //         ToolTip = 'Specifies the value of the To Review Transfer Claim field.';
            //         ApplicationArea = All;
            //     }
            //     field("To Approve Transfer Claim"; Rec."To Approve Transfer Claim")
            //     {
            //         DrillDownPageID = "HR Transfer Requests";
            //         ToolTip = 'Specifies the value of the To Approve Transfer Claim field.';
            //         ApplicationArea = All;
            //     }
            // }
            cuegroup("Residential Address")
            {
                // field("To Screen Residential Address"; Rec."To Screen Residential Address")
                // {
                //     // DrillDownPageID = 60274;
                //     ToolTip = 'Specifies the value of the To Screen Residential Address field.';
                //     ApplicationArea = All;
                // }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Setvisibility;

        HRSetup.Get;
        Rec.SetRange("Contract Expiry Date Filter", Today, CalcDate(HRSetup."Contract Expiry Days", Today));

        Rec.SetFilter("Expiry Check Date", '<=%1', Today);

        Employee.Reset;
        Employee.SetRange("Employment Type", Employee."Employment Type"::Contract);
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetFilter("Contract Expiry Date", '<>0D');
        if Employee.FindFirst then
            repeat
                if Employee."Contract Expiry Date" > Today then begin
                    Employee."Contract Expiry Remaining Days" := Employee."Contract Expiry Date" - Today;
                    Employee.Modify;
                end;
            until Employee.Next = 0;

        Rec.SetFilter("Employee Filter", HRMgt.GetEmployeeNo());
    end;

    var
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        LeaveVisibility: Boolean;
        TravelVisibility: Boolean;
        TransferVisibility: Boolean;
        BulkCashVisibility: Boolean;
        OvertimeVisibility: Boolean;
        Resignationvisibility: Boolean;
        SalaryAdvVisibility: Boolean;

        AttendanceMissedVisibility: Boolean;
        HRSetup: Record "Human Resources Setup";
        EmpActivity: Record "Employee Activity";
        PageTransferList: Page "Employee Transfer Requests";
        HRMgt: Codeunit "HR Mgt.";

    procedure Setvisibility()
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then
            Rec.SetFilter("User Filter", Employee."No.");
        // if not Employee.Screener then
        //     Rec.SetRange("Employee Filter", Employee."No.");

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
            AttendanceMissedVisibility := UserSetup."For Attend. Missed-Dashboard";
        end;
    end;
}
