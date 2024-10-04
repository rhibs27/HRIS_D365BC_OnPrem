page 50305 "KPI Daily Incentive Emp API"
{
    // version KPI1.00

    EntityName = 'kpidailyincempsapi';
    EntitySetName = 'kpidailyincempapis';
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
                field(EmployeeCode; Rec."Employee Code") { }
                field(LocationIncentive; Rec."Location Incentive") { }
                field(RoleIncentive; Rec."Role Incentive") { }
                field(NetKPIScore; Rec."Net KPI Score") { }
                field(KPIScore; Rec."KPI Score") { }
                field(Rating; Rec.Rating) { }
                field(EntryDate; Rec."Entry Date") { }
                field(FunctionalTitle; Rec."Functional Title") { }
                field(Quarter; Rec.Quarter) { }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Employee);
        Rec.FilterGroup(2);
    end;
}
