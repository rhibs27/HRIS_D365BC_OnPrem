page 50312 "KPI Setup Functional API"
{
    // version KPI1.00

    EntityName = 'kpisetupfunctional';
    EntitySetName = 'kpisetupfunctionals';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "KPI Setup Bank";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                IndentationColumn = NameIndent;
                // IndentationControls = rec."KPI Code";
                field(KPICode; Rec."KPI Code")
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                }
                field(KPIDescription; Rec."KPI Description")
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field(Weightage; Rec."Weightage %") { }
                field("Code"; Rec.Code) { }
                field(Type; Rec.Type) { }
                field(KPICategory; Rec."KPI Category") { }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(Indent)
            {
                Image = Indent;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = codeunit "KPI Setup Indent";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NoEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if FunctionalTitleRec.Get(Rec.Code) then begin
            if not FunctionalTitleRec."Is Specific Functional" then
                Rec.Type := Rec.Type::"Department Central & Province Level"
            else
                Rec.Type := Rec.Type::Functional;
        end;
    end;

    var
        FunctionalTitleRec: Record "Functional Title";
        NameIndent: Integer;
        NoEmphasize: Boolean;
        NameEmphasize: Boolean;
}
