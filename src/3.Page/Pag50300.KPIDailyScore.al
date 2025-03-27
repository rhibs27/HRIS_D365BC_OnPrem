page 50300 "KPI Daily Score"
{
    // version KPI1.00

    AutoSplitKey = false;
    PageType = List;
    SourceTable = "KPI Daily Score";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
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
                field("Target Per Day"; Rec."Target Per Day")
                {
                    ToolTip = 'Specifies the value of the Target Per Day field.';
                    ApplicationArea = All;
                }
                field("Actual Score Per Day"; Rec."Actual Score Per Day")
                {
                    ToolTip = 'Specifies the value of the Actual Score Per Day field.';
                    ApplicationArea = All;
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ToolTip = 'Specifies the value of the Entry Date field.';
                    ApplicationArea = All;
                }
                field("Weightage%"; Rec."Weightage%")
                {
                    ToolTip = 'Specifies the value of the Weightage% field.';
                    ApplicationArea = All;
                }
                field("KPI Type"; Rec."KPI Type")
                {
                    ToolTip = 'Specifies the value of the KPI Type field.';
                    ApplicationArea = All;
                }
                field("KPI Score"; Rec."KPI Score")
                {
                    ToolTip = 'Specifies the value of the KPI Score field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Calculate KPI Score")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Calculate KPI Score action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    KPIMgt.CalculateKPIs;
                end;
            }
            action("Import KPI Daily Score")
            {
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Import KPI Daily Score action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    KPImgtCo.ImportXMLFile;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetRange(Type, Rec.Type::Employee);
        Rec.FilterGroup(2);
    end;

    var
        KPIMgt: Report "KPI Management";
        KPImgtCo: Codeunit "KPI Mgt.";
}
