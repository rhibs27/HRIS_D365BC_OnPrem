table 50094 "Attendance Log"
{
    Caption = 'Attendance Log';
    DataClassification = CustomerContent;

    fields
    {
        field(8; "Emp DateTime"; Text[100])
        {
            Caption = 'Emp Datetime';
            DataClassification = CustomerContent;
            //TableRelation = "Attendance Device";
        }
        field(1; "Employee ID"; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; Date; Date) { }
        field(3; "Log Time"; Time) { }
        field(4; "Machine Code"; Integer) { }
        field(5; "Biometric Attendance"; Boolean) { }
        field(6; "Machine Emp. Code"; Code[20]) { }
        field(7; "Date Time Log"; DateTime) { }
        field(9; "Device IP"; Text[20]) { }
    }

    keys
    {
        key(Key1; "Emp DateTime") { }
        key(key2; "Employee ID", "Machine Emp. Code") { }
        key(Key3; "Date Time Log", Date, "Log Time") { }
    }
}
