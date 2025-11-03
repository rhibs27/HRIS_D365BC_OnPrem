page 50369 "Assignment Memo Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Assignment Memo Ledger Entries';
    PageType = List;
    SourceTable = "Assignment Memo Ledger Entry";
    UsageCategory = History;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Enrty No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Enrty No. field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(Open; Rec.Open)
                {
                    ToolTip = 'Specifies the value of the Open field.', Comment = '%';
                }
                field("Employee Activity Type"; Rec."Employee Activity Type")
                {
                    ToolTip = 'Specifies the value of the Employee Activity Type field.', Comment = '%';
                }
                field("Applied Document No."; Rec."Applied Document No.")
                {
                    ToolTip = 'Specifies the value of the Applied Document No. field.', Comment = '%';
                }
                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.', Comment = '%';
                }
                field("Substituted Employee No."; Rec."Substituted Employee No.")
                {
                    ToolTip = 'Specifies the value of the Substituted Employee No. field.', Comment = '%';
                }
            }
        }
    }
}
