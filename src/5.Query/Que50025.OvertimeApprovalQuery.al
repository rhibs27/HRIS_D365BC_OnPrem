query 50025 "Overtime Approval Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'overtimeBulkApproval';
    EntitySetName = 'overtimeBulkApprovalApi';
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
            dataitem(OverTime; OverTime)
            {
                DataItemLink = "No." = ApprovalHRMS."Document No.";
                column(no; "No.") { }
                column(type; Type) { }
                column(employeeNo; "Employee No.") { }
                column(employeeName; "Employee Name") { }
                column(startDate; "Start Date") { }
                column(startDateBS; "Start Date (BS)") { }
                column(endDate; "End Date") { }
                column(endDateBS; "End Date (BS)") { }
                column(requestedDate; "Requested Date") { }
                column(approvalStatus; "Approval Status") { }
                column(remarks; Remarks) { }
                column(rejectionRemarks; "Rejection Remarks") { }
                column(status; status) { }
                column(deputationType; "Deputation Type") { }
                column(deputationCode; "Deputation Code") { }
                column(deputationName; "Deputation Name") { }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(approverCode, HRMgt.GetEmployeeNo());
        CurrQuery.SetRange(type, type::"Overtime Bulk");
    end;
}