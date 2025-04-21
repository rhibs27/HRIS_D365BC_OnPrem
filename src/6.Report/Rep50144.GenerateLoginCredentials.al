report 50145 "Generate Login Credentials"
{
    ApplicationArea = All;
    Caption = 'Generate Login Credentials';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    AllowScheduling = false;
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            DataItemTableView = where(Status = const(Active));
            trigger OnAfterGetRecord()
            var
                UserRec: Record User;
                AccessControl: Record "Access Control";
                UserSetup: Record "User Setup";
                User: Record User;
                AggregatePermissionSet: Record "Aggregate Permission Set";
            begin
                // if "NAV Login ID" <> '' then
                //     CurrReport.Skip();
                User.Reset();
                User.SetRange("User Name", Employee."NAV Login ID");
                if User.FindFirst() then
                    CurrReport.Skip();

                Clear(UserRec);
                UserRec.Init();
                UserRec."User Security ID" := CreateGuid();
                UserRec.Validate("User Name", Employee."First Name" + '.' + Employee."Last Name" + '.' + Employee."No.");
                UserRec.Validate("Full Name", Employee.FullName());
                UserRec.Validate("License Type", UserRec."License Type"::"External User");
                UserRec.Validate(State, UserRec.State::Enabled);
                UserRec."Change Password" := true;
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

                // Clear(AccessControl);
                // AccessControl.Init();
                // AccessControl.Validate("User Security ID", UserRec."User Security ID");
                // AccessControl.Validate("Role ID", 'PORTAL');
                // AggregatePermissionSet.Reset();
                // AggregatePermissionSet.SetRange("Role ID", AccessControl."Role ID");
                // AggregatePermissionSet.FindFirst();
                // AccessControl.Scope := AggregatePermissionSet.Scope;
                // AccessControl."App ID" := AggregatePermissionSet."App ID";
                // AccessControl.Scope := AggregatePermissionSet.Scope;
                // AccessControl.Insert(true);

                // Clear(AccessControl);
                // AccessControl.Init();
                // AccessControl.Validate("User Security ID", UserRec."User Security ID");
                // AccessControl.Validate("Role ID", 'HRMS PERMISSION SET');
                // AggregatePermissionSet.Reset();
                // AggregatePermissionSet.SetRange("Role ID", AccessControl."Role ID");
                // AggregatePermissionSet.FindFirst();
                // AccessControl.Scope := AggregatePermissionSet.Scope;
                // AccessControl."App ID" := AggregatePermissionSet."App ID";
                // AccessControl.Scope := AggregatePermissionSet.Scope;
                // AccessControl.Insert(true);

                // Clear(AccessControl);
                // AccessControl.Init();
                // AccessControl.Validate("User Security ID", UserRec."User Security ID");
                // AccessControl.Validate("Role ID", 'SUPER');
                // AccessControl.Insert(true);

                SetUserPassword(UserRec."User Security ID", 'Hrms@2025'); //need randomize password

                Clear(UserSetup);
                UserSetup.Init();
                UserSetup."User ID" := UserRec."User Name";
                if UserSetup.Insert() then;

                Employee."NAV Login ID" := UserRec."User Name";
                if Employee.Modify() then;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }
}
