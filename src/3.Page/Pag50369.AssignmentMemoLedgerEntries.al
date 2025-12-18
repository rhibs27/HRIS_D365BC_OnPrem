page 50369 "Assignment Memo Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Assignment Memo Ledger Entries';
    PageType = List;
    SourceTable = "Assignment Memo Ledger Entry";
    UsageCategory = Lists;
    InsertAllowed = false;
    // ModifyAllowed = false;
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
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    Editable = false;
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
                    Editable = false;
                }
                field("Applied Document No."; Rec."Payroll Document No.")
                {
                    ToolTip = 'Specifies the value of the Applied Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.', Comment = '%';
                    Editable = false;
                }
                field("Substituted Employee No."; Rec."Substituted Employee No.")
                {
                    ToolTip = 'Specifies the value of the Substituted Employee No. field.', Comment = '%';
                    Editable = false;
                }
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
                    Editable = false;
                }
                field(Claimed; Rec.Claimed)
                {
                    ToolTip = 'Specifies the value of the Claimed field.', Comment = '%';
                }
                field("Claimed Doc No."; Rec."Claimed Doc No.")
                {
                    ToolTip = 'Specifies the value of the Claimed Doc No. field.', Comment = '%';
                }
                field(Pannel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Pannel field.', Comment = '%';
                    Editable = false;
                }
                field("Valid From Date"; Rec."Valid From Date")
                {
                    ToolTip = 'Specifies the value of the Valid From Date field.', Comment = '%';
                }
                field("Valid To Date"; Rec."Valid To Date")
                {
                    ToolTip = 'Specifies the value of the Valid To Date field.', Comment = '%';
                }
                field("Blocked for Payroll"; Rec."Blocked for Payroll")
                {
                    ToolTip = 'Specifies the value of the Blocked for Payroll field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }

            }
        }
    }
}
