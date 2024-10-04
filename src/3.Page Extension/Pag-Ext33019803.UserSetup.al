pageextension 33019803 UserSetup extends "User Setup"
{
    layout
    {
        addafter(Email)
        {
            field("Can View Payroll Fields"; Rec."Can View Payroll Fields")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Can View Payroll Fields field.';
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                Caption = 'Branch Filter';
                ToolTip = 'Specifies the value of the Branch Filter field.';
            }
            field("Update Budget"; Rec."Update Budget")
            {
                ApplicationArea = All;
                Caption = 'Can Update Budget';
                ToolTip = 'Specifies the value of the Can Update Budget field.';
            }
            field("For Attend. Missed-Dashboard"; Rec."For Attend. Missed-Dashboard")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For Attend. Missed-Dashboard field.';
            }
            field("For Leave-Dashboard"; Rec."For Leave-Dashboard")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For Leave-Dashboard field.';
            }
            field("For Travel-Dashboard"; Rec."For Travel-Dashboard")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For Travel-Dashboard field.';
            }
            field("For Transfer-Dashboard"; Rec."For Transfer-Dashboard")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For Transfer-Dashboard field.';
            }
            field("For Overtime-Dashboard"; Rec."For Overtime-Dashboard")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For Overtime-Dashboard field.';
            }
            field("For BulkCash-Dashboard"; Rec."For BulkCash-Dashboard")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For BulkCash-Dashboard field.';
            }
            field("For Resignation-Dashboard"; Rec."For Resignation-Dashboard")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For Resignation-Dashboard field.';
            }
            field("For Salary Advance"; Rec."For Salary Advance")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the For Salary Advance field.';
            }
            field("Run Back Date Daily Attend."; Rec."Run Back Date Daily Attend.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Run Back Date Daily Attend. field.', Comment = '%';
            }
            field("Is Admin"; Rec."Is Admin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is Admin field.', Comment = '%';
            }
            field("Allow Previous Year Payroll"; Rec."Allow Previous Year Payroll")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Previous Year Payroll field.', Comment = '%';
            }
            field("Can View Appraisal List"; Rec."Can View Appraisal List")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Can View Appraisal List field.', Comment = '%';
            }
            field("Can View Confirmation Appraisal"; Rec."Can View Confirmation Appraisal")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Can View Confirmation Appraisa field.', Comment = '%';
            }
            field("Can View Change Log"; Rec."Can View Change Log")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Can View Change Log field.', Comment = '%';
            }
        }
    }
}
