page 50178 BiometricLogAPI
{
    APIGroup = 'apiGroup';
    APIPublisher = 'agileSolution';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'biometricLogAPI';
    DelayedInsert = true;
    EntityName = 'biometricLogAPI';
    EntitySetName = 'biometricLogAPIs';
    PageType = API;
    SourceTable = "Biometric Attendance Log";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(deviceSN; Rec."Device SN")
                {
                    Caption = 'Device SN';
                }
                field(userPIN; Rec."User PIN")
                {
                    Caption = 'User PIN';
                }
                field(attendanceDate; Rec."Attendance Date")
                {
                    Caption = 'Attendance Date';
                }
                field(attendanceTime; Rec."Attendance Time")
                {
                    Caption = 'Attendance Time';
                }
                field(checkTime; Rec."Check Time")
                {
                    Caption = 'Check Time';
                }
                field(branchCode; Rec."Branch Code")
                {
                    Caption = 'Branch Code';
                }
            }
        }
    }
}
