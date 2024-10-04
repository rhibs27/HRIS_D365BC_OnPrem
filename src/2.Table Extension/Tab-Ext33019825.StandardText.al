tableextension 33019825 "Standard Text" extends "Standard Text"
{
    fields
    {
        field(33019800; "Employee Activity Type"; Enum "Employee Activity Type")
        {
            Caption = 'Employee Activity Type';
            DataClassification = ToBeClassified;
        }
        field(33019801; "Attendance Missed Access"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Attendance Missed Access';
            OptionMembers = " ",HR;
            OptionCaption = ' ,HR';
        }
    }
}
