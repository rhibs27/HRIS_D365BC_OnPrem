page 50289 "KPI Setup Department (NIC)"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Setup Bank";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("KPI Code"; Rec."KPI Code")
                {
                    ToolTip = 'Specifies the value of the KPI Code field.';
                    ApplicationArea = All;
                }
                field("KPI Description"; Rec."KPI Description")
                {
                    ToolTip = 'Specifies the value of the KPI Description field.';
                    ApplicationArea = All;
                }
                field("Weightage %"; Rec."Weightage %")
                {
                    ToolTip = 'Specifies the value of the Weightage % field.';
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

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        DepartmentTitle := Rec.GetFilter(Code);//KPI1.00
        if DepartmentTitle <> '' then
            DepartmentTitle := Rec.Code;
    end;

    var
        DepartmentTitle: Text;
}
