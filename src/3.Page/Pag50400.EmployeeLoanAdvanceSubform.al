page 50400 "Employee Loan Advance Subform"
{
    ApplicationArea = All;
    Caption = 'Employee Loan/Advance Subform';
    PageType = ListPart;
    SourceTable = "Employee Loan/Advance Line";
    AutoSplitKey = true;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Type field.', Comment = '%';
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nepali Month field.', Comment = '%';
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nepali Year field.', Comment = '%';
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
                field("Payroll Attributes"; Rec."Payroll Attributes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Attributes field.', Comment = '%';
                }
                field("Payroll Document No."; Rec."Payroll Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Document No. field.', Comment = '%';
                }
                field("Request By Employee No."; Rec."Request By Employee No.")
                {
                    ToolTip = 'Specifies the value of the Request By Employee No. field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reverse field.', Comment = '%';
                }
                field(Settled; Rec.Settled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Settled field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field(Disbursed; Rec.Disbursed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disbursed field.', Comment = '%';
                }
            }
        }
    }
}
