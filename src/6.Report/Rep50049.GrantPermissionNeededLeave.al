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
        LeavetypSetup: Record "Leave Type Setup";
        LeaveEarn: Record "Leave Earn";
        LeaveMgt: Codeunit "Leave Mgt.";
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", Today);
        if EngNep.FindFirst then;
        LeavetypSetup.Reset;
        LeavetypSetup.SetFilter(Code, LeaveCodeFilter);

        LeavetypSetup.SetRange("Needed HR Permission", true);
        if LeavetypSetup.Find('-') then
            repeat
                Clear(LeaveEarn);
                if not (LeavetypSetup.Gender = LeavetypSetup.Gender::" ") then
                    if LeavetypSetup.Gender <> Employee.Gender then
                        Error('Not applicable for employee %1', Employee."Full Name");

                if not (LeavetypSetup."Leave For Employee Type" = LeavetypSetup."Leave For Employee Type"::" ") then
                    if LeavetypSetup."Leave For Employee Type" <> Employee."Employment Type" then
                        Error('Not applicable for employee %1', Employee."Full Name");

                if not (LeavetypSetup."Marital Status" = LeavetypSetup."Marital Status"::" ") then
                    if LeavetypSetup."Marital Status" <> Employee."Marital Status" then
                        Error('Not applicable for employee %1', Employee."Full Name");

                if LeavetypSetup."Services Period" then begin
                    LeaveEarn.Reset;
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", LeavetypSetup.Code);
                    LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                    if LeaveEarn.Count >= LeavetypSetup."Times Per Service Period" then
                        Error('Employee has already taken leave for more than %1 times in his service period.', LeavetypSetup."Times Per Service Period");
                end;
                LeaveEarn.Reset;
                LeaveEarn.Init;
                LeaveEarn.Validate("Entry No.", LeaveMgt.GetNextLeaveLedgerEntryNo());
                LeaveEarn.Validate("Leave Code", LeavetypSetup.Code);
                LeaveEarn.Validate("Employee No.", Employee."No.");
                LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
                LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                LeaveEarn.Validate("Posted Date", Today);
                if not LeavetypSetup."Calculate Proratawise" then
                    LeaveEarn.Validate("Balancing Days", LeavetypSetup."Days Earned Per Year")
                else
                    LeaveEarn.Validate("Balancing Days", LeaveMgt.CalculateProDataLeave(LeavetypSetup.Code, Employee."Employment Date"));
                LeaveEarn.Insert(true);
            //END;
            until LeavetypSetup.Next = 0;
    end;
}
