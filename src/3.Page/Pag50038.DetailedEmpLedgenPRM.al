page 50038 "Detailed Emp. Ledg. en PRM"
{
    // version PRM19.01.01

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Detailed Employee Ledg. En PRM";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Employee Ledger Entry No."; Rec."Employee Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Employee Ledger Entry No. field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.';
                    ApplicationArea = All;
                }
                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.';
                    ApplicationArea = All;
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period Start Date field.';
                    ApplicationArea = All;
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period End Date field.';
                    ApplicationArea = All;
                }
                field("Attribute Type"; Rec."Attribute Type")
                {
                    ToolTip = 'Specifies the value of the Attribute Type field.';
                    ApplicationArea = All;
                }
                field("Attribute Sub Type"; Rec."Attribute Sub Type")
                {
                    ToolTip = 'Specifies the value of the Attribute Sub Type field.';
                    ApplicationArea = All;
                }
                field("Non-Taxable"; Rec."Non-Taxable")
                {
                    ToolTip = 'Specifies the value of the Non-Taxable field.';
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the &Navigate action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }
}
