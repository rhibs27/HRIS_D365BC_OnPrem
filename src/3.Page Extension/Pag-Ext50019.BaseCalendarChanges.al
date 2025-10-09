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
            field(Employee; Rec.Employee)
            {
                ApplicationArea = all;
            }
            field(Disabled; Rec.Disabled)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Disabled field.', Comment = '%';
            }
            field("Province Filter -OR"; Rec."Province Filter -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Province Filter -OR field.', Comment = '%';
            }
            field("Gender Filter -OR"; Rec."Gender Filter -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender Filter -OR field.', Comment = '%';
            }
            field("Inside/Outside Valley -OR"; Rec."Inside/Outside Valley -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inside/Outside Valley -OR field.', Comment = '%';
            }
            field("Branch Code -OR"; Rec."Branch Code -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch Code -OR field.', Comment = '%';
            }
            field("District -OR"; Rec."District -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the District -OR field.', Comment = '%';
            }
            field("Municipality -OR"; Rec."Municipality -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Municipality -OR field.', Comment = '%';
            }
            field("Community -OR"; Rec."Community -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Community -OR field.', Comment = '%';
            }
            field("Disabled -OR"; Rec."Disabled -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Disabled -OR field.', Comment = '%';
            }
            field("Employee -OR"; Rec."Employee -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employee -OR field.', Comment = '%';
            }
            field("Posting Region -OR"; Rec."Posting Region -OR")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Region -OR field.', Comment = '%';
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
