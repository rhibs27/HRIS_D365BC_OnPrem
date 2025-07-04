// codeunit 50018 "Temp Codeunit"
// {
//     Permissions = TableData User = rm;

//     trigger OnRun()
//     var
//         amt: Decimal;
//         i: Integer;
//         DailyAttQuest: Record "Daily Attendance Question";
//     begin
//         UpdateNames;
//         DeleteAttendanceLine;
//         ServiceOrderPost('PKRSOR76/77-00055');
//         MakeNavUser('BATAS-TASK\BHASKAR');
//         GetServiceInvoice('PKRSOR76/77-00049');
//         GetSalesInvoice('PKRSOR76/77-00066');
//         MakeQuoteToOrder('PKRSQO76/77-00011');

//         MESSAGE(InsertLineFromSMS('9841891708', 'asdf'));
//         UpdateAttendancelog();
//         UpdateSalaryLevelDescription;
//         UpdateEmpAttendanceActivity;
//         UpdateEvaluationAttribute();
//         InsertEmployeeAttendanceActivity();
//         ValidateEmployeeSolID; //For Update department,branch,fucntional title
//         UpdateEmployeeFunctionalTitle();
//         UpdateSPO;
//         RemoveAmount();
//         RemovePF();
//         RemoveSpaceAccount();
//         ChangeFiscalYear();
//         ValidateCandidate();
//         ValidateEvaluationAttribute();
//         ValidateNICRTFLoan();
//         ValidateAllowanceAssignmentLine();
//         UpdateVaultKeyAllowance();
//         DeleteEmployeeAttendance();
//         UpdateLFA();
//         settledsalaryadvance();
//         ValidateLumpsum();
//         ValidateEvaluationAttribute();
//         UpdateHoliday();
//         UpdateHoliday();
//         CopyPayrollType();
//         AllowanceAssignmentStatus();
//         UpdateLoan;
//         UpdatePromotionDate; //Min for update promotion date of old employee
//         UpdateContactExpiryDate;
//         UpdateUnitEmployee;//Min --1
//         UpdateTransferUnitCode; //Min -- 2
//         UpdateTransferUnitToCode; //Min -- 3
//         UpdateEmployeeActivityDeputationBranch;
//         UpdateEmployeeActivityDeputationDepartment;
//         UpdateEmployeeActivityDeputationProvince;
//         UpdateEmployeeActivityDeputationSubProvince;
//         UpdateEmployeeActivityDeputationUnit;  --2
//         UpdateLeaveDate;
//         UpdateAllowanceAssignmentLine;
//         UpdateEmpAttendanceActivityDescription;
//         UpdateServiceHistory;
//         LeaveTypeCorr;
//         UpdateEmployeeLoan;
//         UpdatePayrollMonth;
//         UpdateConfirmationDate;
//         UpdateLeaveRequest;
//         KRASubformCheckReviewUpdate; //2
//         KRASubformCheckReview; //1
//         ConfirmationEligibleUpdate;
//         UpdateEmployeeRFActual;
//         UpdatepayrollLineSelected;
//         UpdateFoodingAllowance;
//         UpdateCandidate;
//         UpdatePrevLoan;
//         UpdateInterviewBy;
//         UpdateApproverSalaryAdv;
//         UpdateTrainingApprovalStatus;
//         HideAppraisal;
//         KRASubformCheckReviewUpdateFirst;
//         KRASubformFinalReviewersUpdateSecond;
//         UpdateContactExpiryDateTest;
//         UpdateEcoSystem;
//         UpdateEcoSystemBlank;
//         TravelClaimCorr;
//         UpdateLeaveDays;
//         UpdateTravelOrderNo;
//         UpdateCloseLeaveEarn;
//         UpdatedOTDisbursed;
//         UpdateWeekEmpAttendanceActivity;
//         ValidateEmployeeFunctionalTitle;
//         Message('Success');
//     end;

//     var
//         UserSetup: Record "User Setup";
//         ReturnMsg: Text;
//         EMployee: Record Employee;
//         EmployeeActivity: Record "Employee Activity";
//         TestQuery: Query "Payroll Query";
//         EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
//         Date: Record Date;
//         DimValue: Record "Dimension Value";
//         Province: Record Province;
//         SubProvince: Record "Sub Province";
//         AllowanceLine: Record "Allowance Assignment Line";
//         LoanMgt: Codeunit "Loan Mgt.";
//         PayrollAttributesUsage: Record "Payroll Attributes Usage";
//         PayrollLine: Record "Payroll Line";
//         PayrollAttributes: Record "Payroll Attributes";
//         DetailedEmployeeledger: Record "Detailed Employee Ledger Entry";
//         AllowanceAssigmentLine: Record "Allowance Assignment Line";
//         PGSetup: Record "Payroll General Setup";
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         HRSSetup: Record "Human Resources Setup";
//         HRMgt: Codeunit "HR Mgt.";
//         SalaryAdv: Record "Employee Loan/Advance";
//         EvaluationEntries: Record "Evaluation Entry";
//         EvaluationAttribute: Record "Evaluation Attribute";

//     local procedure "-------------------------Purchase"()
//     begin
//     end;

//     procedure GetPurchaseInvoice(InvoiceNo: Code[20]): Text
//     var
//         PurchInvHdr: Record "Purch. Inv. Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//     begin
//         PurchInvHdr.Reset;
//         PurchInvHdr.SetRange("No.", InvoiceNo);
//         if PurchInvHdr.FindFirst then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(CreateGuid); //."No.";
//             filename := DelChr(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(406, filename, PurchInvHdr);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);

//         end;
//     end;

//     local procedure ImportPurchaseLine(OrderNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal)
//     var
//         PurchaseLine: Record "Purchase Line";
//         LineNo: Integer;
//         PurchaseHeader: Record "Purchase Header";
//     begin
//         PurchaseHeader.Reset;
//         PurchaseHeader.SetRange("No.", OrderNo);
//         PurchaseHeader.FindFirst;

//         PurchaseLine.Reset;
//         PurchaseLine.SetCurrentKey("Line No.");
//         PurchaseLine.SetRange("Document No.", OrderNo);
//         if PurchaseLine.FindLast then
//             LineNo := PurchaseLine."Line No." + 10000;

//         Clear(PurchaseLine);
//         PurchaseLine.Reset;
//         PurchaseLine.Init;
//         PurchaseLine."Document Type" := PurchaseHeader."Document Type";
//         PurchaseLine."Document No." := PurchaseHeader."No.";
//         PurchaseLine."Line No." := LineNo;
//         PurchaseLine.Insert(true);

//         PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
//         PurchaseLine.Validate("No.", ItemNo);
//         PurchaseLine.Validate(Quantity, Quantity);
//         PurchaseLine.Modify(true);
//     end;

//     local procedure "-------------------------Sales"()
//     begin
//     end;

//     procedure SalesOrderPost(No: Code[20]): Text
//     var
//         SalesHeader: Record "Sales Header";
//     begin
//         SalesHeader.Reset;
//         SalesHeader.SetRange("No.", No);
//         SalesHeader.FindFirst;
//         if not SalesHeader.IsApprovedForPosting then
//             exit;

//         SalesHeader.Invoice := true;
//         SalesHeader.Ship := true;

//         CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesHeader);
//         Commit;
//         exit(GetSalesInvoice(No));
//     end;

//     procedure GetSalesInvoice(OrderNo: Code[20]): Text
//     var
//         SalesInvHeader: Record "Sales Invoice Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//     begin
//         SalesInvHeader.Reset;
//         SalesInvHeader.SetRange("Order No.", OrderNo);
//         if SalesInvHeader.FindLast then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(DelChr(SalesInvHeader."No.", '=', '\/')); //."No.";
//                                                                          //filename := DELCHR(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(50004, filename, SalesInvHeader);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);

//         end;
//     end;

//     procedure MakeSalesQuoteToOrder(No: Code[20]): Text
//     var
//         SalesHeader: Record "Sales Header";
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//     begin
//         SalesHeader.Reset;
//         SalesHeader.SetRange("No.", No);
//         SalesHeader.FindFirst;

//         Clear(ApprovalsMgmt);
//         if ApprovalsMgmt.PrePostApprovalCheckSales(SalesHeader) then
//             CODEUNIT.Run(CODEUNIT::"Sales-Quote to Order (Yes/No)", SalesHeader);

//         SalesHeader.Reset;
//         SalesHeader.SetRange("Quote No.", No);
//         if SalesHeader.FindLast then
//             exit(StrSubstNo('Quote has been converted to Order: %1', SalesHeader."No."));
//     end;

//     procedure GetSalesQuote(No: Code[20]): Text
//     var
//         SalesHeader: Record "Sales Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//     begin
//         SalesHeader.Reset;
//         SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
//         SalesHeader.SetRange("No.", No);
//         if SalesHeader.FindFirst then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(CreateGuid); //."No.";
//             filename := DelChr(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(50012, filename, SalesHeader);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);

//         end;
//     end;

//     local procedure "-----------------------Transfer"()
//     begin
//     end;

//     procedure TransferOrderPostShipment(No: Code[20])
//     var
//         TransferHeader: Record "Transfer Header";
//     begin
//         TransferHeader.Get(No);
//         CODEUNIT.Run(CODEUNIT::"TransferOrder-Post Shipment", TransferHeader);
//     end;

