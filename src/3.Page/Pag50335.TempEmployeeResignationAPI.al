// page 50360 "Temp Employee Resignation API"
// {
//     APIGroup = 'HRMS';
//     APIPublisher = 'Agile';
//     APIVersion = 'v2.0';
//     ApplicationArea = All;
//     Caption = 'tempEmployeeResignationAPI';
//     DelayedInsert = true;
//     EntityName = 'tempEmployeeResignation';
//     EntitySetName = 'tempEmployeeResignationEntity';
//     PageType = API;
//     SourceTable = Resignation;
//     SourceTableTemporary = true;
//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 field(type; Rec.Type) { }
//                 field(employeeNo; Rec."Employee No.")
//                 {
//                     Editable = true;
//                 }
//                 field(employeeName; Rec."Employee Name") { }
//                 field(salaryLevel; Rec."Salary Level Code") { }
//                 field(department; Rec.Department) { }
//                 field(departmentName; Rec."Department Name") { }
//                 field(branchCode; Rec."Shortcut Dimension 1 Code") { }
//                 field(branchName; Rec."Branch Name") { }
//                 field(functionalTitle; Rec."Functional Title") { }
//                 // field(leavecode; Rec."Leave Code") { }
//                 field(cancelled; Rec.Cancelled) { }
//                 field(startDate; Rec."Start Date") { }
//                 field(startDateBS; Rec."Start Date (BS)") { }
//                 field(endDate; Rec."End Date") { }
//                 field(endDateBS; Rec."End Date (BS)") { }
//                 // field(noOfDays; Rec."No. of Days")
//                 // {
//                 //     Editable = true;
//                 // }
//                 field(requestedDate; Rec."Requested Date") { }
//                 field(fiscalYear; Rec."Fiscal Year") { }
//                 field(approvalStatus; Rec."Approval Status") { }
//                 // field(cancelledNo; Rec."Cancelled No.") { }
//                 // field(cancelledDocNo; Rec."Cancelled Document No.")
//                 // {
//                 //     Editable = true;
//                 // }
//                 // field(approverType; Rec."Approver Type") { }
//                 field(reasonCode; Rec."Reason Code") { }
//                 field(reasonDescription; Rec."Reason Description") { }
//             }
//             group(Resignation)
//             {
//                 field(proposedDateOfResignation; Rec."Proposed Date of Resignation") { }
//                 // field(supervisorProposedDate; Rec."Supervisor Proposed Date") { }
//                 field(hRProposedDate; Rec."HR Proposed Date") { }
//                 field(applyForWaiver; Rec."Apply for Waiver") { }
//                 field(waiverCase; Rec."Waiver Case") { }
//                 field(reasonForResignation; Rec."Reason for Resignation") { }
//             }
//             group(Approval)
//             {
//                 // field(recommenderCode; Rec."Recommender Code")
//                 // {
//                 //     trigger OnValidate()
//                 //     begin
//                 //         if Rec.Type = Rec.Type::Resignation then
//                 //             ResignationMgt.SendResignationApproval(Rec);
//                 //     end;
//                 // }
//                 // field(recommenderName; Rec."Recommender Name") { }
//                 // field(approverCode; Rec."Approver Code")
//                 // {
//                 // }
//                 // field(approverName; Rec."Approver Name") { }
//             }
//             part(Attachment; "Attachment Subform")
//             {
//                 EntityName = 'attachmentEntity';
//                 EntitySetName = 'attachmentEntities';
//                 SubPageLink = "No." = field("No.");
//             }
//         }
//     }
//     var
//         ResignationMgt: CodeUnit "Resignation Mgt";
//         HRMgt: Codeunit "HR Mgt.";

// }
