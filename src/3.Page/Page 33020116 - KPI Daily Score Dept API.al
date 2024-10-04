page 33020116 "KPI Daily Score Dept API"
{
    // version KPI1.00

    EntityName = 'kpidailyscoredeptapi';
    EntitySetName = 'kpidailyscoredeptapis';
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
                field(Department; Rec.Department) { }
                field(DepartmentName; Rec."Department Name") { }
                field(KPICode; Rec."KPI Code") { }
                field(KPIDescription; Rec."KPI Description") { }
                field(TargetPerDay; Rec."Target Per Day") { }
                field(ActualScorePerDay; Rec."Actual Score Per Day") { }
                field(EntryDate; Rec."Entry Date") { }
                field(Weightage; Rec."Weightage%") { }
                field(KPIType; Rec."KPI Type") { }
                field(KPIScore; Rec."KPI Score") { }
                field(Quarter; Rec.Quarter) { }
                field(Type; Rec.Type) { }
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
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Department;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Department);
        Rec.FilterGroup(2);
    end;

    var
        KPIMgt: Report "KPI Management";
}
