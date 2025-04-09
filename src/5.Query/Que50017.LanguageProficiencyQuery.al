query 50017 "Language Proficiency Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'languageProficiency';
    EntitySetName = 'languageProficiencyEntity';
    QueryType = API;

    elements
    {
        dataitem(languageProficiency; "Language Proficiency")
        {
            column(employeeNo; "Employee Code")
            {
            }
            column(language; Language)
            {
            }
            column(reading; Reading)
            {
            }
            column(speaking; Speaking)
            {
            }
            column(typing; Typing)
            {
            }
            column(writing; Writing)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(employeeNo, HRMgt.GetEmployeeNo());
    end;
}