//     procedure TransferOrderPostReceipt(No: Code[20])
//     var
//         TransferHeader: Record "Transfer Header";
//     begin
//         TransferHeader.Get(No);
//         CODEUNIT.Run(CODEUNIT::"TransferOrder-Post Receipt", TransferHeader);
//     end;

//     procedure GetTransferShipment(No: Code[20]): Text
//     var
//         TransferShptHeader: Record "Transfer Shipment Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//     begin
//         TransferShptHeader.Reset;
//         TransferShptHeader.SetRange("Transfer Order No.", No);
//         if TransferShptHeader.FindLast then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(DelChr(TransferShptHeader."No.", '=', '\/')); //."No.";
//                                                                              //filename := DELCHR(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(50017, filename, TransferShptHeader);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);

//         end;
//     end;

//     procedure GetTransferReceipt(No: Code[20]): Text
//     var
//         TransferRcptHeader: Record "Transfer Receipt Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//     begin
//         TransferRcptHeader.Reset;
//         TransferRcptHeader.SetRange("Transfer Order No.", No);
//         if TransferRcptHeader.FindLast then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(DelChr(TransferRcptHeader."No.", '=', '\/')); //."No.";
//                                                                              //filename := DELCHR(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(50018, filename, TransferRcptHeader);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);

//         end;
//     end;

//     local procedure "------------------------Service"()
//     begin
//     end;

//     procedure ServiceOrderPost(DocumentNo: Code[20]): Text
//     var
//         ServiceHeader: Record "Service Header";
//         ServiceInvoiceHdr: Record "Service Invoice Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//         PostServiceCodeunit: Codeunit "Service-Post (Yes/No)";
//     begin
//         ServiceHeader.Reset;
//         //ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::Order);
//         ServiceHeader.SetRange("No.", DocumentNo);
//         if ServiceHeader.FindFirst then begin
//             //CLEAR(PostServiceCodeunit);
//             //  PostServiceCodeunit.PostServiceDocument(ServiceHeader);
//             //CODEUNIT.RUN(CODEUNIT::"Service-Post", ServiceHeader);
//             Commit;
//             //EXIT(GetServiceInvoice(DocumentNo));
//         end;
//     end;

//     procedure CreateRequisition(ServiceOrderNo: Code[20]): Text
//     var
//         ServiceHeader: Record "Service Header";
//         ServiceMgt: Codeunit "Service Inv.-Printed";
//     begin
//         /*ServiceHeader.RESET;
//         ServiceHeader.SETRANGE("No.", ServiceOrderNo);
//         IF ServiceHeader.FINDFIRST THEN
//           BEGIN
//             CLEAR(ServiceMgt);
//             ServiceMgt.CreateSalesInvoiceInUDRServicesFromBatasBrother(ServiceHeader);

//           END;
//           */

//     end;

//     procedure CreateSalesInvoiceInUDRServicesFromBatasBrother(ServiceOrderNo: Code[20]): Text
//     var
//         UDRServiceReqList: Page "Unlinked Attachments";
//         ServiceHeader: Record "Service Header";
//         Msg: Text;
//     begin
//         /*ServiceHeader.RESET;
//         ServiceHeader.SETRANGE("No." , ServiceOrderNo);
//         IF ServiceHeader.FINDFIRST THEN BEGIN
//           CLEAR(UDRServiceReqList);
//           Msg := UDRServiceReqList.CreateSalesInvoiceInUDRServicesFromBatasBrother(ServiceHeader);
//           EXIT(Msg);
//         END;*/

//     end;

//     procedure GetServiceInvoice(OrderNo: Code[20]): Text
//     var
//         ServiceInvoiceHdr: Record "Service Invoice Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//     // bytes: DotNet ;
//     // Convert: DotNet ;
//     // MemoryStream: DotNet ;
//     begin
//         ServiceInvoiceHdr.Reset;
//         ServiceInvoiceHdr.SetRange("Order No.", OrderNo);
//         //ServiceInvoiceHdr.SETRANGE("No. Printed", 0);
//         if ServiceInvoiceHdr.FindLast then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(DelChr(ServiceInvoiceHdr."No.", '=', '\/')); //."No.";
//                                                                             //filename := DELCHR(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(50174, filename, ServiceInvoiceHdr);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);
//         end;
//         //END;
//     end;

//     procedure GetPI(OrderNo: Code[20]): Text
//     var
//         ServiceHeader: Record "Service Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//     begin
//         ServiceHeader.Reset;
//         ServiceHeader.SetRange("No.", OrderNo);
//         if ServiceHeader.FindLast then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(CreateGuid); //."No.";
//             filename := DelChr(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(50061, filename, ServiceHeader);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);

//         end;
//     end;

//     procedure GetJobCard(OrderNo: Code[20]): Text
//     var
//         ServiceHeader: Record "Service Header";
//         filename: Text;
//         InvoiceFile: File;
//         InStream: InStream;
//         OutputText: Text;
//         Buffer: Text;
//         bytes: DotNet ;
//         Convert: DotNet ;
//         MemoryStream: DotNet ;
//     begin
//         ServiceHeader.Reset;
//         ServiceHeader.SetRange("No.", OrderNo);
//         if ServiceHeader.FindLast then begin
//             filename := 'C:\NAVTemp\';
//             filename += Format(CreateGuid); //."No.";
//             filename := DelChr(filename, '=', '{-}');
//             filename += '.pdf';
//             REPORT.SaveAsPdf(50063, filename, ServiceHeader);
//             Clear(InStream);
//             Clear(OutputText);
//             InvoiceFile.Open(filename);
//             InvoiceFile.CreateInStream(InStream);

//             MemoryStream := MemoryStream.MemoryStream();
//             CopyStream(MemoryStream, InStream);
//             bytes := MemoryStream.ToArray();// GetBuffer();
//             OutputText := Convert.ToBase64String(bytes);

//             InvoiceFile.Close;
//             exit(OutputText);

//         end;
//     end;

//     local procedure "----------------------General"()
//     begin
//     end;

//     procedure MakeWebUser(UserName: Code[50])
//     var
//         User: Record User;
//     begin
//         User.Reset;
//         User.SetRange("User Name", UserName);
//         User.FindFirst;// THEN BEGIN
//         User.Validate("License Type", User."License Type"::"External User");
//         User.Modify(true);
//         //END;
//     end;

//     procedure MakeNavUser(UserName: Code[50]): Text
//     var
//         User: Record User;
//         ReturnText: Text;
//     begin
//         User.Reset;
//         User.SetRange("User Name", UserName);

//         UserSetup.Get(UserName);
//         User.FindFirst;
//         User.Validate("License Type", UserSetup."License Type II");
//         User.Modify(true);

//         ReturnText := StrSubstNo('User %1 has been converted to %2', User."User Name", User."License Type");
//         exit(ReturnText);
//     end;

//     local procedure "----------------------SMS"()
//     begin
//     end;

//     procedure InsertLineFromSMS(from: Text; sms: Text): Text
//     begin
//     end;

//     local procedure Test()
//     begin
//         Message('test');
//     end;

//     local procedure DeleteAttendanceLine()
//     var
//         Employee: Record Employee;
//         AttendanceLine: Record "Attendance Line";
//         EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
//     begin
//         Employee.Reset;
//         //Employee.SETFILTER("Employment Date",'<>%1',0D);
//         if Employee.FindFirst then
//             repeat
//                 AttendanceLine.Reset;
//                 AttendanceLine.SetRange("Employee No.", Employee."No.");
//                 AttendanceLine.SetFilter("Attendance Date", '<%1', Employee."Employment Date");
//                 if AttendanceLine.Count <> 0 then
//                     AttendanceLine.DeleteAll;

//                 EmployeeAttendanceActivity.Reset;
//                 EmployeeAttendanceActivity.SetRange("Employee No.", Employee."No.");
//                 EmployeeAttendanceActivity.SetFilter("Attendance Date", '<%1', Employee."Employment Date");
//                 if EmployeeAttendanceActivity.Count <> 0 then
//                     EmployeeAttendanceActivity.DeleteAll;
//             until Employee.Next = 0;
//     end;

//     local procedure UpdateNames()
//     begin
//         EMployee.Reset;
//         //EMployee.SETRANGE("No.",'KD3587');
//         EMployee.SetFilter("Deputation on", '%1|%2', EMployee."Deputation on"::Branch, EMployee."Deputation on"::"Extension Counter");
//         EMployee.SetRange("Global Dimension 1 Code", 'V3|V4');
//         EMployee.SetRange(Status, EMployee.Status::Active);
//         if EMployee.FindFirst then
//             repeat
//                 case EMployee."Deputation on" of
//                     EMployee."Deputation on"::"Extension Counter":
//                         begin
//                             EMployee.Validate("Extension Counter Code");
//                         end;
//                     EMployee."Deputation on"::Branch:
//                         begin
//                             EMployee.Validate("Global Dimension 1 Code", EMployee."Global Dimension 1 Code");
//                         end;
//                     EMployee."Deputation on"::Province:
//                         begin
//                             EMployee.Validate("Province Code");
//                         end;
//                     EMployee."Deputation on"::"Sub Province":
//                         begin
//                             EMployee.Validate("Sub Province Code");
//                         end;
//                     EMployee."Deputation on"::Unit:
//                         begin
//                             EMployee.Validate("Unit Code");
//                         end;
//                     EMployee."Deputation on"::Department:
//                         begin
//                             EMployee.Validate("Department Code");
//                         end;
//                 end;
//                 EMployee.Modify;
//             until EMployee.Next = 0;
//     end;

