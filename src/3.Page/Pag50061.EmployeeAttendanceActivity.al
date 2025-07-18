page 50061 "Employee Attendance & Activity"
{
    // version ATM.19.01.01

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
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Attendance Date"; Rec."Attendance Date")
                {
                    ToolTip = 'Specifies the value of the Attendance Date field.';
                    ApplicationArea = All;
                }
                field("Check In Time"; Rec."Check In Time")
                {
                    ToolTip = 'Specifies the value of the Check In Time field.';
                    ApplicationArea = All;
                }
                field("Check Out Time"; Rec."Check Out Time")
                {
                    ToolTip = 'Specifies the value of the Check Out Time field.';
                    ApplicationArea = All;
                }
                field("Punch out Remarks"; Rec."Punch out Remarks")
                {
                    ToolTip = 'Specifies the value of the Punch out Remarks field.';
                    ApplicationArea = All;
                }
                field("Late Remarks"; Rec."Late Remarks")
                {
                    Caption = 'Remarks';
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ToolTip = 'Specifies the value of the Day Type field.';
                    ApplicationArea = All;
                }
                field("Employee Working Shift"; Rec."Employee Working Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Working Shift field.';
                    ApplicationArea = All;
                }
                field("Late Deduction"; Rec."Late Deduction")
                {
                    ToolTip = 'Specifies the value of the Late Deduction field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shift Start Time"; Rec."Shift Start Time")
                {
                    ToolTip = 'Specifies the value of the Shift Start Time field.';
                    ApplicationArea = All;
                }
                field("Shift End Time"; Rec."Shift End Time")
                {
                    ToolTip = 'Specifies the value of the Shift End Time field.';
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specified the value of Province Code field';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    ToolTip = 'Specified the value of Province Name field';
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specified the value of Branch Code field';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specified the value of Branch Name field';
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specified the value of Department Code field';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specified the value of Department Name field';
                    ApplicationArea = All;
                }
                field("Check In Difference"; Rec."Check In Difference")
                {
                    ToolTip = 'Specifies the value of the Check In Difference field.';
                    ApplicationArea = All;
                }
                field("Check Out Difference"; Rec."Check Out Difference")
                {
                    ToolTip = 'Specifies the value of the Check Out Difference field.';
                    ApplicationArea = All;
                }
                field("Standard Work Time"; Rec."Standard Work Time")
                {
                    ToolTip = 'Specifies the value of the Standard Work Time field.';
                    ApplicationArea = All;
                }
                field("Actual Work Time"; Rec."Actual Work Time")
                {
                    ToolTip = 'Specifies the value of the Actual Work Time field.';
                    ApplicationArea = All;
                }
                field("Work Time Difference"; Rec."Work Time Difference")
                {
                    ToolTip = 'Specifies the value of the Work Time Difference field.';
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
                field("Tour Day"; Rec."Tour Day")
                {
                    ToolTip = 'Specifies the value of the Tour Day field.';
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
                    Caption = 'Key Custodian Days';
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
                field("Head Teller allow. days"; Rec."Head Teller Allowance Days")
                {
                    ToolTip = 'Specifies the value of the Head Teller Allowance Days field.';
                    ApplicationArea = All;
                }
                field("Teller allow. days"; Rec."Teller Allowance Days")
                {
                    ToolTip = 'Specifies the value of the Teller Allowance Days field.';
                    ApplicationArea = All;
                }
                field("ATM Custodian Allowance days"; Rec."ATM Custodian Allowance days")
                {
                    ToolTip = 'Specifies the value of the ATM Custodian Allowance Days field.';
                    ApplicationArea = All;
                }
                field("Half Day"; Rec."Half Day")
                {
                    ToolTip = 'Specifies the value of the Half Day field.';
                    ApplicationArea = All;
                }
                field("Late Check In Day"; Rec."Late Check In Day")
                {
                    ToolTip = 'Specifies the value of the Late Check In Day field.';
                    ApplicationArea = All;
                }
                field("OT Hrs"; Rec."OT Hrs")
                {
                    ToolTip = 'Specifies the value of the OT Hrs field.';
                    ApplicationArea = All;
                }
                field("OT Day"; Rec."OT Day")
                {
                    ToolTip = 'Specifies the value of the OT Day field.';
                    ApplicationArea = All;
                }
                field("Early Check Out Day"; Rec."Early Check Out Day")
                {
                    ToolTip = 'Specifies the value of the Early Check Out Day field.';
                    ApplicationArea = All;
                }
                field("Outdoor Duty Day"; Rec."Outdoor Duty Day")
                {
                    ToolTip = 'Specifies the value of the Outdoor Duty Day field.';
                    ApplicationArea = All;
                }
                field("Training Day"; Rec."Training Day")
                {
                    ToolTip = 'Specifies the value of the Training Day field.';
                    ApplicationArea = All;
                }
                field("Late Day"; Rec."Late Day")
                {
                    ToolTip = 'Specifies the value of the Late Day field.';
                    ApplicationArea = All;
                }
                field("Daily Food Allowance"; Rec."Daily Food Allowance")
                {
                    ToolTip = 'Specifies the value of the Daily Food Allowance field.';
                    ApplicationArea = All;
                }
                field("Employee Activity Found"; Rec."Employee Activity Found")
                {
                    ToolTip = 'Specifies the value of the Employee Activity Found field.';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.';
                    ApplicationArea = All;
                }
                field("Created Datetime"; Rec."Created Datetime")
                {
                    ToolTip = 'Specifies the value of the Created Datetime field.';
                    ApplicationArea = All;
                }
                field("Holiday Remarks"; Rec."Holiday Remarks")
                {
                    ToolTip = 'Specifies the value of the Holiday Remarks field.';
                    ApplicationArea = All;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ToolTip = 'Specifies the value of the Pay Type field.';
                    ApplicationArea = All;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Punch Out Reviewer"; Rec."Punch Out Reviewer")
                {
                    ToolTip = 'Specifies the value of the Punch Out Reviewer field.';
                    ApplicationArea = All;
                }
                field("Punch Out Check Reviewer"; Rec."Punch Out Check Reviewer")
                {
                    ToolTip = 'Specifies the value of the Punch Out Check Reviewer field.';
                    ApplicationArea = All;
                }
                field("Overtime Disbursed"; Rec."Overtime Disbursed")
                {
                    ToolTip = 'Specifies the value of the Overtime Disbursed field.';
                    ApplicationArea = All;
                }
                field("Night Shift Punch Out Time"; Rec."Night Shift Punch Out Time")
                {
                    ToolTip = 'Specifies the value of the Night Shift Punch Out Time field.';
                    ApplicationArea = All;
                }
                field("Training Check In Time"; Rec."Training Check In Time")
                {
                    ToolTip = 'Specifies the value of the Training Check In Time field.';
                    ApplicationArea = All;
                }
                field("Training Check Out Time"; Rec."Training Check Out Time")
                {
                    ToolTip = 'Specifies the value of the Training Check Out Time field.';
                    ApplicationArea = All;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    ApplicationArea = All;
                }
                field(Week; Rec.Week)
                {
                    ToolTip = 'Specifies the value of the Week field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(ActionGroup48)
            {
                action("Change Reviewer/ Check Reviewer")
                {
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ToolTip = 'Executes the Change Reviewer/ Check Reviewer action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.updateReviewerCheckReviewer; //Min 12.16.2022
                    end;
                }
            }
        }
    }
}
