tableextension 50025 "Standard Text" extends "Standard Text"
{
    fields
    {
        field(50000; "Employee Activity Type"; Enum "Employee Activity Type")
        {
            Caption = 'Employee Activity Type';
            DataClassification = ToBeClassified;
        }
        field(50001; "Attendance Missed Access"; Enum "Attendance Missed Access")
        {
            DataClassification = ToBeClassified;
            Caption = 'Attendance Missed Access';
        }
        field(50002; "Check-in/Check-out Mandatory"; Boolean)
        {
            Caption = 'Check-in/Check-out Mandatory';
            DataClassification = ToBeClassified;
        }
        field(50003; "Attendance Entry Type"; Enum "Attendance Entry Type")
        {
            Caption = 'Attendance Entry Type';
            DataClassification = ToBeClassified;
        }
    }
}
