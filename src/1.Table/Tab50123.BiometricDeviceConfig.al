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
        field(5; "Device Status"; Text[100])
        {
            Caption = 'Device Status';
            DataClassification = ToBeClassified;
        }
        field(6; "Last Sync Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(7; SN; Code[100])
        {
            Caption = 'SN';
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
        field(22; "Connectivity Status"; text[250]) { }
        field(23; "Is Active"; Boolean) { }
        field(100; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;//used in report generation
        }
    }
    keys
    {
        key(PK; SN)
        {
            Clustered = true;
        }
    }
}
