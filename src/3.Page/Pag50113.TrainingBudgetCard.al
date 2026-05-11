page 50113 "Training Budget Card"
{
    PageType = Card;
    SourceTable = "Training Budget Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Total Budget"; Rec."Total Budget")
                {
                    ToolTip = 'Specifies the value of the Total Budget field.';
                    ApplicationArea = All;
                }
            }
            part(Control6; "Monthwise Training Budget")
            {
                SubPageLink = "Training Header Entry No." = field("Entry No.");
                ApplicationArea = All;
            }
            part(Control7; "Categorized Budget Summary")
            {
                SubPageLink = "Training Header Entry No." = field("Entry No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Budget Line")
            {
                Image = CreateLinesFromJob;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Create Budget Line action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.GetTrainBudgetLine;
                end;
            }
            action("Calculate YTD Budget")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Calculate YTD Budget action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CalculateMonthlyTrainBudgetLine;
                    Rec.CalculateCategorizedTrainingBudgetLine;
                end;
            }
        }
    }
}
