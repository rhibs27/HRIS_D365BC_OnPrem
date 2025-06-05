query 50027 OrganizationStructureListAPI
{
    APIGroup = 'Hrms';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'organizationStructureList';
    EntitySetName = 'organizationStructureListAPI';
    QueryType = API;

    elements
    {
        dataitem(organizationStructureList; "Organization Structure List")
        {
            column(type; "Type")
            {
            }
            column(code; "Code")
            {
            }
            column(name; Name)
            {
            }
            column(provinceCode; "Province Code")
            {
            }
            column(provinceName; "Province Name")
            {
            }
            column(region; Region)
            {
            }
            column(insideOutsideValley; "InsideOutside Valley")
            {
            }
            column(districtCode; "District code")
            {
            }
            column(districtName; "District Name")
            {
            }
            column(municipalityCode; "Municipality Code")
            {
            }
            column(municipalityName; "Municipality Name")
            {
            }
            column(blocked; Blocked)
            {
            }
            column(remoteAreaCategory; "Remote Area Category")
            {
            }
            column(remoteAreaReduction; "Remote Area Reduction")
            {
            }
        }
    }
}
