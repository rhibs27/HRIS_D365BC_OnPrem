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
            }
            field("Gender Filter"; Rec."Gender Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender Filter field.';
            }
            field("Inside/Outside Valley"; Rec."Inside/Outside Valley")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inside/Outside Valley field.';
            }
            field("Posting Region"; Rec."Posting Region")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Region field.';
            }
            field("Branch Code"; Rec."Branch code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch Code field.';
            }
            field(District; Rec.District)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the District field.';
            }
            field(Municipality; Rec.Municipality)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Municipality field.';
            }
            field(Community; Rec.Community)
            {
                ApplicationArea = all;
            }
            field(Disabled; Rec.Disabled)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Disabled field.', Comment = '%';
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
