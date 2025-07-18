pageextension 50019 "Base Calendar Changes" extends "Base Calendar Changes"
{
    layout
    {
        addafter(Nonworking)
        {
            field("Holiday Type"; Rec."Holiday Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Holiday Type field.';
            }
            field("Province Filter"; Rec."Province Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Province Filter field.';
                trigger OnLookup(var Text: Text): Boolean

                begin
                    Rec."Province Filter" := HRMgt.SetCalendarHolidayProvience(Rec."Province Filter")
                end;
            }
            field("Gender Filter"; Rec."Gender Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender Filter field.';
            }
            field("Inside/Outisde Valley"; Rec."Inside/Outside Valley")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inside/Outside Valley field.';
            }
            field("Posting Region"; Rec."Posting Region")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Region field.';
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
            }
            field(Community; Rec.Community)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("Update Holiday in Attendance Log")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = UpdateUnitCost;
                PromotedCategory = Process;
                ToolTip = 'Executes the Update Holiday in Attendance Log action.';

                trigger OnAction()
                begin
                end;
            }
        }
    }
    var
        HRMgt: Codeunit "HR Mgt.";
}
