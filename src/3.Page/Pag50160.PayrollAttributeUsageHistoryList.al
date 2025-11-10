page 50367 "Attribute Usage History"
{
    ApplicationArea = All;
    Caption = 'Payroll Attributes Usage History';
    PageType = List;
    SourceTable = "Attributes Usage History";
    UsageCategory = Lists;
    //Editable = false;

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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount.';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the effective date.';
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry date.';
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