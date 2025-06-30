// report 50144 "Sql Connection Attendance"
// {
//     ApplicationArea = All;
//     Caption = 'Sql Connection Attendance';
//     UsageCategory = ReportsAndAnalysis;
//     ProcessingOnly = true;
//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {
//                     field(FromDate; FromDate)
//                     {
//                         Caption = 'From Date';
//                         ApplicationArea = All;
//                     }
//                     field(ToDate; ToDate)
//                     {
//                         Caption = 'To Date';
//                         ApplicationArea = All;
//                     }
//                     field(deviceId; deviceId)
//                     {
//                         Caption = 'Device Id';
//                         ApplicationArea = All;
//                     }
//                     field(UpdateDeviceID; UpdateDeviceID)
//                     {
//                         Caption = 'Update Device ID in old log';
//                         ApplicationArea = All;
//                     }
//                 }
//             }
//         }
//         actions
//         {
//             area(Processing) { }
//         }
//     }
//     trigger OnPreReport()
//     var
//         SqlConAtt: Codeunit "SQL Connection Attendance";
//     // SqlConAtt: Codeunit SQLConnectionAttendance2;
//     begin

//         // Clear(SqlConAtt);
//         // SqlConAtt.SetFilterParameter(FromDate, ToDate, deviceId);
//         // if UpdateDeviceID then
//         //     SqlConAtt.SyncUpdateEmployeeAttendance()
//         // else
//         //     SqlConAtt.Run();
//     end;

//     var
//         FromDate: Date;
//         ToDate: Date;
//         deviceId: Integer;

//         UpdateDeviceID: Boolean;
// }

