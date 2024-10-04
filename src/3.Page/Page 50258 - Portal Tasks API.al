page 50258 "Portal Tasks API"
{
    // version APINICASIA1.00

    EntityName = 'PortalTask';
    EntitySetName = 'PortalTasks';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(FieldName; Rec."Field Name") { }
                field(Value; Rec.Value) { }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("To Approve Attendance Missed");
        if Rec."To Approve Attendance Missed" > 0 then begin
            Rec."Field Name" := 'To Approve Attendance Missed';
            Rec.Value := Rec."To Approve Attendance Missed";
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
        //Setvisibility;
        /*TempHRCue.DELETEALL;
        TempHRCue.INIT;
        CALCFIELDS("To Approve Attendance Missed");
        IF "To Approve Attendance Missed" > 0 THEN BEGIN
          TempHRCue."Field Name" := 'To Approve Attendance Missed';
          TempHRCue.Value := "To Approve Attendance Missed";
          END;
        TempHRCue.INSERT;
        */
    end;

    var
        Employee: Record Employee;

    procedure Setvisibility()
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then begin
            Rec.SetFilter("User Filter", Employee."No.");
            Rec.SetRange("Employee Filter", Employee."No.");
        end;
    end;
}
