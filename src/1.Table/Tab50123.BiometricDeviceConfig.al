table 50123 "Biometric Device Config."
{
    Caption = 'Biometric Device Config.';
    DataClassification = ToBeClassified;
    LookupPageId = "Biometric Device Config.";
    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(2; IP; Code[100])
        {
            Caption = 'IP';
            DataClassification = ToBeClassified;
        }
        field(3; Name; Code[250])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Device Status Name"; Text[100])
        {
            Caption = 'Device Status Name';
            DataClassification = ToBeClassified;
        }
        field(5; "Device Status"; Text[100])
        {
            Caption = 'Device Status';
            DataClassification = ToBeClassified;
        }
        field(6; "Last Activity"; DateTime)
        {
            Caption = 'Last Activity';
            DataClassification = ToBeClassified;
        }
        field(7; SN; Code[100])
        {
            Caption = 'SN';
            DataClassification = ToBeClassified;
        }
        field(8; "Firmware Version"; Code[100])
        {
            Caption = 'Firmware Version';
            DataClassification = ToBeClassified;
        }
        field(9; "User Count"; Integer)
        {
            Caption = 'User Count';
            DataClassification = ToBeClassified;
        }
        field(10; "FP Count"; Integer)
        {
            Caption = 'FP Count';
            DataClassification = ToBeClassified;
        }
        field(11; "Face Count"; Integer)
        {
            Caption = 'Face Count';
            DataClassification = ToBeClassified;
        }
        field(12; "Trans Count"; Integer)
        {
            Caption = 'Trans Count';
            DataClassification = ToBeClassified;
        }
        field(13; "Dev Funs"; Text[100])
        {
            Caption = 'Dev Funs';
            DataClassification = ToBeClassified;
        }
        field(14; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            DataClassification = ToBeClassified;
            TableRelation = "Biometric Branch";
        }
        field(15; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = ToBeClassified;
        }
        field(16; "Is Face Device"; Boolean)
        {
            Caption = 'Is Face Device';
            DataClassification = ToBeClassified;
        }
        field(17; "Device Model"; Text[100])
        {
            Caption = 'Device Model';
            DataClassification = ToBeClassified;
        }
        field(18; "Is Access Device"; Boolean)
        {
            Caption = 'Is Access Device';
            DataClassification = ToBeClassified;
        }
        field(19; "Command Executing"; Integer)
        {
            Caption = 'Command Executing';
            DataClassification = ToBeClassified;
        }
        field(20; "Device Type"; Text[100])
        {
        }
        field(21; "Last Activity Text"; Text[100])
        {
        }
        field(22; "Connectivity Status"; text[250])
        {

        }
        field(100; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;//used in report generation
        }
    }
    keys
    {
        key(PK; SN, "Branch Code")
        {
            Clustered = true;
        }
    }
}

