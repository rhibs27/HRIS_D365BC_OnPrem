page 50236 "Province Entity"
{


    EntityName = 'provinceEntity';
    EntitySetName = 'provinceEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = Province;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("code"; Rec.Code) { }
                field(provinceName; Rec.Description)
                {
                    Caption = 'provinceName';
                }
            }
        }
    }

    actions { }
}
