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
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.', Comment = '%';
                }
                field("Deduction Type"; Rec."Deduction Type")
                {
                    ToolTip = 'Specifies the value of the Deduction Type field.', Comment = '%';
                }
                field("Deduction Date"; Rec."Deduction Date")
                {
                    ToolTip = 'Specifies the value of the Deduction Date field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Count field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
            }
        }
    }
}
