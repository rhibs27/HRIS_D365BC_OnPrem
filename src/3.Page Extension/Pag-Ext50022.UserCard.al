pageextension 50022 "User Card" extends "User Card"
{
    actions
    {
        addafter("Sent Emails")
        {
            action(CreateUser)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = User;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the OT Form action.';
                trigger OnAction()
                var

                    Employee: Record Employee;
                    UserRec: Record User;
                    AccessControl: Record "Access Control";
                    UserSetup: Record "User Setup";
                    User: Record User;
                    AggregatePermissionSet: Record "Aggregate Permission Set";
                begin
                    Employee.Reset();
                    if Employee.FindSet() then
                        repeat

                            User.Reset();
                            User.SetRange("User Name", Employee."NAV Login ID");
                            if not User.FindFirst() then begin
                                Clear(UserRec);
                                UserRec.Init();
                                UserRec."User Security ID" := CreateGuid();
                                UserRec.Validate("User Name", Employee."First Name" + '.' + Employee."Last Name");
                                UserRec.Validate("Full Name", Employee.FullName());
                                UserRec.Validate("License Type", UserRec."License Type"::"External User");
                                UserRec.Validate(State, UserRec.State::Enabled);
                                UserRec."Change Password" := false;
                                UserRec.Insert(true);

                                Clear(AccessControl);
                                AccessControl.Init();
                                AccessControl.Validate("User Security ID", UserRec."User Security ID");
                                AccessControl.Validate("Role ID", 'SUPER');
                                AggregatePermissionSet.Reset();
                                AggregatePermissionSet.SetRange("Role ID", AccessControl."Role ID");
                                AggregatePermissionSet.FindFirst();
                                AccessControl.Scope := AggregatePermissionSet.Scope;
                                AccessControl."App ID" := AggregatePermissionSet."App ID";
                                AccessControl.Scope := AggregatePermissionSet.Scope;
                                AccessControl.Insert(true);
                                SetUserPassword(UserRec."User Security ID", 'Hrms@2025');
                            end;
                        until Employee.Next() = 0;

                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)

    begin
        Rec.Validate("License Type", Rec."License Type"::"External User");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean

    begin
        if Rec."User Name" <> '' then begin
            UserSetup.Init;
            UserSetup.Validate("User ID", Rec."User Name");
            UserSetup.Insert;
        end;
    end;

    var
        UserSetup: Record "User Setup";
}
