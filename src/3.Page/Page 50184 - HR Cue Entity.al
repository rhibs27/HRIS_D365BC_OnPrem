page 50184 "HR Cue Entity"
{
    // version ATNICASIA1.00

    EntityName = 'hrCueEntity';
    EntitySetName = 'hrCueEntities';
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
                field(ApprovedAttendanceMissed; Rec."Approved Attendance Missed")
                {
                    Caption = 'Approved';
                    DrillDownPageId = "Attendance Missed Lists";
                }
                field(EmployeeFilter; Rec."Employee Filter") { }
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
                field(ApprovedLeaveRequest; Rec."Approved Leave Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    DrillDownPageId = "Leave Requests";
                }
                field(RejectedLeaveRequest; Rec."Rejected Leave Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageId = "Leave Requests";
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
                field(ApprovedTravelReq; Rec."Approved Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    DrillDownPageId = "Travel Requests";
                }
                field(RejectedTravelReq; Rec."Rejected Travel Req")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageId = "Travel Requests";
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
                field(ToScreenTravelClaim; Rec."To Screen Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Screen';
                    DrillDownPageId = "Travel Claim Lists";
                }
                field(ToFinalApprovedTravelClaim; Rec."To Final Approved Travel Claim")
                {
                    Caption = 'To Final Approve';
                    DrillDownPageId = "Travel Claim Lists";
                }
                field(FinalApprovedTravelClaim; Rec."Final Approved Travel Claim")
                {
                    Caption = 'Final Approved';
                    DrillDownPageId = "Travel Claim Lists";
                }
                field(RejectedTravelClaim; Rec."Rejected Travel Claim")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageId = "Travel Claim Lists";
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
                field(ToApproveTransfer; Rec."To Approve Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageId = "Employee Transfer Requests";
                }
                field(ApprovedTransfer; Rec."Approved  Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    DrillDownPageId = "Employee Transfer Requests";
                }
                field(RejectedTransfer; Rec."Rejected  Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
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
                field(ToScreenOvertime; Rec."To Screen Overtime")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Screen';
                    DrillDownPageId = Overtimes;
                }
                field(ScreenedOvertime; Rec."Screened Overtime")
                {
                    Caption = 'Screened';
                    DrillDownPageId = Overtimes;
                }
                field(RejectedOvertime; Rec."Rejected  Overtime")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rejected';
                    DrillDownPageId = Overtimes;
                }
                field(ToRecommendOvertime; Rec."To Recommend Overtime")
                {
                    Caption = 'To Recommend';
                }
            }
            cuegroup("Bulk Cash")
            {
                field(ToApproveBulkCash; Rec."To Approve Bulk Cash")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Approve';
                    DrillDownPageId = "Bulk Cash";
                }
                field(ApprovedBulkCash; Rec."Approved  Bulk Cash")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approved';
                    DrillDownPageId = "Bulk Cash";
                }
            }
            cuegroup(Resignation)
            {
                Caption = 'Resignation';
                field(ResignationByAge; Rec."Resignation By Age")
                {
                    DrillDownPageId = "Resignation List";
                }
                field(ResignationByService; Rec."Resignation By Service")
                {
                    DrillDownPageId = "Resignation List";
                }
                field(ToRecommendResignation; Rec."To Recommend Resignation") { }
                field(ToReviewsResignation; Rec."To Reviews Resignation") { }
            }
            cuegroup("Salary Advance")
            {
                field(ToScreenSalaryAdvance; Rec."To Screen Salary Advance")
                {
                    Caption = 'To Screen';
                    DrillDownPageId = "Employee Salary Advance List";
                }
                field(ToApproveSalaryAdvance; Rec."To Approve Salary Advance")
                {
                    Caption = 'To Approve';
                    DrillDownPageId = "Employee Salary Advance List";
                }
                field(ApprovedSalaryAdvance; Rec."Approved Salary Advance")
                {
                    Caption = 'Approved';
                    DrillDownPageId = "Employee Salary Advance List";
                }
                field(RejectedSalaryAdvance; Rec."Rejected Salary Advance")
                {
                    Caption = 'Rejected';
                    DrillDownPageId = "Employee Salary Advance List";
                }
                field(ToRecommendSalaryAdvance; Rec."To Recommend Salary Advance")
                {
                    Caption = 'To Recommend';
                }
            }
            cuegroup("Personal Loan")
            {
                field(ToScreenPersonalLoan; Rec."To Screen Personal Loan")
                {
                    Caption = 'To Screen';
                    DrillDownPageId = "Employee Personal Loan List";
                }
                field(ToApprovePersoanlLoan; Rec."To Approve Persoanl Loan")
                {
                    Caption = 'To Approve';
                    DrillDownPageId = "Employee Personal Loan List";
                }
                field(ApprovedPersoanlLoan; Rec."Approved Persoanl Loan")
                {
                    Caption = 'Approved';
                    DrillDownPageId = "Employee Personal Loan List";
                }
                field(RejectedPersonalLoan; Rec."Rejected Personal Loan")
                {
                    Caption = 'Rejected';
                    DrillDownPageId = "Employee Personal Loan List";
                }
                field(ToRecommendPersonalLoan; Rec."To Recommend Personal Loan")
                {
                    Caption = 'To Recommend';
                }
            }
            cuegroup("Home Loan")
            {
                field(ToScreenHomeLoan; Rec."To Screen Home Loan")
                {
                    Caption = 'To Screen';
                    DrillDownPageId = "Employee Home Loan List";
                }
                field(ToApproveHomeLoan; Rec."To Approve Home Loan")
                {
                    Caption = 'To Approve';
                    DrillDownPageId = "Employee Home Loan List";
                }
                field(ApprovedHomeLoan; Rec."Approved Home Loan")
                {
                    Caption = 'Approved';
                    DrillDownPageId = "Employee Home Loan List";
                }
                field(RejectedHomeLoan; Rec."Rejected Home Loan")
                {
                    Caption = 'Rejected';
                    DrillDownPageId = "Employee Home Loan List";
                }
                field(ToRecommendHomeLoan; Rec."To Recommend Home Loan")
                {
                    Caption = 'To Recommend';
                }
            }
            cuegroup("Vehicle Loan")
            {
                field(ToScreenVehicleLoan; Rec."To Screen Vehicle Loan")
                {
                    Caption = 'To Screen';
                    DrillDownPageId = "Employee Vehicle Loan List";
                }
                field(ToApproveVehicleLoan; Rec."To Approve Vehicle Loan")
                {
                    Caption = 'To Approve';
                    DrillDownPageId = "Employee Vehicle Loan List";
                }
                field(ApprovedVehicleLoan; Rec."Approved Vehicle Loan")
                {
                    Caption = 'Approved';
                    DrillDownPageId = "Employee Vehicle Loan List";
                }
                field(RejectedVehicleLoan; Rec."Rejected Vehicle Loan")
                {
                    Caption = 'Rejected';
                    DrillDownPageId = "Employee Vehicle Loan List";
                }
                field(ToRecommendVehicleLoan; Rec."To Recommend Vehicle Loan")
                {
                    Caption = 'To Recommend';
                }
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

        // Setvisibility;
    end;

    // procedure Setvisibility()
    // begin
    //     Employee.Reset;
    //     Employee.SetRange("No.", Rec.GetFilter("Employee Filter"));
    //     if Employee.FindFirst then begin
    //         Rec.SetFilter("User Filter", Employee."No.");
    //         Rec.SetRange("Employee Filter", Employee."No.");
    //     end;
    // end;
}
