table 50071 "Training Attendance"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Training No"; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20]) { }
        field(4; "Attended Date"; Date)
        {
            trigger OnValidate()
            begin
                TrainingHeader.Get("Training No");
                if ("Attended Date" < TrainingHeader."Start Date") or ("Attended Date" > TrainingHeader."End Date") then
                    Error('The entered date %1 for employee %2 does not lie between training conducted period.', Format("Attended Date"), "Employee No.");
                CheckEmployee;
            end;
        }
        field(5; Approved; Boolean)
        {
            Caption = 'Approved';
            Editable = false;
        }
        field(6; "Approved By"; Code[20])
        {
            Caption = 'Approved By';
            TableRelation = Employee;
            Editable = false;
        }
        field(7; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Training No", "Line No.") { }
    }

    fieldgroups { }

    var
        TrainingAttendance: Record "Training Attendance";
        AttendanceError: Label 'Employee No. %1 already exists on %2 in training No. %3. ';
        TrainingHeader: Record "Training Header";

    local procedure CheckEmployee()
    begin
        TrainingAttendance.Reset;
        TrainingAttendance.SetRange("Employee No.", "Employee No.");
        TrainingAttendance.SetRange("Attended Date", "Attended Date");
        TrainingAttendance.SetRange("Training No", "Training No");
        if TrainingAttendance.FindFirst then
            Error(AttendanceError, "Employee No.", "Attended Date", "Training No");
    end;

    procedure GetLineNo(DocNo: Code[20]): Integer
    var
        TrainingAttendance: Record "Training Attendance";
    begin
        TrainingAttendance.Reset;
        TrainingAttendance.SetCurrentKey("Training No", "Line No.");
        TrainingAttendance.SetRange("Training No", DocNo);
        if TrainingAttendance.FindLast then
            exit(TrainingAttendance."Line No." + 10000)
        else
            exit(10000);
    end;
}
