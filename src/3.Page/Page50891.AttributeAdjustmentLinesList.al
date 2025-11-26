page 50375 "Attribute Adjustment Lines"
{
    PageType = ListPart;
    SourceTable = "Attribute Adjustment Line";
    ApplicationArea = All;
    Caption = 'Attribute Adjustment Lines';
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Employee Name"; Rec."Employee Name") { ApplicationArea = All; }
                field("Adjustment Type"; Rec."Adjustment Type") { ApplicationArea = All; }
                field("Attribute Code"; Rec."Attribute Code") { ApplicationArea = All; }
                field("Old Amount"; Rec."Old Amount") { ApplicationArea = All; }
                field("New Amount"; Rec."New Amount") { ApplicationArea = All; }
                field("Effective Start Date"; Rec."Effective Start Date") { ApplicationArea = All; }
                field("Effective End Date"; Rec."Effective End Date") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(InsertLine)
            {
                Caption = 'Insert Line';
                ApplicationArea = All;
            }

            action(ExportToExcel)
            {
                Caption = 'Export to Excel';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec."Document No." = '' then
                        Error('No Document selected. Open the Card page and try again.');
                    AttrAdjMgt.ExportLines(Rec."Document No.");
                end;
            }

            action(ImportFromExcel)
            {
                Caption = 'Import from Excel';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec."Document No." = '' then
                        Error('No Document selected. Open the Card page and try again.');
                    AttrAdjMgt.ImportLines(Rec."Document No.");
                    CurrPage.Update();
                end;
            }
        }
    }
    var
        AttrAdjMgt: Codeunit "Excel Import";
}
