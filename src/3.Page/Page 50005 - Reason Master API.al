page 50005 "Reason Master API"
{
    // version APINICASIA1.00

    EntityName = 'reasonMasterEntity';
    EntitySetName = 'reasonMasterEntities';
    PageType = API;
    APIPublisher = 'Agile';
    APIGroup = 'HRMS';
    DelayedInsert = true;
    APIVersion = 'v2.0';
    SourceTable = "Standard Text";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(attendanceMissedAccess; Rec."Attendance Missed Access")
                {
                    Caption = 'Attendance Missed Access';
                }
                field(employeeActivityType; Rec."Employee Activity Type")
                {
                    Caption = 'Employee Activity Type';
                }
            }
        }
    }

    actions { }
}
