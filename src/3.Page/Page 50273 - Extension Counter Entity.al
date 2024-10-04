page 50273 "Extension Counter Entity"
{
    EntityName = 'extensionCounterEntity';
    EntitySetName = 'extensionCounterEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Employee Hierarchy Master";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(SubProvince; Rec."Sub-Province") { }
                field(Type; Rec.Type) { }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code") { }
                field(SolID; Rec."Sol ID") { }
                field(DepartmentCode; Rec."Department Code") { }
                field(ReportingCategory; Rec."Reporting Category") { }
                field(Blocked; Rec.Blocked) { }
            }
        }
    }

    actions { }
}
