table 50135 "Biometric Attendance Log"
{
    Caption = 'Biometric Attendance Log';
    DataClassification = ToBeClassified;
    LookupPageId = "Biometric Attendance Log";
    fields
    {
        field(1; "Device Id"; Integer)
        {
            Caption = 'Device Id';
            DataClassification = ToBeClassified;
            Description = 'id of the device';
        }
        field(2; "User PIN"; Integer)
        {
            Caption = 'User PIN';
            DataClassification = ToBeClassified;
            Description = 'Employee Biometric Id';
        }
        field(3; "User Name"; Code[250])
        {
            Caption = 'User Name';
            DataClassification = ToBeClassified;
            //no data
        }
        field(6; "Check Time"; text[200])
        {
            Caption = 'Check Time';
            DataClassification = ToBeClassified;
            //original data from api
        }
        field(7; "Branch Code"; Code[100])
        {
            Caption = 'Branch Code';
            DataClassification = ToBeClassified;
            //company code in device
        }
        field(8; "Device SN"; text[100])
        {
        }
        field(9; "Attendance Date"; Date)
        {
        }
        field(10; "Attendance Time"; Time)
        {
        }
    }
    keys
    {
        key(PK; "Device Id", "User PIN", "Attendance Date", "Attendance Time")
        {
            Clustered = true;
        }
    }
}
