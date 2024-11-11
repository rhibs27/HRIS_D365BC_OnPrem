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
            group(Overtime)
            {
                field(TimeDuration; Rec."Time Duration") { }
                field(ActualHours; Rec."Actual Hours") { }
                field(EstimatedHours; Rec."Estimated Hours") { }
                field(EncashmentCode; Rec."Encashment Code") { }
                field(OTAmount; Rec."OT Amount") { }
                field(OTDisbursed; Rec."OT Disbursed") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
            group(Approval)
            {
                field(recommendercode; Rec."Recommender Code")
                {
                }
                field(recommnedername; Rec."Recommender Name") { }
                field(approvercode; Rec."Approver Code") { }
                field(approvername; Rec."Approver Name") { }
            }
        }
    }
}
