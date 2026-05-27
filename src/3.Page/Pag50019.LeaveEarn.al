page 50019 "Leave Earn"
{
    // Editable = false;
    // ModifyAllowed = false;
    PageType = List;
    SourceTable = "Leave Earn";
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field(EmpNo; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the EmpNo field.';
                    ApplicationArea = All;
                }
                field("Employee Full Name"; Rec."Employee Full Name")
                {
                    ToolTip = 'Specifies the value of the Employee Full Name field.';
                    ApplicationArea = All;
                }
                field("Fiscal year"; Rec."Fiscal year")
                {
                    ToolTip = 'Specifies the value of the Fiscal year field.';
                    ApplicationArea = All;
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    ToolTip = 'Specifies the value of the Posted Date field.';
                    ApplicationArea = All;
                }
                field("Balancing Days"; Rec."Balancing Days")
                {
                    ToolTip = 'Specifies the value of the Balancing Days field.';
                    ApplicationArea = All;
                }
                field("Nepali year"; rec."Nepali year")
                {
                    ToolTip = 'Specifies the value of the Nepali year field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Leave Request No"; Rec."Leave Request No")
                {
                    ToolTip = 'Specifies the value of the Leave Request No field.';
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
