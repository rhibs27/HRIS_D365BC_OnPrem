query 50028 Currency
{
    APIGroup = 'Hrms';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'currency';
    EntitySetName = 'currencyApi';
    QueryType = API;

    elements
    {
        dataitem(Currency; Currency)
        {
            column(code; "Code")
            {
            }
            column(description; Description)
            {
            }
        }
    }
}
