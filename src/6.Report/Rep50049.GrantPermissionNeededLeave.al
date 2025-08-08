report 50049 "Grant Permission Needed Leave"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            trigger OnAfterGetRecord()
            begin
                GrantLeave;
                Message('Completed');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Leave Code"; LeaveCodeFilter)
                {
                    TableRelation = "Leave Type Setup".Code where("Needed HR Permission" = const(true));
                    ToolTip = 'Specifies the value of the LeaveCodeFilter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        LeaveCodeFilter: Text;
        HRMgt: Codeunit "HR Mgt.";

    local procedure GrantLeave()
    var
        EngNep: Record "English-Nepali Date";
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveEarn: Record "Leave Earn";
        LeaveMgt: Codeunit "Leave Mgt.";
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", Today);
        if EngNep.FindFirst then;
        LeaveTypeSetup.Reset;
        LeaveTypeSetup.SetFilter(Code, LeaveCodeFilter);

        LeaveTypeSetup.SetRange("Needed HR Permission", true);
        if LeaveTypeSetup.Find('-') then
            repeat
                Clear(LeaveEarn);
                if not (LeaveTypeSetup.Gender = LeaveTypeSetup.Gender::" ") then
                    if LeaveTypeSetup.Gender <> Employee.Gender then
                        Error('Not applicable for employee %1', Employee."Full Name");

                if not (LeaveTypeSetup."Leave For Employee Type" = LeaveTypeSetup."Leave For Employee Type"::" ") then
                    if LeaveTypeSetup."Leave For Employee Type" <> Employee."Employment Type" then
                        Error('Not applicable for employee %1', Employee."Full Name");

                if not (LeaveTypeSetup."Marital Status" = LeaveTypeSetup."Marital Status"::" ") then
                    if LeaveTypeSetup."Marital Status" <> Employee."Marital Status" then
                        Error('Not applicable for employee %1', Employee."Full Name");

                if LeaveTypeSetup."Services Period" then begin
                    LeaveEarn.Reset;
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", LeaveTypeSetup.Code);
                    LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                    if LeaveEarn.Count >= LeaveTypeSetup."Times Per Service Period" then
                        Error('Employee has already taken leave for more than %1 times in his service period.', LeaveTypeSetup."Times Per Service Period");
                end;
                LeaveEarn.Reset;
                LeaveEarn.Init;
                LeaveEarn.Validate("Leave Code", LeaveTypeSetup.Code);
                LeaveEarn.Validate("Employee No.", Employee."No.");
                LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
                LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                LeaveEarn.Validate("Posted Date", Today);
                if not LeaveTypeSetup."Calculate Proratawise" then
                    LeaveEarn.Validate("Balancing Days", LeaveTypeSetup."Days Earned Per Year")
                else
                    LeaveEarn.Validate("Balancing Days", LeaveMgt.CalculateProDataLeave(LeaveTypeSetup.Code, Employee."Employment Date"));
                LeaveEarn.Validate("Entry No.", LeaveMgt.GetNextLeaveLedgerEntryNo());
                LeaveEarn.Insert(true);
            until LeaveTypeSetup.Next = 0;
    end;
}
