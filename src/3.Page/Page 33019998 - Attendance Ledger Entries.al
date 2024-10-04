page 33019998 "Attendance Ledger Entries"
{
    // version AMS6.1.0

    Editable = false;
    PageType = List;
    SourceTable = "Attendance Ledger Entry";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Attendance Date"; Rec."Attendance Date")
                {
                    ToolTip = 'Specifies the value of the Attendance Date field.';
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
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
                field("Entry Subtype"; Rec."Entry Subtype")
                {
                    ToolTip = 'Specifies the value of the Entry Subtype field.';
                    ApplicationArea = All;
                }
                field(Days; Rec.Days)
                {
                    ToolTip = 'Specifies the value of the Days field.';
                    ApplicationArea = All;
                }
                field("Login frequency"; Rec."Login frequency")
                {
                    ToolTip = 'Specifies the value of the Login frequency field.';
                    ApplicationArea = All;
                }
                field("Logout frequency"; Rec."Logout frequency")
                {
                    ToolTip = 'Specifies the value of the Logout frequency field.';
                    ApplicationArea = All;
                }
                field("Presence Minutes"; Rec."Presence Minutes")
                {
                    ToolTip = 'Specifies the value of the Presence Minutes field.';
                    ApplicationArea = All;
                }
                field("Absense Minutes"; Rec."Absense Minutes")
                {
                    ToolTip = 'Specifies the value of the Absense Minutes field.';
                    ApplicationArea = All;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                    ToolTip = 'Specifies the value of the Adjustment Type field.';
                    ApplicationArea = All;
                }
                field("Adjustment Minutes"; Rec."Adjustment Minutes")
                {
                    ToolTip = 'Specifies the value of the Adjustment Minutes field.';
                    ApplicationArea = All;
                }
                field("Conflict Exists"; Rec."Conflict Exists")
                {
                    ToolTip = 'Specifies the value of the Conflict Exists field.';
                    ApplicationArea = All;
                }
                field("Conflict Description"; Rec."Conflict Description")
                {
                    ToolTip = 'Specifies the value of the Conflict Description field.';
                    ApplicationArea = All;
                }
                field(Correction; Rec.Correction)
                {
                    ToolTip = 'Specifies the value of the Correction field.';
                    ApplicationArea = All;
                }
                field("Corrected By"; Rec."Corrected By")
                {
                    ToolTip = 'Specifies the value of the Corrected By field.';
                    ApplicationArea = All;
                }
                field("Correction Reason"; Rec."Correction Reason")
                {
                    ToolTip = 'Specifies the value of the Correction Reason field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("System Remarks"; Rec."System Remarks")
                {
                    ToolTip = 'Specifies the value of the System Remarks field.';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
