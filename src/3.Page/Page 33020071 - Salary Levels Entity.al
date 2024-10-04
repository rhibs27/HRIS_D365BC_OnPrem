page 33020071 "Salary Levels Entity"
{
    // version PRM19.01.01

    EntityName = 'salaryLevelsEntity';
    EntitySetName = 'salaryLevelsEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Salary Level";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(Rank; Rec.Rank) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Promotion Eligibilty Criteria")
            {
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Promotion Eligibilty Criteria";
                RunPageLink = "Salary Level" = field(Code);
            }
        }
    }
}
