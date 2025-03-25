page 50288 "KPI Setup Functional Bank"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Setup Bank";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                IndentationColumn = NameIndent;
                IndentationControls = "KPI Code";
                field("KPI Code"; Rec."KPI Code")
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ToolTip = 'Specifies the value of the KPI Code field.';
                    ApplicationArea = All;
                }
                field("KPI Description"; Rec."KPI Description")
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the value of the KPI Description field.';
                    ApplicationArea = All;
                }
                field("Weightage %"; Rec."Weightage %")
                {
                    ToolTip = 'Specifies the value of the Weightage % field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("KPI Category"; Rec."KPI Category")
                {
                    ToolTip = 'Specifies the value of the KPI Category field.';
                    ApplicationArea = All;
                }
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
                ToolTip = 'Executes the Indent action.';
                ApplicationArea = All;
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
