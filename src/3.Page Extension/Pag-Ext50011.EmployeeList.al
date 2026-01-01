pageextension 50011 "Employee List" extends "Employee List"
{
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Full Name"; Rec."Full Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Name field.';
            }
            field("Contract Expiry Date"; Rec."Contract Expiry Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contract Expiry Date field.';
                Visible = false;
            }
            field("Contract Expiry Remaining Days"; Rec."Contract Expiry Remaining Days")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contract Expiry Remaining Days field.';
                Visible = false;
            }
            field(Gender; Rec.Gender)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status field.';
            }
            field("Resignation Date"; Rec."Resignation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Resignation Date field.';
                Visible = false;
            }
            field("Employment Type"; Rec."Employment Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employment Type field.';
            }
            field("Deputation on"; Rec."Deputation on")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deputation on field.';
            }
            field("Province Name"; Rec."Province Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Province Name field.';
                Visible = false;
            }
            field("Branch Name"; Rec."Branch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch Name field.';
            }
            field("Department Name"; Rec."Department Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Department Name field.';
            }
            field("Functional Title Desc"; Rec."Functional Title Desc")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Functional Title Desc field.';
            }
            field("Employment Date"; Rec."Employment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employment Date field.';
                Visible = false;
            }
            field("Confirmation Date"; Rec."Confirmation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Confirmation Date field.';
                Visible = false;
            }
            field("Promotion Date"; Rec."Promotion Date")
            {
                ApplicationArea = All;
                Caption = 'Last Promotion Date';
                Visible = false;
                ToolTip = 'Specifies the value of the Last Promotion Date field.';
            }
            field("Contract Expiry Month"; Rec."Contract Expiry Month")
            {
                ApplicationArea = All;
                Caption = 'Contract Period';
                Visible = false;
                ToolTip = 'Specifies the value of the Contract Period field.';
            }
            field("Birth Date"; Rec."Birth Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Birth Date field.';
                Visible = false;
            }
            field("Company E-Mail"; Rec."Company E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Email field.';
            }
            field("Date of Birth (B.S.)"; Rec."Date of Birth (B.S.)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Date of Birth (B.S.) field.';
                Visible = false;
            }
            field("NAV Login ID"; Rec."NAV Login ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NAV Login ID field.';
                Visible = false;
            }
            field("Salary Grade"; Rec."Salary Grade")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salary Grade field.';
                Visible = false;
            }
            field("GrandFather's Name (Nepali)"; Rec."GrandFather's Name (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GrandFather''s Name (Nepali) field.';
                Visible = false;
            }
            field("Father's Name (Nepali)"; Rec."Father's Name (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Father''s Name (Nepali) field.';
                Visible = false;
            }
            field("Mother's Name (Nepali)"; Rec."Mother's Name (Nepali)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mother''s Name (Nepali) field.';
                Visible = false;
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Account No. field.';
                Visible = false;
            }
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Marital Status field.';
                Visible = false;
            }
            field("Approver Role"; Rec."Approver Role")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Salary Level"; Rec."Salary Level")
            {
                ApplicationArea = All;
                Caption = 'Job Position';
            }
        }
    }
    actions
    {
        modify(PayEmployee)
        {
            Visible = false;
        }
        modify("Ledger E&ntries")
        {
            Visible = false;
        }
        modify("Absence Registration")
        {
            Visible = false;
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify("Sent Emails")
        {
            Visible = false;
        }
        modify("E&mployee")
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec."Contract Expiry Remaining Days" := 0;
        if Rec."Contract Expiry Date" > Today then
            Rec."Contract Expiry Remaining Days" := Rec."Contract Expiry Date" - Today;
    end;
}
