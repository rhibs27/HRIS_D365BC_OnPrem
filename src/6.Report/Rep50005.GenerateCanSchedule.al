report 50005 "Generate Can Schedule"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Candidate; Candidate)
        {
            trigger OnAfterGetRecord()
            begin
                if VacancyHeader.Type = VacancyHeader.Type::Internal then begin
                    TestField("Functional Title");
                    FuntionalTitle.Get("Functional Title");
                end;
                if Reschedule then
                    TestField(Status, Status::"Interview Scheduled")
                else if FuntionalTitle."Written Exam" then
                    TestField(Status, Status::"Written/GD Passed")
                else
                    TestField(Status, Status::"Manual Shortlist");

                if VarTime > InterviewEndTime then
                    Error('Cannot generate interview schedule later than ' + Format(InterviewEndTime));
                Counter += 1;

                Candidate."Interview Date" := VarDate;
                Candidate."Interview Time" := VarTime;
                Venue := VenueFilter;
                Status := Status::"Interview Scheduled";
                Modify;

                if Counter >= NoofCandidatePerHrs then begin
                    VarTime := DT2Time(CreateDateTime(Today, VarTime) + (CreateDateTime(Today, 010000T) - CreateDateTime(Today, 0T)));
                    Counter := 0;
                    if InterviewBreakStart <> 0T then
                        if (VarTime >= InterviewBreakStart) and not Breaking then begin
                            if InterviewBreakEnd = 0T then
                                Error('interview break must have value');
                            VarTime := InterviewBreakEnd;
                            Breaking := true;
                        end;

                    /*
                      IF (VarTime>=InterviewEndTime) AND Breaking THEN begin
                        VarTime := InterviewStartTime;
                        VarDate := VarDate +1;
                        Breaking := FALSE;
                      end;*/
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Interview Starting Date"; InterviewStartDate)
                {
                    ToolTip = 'Specifies the value of the InterviewStartDate field.';
                    ApplicationArea = All;
                }
                field("Starting Time"; InterviewStartTime)
                {
                    ToolTip = 'Specifies the value of the InterviewStartTime field.';
                    ApplicationArea = All;
                }
                field("Ending Time"; InterviewEndTime)
                {
                    ToolTip = 'Specifies the value of the InterviewEndTime field.';
                    ApplicationArea = All;
                }
                field("No of Candidate Per Hours"; NoofCandidatePerHrs)
                {
                    ToolTip = 'Specifies the value of the NoofCandidatePerHrs field.';
                    ApplicationArea = All;
                }
                field("Break Start"; InterviewBreakStart)
                {
                    ToolTip = 'Specifies the value of the InterviewBreakStart field.';
                    ApplicationArea = All;
                }
                field("Break End"; InterviewBreakEnd)
                {
                    ToolTip = 'Specifies the value of the InterviewBreakEnd field.';
                    ApplicationArea = All;
                }
                field(Venue; VenueFilter)
                {
                    ToolTip = 'Specifies the value of the VenueFilter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        VacancyHeader.Status := VacancyHeader.Status::"Interview Scheduled";
        VacancyHeader.Modify;
        Message('Interview Schedule has been set for vacancy code %1', VacancyHeader."No.");
        HRMgt.InterviewScheduleEmailToCandidate(VacancyHeader."No.", Reschedule);
        //HRMgt.CandidateListmailToInterviewer(VacancyHeader."No.",Reschedule);
    end;

    trigger OnPreReport()
    begin

        VacancyHeader.Reset;
        VacancyHeader.Get(VacancyFilter);
        if VacancyHeader.Type = VacancyHeader.Type::External then begin
            FuntionalTitle.Get(VacancyHeader."Functional Title");
        end;
        if Reschedule then
            VacancyHeader.TestField(Status, VacancyHeader.Status::"Interview Scheduled")
        else if FuntionalTitle."Written Exam" then
            VacancyHeader.TestField(Status, VacancyHeader.Status::"Written/GD Passed")
        else
            VacancyHeader.TestField(Status, VacancyHeader.Status::"Manual Shortlist");
        Counter := 0;
        VarDate := InterviewStartDate;
        VarTime := InterviewStartTime;
    end;

    var
        InterviewStartDate: Date;
        InterviewStartTime: Time;
        InterviewEndTime: Time;
        InterviewInterval: Time;
        InterviewBreakStart: Time;
        InterviewBreakEnd: Time;
        VarDate: Date;
        VarTime: Time;
        Breaking: Boolean;
        NoofCandidatePerHrs: Integer;
        Counter: Integer;
        FuntionalTitle: Record "Functional Title";
        VacancyHeader: Record "Vacancy Header";
        VacancyFilter: Text;
        VenueFilter: Text;
        HRMgt: Codeunit "HR Mgt.";
        Reschedule: Boolean;

    local procedure GetInterval()
    var
        Mintues: Integer;
        Hour: Integer;
        MinText: Text;
        HourText: Text;
    begin
        //Hour:= ROUND(IntervalTime/60,1,'=');
        if Hour >= 24 then
            Error('Interview interval cannot be this long');
        if Hour > 9 then
            HourText := Format(Hour)
        else
            HourText := '0' + Format(Hour);
        //Mintues := IntervalTime MOD 60;

        if Mintues > 9 then
            MinText := Format(Mintues)
        else
            MinText := '0' + Format(Mintues);

        Evaluate(InterviewInterval, HourText + MinText + '00');
    end;

    procedure GetVacancyNo(VacancyNo: Code[20])
    begin
        VacancyFilter := VacancyNo;
    end;

    procedure IsReschedule()
    begin
        Reschedule := true;
    end;
}
