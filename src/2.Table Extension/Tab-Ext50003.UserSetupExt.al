tableextension 50003 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(33019800; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(33019801; "Update Budget"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019802; "Can View Payroll Fields"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019803; "License Type II"; Option)
        {
            TableRelation = User."License Type";
            DataClassification = CustomerContent;
            OptionMembers = "Full User","Limited User","Device Only User","Windows Group","External User";
            OptionCaption = 'Full User,Limited User,Device Only User,Windows Group,External User';
        }
        field(33019804; "For Leave-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019805; "For Travel-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019806; "For Transfer-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019807; "For Overtime-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019808; "For BulkCash-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019809; "For Resignation-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019810; "For Salary Advance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019811; "For Attend. Missed-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019812; "Run Back Date Daily Attend."; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019813; "Is Admin"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019814; "Allow Previous Year Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019815; "Can View Appraisal List"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019816; "Can View Confirmation Appraisal"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33019817; "Can View Change Log"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    trigger OnRename()
    begin
        Error('');
    end;
}
