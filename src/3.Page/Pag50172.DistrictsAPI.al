page 50172 "Districts API"
{
    EntityName = 'districts';
    EntitySetName = 'districts';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = District;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(districtCode; Rec."District Code") { }
                field(districtName; Rec."District Name") { }
                field(province; Rec.Province) { }
                field(provinceName; Rec."Province Name") { }
            }
        }
    }

    actions { }
}