//     local procedure UpdateWorkShift()
//     var
//         Workshift: Record "Employee Work Shift";
//     begin
//         Workshift.FindFirst;
//         EMployee.Reset;
//         if EMployee.FindFirst then
//             repeat
//                 EMployee."Employee Work Shift" := Workshift.Code;
//                 EMployee.Modify;
//             until EMployee.Next = 0;
//     end;

//     local procedure InsertEmployeeAttendanceActivity()
//     begin
//         EmployeeAttendanceActivity.Reset();
//         EmployeeAttendanceActivity.SetRange("Attendance Date", 20210831D);
//         EmployeeAttendanceActivity.DeleteAll;
//     end;

//     local procedure UpdateAttendancelog()
//     var
//         Date: Record Date;
//         AttendanceLog: Record "Attendance Log";
//         AttendanceLog2: Record "Attendance Log";
//     begin
//         EMployee.Reset;
//         EMployee.SetRange(Status, EMployee.Status::Active);
//         if EMployee.FindFirst then
//             repeat
//                 Date.Reset;
//                 Date.SetRange("Period Start", 20210324D, 20210329D);
//                 if Date.FindFirst then
//                     repeat
//                         AttendanceLog.Reset;
//                         AttendanceLog.SetRange("Employee ID", EMployee."No.");
//                         AttendanceLog.SetRange(Date, Date."Period Start");
//                         //  AttendanceLog.SETFILTER("Check Out Time",'<>%1',0T);
//                         if AttendanceLog.FindFirst then begin
//                             AttendanceLog2.Reset;
//                             AttendanceLog2.SetRange("Employee ID", EMployee."No.");
//                             AttendanceLog2.SetRange(Date, Date."Period Start");
//                             AttendanceLog2.SetFilter("Entry No.", '<>%1', AttendanceLog."Entry No.");
//                             AttendanceLog2.DeleteAll;
//                         end;

//                     until Date.Next = 0;
//             until EMployee.Next = 0;
//     end;

//     local procedure DeleteServiceHistory()
//     var
//         TempServiceHistory: Record "Temp Service History 1";
//         ServiceHistory: Record "Employee Service History";
//     begin
//         TempServiceHistory.Reset;
//         if TempServiceHistory.Find('-') then
//             repeat
//                 ServiceHistory.Reset;
//                 ServiceHistory.Get(TempServiceHistory."Service History Code");
//                 ServiceHistory.Delete;
//             until TempServiceHistory.Next = 0;
//     end;

//     local procedure UpdateSalaryLevelDescription()
//     var
//         Employee: Record Employee;
//     begin
//         Employee.Reset;
//         if Employee.FindSet then
//             repeat
//                 Employee.Validate("Salary Level", Employee."Salary Level");
//                 Employee.Modify;
//             until Employee.Next = 0;
//     end;

//     local procedure UpdateEmpAttendanceActivity()
//     begin
//         EmployeeAttendanceActivity.Reset;
//         EmployeeAttendanceActivity.SetRange("Present Day", 1);
//         EmployeeAttendanceActivity.SetRange("Leave Day", 0);
//         EmployeeAttendanceActivity.SetRange("Attendance Date", 20210409D, 20210428D);
//         EmployeeAttendanceActivity.SetRange("Source No.", '');
//         EmployeeAttendanceActivity.SetRange("Check In Time", 0T);
//         EmployeeAttendanceActivity.SetRange("Check Out Time", 0T);
//         EmployeeAttendanceActivity.SetRange("Late Remarks", 'System Auto Present.Covid second wave Lockdown');
//         if EmployeeAttendanceActivity.FindFirst then
//             repeat
//                 EmployeeAttendanceActivity."Present Day" := 0;
//                 EmployeeAttendanceActivity."Absent Day" := 1;
//                 EmployeeAttendanceActivity."Late Remarks" := '';
//                 EmployeeAttendanceActivity.Modify;
//             until EmployeeAttendanceActivity.Next = 0;
//     end;

//     local procedure UpdateEvaluationAttribute()
//     var
//         EvaluationEntry: Record "Evaluation Entry";
//     begin
//         EvaluationEntry.Reset;
//         EvaluationEntry.SetRange("Interviewer Code", 'PB2350');
//         EvaluationEntry.ModifyAll(Posted, true);
//     end;

//     local procedure ValidateEmployeeSolID()
//     var
//         Depart: Record Department;
//         EmpHie: Record "Employee Hierarchy Master";
//         Province: Record Province;
//         Subprovince: Record "Sub Province";
//     begin
//         EMployee.Reset;
//         EMployee.SetRange(Status, EMployee.Status::Active);
//         if EMployee.FindFirst then
//             repeat
//                 case EMployee."Deputation on" of
//                     EMployee."Deputation on"::Branch:
//                         begin
//                             EMployee.Validate("Global Dimension 1 Code");
//                             EMployee.Modify;
//                         end;

//                     EMployee."Deputation on"::Department:
//                         begin
//                             EMployee.Validate("Department Code");
//                             EMployee.Modify;
//                         end;

//                     EMployee."Deputation on"::"Extension Counter":
//                         begin
//                             EMployee.Validate("Extension Counter Code");
//                             EMployee.Modify;
//                         end;

//                     EMployee."Deputation on"::Province:
//                         begin
//                             EMployee.Validate("Province Code");
//                             EMployee.Modify;
//                         end;

//                     EMployee."Deputation on"::"Sub Province":
//                         begin
//                             EMployee.Validate("Sub Province Code");
//                             EMployee.Modify;
//                         end;

//                     EMployee."Deputation on"::Unit:
//                         begin
//                             EMployee.Validate("Unit Code");
//                             EMployee.Modify;
//                         end;
//                 end;
//             until EMployee.Next = 0;
//     end;

//     local procedure UpdateEmployeeFunctionalTitle()
//     begin

//         EMployee.Reset;
//         EMployee.SetFilter("Functional Title", 'CCE|ECE|REE|RCEE');
//         EMployee.SetRange(Status, EMployee.Status::Active);
//         if EMployee.FindFirst then
//             repeat
//                 if EMployee."Functional Title" = 'CCE' then
//                     EMployee.Validate("Functional Title", 'RMC')
//                 else if EMployee."Functional Title" = 'ECE' then
//                     EMployee.Validate("Functional Title", 'CCRM')
//                 else if EMployee."Functional Title" in ['REE', 'RCEE'] then
//                     EMployee.Validate("Functional Title", 'RMR');
//                 EMployee.Modify;
//             until EMployee.Next = 0;
//     end;

//     local procedure UpdateSPO()
//     begin
//         EMployee.Reset;
//         EMployee.SetFilter("Deputation on", '%1|%2', EMployee."Deputation on"::Branch, EMployee."Deputation on"::"Extension Counter");
//         EMployee.SetRange(Status, EMployee.Status::Active);

//         if EMployee.FindFirst then
//             repeat
//                 if EMployee."Deputation on" = EMployee."Deputation on"::Branch then
//                     EMployee.Validate("Global Dimension 1 Code")
//                 else
//                     if EMployee."Deputation on" = EMployee."Deputation on"::"Extension Counter" then
//                         EMployee.Validate("Extension Counter Code");
//                 EMployee.Modify;
//             until EMployee.Next = 0;
//     end;

//     local procedure RemoveAmount()
//     begin
//         PayrollAttributesUsage.Reset;
//         PayrollAttributesUsage.SetFilter(Code, '%1|%2|%3|%4|%5', 'PF-BENEFIT', 'PF-EMPLOYEE', 'PF-EMPLOYER', 'CIT', 'RTF');
//         PayrollAttributesUsage.ModifyAll(Amount, 0);
//     end;

//     local procedure RemovePF()
//     begin
//         EMployee.Reset();
//         EMployee.SetFilter("Employment Type", '%1|%2', EMployee."Employment Type"::Contract, EMployee."Employment Type"::Probation);
//         if EMployee.FindFirst then
//             repeat
//                 PayrollAttributesUsage.Reset;
//                 PayrollAttributesUsage.SetFilter(Code, '%1|%2|%3|%4', 'PF-BENEFIT', 'PF-EMPLOYEE', 'PF-EMPLOYER', 'LFA');
//                 PayrollAttributesUsage.SetRange("Employee Code", EMployee."No.");
//                 PayrollAttributesUsage.DeleteAll();
//             until EMployee.Next = 0;
//     end;

//     local procedure RemoveSpaceAccount()
//     var
//         BankAccount: Text;
//     begin
//         EMployee.Reset;
//         EMployee.SetFilter("Bank Account No.", '<>%1', '');
//         if EMployee.FindFirst then begin
//             BankAccount := DelChr(EMployee."Bank Account No.", '=', ' ');
//             EMployee."Bank Account No." := BankAccount;
//             EMployee.Modify;
//         end;
//     end;

