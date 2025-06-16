query 50026 "Overtime Approval Line Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'overtimeBulkApprovalLine';
    EntitySetName = 'overtimeBulkApprovalLineApi';
    QueryType = API;
    OrderBy = descending(no);
    elements
    {
        dataitem(ApprovalHRMS; "Approval HRMS")
        {
            column(approverCode; "Approver No")
            {
            }
            column(approverName; "Approver Name")
            {

            }
            column(type; "Document Type") { }
            column(approvalStatusLine; "Approval Status") { }
            column(approvalSequence; "Approval Sequence") { }
            dataitem(OverTimeLine; "OverTime Line")
            {
                DataItemLink = "No." = ApprovalHRMS."Document No.";
                column(no; "No.") { }

                column(lineNo; "Line No.") { }
                column(employeeName; "Employee Name") { }
                column(overtimeDate; "Overtime Date") { }
                column(checkInTime; "Check In Time") { }
                column(employeeWorkShift; "Employee Work Shift") { }
                column(checkOutTime; "Check Out Time") { }
                column(overtimeClaimType; "Overtime Claim Type") { }
                column(totalOTHours; "Total OT Hours") { }
                column(actualOTHours; "Actual OT Hours") { }
                column(oTAmount; "OT Amount") { }
                column(approvalStatus; "Approval Status") { }
                column(remarks; Remarks) { }
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