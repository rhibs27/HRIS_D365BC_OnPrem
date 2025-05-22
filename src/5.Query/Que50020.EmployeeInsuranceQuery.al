query 50020 "Employee Insurance Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'insuranceApproval';
    EntitySetName = 'insuranceApprovalEntity';
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
                dataitem(EmployeeInsuranceInformation; "Employee Insurance Information")
                {
                    DataItemLink = "Insurance No." = ApprovalHRMS."Document No.";
                    column(employeeNo; "Employee No.")
                    {
                        Caption = 'Employee No.';
                    }
                    column(type; Type) { }
                    column(insuranceNo; "Insurance No.")
                    {
                        Caption = 'Insurance No.';
                    }
                    column(employeeName; "Employee Name")
                    {
                        Caption = 'Employee Name';
                    }
                    column(insuranceCompany; "Insurance Company Code")
                    {
                        Caption = 'Insurance Company';
                    }
                    column(insuranceCompanyName; "Insurance Company Name")
                    {
                        Caption = 'Insurance Company Name';
                    }
                    column(policyNumber; "Policy Number")
                    {
                        Caption = 'Policy Number';
                    }
                    column(insuranceStartDateAD; "Insurance Start Date (AD)")
                    {
                        Caption = 'Insurance Start Date (AD)';
                    }
                    column(insuranceStartDateBS; "Insurance Start Date (BS)")
                    {
                        Caption = 'Insurance Start Date (BS)';
                    }
                    column(insuranceExpiryDateAD; "Insurance Expiry Date (AD)")
                    {
                        Caption = 'Insurance Expiry Date (AD)';
                    }
                    column(insuranceExpiryDateBS; "Insurance Expiry Date (BS)")
                    {
                        Caption = 'Insurance Expiry Date (BS)';
                    }
                    column(insuranceAmount; "Insurance Amount")
                    {
                        Caption = 'Insurance Amount';
                    }
                    column(monthlyPremiumAmount; "Monthly Premium Amount")
                    {
                        Caption = 'Monthly Premium Amount';
                    }
                    column(isHomeLoanTieUp; "Is Home Loan TieUp")
                    {
                        Caption = 'Is Home Loan TieUp';
                    }
                    column(requestedDate; "Requested Date")
                    {
                        Caption = 'Requested Date';
                    }
                    column(approvalStatus; "Approval Status")
                    {
                    }
                    column(status; Status)
                    {
                        Caption = 'Status';
                    }
                    column(insuranceType; "Insurance Type")
                    {
                        Caption = 'Type';
                    }
                    column(remarks; Remarks)
                    {
                        Caption = 'Remarks';
                    }
                    column(rejectionRemarks; "Rejection Remarks") { }
                    column(annualPremiumAmount; "Annual Premium Amount")
                    {
                        Caption = 'Annual Premium Amount';
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HRMgt.GetEmployeeNo());
        CurrQuery.SetRange(type, type::Insurance);
    end;
}