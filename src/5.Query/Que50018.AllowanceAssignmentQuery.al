query 50018 "Allowance Assignment Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'allowanceApproval';
    EntitySetName = 'allowanceApprovalEntity';
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
            dataitem(ApprovalHRMS; "Approval HRMS")
            {
                DataItemLink = "Approver No" = employee."No.";

                column(no; "Document No.")
                {
                }
                column(approverCode; "Approver No")
                {

                }
                column(approverName; "Approver Name")
                {

                }
                column(approvalStatusLine; "Approval Status")
                {

                }
                column(approvalSequence; "Approval Sequence")
                {

                }
                dataitem(AllowanceAssignmentHeader; "Allowance Assignment Header")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(type; Type) { }
                    column(activityType; "Activity Type") { }
                    column(employeeNo; "Employee No.")
                    {
                    }
                    column("code"; Code) { }
                    column(name; Name)
                    {
                    }
                    column(fromDate; "From Date") { }
                    column(toDate; "To date") { }
                    column(approvalStatus; "Approval Status") { }
                    column(Week; Week) { }
                    column(englishMonth; "English Month") { }
                    column(englishYear; "English Year") { }
                    column(allowanceType; "Allowance Type Filter") { }
                    dataitem(Allowance_Assignment_Line; "Allowance Assignment Line")
                    {
                        DataItemLink = "No." = AllowanceAssignmentHeader."No.";
                        column(lineNo; "Line No.")
                        {

                        }
                        column(employeeCode; "Employee Code")
                        {

                        }
                        column(employeeName; "Employee Name")
                        {

                        }
                        column(noOfDays; "No. of Days")
                        {

                        }
                        column(isSubstitute; "Is Substitute")
                        {

                        }
                        column(panel; Panel)
                        {

                        }
                        column(approvalStatusAllowanceLine; "Approval Status")
                        {
                        }
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
        CurrQuery.SetRange(activityType, activityType::"Allowance Assignment");
    end;
}