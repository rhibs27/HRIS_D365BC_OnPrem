tableextension 50001 GLEntryExt extends "G/L Entry"
{
    fields
    {
        field(50050; "Posted Payroll Plan No."; Code[20])
        {
            TableRelation = "Posted Payroll Header";
            DataClassification = CustomerContent;
        }
        field(50051; "Posted Payroll Plan Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50052; "Payroll Attribute Code"; Code[20])
        { DataClassification = CustomerContent; }
        field(50053; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        // field(70000; "Shortcut Dimension 3 Code"; Code[20])
        // {
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        //     DataClassification = ToBeClassified;
        //     CaptionClass = '1,2,3';
        // }
        // field(70001; "Shortcut Dimension 4 Code"; Code[20])
        // {
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        //     DataClassification = ToBeClassified;
        //     CaptionClass = '1,2,4';
        // }
        // field(70002; "Shortcut Dimension 5 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        //  field(70003; "Shortcut Dimension 6 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(70004; "Shortcut Dimension 7 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(70005; "Shortcut Dimension 8 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        field(80000; "Budget Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(80005; Budget; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(80006; "Fiscal Year"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
