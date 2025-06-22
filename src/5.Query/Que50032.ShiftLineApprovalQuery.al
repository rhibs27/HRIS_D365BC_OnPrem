query 50032 "Shift Line Approval Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'shiftApprovalLine';
    EntitySetName = 'shiftApprovalLineEntity';
    QueryType = API;
    OrderBy = descending(no);
    elements
    {
        dataitem(ApprovalHRMS; "Approval HRMS")
        {
            column(approverCode; "Approver No") { }
            column(approverName; "Approver Name") { }
            column(type; "Document Type") { }
            column(approvalStatusLine; "Approval Status") { }
            column(approvalSequence; "Approval Sequence") { }
            dataitem(ShiftLine; "Shift Line")
            {
                DataItemLink = "No." = ApprovalHRMS."Document No.";
                column(no; "No.") { }
                column(lineNo; "Line No") { }
                column(employeeName; "Employee Name") { }
                column(rosterDate; "Roster Date") { }
                column(deputationType; "Deputation Type") { }
                column(employeeWorkShift; "Employee Work Shift") { }
                column(deputationCode; "Deputation Code") { }
                column(deputationName; "Deputation Name") { }
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