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
            column(number; "No.")
            {
            }
            column(fullName; "Full Name")
            {
            }
            column(functionalTitleDesc; "Functional Title Desc")
            {

            }
            column(deputationOn; "Deputation on")
            {
            }
            column(deputationOnCode; "Deputation On Code") { }
            column(branchCode; "Branch Code")
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
            column(gender; Gender)
            {
            }
            column(extensionCounterCode; "Extension Counter Code")
            {
            }
            column(unitCode; "Unit Code")
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
