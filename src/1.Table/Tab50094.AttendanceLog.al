table 50094 "Attendance Log"
{
    // version AMS6.1.0
    // * Machine Emp. Code
    // * Employee Name
    // - Two fields Added
    // validation of employee code will bring Employee code and Name in the record.

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
        }
        field(2; Date; Date) { }
        field(3; "Log Time"; Time) { }
        field(4; "Machine Code"; Integer) { }
        field(5; "Biometric Attendance"; Boolean)
        {
        }
        field(6; "Machine Emp. Code"; Code[20])
        {
        }
        field(7; "Date Time Log"; DateTime) { }
    }

    keys
    {
        key(Key1; "Emp DateTime") { }
    }
    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
}
