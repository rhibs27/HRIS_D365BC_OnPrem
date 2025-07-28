tableextension 50001 GLEntryExt extends "G/L Entry"
{
    fields
    {
        field(50000; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
            DataClassification = CustomerContent;
        }
        field(50001; "Posted Payroll Plan Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Payroll Attribute Code"; Code[20])
        { DataClassification = CustomerContent; }
        field(50003; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        // field(50004; "Shortcut Dimension 3 Code"; Code[20])
        // {
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        //     DataClassification = ToBeClassified;
        //     CaptionClass = '1,2,3';
        // }
        // field(50005; "Shortcut Dimension 4 Code"; Code[20])
        // {
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        //     DataClassification = ToBeClassified;
        //     CaptionClass = '1,2,4';
        // }
        // field(50006; "Shortcut Dimension 5 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        //  field(50007; "Shortcut Dimension 6 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(50008; "Shortcut Dimension 7 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(50009; "Shortcut Dimension 8 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        field(50010; "Budget Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50011; Budget; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Fiscal Year"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