//     local procedure ChangeFiscalYear()
//     var
//         EmployeeLedgerEntry: Record "Employee Ledger Entry";
//         PostedPayrollHeader: Record "Posted Payroll Header";
//         EngNepDate: Record "English-Nepali Date";
//     begin
//         DetailedEmployeeledger.Reset();
//         DetailedEmployeeledger.SetRange("Document No.", 'POSTSET_78_79_00005');
//         if DetailedEmployeeledger.FindFirst then
//             repeat
//                 EMployee.Get(DetailedEmployeeledger."Employee No.");
//                 PayrollAttributes.Get(DetailedEmployeeledger."Payroll Attribute Code");
//                 EngNepDate.Reset;
//                 EngNepDate.SetRange("English Date", DetailedEmployeeledger."Pay Period Start Date");
//                 if EngNepDate.FindFirst then;

//                 if PayrollAttributes.Type in [PayrollAttributes.Type::Benefits, PayrollAttributes.Type::"Non-Payment"] then begin
//                     case EMployee."Deputation on" of
//                         EMployee."Deputation on"::Province, EMployee."Deputation on"::"Sub Province":
//                             begin
//                                 if PayrollAttributes."Static GL Ledger" then begin
//                                     PayrollAttributes.TestField("Static GL Ledger Account");
//                                     DetailedEmployeeledger.Validate("Finacle GL No", PayrollAttributes."Static GL Ledger Account" + PayrollAttributes."GL Code for Region");
//                                 end else
//                                     DetailedEmployeeledger.Validate("Finacle GL No", EMployee."Sol Id" + PayrollAttributes."GL Code for Region");
//                             end else begin
//                             if PayrollAttributes."Static GL Ledger" then begin
//                                 PayrollAttributes.TestField("Static GL Ledger Account");
//                                 DetailedEmployeeledger.Validate("Finacle GL No", PayrollAttributes."Static GL Ledger Account" + PayrollAttributes."GL Code For Branch");
//                             end else
//                                 DetailedEmployeeledger.Validate("Finacle GL No", EMployee."Sol Id" + PayrollAttributes."GL Code For Branch");
//                         end;
//                     end;
//                 end else begin
//                     if PayrollAttributes."Static GL Ledger" then
//                         DetailedEmployeeledger.Validate("Finacle GL No", PayrollAttributes."Static GL Ledger Account" + PayrollAttributes."GL Code For Branch")
//                     else
//                         DetailedEmployeeledger.Validate("Finacle GL No", PayrollAttributes."GL Code For Branch")
//                 end;
//                 if PayrollAttributes."Finacle GL Name" <> '' then
//                     DetailedEmployeeledger.Validate("Finacle GL Name", StrSubstNo('%1 %2-%3', PayrollAttributes."Finacle GL Name", EngNepDate."Nepali Year", EngNepDate."Nepali Month"))
//                 else
//                     Clear(DetailedEmployeeledger."Finacle GL Name");
//                 DetailedEmployeeledger.Modify;
//             until DetailedEmployeeledger.Next = 0;
//     end;

//     local procedure ValidateNICRTFLoan()
//     begin
//         PayrollAttributesUsage.Reset();
//         PayrollAttributesUsage.SetRange(Code, 'RF LOAN');
//         PayrollAttributesUsage.SetFilter(Amount, '<>%1', 0);
//         PayrollAttributesUsage.ModifyAll("Is Loan EMI Applicable", true);
//     end;

//     local procedure ValidateAllowanceAssignmentLine()
//     var
//         LevelwiseAttribute: Record "Level Wise Attributes";
//         NoOfDays: Integer;
//     begin
//         PGSetup.Get;

//         AllowanceAssigmentLine.Reset();
//         AllowanceAssigmentLine.SetRange("From Date", 20210701D, 20210731D);
//         AllowanceAssigmentLine.SetRange("Allowance Type", 'CRISK');
//         AllowanceAssigmentLine.SetRange("Approval Status", AllowanceAssigmentLine."Approval Status"::Screened);
//         AllowanceAssigmentLine.SetRange("Allowance Amount", 0);
//         if AllowanceAssigmentLine.FindFirst then
//             repeat
//                 EMployee.Get(AllowanceAssigmentLine."Employee Code");
//                 if EMployee."Employment Type" <> EMployee."Employment Type"::Contract then begin
//                     LevelwiseAttribute.Reset;
//                     PGSetup.TestField("TA Salary Level");
//                     LevelwiseAttribute.Get(EMployee."Salary Grade", EMployee."Salary Level");
//                     if LevelwiseAttribute."Level Code" = PGSetup."TA Salary Level" then
//                         AllowanceAssigmentLine."Allowance Amount" := Round(PGSetup."Cash Risk Percent" / 100 * LevelwiseAttribute.Allowance / 31, 0.00001, '=')
//                     else
//                         AllowanceAssigmentLine."Allowance Amount" := Round(PGSetup."Cash Risk Percent" / 100 * LevelwiseAttribute."Total Basic Salary" / 31, 0.00001, '=');
//                 end else begin
//                     AllowanceAssigmentLine."Allowance Amount" := Round(PGSetup."Cash Risk Percent" / 100 * EMployee."Contract Salary Amount" / 31, 0.00001, '=');
//                 end;
//                 AllowanceAssigmentLine.Modify;
//             until AllowanceAssigmentLine.Next = 0;
//     end;

//     local procedure UpdateVaultKeyAllowance()
//     var
//         AllowanceLine: Record "Allowance Assignment Line";
//         AllowanceLine2: Record "Allowance Assignment Line";
//     begin
//         AllowanceLine.Reset();
//         //AllowanceLine.SETRANGE("From Date",070121D,070121D);
//         AllowanceLine.SetRange("From Date", 20210701D, 20210731D);
//         AllowanceLine.SetRange("Allowance Type", 'VAULT KEY');
//         AllowanceLine.SetRange("Approval Status", AllowanceLine."Approval Status"::Screened);
//         //AllowanceLine.SETCURRENTKEY(
//         if AllowanceLine.FindFirst then
//             repeat
//                 AllowanceLine2.Reset;
//                 AllowanceLine2.SetRange("From Date", AllowanceLine."From Date");
//                 AllowanceLine2.SetRange("Employee Code", AllowanceLine."Employee Code");
//                 AllowanceLine2.SetRange("Approval Status", AllowanceLine2."Approval Status"::Screened);
//                 AllowanceLine2.SetRange("Allowance Type", AllowanceLine."Allowance Type");
//                 AllowanceLine2.SetFilter("Entry No.", '<>%1', AllowanceLine."Entry No.");
//                 if AllowanceLine2.FindFirst then begin
//                     AllowanceLine2."Approval Status" := AllowanceLine2."Approval Status"::Rejected;
//                     AllowanceLine2.Modify;
//                 end;
//             until AllowanceLine.Next = 0;
//     end;

//     local procedure DeleteEmployeeAttendance()
//     begin
//         EmployeeAttendanceActivity.Reset();
//         EmployeeAttendanceActivity.SetRange("Attendance Date", Today, 20210816D);
//         EmployeeAttendanceActivity.DeleteAll;
//     end;

//     local procedure UpdateLFA()
//     var
//         LeaveEarn: Record "Leave Earn";
//         DocNo: Code[20];
//     begin
//         HRSSetup.Get();
//         EMployee.Reset;
//         EMployee.SetRange(Status, EMployee.Status::Active);
//         EMployee.SetRange("Employment Type", EMployee."Employment Type"::Permanent);
//         if EMployee.FindFirst then
//             repeat
//                 DocNo := NoSeriesMgt.GetNextNo(HRSSetup."Leave Earn No.", Today, true);
//                 LeaveEarn.Init;
//                 LeaveEarn.Validate(EmpNo, EMployee."No.");
//                 LeaveEarn.Validate("Leave Code", 'AML');
//                 LeaveEarn.Validate("Balancing Days", 10);
//                 LeaveEarn.Validate(Type, LeaveEarn.Type::Earned);
//                 LeaveEarn.Validate(Remarks, 'AML 2079/2080 Fisal Year earned.');
//                 LeaveEarn.Validate("Posted Date", Today);
//                 LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(Today));
//                 LeaveEarn."Entry No." := DocNo;
//                 LeaveEarn.Insert();
//             until EMployee.Next = 0;
//     end;

//     local procedure settledsalaryadvance()
//     begin
//         SalaryAdv.Reset();
//         SalaryAdv.SetRange("Approval Status", SalaryAdv."Approval Status"::Approved);
//         SalaryAdv.SetRange(Settled, false);
//         if SalaryAdv.FindFirst then
//             repeat
//                 SalaryAdv.CalcFields("Salary Advance Paid");
//                 if SalaryAdv."Salary Advance Paid" = SalaryAdv."Applied Loan/Advance" then begin
//                     SalaryAdv.Settled := true;
//                     SalaryAdv."Settlement Date" := Today;
//                     SalaryAdv."Settler User ID" := UserId;
//                     SalaryAdv.Modify;
//                 end;
//             until SalaryAdv.Next = 0;
//     end;

