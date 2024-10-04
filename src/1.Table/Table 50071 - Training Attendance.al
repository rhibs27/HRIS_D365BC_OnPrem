table 50071 "Training Attendance"
{
    DataClassification = CustomerContent;
    // version NIC Asia1.00,Training

    fields
    {
        field(1; "Training No"; Code[20]) { }
        field(2; "Employee No."; Code[20])
        {
            trigger OnValidate()
            begin
                /*TrainingLine.RESET;
                TrainingLine.SETRANGE("Training No.","Training No");
                TrainingLine.SETRANGE("Employee Code","Employee No.");
                IF TrainingLine.ISEMPTY THEN
                  ERROR('Employee %1 has not attended training. Please enter the employee in trainee subform first.',"Employee No.");
                  */
            end;
        }
        field(3; "Attended Date"; Date)
        {
            trigger OnValidate()
            begin
                TrainingHeader.Get("Training No");
                if ("Attended Date" < TrainingHeader."Start Date") or ("Attended Date" > TrainingHeader."End Date") then
                    Error('The entered date %1 for employee %2 does not lie between training conducted period.', Format("Attended Date"), "Employee No.");
            end;
        }
        field(4; "Line No."; Integer) { }
    }

    keys
    {
        key(Key1; "Training No", "Line No.") { }
    }

    fieldgroups { }

    var
        TrainingAtttendance: Record "Training Attendance";
        AttendaceError: Label 'Employee No. %1 already exists on %2 in training No. %3. ';
        TrainingHeader: Record "Training Header";

    local procedure CheckEmployee()
    begin
        TrainingAtttendance.Reset;
        TrainingAtttendance.SetRange("Employee No.", "Employee No.");
        TrainingAtttendance.SetRange("Attended Date", "Attended Date");
        TrainingAtttendance.SetRange("Training No", "Training No");
        if TrainingAtttendance.FindFirst then
            Error(AttendaceError, "Employee No.", "Attended Date", "Training No");
    end;
}
