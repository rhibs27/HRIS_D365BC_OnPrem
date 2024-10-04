page 50172 "Districts API"
{
    // version APINICASIA1.00

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
                field(DistrictCode; Rec."District Code") { }
                field(DistrictName; Rec."District Name") { }
                field(Province; Rec.Province) { }
                field(ProvinceName; Rec."Province Name") { }
                field(SubProvinceCode; Rec."Sub-Province Code") { }
                field(SubProvinceName; Rec."Sub-Province Name") { }
            }
        }
    }

    actions { }
}
