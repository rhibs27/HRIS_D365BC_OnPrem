tableextension 33019808 "Source Code Setup Ext" extends "Source Code Setup"
{
    fields
    {
        field(50000; "Bank Receipt Journal"; Code[10])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50001; "Bank Payment Journal"; Code[10])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50002; "Cheque Receipt Journal"; Code[10])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50003; "Cheque Payment Journal"; Code[10])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50100; "Payroll Journal"; Code[10])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50101; "Payroll Plan"; Code[10])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
            // Description = 'Pranisha';
        }
        field(50102; "Attendance Management"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }
}
