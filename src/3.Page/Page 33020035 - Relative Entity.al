page 33020035 "Relative Entity"
{
    // version APINICASIA1.00

    EntityName = 'relativeEntity';
    EntitySetName = 'relativeEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = Relative;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(RelationInNepali; Rec."Relation (In Nepali)") { }
                field(MaleCorresRelationNepali; Rec."Male Corres. Relation (Nepali)") { }
                field(FemaleCorresRelationNepali; Rec."FemaleCorres. Relation(Nepali)") { }
                field(Relation; Rec.Relation) { }
            }
        }
    }

    actions { }
}