//     local procedure ValidateLumpsum()
//     begin
//         DetailedEmployeeledger.Reset;
//         DetailedEmployeeledger.SetRange("Document No.", 'POSTSAL_78_79_0002');
//         DetailedEmployeeledger.SetFilter("Payroll Attribute Code", '%1', 'LUMPSUM CIT');
//         if DetailedEmployeeledger.FindFirst then
//             repeat
//                 EMployee.Get(DetailedEmployeeledger."Employee No.");
//                 EMployee."Lumpsum CIT (Not Actual)" := Abs(DetailedEmployeeledger.Amount);
//                 EMployee.Modify;
//                 DetailedEmployeeledger.Disabled := true;
//                 DetailedEmployeeledger.Modify;
//             until DetailedEmployeeledger.Next = 0;
//     end;

//     local procedure ValidateCandidate()
//     var
//         Candidate: Record Candidate;
//         EvaluationEntry: Record "Evaluation Entry";
//     begin
//         Candidate.Reset;
//         Candidate.SetRange("Vacancy Code", 'VACANCY0003');
//         Candidate.ModifyAll(Status, Candidate.Status::"Interview Scheduled");
//     end;

//     local procedure ValidateEvaluationAttribute()
//     var
//         Candidate: Record Candidate;
//     begin
//         Candidate.Reset;
//         if Candidate.FindFirst then
//             repeat
//                 EvaluationEntries.Reset;
//                 EvaluationEntries.SetRange("Vacancy Code", Candidate."Vacancy Code");
//                 EvaluationEntries.SetRange("No.", Candidate."No.");
//                 EvaluationEntries.ModifyAll(Name, Candidate."Full Name");
//             until Candidate.Next = 0;

//         /*EvaluationEntries.SETRANGE(Posted,FALSE);
//         EvaluationEntries.SETRANGE("Attribute Code",'WRITTEN');
//         EvaluationEntries.SETFILTER(Marks,'<>%1',0);
//         //EvaluationEntries.SETRANGE("Is Remarks",FALSE);
//         EvaluationEntries.MODIFYALL(Posted,TRUE);*/

//         /*  EvaluationEntries.RESET();
//           EvaluationEntries.SETRANGE("Vacancy Code",'VACANCY0002');
//           //EvaluationEntries.SETRANGE("Attribute Code",EvaluationAttribute.Code);
//         //  EvaluationEntries.SETRANGE("Interviewer Code",'MP5727');
//           IF EvaluationEntries.FINDFIRST THEN REPEAT
//             IF EMployee.GET(EvaluationEntries."Interviewer Code") THEN BEGIN
//               EvaluationEntries."Interviewer Name" := EMployee."Full Name";
//               EvaluationEntries.MODIFY;
//             END;
//           UNTIL EvaluationEntries.NEXT =0;*/

//     end;

//     local procedure UpdateHoliday()
//     begin
//         EMployee.Reset;
//         EMployee.SetRange("Deputation on", EMployee."Deputation on"::"Extension Counter");
//         EMployee.SetFilter("Extension Counter Code", '%1|%2', 'EXT031', 'EXT058', 'EXT048');
//         if EMployee.FindFirst then
//             repeat
//                 EmployeeAttendanceActivity.Reset;
//                 EmployeeAttendanceActivity.SetRange("Employee No.", EMployee."No.");
//                 EmployeeAttendanceActivity.SetRange("Attendance Date", 20210912D);
//                 if EmployeeAttendanceActivity.FindFirst then begin
//                     EmployeeAttendanceActivity."Day Type" := EmployeeAttendanceActivity."Day Type"::Holiday;
//                     EmployeeAttendanceActivity.Modify;
//                 end;
//             until EMployee.Next = 0;
//     end;

//     local procedure CopyPayrollType()
//     var
//         EmployeeLedgerEntry: Record "Employee Ledger Entry";
//         PostedPayHeader: Record "Posted Payroll Header";
//     begin
//         PostedPayHeader.Reset;
//         if PostedPayHeader.FindFirst then
//             repeat
//                 EmployeeLedgerEntry.Reset;
//                 EmployeeLedgerEntry.SetRange("Document No.", PostedPayHeader."No.");
//                 EmployeeLedgerEntry.ModifyAll(Type, PostedPayHeader.Type);
//             until PostedPayHeader.Next = 0;
//     end;

//     local procedure AllowanceAssignmentStatus()
//     begin
//         AllowanceAssigmentLine.Reset;
//         AllowanceAssigmentLine.SetRange("From Date", 20211001D, 20211031D);
//         AllowanceAssigmentLine.ModifyAll("Rejection Remarks", '');
//     end;

//     [TryFunction]
//     local procedure UpdateLoan()
//     var
//         EmpLoan: Record "Employee Loan/Advance";
//     begin
//         EmpLoan.Reset();
//         EmpLoan.SetRange("Employee Code", 'st4310');
//         EmpLoan.SetFilter("Approval Status", '%1|%2', EmpLoan."Approval Status"::"Pending Approval", EmpLoan."Approval Status"::Recommended, EmpLoan."Approval Status"::Screened);
//         if EmpLoan.FindFirst then
//             repeat
//                 EmpLoan.Validate("Applied Loan/Advance");
//                 EmpLoan.Modify(true);
//             until EmpLoan.Next = 0;
//     end;

//     local procedure UpdatePromotionDate()
//     var
//         EmpServiceHistory: Record "Employee Service History";
//         DocNo: Code[20];
//     begin
//         EMployee.Reset;
//         EMployee.SetRange(Status, EMployee.Status::Active);
//         EMployee.SetRange("Employment Type", EMployee."Employment Type"::Permanent);
//         EMployee.SetFilter("Promotion Date", '<>%1', 0D);
//         //EMployee.SETFILTER("No.",'RB0674'); '<>%1'
//         if EMployee.FindFirst then
//             repeat
//                 EmpServiceHistory.Reset;
//                 EmpServiceHistory.SetCurrentKey("Effective Date");
//                 EmpServiceHistory.SetRange("Employee No.", EMployee."No.");
//                 EmpServiceHistory.SetFilter("Service Event", '%1|%2|%3', EmpServiceHistory."Service Event"::Promotion, EmpServiceHistory."Service Event"::"Internal Appointment", EmpServiceHistory."Service Event"::"Promotion Through Job Evaluation");
//                 if EmpServiceHistory.FindLast then begin
//                     EMployee."Promotion Date" := EmpServiceHistory."Effective Date";
//                     EMployee.Modify;
//                 end;
//             until EMployee.Next = 0;
//     end;

//     local procedure UpdateContactExpiryDate()
//     var
//         EmployeeRec: Record Employee;
//     begin
//         EmployeeRec.Reset;
//         EmployeeRec.SetRange("No.", 'SC16021');
//         if EmployeeRec.FindFirst then begin
//             EmployeeRec."Contract Expiry Date" := 20220714D; //021222D
//             EmployeeRec.Modify;
//         end;
//     end;

//     local procedure UpdateUnitEmployee()
//     var
//         EmployeeRec: Record Employee;
//     begin
//         EmployeeRec.Reset;
//         EmployeeRec.SetRange("Unit Code", 'UNIT114');
//         if EmployeeRec.FindFirst then
//             repeat
//                 EmployeeRec."Unit Code" := '';
//                 EmployeeRec.Modify;
//             until EmployeeRec.Next = 0;
//     end;

//     local procedure UpdateTransferUnitCode()
//     var
//         EmpActivity: Record "Employee Activity";
//     begin
//         EmpActivity.Reset;
//         EmpActivity.SetFilter("Deputation On", '<>%1', EmpActivity."Deputation On"::Unit);
//         EmpActivity.SetRange("Unit Code", 'UNIT114');
//         if EmpActivity.FindFirst then
//             repeat
//                 EmpActivity."Unit Code" := '';
//                 EmpActivity.Modify;
//             until EmpActivity.Next = 0;
//     end;

//     local procedure UpdateTransferUnitToCode()
//     var
//         EmpActivity: Record "Employee Activity";
//     begin
//         EmpActivity.Reset;
//         EmpActivity.SetFilter("Deputation On (To)", '<>%1', EmpActivity."Deputation On (To)"::Unit);
//         EmpActivity.SetRange("Unit (To)", 'UNIT114');
//         if EmpActivity.FindFirst then
//             repeat
//                 EmpActivity."Unit (To)" := '';
//                 EmpActivity.Modify;
//             until EmpActivity.Next = 0;
//     end;

//     local procedure UpdateEmployeeActivityDeputationExtensionCounter()
//     var
//         EmployeeActivity: Record "Employee Activity";
//         EmployeeServiceHistory: Record "Employee Service History";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetFilter(Type, '%1|%2', EmployeeActivity.Type::"Employee Transfer", EmployeeActivity.Type::"HR Transfer");
//         EmployeeActivity.SetRange("Deputation On (To)", EmployeeActivity."Deputation On (To)"::"Extension Counter");
//         EmployeeActivity.SetRange("Extension Counter (To)", '');
//         if EmployeeActivity.FindFirst then
//             repeat
//                 EmployeeServiceHistory.Reset;
//                 EmployeeServiceHistory.SetRange("Document No.", EmployeeActivity."No.");
//                 EmployeeServiceHistory.SetRange("Deputation On (To)", EmployeeServiceHistory."Deputation On (To)"::"Extension Counter");
//                 if EmployeeServiceHistory.FindFirst then begin
//                     EmployeeActivity."Extension Counter (To)" := EmployeeServiceHistory."Deputation Code (To)";
//                     EmployeeActivity.Modify;
//                 end;
//             until EmployeeActivity.Next = 0;
//     end;

