page 50315 "Reason Code Master"
{
    ApplicationArea = All;
    Caption = 'Reason Code Master';
    PageType = List;
    SourceTable = "Standard Text";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Activity Type"; Rec."Employee Activity Type")
                {
                    ToolTip = 'Specifies the value of the Employee Activity Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Check-in/Check-out Mandatory"; Rec."Check-in/Check-out Mandatory")
                {
                    ToolTip = 'Specifies the value of the Check-in/Check-out Mandatory field. If set to true, check-in or check-out must be input while sending attendance missed', Comment = '%';
                }
                field("Attendance Entry Type"; Rec."Attendance Entry Type")
                {
                    ToolTip = 'Specifies the value of the Attendance Entry Type field.', Comment = '%';
                }
                field("Attendance Missed Access"; Rec."Attendance Missed Access")
                {
                    ToolTip = 'Specifies the value of the Attendance Missed Access field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        TypFilter := Rec.GetFilter("Employee Activity Type");
        if TypFilter = Format(Rec."Employee Activity Type"::"Attendance Missed") then
            Rec.Validate("Employee Activity Type", Rec."Employee Activity Type"::"Attendance Missed");
    end;

    var
        TypFilter: Text;
}
