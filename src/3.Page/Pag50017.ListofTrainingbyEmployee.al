page 50017 "List of Training by Employee"
{

    Editable = false;
    PageType = List;
    SourceTable = "Training Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Training No."; Rec."Training No.")
                {
                    ToolTip = 'Specifies the value of the Training No. field.';
                    ApplicationArea = All;
                }
                field("Training Description"; Rec."Training Description")
                {
                    ToolTip = 'Specifies the value of the Training Description field.';
                    ApplicationArea = All;
                }
                field("Training Start Date"; Rec."Training Start Date")
                {
                    ToolTip = 'Specifies the value of the Training Start Date field.';
                    ApplicationArea = All;
                }
                field("Training End Date"; Rec."Training End Date")
                {
                    ToolTip = 'Specifies the value of the Training End Date field.';
                    ApplicationArea = All;
                }
                field("Hours Attended"; HoursAttended)
                {
                    ToolTip = 'Specifies the value of the HoursAttended field.';
                    ApplicationArea = All;
                }
                field("Sponsorship Type"; Rec."Sponsorship Type")
                {
                    ToolTip = 'Specifies the value of the Sponsorship Type field.', Comment = '%';
                }
                field("Training Remarks"; Rec."Training Remarks")
                {
                    ToolTip = 'Specifies the value of the Training Remarks field.', Comment = '%';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = '%';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin

        GetFiltersText := Rec.GetFilter(Type);
        if GetFiltersText = Format(Rec.Type::Trainee) then begin
            TrainingAttendance.Reset;
            TrainingAttendance.SetRange("Training No", Rec."Training No.");
            TrainingAttendance.SetRange("Employee No.", Rec."Employee Code");
            if TrainingAttendance.Find('-') then
                repeat
                    TrainingLine.Reset;
                    TrainingLine.SetRange("Training No.", Rec."Training No.");
                    TrainingLine.SetRange(Type, TrainingLine.Type::Trainer);
                    TrainingLine.SetRange("Trainer Date", TrainingAttendance."Attended Date");
                    if TrainingLine.Find('-') then
                        repeat
                            HoursAttended += TrainingLine."Total Hours" / 3600000;
                        until TrainingLine.Next = 0;
                until TrainingAttendance.Next = 0;
        end else if GetFiltersText = Format(Rec.Type::Trainer) then
                HoursAttended := Rec."Total Hours" / 3600000;
    end;

    var
        HoursAttended: Decimal;
        TrainingLine: Record "Training Line";
        TrainingAttendance: Record "Training Attendance";
        GetFiltersText: Text;
}
