page 50338 "Employee Leave Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'employeeLeaveEntity';
    DelayedInsert = true;
    EntityName = 'employeeLeave';
    EntitySetName = 'employeeLeaveEntity';
    PageType = API;
    SourceTable = Leave;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeeName; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmentName; Rec."Department Name") { }
                field(branchCode; Rec."Shortcut Dimension 1 Code") { }
                field(branchName; Rec."Branch Name") { }
                field(functionalTitle; Rec."Functional Title") { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(noOfDays; Rec."No. of Days") { }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(cancelled; Rec.Cancelled) { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.") { }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
            }
            group(Leave)
            {
                field(leaveCode; Rec."Leave Code") { }
                field(leaveDescription; Rec."Leave Description") { }
                field(leaveType; Rec."Leave Type") { }
                field(payType; Rec."Pay Type") { }
                field(startTime; Rec."Start Time") { }
                field(endTime; Rec."End Time") { }
                field(compensatoryDate; Rec."Compensatory Date") { }
                field(childGender; Rec."Child's Gender") { }
                field(forDeathOf; Rec."For Death Of") { }
                field(contactNo; Rec."Contact No.") { }
                field(remarks; Rec.Remarks) { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }
            }
            group(Approval)
            {
                field(recommenderCode; Rec."Recommender Code")
                {
                }
                field(recommenderName; Rec."Recommender Name") { }
                field(approverCode; Rec."Approver Code") { }
                field(approverName; Rec."Approver Name") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
        }
    }
}
