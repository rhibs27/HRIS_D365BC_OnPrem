// codeunit 33019807 "Attendance-Post (Yes/No)"
// {
//     // version AMS6.1.0

//     TableNo = "Employee Insurance Information";

//     trigger OnRun()
//     begin
//         AttJnlLine.Copy(Rec);
//         Code;
//         Rec := AttJnlLine;
//     end;

//     var
//         AttJnlLine: Record "Employee Insurance Information";
//         AttPost: Codeunit "Attendance-Post";

//     procedure "Code"()
//     var
//         Text001: Label 'Do you want to post the Journal?';
//     begin
//         if not Confirm(Text001, true) then
//             exit;
//         AttPost.Run(AttJnlLine);
//         Commit;
//     end;
// }
