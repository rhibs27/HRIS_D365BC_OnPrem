page 50225 "Insurance Company Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'insuranceCompanyEntity';
    DelayedInsert = true;
    EntityName = 'insuranceCompanyEntity';
    EntitySetName = 'insuranceCompanyEntities';
    PageType = API;
    SourceTable = "Insurance Company";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
            }
        }
    }
}
