// codeunit 33019806 "Attendance-Post"
// {
//     // version AMS6.1.0

//     TableNo = "Employee Insurance Information";

//     trigger OnRun()
//     begin
//         ClearAll;
//         AttJnlLine := Rec;
//         /*
//         IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
//           FIELDERROR("Posting Date",Text001);
//         */
//         SetTemplate;
//         if Rec.RecordLevelLocking then begin
//             AttJnlLine.LockTable;
//             AttJnlDetail.LockTable;
//         end;
//         Window.Open(
//           Text005 +
//           Text003 +
//           Text006 +
//           Text004);
//         Window.Update(5, Rec."Employee No.");
//         Code;
//         Commit;

//     end;

//     var
//         AttJnlLine: Record "Employee Insurance Information";
//         AttJnlDetail: Record "Employee Declaration";
//         AttJnlLedger: Record "Attendance Ledger Entry";
//         AttRegister: Record "Attendance Register";
//         AttJnlBatch: Record "HR Budget Plan";
//         CurrentTemplate: Code[10];
//         CurrentBatch: Code[10];
//         Text000: Label 'There is nothing to post.';
//         GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
//         Text001: Label 'is not within your range of allowed posting dates.';
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         Text002: Label 'Please resolve conflict on calculation for employee %1.';
//         Window: Dialog;
//         LineCount: Integer;
//         Text003: Label 'Checking Lines  #1######  @2@@@@@@@@@@@@@\';
//         Text004: Label 'Creating Ledger    #3######  @4@@@@@@@@@@@@@\';
//         Text005: Label 'Journal Batch Name #5######\';
//         NoOfRecords: Integer;
//         Text006: Label 'Creating Register #6###### @7@@@@@@@@@@@@@\';
//         CurrDocNo: Code[20];
//         PostingNo: Code[20];
//         LeaveIsEarnable: Boolean;

//     procedure "Code"()
//     begin
//         CurrDocNo := NoSeriesMgt.GetNextNo(AttJnlBatch."No. Series", Today, false);
//         LineCount := 0;
//         AttJnlLine.Reset;
//         AttJnlLine.SetRange("Insurance No.", CurrentTemplate);
//         AttJnlLine.SetRange("Employee No.", CurrentBatch);
//         if AttJnlLine.FindSet then begin
//             NoOfRecords := AttJnlLine.Count;
//             repeat
//                 LineCount += 1;
//                 ;
//                 Window.Update(1, LineCount);
//                 Window.Update(2, Round(LineCount / NoOfRecords * 10000, 1));
//                 CheckJnlLine();
//             until AttJnlLine.Next = 0;
//         end
//         else begin
//             Error(Text000);
//         end;
//         Clear(NoSeriesMgt);
//         PostingNo := NoSeriesMgt.GetNextNo(AttJnlBatch."Posting No. Series", Today, false);
//         LineCount := 0;
//         AttJnlLine.Reset;
//         AttJnlLine.SetRange("Insurance No.", CurrentTemplate);
//         AttJnlLine.SetRange("Employee No.", CurrentBatch);
//         if AttJnlLine.FindSet then begin
//             NoOfRecords := AttJnlLine.Count;
//             repeat
//                 LineCount += 1;
//                 ;
//                 Window.Update(6, LineCount);
//                 Window.Update(7, Round(LineCount / NoOfRecords * 10000, 1));
//                 PostJnlLine();
//             until AttJnlLine.Next = 0;
//         end
//         else begin
//             Error(Text000);
//         end;
//         CurrDocNo := NoSeriesMgt.GetNextNo(AttJnlBatch."No. Series", Today, true);
//         PostingNo := NoSeriesMgt.GetNextNo(AttJnlBatch."Posting No. Series", Today, true);
//         Window.Close;
//     end;

//     procedure SetTemplate()
//     begin
//         CurrentTemplate := AttJnlLine."Insurance No.";
//         CurrentBatch := AttJnlLine."Employee No.";
//         AttJnlBatch.Get(CurrentTemplate, CurrentBatch);
//     end;

//     procedure CheckJnlLine()
//     begin
//         AttJnlLine.CalcFields("Conflict Exists");
//         if "Conflict Exists" then
//             Error(Text002, AttJnlLine."Insurance Amount");
//         AttJnlLine.TestField("Posting No. Series");
//         AttJnlLine.TestField("Insurance Company", CurrDocNo);
//     end;

//     procedure PostJnlLine()
//     var
//         LineCount: Integer;
//         NoOfRecords: Integer;
//     begin
//         AttJnlLine.CalcFields("Present Days", "Absent Days", "Paid Days");
//         Clear(AttRegister);
//         AttRegister.Init;
//         AttRegister.TransferFields(AttJnlLine);
//         AttRegister."No." := PostingNo;
//         AttRegister."Source No." := AttJnlLine."Insurance Company";
//         AttRegister."Present Days" := "Present Days";
//         AttRegister."Absent Days" := "Absent Days";
//         AttRegister."Paid Days" := "Paid Days";
//         AttRegister."Unpaid Days" := "Unpaid Days";
//         AttRegister.Insert;

//         if AttJnlLine.HasLinks then
//             AttRegister.CopyLinks(AttJnlLine);
//         LineCount := 0;
//         AttJnlDetail.Reset;
//         AttJnlDetail.SetRange("No.", CurrentTemplate);
//         AttJnlDetail.SetRange("Employee No.", CurrentBatch);
//         AttJnlDetail.SetRange("Fiscal Year", AttJnlLine."Insurance Company");
//         AttJnlDetail.SetRange("Employee Name", AttJnlLine."Employee Name");
//         AttJnlDetail.SetRange("By Laws Policies", AttJnlLine."Insurance Amount");
//         if AttJnlDetail.FindSet then begin
//             NoOfRecords := AttJnlDetail.Count;
//             LeaveIsEarnable := true;
//             repeat
//                 LineCount += 1;
//                 ;
//                 Window.Update(3, LineCount);
//                 Window.Update(4, Round(LineCount / NoOfRecords * 10000, 1));
//                 Clear(AttJnlLedger);
//                 AttJnlLedger.Init;
//                 AttJnlLedger.TransferFields(AttJnlDetail);
//                 AttJnlLedger."No." := AttRegister."No.";
//                 AttJnlLedger."Source No." := AttRegister."Source No.";
//                 AttJnlLedger.Insert;
//                 if (AttJnlDetail."Other Documents if Any" = AttJnlDetail."Other Documents if Any"::"1") and
//                   (AttJnlDetail."Involved In Outside Business" = AttJnlDetail."Involved In Outside Business"::"2") and
//                   (AttJnlDetail."Souvenir Declaration" = AttJnlDetail."Souvenir Declaration"::"0") then
//                     LeaveIsEarnable := false;
//                 AttJnlLedger.CopyLinks(AttJnlDetail);
//             until AttJnlDetail.Next = 0;
//             UpdateLeaveEarn(AttJnlLine."Insurance Amount");
//         end;
//         if AttJnlLine.HasLinks then AttJnlLine.DeleteLinks;
//         AttJnlLine.Delete;
//         AttJnlDetail.DeleteAll;
//     end;

//     procedure UpdateLeaveEarn(EmployeeCode: Code[20])
//     var
//         Employee: Record Employee;
//     begin
//         Employee.Reset;
//         Employee.SetRange("No.", EmployeeCode);
//         if Employee.FindFirst then begin
//             if LeaveIsEarnable then
//                 Employee."Restrict Leave Earn" := false
//             else
//                 Employee."Restrict Leave Earn" := true;
//             Employee.Modify;
//         end;
//     end;
// }
