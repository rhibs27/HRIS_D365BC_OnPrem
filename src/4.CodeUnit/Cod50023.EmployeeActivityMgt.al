codeunit 50023 EmployeeActivityMgt
{
    procedure SendForApproval(DocumentNo: Code[20]; DocumentType: Enum "Employee Activity Type")
    var
        EmpActJnl1: Record "Employee Activity Journal";
        ApprovalHRMS: Record "Approval HRMS";
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
                end;
                EmpActJnl1.Validate("Approval Status", EmpActJnl1."Approval Status"::Pending);
                EmpActJnl1.Modify();
            until EmpActJnl1.Next() = 0;
            ApproverMgt.UpdateFirstApproverStatus(DocumentNo);
        end else
            Error('Record not found in Status Open');
    end;

    procedure ConfirmTransferJournalDetails(EmployeeACTJnl: Record "Employee Activity Journal")

    begin
        EmployeeACTJnl.TestField("Employee No.");
        EmployeeACTJnl.TestField("Transfer Type");
        EmployeeACTJnl.TestField("Transfer Category");
        EmployeeACTJnl.TestField("Deputation On (To)");
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
        EmployeeACTJnl.TestField("Incoming Supervisor");
        EmployeeACTJnl.TestField("Outgoing Branch Rep. Person");
        EmployeeACTJnl.TestField("Approver Role (TO)");
        EmployeeACTJnl.TestField("Transfer Effective Date");
    end;

    procedure ConfirmAttendanceJournalDetails(EmployeeACTJnl: Record "Employee Activity Journal")
    begin
        if EmployeeACTJnl."Start Date" > Today then
            Error('Attendance missed date cannot be future date');
        EmployeeACTJnl.TestField("Employee No.");
        EmployeeACTJnl.TestField("Start Date");
        // EmployeeACTJnl.TestField("CheckIn Time");
        // EmployeeACTJnl.TestField("CheckOut Time");
    end;

    // procedure ApproveJournalPost(DocumentNo: Code[20])
    // var
    //     // HRSetup: Record "Human Resources Setup";
    //     EmpActJnl1: Record "Employee Activity Journal";
    //     ApprovalHRMS: Record "Approval HRMS";
    // begin

    //     EmpActJnl1.Reset();
    //     EmpActJnl1.SetRange("Emp Act. No", DocumentNo);
    //     EmpActJnl1.SetRange("Approval Status", EmpActJnl1."Approval Status"::Pending);
    //     if EmpActJnl1.FindSet() then begin
    //         ApproverMgt.CheckApprover(EmpActJnl1."Emp Act. No");
    //         EmpActJnl1.ModifyAll("Approval Status", EmpActJnl1."Approval Status"::"Approved");
    //     end else
    //         Error('There arenot record in Status Pending');

    //     ApprovalHRMS.Reset();
    //     ApprovalHRMS.SetRange("Document No.", DocumentNo);
    //     if ApprovalHRMS.Findset() then begin
    //         ApprovalHRMS.Validate("Approval Status", ApprovalHRMS."Approval Status"::Approved);
    //         ApprovalHRMS.Modify();
    //     end;
    // end;

    procedure PostTransferInBulk(EmpActNo: Code[20])
    var
        TransferRequest, EmphrTransfer : Record "Employee Transfer";
        PostedEmployeeTransfer: Record "Posted Employee Journal";
        TransferEmployeeJournal: Record "Employee Activity Journal";
    begin
        TransferEmployeeJournal.Reset();
        TransferEmployeeJournal.SetRange("Emp Act. No", EmpActNo);
        TransferEmployeeJournal.setrange("Approval Status", TransferEmployeeJournal."Approval Status"::Approved);
        if TransferEmployeeJournal.FindSet() then
            repeat
                EmphrTransfer.Reset;
                EmphrTransfer.SetFilter(Type, '%1|%2', EmphrTransfer.Type::"HR Transfer", EmphrTransfer.Type::"Employee Transfer");
                EmphrTransfer.SetRange("Employee No.", TransferEmployeeJournal."Employee No.");
                EmphrTransfer.SetFilter("Approval Status", '%1|%2|%3', EmphrTransfer."Approval Status"::Pending, EmphrTransfer."Approval Status"::Approved, EmphrTransfer."Approval Status"::"On Hold");
                if EmphrTransfer.FindFirst then
                    Error('Transfer card of employee %1 is still open or pending.Please verify Transfer Document %2', EmphrTransfer."Employee Name", EmphrTransfer."No.");
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
                TransferRequest.Validate("Transfer Effective Date", TransferEmployeeJournal."Transfer Effective Date");
                TransferRequest.Validate("Incoming Supervisior", TransferEmployeeJournal."Incoming Supervisor");
                TransferRequest.Validate("Outgoing Branch Rep. Person", TransferEmployeeJournal."Outgoing Branch Rep. Person");
                TransferRequest.Validate("Notify to", TransferEmployeeJournal."Notify to");
                TransferRequest.Validate("Approver Role To", TransferEmployeeJournal."Approver Role (TO)");
                TransferRequest.Validate(Remarks, TransferEmployeeJournal.Remarks);
                TransferRequest.Validate("Approval Status", TransferRequest."Approval Status"::Approved);
                TransferRequest.Validate("Is Transfer Details Added", true);
                TransferRequest.Validate("Approved Date", Today);
                TransferRequest.Validate(Type, TransferRequest.Type::"HR Transfer");
                TransferRequest.Insert(true);
                PostedEmployeeTransfer.Init();
                PostedEmployeeTransfer.TransferFields(TransferEmployeeJournal);
                TransferEmployeeJournal.Delete();
                PostedEmployeeTransfer.Validate(Posted, true);
                PostedEmployeeTransfer.Validate("Document No", TransferRequest."No.");
                PostedEmployeeTransfer.Insert(true);
                OnAfterTransferJournalPost(TransferEmployeeJournal, TransferRequest);
            until TransferEmployeeJournal.next() = 0
        else
            Error('There is no Document to post');

        Message('Transfer Journal is posted')

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
                    LeaveRequest.Validate("Leave Description", leaveJournal."Leave Description");
                    LeaveRequest.Validate("Leave Type", leaveJournal."Leave Type");
                    LeaveRequest.Validate("Start Date", leaveJournal."Start Date");
                    LeaveRequest.Validate("End Date", leaveJournal."End Date");
                    LeaveRequest.Validate(Remarks, leaveJournal.Remarks);
                    LeaveRequest.Validate("Approval Status", LeaveRequest."Approval Status"::Approved);
                    LeaveRequest.Validate("Approved Date", Today);
                    LeaveRequest.Validate(Type, LeaveRequest.Type::"Leave Request");
                    LeaveRequest.Validate("Form Journal", true);
                    LeaveRequest.Insert(true);
                end else if leaveJournal."Adjustment Type" = leaveJournal."Adjustment Type"::Adjustment then
                        LeaveMgt.InsertLeaveEarnfromJournal(
                            leaveJournal."Leave Code",
                            leaveJournal."Employee No.",
                            leaveJournal."Adjustment Type",
                            leaveJournal."No. of Days",
                            leaveJournal."Emp Act. No",
                            leaveJournal."Requested Date");
                PostedLeaveJournal.Init();
                PostedLeaveJournal.TransferFields(leaveJournal);
                if leaveJournal."Adjustment Type" = leaveJournal."Adjustment Type"::Used then begin
                    PostedLeaveJournal.Validate("Document No", LeaveRequest."No.");
                    LeaveMgt.LeaveApproved(LeaveRequest."No.");
                end;
                PostedLeaveJournal.Validate(Posted, true);
                PostedLeaveJournal.Insert(true);
                leaveJournal.Delete();
            until leaveJournal.next() = 0
        else
            Error('There is no Document to post');
        Message('Leave is posted');
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
                AttendanceMgn.CheckAlreadyExists(AttendanceMissedJournal."Employee No.", AttendanceMissedJournal.Type, AttendanceMissedJournal."Start Date");
                AttendanceMissed.Reset();
                AttendanceMissed.Init();
                AttendanceMissed.Validate("No.", '');
                AttendanceMissed.Validate("Employee No.", AttendanceMissedJournal."Employee No.");
                AttendanceMissed.Validate("Start Date", AttendanceMissedJournal."Start Date");
                AttendanceMissed.Validate("Check In Time", AttendanceMissedJournal."CheckIn Time");
                AttendanceMissed.Validate("Check Out Time", AttendanceMissedJournal."CheckOut Time");
                AttendanceMissed.Validate(Remarks, AttendanceMissedJournal.Remarks);
                AttendanceMissed.Validate("Approval Status", AttendanceMissedJournal."Approval Status"::Approved);
                AttendanceMissed.Validate("Approved Date", Today);
                AttendanceMissed.Validate(Type, AttendanceMissed.Type::"Attendance Missed");
                AttendanceMissed.Validate("From Journal", true);
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
        Message('Attendance Jounral is posted');
    end;

    procedure RejectJournal(var EmployeeActJournal: Record "Employee Activity Journal"; Reject: Boolean)
    var
        Approver: Record "Approval HRMS";
        StatusMaster: Record "Status Master";

    begin
        if Reject then begin
            EmployeeActJournal.TestField("Approval Status", EmployeeActJournal."Approval Status"::Pending);
            ApproverMgt.CheckApprover(EmployeeActJournal."Emp Act. No");
            // Approver.Validate("Approval Status", Approver."Approval Status"::Rejected);
            // Approver.Validate("Rejected By", HRMgt.GetEmpName());
            EmployeeActJournal.Validate("Approval Status", EmployeeActJournal."Approval Status"::Rejected);
            EmployeeActJournal.Modify();
            // EmployeeActJournal.Modify("Approval Status", EmployeeActJournal."Approval Status"::Rejected);
            // Approver.Modify();
            // Get the Rejected Status from Status Master
            StatusMaster.Reset();
            StatusMaster.SetRange(Rejected, true);
            if StatusMaster.FindFirst() then begin
                EmployeeActJournal.Validate(Status, StatusMaster.Status);
            end
            else
                Error('Rejected Status not Found On Status Master Setup');
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

    [IntegrationEvent(false, false)]
    procedure OnAfterTransferJournalPost(var TransferEmployeeJournalACK: Record "Employee Activity Journal"; var TransferRequest: Record "Employee Transfer")
    begin
    end;

    var
        ApproverMgt: Codeunit "Approver Mgt";
        LeaveMgt: Codeunit "Leave Mgt.";
        HRMgt: Codeunit "HR Mgt.";

}
