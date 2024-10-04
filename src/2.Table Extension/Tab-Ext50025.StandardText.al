tableextension 50025 "Standard Text" extends "Standard Text"
{
    fields
    {
        field(50000; "Employee Activity Type"; Enum "Employee Activity Type")
        {
            Caption = 'Employee Activity Type';
            DataClassification = ToBeClassified;
        }
        field(50001; "Attendance Missed Access"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Attendance Missed Access';
            OptionMembers = " ",HR;
            OptionCaption = ' ,HR';
        }
    }
}
