page 33020045 "Key Value Master Entity"
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
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(Type; Rec.Type) { }
            }
        }
    }

    actions { }
}
