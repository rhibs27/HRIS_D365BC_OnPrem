page 50018 "Municipalities Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'municipalities';
    DelayedInsert = true;
    EntityName = 'municipality';
    EntitySetName = 'municipalities';
    PageType = API;
    SourceTable = Municipality;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(municipalityName; Rec."Municipality Name")
                {
                    Caption = 'Municipality Name';
                }
                field(districtName; Rec."District Name")
                {
                    Caption = 'District Name';
                }
                field(noOfWard; Rec."No of ward")
                {
                    Caption = 'No of ward';
                }
            }
        }
    }
}
