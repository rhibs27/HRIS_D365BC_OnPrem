pageextension 33019805 SourceCodeSetup extends "Source Code Setup"
{
    layout
    {
        addafter("Payment Reconciliation Journal")
        {
            field("Attendance Management"; Rec."Attendance Management")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Attendance Management field.';
            }
        }
        addafter("Unapplied Empl. Entry Appln.")
        {
            field("Payroll Plan"; Rec."Payroll Plan")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payroll Plan field.';
            }
            field("Payroll Journal"; Rec."Payroll Journal")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payroll Journal field.';
            }
        }
    }
}
