page 50281 "KPI Masters API"
{
    // version KPI1.00

    EntityName = 'Kpimaster';
    EntitySetName = 'Kpimasters';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "KPI Master Bank";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(KPINo; Rec."KPI No.") { }
                field(Description; Rec.Description) { }
                field(Blocked; Rec.Blocked) { }
                field(Type; Rec.Type) { }
                field(IsDepartment; Rec."Is Department") { }
                field(IsOperatingProfit; Rec."Is Operating Profit") { }
                field(IsAdjustmentKPI; Rec."Is Adjustment KPI") { }
            }
        }
    }

    actions { }
}
