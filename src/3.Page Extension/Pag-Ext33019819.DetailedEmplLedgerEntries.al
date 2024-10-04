pageextension 33019819 "Detailed Empl. Ledger Entries" extends "Detailed Empl. Ledger Entries"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Pay Cycle Code"; Rec."Pay Cycle Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pay Cycle Code field.';
            }
            field("Pay Cycle Term"; Rec."Pay Cycle Term")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pay Cycle Term field.';
            }
            field("Pay Cycle Period"; Rec."Pay Cycle Period")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pay Cycle Period field.';
            }
            field("Pay Period Start Date"; Rec."Pay Period Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pay Period Start Date field.';
            }
            field("Pay Period End Date"; Rec."Pay Period End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pay Period End Date field.';
            }
            field("Attribute Type"; Rec."Attribute Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Attribute Type field.';
            }
            field("Attribute Sub Type"; Rec."Attribute Sub Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Attribute Sub Type field.';
            }
            field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payroll Attribute Code field.';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description field.';
            }
            field("Finacle GL No"; Rec."Finacle GL No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Finacle GL No field.';
            }
            field("Finacle GL Name"; Rec."Finacle GL Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Finacle GL Name field.';
            }
        }
    }
}
