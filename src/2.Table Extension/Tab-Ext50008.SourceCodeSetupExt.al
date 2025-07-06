tableextension 50008 "Source Code Setup Ext" extends "Source Code Setup"
{
    fields
    {
        field(50000; "Bank Receipt Journal"; Code[20])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50001; "Bank Payment Journal"; Code[20])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50002; "Cheque Receipt Journal"; Code[20])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50003; "Cheque Payment Journal"; Code[20])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50004; "Payroll Journal"; Code[20])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
        }
        field(50005; "Payroll Plan"; Code[20])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
            // Description = 'Pranisha';
        }
        field(50006; "Attendance Management"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
