page 50367 "Attribute Usage History"
{
    ApplicationArea = All;
    Caption = 'Payroll Attributes Usage History';
    PageType = List;
    SourceTable = "Attributes Usage History";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll attribute code.';
                }
                field("Old Amount"; Rec."Old Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount.';
                }
                field("New Amount"; Rec."New Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Start date.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the End date.';
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry date.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the entry is reversed.';
                }
            }
        }
    }

}