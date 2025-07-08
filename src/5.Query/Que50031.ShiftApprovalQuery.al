query 50031 "Shift Approval Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'ShiftApproval';
    EntitySetName = 'ShiftApprovalEntity';
    QueryType = API;
    OrderBy = descending(no);
    elements
    {
        dataitem(ApprovalHRMS; "Approval HRMS")
        {
            column(approverCode; "Approver No") { }
            column(approverName; "Approver Name") { }
            column(approvalStatusLine; "Approval Status") { }
            column(approvalSequence; "Approval Sequence") { }
            dataitem(ShiftAssignmentHeader; "Shift Assignment Header")
            {
                DataItemLink = "No." = ApprovalHRMS."Document No.";
                column(no; "No.") { }
                column(type; Type) { }
                column(employeeNo; "Employee No.") { }
                column(employeeName; "Employee Name") { }
                column(fromDate; "From Date") { }
                column(toDate; "To Date") { }
                column(approvalStatus; "Approval Status") { }
                column(rejectionRemarks; "Rejection Remarks") { }
                column(status; status) { }
                column(deputationType; "Deputation Type") { }
                column(deputationCode; "Deputation Code") { }
                column(deputationName; "Deputation Name") { }
                column(deputationSubType; "Deputation Sub Type") { }
                column(deputationSubTypeCode; "Deputation Sub Type Code") { }
                column(deputationSubTypeName; "Deputation Sub Type Name") { }
                column(approvedDate; "Approved Date") { }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(approverCode, HRMgt.GetEmployeeNo());
        CurrQuery.SetRange(type, type::"Shift Assignment");
    end;
}