page 50219 "OrgStrucLine API"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'orgStrucLineAPI';
    InsertAllowed = false;
    EntityName = 'orgStructureLineEntity';
    EntitySetName = 'orgStructureLineEntities';
    PageType = API;
    SourceTable = "Organization Structure line";

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
                field(reportingCode; Rec."Reporting Code")
                {
                    Caption = 'Reporting Code';
                }
                field(reportingName; Rec."Reporting Name")
                {
                    Caption = 'Reporting Name';
                }
                field(reportingType; Rec."Reporting Type")
                {
                    Caption = 'Reporting Type';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
            }
        }
    }
}
