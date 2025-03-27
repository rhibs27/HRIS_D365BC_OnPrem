query 50014 Employee
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'employee';
    EntitySetName = 'employeeApi';
    QueryType = API;

    elements
    {
        dataitem(employee; Employee)
        {
            column(no; "No.")
            {
            }
            column(fullName; "Full Name")
            {
            }
            column(deputationOn; "Deputation on")
            {
            }
            column(departmentCode; "Department Code")
            {
            }
            column(branchCode; "Global Dimension 1 Code")
            {
            }

            column(branchName; "Branch Name")
            {
            }
            column(departmentName; "Department Name")
            {
            }
            column(companyEmail; "Company E-Mail")
            {
            }
            column(status; Status)
            {
            }
            column(phoneNo; "Phone No.")
            {
            }
            column(image; Image)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(status, status::Active);
    end;
}
