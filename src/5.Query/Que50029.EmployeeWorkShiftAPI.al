query 50029 "Employee Work Shift API"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'employeeWorkShift';
    EntitySetName = 'employeeWorkShiftEntity';
    QueryType = API;

    elements
    {
        dataitem(employeeWorkShift; "Employee Work Shift")
        {
            column("code"; "Code")
            {
            }
            column(description; Description)
            {
            }
            column(startTime; "Start Time")
            {
            }
            column(endTime; "End Time")
            {
            }
            column(deputationType; "Deputation Type")
            {
            }
            column(deputationCode; "Deputation Code")   
            {
            }
            column(fridayEndTime; "Friday End Time")
            {
            }
            column(winterStartDate; "Winter Start Date")
            {
            }
            column(winterEndDate; "Winter End Date")
            {
            }
            column(workTime; "Work Time")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
