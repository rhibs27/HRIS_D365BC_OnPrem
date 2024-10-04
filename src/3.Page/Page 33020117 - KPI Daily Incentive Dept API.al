page 33020117 "KPI Daily Incentive Dept API"
{
    // version KPI1.00

    EntityName = 'kpidailyincentivedept';
    EntitySetName = 'kpidailyincentivedepts';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "KPI Daily Incentive";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Department; Rec.Department) { }
                field(LocationIncentive; Rec."Location Incentive") { }
                field(RoleIncentive; Rec."Role Incentive") { }
                field(NetKPIScore; Rec."Net KPI Score") { }
                field(KPIScore; Rec."KPI Score") { }
                field(Rating; Rec.Rating) { }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Department);
        Rec.FilterGroup(2);
    end;
}
