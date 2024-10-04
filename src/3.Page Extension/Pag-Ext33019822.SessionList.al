pageextension 33019822 "Session List" extends "Concurrent Session List"
{
    actions
    {
        addlast(Processing)
        {
            action("Kill Sessions")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Delete;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Kill Sessions action.';

                trigger OnAction()
                begin
                    if Confirm('Do you want to kill session?', false) then
                        StopSession(Rec."Session ID");
                end;
            }
        }
    }
}
