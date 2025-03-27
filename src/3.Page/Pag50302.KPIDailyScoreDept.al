page 50302 "KPI Daily Score Dept"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Daily Score";
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
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
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
                field(Quarter; Rec.Quarter)
                {
                    ToolTip = 'Specifies the value of the Quarter field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
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
                ToolTip = 'Executes the Calculate KPI Score action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    KPIMgt.CalculateKPIs;
                end;
            }
            action("Import Qualitative")
            {
                ToolTip = 'Executes the Import Qualitative action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    KPImgtCo.ImportXMLFileDept;
                end;
            }
            action("Import Quantative")
            {
                ToolTip = 'Executes the Import Quantative action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    KPImgtCo.ImportXMLFileDeptQuantitative;
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
        KPIMgt: Report "KPI Management";
        KPImgtCo: Codeunit "KPI Mgt.";
}
