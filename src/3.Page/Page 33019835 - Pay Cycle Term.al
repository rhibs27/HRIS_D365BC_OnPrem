page 33019835 "Pay Cycle Term"
{
    // version PRM19.01.01

    PageType = List;
    SourceTable = "Pay Cycle Term";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;
                }
                field(Term; Rec.Term)
                {
                    ToolTip = 'Specifies the value of the Term field.';
                    ApplicationArea = All;
                }
                field("Default Periods"; Rec."Default Periods")
                {
                    ToolTip = 'Specifies the value of the Default Periods field.';
                    ApplicationArea = All;
                }
                field("Periods Generated"; Rec."Periods Generated")
                {
                    ToolTip = 'Specifies the value of the Periods Generated field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Term")
            {
                Caption = '&Term';
                action("&Pay Cycle Periods")
                {
                    Caption = '&Pay Cycle Periods';
                    Image = Period;
                    RunObject = page "Pay Cycle Period";
                    RunPageLink = "Pay Cycle Code" = field("Pay Cycle Code"),
                                  "Pay Cycle Term" = field(Term);
                    ToolTip = 'Executes the &Pay Cycle Periods action.';
                    ApplicationArea = All;
                }
            }
        }
        area(Processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Generate Pay Periods")
                {
                    Caption = '&Generate Pay Periods';
                    Image = ReopenPeriod;
                    ToolTip = 'Executes the &Generate Pay Periods action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PayCyclePeriodGenerator: Report "Pay Cycle Period Generator";
                    begin
                        Clear(PayCyclePeriodGenerator);
                        PayCyclePeriodGenerator.SetOptions(Rec);
                        PayCyclePeriodGenerator.RunModal;
                    end;
                }
            }
        }
    }
}
