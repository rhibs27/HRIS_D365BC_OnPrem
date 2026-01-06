page 50055 "Salary Deduction Entries"
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
                    Editable = not Rec."Attendance Posted";
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Deduction Type"; Rec."Deduction Type")
                {
                    ToolTip = 'Specifies the value of the Deduction Type field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Deduction Date"; Rec."Deduction Date")
                {
                    ToolTip = 'Specifies the value of the Deduction Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Attendance Posted"; Rec."Attendance Posted")
                {
                    ToolTip = 'Specifies the value of the Attendance Posted field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
            }
        }
    }
}
