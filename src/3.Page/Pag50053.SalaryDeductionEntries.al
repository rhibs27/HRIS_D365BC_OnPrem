page 50053 "Salary Deduction Entries"
{
    ApplicationArea = All;
    Caption = 'Salary Deduction Entries';
    PageType = List;
    SourceTable = "Salary Deduction Entry";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Deduction Type"; Rec."Deduction Type")
                {
                    ToolTip = 'Specifies the value of the Deduction Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Deduction Date"; Rec."Deduction Date")
                {
                    ToolTip = 'Specifies the value of the Deduction Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Count field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
