page 50049 "Employee Work Shift"
{
    // version ATM.19.01.01

    PageType = List;
    SourceTable = "Employee Work Shift";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Deputation Type"; Rec."Deputation Type")
                {
                    ApplicationArea = All;
                }
                field("Deputation Code"; Rec."Deputation Code")
                {
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field("Working Time"; Rec."Work Time")
                {
                    ToolTip = 'Specifies the value of the Working Time field.';
                    ApplicationArea = All;
                }
                field("Check In From"; Rec."Check In From")
                {
                    ToolTip = 'Specifies the value of the Check In From field.';
                    ApplicationArea = All;
                    Caption = 'Check In from (Hrs)';
                }
                field("Check Out From"; Rec."Check Out From")
                {
                    ToolTip = 'Specifies the value of the Check Out From field.';
                    ApplicationArea = All;
                    Caption = 'Check Out from (Hrs)';
                }
                field(OverNight; rec.OverNight)
                {
                    ToolTip = 'Specifies the value of the Overnight From field.';
                    ApplicationArea = All;
                }
                field("OverTime Hours"; Rec."OverTime Hours")
                {
                    ToolTip = 'Specifies the value of the OverTime Hours field.';
                    ApplicationArea = All;
                }
                field("Lunch Start"; Rec."Lunch Start")
                {
                    ToolTip = 'Specifies the value of the Lunch Start field.';
                    ApplicationArea = All;
                }
                field("Winter End Time"; Rec."Winter End Time")
                {
                    ToolTip = 'Specifies the value of the Winter End Time field.';
                    ApplicationArea = All;
                }
                field("Friday End Time"; Rec."Friday End Time")
                {
                    ToolTip = 'Specifies the value of the Friday End Time field.';
                    ApplicationArea = All;
                }
                field("Winter Start Date"; Rec."Winter Start Date")
                {
                    ToolTip = 'Specifies the value of the Winter Start Date field.';
                    ApplicationArea = All;
                }
                field("Winter End Date"; Rec."Winter End Date")
                {
                    ToolTip = 'Specifies the value of the Winter End Date field.';
                    ApplicationArea = All;
                }
                field("Alternate Start Date"; Rec."Alternate Start Date")
                {
                    ToolTip = 'Specifies the value of the Alternate Start Date field.';
                    ApplicationArea = All;
                }
                field("Alternate End Date"; Rec."Alternate End Date")
                {
                    ToolTip = 'Specifies the value of the Alternate End Date field.';
                    ApplicationArea = All;
                }
                field("Alternate Start Time"; Rec."Alternate Start Time")
                {
                    ToolTip = 'Specifies the value of the Alternate Start Time field.';
                    ApplicationArea = All;
                }
                field("Alternate End Time"; Rec."Alternate End Time")
                {
                    ToolTip = 'Specifies the value of the Alternate End Time field.';
                    ApplicationArea = All;
                }
                field("Alternate Friday End Time"; Rec."Alternate Friday End Time")
                {
                    ToolTip = 'Specifies the value of the Alternate End Time field.';
                    ApplicationArea = All;
                }
                field("Default Employee Type"; Rec."Default Employee Type")
                {
                    ToolTip = 'Specifies the value of the Default Employee Type field.';
                    ApplicationArea = All;
                }
                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.', Comment = '%';
                }
                field("Registered Employees"; Rec."Registered Employees")
                {
                    ToolTip = 'Specifies the value of the Registered Employees field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
