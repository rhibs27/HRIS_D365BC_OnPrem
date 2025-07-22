query 50034 Qualification
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'qualification';
    EntitySetName = 'qualificationEntity';
    QueryType = API;
    elements
    {
        dataitem(qualification; Qualification)
        {
            column(code; "Code")
            {
            }
            column(description; Description)
            {
            }
            column(qualificationType; "Qualification Type")
            {
            }
            column(rank; Rank)
            {
            }
            column(type; "Type")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
