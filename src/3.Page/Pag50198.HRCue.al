page 50198 "HR Cue"
{
    // version KPI1.00

    PageType = CardPart;
    SourceTable = "HR Cue";
    ApplicationArea = All;
    Caption = 'HR Cue';
    layout
    {
        area(Content)
        {

            cuegroup(Resignation)
            {
                Caption = 'Resignation';
                Visible = Resignationvisibility;
                field("Resignation By Age"; Rec."Resignation By Age")
                {
                    DrillDownPageID = "Resignation List";
                    ToolTip = 'Specifies the value of the Resignation By Age field.';
                    ApplicationArea = All;
                }
                field("Resignation By Service"; Rec."Resignation By Service")
                {
                    DrillDownPageID = "Resignation List";
                    ToolTip = 'Specifies the value of the Resignation By Service field.';
                    ApplicationArea = All;
                }
            }


        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Setvisibility;

        HRSetup.Get;
        Rec.SetRange("Contract Expiry Date Filter", Today, CalcDate(HRSetup."Contract Expiry Days", Today));

        Rec.SetFilter("Expiry Check Date", '<=%1', Today);

        Employee.Reset;
        Employee.SetRange("Employment Type", Employee."Employment Type"::Contract);
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetFilter("Contract Expiry Date", '<>0D');
        if Employee.FindFirst then
            repeat
                if Employee."Contract Expiry Date" > Today then begin
                    Employee."Contract Expiry Remaining Days" := Employee."Contract Expiry Date" - Today;
                    Employee.Modify;
                end;
            until Employee.Next = 0;

        if not HrMgt.IsSaaS() then
            Rec.SetFilter("Employee Filter", HRMgt.GetEmployeeNo());

    end;

    var
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        LeaveVisibility: Boolean;
        TravelVisibility: Boolean;
        TransferVisibility: Boolean;
        BulkCashVisibility: Boolean;
        OvertimeVisibility: Boolean;
        Resignationvisibility: Boolean;
        SalaryAdvVisibility: Boolean;

        AttendanceMissedVisibility: Boolean;
        HRSetup: Record "Human Resources Setup";
        PageTransferList: Page "Employee Transfer Requests";
        HRMgt: Codeunit "HR Mgt.";

    procedure Setvisibility()
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then
            Rec.SetFilter("User Filter", Employee."No.");
        // if not Employee.Screener then
        //     Rec.SetRange("Employee Filter", Employee."No.");

        // UserSetup.Reset;
        // UserSetup.SetRange("User ID", UserId);
        // if UserSetup.FindFirst then begin
        //     LeaveVisibility := UserSetup."For Leave-Dashboard";
        //     TravelVisibility := UserSetup."For Travel-Dashboard";
        //     TransferVisibility := UserSetup."For Transfer-Dashboard";
        //     OvertimeVisibility := UserSetup."For Overtime-Dashboard";
        //     BulkCashVisibility := UserSetup."For BulkCash-Dashboard";
        //     Resignationvisibility := UserSetup."For Resignation-Dashboard";
        //     SalaryAdvVisibility := UserSetup."For Salary Advance";
        //     AttendanceMissedVisibility := UserSetup."For Attend. Missed-Dashboard";
        // end;
    end;
}
