page 50273 TAXSetupLineAPI
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'taxSetupLineAPI';
    DelayedInsert = true;
    EntityName = 'taxSetupLineAPI';
    EntitySetName = 'taxSetupLineAPIs';
    PageType = API;
    SourceTable = "Tax Setup Line";

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
                field(taxRate; Rec."Tax Rate")
                {
                    Caption = 'Tax Rate';
                }
                field(startAmount; Rec."Start Amount")
                {
                    Caption = 'Start Amount';
                }
                field(endAmount; Rec."End Amount")
                {
                    Caption = 'End Amount';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
            }
        }
    }
}
