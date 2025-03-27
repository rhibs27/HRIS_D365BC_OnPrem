page 50178 "Branchwise Allowance API"
{

    EntityName = 'branchwiseAllowanceEntity';
    EntitySetName = 'branchwiseAllowanceEntities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Branchwise/Extension Allowance";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(type; Rec.Type) { }
                field("Code"; Rec.Code) { }
                field(Name; Rec.Name) { }
                field(AllowanceType; Rec."Allowance Type") { }
                field(Disabled; Rec.Disabled) { }
            }
        }
    }

    actions { }
}
