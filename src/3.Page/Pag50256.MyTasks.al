page 50256 "My Tasks"
{


    EntityName = 'myTask';
    EntitySetName = 'myTasks';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            cuegroup("Attendance Missed")
            {
                field(ToRecommendAttendanceMissed; Rec."To Recommend Attendance Missed")
                {
                    Caption = 'To Recommend';
                    DrillDownPageId = "Attendance Missed Lists";
                    Visible = false;
                }
                field(ToApproveAttendanceMissed; Rec."To Approve Attendance Missed")
                {
                    Caption = 'To Approve';
                    DrillDownPageId = "Attendance Missed Lists";
                    Visible = false;
                }
            }
            cuegroup("Leave Request")
            {
                field(ToRecommendLeaveReq; Rec."To Recommend Leave Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    DrillDownPageId = "Leave Requests";
                    Visible = false;
                }
                field(ToApproveLeaveRequest; Rec."To Approve Leave Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageId = "Leave Requests";
                    Visible = false;
                }
            }
            cuegroup("Travel Request")
            {
                Caption = 'Travel';
                field(ToRecommendTravelReq; Rec."To Recommend Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    DrillDownPageId = "Travel Requests";
                    Visible = false;
                }
                field(ToApproveTravelReq; Rec."To Approve Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageId = "Travel Requests";
                    Visible = false;
                }
            }
            cuegroup("Travel Claim")
            {
                Caption = 'Travel Settlement';
                field(ToRecommendTravelClaim; Rec."To Recommend Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    DrillDownPageId = "Travel Claim Lists";
                    Visible = false;
                }
                field(ToApproveTravelClaim; Rec."To Approve Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageId = "Travel Claim Lists";
                    Visible = false;
                }
            }
            cuegroup(Transfer)
            {
                field(ToRecommendTransfer; Rec."To Recommend  Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Recommend';
                    DrillDownPageId = "Employee Transfer Requests";
                }
                field(IncomingBranch; Rec."Incoming Branch")
                {
                    DrillDownPageId = "Employee Transfer Requests";
                }
                field(ToReviewTransfer; Rec."To Review Transfer")
                {
                    Caption = 'To Review';
                    DrillDownPageId = "Employee Transfer Requests";
                }
            }
            cuegroup(Overtime)
            {
                field(ToApproveOvertime; Rec."To Approve Overtime")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageId = Overtimes;
                    Visible = false;
                }
                field(ToRecommendOvertime; Rec."To Recommend Overtime")
                {
                    Caption = 'To Recommend';
                }
            }
            cuegroup(Resignation)
            {
                Caption = 'Resignation';
                field(ToRecommendResignation; Rec."To Recommend Resignation") { }
                field(ToReviewsResignation; Rec."To Reviews Resignation") { }
            }
            cuegroup("Salary Advance")
            {
                // field(ToRecommendSalaryAdvance; Rec."To Recommend Salary Advance")
                // {
                //     Caption = 'To Recommend';
                // }
            }
            cuegroup("Personal Loan")
            {
                // field(ToRecommendPersonalLoan; Rec."To Recommend Personal Loan")
                // {
                //     Caption = 'To Recommend';
                // }
            }
            cuegroup("Home Loan")
            {
                // field(ToRecommendHomeLoan; Rec."To Recommend Home Loan")
                // {
                //     Caption = 'To Recommend';
                // }
            }
            cuegroup("Vehicle Loan")
            {
                // field(ToRecommendVehicleLoan; Rec."To Recommend Vehicle Loan")
                // {
                //     Caption = 'To Recommend';
                // }
            }
            cuegroup("Allowance Assignment")
            {
                field(ToRecommendAllowanceAssig; Rec."To Recommend Allowance Assig.")
                {
                    Caption = 'To Recommend';
                }
            }
            cuegroup("Transfer Claim")
            {
                field(ToRecommendTransferClaim; Rec."To Recommend Transfer Claim")
                {
                    DrillDownPageId = "Employee Transfer Requests";
                }
                field(ToReviewTransferClaim; Rec."To Review Transfer Claim")
                {
                    DrillDownPageId = "Employee Transfer Requests";
                }
            }
            cuegroup(Appraisal)
            {
                field(ToReviewsAppraisal; Rec."To Reviews Appraisal") { }
                field(ToCheckReviewsAppraisal; Rec."To Check Reviews Appraisal") { }
            }
            field("EmployeeFilter"; Rec."Employee Filter")
            {
            }
            field(employeeNo; employeeNo)
            {
                ApplicationArea = All;
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        // Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
        Setvisibility;
    end;

    var
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        HRMgt: Codeunit "HR Mgt.";
        employeeNo: Code[20];

    procedure Setvisibility() p: Text;
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", employeeNo);
        if Employee.FindFirst then begin
            if Employee."Disable Punch in" then //Min
                Error('PunchIn Disable, due to incompletion of declaraton form.Please, complete first.');
        end;
    end;
}
