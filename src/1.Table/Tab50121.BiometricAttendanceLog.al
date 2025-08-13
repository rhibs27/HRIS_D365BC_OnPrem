table 50121 "Biometric Attendance Log EBL"
{
    Caption = 'Biometric Attendance Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Enroll No."; Integer)
        {
            Caption = 'Enroll No.';
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; "Time"; Time)
        {
            Caption = 'Time';
        }
        field(4; "Portal Attendance"; Boolean)
        {
            Caption = 'Portal Attendance';
        }
        field(5; IP; Text[20])
        {
            Caption = 'IP';
        }
        field(6; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
    }
    keys
    {
        key(PK; "Enroll No.", "Date", "Time", "Portal Attendance")
        {
            Clustered = true;
        }
    }
}
