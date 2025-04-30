page 50332 "Attendance Missed API"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'attendanceMissedAPI';
    DelayedInsert = true;
    EntityName = 'attendanceMissedEntity';
    EntitySetName = 'attendanceMissedEntities';
    PageType = API;
    SourceTable = "Attendance Missed";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                }
                field(approvedDate; Rec."Approved Date")
                {
                    Caption = 'Approved Date';
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(employeeWorkShift; Rec."Employee Work Shift")
                {
                    Caption = 'Employee Work Shift';
                }
                field(endDate; Rec."End Date")
                {
                    Caption = 'End Date';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(rejectionRemarks; Rec."Rejection Remarks")
                {
                    Caption = 'Rejection Remarks';
                }
                field(remarks; Rec.Remarks)
                {
                    Caption = 'Remarks';
                }
                field(requestedDate; Rec."Requested Date")
                {
                    Caption = 'Requested Date';
                }
                field(startDate; Rec."Start Date")
                {
                    Caption = 'Start Date';
                }
                field(startDateBS; Rec."Start Date (BS)")
                {
                    Caption = 'Start Date (BS)';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(reasonCode; rec."Reason Code")
                {

                }
                field(reasonDescription; Rec."Reason Description")
                {
                }
                // field(noOfDays; Rec."No. of Days")
                // {
                // }
                field(endDateBS; Rec."End Date (BS)")
                {
                    Caption = 'End Date (BS)';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetAscending("No.", false);
    end;
}
