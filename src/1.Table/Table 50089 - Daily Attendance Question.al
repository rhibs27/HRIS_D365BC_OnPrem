table 50089 "Daily Attendance Question"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; Question; Text[250]) { }
        field(3; Option1; Text[150]) { }
        field(4; Option2; Text[150]) { }
        field(5; Option3; Text[150]) { }
        field(6; Option4; Text[150]) { }
        field(7; "Question Date"; Date) { }
        field(8; "Is Punch In Question"; Boolean) { }
        field(9; "Correct Option"; Enum "Correct Option")
        {
        }
        field(10; "Sync to Portal"; Boolean) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        GetEntryNo;
        UpdateFields;
        CheckDailyAttendanceQuestion;
    end;

    trigger OnModify()
    begin
        UpdateFields
    end;

    var
        DailyAttendanceQuestion: Record "Daily Attendance Question";

    local procedure GetEntryNo()
    begin
        DailyAttendanceQuestion.Reset;
        DailyAttendanceQuestion.SetCurrentKey("Entry No.");
        if DailyAttendanceQuestion.FindLast then
            "Entry No." := DailyAttendanceQuestion."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    local procedure UpdateFields()
    var
        DailyAttendanceQuestion: Record "Daily Attendance Question";
    begin
        "Sync to Portal" := true;

        //IF "Question Date" < TODAY THEN
        //ERROR('You cannot enter questions for back dates.');

        DailyAttendanceQuestion.Reset;
        DailyAttendanceQuestion.SetRange("Question Date", "Question Date");
        if DailyAttendanceQuestion.FindFirst then begin
            if DailyAttendanceQuestion.Count > 2 then
                Error('You can only enter 2 questions for the date %1', DailyAttendanceQuestion."Question Date");
        end;
        /*
        DailyAttendanceQuestion.RESET;
        DailyAttendanceQuestion.SETRANGE("Question Date","Question Date");
        DailyAttendanceQuestion.SETFILTER("Entry No.",'<>%1',"Entry No.");
        IF DailyAttendanceQuestion.FINDFIRST THEN
          "Is Punch In Question" := FALSE
        ELSE
          "Is Punch In Question" := TRUE;
        */
    end;

    local procedure CheckDailyAttendanceQuestion()
    begin
        DailyAttendanceQuestion.Reset;
        DailyAttendanceQuestion.SetRange("Question Date", "Question Date");
        DailyAttendanceQuestion.SetRange("Is Punch In Question", "Is Punch In Question");
        if DailyAttendanceQuestion.FindFirst then
            Error('Question Already exist for date %1', "Question Date");
    end;
}
