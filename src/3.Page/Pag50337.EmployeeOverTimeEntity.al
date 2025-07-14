page 50337 "Employee OverTime Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'employeeOverTimeEntity';
    DelayedInsert = true;
    EntityName = 'employeeOverTime';
    EntitySetName = 'employeeOverTimeEntity';
    PageType = API;
    SourceTable = OverTime;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(no; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeNo; Rec."Employee No.")
                {
                }
                field(employeeName; Rec."Employee Name") { }
                field(employeeWorkShift; Rec."Employee Work Shift") { }
                // field(salaryLevel; Rec."Salary Level Code") { }
                // field(department; Rec.Department) { }
                // field(departmentName; Rec."Department Name") { }
                // field(branchCode; Rec."Shortcut Dimension 1 Code") { }
                // field(branchName; Rec."Branch Name") { }
                // field(functionalTitle; Rec."Functional Title") { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(checkInTime; HrMgt.getTimeinFormat(Rec."Check In Time")) { }
                field(checkOutTime; HrMgt.getTimeinFormat(Rec."Check Out Time")) { }
                // field(noOfDays; Rec."No. of Days") { }
                field(requestedDate; Rec."Requested Date") { }
                // field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                // field(cancelled; Rec.Cancelled) { }
                // field(cancelledNo; Rec."Cancelled No.") { }
                // field(cancelledDocNo; Rec."Cancelled Document No.") { }
                // field(approverType; Rec."Approver Type") { }
                // field(reasonCode; Rec."Reason Code") { }
                // field(reasonDescription; Rec."Reason Description") { }
                field(remarks; Rec.Remarks) { }
                // field(screenerRemarks; Rec."Screener Remarks") { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }
                field(status; Rec.status) { }

            }
            group(Overtime)
            {
                field(timeDuration; Rec."Time Duration") { }
                field(actualHours; Rec."Actual OT Hours") { }
                field(estimatedHours; Rec."Estimated Hours") { }
                field(encashmentCode; Rec."Encashment Code") { }
                field(overTimeClaimType; Rec."Overtime Claim Type") { }
                field(compensatoryDays; Rec."Compensatory Days") { }
                field(oTAmount; Rec."OT Amount") { }
                field(oTDisbursed; Rec."OT Disbursed") { }
                field(morningOThrs; Rec."Morning OT Hours")
                {
                }
                field(eveningOThrs; Rec."Evening OT Hours")
                {
                }
                field(totalOTHours; Rec."Total OT Hours")
                {
                }

            }
            // part(Attachment; "Attachment Subform")
            // {
            //     EntityName = 'attachmentEntity';
            //     EntitySetName = 'attachmentEntities';
            //     SubPageLink = "No." = field("No.");
            // }
            // group(Approval)
            // {
            //     field(recommendercode; Rec."Recommender Code")
            //     {
            //     }
            //     field(recommnedername; Rec."Recommender Name") { }
            //     field(approvercode; Rec."Approver Code") { }
            //     field(approvername; Rec."Approver Name") { }
            // }
        }
    }
    trigger OnOpenPage()

    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetRange(Type, Rec.Type::"Overtime");
        Rec.SetAscending("No.", false);
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
}
