page 50194 "Attendance Logs"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Attendance Log";
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Emp DateTime"; rec."Emp DateTime")
                {
                    ToolTip = 'Specifies the value of the Employee ID field.';
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ToolTip = 'Specifies the value of the Employee ID field.';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field("Log Time"; Rec."Log Time")
                {
                    ToolTip = 'Specifies the value of the Check In Time field.';
                    ApplicationArea = All;
                    Caption = 'Attendance Time';
                }
                field("Date Time Log"; Rec."Date Time Log")
                {
                    ApplicationArea = All;
                }
                field("Device IP"; Rec."Device IP")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
