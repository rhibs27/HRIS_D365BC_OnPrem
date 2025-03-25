query 50012 "Resignation Clearance Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'resignClearance';
    EntitySetName = 'resignClearanceEntity';
    QueryType = API;
    OrderBy = descending(no);

    elements
    {
        dataitem(employee; Employee)
        {
            column(empNo; "No.")
            {
            }
            column(navLoginID; "NAV Login ID")
            {
            }
            column(fullName; "Full Name")
            {
            }
            dataitem(Resignation; Resignation)
            {
                DataItemLink = "Employee No." = employee."No.";
                column(employeeno; "Employee No.")
                {
                }
                column(empName; "Employee Name") { }
                column(approvalStatusLine; "Approval Status")
                {

                }
                dataitem(documentApprover; "Document Approver")
                {
                    DataItemLink = "Document No." = Resignation."No.";
                    column(no; "Document No.")
                    {
                        Caption = 'Document No.';
                    }
                    column(employeeName; "Employee Name")
                    {
                        Caption = 'Employee Name';
                    }
                    column(approvalStatus; "Approval Status")
                    {
                        Caption = 'Approval Status';
                    }
                    column(approvedDate; "Approved Date")
                    {
                        Caption = 'Approved Date';
                    }
                    column(remarks; Remarks)
                    {
                        Caption = 'Remarks';
                    }
                    column(rejectionRemarks; "Rejection Remarks")
                    {
                        Caption = 'Rejection Remarks';
                    }
                }
            }

        }
    }
    trigger OnBeforeOpen()
    var
        Hrmgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, Hrmgt.GetEmployeeNo());
    end;
}