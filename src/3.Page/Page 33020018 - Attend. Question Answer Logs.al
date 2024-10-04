page 33020018 "Attend. Question Answer Logs"
{
    // version APINICASIA1.00

    EntityName = 'attendancequestionanswerlog';
    EntitySetName = 'attendancequestionanswerlogs';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Attend. Question Answer Log";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.") { }
                field(EmployeeNo; Rec."Employee No.") { }
                field(EmployeeName; Rec."Employee Name") { }
                field(Question; Rec.Question) { }
                field(WrongAnswerCount; Rec."Wrong Answer Count") { }
                field(PunchInDate; Rec."Punch In Date") { }
                field(PunchInTime; Rec."Punch In Time") { }
                field(PuchOutTime; Rec."Puch Out Time") { }
                field(Remarks; Rec.Remarks) { }
            }
        }
    }

    actions { }
}
