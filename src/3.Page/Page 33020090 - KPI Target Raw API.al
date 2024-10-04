page 33020090 "KPI Target Raw API"
{
    // version KPI1.00

    EntityName = 'kpitargetraw';
    EntitySetName = 'kpitargetsraw';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "KPI Target Raw";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(EmployeeCode; Rec."Employee Code") { }
                field(KPICode; Rec."KPI Code") { }
                field(KPIDescription; Rec."KPI Description") { }
                field(TargetScore; Rec."Target Score") { }
                field(StartDate; Rec."Start Date") { }
                field(EndDate; Rec."End Date") { }
                field(AssignedBy; Rec."Assigned By") { }
                field(Type; Rec.Type) { }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Employee;
    end;
}
