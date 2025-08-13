page 50171 "Biometric Attendance Logs EBL"
{
    ApplicationArea = All;
    Caption = 'Biometric Attendance Logs';
    PageType = List;
    SourceTable = "Biometric Attendance Log EBL";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Enroll No."; Rec."Enroll No.")
                {
                    ToolTip = 'Specifies the value of the Enroll No. field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Time"; Rec."Time")
                {
                    ToolTip = 'Specifies the value of the Time field.', Comment = '%';
                }
                field("Portal Attendance"; Rec."Portal Attendance")
                {
                    ToolTip = 'Specifies the value of the Portal Attendance field.', Comment = '%';
                }
                field(IP; Rec.IP)
                {
                    ToolTip = 'Specifies the value of the IP field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
            }
        }
    }
}
