page 50231 "Event Calendar API Lists"
{
    // version APINICASIA1.00

    EntityName = 'eventCalendarEntity';
    EntitySetName = 'eventCalendarEntities';
    PageType = API;
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIVersion = 'v2.0';
    APIPublisher = 'Agile';
    SourceTable = "Base Calendar Change";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(empNo; "Employee Filter") { }
                field(BaseCalendarCode; Rec."Base Calendar Code") { }
                field(RecurringSystem; Rec."Recurring System") { }
                field(Date; Rec.Date) { }
                field(Day; Rec.Day) { }
                field(Description; Rec.Description) { }
                field(Nonworking; Rec.Nonworking) { }
                field(HolidayType; Rec."Holiday Type") { }
                field(ProvinceFilter; Rec."Province Filter") { }
                field(GenderFilter; Rec."Gender Filter") { }
                field(InsideOutisdeValley; Rec."Inside/Outisde Valley") { }
                field(PostingRegion; Rec."Posting Region") { }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Employee.Reset;
        Employee.SetRange("No.", Rec.GetFilter("Employee Filter"));
        Employee.FindFirst;
        Rec.SetRange(Nonworking, true);
        Rec.SetFilter("Gender Filter", '%1|%2', Rec."Gender Filter"::" ");
        Rec.SetFilter("Inside/Outisde Valley", '%1|%2', Employee."Inside/Outisde Valley", Rec."Inside/Outisde Valley"::" ");
        Rec.SetFilter("Posting Region", '%1|%2', Employee."Posting Region", Rec."Posting Region"::" ");
        Rec.SetFilter("Province Filter", '%1|%2', StrSubstNo('*%1*', Employee."Province Code"), '');
    end;

    var
        Employee: Record Employee;
}
