table 50175 "Appraisal Employee"
{
    Caption = 'Appraisal Employee';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Template Master No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Appraisal Template"."Template Master No.";
            Caption = 'Template Master No.';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
            Caption = 'Employee No.';
        }
        field(4; "Full Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Full Name';
        }
        field(5; "Employment Type"; Enum "Employee Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Employment Type';
        }
        field(6; "Functional Title"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Functional Title';
        }
        field(7; Status; Enum "Employee Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(8; "Employment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Employment Date';
        }
        field(9; "Confirmation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Confirmation Date';
        }

        field(10; "Province Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Province Code';
        }
        field(11; "Branch Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Branch Code';
        }
        field(12; "Department Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department Code';
        }
        field(13; "Extension Counter Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Extension Counter Code';
        }
        field(14; "Unit Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Code';
        }
        field(15; "Sub-Unit Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub-Unit Code';
        }
    }

    keys
    {
        key(PK; "Template Master No.", "Line No.", "Employee No.")
        {
            Clustered = true;
        }
    }
}