codeunit 50023 EmployeeActivityMgt
{
    procedure SendForApproval(DocumentNo: Code[20]; DocumentType: Enum "Employee Activity Type")
    var
        EmpActJnl1: Record "Employee Activity Journal";
    begin
        EmpActJnl1.Reset();
        EmpActJnl1.SetRange("Emp Act. No", DocumentNo);
        EmpActJnl1.SetRange("Employee Act Type", DocumentType);
        EmpActJnl1.SetRange("Approval Status", EmpActJnl1."Approval Status"::Open);
        if EmpActJnl1.FindSet() then begin
            repeat
                case DocumentType of
                    //for leave
                    DocumentType::"Leave Request":
                        begin
                            CheckLeaveDetails(EmpActJnl1);
                        end;
                    // For HR Transfer
                    DocumentType::"HR Transfer":
                        begin
                            ConfirmTransferJournalDetails(EmpActJnl1);
                        end;
                    DocumentType::"Attendance Missed":
                        begin
                            ConfirmAttendanceJournalDetails(EmpActJnl1);
                        end;
                    DocumentType::Promotion:
                        begin
                            CheckPromotionDetails(EmpActJnl1);
                        end;
                end;
                EmpActJnl1.Validate("Approval Status", EmpActJnl1."Approval Status"::Pending);
                EmpActJnl1.Modify();
            until EmpActJnl1.Next() = 0;
            ApproverMgt.UpdateFirstApproverStatus(DocumentNo);
        end else
            Error('Record not found in Status Open');
    end;

    procedure ConfirmTransferJournalDetails(EmployeeACTJnl: Record "Employee Activity Journal")
    var
        EmphrTransfer: Record "Employee Transfer";
        TransferType: Enum "Transfer Type";
    begin
        if not (EmployeeACTJnl."Transfer Type" in [TransferType::"Intra Branch", TransferType::"Intra Department", TransferType::"Intra Provincial"]) then begin
            EmployeeACTJnl.TestField("Incoming Supervisor");
            EmployeeACTJnl.TestField("Outgoing Branch Rep. Person");
        end;
        EmployeeACTJnl.TestField("Employee No.");
        EmployeeACTJnl.TestField("Transfer Type");
        EmployeeACTJnl.TestField("Transfer Category");
        EmployeeACTJnl.TestField("Deputation On (To)");
        EmployeeACTJnl.TestField("Transfer Effective Date");
        EmployeeACTJnl.TestField("Approver Role (TO)");
        case EmployeeACTJnl."Deputation On (To)" of
            EmployeeACTJnl."Deputation On (To)"::Branch:
                EmployeeACTJnl.TestField("To Branch");
            EmployeeACTJnl."Deputation On (To)"::Department:
                EmployeeACTJnl.TestField("Department Code (To)");
            EmployeeACTJnl."Deputation On (To)"::"Extension Counter":
                EmployeeACTJnl.TestField("Extension Counter (To)");
            EmployeeACTJnl."Deputation On (To)"::Province:
                EmployeeACTJnl.TestField("Province Code (To)");
            EmployeeACTJnl."Deputation On (To)"::Unit:
                EmployeeACTJnl.TestField("Unit (To)");
        end;
        EmphrTransfer.Reset();
        EmphrTransfer.SetRange("Employee No.", EmployeeACTJnl."Employee No.");
        EmphrTransfer.SetFilter(Type, '%1|%2', EmphrTransfer.Type::"HR Transfer", EmphrTransfer.Type::"Employee Transfer");
        EmphrTransfer.SetFilter("Approval Status", '%1|%2|%3', EmphrTransfer."Approval Status"::Pending, EmphrTransfer."Approval Status"::Approved, EmphrTransfer."Approval Status"::"On Hold");
        if EmphrTransfer.FindFirst() then
            Error('%1 of employee %2 is still open or pending. Please verify Transfer Document %3', EmphrTransfer.Type, EmphrTransfer."Employee Name", EmphrTransfer."No.");
    end;

    procedure ConfirmAttendanceJournalDetails(EmployeeACTJnl: Record "Employee Activity Journal")
    var
        AttendanceMgn: Codeunit "AttendanceMiss Mgt";
    begin
        if EmployeeACTJnl."Start Date" > Today then
            Error('Attendance missed date cannot be future date');
        // AttendanceMgn.CheckAlreadyExists(EmployeeACTJnl."Employee No.", EmployeeACTJnl.Type, EmployeeACTJnl."Start Date");
        AttendanceMgn.CheckForLeaveDay(EmployeeACTJnl);
        EmployeeACTJnl.TestField("Employee No.");
        EmployeeACTJnl.TestField("Start Date");

        if (EmployeeACTJnl."CheckIn Time" = 0T) and (EmployeeACTJnl."CheckOut Time" = 0T) then
            Error('Check In or check Out fields must have a Value');
    end;

    procedure PostTransferInBulk(EmpActNo: Code[20])
    var
        TransferRequest: Record "Employee Transfer";
        PostedEmployeeTransfer: Record "Posted Employee Journal";
        TransferEmployeeJournal: Record "Employee Activity Journal";
        HrSetup: Record "Human Resources Setup";
        AttachmentSetup: Record "Attachment Setup";
    begin
        HrSetup.Get();
        TransferEmployeeJournal.Reset();
        TransferEmployeeJournal.SetRange("Emp Act. No", EmpActNo);
        if not HrSetup."Skip Approval On HR Transfer" then  //to allow Transfer Journal Post without Approval
            TransferEmployeeJournal.setrange("Approval Status", TransferEmployeeJournal."Approval Status"::Approved);
        if TransferEmployeeJournal.FindSet() then
            repeat

                //check for mandatory attachment
                AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Transfer");
                AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Transfer Letter");
                AttachmentSetup.SetRange(Mandatory, true);
                if AttachmentSetup.FindFirst() then
                    if not TransferEmployeeJournal.Attachment.HasValue then
                        Error('Please attach the mandatory document in Transfer Journal No %1 and line no %2 before posting', TransferEmployeeJournal."Emp Act. No", TransferEmployeeJournal."Line No");

                TransferRequest.Init();
                TransferRequest.Validate("No.", '');
                TransferRequest.Validate("Employee No.", TransferEmployeeJournal."Employee No.");
                TransferRequest.Validate("Deputation On (To)", TransferEmployeeJournal."Deputation On (To)");
                TransferRequest.Validate("Department Code (To)", TransferEmployeeJournal."Department Code (To)");
                TransferRequest.Validate("Province Code (To)", TransferEmployeeJournal."Province Code (To)");
                TransferRequest.Validate("To Branch", TransferEmployeeJournal."To Branch");
                TransferRequest.Validate("Department Code (To)", TransferEmployeeJournal."Department Code (To)");
                TransferRequest.Validate("Extension Counter (To)", TransferEmployeeJournal."Extension Counter (To)");
                TransferRequest.Validate("Unit (To)", TransferEmployeeJournal."Unit (To)");
                TransferRequest.Validate("Functional Title (To)", TransferEmployeeJournal."Functional Title (To)");
                TransferRequest.Validate("Transfer Category", TransferEmployeeJournal."Transfer Category");
                TransferRequest.Validate("Transfer Type", TransferEmployeeJournal."Transfer Type");
                TransferRequest.Validate("Transfer Effective Date", TransferEmployeeJournal."Transfer Effective Date");
                TransferRequest.Validate("Incoming Supervisior", TransferEmployeeJournal."Incoming Supervisor");
                TransferRequest.Validate("Incoming Supervisior 2", TransferEmployeeJournal."Incoming Supervisor 2");
                TransferRequest.Validate("Outgoing Branch Rep. Person", TransferEmployeeJournal."Outgoing Branch Rep. Person");
                TransferRequest.Validate("Outgoing Branch Rep. Person 2", TransferEmployeeJournal."Outgoing Branch Rep. Person 2");
                TransferRequest.Validate("Notify to", TransferEmployeeJournal."Notify to");
                TransferRequest.Validate("Approver Role To", TransferEmployeeJournal."Approver Role (TO)");
                TransferRequest.Validate(Remarks, TransferEmployeeJournal.Remarks);
                TransferRequest.Validate("Approval Status", TransferRequest."Approval Status"::Approved);
                TransferRequest.Validate("Is Transfer Details Added", true);
                TransferRequest.Validate("Approved Date", Today);
                TransferRequest.Validate("On Employee Request", TransferEmployeeJournal."On Employee Request");
                TransferRequest.Validate(Type, TransferRequest.Type::"HR Transfer");
                TransferRequest.Insert(true);

                //Handle the attachment transfer from Employee Activity Journal to Posted Employee Journal
                if TransferEmployeeJournal.Attachment.HasValue then
                    InsertTransferLetterAttachment(TransferEmployeeJournal, TransferRequest);

                PostedEmployeeTransfer.Init();
                PostedEmployeeTransfer.TransferFields(TransferEmployeeJournal);
                PostedEmployeeTransfer.Validate(Posted, true);
                PostedEmployeeTransfer.Validate("Document No", TransferRequest."No.");
                PostedEmployeeTransfer.Insert(true);
                OnAfterTransferJournalPost(PostedEmployeeTransfer, TransferRequest);
                TransferEmployeeJournal.Delete();
            until TransferEmployeeJournal.next() = 0
        else
            Error('There is no Document to post');
    end;

    procedure PostLeaveJournal(EmpActNo: Code[20])
    var
        LeaveRequest: Record Leave;
        leaveJournal: Record "Employee Activity Journal";
        PostedLeaveJournal: Record "Posted Employee Journal";
        LeaveMgt: Codeunit "Leave Mgt.";
    begin
        leaveJournal.Reset();
        leaveJournal.SetRange("Emp Act. No", EmpActNo);
        leaveJournal.setrange("Approval Status", leaveJournal."Approval Status"::Approved);
        if leaveJournal.FindSet() then
            repeat
                if leaveJournal."Adjustment Type" = leaveJournal."Adjustment Type"::Used then begin
                    LeaveMgt.CheckPendingLeave('', leaveJournal."Leave Code", leaveJournal."Employee No.");
                    LeaveMgt.CheckRemainingLeaveDays(leaveJournal."Leave Code", leaveJournal."Employee No.", leaveJournal."No. of Days");
                    LeaveMgt.CheckForEmployeeLimit(leaveJournal."Leave Code", leaveJournal."Employee No.");
                    LeaveRequest.Reset();
                    LeaveRequest.Init();
                    LeaveRequest.Validate("No.", '');
                    LeaveRequest.Validate("Employee No.", leaveJournal."Employee No.");
                    LeaveRequest.Validate("Leave Code", leaveJournal."Leave Code");
                    LeaveRequest.Validate(Type, LeaveRequest.Type::"Leave Request");
                    LeaveRequest.Validate("Leave Description", leaveJournal."Leave Description");
                    LeaveRequest.Validate("Leave Type", leaveJournal."Leave Type");
                    LeaveRequest.Validate("Start Date", leaveJournal."Start Date");
                    LeaveRequest.Validate("End Date", leaveJournal."End Date");
                    LeaveRequest.Validate(Remarks, leaveJournal.Remarks);
                    LeaveRequest.Validate("Approval Status", LeaveRequest."Approval Status"::Approved);
                    LeaveRequest.Validate("Approved Date", Today);
                    LeaveRequest.Validate("Requested Date", leaveJournal."Requested Date");
                    LeaveRequest.Validate("Form Journal", true);
                    OnBeforeLeaveRequestInsert(LeaveRequest, leaveJournal);
                    LeaveRequest.Insert(true);
                    if leaveJournal.Attachment.HasValue then
                        InsertAttachmentforLeave(LeaveRequest, leaveJournal);
                end else if leaveJournal."Adjustment Type" = leaveJournal."Adjustment Type"::Adjustment then
                        LeaveMgt.InsertLeaveEarnfromJournal(leaveJournal);
                PostedLeaveJournal.Init();
                PostedLeaveJournal.TransferFields(leaveJournal);
                PostedLeaveJournal.Validate(Posted, true);
                PostedLeaveJournal.Validate("Document No", LeaveRequest."No.");
                PostedLeaveJournal.Insert(true);
                if leaveJournal."Adjustment Type" = leaveJournal."Adjustment Type"::Used then begin
                    LeaveMgt.LeaveApproved(LeaveRequest."No.");
                end;
                leaveJournal.Delete();
            until leaveJournal.next() = 0
        else
            Error('There is no Document to post');
    end;

    procedure PostAttendanceJournal(EmpActNo: Code[20])
    var
        AttendanceMissed: Record "Attendance Missed";
        AttendanceMissedJournal: Record "Employee Activity Journal";
        PostedAttendanceJournal: Record "Posted Employee Journal";
        AttendanceMgn: Codeunit "AttendanceMiss Mgt";
    begin
        AttendanceMissedJournal.Reset();
        AttendanceMissedJournal.SetRange("Emp Act. No", EmpActNo);
        AttendanceMissedJournal.setrange("Approval Status", AttendanceMissedJournal."Approval Status"::Approved);
        if AttendanceMissedJournal.FindSet() then
            repeat
                AttendanceMissed.Reset();
                AttendanceMissed.Init();
                AttendanceMissed.Validate("No.", '');
                AttendanceMissed.Validate("Employee No.", AttendanceMissedJournal."Employee No.");
                AttendanceMissed.Validate(Type, AttendanceMissed.Type::"Attendance Missed");
                AttendanceMissed.Validate("From Journal", true);
                AttendanceMissed.Validate("Start Date", AttendanceMissedJournal."Start Date");
                AttendanceMissed.Validate("Check In Time", AttendanceMissedJournal."CheckIn Time");
                AttendanceMissed.Validate("Check Out Time", AttendanceMissedJournal."CheckOut Time");
                AttendanceMissed.Validate(Remarks, AttendanceMissedJournal.Remarks);
                AttendanceMissed.Validate("Approval Status", AttendanceMissedJournal."Approval Status"::Approved);
                AttendanceMissed.Validate("Approved Date", Today);
                AttendanceMissed.Validate("Checkout OverNight", AttendanceMissedJournal."CheckOut OverNight");
                AttendanceMissed.Validate("Employee Work Shift", AttendanceMissedJournal."Employee Work Shift");
                OnBeforePostAttendanceJournal(AttendanceMissed, AttendanceMissedJournal);
                AttendanceMissed.Insert(true);
                PostedAttendanceJournal.Init();
                PostedAttendanceJournal.TransferFields(AttendanceMissedJournal);
                PostedAttendanceJournal.Validate("Document No", AttendanceMissed."No.");
                AttendanceMgn.AttendanceMissedApproved(AttendanceMissed."No.");

                PostedAttendanceJournal.Validate(Posted, true);
                PostedAttendanceJournal.Insert(true);
                AttendanceMissedJournal.Delete();
            until AttendanceMissedJournal.next() = 0
        else
            Error('There is no Document to post');
    end;

    procedure PostLateDeductionJournal(EmpActNo: Code[20])
    var
        LateDeductionJournal: Record "Employee Activity Journal";
        PostedAttendanceJournal: Record "Posted Employee Journal";
    begin
        LateDeductionJournal.Reset();
        LateDeductionJournal.SetRange("Emp Act. No", EmpActNo);
        LateDeductionJournal.setrange("Approval Status", LateDeductionJournal."Approval Status"::Approved);
        if LateDeductionJournal.FindSet() then
            repeat
                PostedAttendanceJournal.Init();
                PostedAttendanceJournal.TransferFields(LateDeductionJournal);
                PostedAttendanceJournal.Validate("Document No", LateDeductionJournal."Emp Act. No");
                PostedAttendanceJournal.Validate(Posted, true);
                PostedAttendanceJournal.Insert(true);
                HRMgt.CreateEmpActLedger(PostedAttendanceJournal.Type::"Late Deduction", format(PostedAttendanceJournal."Entry No"), PostedAttendanceJournal."Employee No.", PostedAttendanceJournal."Start Date", false, 1);
                LateDeductionJournal.Delete();
                AttendanceMgt.DailyAttendanceUpdate(PostedAttendanceJournal."Start Date", PostedAttendanceJournal."Start Date", PostedAttendanceJournal."Employee No.");
            until LateDeductionJournal.next() = 0
        else
            Error('There is no Document to post');
    end;

    procedure RejectJournal(var EmployeeActJournal: Record "Employee Activity Journal"; Reject: Boolean)
    var
        StatusMaster: Record "Status Master";
        PostedEmployeeJournal: Record "Posted Employee Journal";
        EmployeeActNo: Code[20];
    begin
        if Reject then begin
            EmployeeActNo := EmployeeActJournal."Emp Act. No";
            EmployeeActJournal.TestField("Approval Status", EmployeeActJournal."Approval Status"::Pending);
            ApproverMgt.CheckApprover(EmployeeActJournal."Emp Act. No");
            EmployeeActJournal.Validate("Approval Status", EmployeeActJournal."Approval Status"::Rejected);
            StatusMaster.Reset();
            StatusMaster.SetRange(Rejected, true);
            if StatusMaster.FindFirst() then begin
                EmployeeActJournal.Validate(Status, StatusMaster.Status);
            end
            else
                Error('Rejected Status not Found On Status Master Setup');
            EmployeeActJournal.Modify();
            PostedEmployeeJournal.Init();
            PostedEmployeeJournal.TransferFields(EmployeeActJournal);
            PostedEmployeeJournal.Validate(Posted, true);
            PostedEmployeeJournal.Insert(true);
            EmployeeActJournal.Delete();
            CheckJournalAndUpdateApproval(EmployeeActNo);
        end;
    end;

    local procedure CheckJournalAndUpdateApproval(EmpJournalNo: Code[20])
    var
        ApprovalHRMS: Record "Approval HRMS";
        EmployeeActJournal: Record "Employee Activity Journal";
    begin
        EmployeeActJournal.Reset();
        EmployeeActJournal.SetRange("Emp Act. No", EmpJournalNo);
        EmployeeActJournal.SetRange("Approval Status", EmployeeActJournal."Approval Status"::Pending);
        if not EmployeeActJournal.FindFirst() then begin
            ApprovalHRMS.Reset();
            ApprovalHRMS.SetRange("Document No.", EmpJournalNo);
            if ApprovalHRMS.FindSet() then
                repeat
                    ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Rejected);
                    ApprovalHRMS.Validate("Rejected By", HRMgt.GetEmpName());
                    ApprovalHRMS.Validate("Rejected By Code", HRMgt.GetEmployeeNo());
                    ApprovalHRMS.Modify();
                until ApprovalHRMS.Next() = 0;
        end;
    end;

    procedure UpdateOvertimeLineInEmployeeAct(OvertimeLine: Record "Overtime Line")
    var
        PostEmployeeActJournal: Record "Posted Employee Journal";
    begin
        PostEmployeeActJournal.Init();
        PostEmployeeActJournal."Emp Act. No" := OvertimeLine."No.";
        PostEmployeeActJournal.Type := OvertimeLine.Type;
        PostEmployeeActJournal."Employee No." := OvertimeLine."Employee Code";
        PostEmployeeActJournal."Employee Name" := OvertimeLine."Employee Name";
        PostEmployeeActJournal."Start Date" := OvertimeLine."Overtime Date";
        PostEmployeeActJournal."End Date" := OvertimeLine."Overtime Date";
        PostEmployeeActJournal."Fiscal Year" := Hrmgt.ReturnFiscalYear(OvertimeLine."Overtime Date");
        PostEmployeeActJournal."Approval Status" := OvertimeLine."Approval Status"::Approved;
        PostEmployeeActJournal."Approved Date" := OvertimeLine."Approved Date";
        PostEmployeeActJournal."Overtime Claim Type" := OvertimeLine."Overtime Claim Type";
        PostEmployeeActJournal."Actual OT Hours" := OvertimeLine."Actual OT Hours";
        PostEmployeeActJournal."OT Amount" := OvertimeLine."OT Amount";
        PostEmployeeActJournal."Morning OT Hours" := OvertimeLine."Morning OT Hours";
        PostEmployeeActJournal."Evening OT Hours" := OvertimeLine."Evening OT Hours";
        PostEmployeeActJournal."Total OT Hours" := OvertimeLine."Total OT Hours";
        PostEmployeeActJournal.Insert(true);
    end;

    procedure UpdateOvertimeInEmployeeAct(Overtime: Record "Overtime")
    var
        PostEmployeeActJournal: Record "Posted Employee Journal";
    begin
        PostEmployeeActJournal.Init();
        PostEmployeeActJournal."Emp Act. No" := Overtime."No.";
        PostEmployeeActJournal.Type := Overtime.Type;
        PostEmployeeActJournal."Employee No." := Overtime."Employee No.";
        PostEmployeeActJournal."Employee Name" := Overtime."Employee Name";
        PostEmployeeActJournal."Start Date" := Overtime."Start Date";
        PostEmployeeActJournal."End Date" := Overtime."End Date";
        PostEmployeeActJournal."Fiscal Year" := Hrmgt.ReturnFiscalYear(Overtime."Start Date");
        PostEmployeeActJournal."Approval Status" := Overtime."Approval Status";
        PostEmployeeActJournal."Approved Date" := Overtime."Approved Date";
        PostEmployeeActJournal."Overtime Claim Type" := Overtime."Overtime Claim Type";
        PostEmployeeActJournal."Actual OT Hours" := Overtime."Actual OT Hours";
        PostEmployeeActJournal."OT Amount" := Overtime."OT Amount";
        PostEmployeeActJournal."Morning OT Hours" := Overtime."Morning OT Hours";
        PostEmployeeActJournal."Evening OT Hours" := Overtime."Evening OT Hours";
        PostEmployeeActJournal."Total OT Hours" := Overtime."Total OT Hours";
        PostEmployeeActJournal.Insert(true);
    end;

    procedure CheckLeaveDetails(EmployeeACTJnl: Record "Employee Activity Journal")
    begin
        EmployeeACTJnl.TestField("Employee No.");
        EmployeeACTJnl.TestField("Leave Code");
        EmployeeACTJnl.TestField("No. of Days");
        if EmployeeACTJnl."Adjustment Type" = EmployeeACTJnl."Adjustment Type"::Used then begin
            EmployeeACTJnl.TestField("Start Date");
            EmployeeACTJnl.TestField("End Date");
            if EmployeeACTJnl."Leave Type" = EmployeeACTJnl."Leave Type"::" " then
                Error('Leave Type cannot be blank in %1 line No %2', EmployeeACTJnl."Emp Act. No", EmployeeACTJnl."Line No");
        end;
    end;

    procedure CheckLeaveInSameDay(EmployeeACTJnl: Record "Employee Activity Journal")
    var
        EmpActJnl: Record "Employee Activity Journal";
    begin
        EmpActJnl.SetRange("Employee Act Type", EmpActJnl."Employee Act Type"::"Leave Request");
        EmpActJnl.SetRange("Employee No.", EmployeeACTJnl."Employee No.");
        EmpActJnl.Setfilter("Approval Status", '<>%1', EmpActJnl."Approval Status"::Rejected);
        EmpActJnl.FilterGroup(-1);
        EmpActJnl.SetRange("Start Date", EmployeeACTJnl."Start Date", EmployeeACTJnl."End Date");
        EmpActJnl.SetRange("End Date", EmployeeACTJnl."Start Date", EmployeeACTJnl."End Date");
        EmpActJnl.FilterGroup(0);
        if EmpActJnl.FindSet() then
            repeat
                if not ((EmpActJnl."Emp Act. No" = EmployeeACTJnl."Emp Act. No") and (EmpActJnl."Line No" = EmployeeACTJnl."Line No")) then
                    Error('Leave has already been Assign between %1 to %2 in %3 and Line No %4', EmployeeACTJnl."Start Date", EmployeeACTJnl."End Date", EmpActJnl."Emp Act. No", EmpActJnl."Line No");
            until EmpActJnl.Next() = 0;
    end;

    procedure CheckAttendanceMissedInJournal(EmpNo: Code[20]; AttendanceDate: Date)
    Var
        EmpActJournal: Record "Employee Activity Journal";
    begin
        EmpActJournal.Reset();
        EmpActJournal.SetRange("Employee No.", EmpNo);
        EmpActJournal.SetRange("Employee Act Type", EmpActJournal."Employee Act Type"::"Attendance Missed");
        EmpActJournal.SetFilter("Approval Status", '<>%1', EmpActJournal."Approval Status"::Rejected);
        EmpActJournal.SetRange("Start Date", AttendanceDate);
        if EmpActJournal.FindFirst then
            Error('Attendance Already Applied for date %1 of %2', AttendanceDate, EmpNo);
    end;

    procedure InsertTransferLetterAttachment(var EmployeeActivityJournal: Record "Employee Activity Journal"; var EmployeeTransfer: Record "Employee Transfer")
    var
        AttachmentSetup: Record "Attachment Setup";
    begin
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Transfer");
        AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Transfer Letter");
        AttachmentSetup.FindFirst();

        InsertAttachment(EmployeeActivityJournal,
                        EmployeeTransfer."No.",
                        EmployeeTransfer."Employee No.",
                        EmployeeTransfer.Type,
                        AttachmentSetup."Attachment Code");
    end;

    procedure InsertAttachment(EmpActJnl: Record "Employee Activity Journal"; DocumentNo: Code[20]; EmpNo: Code[20]; EmpActType: Enum "Employee Activity Type"; AttachmentsetupCode: Code[20])
    var

        IncDocument, IncDocument2 : Record "Incoming Document";
        IncomingDocAttachment: Record "Incoming Document Attachment";
        TenantMedia: Record "Tenant Media";
        InStream: InStream;
        OutStream: OutStream;
        FileManagement: Codeunit "File Management";
        FileName: Text;
        FileExtension: Text;
    begin
        if EmpActJnl.Attachment.HasValue then begin
            IncDocument2.SetRange("No.", DocumentNo);
            IncDocument2.SetRange("Employee Code", EmpNo);
            IncDocument2.SetRange("Attachment Code", AttachmentsetupCode);
            if IncDocument2.FindFirst() then
                IncDocument := IncDocument2
            else begin
                IncDocument.Init();
                IncDocument."No." := DocumentNo;
                IncDocument."Document No." := DocumentNo;
                IncDocument."Table ID" := Database::"Employee Activity Journal";
                IncDocument."Employee Activity Type" := EmpActType;
                IncDocument."Employee Code" := EmpNo;
                IncDocument."Attachment Code" := AttachmentsetupCode;
                IncDocument.Insert(true);
            end;

            if TenantMedia.Get(EmpActJnl.Attachment.MediaId) then begin
                TenantMedia.CalcFields(Content);
                TenantMedia.Content.CreateInStream(InStream);

                // Get file name and extension
                if EmpActJnl."Attachment File Name" <> '' then
                    FileName := EmpActJnl."Attachment File Name"
                else
                    FileName := TenantMedia.Description;

                FileExtension := FileManagement.GetExtension(FileName);

                // Create incoming document attachment record
                IncomingDocAttachment.Init();
                IncomingDocAttachment."Incoming Document Entry No." := IncDocument."Entry No.";
                IncomingDocAttachment."Line No." := 10000;
                IncomingDocAttachment.Name := CopyStr(FileName, 1, MaxStrLen(IncomingDocAttachment.Name));
                IncomingDocAttachment."File Extension" := CopyStr(FileExtension, 1, MaxStrLen(IncomingDocAttachment."File Extension"));
                IncomingDocAttachment.Type := IncomingDocAttachment.Type::Image;
                IncomingDocAttachment.Content.CreateOutStream(OutStream);
                CopyStream(OutStream, InStream);
                IncomingDocAttachment.Insert(true);

                // Update Incoming Document with file name
                IncDocument."File Name" := CopyStr(FileName, 1, MaxStrLen(IncDocument."File Name"));
                IncDocument.Modify();
            end;
        end;
    end;

    procedure CheckPromotionDetails(EmployeeACTJnl: Record "Employee Activity Journal")
    begin
        EmployeeACTJnl.TestField("Employee No.");
        EmployeeACTJnl.TestField("Promotion Date");
        EmployeeACTJnl.TestField("Functional Title (To)");
        EmployeeACTJnl.TestField("Promoted Salary level");
        EmployeeACTJnl.TestField("Promoted Salary Grade");
        EmployeeACTJnl.TestField("Approver Role (TO)");
        EmployeeACTJnl.TestField("Promoted Staff Level");
    end;

    procedure PostPromotionJournal(EmpActNo: Code[20])
    var
        Promotion: Record Promotion;
        PostedPromotionJournal: Record "Posted Employee Journal";
        PromotionEmployeeJournal: Record "Employee Activity Journal";
        PromotionMgt: Codeunit "Promotion Mgt";
        ServiceEvent: Enum "Service Event";
        ServiceHistoryCode: Code[20];
    begin
        PromotionEmployeeJournal.Reset();
        PromotionEmployeeJournal.SetRange("Emp Act. No", EmpActNo);
        if PromotionEmployeeJournal.FindSet() then
            repeat
                Promotion.Init();
                Promotion.Validate("No.", '');
                Promotion.Validate("Employee No.", PromotionEmployeeJournal."Employee No.");
                Promotion.Validate("Promoted Functional Title", PromotionEmployeeJournal."Functional Title (To)");
                Promotion.Validate("Promoted Approver Role", PromotionEmployeeJournal."Approver Role (TO)");
                Promotion.Validate("Promoted Salary level", PromotionEmployeeJournal."Promoted Salary level");
                Promotion.Validate("Promoted Salary Grade", PromotionEmployeeJournal."Promoted Salary Grade");
                Promotion.Validate("Promoted Staff Level", PromotionEmployeeJournal."Promoted Staff Level");
                Promotion.Validate("Promotion Date", PromotionEmployeeJournal."Promotion Date");
                Promotion.Validate("Approval Status", PromotionEmployeeJournal."Approval Status"::Approved);
                Promotion.Validate("Approved Date", Today);
                Promotion.Validate("Decision Date", PromotionEmployeeJournal."Decision Date");
                Promotion.Validate(Type, PromotionEmployeeJournal.Type::Promotion);
                Promotion.Insert(true);
                PostedPromotionJournal.Init();
                PostedPromotionJournal.TransferFields(PromotionEmployeeJournal);
                PromotionEmployeeJournal.Delete();
                PostedPromotionJournal.Validate(Posted, true);
                PostedPromotionJournal.Validate("Document No", Promotion."No.");
                PostedPromotionJournal.Insert(true);
                OnAfterPromotionJournalPost(PromotionEmployeeJournal, PostedPromotionJournal, Promotion);
                ServiceHistoryCode := ServiceHistory.AddToServiceHistory(Promotion."No.", ServiceEvent::Promotion, '', PostedPromotionJournal."Promotion Date");
                if PostedPromotionJournal."Promotion Date" <= Today then
                    PromotionMgt.UpdateInEmployeeProfile(ServiceHistoryCode);
            until PromotionEmployeeJournal.next() = 0
        else
            Error('There is no Document to post');
        Message('Employee Promotion is posted')
    end;

    procedure PostLoanInBulk(EmpActNo: Code[20])
    var
        EmployeeLoanRec: Record "Employee Loan/Advance";
        PostedLoanJnl: Record "Posted Employee Journal";
        LoanJournal: Record "Employee Activity Journal";
        HrSetup: Record "Human Resources Setup";
        AttachmentSetup: Record "Attachment Setup";
        NoSeries: Codeunit "No. Series";
    begin
        //note that this procedure assume you are just recording the loan record that is already processed.
        //Thus there wont be validation and what so ever

        HrSetup.Get();
        LoanJournal.Reset();
        LoanJournal.SetRange("Emp Act. No", EmpActNo);
        //add status = approved filter here is approval needed
        if LoanJournal.FindSet() then
            repeat
                //check mandatory fields before posting
                LoanJournal.TestField(Remarks);
                LoanJournal.TestField("Employee No.");
                LoanJournal.TestField("Loan Type");
                LoanJournal.TestField("Loan Account No.");
                LoanJournal.TestField("Loan Disbursed Amount");
                LoanJournal.TestField("Loan Disbursement Date");
                if LoanJournal."Loan Type" = LoanJournal."Loan Type"::"Vehicle Loan" then begin
                    LoanJournal.TestField("Loan Account Opening Date");
                    LoanJournal.TestField("Loan Expiry Date");
                    HrSetup.TestField("Vehicle Loan No.");
                end else if LoanJournal."Loan Type" = LoanJournal."Loan Type"::"Home Loan Insurance Tieup" then begin
                    LoanJournal.TestField("Insurance Company");
                    LoanJournal.TestField("Policy No");
                    LoanJournal.TestField("Yearly Premium Amount");
                    LoanJournal.TestField("First Premium Date");
                    HrSetup.TestField("Home Loan Insur. TieUp No.");
                end;

                //check for mandatory attachment here if needed
                AttachmentSetup.Reset();
                AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Loan Journal");
                AttachmentSetup.SetRange(Mandatory, true);
                if AttachmentSetup.FindFirst() then
                    if not LoanJournal.Attachment.HasValue then
                        Error('Please attach the mandatory document in Loan Journal No %1 and line no %2 before posting', LoanJournal."Emp Act. No", LoanJournal."Line No");

                EmployeeLoanRec.Init();
                EmployeeLoanRec.Type := EmployeeLoanRec.Type::Loan;
                EmployeeLoanRec."Loan Type" := LoanJournal."Loan Type";

                if LoanJournal."Loan Type" = LoanJournal."Loan Type"::"Vehicle Loan" then
                    EmployeeLoanRec."No." := NoSeries.GetNextNo(HrSetup."Vehicle Loan No.")
                else if LoanJournal."Loan Type" = LoanJournal."Loan Type"::"Home Loan Insurance Tieup" then
                    EmployeeLoanRec."No." := NoSeries.GetNextNo(HrSetup."Home Loan Insur. TieUp No.");

                EmployeeLoanRec.Validate("Employee No.", LoanJournal."Employee No.");
                EmployeeLoanRec."Loan Account No." := LoanJournal."Loan Account No.";
                EmployeeLoanRec."Interest Rate" := LoanJournal."Loan Interest Rate (%)";
                EmployeeLoanRec."Loan Acc. Open Date" := LoanJournal."Loan Account Opening Date";
                EmployeeLoanRec.Disbursed := true;
                EmployeeLoanRec."Applied Loan/Advance" := LoanJournal."Loan Disbursed Amount";
                EmployeeLoanRec."Disbursed Amount" := LoanJournal."Loan Disbursed Amount";
                EmployeeLoanRec."Loan Expiry Date" := LoanJournal."Loan Expiry Date";
                EmployeeLoanRec."Disbursement Date" := LoanJournal."Loan Disbursement Date";
                EmployeeLoanRec."Settlement Date" := LoanJournal."Loan Settlement Date";
                EmployeeLoanRec."Insurance Company" := LoanJournal."Insurance Company";
                EmployeeLoanRec."Policy No" := LoanJournal."Policy No";
                EmployeeLoanRec."Yearly Premium Amount" := LoanJournal."Yearly Premium Amount";
                EmployeeLoanRec."First Premium Date" := LoanJournal."First Premium Date";
                EmployeeLoanRec."Monthly Deduction" := LoanJournal."Monthly Deduction";

                EmployeeLoanRec.Validate(Remarks, LoanJournal.Remarks);
                EmployeeLoanRec.Validate("Approval Status", EmployeeLoanRec."Approval Status"::Approved);
                EmployeeLoanRec."Approved Date" := LoanJournal."Posting Date";
                EmployeeLoanRec.Insert();

                //Handle the attachment transfer from Employee Activity Journal to loan document if any
                if LoanJournal.Attachment.HasValue then begin
                    AttachmentSetup.Reset();
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Loan Journal");
                    AttachmentSetup.FindFirst();
                    InsertAttachment(LoanJournal,
                                    EmployeeLoanRec."No.",
                                    EmployeeLoanRec."Employee No.",
                                    EmployeeLoanRec.Type,
                                    AttachmentSetup."Attachment Code");
                end;

                PostedLoanJnl.Init();
                PostedLoanJnl.TransferFields(LoanJournal);
                LoanJournal.Delete();
                PostedLoanJnl.Validate(Posted, true);
                PostedLoanJnl.Validate("Document No", EmployeeLoanRec."No.");
                PostedLoanJnl.Insert(true);
            until LoanJournal.next() = 0
        else
            Error('There is no Document to post');

        Message('Loan Journal is posted')
    end;

    procedure InsertAttachmentforLeave(Leave: Record Leave; leaveJournal: Record "Employee Activity Journal")
    var
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        TenantMedia: Record "Tenant Media";
        InStr: InStream;
        FileMgt: Codeunit "File Management";
        AttachmentSetup: Record "Attachment Setup";
    begin
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
        AttachmentSetup.SetRange("Leave Type Code", Leave."Leave Code");
        if AttachmentSetup.FindFirst() then begin
            Clear(IncomingDocument);
            IncomingDocument.Init;
            IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
            IncomingDocument.Description := Leave.TableName;
            IncomingDocument."Attachment Code" := AttachmentSetup."Attachment Code";
            IncomingDocument."No." := Leave."No.";
            IncomingDocument."Leave Type Code" := Leave."Leave Code";
            IncomingDocument."Employee Code" := Leave."Employee No.";
            IncomingDocument."Employee Activity Type" := IncomingDocument."Employee Activity Type"::"Leave Request";
            IncomingDocument."File Name" := leaveJournal."Attachment File Name";
            IncomingDocument.Insert(true);
            IncomingDocumentAttachment.Init;
            IncomingDocumentAttachment."Line No." := 10000;
            IncomingDocumentAttachment."Created Date-Time" := CurrentDateTime;
            IncomingDocumentAttachment."Created By User Name" := UserId;
            IncomingDocumentAttachment."Incoming Document Entry No." := IncomingDocument."Entry No.";
            if TenantMedia.Get(leaveJournal.Attachment.MediaId) then
                TenantMedia.CalcFields(Content);
            IncomingDocumentAttachment."File Extension" := FileMgt.GetExtension(TenantMedia.Description);
            IncomingDocumentAttachment.Content := TenantMedia.Content;
            IncomingDocumentAttachment.Insert(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterTransferJournalPost(var PostedTransferEmployeeJournalACK: Record "Posted Employee Journal"; var TransferRequest: Record "Employee Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeLeaveRequestInsert(var leaveRequest: Record leave; var leaveJournal: Record "Employee Activity Journal")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterPromotionJournalPost(var PromotionEmployeeJournal: Record "Employee Activity Journal"; var PostedPromotionJournal: Record "Posted Employee Journal"; Var Promotion: Record Promotion)
    begin
        //For any control or modify after Promotion is posted
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostAttendanceJournal(var AttendanceMissed: Record "Attendance Missed"; AttendanceMissedJournal: Record "Employee Activity Journal")
    begin

    end;

    var
        ApproverMgt: Codeunit "Approver Mgt";
        HRMgt: Codeunit "HR Mgt.";
        ServiceHistory: Codeunit "Service History Mgt";
        AttendanceMgt: Codeunit "Attendance Mgt";
}
