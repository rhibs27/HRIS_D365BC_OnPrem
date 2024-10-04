page 50238 "Leave Earn Card"
{
    PageType = Card;
    SourceTable = "Leave Earn";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee Full Name"; Rec."Employee Full Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Full Name field.';
                    ApplicationArea = All;
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                }
                field("Balancing Days"; Rec."Balancing Days")
                {
                    ToolTip = 'Specifies the value of the Balancing Days field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Save)
            {
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Save action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.PostLeaveEarn(Rec);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Earned;
    end;
}
