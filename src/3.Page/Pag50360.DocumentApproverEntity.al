// page 50360 "Resign Doc Approver Entity"
// {
//     APIGroup = 'HRMS';
//     APIPublisher = 'Agile';
//     APIVersion = 'v2.0';
//     ApplicationArea = All;
//     Caption = 'documentApproverEntity';
//     DelayedInsert = true;
//     EntityName = 'resignDocumentApprover';
//     EntitySetName = 'resignDocumentApproverEntity';
//     PageType = API;
//     SourceTable = "Document Approver";

//     layout
//     {
//         area(Content)
//         {
//             repeater(General)
//             {
//                 field(no; Rec."Document No.")
//                 {
//                     Caption = 'Document No.';
//                     Editable = false;
//                 }
//                 field(employeeNo; Rec."Employee No.")
//                 {
//                     Caption = 'Employee No.';
//                     Editable = false;
//                 }
//                 field(employeeName; Rec."Employee Name")
//                 {
//                     Caption = 'Employee Name';
//                     Editable = false;
//                 }
//                 field(documentType; Rec."Document Type")
//                 {
//                     Caption = 'Document Type';
//                     Editable = false;
//                 }
//                 field(approvalStatus; Rec."Approval Status")
//                 {
//                     Caption = 'Approval Status';
//                 }
//                 field(approvedDate; Rec."Approved Date")
//                 {
//                     Caption = 'Approved Date';
//                     Editable = false;
//                 }
//                 field(remarks; Rec.Remarks)
//                 {
//                     Caption = 'Remarks';
//                 }
//                 field(rejectionRemarks; Rec."Rejection Remarks")
//                 {
//                     Caption = 'Rejection Remarks';
//                 }
//                 field(employeeType; Rec."Employee Type")
//                 {
//                     Caption = 'Employee Type';
//                     Editable = false;
//                 }
//                 field(functionalTitle; Rec."Functional Title")
//                 {
//                     Caption = 'Functional Title';
//                     Editable = false;
//                 }
//             }
//         }
//     }
//     trigger OnOpenPage()
//     var
//         HrMgt: Codeunit "HR Mgt.";
//     begin
//         Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
//         Rec.SetRange("Document Type", Rec."Document Type"::Resignation);
//     end;
// }
