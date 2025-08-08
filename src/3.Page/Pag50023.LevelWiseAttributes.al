page 50023 "Level Wise Attributes"
{
    // version PRM19.01.01

    PageType = List;
    SourceTable = "Level Wise Attributes";
    SourceTableView = sorting("Level Code");
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Level Code"; Rec."Level Code")
                {
                    ToolTip = 'Specifies the value of the Level Code field.';
                    ApplicationArea = All;
                }
                field("Grade Code"; Rec."Grade Code")
                {
                    ToolTip = 'Specifies the value of the Grade Code field.';
                    ApplicationArea = All;
                }
                field("Starting Point"; Rec."Starting Point")
                {
                    ToolTip = 'Specifies the value of the Starting Point field.';
                    ApplicationArea = All;
                }
                field("Annual Income Inc. Grade"; Rec."Annual Income Inc. Grade")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Annual Income Inc. Grade field.';
                    ApplicationArea = All;
                }
                field("Total Income Inc. Grade"; Rec."Total Income Inc. Grade")
                {
                    ToolTip = 'Specifies the value of the Total Income Inc. Grade field.';
                    ApplicationArea = All;
                }
                field("Standard Basic Salary"; Rec."Standard Basic Salary")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Standard Basic Salary field.';
                    ApplicationArea = All;
                }
                field(Grade; Rec.Grade)
                {
                    ToolTip = 'Specifies the value of the Grade field.';
                    ApplicationArea = All;
                }
                field("Total Basic Salary"; Rec."Total Basic Salary")
                {
                    ToolTip = 'Specifies the value of the Total Basic Salary field.';
                    ApplicationArea = All;
                }
                field(Allowance; Rec.Allowance)
                {
                    ToolTip = 'Specifies the value of the Allowance field.';
                    ApplicationArea = All;
                }
                field("TA Out of Pocket"; Rec."TA Out of Pocket")
                {
                    ToolTip = 'Specifies the value of the TA Out of Pocket field.';
                    ApplicationArea = All;
                }
                field("Relocation Allowance"; Rec."Relocation Allowance")
                {
                    ToolTip = 'Specifies the value of the Relocation Allowance field.';
                    ApplicationArea = All;
                }
                field("Outstation Allowance"; Rec."Outstation Allowance")
                {
                    ToolTip = 'Specifies the value of the Outstation Allowance field.';
                    ApplicationArea = All;
                }
                field("Friday Counter Allowance"; Rec."Friday Counter Allowance")
                {
                    ToolTip = 'Specifies the value of the Friday Counter Allowance field.';
                    ApplicationArea = All;
                }
                field("Night Shift Allowance"; Rec."Night Shift Allowance")
                {
                    ToolTip = 'Specifies the value of the Night Shift Allowance field.';
                    ApplicationArea = All;
                }
                field("Club Membership"; Rec."Club Membership")
                {
                    ToolTip = 'Specifies the value of the Club Membership field.';
                    ApplicationArea = All;
                }
                field("Facilitator Allowance"; Rec."Facilitator Allowance")
                {
                    ToolTip = 'Specifies the value of the Facilitator Allowance field.';
                    ApplicationArea = All;
                }
                field("Officiating Allowance"; Rec."Officiating Allowance")
                {
                    ToolTip = 'Specifies the value of the Officiating Allowance field.';
                    ApplicationArea = All;
                }
                field("Additional Time Allowance"; Rec."Additional Time Allowance")
                {
                    ToolTip = 'Specifies the value of the Additional Time Allowance field.';
                    ApplicationArea = All;
                }
                field("Staff Vehicle Allowance"; Rec."Staff Vehicle Allowance")
                {
                    ToolTip = 'Specifies the value of the Staff Vehicle Allowance field.';
                    ApplicationArea = All;
                }
                field("Communication Reim. Allowence"; Rec."Communication Reim. Allowence")
                {
                    ToolTip = 'Specifies the value of the Communication Reim. Allowence field.';
                    ApplicationArea = All;
                }
                field("LFA Allowance"; Rec."LFA Allowance")
                {
                    ToolTip = 'Specifies the value of the LFA Allowance field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CreateAllCombinationOfGradeStep)
                {
                    Caption = 'Create all combinations';
                    Image = CreateLinesFromJob;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Create all combinations action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.CreateAllCombinations;
                    end;
                }
            }
        }
    }
}
