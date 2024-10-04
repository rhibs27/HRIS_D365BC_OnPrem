tableextension 50003 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(50001; "Update Budget"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Can View Payroll Fields"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "License Type II"; Option)
        {
            TableRelation = User."License Type";
            DataClassification = CustomerContent;
            OptionMembers = "Full User","Limited User","Device Only User","Windows Group","External User";
            OptionCaption = 'Full User,Limited User,Device Only User,Windows Group,External User';
        }
        field(50004; "For Leave-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50005; "For Travel-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50006; "For Transfer-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50007; "For Overtime-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50008; "For BulkCash-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50009; "For Resignation-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "For Salary Advance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50011; "For Attend. Missed-Dashboard"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Run Back Date Daily Attend."; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50013; "Is Admin"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50014; "Allow Previous Year Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50015; "Can View Appraisal List"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Can View Confirmation Appraisal"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Can View Change Log"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    trigger OnRename()
    begin
        Error('');
    end;
}
