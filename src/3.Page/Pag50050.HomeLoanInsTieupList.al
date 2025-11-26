page 50050 "Home Loan Ins Tieup List"
{
    ApplicationArea = All;
    Caption = 'Home Loan Ins Tieup List';
    PageType = List;
    SourceTable = "Employee Loan/Advance";
    SourceTableView = where("Loan Type" = const("Home Loan Insurance Tieup"));
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Loan Account No."; Rec."Loan Account No.")
                {
                    ToolTip = 'Specifies the value of the Loan Account No. field.', Comment = '%';
                }
                field("Loan Acc. Open Date"; Rec."Loan Acc. Open Date")
                {
                    ToolTip = 'Specifies the value of the Loan Acc. Open Date field.', Comment = '%';
                }
                field("Loan Expiry Date"; Rec."Loan Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Loan Expiry Date field.';
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the value of the Loan Type field.', Comment = '%';
                }
                field("Disbursed Amount"; Rec."Disbursed Amount")
                {
                    ToolTip = 'Specifies the value of the Disbursed Amount field.';
                }
                field("Insurance Company"; Rec."Insurance Company")
                {
                    ToolTip = 'Specifies the value of the Insurance Company field.', Comment = '%';
                }
                field("Policy No"; Rec."Policy No")
                {
                    ToolTip = 'Specifies the value of the Policy No field.', Comment = '%';
                }
                field("Yearly Premium Amount"; Rec."Yearly Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Yearly Premium Amount field.', Comment = '%';
                }
                field("First Premium Date"; Rec."First Premium Date")
                {
                    ToolTip = 'Specifies the value of the First Premium Date field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
            }
        }
    }
}
