page 50304 "KPI Daily Score API"
{
    // version KPI1.00

    AutoSplitKey = false;
    EntityName = 'kpidailyscoreemp';
    EntitySetName = 'kpidailyscoresemp';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "KPI Daily Score";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(EmployeeCode; Rec."Employee Code") { }
                field(Type; Rec.Type) { }
                field(KPICode; Rec."KPI Code") { }
                field(KPIDescription; Rec."KPI Description") { }
                field(TargetPerDay; Rec."Target Per Day") { }
                field(ActualScorePerDay; Rec."Actual Score Per Day") { }
                field(EntryDate; Rec."Entry Date") { }
                field(Weightage; Rec."Weightage%") { }
                field(KPIType; Rec."KPI Type") { }
                field(KPIScore; Rec."KPI Score") { }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Calculate KPI Score")
            {
                trigger OnAction()
                begin
                    KPIMgt.CalculateKPIs;
                end;
            }
            action("Calculate Location Incentive") { }
            action(import)
            {
                trigger OnAction()
                begin
                    // KPImgtCo.ImportXMLFile;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Employee);
        Rec.FilterGroup(2);
    end;

    var
        KPIMgt: Report "KPI Management";
        KPImgtCo: Codeunit "KPI Mgt.";
}
