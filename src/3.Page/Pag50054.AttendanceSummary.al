page 50054 "Attendance Summary"
{
    // version ATM.19.01.01

    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Attendance Summary";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Present Day"; Rec."Present Day")
                {
                    ToolTip = 'Specifies the value of the Present Day field.';
                    ApplicationArea = All;
                }
                field("Week Off Day"; Rec."Week Off Day")
                {
                    ToolTip = 'Specifies the value of the Week Off Day field.';
                    ApplicationArea = All;
                }
                field("Leave Day"; Rec."Leave Day")
                {
                    ToolTip = 'Specifies the value of the Leave Day field.';
                    ApplicationArea = All;
                }
                field("Absent Day"; Rec."Absent Day")
                {
                    ToolTip = 'Specifies the value of the Absent Day field.';
                    ApplicationArea = All;
                }
                field("Total Days"; Rec."Total Days")
                {
                    ToolTip = 'Specifies the value of the Total Days field.';
                    ApplicationArea = All;
                }
                field("Tour Day"; Rec."Tour Day")
                {
                    ToolTip = 'Specifies the value of the Tour Day field.';
                    ApplicationArea = All;
                }
                field("Late Day"; Rec."Late Check In Day")
                {
                    ToolTip = 'Specifies the value of the Late Day field.';
                    ApplicationArea = All;
                }
                field("OT Days"; Rec."OT Days")
                {
                    ToolTip = 'Specifies the value of the OT Days field.';
                    ApplicationArea = All;
                }
                field("OT Hrs"; Rec."OT Hrs")
                {
                    ToolTip = 'Specifies the value of the OT Hrs field.';
                    ApplicationArea = All;
                }
                field("Friday Counter Days"; Rec."Friday Counter Days")
                {
                    ToolTip = 'Specifies the value of the Friday Counter Days field.';
                    ApplicationArea = All;
                }
                field("Holiday Counter Days"; Rec."Holiday Counter Days")
                {
                    ToolTip = 'Specifies the value of the Holiday Counter Days field.';
                    ApplicationArea = All;
                }
                field("Vault Key Days"; Rec."Vault Key Days")
                {
                    ToolTip = 'Specifies the value of the Vault Key Days field.';
                    ApplicationArea = All;
                }
                field("Evening Counter Days"; Rec."Evening Counter Days")
                {
                    ToolTip = 'Specifies the value of the Evening Counter Days field.';
                    ApplicationArea = All;
                }
                field("Morning Counter Days"; Rec."Morning Counter Days")
                {
                    ToolTip = 'Specifies the value of the Morning Counter Days field.';
                    ApplicationArea = All;
                }
                field("Cash Risk Days"; Rec."Cash Risk Days")
                {
                    ToolTip = 'Specifies the value of the Cash Risk Days field.';
                    ApplicationArea = All;
                }
                field("Festival Counter Days"; Rec."Festival Counter Days")
                {
                    ToolTip = 'Specifies the value of the Festival Counter Days field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Device Attendance")
            {
                Image = DepositLines;
                Promoted = true;
                ToolTip = 'Executes the Device Attendance action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.GetDeviceAttendance;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Date Filter", '%1..%2', Rec."From Date", Rec."To Date");
        if PayCyclePeriod.Get(Rec."Pay Cycle Code", Rec."Pay Cycle Term", Rec."Pay Cycle Period") then
            Rec.SetFilter("Allowance Date Filter", '%1..%2', PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
        if Rec.Posted then
            CurrPage.Editable := false
        else
            CurrPage.Editable := true;
        Rec.CalcFields("Present Day", "Week Off Day", "Leave Day", "Absent Day", "Total Days", "Tour Day", "OT Hrs", "OT Days", "Friday Counter Days", "Festival Counter Days",
                    "Holiday Counter Days", "Evening Counter Days", "Morning Counter Days", "Cash Risk Days", "Vault Key Days");
    end;

    var
        PayCyclePeriod: Record "Pay Cycle Period";
}