//     local procedure UpdateEmployeeActivityDeputationBranch()
//     var
//         EmployeeActivity: Record "Employee Activity";
//         EmployeeServiceHistory: Record "Employee Service History";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetFilter(Type, '%1|%2', EmployeeActivity.Type::"Employee Transfer", EmployeeActivity.Type::"HR Transfer");
//         EmployeeActivity.SetRange("Deputation On (To)", EmployeeActivity."Deputation On (To)"::Branch);
//         EmployeeActivity.SetRange("Shortcut Dimension 1 Code (To)", '');
//         //EmployeeActivity.SETRANGE("No.",'TRANSFER_78-79_00886');
//         if EmployeeActivity.FindFirst then
//             repeat
//                 EmployeeServiceHistory.Reset;
//                 EmployeeServiceHistory.SetRange("Document No.", EmployeeActivity."No.");
//                 EmployeeServiceHistory.SetRange("Deputation On (To)", EmployeeServiceHistory."Deputation On (To)"::Branch);
//                 if EmployeeServiceHistory.FindFirst then begin
//                     EmployeeActivity."Shortcut Dimension 1 Code (To)" := EmployeeServiceHistory."Deputation Code (To)";
//                     EmployeeActivity.Modify;
//                 end;
//             until EmployeeActivity.Next = 0;
//     end;

//     local procedure UpdateEmployeeActivityDeputationDepartment()
//     var
//         EmployeeActivity: Record "Employee Activity";
//         EmployeeServiceHistory: Record "Employee Service History";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetFilter(Type, '%1|%2', EmployeeActivity.Type::"Employee Transfer", EmployeeActivity.Type::"HR Transfer");
//         EmployeeActivity.SetRange("Deputation On (To)", EmployeeActivity."Deputation On (To)"::Department);
//         EmployeeActivity.SetRange("Department Code (To)", '');
//         //EmployeeActivity.SETRANGE("No.",'TRANSFER_78-79_00885');
//         if EmployeeActivity.FindFirst then
//             repeat
//                 EmployeeServiceHistory.Reset;
//                 EmployeeServiceHistory.SetRange("Document No.", EmployeeActivity."No.");
//                 EmployeeServiceHistory.SetRange("Deputation On (To)", EmployeeServiceHistory."Deputation On (To)"::Department);
//                 if EmployeeServiceHistory.FindFirst then begin
//                     EmployeeActivity."Department Code (To)" := EmployeeServiceHistory."Deputation Code (To)";
//                     EmployeeActivity.Modify;
//                 end;
//             until EmployeeActivity.Next = 0;
//     end;

//     local procedure UpdateEmployeeActivityDeputationProvince()
//     var
//         EmployeeActivity: Record "Employee Activity";
//         EmployeeServiceHistory: Record "Employee Service History";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetFilter(Type, '%1|%2', EmployeeActivity.Type::"Employee Transfer", EmployeeActivity.Type::"HR Transfer");
//         EmployeeActivity.SetRange("Deputation On (To)", EmployeeActivity."Deputation On (To)"::Province);
//         EmployeeActivity.SetRange("Province Code (To)", '');
//         //EmployeeActivity.SETRANGE("No.",'TRANSFER_78-79_00956');
//         if EmployeeActivity.FindFirst then
//             repeat
//                 EmployeeServiceHistory.Reset;
//                 EmployeeServiceHistory.SetRange("Document No.", EmployeeActivity."No.");
//                 EmployeeServiceHistory.SetRange("Deputation On (To)", EmployeeServiceHistory."Deputation On (To)"::Province);
//                 if EmployeeServiceHistory.FindFirst then begin
//                     EmployeeActivity."Province Code (To)" := EmployeeServiceHistory."Deputation Code (To)";
//                     EmployeeActivity.Modify;
//                 end;
//             until EmployeeActivity.Next = 0;
//     end;

//     local procedure UpdateEmployeeActivityDeputationSubProvince()
//     var
//         EmployeeActivity: Record "Employee Activity";
//         EmployeeServiceHistory: Record "Employee Service History";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetFilter(Type, '%1|%2', EmployeeActivity.Type::"Employee Transfer", EmployeeActivity.Type::"HR Transfer");
//         EmployeeActivity.SetRange("Deputation On (To)", EmployeeActivity."Deputation On (To)"::"Sub Province");
//         EmployeeActivity.SetRange("Sub Province Code (To)", '');
//         //EmployeeActivity.SETRANGE("No.",'TRANSFER_78-79_00958');
//         if EmployeeActivity.FindFirst then
//             repeat
//                 EmployeeServiceHistory.Reset;
//                 EmployeeServiceHistory.SetRange("Document No.", EmployeeActivity."No.");
//                 EmployeeServiceHistory.SetRange("Deputation On (To)", EmployeeServiceHistory."Deputation On (To)"::"Sub Province");
//                 if EmployeeServiceHistory.FindFirst then begin
//                     EmployeeActivity."Sub Province Code (To)" := EmployeeServiceHistory."Deputation Code (To)";
//                     EmployeeActivity.Modify;
//                 end;
//             until EmployeeActivity.Next = 0;
//     end;

//     local procedure UpdateEmployeeActivityDeputationUnit()
//     var
//         EmployeeActivity: Record "Employee Activity";
//         EmployeeServiceHistory: Record "Employee Service History";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetFilter(Type, '%1|%2', EmployeeActivity.Type::"Employee Transfer", EmployeeActivity.Type::"HR Transfer");
//         EmployeeActivity.SetRange("Deputation On (To)", EmployeeActivity."Deputation On (To)"::Unit);
//         EmployeeActivity.SetRange("Unit (To)", '');
//         //EmployeeActivity.SETRANGE("No.",'TRANSFER_78-79_01178');
//         if EmployeeActivity.FindFirst then
//             repeat
//                 EmployeeServiceHistory.Reset;
//                 EmployeeServiceHistory.SetRange("Document No.", EmployeeActivity."No.");
//                 EmployeeServiceHistory.SetRange("Deputation On (To)", EmployeeServiceHistory."Deputation On (To)"::Unit);
//                 if EmployeeServiceHistory.FindFirst then begin
//                     EmployeeActivity."Unit (To)" := EmployeeServiceHistory."Deputation Code (To)";
//                     EmployeeActivity.Modify;
//                 end;
//             until EmployeeActivity.Next = 0;
//     end;

//     local procedure UpdateLeaveDate()
//     var
//         EmployeeActivity: Record "Employee Activity";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetRange("No.", 'LEAVE_77_78-004346');
//         EmployeeActivity.SetRange("Leave Code", 'WEDDING');
//         if EmployeeActivity.FindFirst then begin
//             EmployeeActivity."Start Date" := 20201028D;
//             EmployeeActivity."End Date" := 20201030D;
//             EmployeeActivity."No. of Days" := 3;
//             EmployeeActivity.Modify;
//         end;
//     end;

//     local procedure UpdateAllowanceAssignmentLine()
//     var
//         AllowAssignLine: Record "Allowance Assignment Line";
//     begin
//         AllowAssignLine.Reset;
//         AllowAssignLine.SetFilter("From Date", '%1..%2', 20220301D, 20220306D); //11/1/2020
//         AllowAssignLine.SetRange("Approval Status", AllowAssignLine."Approval Status"::Screened);
//         if AllowAssignLine.FindFirst then
//             repeat
//                 AllowAssignLine."Approval Status" := AllowAssignLine."Approval Status"::"Pending Approval";
//                 AllowAssignLine.Modify;
//             until AllowAssignLine.Next = 0;
//     end;

//     local procedure UpdateEmpAttendanceActivityDescription()
//     var
//         EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
//     begin
//         EmployeeAttendanceActivity.Reset;
//         EmployeeAttendanceActivity.SetRange("Source No.", 'LEAVE_78_79-023392');
//         EmployeeAttendanceActivity.SetFilter("Attendance Date", '%1..%2', 20220214D, 20220216D);
//         if EmployeeAttendanceActivity.FindFirst then
//             repeat
//                 EmployeeAttendanceActivity."Leave Description" := 'WEDDING';
//                 EmployeeAttendanceActivity.Modify;
//             until EmployeeAttendanceActivity.Next = 0;
//     end;

//     local procedure UpdateServiceHistory()
//     var
//         EmpServiceHistory: Record "Employee Service History";
//     begin
//         EmpServiceHistory.Reset;
//         EmpServiceHistory.SetFilter("Service History Code", 'SERVICEHIST_00026484');
//         if EmpServiceHistory.FindFirst then begin
//             EmpServiceHistory.Get('SERVICEHIST_00026484');
//             EmpServiceHistory.Rename('SERVICEHIST_00026848');
//             EmpServiceHistory.Modify;
//         end;
//     end;

//     local procedure LeaveTypeCorr()
//     var
//         EmpActivity: Record "Employee Activity";
//     begin
//         EmpActivity.Reset;
//         EmpActivity.SetRange("No.", 'LEAVE_77_78-022876');
//         if EmpActivity.FindFirst then begin
//             EmpActivity."Approver Type" := EmpActivity."Approver Type"::Direct;
//             EmpActivity.Modify;
//         end;
//     end;

