pageextension 50008 ChangeLogEntries extends "Change Log Entries"
{
    actions
    {
        modify(Setup)
        {
            Visible = false;
        }
    }
    trigger OnOpenPage()

    begin
        UserSetup.Get(UserId);
        if not UserSetup."Can View Change Log" then
            Error(Err001);
    end;

    var
        UserSetup: Record "User Setup";
        Err001: Label 'You do not have permission to view Change Log List Page.';
}
