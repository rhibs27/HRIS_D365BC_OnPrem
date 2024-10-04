page 33020113 "KPI Target Raw Department"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Target Raw";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
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
                field("Target Score"; Rec."Target Score")
                {
                    ToolTip = 'Specifies the value of the Target Score field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Import KPI Target")
            {
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Import KPI Target action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    KPIMgt.ImportKPITargetDepartment;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Department;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Department);
        Rec.FilterGroup(2);
    end;

    var
        KPIMgt: Codeunit "KPI Mgt.";
}