//     local procedure UpdateEmployeeLoan()
//     var
//         EmployeeLoan: Record "Employee Loan/Advance";
//     begin
//         EmployeeLoan.Reset;
//         EmployeeLoan.SetRange("No.", 'HOMELOAN_78_79-00869');
//         if EmployeeLoan.FindFirst then begin
//             EmployeeLoan."Previous Loan Amount" := 8500000;
//             EmployeeLoan.Modify;
//         end;
//     end;

//     local procedure UpdatePayrollMonth()
//     var
//         PayrollHeader: Record "Payroll Header";
//     begin
//         PayrollHeader.Reset;
//         PayrollHeader.SetRange("No.", 'SETTLE_78_79_00078');
//         if PayrollHeader.FindFirst then begin
//             PayrollHeader."Pay Cycle Period" := 9;
//             PayrollHeader.Modify;
//         end;
//     end;

//     local procedure UpdateConfirmationDate()
//     var
//         EmpRec: Record Employee;
//         EmployeeServiceHistory: Record "Employee Service History";
//     begin
//         EmpRec.Reset;
//         EmpRec.SetRange("No.", 'MY5914');
//         if EmpRec.FindFirst then begin
//             EmpRec."Confirmation Date" := 20221117D; // 11/17/2022 -- 111722D //0D
//             EmpRec.Modify;
//         end;
//         /*EmployeeServiceHistory.RESET;
//         EmployeeServiceHistory.SETRANGE("Service Event",EmployeeServiceHistory."Service Event"::Confirmation);
//         IF EmployeeServiceHistory.FINDFIRST THEN REPEAT
//           IF EmpRec.GET(EmployeeServiceHistory."Employee No.") THEN BEGIN
//             EmpRec."Confirmation Date" := EmployeeServiceHistory."Effective Date";
//             EmpRec.MODIFY;
//             END;
//           UNTIL EmployeeServiceHistory.NEXT = 0;*/
//         /*EmpRec.RESET;
//         EmpRec.SETRANGE("Employment Type",EmpRec."Employment Type"::Contract);
//         IF EmpRec.FINDFIRST THEN REPEAT
//           EmpRec."Confirmation Date" := 0D;
//           EmpRec.MODIFY;
//          UNTIL EmpRec.NEXT = 0;*/

//     end;

//     local procedure UpdateLeaveRequest()
//     var
//         EmployeeActivity: Record "Employee Activity";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetRange("No.", 'LEAVE_79_80-000339');
//         EmployeeActivity.SetRange(Type, EmployeeActivity.Type::"Leave Request");
//         if EmployeeActivity.FindFirst then begin
//             //EmployeeActivity."Employee Work Shift" := 'Day';
//             //EmployeeActivity."Employee No." := 'AK6514';
//             //EmployeeActivity."Fiscal Year" := '2078/2079';
//             EmployeeActivity."Employee Name" := 'Chudamani Karki';
//             //EmployeeActivity."Approver Type" := EmployeeActivity."Approver Type"::Direct;
//             EmployeeActivity.Modify;
//         end;
//     end;

//     local procedure KRASubformCheckReviewUpdate()
//     var
//         KRASubformList: Record "KRA Subform List";
//         Appraisal: Record Appraisal;
//     begin
//         Appraisal.Reset;
//         //Appraisal.SETRANGE(Status,Appraisal.Status::"Check Reviewed");
//         //Appraisal.SETRANGE(Posted,FALSE);
//         //Appraisal.SETRANGE("Appraisal Code",'APPRAI_78-79_0005139');
//         Appraisal.SetRange("Confirmation Eligible", true);
//         //Appraisal.SETRANGE("Employee Code",'KM5710');
//         if Appraisal.FindFirst then
//             repeat
//                 KRASubformList.Reset;
//                 KRASubformList.SetRange("Appraisal Code", Appraisal."Appraisal Code");
//                 if KRASubformList.FindFirst then
//                     repeat
//                         KRASubformList."Reviewers Final Score" := KRASubformList."Reviewers Score" * (KRASubformList."Weightage (%)" / 100);
//                         KRASubformList.Modify;
//                     until KRASubformList.Next = 0;
//             until Appraisal.Next = 0;
//     end;

//     local procedure KRASubformCheckReview()
//     var
//         KRASubformList: Record "KRA Subform List";
//         Appraisal: Record Appraisal;
//     begin
//         Appraisal.Reset;
//         Appraisal.SetRange("Confirmation Eligible", true);
//         if Appraisal.FindFirst then
//             repeat
//                 KRASubformList.Reset;
//                 KRASubformList.SetRange("Appraisal Code", Appraisal."Appraisal Code");
//                 if KRASubformList.FindFirst then
//                     repeat
//                         //KRASubformList."Reviewers Score" := KRASubformList.Score - 10;
//                         KRASubformList."Check Reviewers Score" := KRASubformList."Reviewers Score" - 10;
//                         KRASubformList.Modify;
//                     until KRASubformList.Next = 0;
//             until Appraisal.Next = 0;
//     end;

//     local procedure ConfirmationEligibleUpdate()
//     var
//         AppraisalRec: Record Appraisal;
//     begin
//         AppraisalRec.Reset;
//         //AppraisalRec.SETRANGE("Confirmation Eligible",TRUE);
//         AppraisalRec.SetRange("Appraisal Type", AppraisalRec."Appraisal Type"::Confirmation);
//         //AppraisalRec.SETRANGE(Posted,FALSE);
//         if AppraisalRec.FindFirst then
//             repeat
//                 //AppraisalRec."Confirmation Eligible" := FALSE;
//                 AppraisalRec.Modify;
//             until AppraisalRec.Next = 0;
//     end;

//     local procedure UpdateEmployeeRFActual()
//     var
//         EmployeeVar: Record Employee;
//     begin
//         EmployeeVar.Reset;
//         EmployeeVar.SetFilter("Lumpsum RF (Not Actual)", '>%1', 0);
//         if EmployeeVar.FindFirst then
//             repeat
//                 EmployeeVar."Lumpsum RF (Not Actual)" := 0;
//                 EmployeeVar.Modify;
//             until EmployeeVar.Next = 0;
//     end;

//     local procedure UpdatepayrollLineSelected()
//     var
//         PayrollLineRec: Record "Payroll Line";
//     begin
//         PayrollLineRec.Reset;
//         PayrollLineRec.SetRange(Selected, true);
//         if PayrollLineRec.FindFirst then
//             repeat
//                 PayrollLineRec.Selected := false;
//                 PayrollLineRec.Modify;
//             until PayrollLineRec.Next = 0;
//     end;

//     local procedure UpdateFoodingAllowance()
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetRange("No.", 'TRACLAIM_78_79-01362');
//         if EmployeeActivity.FindFirst then begin
//             EmployeeActivity."Fooding Allowance" := 7700;
//             EmployeeActivity.Modify;
//         end;
//     end;

//     local procedure UpdateCandidate()
//     var
//         CandidateRec: Record Candidate;
//     begin
//         CandidateRec.Reset;
//         CandidateRec.SetRange("Vacancy Code", 'VACANCY_79_80_0001');
//         if CandidateRec.FindFirst then
//             repeat
//                 CandidateRec.Status := CandidateRec.Status::"Interview Scheduled";
//                 CandidateRec.Modify;
//             until CandidateRec.Next = 0;
//     end;

//     local procedure UpdatePrevLoan()
//     var
//         EmpLoan: Record "Employee Loan/Advance";
//     begin
//         EmpLoan.Reset;
//         EmpLoan.SetRange("No.", 'HOMELOAN_78_79-01784');
//         if EmpLoan.FindFirst then begin
//             EmpLoan."Previous Loan Amount" := 0;
//             EmpLoan.Modify;
//         end;
//     end;

//     local procedure UpdateInterviewBy()
//     var
//         EvaluationEntry: Record "Evaluation Entry";
//         CandidateRec: Record Candidate;
//     begin
//         CandidateRec.Reset; //Min -- for update "Interview By" in candidate list
//         CandidateRec.SetFilter("Vacancy Code", 'VACANCY_79_80_0001');
//         CandidateRec.SetFilter(Status, '%1|%2', CandidateRec.Status::"Interview Scheduled", CandidateRec.Status::Interviewed);
//         if CandidateRec.Find('-') then
//             repeat
//                 CandidateRec."Interview By" := '';
//                 EvaluationEntry.Reset;
//                 EvaluationEntry.SetRange("Attribute Code", 'APTITUDE');
//                 EvaluationEntry.SetRange("Vacancy Code", CandidateRec."Vacancy Code");
//                 EvaluationEntry.SetRange("No.", CandidateRec."No.");
//                 EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
//                 EvaluationEntry.SetFilter(Marks, '>0');
//                 if EvaluationEntry.Find('-') then
//                     repeat
//                         if CandidateRec."Interview By" = '' then
//                             CandidateRec."Interview By" := EvaluationEntry."Interviewer Code"
//                         else
//                             CandidateRec."Interview By" += '|' + EvaluationEntry."Interviewer Code";
//                     until EvaluationEntry.Next = 0;
//                 CandidateRec.Modify;
//             until CandidateRec.Next = 0;
//     end;

