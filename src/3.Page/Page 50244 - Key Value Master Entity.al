page 50244 "Key Value Master Entity"
{
    EntityName = 'keyValueMasterEntity';
    EntitySetName = 'keyValueMasterEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Key Value Master";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(code; Rec.Code) { }
                field(description; Rec.Description) { }
                field(type; Rec.Type) { }
            }
        }
    }

    actions { }
}
