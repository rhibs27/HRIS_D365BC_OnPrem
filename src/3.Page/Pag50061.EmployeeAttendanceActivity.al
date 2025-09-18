page 50061 "Employee Attendance & Activity"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Employee Attendance & Activity";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Attendance Date"; Rec."Attendance Date")
                {
                    ToolTip = 'Specifies the value of the Attendance Date field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Attendance Date BS"; Rec."Attendance Date (B.S)")
                {
                    ToolTip = 'Specifies the value of the Attendance Date BS field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Check In Time"; Rec."Check In Time")
                {
                    ToolTip = 'Specifies the value of the Check In Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Check Out Time"; Rec."Check Out Time")
                {
                    ToolTip = 'Specifies the value of the Check Out Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field(Week; Rec.Week)
                {
                    ToolTip = 'Specifies the value of the Week field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ToolTip = 'Specifies the value of the Day Type field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Employee Working Shift"; Rec."Employee Working Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Working Shift field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Late Deduction"; Rec."Late Deduction")
                {
                    ToolTip = 'Specifies the value of the Late Deduction field.';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = Colors;
                }
                field("Shift Start Time"; Rec."Shift Start Time")
                {
                    ToolTip = 'Specifies the value of the Shift Start Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Shift End Time"; Rec."Shift End Time")
                {
                    ToolTip = 'Specifies the value of the Shift End Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specified the value of Province Code field';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specified the value of Province Name field';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specified the value of Branch Code field';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specified the value of Branch Name field';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specified the value of Department Code field';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specified the value of Department Name field';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Check In Difference"; Rec."Check In Difference")
                {
                    ToolTip = 'Specifies the value of the Check In Difference field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Check Out Difference"; Rec."Check Out Difference")
                {
                    ToolTip = 'Specifies the value of the Check Out Difference field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Standard Work Time"; Rec."Standard Work Time")
                {
                    ToolTip = 'Specifies the value of the Standard Work Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Actual Work Time"; Rec."Actual Work Time")
                {
                    ToolTip = 'Specifies the value of the Actual Work Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Work Time Difference"; Rec."Work Time Difference")
                {
                    ToolTip = 'Specifies the value of the Work Time Difference field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Present Day"; Rec."Present Day")
                {
                    ToolTip = 'Specifies the value of the Present Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Week Off Day"; Rec."Week Off Day")
                {
                    ToolTip = 'Specifies the value of the Week Off Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Leave Day"; Rec."Leave Day")
                {
                    ToolTip = 'Specifies the value of the Leave Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Absent Day"; Rec."Absent Day")
                {
                    ToolTip = 'Specifies the value of the Absent Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Tour Day"; Rec."Tour Day")
                {
                    ToolTip = 'Specifies the value of the Tour Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Friday Counter Days"; Rec."Friday Counter Days")
                {
                    ToolTip = 'Specifies the value of the Friday Counter Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Holiday Counter Days"; Rec."Holiday Counter Days")
                {
                    ToolTip = 'Specifies the value of the Holiday Counter Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Vault Key Days"; Rec."Vault Key Days")
                {
                    Caption = 'Key Custodian Days';
                    ToolTip = 'Specifies the value of the Vault Key Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Evening Counter Days"; Rec."Evening Counter Days")
                {
                    ToolTip = 'Specifies the value of the Evening Counter Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Morning Counter Days"; Rec."Morning Counter Days")
                {
                    ToolTip = 'Specifies the value of the Morning Counter Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Cash Risk Days"; Rec."Cash Risk Days")
                {
                    ToolTip = 'Specifies the value of the Cash Risk Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Festival Counter Days"; Rec."Festival Counter Days")
                {
                    ToolTip = 'Specifies the value of the Festival Counter Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Head Teller allow. days"; Rec."Head Teller Allowance Days")
                {
                    ToolTip = 'Specifies the value of the Head Teller Allowance Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Teller allow. days"; Rec."Teller Allowance Days")
                {
                    ToolTip = 'Specifies the value of the Teller Allowance Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("ATM Custodian Allowance days"; Rec."ATM Custodian Allowance days")
                {
                    ToolTip = 'Specifies the value of the ATM Custodian Allowance Days field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Half Day"; Rec."Half Day")
                {
                    ToolTip = 'Specifies the value of the Half Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Late Check In Day"; Rec."Late Check In Day")
                {
                    ToolTip = 'Specifies the value of the Late Check In Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("OT Hrs"; Rec."OT Hrs")
                {
                    ToolTip = 'Specifies the value of the OT Hrs field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("OT Day"; Rec."OT Day")
                {
                    ToolTip = 'Specifies the value of the OT Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Early Check Out Day"; Rec."Early Check Out Day")
                {
                    ToolTip = 'Specifies the value of the Early Check Out Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Outdoor Duty Day"; Rec."Outdoor Duty Day")
                {
                    ToolTip = 'Specifies the value of the Outdoor Duty Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Training Day"; Rec."Training Day")
                {
                    ToolTip = 'Specifies the value of the Training Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Late Day"; Rec."Late Day")
                {
                    ToolTip = 'Specifies the value of the Late Day field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Daily Food Allowance"; Rec."Daily Food Allowance")
                {
                    ToolTip = 'Specifies the value of the Daily Food Allowance field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Employee Activity Found"; Rec."Employee Activity Found")
                {
                    ToolTip = 'Specifies the value of the Employee Activity Found field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Created Datetime"; Rec."Created Datetime")
                {
                    ToolTip = 'Specifies the value of the Created Datetime field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Holiday Remarks"; Rec."Holiday Remarks")
                {
                    ToolTip = 'Specifies the value of the Holiday Remarks field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ToolTip = 'Specifies the value of the Pay Type field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Punch Out Reviewer"; Rec."Punch Out Reviewer")
                {
                    ToolTip = 'Specifies the value of the Punch Out Reviewer field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Punch Out Check Reviewer"; Rec."Punch Out Check Reviewer")
                {
                    ToolTip = 'Specifies the value of the Punch Out Check Reviewer field.';
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = Colors;
                }
                field("Overtime Disbursed"; Rec."Overtime Disbursed")
                {
                    ToolTip = 'Specifies the value of the Overtime Disbursed field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Night Shift Punch Out Time"; Rec."Night Shift Punch Out Time")
                {
                    ToolTip = 'Specifies the value of the Night Shift Punch Out Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Training Check In Time"; Rec."Training Check In Time")
                {
                    ToolTip = 'Specifies the value of the Training Check In Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Training Check Out Time"; Rec."Training Check Out Time")
                {
                    ToolTip = 'Specifies the value of the Training Check Out Time field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    ApplicationArea = All;
                    StyleExpr = Colors;
                }
                field("Check-In Device IP"; Rec."Check-In Device IP")
                {
                    ToolTip = 'Specifies the value of the Check-In Device IP field.', Comment = '%';
                    StyleExpr = Colors;
                }
                field("Check-Out Device IP"; Rec."Check-Out Device IP")
                {
                    ToolTip = 'Specifies the value of the Check-Out Device IP field.', Comment = '%';
                    StyleExpr = Colors;
                }
            }
        }
    }
    var
        Colors: Text;

    trigger OnAfterGetRecord()
    begin
        Colors := 'standard';
        if "Absent Day" = 1 then
            Colors := 'Unfavorable'
        else if (Rec."Day Type" = Rec."Day Type"::"Working Day") And ("Absent Day" <> 1) then
            Colors := 'favorable'
        else if Rec."Day Type" = Rec."Day Type"::Holiday then
            Colors := 'Ambiguous';
    end;
}
