codeunit 50023 EmployeeActivityMgt
{
    procedure SendForApproval(DocumentNo: Code[20])
    var
        // HRSetup: Record "Human Resources Setup";
        EmpActJnl1: Record "Employee Activity Journal";
        ApprovalHRMS: Record "Approval HRMS";
    begin
        EmpActJnl1.Reset();
        EmpActJnl1.SetRange("Emp Act. No", DocumentNo);
        EmpActJnl1.SetRange("Approval Status", EmpActJnl1."Approval Status"::Open);
        if EmpActJnl1.FindSet() then
            EmpActJnl1.ModifyAll("Approval Status", EmpActJnl1."Approval Status"::"Pending")
        else
            Error('There arenot record in Status Open');
        ApproverMgt.UpdateFirstApproverStatus(DocumentNo);
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
        TransferRequest, EmphrTransfer : Record "Employee/HR Transfer";
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
                TransferRequest.Validate("Notify to", TransferEmployeeJournal."Notify to");
                TransferRequest.Validate(Remarks, TransferEmployeeJournal.Remarks);
                TransferRequest.Validate("Approval Status", TransferRequest."Approval Status"::Approved);
                TransferRequest.Validate("Is Transfer Details Added", false);
                TransferRequest.Validate("Approved Date", Today);
                TransferRequest.Validate(Type, TransferRequest.Type::"HR Transfer");
                TransferRequest.Insert(true);
                PostedEmployeeTransfer.Init();
                PostedEmployeeTransfer.TransferFields(TransferEmployeeJournal);
                TransferEmployeeJournal.Delete();
                PostedEmployeeTransfer.Validate(Posted, true);
                PostedEmployeeTransfer.Validate("Document No", TransferRequest."No.");
                PostedEmployeeTransfer.Insert(true);
            until TransferEmployeeJournal.next() = 0;
        Message('Transfer is posted');
    end;

    procedure PostLeaveJournal(EmpActNo: Code[20])
    var
        LeaveRequest: Record Leave;
        leaveJournal: Record "Employee Activity Journal";
        PostedLeaveJournal: Record "Posted Employee Journal";
    begin
        leaveJournal.Reset();
        leaveJournal.SetRange("Emp Act. No", EmpActNo);
        leaveJournal.setrange("Approval Status", leaveJournal."Approval Status"::Approved);
        if leaveJournal.FindSet() then
            repeat
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
                PostedLeaveJournal.Init();
                PostedLeaveJournal.TransferFields(leaveJournal);
                leaveJournal.Delete();
                PostedLeaveJournal.Validate(Posted, true);
                PostedLeaveJournal.Validate("Document No", LeaveRequest."No.");
                PostedLeaveJournal.Insert(true);
            until leaveJournal.next() = 0
        else
            Error('There is no Document to post');
        Message('Leave is posted');
    end;

    procedure RejectJournal(var EmployeeActJournal: Record "Employee Activity Journal"; Reject: Boolean)
    var
        Approver: Record "Approval HRMS";
        StatusMaster: Record "Status Master";

    begin
        if Reject then begin
            EmployeeActJournal.TestField("Approval Status", EmployeeActJournal."Approval Status"::Pending);
            ApproverMgt.CheckApprover(EmployeeActJournal."Emp Act. No");
            Approver.Validate("Approval Status", Approver."Approval Status"::Rejected);
            Approver.Validate("Rejected By", HRMgt.GetEmpName());
            EmployeeActJournal.ModifyAll("Approval Status", EmployeeActJournal."Approval Status"::Rejected);
            Approver.Modify();
            // Get the Rejected Status from Status Master
            StatusMaster.Reset();
            StatusMaster.SetRange(Rejected, true);
            if StatusMaster.FindFirst() then begin
                EmployeeActJournal.ModifyAll(Status, StatusMaster.Status);
            end
            else
                Error('Rejected Status not Found On Status Master Setup');
        end;
    end;


    var
        ApproverMgt: Codeunit "Approver Mgt";
        LeaveMgt: Codeunit "Leave Mgt.";
        HRMgt: Codeunit "HR Mgt.";

}
