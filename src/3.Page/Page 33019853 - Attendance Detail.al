page 33019853 "Attendance Detail"
{
    // version ATM.19.01.01

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Attendance Line";
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Employee Working Shift"; Rec."Employee Working Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Working Shift field.';
                    ApplicationArea = All;
                }
                field("Attendance Date"; Rec."Attendance Date")
                {
                    ToolTip = 'Specifies the value of the Attendance Date field.';
                    ApplicationArea = All;
                }
                field("Check In Time"; Rec."Check In Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Check In Time field.';
                    ApplicationArea = All;
                }
                field("Check Out Time"; Rec."Check Out Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Check Out Time field.';
                    ApplicationArea = All;
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
                field("Day Type"; Rec."Day Type")
                {
                    ToolTip = 'Specifies the value of the Day Type field.';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
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
                field("Absent Day"; Rec."Absent Day")
                {
                    ToolTip = 'Specifies the value of the Absent Day field.';
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
                field("Early Check Out Day"; Rec."Early Check Out Day")
                {
                    ToolTip = 'Specifies the value of the Early Check Out Day field.';
                    ApplicationArea = All;
                }
                field("OT Hrs"; Rec."OT Hrs")
                {
                    ToolTip = 'Specifies the value of the OT Hrs field.';
                    ApplicationArea = All;
                }
                field("OT Days"; Rec."OT Days")
                {
                    ToolTip = 'Specifies the value of the OT Days field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        /*IF Posted THEN
          CurrPage.EDITABLE := FALSE
        ELSE
          CurrPage.EDITABLE := TRUE;
          */
    end;
}