//     local procedure UpdateApproverSalaryAdv()
//     var
//         SalaryAdvance: Record "Employee Loan/Advance";
//     begin
//         SalaryAdvance.Reset;
//         SalaryAdvance.SetRange("No.", 'SALADV_79_80-00045');
//         if SalaryAdvance.FindFirst then begin
//             SalaryAdvance.Approver := 'PS0692';
//             SalaryAdvance."Approver Name" := 'Prakash Shrestha';
//             SalaryAdvance.Modify;
//         end;
//     end;

//     local procedure UpdateTrainingApprovalStatus()
//     var
//         TrainingHeader: Record "Training Header";
//     begin
//         TrainingHeader.Reset;
//         TrainingHeader.SetFilter("No.", 'TRAIN_78_79-00004');
//         if TrainingHeader.FindFirst then begin
//             TrainingHeader."Approval Status" := TrainingHeader."Approval Status"::Released;
//             TrainingHeader.Modify;
//         end;
//     end;

//     local procedure HideAppraisal()
//     var
//         AppraisalRec: Record Appraisal;
//     begin
//         AppraisalRec.Reset;
//         AppraisalRec.SetRange("Requested Date", 20210803D, 20220716D);
//         AppraisalRec.SetFilter("Appraisal Type", '<>%1', AppraisalRec."Appraisal Type"::Confirmation);
//         if AppraisalRec.FindFirst then
//             repeat
//                 AppraisalRec.Hide := true;
//                 AppraisalRec.Modify;
//             until AppraisalRec.Next = 0;
//     end;

//     local procedure KRASubformCheckReviewUpdateFirst()
//     var
//         KRASubformList: Record "KRA Subform List";
//         Appraisal: Record Appraisal;
//     begin
//         Appraisal.Reset;
//         //Appraisal.SETRANGE("Confirmation Eligible",TRUE);
//         Appraisal.SetRange("Appraisal Code", 'APPRAI_78-79_0005150');
//         /*Appraisal.SETRANGE("Requested Date",071722D,082122D);
//         Appraisal.SETRANGE(Status,Appraisal.Status::"Check Reviewed");
//         Appraisal.SETRANGE(Posted,FALSE);
//         Appraisal.SETRANGE(Hide,FALSE);
//         Appraisal.CALCFIELDS("Total Check Reviewers Score");
//         Appraisal.SETRANGE("Total Check Reviewers Score",0);*/
//         if Appraisal.FindFirst then
//             repeat
//                 KRASubformList.Reset;
//                 KRASubformList.SetRange("Appraisal Code", Appraisal."Appraisal Code");
//                 if KRASubformList.FindFirst then
//                     repeat
//                         KRASubformList."Check Reviewers Final Score" := KRASubformList."Check Reviewers Score" * (KRASubformList."Weightage (%)" / 100);
//                         KRASubformList.Modify;
//                     until KRASubformList.Next = 0;
//             until Appraisal.Next = 0;

//     end;

//     local procedure KRASubformFinalReviewersUpdateSecond()
//     var
//         KRASubformList: Record "KRA Subform List";
//         Appraisal: Record Appraisal;
//     begin
//         Appraisal.Reset;
//         Appraisal.SetRange("Appraisal Code", 'APPRAI_78-79_0005150');
//         /*Appraisal.SETRANGE(Posted,FALSE);
//         Appraisal.SETRANGE(Hide,FALSE);
//         Appraisal.SETRANGE("Requested Date",071722D,082122D);
//         Appraisal.SETRANGE("Appraisal Type",Appraisal."Appraisal Type"::Annually);
//         Appraisal.SETRANGE(Status,Appraisal.Status::"Check Reviewed");*/
//         if Appraisal.FindFirst then
//             repeat
//                 KRASubformList.Reset;
//                 KRASubformList.SetRange("Appraisal Code", Appraisal."Appraisal Code");
//                 if KRASubformList.FindFirst then
//                     repeat
//                         KRASubformList."Reviewers Final Score" := KRASubformList."Reviewers Score" * (KRASubformList."Weightage (%)" / 100);
//                         KRASubformList.Modify;
//                     until KRASubformList.Next = 0;
//             until Appraisal.Next = 0;

//     end;

//     local procedure UpdateContactExpiryDateTest()
//     var
//         EmpRec: Record Employee;
//     begin
//         EmpRec.Reset;
//         EmpRec.SetRange("No.", 'BS16575');
//         if EmpRec.FindFirst then begin
//             EmpRec."Contract Expiry Date" := 20230309D;
//             EmpRec.Modify;
//         end;
//     end;

//     local procedure UpdateEcoSystem()
//     var
//         EmployeeList: Record Employee;
//         DeptRec: Record Department;
//     begin
//         EmployeeList.Reset;
//         EmployeeList.SetRange(Status, EmployeeList.Status::Retired);
//         EmployeeList.SetFilter("Department Code", '<>%1', '');
//         if EmployeeList.FindFirst then
//             repeat
//                 if DeptRec.Get(EmployeeList."Department Code") then
//                     EmployeeList."Eco-System" := DeptRec."Eco-System";
//                 EmployeeList.Modify;
//             until EmployeeList.Next = 0;
//     end;

//     local procedure UpdateEcoSystemBlank()
//     var
//         EmployeeList: Record Employee;
//         DeptRec: Record Department;
//     begin
//         EmployeeList.Reset;
//         EmployeeList.SetRange(Status, EmployeeList.Status::Retired);
//         EmployeeList.SetRange("Department Code", '');
//         if EmployeeList.FindFirst then
//             repeat
//                 EmployeeList."Eco-System" := '';
//                 EmployeeList.Modify;
//             until EmployeeList.Next = 0;
//     end;

//     local procedure TravelClaimCorr()
//     var
//         EmpActivity: Record "Employee Activity";
//     begin
//         EmpActivity.Reset;
//         EmpActivity.SetRange("No.", 'TRACLAIM_79_80-00346');
//         if EmpActivity.FindFirst then begin
//             EmpActivity."Lodging Allowance" := 30000;
//             EmpActivity.Modify;
//         end;
//     end;

//     local procedure UpdateLeaveDays()
//     var
//         EmployeeActivity: Record "Employee Activity";
//     begin
//         EmployeeActivity.Reset;
//         EmployeeActivity.SetRange("No.", 'LEAVE_79_80-012972');
//         if EmployeeActivity.FindFirst then begin
//             EmployeeActivity."No. of Days" := 3;
//             EmployeeActivity.Modify;
//         end;
//     end;

//     local procedure UpdateTravelOrderNo()
//     var
//         EmpActVar: Record "Employee Activity";
//     begin
//         EmpActVar.Reset;
//         EmpActVar.SetRange("No.", 'TRAREQ_79_80-00929');
//         if EmpActVar.FindFirst then begin
//             EmpActVar."Travel Order No." := '';
//             EmpActVar.Modify;
//         end;
//     end;

//     local procedure UpdateCloseLeaveEarn()
//     var
//         LeaveEarn: Record "Leave Earn";
//     begin
//         LeaveEarn.Reset;
//         LeaveEarn.SetRange("Leave Code", 'COMPENSATORY');
//         LeaveEarn.SetRange(Type, LeaveEarn.Type::Used);
//         LeaveEarn.SetRange(Closed, false);
//         if LeaveEarn.FindFirst then
//             repeat
//                 LeaveEarn.Closed := true;
//                 LeaveEarn.Modify;
//             until LeaveEarn.Next = 0;
//     end;

//     local procedure UpdatedOTDisbursed()
//     var
//         EmployeeActRec: Record "Employee Activity";
//     begin
//         EmployeeActRec.Reset;
//         EmployeeActRec.SetRange(Type, EmployeeActRec.Type::Overtime);
//         EmployeeActRec.SetRange("Approval Status", EmployeeActRec."Approval Status"::Approved);
//         EmployeeActRec.SetRange("Updated Payroll Line", true);
//         if EmployeeActRec.FindFirst then
//             repeat
//                 EmployeeActRec."OT Disbursed" := true;
//                 EmployeeActRec.Modify;
//             until EmployeeActRec.Next = 0;
//     end;

//     local procedure UpdateWeekEmpAttendanceActivity()
//     var
//         EngNep: Record "English-Nepali Date";
//         EmpAttenActivity: Record "Employee Attendance & Activity";
//     begin
//         EmpAttenActivity.Reset;
//         EmpAttenActivity.SetRange("Attendance Date", 20220717D, 20230124D);
//         if EmpAttenActivity.FindSet then
//             repeat
//                 EngNep.Reset;
//                 EngNep.SetRange("English Date", EmpAttenActivity."Attendance Date");
//                 if EngNep.FindFirst then
//                     EmpAttenActivity.Week := EngNep.Week;
//                 EmpAttenActivity.Modify;
//             until EmpAttenActivity.Next = 0;
//     end;

//     local procedure ValidateEmployeeFunctionalTitle()
//     var
//         Depart: Record Department;
//         EmpHie: Record "Employee Hierarchy Master";
//         Province: Record Province;
//         Subprovince: Record "Sub Province";
//     begin
//         EMployee.Reset;
//         EMployee.SetRange(Status, EMployee.Status::Active);
//         if EMployee.FindFirst then
//             repeat
//                 EMployee.Validate("Functional Title");
//                 EMployee.Modify;
//             until EMployee.Next = 0;
//     end;
// }
