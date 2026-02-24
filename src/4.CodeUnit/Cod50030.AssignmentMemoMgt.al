codeunit 50030 "Assignment Memo Mgt"
{
    procedure OpenAllowanceRequestMemo(EmpCode: Code[20])
    var
        AssignmentMemoHdr, AssignmentMemoHdr2 : Record "Assignment Memo Header";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
    begin

        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Allowance Assignment Memo");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();

        Employee.Get(EmpCode);
        AssignmentMemoHdr.SetRange("Employee No.", EmpCode);
        AssignmentMemoHdr.SetRange("Activity Type", AssignmentMemoHdr."Activity Type"::"Allowance Assignment Memo");
        AssignmentMemoHdr.SetRange("Approval Status", AssignmentMemoHdr."Approval Status"::open);
        if AssignmentMemoHdr.Findfirst() then begin
            Message('This Employee Already has open Allowance Request.Click Ok to Open');
            PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr)
        end else begin
            AssignmentMemoHdr2.Init;
            AssignmentMemoHdr2.Validate("Activity Type", AssignmentMemoHdr2."Activity Type"::"Allowance Assignment Memo");
            AssignmentMemoHdr2.Validate("Approval Status", AssignmentMemoHdr2."Approval Status"::Open);
            AssignmentMemoHdr2.Validate("Employee No.", EmpCode);
            AssignmentMemoHdr2.Validate("Province Code", Employee."Province Code");
            AssignmentMemoHdr2.Validate("Branch Code", Employee."Branch Code");
            AssignmentMemoHdr2.Validate("Department Code", Employee."Department Code");
            AssignmentMemoHdr2.Validate("Unit Code", Employee."Unit Code");
            AssignmentMemoHdr2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr2);
        end;
    end;

    procedure ApproveRejectAssignmentmemo(docNo: Code[20]; IsApproved: Boolean)
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        SkipAssignmentLedgerCreation: Boolean;
    begin
        if not AssignmentMemoHdr.Get(docNo) then
            Error('Assignment %1 not found.', docNo);

        if not IsApproved then begin
            if AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending then  //substitute approval pending
                AssignmentMemoHdr."Substitute Approval Status" := AssignmentMemoHdr."Substitute Approval Status"::Rejected;
            if (AssignmentMemoHdr."Approval Status" <> AssignmentMemoHdr."Approval Status"::Approved) and
               (AssignmentMemoHdr."Substitute Approval Status" in [AssignmentMemoHdr."Substitute Approval Status"::Open, AssignmentMemoHdr."Substitute Approval Status"::Created]) then
                AssignmentMemoHdr."Approval Status" := AssignmentMemoHdr."Approval Status"::Rejected;
            AssignmentMemoHdr.Modify();

            //reject the pending line as well
            AssignmentMemoLine.SetRange("Document No.", docNo);
            AssignmentMemoLine.SetRange("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
            if AssignmentMemoLine.FindSet() then
                repeat
                    AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Rejected;
                    AssignmentMemoLine.Modify();
                    //clear ledger entry if any
                    ClearAssignmentMemoLedgerDataOnLineReject(AssignmentMemoLine."Assign Memo Ledger Entry No.");
                until AssignmentMemoLine.Next() = 0;
        end;

        //approved
        if IsApproved then begin
            AssignmentMemoHdr."Approval Status" := AssignmentMemoHdr."Approval Status"::Approved;
            if AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending then
                AssignmentMemoHdr."Substitute Approval Status" := AssignmentMemoHdr."Substitute Approval Status"::Approved;
            AssignmentMemoHdr.Modify();

            //approve line as well
            AssignmentMemoLine.SetRange("Document No.", docNo);
            AssignmentMemoLine.SetRange("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
            if AssignmentMemoLine.FindSet() then
                repeat
                    AssignmentMemoLine."Approval Status" := AssignmentMemoLine."Approval Status"::Approved;
                    AssignmentMemoLine.Modify();

                    //create assignment memo ledger entry
                    CheckSkipAssignmentLedgerCreation(AssignmentMemoLine, SkipAssignmentLedgerCreation);
                    if not SkipAssignmentLedgerCreation then
                        CreateAssignmentMemoLedgerEntry(AssignmentMemoLine."Document No.", AssignmentMemoLine."Line No.");
                until AssignmentMemoLine.Next() = 0;
            if not ((AssignmentMemoHdr."Activity Type" = AssignmentMemoHdr."Activity Type"::"Allowance Assignment Memo") or (AssignmentMemoHdr."Activity Type" = AssignmentMemoHdr."Activity Type"::"Shift Assignment Memo")) then
                CreatePayrollAttrUsesOnApprovedAssignmentMemo(AssignmentMemoHdr);
            OnafterApproveAssignmentMemo(AssignmentMemoHdr); //company specific logic hook
        end;
    end;

    procedure CreateAssignmentMemoLedgerEntry(DocumentNo: Code[20]; lineNo: Integer)
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        AllowanceConfiguration, AllConfig2 : Record "Allowance Configuration";
        EmployeeWorkShift: Record "Employee Work Shift";
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveMgt: Codeunit "Leave Mgt.";
        DateVar: Record Date;
        IsHandled: Boolean;
    begin
        AssignmentMemoHdr.Get(DocumentNo);
        if AssignmentMemoLine.Get(DocumentNo, lineNo) then begin

            //check and update the source substitute ledger entry to closed
            if AssignmentMemoLine."Substitute Type" = AssignmentMemoLine."Substitute Type"::"Added as Substitute" then
                UpdateSubstituteAssignmentMemoLedgerEntry(AssignmentMemoLine);

            if AssignmentMemoLine."Claimed as Leave" then begin

                //Generate substitute leave balance and exit the procedure
                LeaveTypeSetup.SetRange("Leave Category", LeaveTypeSetup."Leave Category"::Substitute);
                LeaveTypeSetup.FindFirst();

                LeaveMgt.CreateLeaveLedger(AssignmentMemoLine."Employee No.",
                LeaveTypeSetup.Code,
                AssignmentMemoLine."From Date",
                Enum::"Leave Earn Type"::Earned,
                AssignmentMemoLine."To Date" - AssignmentMemoLine."From Date" + 1,
                LeaveMgt.GetNextLeaveLedgerEntryNo(),
                AssignmentMemoLine."Document No.",
                'Leave earned against holiday shift',
                ''
                );
                exit;
            end;

            //check allowance configuration source and create ledger entries accordingly
            Clear(AllConfig2);
            Clear(AllowanceConfiguration);
            OnOtherAllowanceConfigurationCheck(AssignmentMemoLine, AllConfig2, IsHandled);
            if not IsHandled then begin
                AllowanceConfiguration.Reset();
                AllowanceConfiguration.SetRange("Payroll Attribute", AssignmentMemoLine."Payroll Attribute Code");
                AllowanceConfiguration.SetFilter("ATM Site", '%1|%2', AssignmentMemoLine."ATM Site"::" ", AssignmentMemoLine."ATM Site");
                if AllowanceConfiguration.FindSet() then
                    repeat
                        // check if allowance is eligible for employee.
                        if AllowanceConfiguration.IsValidAllowanceConfigurationForEmployee(AllowanceConfiguration, AssignmentMemoLine."Employee No.", AssignmentMemoLine."To Date") then begin
                            AllConfig2 := AllowanceConfiguration;
                            break;
                        end;
                    until AllowanceConfiguration.Next() = 0;
            end;
            DateVar.Reset();
            DateVar.SetRange("Period Type", DateVar."Period Type"::Date);
            if AllConfig2.Source in [AllConfig2.Source::Assignment, AllConfig2.Source::Shift] then
                DateVar.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date")
            else
                DateVar.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."From Date"); //insert only one ledger
            if DateVar.FindSet() then
                repeat
                    //insert ledger entry for each date in range
                    Clear(AssignmentMemoLedgerEntry);
                    AssignmentMemoLedgerEntry.Init();
                    AssignmentMemoLedgerEntry."Entry No." := AssignmentMemoLedgerEntry.GetNextEntryNo();
                    AssignmentMemoLedgerEntry.Validate("Document No.", AssignmentMemoHdr."No.");
                    AssignmentMemoLedgerEntry.Validate("Employee Activity Type", AssignmentMemoHdr."Activity Type");
                    AssignmentMemoLedgerEntry.Validate("Employee No.", AssignmentMemoLine."Employee No.");
                    AssignmentMemoLedgerEntry.Validate("Payroll Attribute Code", AssignmentMemoLine."Payroll Attribute Code");
                    AssignmentMemoLedgerEntry.Validate("Posting Date", DateVar."Period Start");
                    AssignmentMemoLedgerEntry.Validate("Open", true);
                    AssignmentMemoLedgerEntry.Validate(Amount, AssignmentMemoLine."Allowance Amount");
                    AssignmentMemoLedgerEntry.Validate("Vault Name", AssignmentMemoLine."Vault Name");
                    AssignmentMemoLedgerEntry.Validate(Panel, AssignmentMemoLine."Panel");
                    AssignmentMemoLedgerEntry.Validate("ATM Site", AssignmentMemoLine."ATM Site");
                    AssignmentMemoLedgerEntry.Validate("Employee Work Shift", AssignmentMemoLine."Employee Work Shift");
                    if AssignmentMemoHdr."Activity Type" = AssignmentMemoHdr."Activity Type"::"Shift Assignment Memo" then
                        if EmployeeWorkShift.Get(AssignmentMemoLine."Employee Work Shift") then
                            AssignmentMemoLedgerEntry.Validate("Payroll Attribute Code", EmployeeWorkShift."Payroll Attribute Code");

                    if AllConfig2.Source in [AllConfig2.Source::Direct, AllConfig2.Source::" "] then begin
                        AssignmentMemoLedgerEntry.Validate("Valid From Date", AssignmentMemoHdr."From Date");  //allowance that is request once but valid for whole fiscal year
                        AssignmentMemoLedgerEntry.Validate("Valid To Date", AssignmentMemoHdr."To Date");

                        //outstation and remote allowance prorata calculation
                        ProrateAllowanceAmount(AssignmentMemoLine, AssignmentMemoLedgerEntry);
                    end;
                    AssignmentMemoLedgerEntry.Insert(true);
                until DateVar.Next() = 0;
        end;
    end;

    procedure SendApprovalAssignmentMemo(var AssignmentmemoHdr: Record "Assignment Memo Header")
    var
        AssignmentMemoLine, AssignmentMemoLine2 : Record "Assignment Memo Line";
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalHrms: Record "Approval HRMS";
        IsHandled, SkipCheck : Boolean;
        PayrollGSUP: Record "Payroll General Setup";
        OrganizationalStructureList: Record "Organization Structure List";
    begin
        PayrollGSUP.Get();
        ProcessAssignmentRequestFromCopyTable(AssignmentmemoHdr, IsHandled);
        if AssignmentmemoHdr."Approval Status" = AssignmentmemoHdr."Approval Status"::Open then
            AssignmentMemoHdr.TestField(Remarks);

        AssignmentMemoLine2.SetRange("Document No.", AssignmentmemoHdr."No.");
        if AssignmentMemoLine2.Count = 0 then
            Error('Nothing to send for approval.');

        AssignmentMemoLine2.CalcSums("Allowance Amount");
        if AssignmentMemoLine2."Allowance Amount" = 0 then
            if AssignmentmemoHdr."Activity Type" = AssignmentmemoHdr."Activity Type"::"Request Allowance" then
                Error('Total Allowance Amount cannot be zero.');

        CheckAttachmentOnBeforeSendForApproval(AssignmentmemoHdr);  //check mandatory attachment exist
        AssignmentMemoOnbeforeSendForApproval(AssignmentmemoHdr, IsHandled);  //company specific and allowance specific controls
        if AssignmentmemoHdr."Activity Type" = AssignmentmemoHdr."Activity Type"::"Allowance Assignment Memo" then
            AllowanceAssignmentmemoOnbeforeSendForApproval(AssignmentmemoHdr."No."); //only for assignment to check limit
        CheckIfAllowanceIsSubstitutedForTheDate(AssignmentmemoHdr);  //do now allow to request if already substituted

        ApproverMgt.UpdateFirstApproverStatus(AssignmentmemoHdr."No.");

        if AssignmentmemoHdr."Approval Status" in [AssignmentmemoHdr."Approval Status"::Open, AssignmentmemoHdr."Approval Status"::Created] then
            AssignmentmemoHdr.Validate("Approval Status", AssignmentmemoHdr."Approval Status"::"Pending");
        if AssignmentmemoHdr."Substitute Approval Status" = AssignmentmemoHdr."Substitute Approval Status"::Open then
            AssignmentmemoHdr.Validate("Substitute Approval Status", AssignmentmemoHdr."Substitute Approval Status"::"Pending");
        AssignmentmemoHdr.Modify(true);

        AssignmentMemoLine.SetRange("Document No.", AssignmentmemoHdr."No.");
        AssignmentMemoLine.SetRange("Approval Status", AssignmentMemoLine."Approval Status"::Open);
        if AssignmentMemoLine.FindSet() then
            repeat
                AssignmentMemoLine.TestField("Employee No.");
                AssignmentMemoLine.TestField("From Date");
                AssignmentMemoLine.TestField("To Date");

                if AssignmentMemoLine."Emp Act Type" in [AssignmentMemoLine."Emp Act Type"::"Allowance Assignment Memo", AssignmentMemoLine."Emp Act Type"::"Request Allowance"] then begin
                    AssignmentMemoLine.TestField("Payroll Attribute Code");
                end;
                if AssignmentMemoLine."Emp Act Type" = AssignmentMemoLine."Emp Act Type"::"Shift Assignment Memo" then begin
                    AssignmentMemoLine.TestField("Employee Work Shift");
                end;

                CheckAmountForReimbursement(AssignmentMemoLine);
                if AssignmentMemoLine."Allowance Amount" = 0 then
                    AssignmentMemoLine.CalculateAmountForLine();  //calculate the amount before sending for approval
                AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
                AssignmentMemoLine.Modify();
            until AssignmentMemoLine.Next() = 0;

        // final check allowance amount 
        OnBeforeAmountCheck(AssignmentMemoLine, SkipCheck);
        if not SkipCheck then begin
            AssignmentMemoLine.Reset();
            AssignmentMemoLine.SetRange("Document No.", AssignmentmemoHdr."No.");
            AssignmentMemoLine.SetRange("Allowance Amount", 0);
            if not AssignmentMemoLine.IsEmpty() then
                Error('allowance amount cannot be zero for any line.');
        end;
        //final check allowance amount 
        OrganizationalStructureList.Get(OrganizationalStructureList.Type::Branch, AssignmentmemoHdr."Branch Code");
        AssignmentMemoLine.Reset();
        AssignmentMemoLine.SetRange("Document No.", AssignmentmemoHdr."No.");
        AssignmentMemoLine.SetRange("Allowance Amount", 0);
        if not AssignmentMemoLine.IsEmpty() then
            //Error('allowance amount cannot be zero for any line.');
            Error('%1 is not eligible for %2.', OrganizationalStructureList.Name, AssignmentMemoLine."Payroll Attribute Description");

        //In case of substitute, open the approval for substitute
        if AssignmentmemoHdr."Substitute Approval Status" = AssignmentmemoHdr."Substitute Approval Status"::Pending then begin
            ApprovalHrms.SetFilter("Approval Sequence", '>%1', 1);
            ApprovalHrms.SetRange("Document No.", AssignmentmemoHdr."No.");
            ApprovalHrms.SetFilter("Approval Sequence", '>%1', 1);
            if ApprovalHrms.FindSet() then
                ApprovalHrms.ModifyAll("Approval Status", ApprovalHrms."Approval Status"::Created);
        end;
    end;

#if SaasFeature
    procedure SendApprovalAssignmentMemo(var AssignmentmemoHdr: Record "Assignment Memo Header"; AccessToken: text[60])
    var
        AssignmentMemoLine, AssignmentMemoLine2 : Record "Assignment Memo Line";
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalHrms: Record "Approval HRMS";
        IsHandled: Boolean;
        OrganizationalStructureList: Record "Organization Structure List";
    begin
        ProcessAssignmentRequestFromCopyTable(AssignmentmemoHdr, IsHandled);
        if AssignmentmemoHdr."Approval Status" = AssignmentmemoHdr."Approval Status"::Open then
            AssignmentMemoHdr.TestField(Remarks);

        AssignmentMemoLine2.SetRange("Document No.", AssignmentmemoHdr."No.");
        if AssignmentMemoLine2.Count = 0 then
            Error('Nothing to send for approval.');

        AssignmentMemoLine2.CalcSums("Allowance Amount");
        if AssignmentMemoLine2."Allowance Amount" = 0 then
            if AssignmentmemoHdr."Activity Type" = AssignmentmemoHdr."Activity Type"::"Request Allowance" then
                Error('Total Allowance Amount cannot be zero.');

        CheckAttachmentOnBeforeSendForApproval(AssignmentmemoHdr);  //check mandatory attachment exist
        AssignmentMemoOnbeforeSendForApproval(AssignmentmemoHdr, IsHandled);  //company specific and allowance specific controls
        if AssignmentmemoHdr."Activity Type" = AssignmentmemoHdr."Activity Type"::"Allowance Assignment Memo" then
            AllowanceAssignmentmemoOnbeforeSendForApproval(AssignmentmemoHdr."No."); //only for assignment to check limit
        CheckIfAllowanceIsSubstitutedForTheDate(AssignmentmemoHdr);  //do now allow to request if already substituted

        ApproverMgt.UpdateFirstApproverStatus(AssignmentmemoHdr."No.");

        if AssignmentmemoHdr."Approval Status" in [AssignmentmemoHdr."Approval Status"::Open, AssignmentmemoHdr."Approval Status"::Created] then
            AssignmentmemoHdr.Validate("Approval Status", AssignmentmemoHdr."Approval Status"::"Pending");
        if AssignmentmemoHdr."Substitute Approval Status" = AssignmentmemoHdr."Substitute Approval Status"::Open then
            AssignmentmemoHdr.Validate("Substitute Approval Status", AssignmentmemoHdr."Substitute Approval Status"::"Pending");
        AssignmentmemoHdr.Modify(true);

        AssignmentMemoLine.SetRange("Document No.", AssignmentmemoHdr."No.");
        AssignmentMemoLine.SetRange("Approval Status", AssignmentMemoLine."Approval Status"::Open);
        if AssignmentMemoLine.FindSet() then
            repeat
                AssignmentMemoLine.TestField("Employee No.");
                AssignmentMemoLine.TestField("From Date");
                AssignmentMemoLine.TestField("To Date");

                if AssignmentMemoLine."Emp Act Type" in [AssignmentMemoLine."Emp Act Type"::"Allowance Assignment Memo", AssignmentMemoLine."Emp Act Type"::"Request Allowance"] then begin
                    AssignmentMemoLine.TestField("Payroll Attribute Code");
                end;
                if AssignmentMemoLine."Emp Act Type" = AssignmentMemoLine."Emp Act Type"::"Shift Assignment Memo" then begin
                    AssignmentMemoLine.TestField("Employee Work Shift");
                end;

                CheckAmountForReimbursement(AssignmentMemoLine);
                if AssignmentMemoLine."Allowance Amount" = 0 then
                    AssignmentMemoLine.CalculateAmountForLine();  //calculate the amount before sending for approval
                AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::"Pending");
                AssignmentMemoLine.Modify();
            until AssignmentMemoLine.Next() = 0;

        //final check allowance amount 
        OrganizationalStructureList.Get(OrganizationalStructureList.Type::Branch, AssignmentmemoHdr."Branch Code");
        AssignmentMemoLine.Reset();
        AssignmentMemoLine.SetRange("Document No.", AssignmentmemoHdr."No.");
        AssignmentMemoLine.SetRange("Allowance Amount", 0);
        if not AssignmentMemoLine.IsEmpty() then
            //Error('allowance amount cannot be zero for any line.');
             Error('%1 is not eligible for %2.', OrganizationalStructureList.Name, AssignmentMemoLine."Payroll Attribute Description");


        //In case of substitute, open the approval for substitute
        if AssignmentmemoHdr."Substitute Approval Status" = AssignmentmemoHdr."Substitute Approval Status"::Pending then begin
            ApprovalHrms.SetFilter("Approval Sequence", '>%1', 1);
            ApprovalHrms.SetRange("Document No.", AssignmentmemoHdr."No.");
            ApprovalHrms.SetFilter("Approval Sequence", '>%1', 1);
            if ApprovalHrms.FindSet() then
                ApprovalHrms.ModifyAll("Approval Status", ApprovalHrms."Approval Status"::Created);
        end;
    end;
#endif

    procedure InsertSubstituteAssignmentMemo(docNo: Code[20]; lineNo: Integer; fromDate: Date; toDate: Date; empCode: Code[20])
    var
        SubAssigmemoLine: Record "Assignment Memo Line";
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLine: Record "Assignment Memo Line";
    begin
        // Implementation for inserting substitute assignment memo
        AssignmentMemoHdr.Get(docNo);
        AssignmentMemoLine.Get(docNo, lineNo);
        OnAfterCheckDuplicateShiftLine(docNo, LineNo, fromDate, toDate, empCode);
        //check if there is pending request allowance exist for the document
        CheckIfPendingClaimedAllowanceExist(docNo, lineNo);

        //check if substitute dates are within the original assignment memo line dates
        if not ((FromDate >= AssignmentMemoLine."From Date") and (ToDate <= AssignmentMemoLine."To Date")) then
            Error('Substitute dates must be within the original assignment line dates.');

        //check conflicting substitute assignment
        CheckConflictingSubstituteAssignment(docNo, lineNo, fromDate, toDate);

        SubAssigmemoLine.Init();
        SubAssigmemoLine.TransferFields(AssignmentMemoLine);
        SubAssigmemoLine."Line No." := 0;
        SubAssigmemoLine.Validate("Employee No.", EmpCode);
        SubAssigmemoLine.Validate("From Date", FromDate);
        SubAssigmemoLine.Validate("To Date", ToDate);
        SubAssigmemoLine.Validate("Substitute Type", SubAssigmemoLine."Substitute Type"::"Added as Substitute");
        SubAssigmemoLine."Substitute of Line No." := AssignmentMemoLine."Line No.";
        SubAssigmemoLine."Approval Status" := SubAssigmemoLine."Approval Status"::Open;
        SubAssigmemoLine.Insert(true);

        AssignmentMemoHdr."Substitute Approval Status" := AssignmentMemoHdr."Substitute Approval Status"::Open;
        AssignmentMemoHdr.Modify();
    end;

    procedure UpdateSubstituteAssignmentMemoLedgerEntry(var SubAssigmemoLine: Record "Assignment Memo Line")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        AttendanceMgt: Codeunit "Attendance Mgt";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
    begin
        AssignmentMemoLine.Get(SubAssigmemoLine."Document No.", SubAssigmemoLine."Substitute of Line No.");
        AssignmentMemoLedgerEntry.SetRange("Document No.", AssignmentMemoLine."Document No.");
        AssignmentMemoLedgerEntry.SetRange("Employee No.", AssignmentMemoLine."Employee No.");
        AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", SubAssigmemoLine."Payroll Attribute Code");
        if SubAssigmemoLine."ATM Site" <> SubAssigmemoLine."ATM Site"::" " then
            AssignmentMemoLedgerEntry.SetRange("ATM Site", SubAssigmemoLine."ATM Site");
        if SubAssigmemoLine."Vault Name" <> '' then
            AssignmentMemoLedgerEntry.SetRange("Vault Name", SubAssigmemoLine."Vault Name");
        if SubAssigmemoLine.Panel <> SubAssigmemoLine.Panel::" " then
            AssignmentMemoLedgerEntry.SetRange(Panel, SubAssigmemoLine.Panel);
        AssignmentMemoLedgerEntry.SetRange("Posting Date", SubAssigmemoLine."From Date", SubAssigmemoLine."To Date");
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoLedgerEntry.Validate("Open", false);
                AssignmentMemoLedgerEntry.Validate("Substituted Employee No.", SubAssigmemoLine."Employee No.");
                AssignmentMemoLedgerEntry.Modify(true);
                Commit();
                ShiftAssignmentMgt.ProcessDailyAttendanceForShiftSubstitute(AssignmentMemoLedgerEntry."Posting Date", AssignmentMemoLedgerEntry."Employee No.");
                ShiftAssignmentMgt.ProcessDailyAttendanceForShiftSubstitute(AssignmentMemoLedgerEntry."Posting Date", AssignmentMemoLedgerEntry."Substituted Employee No.");
            until AssignmentMemoLedgerEntry.Next() = 0;
    end;

    procedure CheckConflictingSubstituteAssignment(docNo: Code[20]; LineNo: Integer; fromDate: Date; toDate: Date): Boolean
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        Daterec: Record Date;
        DateList: List of [Date];
    begin
        AssignmentMemoLine.SetRange("Document No.", docNo);
        AssignmentMemoLine.SetRange("Substitute Type", AssignmentMemoLine."Substitute Type"::"Added as Substitute");
        AssignmentMemoLine.Setfilter("Approval Status", '<>%1', AssignmentMemoLine."Approval Status"::Rejected);
        AssignmentMemoLine.SetRange("Substitute of Line No.", LineNo);
        if AssignmentMemoLine.FindSet() then
            repeat
                Daterec.Reset();
                Daterec.SetRange("Period Type", Daterec."Period Type"::Date);
                Daterec.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date");
                if Daterec.FindSet() then
                    repeat
                        if not DateList.Contains(Daterec."Period Start") then
                            DateList.Add(Daterec."Period Start")
                        else
                            Error('Conflicting substitute assignment exists for the selected date range %1 to %2.', fromDate, toDate);
                    until Daterec.Next() = 0;
            until AssignmentMemoLine.Next() = 0;

        Daterec.Reset();
        Daterec.SetRange("Period Type", Daterec."Period Type"::Date);
        Daterec.SetRange("Period Start", fromDate, toDate);
        if Daterec.FindSet() then
            repeat
                if DateList.Contains(Daterec."Period Start") then
                    Error('Conflicting substitute assignment exists for the selected date range %1 to %2.', fromDate, toDate);
            until Daterec.Next() = 0;
    end;

    procedure CreateNewAssignmentMemoFromCopyDoc(SourceDocNo: Code[20]; FromDate: Date; ToDate: Date; empCode: Code[20])
    var
        SourceAssignmentMemoHdr, AssignmentMemoHdr : Record "Assignment Memo Header";
        SourceAssignmentMemoLine, AssignmentMemoLine : Record "Assignment Memo Line";
    begin
        SourceAssignmentMemoHdr.Get(SourceDocNo);
        SourceAssignmentMemoHdr.TestField("Activity Type", SourceAssignmentMemoHdr."Activity Type"::"Allowance Assignment Memo");
        SourceAssignmentMemoHdr.TestField("Approval Status", SourceAssignmentMemoHdr."Approval Status"::Approved);

        SourceAssignmentMemoLine.SetRange("Document No.", SourceDocNo);
        SourceAssignmentMemoLine.SetRange("Approval Status", SourceAssignmentMemoLine."Approval Status"::Approved);
        if SourceAssignmentMemoLine.IsEmpty() then
            Error('No lines found in the source assignment memo %1.', SourceDocNo);

        //create new assignment memo header
        AssignmentMemoHdr.Init();
        AssignmentMemoHdr.Validate("Activity Type", SourceAssignmentMemoHdr."Activity Type");
        AssignmentMemoHdr.Validate("Province Code", SourceAssignmentMemoHdr."Province Code");
        AssignmentMemoHdr.Validate("Branch Code", SourceAssignmentMemoHdr."Branch Code");
        AssignmentMemoHdr.Validate("Department Code", SourceAssignmentMemoHdr."Department Code");
        AssignmentMemoHdr.Validate("Unit Code", SourceAssignmentMemoHdr."Unit Code");
        AssignmentMemoHdr.Validate("Employee No.", empCode);
        AssignmentMemoHdr.Validate("From Date", FromDate);
        AssignmentMemoHdr.Validate("To Date", ToDate);
        AssignmentMemoHdr.Validate("Approval Status", AssignmentMemoHdr."Approval Status"::Open);
        AssignmentMemoHdr.Insert(true);

        //copy lines
        SourceAssignmentMemoLine.Reset();
        SourceAssignmentMemoLine.SetRange("Document No.", SourceDocNo);
        SourceAssignmentMemoLine.SetRange("Approval Status", SourceAssignmentMemoLine."Approval Status"::Approved);
        SourceAssignmentMemoLine.SetRange("Substitute of Line No.", 0);
        if SourceAssignmentMemoLine.FindSet() then
            repeat
                AssignmentMemoLine.Init();
                AssignmentMemoLine.TransferFields(SourceAssignmentMemoLine);
                AssignmentMemoLine.Validate("Document No.", AssignmentMemoHdr."No.");
                AssignmentMemoLine.Validate("From Date", FromDate);
                AssignmentMemoLine.Validate("To Date", ToDate);
                AssignmentMemoLine.Validate("Allowance Amount", 0);
                AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
                AssignmentMemoLine.CalculateAmountForLine();
                AssignmentMemoLine.Insert(true);
            until SourceAssignmentMemoLine.Next() = 0;
    end;

    procedure AllowanceAssignmentmemoOnbeforeSendForApproval(DocNo: Code[20])
    var
        AssignmentMemoHdr, AssignmentMemoHdr2 : Record "Assignment Memo Header";
        OrgStructureList: Record "Organization Structure List";
        OrgwiseATMVault: Record "Orgwise Vaults & ATM";
        AssignmentMemoLine, AssignmentMemoLine2 : Record "Assignment Memo Line";
        DateRec: Record Date;
        TempAssignmentMemoLedger: Record "Temp Assignment Memo Ledger" temporary;
        entryno: Integer;
        VaultNameList, AttributeList : List of [Code[100]];
        VaultName: Code[100];
        CountLimit: Integer;
        PipedAttributeCode: Code[1024];
        AttributeCode: Code[20];
    begin
        //this code execute for a single branch only.

        entryno := 1;
        PipedAttributeCode := '';
        AttributeCode := '';
        Clear(AttributeList);

        AssignmentMemoHdr2.Get(DocNo);
        if AssignmentMemoHdr2."Activity Type" <> AssignmentMemoHdr2."Activity Type"::"Allowance Assignment Memo" then
            exit;

        AssignmentMemoLine2.SetRange("Document No.", AssignmentMemoHdr2."No.");
        if AssignmentMemoLine2.FindSet() then
            repeat
                if not AttributeList.Contains(AssignmentMemoLine2."Payroll Attribute Code") then
                    AttributeList.Add(AssignmentMemoLine2."Payroll Attribute Code");
            until AssignmentMemoLine2.Next() = 0;

        foreach attributeCode in AttributeList do begin
            if AttributeCode <> '' then begin
                if PipedAttributeCode <> '' then
                    PipedAttributeCode += '|';
                PipedAttributeCode += AttributeCode;
            end;
        end;

        OrgStructureList.Get(OrgStructureList.Type::Branch, AssignmentMemoHdr2."Branch Code");
        Clear(VaultNameList);
        TempAssignmentMemoLedger.DeleteAll();

        AssignmentMemoHdr.SetRange("Branch Code", AssignmentMemoHdr2."Branch Code");
        AssignmentMemoHdr.SetRange("Activity Type", AssignmentMemoHdr."Activity Type"::"Allowance Assignment Memo");
        AssignmentMemoHdr.SetFilter("Approval Status", '%1|%2', AssignmentMemoHdr."Approval Status"::Pending, AssignmentMemoHdr."Approval Status"::Approved);
        AssignmentMemoHdr.SetRange("From Date", AssignmentMemoHdr2."From Date", AssignmentMemoHdr2."To date");
        AssignmentMemoHdr.SetRange("To date", AssignmentMemoHdr2."From Date", AssignmentMemoHdr2."To date");
        AssignmentMemoHdr.SetFilter("No.", '<>%1', AssignmentMemoHdr2."No.");
        if AssignmentMemoHdr.FindSet() then
            repeat
                AssignmentMemoLine.SetRange("Document No.", AssignmentMemoHdr."No.");
                AssignmentMemoLine.SetFilter("Payroll Attribute Code", PipedAttributeCode);
                AssignmentMemoLine.SetRange("Substitute of Line No.", 0);  //to avoid counting substitute lines
                if AssignmentMemoLine.FindSet() then
                    repeat
                        if not VaultNameList.Contains(AssignmentMemoLine."Vault Name") then
                            VaultNameList.Add(AssignmentMemoLine."Vault Name");

                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Date);
                        DateRec.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date");
                        if DateRec.FindSet() then
                            repeat
                                TempAssignmentMemoLedger.Init();
                                TempAssignmentMemoLedger."Entry No." := entryno;
                                TempAssignmentMemoLedger."Posting Date" := DateRec."Period Start";
                                TempAssignmentMemoLedger.Insert();
                                TempAssignmentMemoLedger.CopyFromAssignmentMemoLine(AssignmentMemoLine);
                                TempAssignmentMemoLedger.Modify();
                                entryno := entryno + 1;
                            until DateRec.Next() = 0;
                    until AssignmentMemoLine.Next() = 0;

            until AssignmentMemoHdr.Next() = 0;


        //also check for the current assignment memo being sent for approval
        //will enhance the length of code later
        AssignmentMemoLine.Reset();
        AssignmentMemoLine.SetRange("Document No.", AssignmentMemoHdr2."No.");
        AssignmentMemoLine.SetFilter("Payroll Attribute Code", PipedAttributeCode);
        AssignmentMemoLine.SetRange("Substitute of Line No.", 0);  //to avoid counting substitute lines
        if AssignmentMemoLine.FindSet() then
            repeat
                if not VaultNameList.Contains(AssignmentMemoLine."Vault Name") then
                    VaultNameList.Add(AssignmentMemoLine."Vault Name");

                DateRec.Reset();
                DateRec.SetRange("Period Type", DateRec."Period Type"::Date);
                DateRec.SetRange("Period Start", AssignmentMemoLine."From Date", AssignmentMemoLine."To Date");
                if DateRec.FindSet() then
                    repeat
                        TempAssignmentMemoLedger.Init();
                        TempAssignmentMemoLedger."Entry No." := entryno;
                        TempAssignmentMemoLedger."Posting Date" := DateRec."Period Start";
                        TempAssignmentMemoLedger."Document No." := AssignmentMemoLine."Document No.";
                        TempAssignmentMemoLedger.Insert();
                        TempAssignmentMemoLedger.CopyFromAssignmentMemoLine(AssignmentMemoLine);
                        TempAssignmentMemoLedger.Modify();
                        entryno := entryno + 1;
                    until DateRec.Next() = 0;
            until AssignmentMemoLine.Next() = 0;


        DateRec.Reset();
        DateRec.SetRange("Period Type", DateRec."Period Type"::Date);
        DateRec.SetRange("Period Start", AssignmentMemoHdr2."From Date", AssignmentMemoHdr2."To date");
        if DateRec.FindSet() then
            repeat

                //check atm off site limit
                CountLimit := 0;
                TempAssignmentMemoLedger.Reset();
                TempAssignmentMemoLedger.SetRange("Posting Date", DateRec."Period Start");
                TempAssignmentMemoLedger.SetRange("ATM Site", TempAssignmentMemoLedger."ATM Site"::"Off-Site");
                CountLimit := OrgwiseATMVault.GetATMVaultsCountForOrgStruct(OrgStructureList.Code,
                                                  DateRec."Period Start",
                                                  OrgwiseATMVault."ATM Site"::"Off-Site",
                                                  '',
                                                  OrgwiseATMVault.Panel::" ");
                if TempAssignmentMemoLedger.Count() > CountLimit then
                    Error('Number of Off-Site ATM assignment %1 exceeds the limit %2 for date %3', TempAssignmentMemoLedger.Count(), CountLimit, DateRec."Period Start");

                //check atm on site limit
                CountLimit := 0;
                TempAssignmentMemoLedger.Reset();
                TempAssignmentMemoLedger.SetRange("Posting Date", DateRec."Period Start");
                TempAssignmentMemoLedger.SetRange("ATM Site", TempAssignmentMemoLedger."ATM Site"::"On-Site");
                CountLimit := OrgwiseATMVault.GetATMVaultsCountForOrgStruct(OrgStructureList.Code,
                                                  DateRec."Period Start",
                                                  OrgwiseATMVault."ATM Site"::"On-Site",
                                                  '',
                                                  OrgwiseATMVault.Panel::" ");
                if TempAssignmentMemoLedger.Count() > CountLimit then
                    Error('Number of On-Site ATM assignment %1 exceeds the limit %2 for date %3', TempAssignmentMemoLedger.Count(), CountLimit, DateRec."Period Start");


                foreach VaultName in VaultNameList do begin
                    CountLimit := 0;
                    TempAssignmentMemoLedger.Reset();
                    TempAssignmentMemoLedger.SetRange("Posting Date", DateRec."Period Start");
                    TempAssignmentMemoLedger.SetRange("Vault Name", VaultName);
                    TempAssignmentMemoLedger.SetRange(Panel, TempAssignmentMemoLedger.Panel::"Panel A");
                    CountLimit := OrgwiseATMVault.GetATMVaultsCountForOrgStruct(OrgStructureList.Code,
                                                     DateRec."Period Start",
                                                     OrgwiseATMVault."ATM Site"::" ",
                                                     VaultName,
                                                     OrgwiseATMVault.Panel::"Panel A");
                    if TempAssignmentMemoLedger.Count() > CountLimit then
                        Error('Number of Vault Key assignment %1 exceeds the limit %2 for date %3 for %4 panel A', TempAssignmentMemoLedger.Count(), CountLimit, DateRec."Period Start", VaultName);

                    CountLimit := 0;
                    TempAssignmentMemoLedger.Reset();
                    TempAssignmentMemoLedger.SetRange("Posting Date", DateRec."Period Start");
                    TempAssignmentMemoLedger.SetRange("Vault Name", VaultName);
                    TempAssignmentMemoLedger.SetRange(Panel, TempAssignmentMemoLedger.Panel::"Panel B");
                    CountLimit := OrgwiseATMVault.GetATMVaultsCountForOrgStruct(OrgStructureList.Code,
                                                     DateRec."Period Start",
                                                     OrgwiseATMVault."ATM Site"::" ",
                                                     VaultName,
                                                     OrgwiseATMVault.Panel::"Panel B");
                    if TempAssignmentMemoLedger.Count() > CountLimit then
                        Error('Number of Vault Key assignment %1 exceeds the limit %2 for date %3 for %4 panel B', TempAssignmentMemoLedger.Count(), CountLimit, DateRec."Period Start", VaultName);

                end;

            until DateRec.Next() = 0;

        TempAssignmentMemoLedger.DeleteAll();
    end;

    //request allowance section
    procedure OpenAllowance(EmpCode: Code[20]; AllowanceType: code[20]; NepaliMonth: Enum "Nepali Month")
    var
        AssignmentmemoHdr: Record "Assignment Memo Header";
        Approval: Record "Approval HRMS";
        PGSetup: Record "Payroll General Setup";
        Employee: Record Employee;
    begin
        PGSetup.Get();

        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Request Allowance");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();

        Employee.Get(EmpCode);
        AssignmentmemoHdr.Reset();
        AssignmentmemoHdr.SetRange("Employee No.", EmpCode);
        AssignmentmemoHdr.SetRange("Activity Type", AssignmentmemoHdr."Activity Type"::"Request Allowance");
        AssignmentmemoHdr.SetRange("Approval Status", AssignmentmemoHdr."Approval Status"::open);
        AssignmentmemoHdr.SetRange("Payroll Attribute Code", AllowanceType);
        AssignmentmemoHdr.SetRange("Nepali Month", NepaliMonth);
        if AssignmentmemoHdr.Findfirst() then begin
            If GuiAllowed then begin
                Message('This Employee Already has open Allowance Request .Click Ok to Open');
                PAGE.Run(PAGE::"Request Allowance Card", AssignmentmemoHdr)
            end;
        end
        else
            CreateNewAllowanceRequest(EmpCode, AllowanceType, NepaliMonth);
    end;

    procedure CreateNewAllowanceRequest(EmpCode: Code[20]; AllowanceType: Code[20]; NepaliMonth: Enum "Nepali Month")
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        PGSetup: Record "Payroll General Setup";
    begin
        //check for allowance eligibility
        CheckAllowanceELIgibility(EmpCode, AllowanceType);

        PGSetup.Get();

        AssignmentMemoHdr.Init;
        AssignmentMemoHdr.Validate("Employee No.", EmpCode);
        AssignmentMemoHdr.Validate("Activity Type", AssignmentMemoHdr."Activity Type"::"Request Allowance");
        AssignmentMemoHdr.Validate("Payroll Attribute Code", AllowanceType);
        AssignmentMemoHdr.Validate("Nepali Month", NepaliMonth);
        AssignmentMemoHdr.AutoInsertDatesForRequestAllowance();
        AssignmentMemoHdr.Validate("Approval Status", AssignmentMemoHdr."Approval Status"::Open);
        AssignmentMemoHdr.Insert(true);

        CreateAllowanceAssignmentLineFromRequest(AssignmentMemoHdr."No.");
        if GuiAllowed then
            PAGE.Run(PAGE::"request allowance Card", AssignmentMemoHdr);
    end;

    procedure CreateAllowanceAssignmentLineFromRequest(AllowanceAssignmentCode: Code[20])
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AllowanceConfig: Record "Allowance Configuration";
    begin
        if not AssignmentMemoHdr.Get(AllowanceAssignmentCode) then
            exit;
        if AssignmentMemoHdr."Payroll Attribute Code" = '' then
            exit;

        AllowanceConfig.SetRange("Payroll Attribute", AssignmentMemoHdr."Payroll Attribute Code");
        AllowanceConfig.FindFirst();

        case AllowanceConfig.Source of
            AllowanceConfig.Source::Assignment, AllowanceConfig.Source::Shift:
                CreateAllowanceRequestLineFromAssignmentLine(AssignmentMemoHdr, AllowanceConfig.Source);
            AllowanceConfig.Source::Leave:
                CreateAllowanceRequestLineFromApprovedLeave(AssignmentMemoHdr);
        end;
        CreateAllowanceRequestLineForEducation(AssignmentMemoHdr);
    end;

    procedure CreateAllowanceRequestLineForEducation(AllowanceAssignmentHdr: Record "Assignment Memo Header")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        PayrollAttribute: Record "Payroll Attributes";
        LastAssignmentMemoHdr: Record "Assignment Memo Header";
        LastAssignmentMemoLine: Record "Assignment Memo Line";
    begin
        PayrollAttribute.Get(AllowanceAssignmentHdr."Payroll Attribute Code");
        if PayrollAttribute."Specific Attributes" <> PayrollAttribute."Specific Attributes"::"Education Allowance" then
            exit;

        //check if there is pending education allowance request
        LastAssignmentMemoHdr.Reset();
        LastAssignmentMemoHdr.SetRange("Employee No.", AllowanceAssignmentHdr."Employee No.");
        LastAssignmentMemoHdr.SetRange("Activity Type", LastAssignmentMemoHdr."Activity Type"::"Request Allowance");
        LastAssignmentMemoHdr.SetRange("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        LastAssignmentMemoHdr.SetRange("Approval Status", LastAssignmentMemoHdr."Approval Status"::"Pending");
        if not LastAssignmentMemoHdr.IsEmpty() then
            Error('You have pending education allowance request.');

        //get last approved education allowance request
        LastAssignmentMemoHdr.Reset();
        LastAssignmentMemoHdr.SetRange("Employee No.", AllowanceAssignmentHdr."Employee No.");
        LastAssignmentMemoHdr.SetRange("Activity Type", LastAssignmentMemoHdr."Activity Type"::"Request Allowance");
        LastAssignmentMemoHdr.SetRange("Approval Status", LastAssignmentMemoHdr."Approval Status"::Approved);
        LastAssignmentMemoHdr.SetRange("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        LastAssignmentMemoHdr.SetFilter("No.", '<>%1', AllowanceAssignmentHdr."No.");
        if LastAssignmentMemoHdr.FindLast() then begin
            LastAssignmentMemoLine.SetRange("Document No.", LastAssignmentMemoHdr."No.");
            LastAssignmentMemoLine.SetRange(Discontinued, false);
            if LastAssignmentMemoLine.FindSet() then
                repeat
                    Clear(AssignmentMemoLine);
                    AssignmentMemoLine.Init();
                    AssignmentMemoLine := LastAssignmentMemoLine;
                    AssignmentMemoLine.Validate("Document No.", AllowanceAssignmentHdr."No.");
                    AssignmentMemoLine.Validate("From Date", AllowanceAssignmentHdr."From Date");
                    AssignmentMemoLine.Validate("To Date", AllowanceAssignmentHdr."To Date");
                    AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
                    AssignmentMemoLine.Insert(true);
                    AssignmentMemoLine.Validate("Payroll Attribute Code");
                    AssignmentMemoLine.Modify();
                until LastAssignmentMemoLine.Next() = 0;
        end;
    end;

    procedure CreateAllowanceRequestLineFromAssignmentLine(AllowanceAssignmentHdr: Record "Assignment Memo Header"; AllowanceConfigSource: Enum "Allowance Config. Source")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        PayrollAttribute: Record "Payroll Attributes";
        CreateAdjustmentledger: Boolean;
    begin
        //while requesting create a assignment line entry from unclaimed allowance ledger entry
        AssignmentMemoLedgerEntry.SetRange("Employee No.", AllowanceAssignmentHdr."Employee No.");
        AssignmentMemoLedgerEntry.SetRange(Reversed, false);
        AssignmentMemoLedgerEntry.SetRange("Posting Date", AllowanceAssignmentHdr."From Date", AllowanceAssignmentHdr."To Date");

        if AllowanceConfigSource = AllowanceConfigSource::Assignment then
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Allowance Assignment Memo");
        if AllowanceConfigSource = AllowanceConfigSource::Shift then
            AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Shift Assignment Memo");

        if AllowanceAssignmentHdr."Payroll Attribute Code" <> '' then
            AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        AssignmentMemoLedgerEntry.SetRange(Open, true);
        AssignmentMemoLedgerEntry.SetRange(Claimed, false);
        AssignmentMemoLedgerEntry.SetRange("Claimed Doc No.", '');
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoLedgerEntry.CalcFields("Leave Days");
                if AssignmentMemoLedgerEntry."Leave Days" = 0 then begin  //only calim if employee is present or will be present on that date
                    //create assignment memo line
                    Clear(AssignmentMemoLine);
                    AssignmentMemoLine.Init();
                    AssignmentMemoLine.Validate("Document No.", AllowanceAssignmentHdr."No.");
                    AssignmentMemoLine.Validate("Emp Act Type", AllowanceAssignmentHdr."Activity Type");
                    AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
                    AssignmentMemoLine.Insert(true);
                    AssignmentMemoLine.CopyFromAssignmentMemoLedgerEntry(AssignmentMemoLedgerEntry);
                    AssignmentMemoLine.Validate("Payroll Attribute Code");
                    AssignmentMemoLine.Modify();

                    // mark allowance
                    AssignmentMemoLedgerEntry."Claimed Doc No." := AllowanceAssignmentHdr."No.";
                    AssignmentMemoLedgerEntry.Claimed := true;
                    AssignmentMemoLedgerEntry.Modify();
                end;
            until AssignmentMemoLedgerEntry.Next() = 0;

        //
        AssignmentMemoLedgerEntry.Reset();
        AssignmentMemoLedgerEntry.SetRange(Reversed, false);
        AssignmentMemoLedgerEntry.SetRange("Employee No.", AllowanceAssignmentHdr."Employee No.");
        AssignmentMemoLedgerEntry.SetRange("Employee Activity Type", AssignmentMemoLedgerEntry."Employee Activity Type"::"Request Allowance");
        AssignmentMemoLedgerEntry.SetRange("Attendance Checked", false);
        AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", AllowanceAssignmentHdr."Payroll Attribute Code");
        AssignmentMemoLedgerEntry.SetFilter("Posting Date", '<%1', WorkDate() - 1);
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                //check is employee attendance is marked for the allowance request date
                PayrollAttribute.Get(AssignmentMemoLedgerEntry."Payroll Attribute Code");
                AssignmentMemoLedgerEntry.CalcFields("Present Days", "Leave Days", "Leave Days", "Week Off Days", "Absent Days");
                if (AssignmentMemoLedgerEntry."Present Days" > 0) or (AssignmentMemoLedgerEntry."Absent Days" > 0) then begin
                    AssignmentMemoLedgerEntry."Attendance Checked" := true;
                    AssignmentMemoLedgerEntry.Modify();
                    CreateAdjustmentledger := false;
                end
                else if AssignmentMemoLedgerEntry."Week Off Days" > 0 then begin
                    AssignmentMemoLedgerEntry."Attendance Checked" := true;
                    AssignmentMemoLedgerEntry.Modify();
                    if PayrollAttribute."Specific Attributes" = PayrollAttribute."Specific Attributes"::"Holiday Allowance" then
                        CreateAdjustmentledger := true
                    else
                        CreateAdjustmentledger := false;
                end
                else begin
                    CreateAdjustmentledger := true;
                    AssignmentMemoLedgerEntry."Attendance Checked" := true;
                    AssignmentMemoLedgerEntry.Modify();
                end;

                if CreateAdjustmentledger then begin
                    //create opposite ledger line
                    Clear(AssignmentMemoLine);
                    AssignmentMemoLine.Init();
                    AssignmentMemoLine.Validate("Document No.", AllowanceAssignmentHdr."No.");
                    AssignmentMemoLine.Validate("Emp Act Type", AllowanceAssignmentHdr."Activity Type");
                    AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
                    AssignmentMemoLine.Insert(true);

                    AssignmentMemoLine.CopyFromAssignmentMemoLedgerEntry(AssignmentMemoLedgerEntry);
                    AssignmentMemoLine."Allowance Amount" := -AssignmentMemoLedgerEntry.Amount;
                    AssignmentMemoLine.Modify();

                    // no need to mark allowance
                end;
            until AssignmentMemoLedgerEntry.Next() = 0;
    end;

    procedure GenerateIncDocuments(EmpActType: Enum "Employee Activity Type"; No: Code[20]; EmployeeNo: Code[20]; AttachmentCode: Code[20])
    var
        IncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        AttachmentSetup.setfilter(Type, Format(EmpActType));
        if not AttachmentSetup.FindFirst then
            exit;

        IncomingDoc.Init;
        IncomingDoc.Validate(Type, IncomingDoc.Type::" ");
        IncomingDoc.Validate("No.", No);

        IncomingDoc.Validate("Employee Activity Type", EmpActType);
        IncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
        IncomingDoc.Validate(Description, Format(EmpActType) + ': ' + Format(AttachmentSetup."Attachment Code") + '-' + Format(No));
        IncomingDoc.Validate("Employee Code", EmployeeNo);
        if IncomingDoc.Insert(true) then;
    end;

    procedure CheckAttachmentOnBeforeSendForApproval(var AssignmentmemoHdr: Record "Assignment Memo Header")
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
        PayrollAttributes: Record "Payroll Attributes";
    begin
        //for now attachment check only for request allowance
        if AssignmentmemoHdr."Activity Type" <> AssignmentmemoHdr."Activity Type"::"Request Allowance" then
            exit;
        if not PayrollAttributes.Get(AssignmentmemoHdr."Payroll Attribute Code") then
            exit;
        AttachmentSetup.SetRange(Mandatory, true);
        AttachmentSetup.SetFilter(Type, Format(AssignmentmemoHdr."Activity Type"));
        case PayrollAttributes."Specific Attributes" of
            PayrollAttributes."Specific Attributes"::"Education Allowance":
                AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Education Allowance");
            PayrollAttributes."Specific Attributes"::Reimbursement:
                AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::Reimbursement);
            PayrollAttributes."Specific Attributes"::"Remote Area Allowance":
                AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Remote Allowance");
            PayrollAttributes."Specific Attributes"::"OutStation Allowance":
                AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Outstation Allowance");
            else
                AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
        end;
        if AttachmentSetup.FindSet() then
            repeat
                IncomingDoc.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.SetRange("Document No.", AssignmentmemoHdr."No.");
                IncomingDoc.SetRange("Employee Activity Type", AssignmentmemoHdr."Activity Type");
                if IncomingDoc.FindSet() then
                    repeat
                        IF (IncomingDoc."File Name" = '') OR (IncomingDoc."Attachment Code" = '') then
                            Error('Mandatory attachment %1 is missing. Please attach before sending for approval.', AttachmentSetup."Attachment Code");
                    until IncomingDoc.Next() = 0;
            until AttachmentSetup.Next() = 0;
    end;

    procedure ClearAssignmentMemoLedgerDataOnLineReject(ledgerEntryNo: Integer)
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if AssignmentMemoLedgerEntry.Get(ledgerEntryNo) then begin
            AssignmentMemoLedgerEntry."Claimed Doc No." := '';
            AssignmentMemoLedgerEntry.Claimed := false;
            AssignmentMemoLedgerEntry.Modify();
        end;
    end;

    //shift assignment section
    procedure OpenShiftRequest(EmpCode: Code[20])
    var
        AssignmentMemoHdr, AssignmentMemoHdr2 : Record "Assignment Memo Header";
        Approval: Record "Approval HRMS";
        Employee: Record Employee;
    begin
        // Clear Approval line
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Shift Assignment Memo");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();

        Employee.Get(EmpCode);
        AssignmentMemoHdr.Reset();
        AssignmentMemoHdr.SetRange("Employee No.", EmpCode);
        AssignmentMemoHdr.SetRange("Activity Type", AssignmentMemoHdr."Activity Type"::"Shift Assignment Memo");
        AssignmentMemoHdr.SetRange("Approval Status", AssignmentMemoHdr."Approval Status"::open);
        if AssignmentMemoHdr.Findfirst() then begin
            Message('This Employee Already has open Shift Assignment Request.Click Ok to Open');
            PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr)
        end else begin
            AssignmentMemoHdr2.Init;
            AssignmentMemoHdr2.Validate("Activity Type", AssignmentMemoHdr2."Activity Type"::"Shift Assignment Memo");
            AssignmentMemoHdr2.Validate("Approval Status", AssignmentMemoHdr2."Approval Status"::Open);
            AssignmentMemoHdr2.Validate("Employee No.", EmpCode);
            AssignmentMemoHdr2.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Assignment Memo Card", AssignmentMemoHdr2);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approver Mgt", OnApproverejectDocumentOnBeforeCheckApprover, '', false, false)]
    local procedure OnApproverejectDocumentOnBeforeCheckApprover(var RecRef: RecordRef; var EmployeeActivityType: Enum "Employee Activity Type"; var DocumentNo: Code[20]; var ApprovalStatusField: Text)
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        PayCyclePeriod: Record "Pay Cycle Period";
        EmployeeEdit: Record "Employee Edit";
    begin
        case RecRef.Number of
            Database::"Assignment Memo Header":
                begin
                    AssignmentMemoHdr.Get(DocumentNo);

                    //check if within the date
                    PayCyclePeriod.SetFilter("Start Date", '<=%1', AssignmentMemoHdr."From Date");
                    PayCyclePeriod.SetFilter("End Date", '>=%1', AssignmentMemoHdr."To Date");
                    PayCyclePeriod.FindFirst();
                    if PayCyclePeriod."Allowance End Date" <> 0D then
                        if WorkDate() >= PayCyclePeriod."Allowance End Date" then
                            if AssignmentMemoHdr."Activity Type" = AssignmentMemoHdr."Activity Type"::"Request Allowance" then
                                Error('Cannot approve/reject the allowance request as the allowance end date %1 has passed.', PayCyclePeriod."Allowance End Date");

                    if ApprovalStatusField = 'Approved' then begin
                        if (AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending) then begin
                            ApprovalStatusField := 'Pending';
                        end;
                    end;
                end;
            Database::"Employee Edit":
                begin
                    EmployeeEdit.Get(DocumentNo);
                    if EmployeeEdit."Changes In Employee Type" <> EmployeeEdit."Changes In Employee Type"::"Vehicle Info Update" then
                        exit;

                    PayCyclePeriod.SetFilter("Start Date", '<=%1', EmployeeEdit."Requested Date");
                    PayCyclePeriod.SetFilter("End Date", '>=%1', EmployeeEdit."Requested Date");
                    PayCyclePeriod.FindFirst();
                    if PayCyclePeriod."Allowance End Date" <> 0D then
                        if WorkDate() >= PayCyclePeriod."Allowance End Date" then
                            Error('Cannot approve/reject the vehicle update request as the end date %1 has passed.', PayCyclePeriod."Allowance End Date");
                end;
        end;
    end;

    procedure CheckAmountForReimbursement(var AssignmentMemoLine: Record "Assignment Memo Line")
    var
        PayrollAttributes: Record "Payroll Attributes";
        Employee: Record Employee;
        Salarylevel: Record "Salary Level";
    begin
        if not PayrollAttributes.Get(AssignmentMemoLine."Payroll Attribute Code") then
            exit;

        Employee.Get(AssignmentMemoLine."Employee No.");
        Salarylevel.Get(Employee."Salary Level");

        if PayrollAttributes."Specific Attributes" = PayrollAttributes."Specific Attributes"::Reimbursement then begin
            if Employee."Vehicle Type" in [Employee."Vehicle Type"::"Four Wheeler (EV)", Employee."Vehicle Type"::"Two Wheeler (EV)", Employee."Vehicle Type"::" "] then
                Error('You are not eligible to claim Transportation Reimbursement.');

            if Salarylevel.Rank >= GetAMRank() then begin
                if GetAssignmentLineLtr(AssignmentMemoLine."Document No.") > Salarylevel."Fuel Limit (ltr)" then
                    Error('Fuel claimed exceeds the limit of allowable %1 liters.', Salarylevel."Fuel Limit (ltr)");
            end
            else begin
                if GetAssignmentLineAmount(AssignmentMemoLine."Document No.") > Salarylevel."Transportation Allowance" then
                    Error('Reimbursement amount exceeds the limit of allowable Rs. %1.', Salarylevel."Transportation Allowance");
            end;

            if AssignmentMemoLine."Allowance Amount" = 0 then
                Error('Reimbursement amount or fuel claimed must have a value.');
        end;
    end;

    procedure GetAssignmentLineAmount(DocNo: Code[20]): Decimal
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
    begin
        AssignmentMemoLine.SetRange("Document No.", DocNo);
        AssignmentMemoLine.CalcSums("Allowance Amount");
        exit(AssignmentMemoLine."Allowance Amount");
    end;

    procedure GetAssignmentLineLtr(DocNo: Code[20]): Decimal
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
    begin
        AssignmentMemoLine.SetRange("Document No.", DocNo);
        AssignmentMemoLine.CalcSums("Fuel Claimed (ltr)");
        exit(AssignmentMemoLine."Fuel Claimed (ltr)");
    end;

    procedure CheckAllowanceELIgibility(EmpCode: Code[20]; AllowanceType: Code[20])
    var
        Employee: Record Employee;
        Salarylevel: Record "Salary Level";
        PayrollAttributes: Record "Payroll Attributes";
        EmployeeEdit: Record "Employee Edit";
        AllowanceConfig: Record "Allowance Configuration";
    begin
        if EmpCode = '' then
            exit;
        if AllowanceType = '' then
            exit;
        PayrollAttributes.Get(AllowanceType);
        Employee.Get(EmpCode);

        case PayrollAttributes."Specific Attributes" of
            PayrollAttributes."Specific Attributes"::Reimbursement:
                begin
                    Salarylevel.Get(Employee."Salary Level");
                    if Employee."Vehicle Type" in [Employee."Vehicle Type"::"Four Wheeler (EV)", Employee."Vehicle Type"::"Two Wheeler (EV)", Employee."Vehicle Type"::" ", Employee."Vehicle Type"::"No Vehicle"] then
                        Error('You are not eligible to claim Transportation Reimbursement.');

                    EmployeeEdit.SetLoadFields("Employee No.", "Requested Date", "Claim Type", "Vehicle Type", "Approval Status", "Changes In Employee Type");
                    EmployeeEdit.SetCurrentKey("Requested Date");
                    EmployeeEdit.SetRange("Employee No.", EmpCode);
                    EmployeeEdit.SetRange("Changes In Employee Type", EmployeeEdit."Changes In Employee Type"::"Vehicle Info Update");
                    EmployeeEdit.SetRange("Approval Status", EmployeeEdit."Approval Status"::Approved);
                    if EmployeeEdit.FindLast() then begin
                        if EmployeeEdit."Claim Type" <> AllowanceType then
                            Error('You are not eligible to claim %1 as your claim type was updated to %2 on %3.', AllowanceType, EmployeeEdit."Claim Type", EmployeeEdit."Requested Date");
                    end;
                end;

            PayrollAttributes."Specific Attributes"::"Remote Area Allowance",
            payrollAttributes."Specific Attributes"::"OutStation Allowance":
                begin
                    AllowanceConfig.SetRange("Payroll Attribute", AllowanceType);
                    AllowanceConfig.FindFirst();

                    if not AllowanceConfig.IsValidAllowanceConfigurationForEmployee(AllowanceConfig, EmpCode, WorkDate()) then
                        Error('You are not eligible to claim %1 as per the policy.', PayrollAttributes.Description);
                end;
        end;
    end;

    procedure ProcessAssignmentRequestFromCopyTable(var AssignmentMemoHdr: Record "Assignment Memo Header"; var IsHandled: Boolean)
    var
        AssignmentMemoLine, AssignmentMemoLine2 : Record "Assignment Memo Line";
        AssignmentMemoLineCopy: Record "Assignment Memo Line Copy";
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;

        FuelLimit, TempFuelLimit, RemainingFuelLimit : Decimal;
        AmountLimit, TempAmountLimit, RemainingAmountLimit : Decimal;
        FuelClaimed, AmountClaimed : Decimal;
        PayrollAttributes: Record "Payroll Attributes";
        AssignmentmemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        BlockedClaimedAllowance, BlockedFuelAllowance : decimal;
    begin
        //get limit
        if not PayrollAttributes.Get(AssignmentMemoHdr."Payroll Attribute Code") then
            exit;

        if PayrollAttributes."Specific Attributes" <> PayrollAttributes."Specific Attributes"::Reimbursement then
            exit;

        Employee.Get(AssignmentMemoHdr."Employee No.");
        SalaryLevel.Get(Employee."Salary Level");

        if (Employee."Vehicle Type" in [Employee."Vehicle Type"::"Two Wheeler", Employee."Vehicle Type"::"Four Wheeler"])
            and (SalaryLevel.Rank >= GetAMRank()) then begin
            FuelLimit := SalaryLevel."Fuel Limit (ltr)";
            AmountLimit := 0;
        end else begin
            FuelLimit := 0;
            AmountLimit := SalaryLevel."Transportation Allowance";
        end;

        //check limit
        AssignmentMemoLine2.Reset();
        AssignmentMemoLine2.SetRange("Employee No.", AssignmentMemoHdr."Employee No.");
        AssignmentMemoLine2.SetRange("Payroll Attribute Code", AssignmentMemoHdr."Payroll Attribute Code");
        AssignmentMemoLine2.SetFilter("Approval Status", '%1|%2', AssignmentMemoLine2."Approval Status"::Pending, AssignmentMemoLine2."Approval Status"::Approved);
        AssignmentMemoLine2.SetRange("From Date", AssignmentMemoHdr."To date");
        AssignmentMemoLine2.SetRange("To Date", AssignmentMemoHdr."To Date");
        BlockedClaimedAllowance := 0;
        BlockedFuelAllowance := 0;
        if AssignmentMemoLine2.FindSet() then begin
            repeat
                AssignmentmemoLedgerEntry.SetRange("Document No.", AssignmentMemoLine2."Document No.");
                AssignmentmemoLedgerEntry.SetRange("Blocked for Payroll", true);
                if not AssignmentmemoLedgerEntry.IsEmpty() then begin
                    BlockedClaimedAllowance += AssignmentMemoLine2."Allowance Amount";
                    BlockedFuelAllowance += AssignmentMemoLine2."Fuel Claimed (ltr)";
                end;
            until AssignmentMemoLine2.Next() = 0;

            AssignmentMemoLine2.CalcSums("Fuel Claimed (ltr)");
            AssignmentMemoLine2.CalcSums("Allowance Amount");
        end;

        RemainingFuelLimit := FuelLimit - AssignmentMemoLine2."Fuel Claimed (ltr)" + BlockedFuelAllowance;
        RemainingAmountLimit := AmountLimit - AssignmentMemoLine2."Allowance Amount" + BlockedClaimedAllowance;
        if (RemainingFuelLimit <= 0) and (FuelLimit > 0) then
            Error('Fuel claimed exceeds the limit of allowable %1 liters.', FuelLimit);

        if (RemainingAmountLimit <= 0) and (AmountLimit > 0) then
            Error('Reimbursement amount exceeds the limit of allowable Rs. %1.', AmountLimit);

        AssignmentMemoLineCopy.SetCurrentKey("Amount per Ltr.");
        AssignmentMemoLineCopy.SetRange("Document No.", AssignmentMemoHdr."No.");
        AssignmentMemoLineCopy.SetFilter("Amount per Ltr.", '>0');
        AssignmentMemoLineCopy.SetAscending("Amount per Ltr.", false);
        AssignmentMemoLineCopy.CalcSums("Fuel Claimed (ltr)");
        AssignmentMemoLineCopy.CalcSums("Allowance Amount");
        TempFuelLimit := AssignmentMemoLineCopy."Fuel Claimed (ltr)";
        if (TempFuelLimit >= RemainingFuelLimit) and (FuelLimit > 0) then
            TempFuelLimit := RemainingFuelLimit;
        TempAmountLimit := AssignmentMemoLineCopy."Allowance Amount";
        if (TempAmountLimit >= RemainingAmountLimit) and (AmountLimit > 0) then
            TempAmountLimit := RemainingAmountLimit;
        if FuelLimit > 0 then begin
            FuelClaimed := 0;
            AmountClaimed := 0;
            if AssignmentMemoLineCopy.FindSet() then
                repeat
                    if TempFuelLimit - AssignmentMemoLineCopy."Fuel Claimed (ltr)" >= 0 then begin
                        FuelClaimed += AssignmentMemoLineCopy."Fuel Claimed (ltr)";
                        AmountClaimed += AssignmentMemoLineCopy."Allowance Amount";
                        TempFuelLimit -= AssignmentMemoLineCopy."Fuel Claimed (ltr)";
                    end else begin
                        FuelClaimed += TempFuelLimit;
                        AmountClaimed += (TempFuelLimit * AssignmentMemoLineCopy."Amount per Ltr.");
                        TempFuelLimit := 0;
                    end
                until (AssignmentMemoLineCopy.Next() = 0) or (FuelClaimed >= RemainingFuelLimit);
        end
        else begin
            AmountClaimed := 0;
            fuelClaimed := 0;
            if AssignmentMemoLineCopy.FindSet() then
                repeat
                    if TempAmountLimit - AssignmentMemoLineCopy."Allowance Amount" >= 0 then begin
                        AmountClaimed += AssignmentMemoLineCopy."Allowance Amount";
                        FuelClaimed += AssignmentMemoLineCopy."Fuel Claimed (ltr)";
                        TempAmountLimit -= AssignmentMemoLineCopy."Allowance Amount";
                    end else begin
                        AmountClaimed += TempAmountLimit;
                        FuelClaimed += Round((TempAmountLimit / AssignmentMemoLineCopy."Amount per Ltr."), 0.01, '=');
                        TempAmountLimit := 0;
                    end
                until (AssignmentMemoLineCopy.Next() = 0) or (AmountClaimed >= RemainingAmountLimit);
        end;

        if (FuelClaimed = 0) and (AmountClaimed = 0) then
            exit;

        AssignmentMemoLine.Init();
        AssignmentMemoLine.Validate("Document No.", AssignmentMemoHdr."No.");
        AssignmentMemoLine.Validate("Emp Act Type", AssignmentMemoHdr."Activity Type");
        AssignmentMemoLine.Validate("Employee No.", AssignmentMemoHdr."Employee No.");
        AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
        AssignmentMemoLine.Validate("Payroll Attribute Code", AssignmentMemoHdr."Payroll Attribute Code");
        AssignmentMemoLine.Validate("From Date", AssignmentMemoHdr."To Date");
        AssignmentMemoLine.Validate("To Date", AssignmentMemoHdr."To Date");
        AssignmentMemoLine.Validate("Fuel Claimed (ltr)", FuelClaimed);
        AssignmentMemoLine.Validate("Allowance Amount", AmountClaimed);
        AssignmentMemoLine.Insert(true);
    end;

    procedure CreatePayrollAttrUsesOnApprovedAssignmentMemo(var AssignmentMemoHdr: Record "Assignment Memo Header")
    var
        PayrollAtttrUses, PayrollAtttrUses2 : Record "Payroll Attributes Usage";
    begin
        PayrollAtttrUses2.SetRange("Code", AssignmentMemoHdr."Payroll Attribute Code");
        PayrollAtttrUses2.SetRange("Employee Code", AssignmentMemoHdr."Employee No.");
        if PayrollAtttrUses2.IsEmpty() then begin
            PayrollAtttrUses.Init();
            PayrollAtttrUses.Validate("Code", AssignmentMemoHdr."Payroll Attribute Code");
            PayrollAtttrUses.Validate("Employee Code", AssignmentMemoHdr."Employee No.");
            PayrollAtttrUses.Insert(true);
        end;
    end;

    procedure CheckIfOpenMemoLedgerEntriesExist(AssignmentMemoLine: Record "Assignment Memo Line"): Boolean
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        AssignmentMemoLedgerEntry.SetLoadFields("Employee No.", "Employee Activity Type", "Payroll Attribute Code", "Posting Date", Open, Reversed);
        AssignmentMemoLedgerEntry.Setfilter("Employee Activity Type", '%1|%2', AssignmentMemoLedgerEntry."Employee Activity Type"::"Allowance Assignment Memo", AssignmentMemoLedgerEntry."Employee Activity Type"::"Shift Assignment Memo");
        AssignmentMemoLedgerEntry.SetRange(Reversed, false);
        AssignmentMemoLedgerEntry.SetRange("Employee No.", AssignmentMemoLine."Employee No.");
        AssignmentMemoLedgerEntry.SetRange("Payroll Attribute Code", AssignmentMemoLine."Payroll Attribute Code");
        AssignmentMemoLedgerEntry.SetRange("Posting Date", AssignmentMemoLine."From Date");
        AssignmentMemoLedgerEntry.SetRange(Open, true);
        exit(not AssignmentMemoLedgerEntry.IsEmpty());
    end;

    procedure CheckIfAllowanceIsSubstitutedForTheDate(AssignmentMemoHdr: Record "Assignment Memo Header")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        AllowanceConfig: Record "Allowance Configuration";
    begin
        if AssignmentMemoHdr."Activity Type" <> AssignmentMemoHdr."Activity Type"::"Request Allowance" then
            exit;

        AllowanceConfig.SetRange("Payroll Attribute", AssignmentMemoHdr."Payroll Attribute Code");
        AllowanceConfig.SetFilter(Source, '%1|%2', AllowanceConfig.Source::Assignment, AllowanceConfig.Source::Shift);
        if AllowanceConfig.FindFirst() then begin
            AssignmentMemoLine.SetRange("Document No.", AssignmentMemoHdr."No.");
            if AssignmentMemoLine.FindSet() then
                repeat
                    if not CheckIfOpenMemoLedgerEntriesExist(AssignmentMemoLine) then
                        Error('Allowance for %1 is already substituted on %2. Cannot proceed with your allowance request.', AssignmentMemoLine."Payroll Attribute Code", AssignmentMemoLine."From Date");

                    //check if pending substituted exist.
                    CheckIfSubstituteDocumentPendingExist(AssignmentMemoLine);
                until AssignmentMemoLine.Next() = 0;
        end;
    end;

    procedure CheckIfSubstituteDocumentPendingExist(AssignmentMemoLine: Record "Assignment Memo Line")
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
    begin
        if AssignmentMemoLedgerEntry.Get(AssignmentMemoLine."Assign Memo Ledger Entry No.") then begin
            AssignmentMemoHdr.Get(AssignmentMemoLedgerEntry."Document No.");
            if AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending then
                Error('There is a pending substitute assignment. Cannot proceed with your allowance request.Please try again later.');
        end
        // else
        //     Error('Linked allowance assignment not found!');
    end;

    procedure CheckIfPendingClaimedAllowanceExist(DocNo: Code[20]; LineNo: Integer)
    var
        AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        AssignmentMemoLedgerEntry.SetLoadFields("Employee No.", "Employee Activity Type", "Payroll Attribute Code", "Posting Date", Open, Reversed);
        AssignmentMemoLedgerEntry.SetRange("Document No.", DocNo);
        AssignmentMemoLedgerEntry.SetRange(Claimed, true);
        if AssignmentMemoLedgerEntry.FindSet() then
            repeat
                AssignmentMemoHdr.Get(AssignmentMemoLedgerEntry."Claimed Doc No.");
                if AssignmentMemoHdr."Approval Status" = AssignmentMemoHdr."Approval Status"::Pending then
                    Error('There is a pending claimed allowance for %1 on %2. Cannot proceed with substitution.', AssignmentMemoLedgerEntry."Payroll Attribute Code", AssignmentMemoLedgerEntry."Posting Date");
            until AssignmentMemoLedgerEntry.Next() = 0;
    end;

    // TODO: Implement Assignment Memo Reverse
    procedure ReverseAssignmentMemos(DocNo: Code[20])
    var
        AssignemntMemoHeader: Record "Assignment Memo Header";
        AssignemntMemoLedgerEntry: Record "Assignment Memo Ledger Entry";
        AssignmentMemoLine: Record "Assignment Memo Line";
        PostedPayrollHeader: Record "Posted Payroll Header";
        AttendanceMgt: Codeunit "Attendance Mgt";
    begin
        OnBeforeReverseAssignmentMemo(DocNo);
        //get assignment memo header
        if not AssignemntMemoHeader.Get(DocNo) then
            Error('Document %1 not found.', DocNo);
        if AssignemntMemoHeader.Reversed then
            Error('Document %1 is already reversed.', DocNo);
        if AssignemntMemoHeader."Approval Status" <> AssignemntMemoHeader."Approval Status"::Approved then
            Error('Only approved document can be reversed. Document %1 is in %2 status.', DocNo, AssignemntMemoHeader."Approval Status");

        //reverse ledger entries
        if AssignemntMemoHeader."Activity Type" in [AssignemntMemoHeader."Activity Type"::"Allowance Assignment Memo", AssignemntMemoHeader."Activity Type"::"Shift Assignment Memo"] then begin
            //check if claimed
            AssignemntMemoLedgerEntry.SetRange("Document No.", DocNo);
            if AssignemntMemoLedgerEntry.FindSet() then
                repeat
                    if AssignemntMemoLedgerEntry.Claimed then
                        Error('Cannot reverse the assignment %1 as it has been claimed by employee. Reverse the claim first.', DocNo);
                    AssignemntMemoLedgerEntry.Reversed := true;
                    AssignemntMemoLedgerEntry.Open := false;
                    AssignemntMemoLedgerEntry."Blocked for Payroll" := true;
                    AssignemntMemoLedgerEntry.Modify();
                    AttendanceMgt.DailyAttendanceUpdate(AssignemntMemoLedgerEntry."Posting Date", AssignemntMemoLedgerEntry."Posting Date", AssignemntMemoLedgerEntry."Employee No.");
                until AssignemntMemoLedgerEntry.Next() = 0;

        end else if AssignemntMemoHeader."Activity Type" = AssignemntMemoHeader."Activity Type"::"Request Allowance" then begin
            //check if payroll is posted
            AssignemntMemoLedgerEntry.SetRange("Document No.", DocNo);
            AssignemntMemoLedgerEntry.SetFilter("Payroll Document No.", '<>%1', '');
            if AssignemntMemoLedgerEntry.FindSet() then
                repeat
                    if PostedPayrollHeader.Get(AssignemntMemoLedgerEntry."Payroll Document No.") then
                        Error('Cannot reverse the allowance request %1 as payroll for the claimed allowance has been posted in payroll %2. Reverse the payroll first.', DocNo, PostedPayrollHeader."No.");
                until AssignemntMemoLedgerEntry.Next() = 0;
        end;

        //mark lines as reversed
        AssignmentMemoLine.SetRange("Document No.", DocNo);
        if AssignmentMemoLine.FindSet() then
            repeat
                AssignmentMemoLine.Reversed := true;
                AssignmentMemoLine.Modify();
            until AssignmentMemoLine.Next() = 0;

        //mark reversed in header
        AssignemntMemoHeader.Reversed := true;
        AssignemntMemoHeader.Modify();
    end;

    procedure CheckIfValueexistInPipedValue(PipedValues: Text; targetValue: text): Boolean
    var
    begin
        exit(StrPos('|' + PipedValues + '|', '|' + targetValue + '|') > 0);
    end;

    procedure GetAMRank(): Integer
    var
        SalaryLevel: Record "Salary Level";
    begin
        SalaryLevel.SetRange("Is AM", true);
        SalaryLevel.FindFirst();
        exit(SalaryLevel.Rank);
    end;

    procedure ProrateAllowanceAmount(AssignmentMemoLine: Record "Assignment Memo Line"; var AssignmentMemoLedgerEntry: Record "Assignment Memo Ledger Entry")
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
        newamt: Decimal;
        PayrollAttributes: Record "Payroll Attributes";
    begin
        AssignmentMemoHdr.Get(AssignmentMemoLine."Document No.");
        if AssignmentMemoHdr."Effective Date" = 0D then
            exit;

        PayrollAttributes.Get(AssignmentMemoHdr."Payroll Attribute Code");
        if not (PayrollAttributes."Specific Attributes" in
            [PayrollAttributes."Specific Attributes"::"Remote Area Allowance",
             PayrollAttributes."Specific Attributes"::"OutStation Allowance"]) then
            exit;

        if (AssignmentMemoHdr."From Date" < AssignmentMemoHdr."Effective Date") and
        (AssignmentMemoHdr."To date" > AssignmentMemoHdr."Effective Date") then begin

            newamt := AssignmentMemoLine."Allowance Amount" *
                      ((AssignmentMemoHdr."Effective Date" - AssignmentMemoHdr."From Date" + 1) /
                      (AssignmentMemoHdr."To date" - AssignmentMemoHdr."From Date" + 1));

            AssignmentMemoLedgerEntry.Amount := newamt;
        end;
    end;

    procedure CreateAllowanceRequestLineFromApprovedLeave(var AssignmentMemoHdr: Record "Assignment Memo Header")
    var
        LeaveEarn: Record "Leave Earn";
    begin
        LeaveEarn.SetRange("Payroll Attribute", AssignmentMemoHdr."Payroll Attribute Code");
        LeaveEarn.SetRange("Employee No.", AssignmentMemoHdr."Employee No.");
        LeaveEarn.SetRange(Claimed, false);
        LeaveEarn.SetRange("Claimed Document No.", '');
        if LeaveEarn.FindSet() then
            repeat
                //create assignment memo line
                CreateAllowanceRequestLineFromLeaveEarn(AssignmentMemoHdr, LeaveEarn);
            until LeaveEarn.Next() = 0;

    end;

    procedure CreateAllowanceRequestLineFromLeaveEarn(var AssignmentMemoHdr: Record "Assignment Memo Header"; var LeaveEarn: Record "Leave Earn")
    var
        AssignmentMemoLine: Record "Assignment Memo Line";
    begin
        AssignmentMemoLine.Init();
        AssignmentMemoLine.Validate("Document No.", AssignmentMemoHdr."No.");
        AssignmentMemoLine.Validate("Emp Act Type", AssignmentMemoHdr."Activity Type");
        AssignmentMemoLine.Validate("Employee No.", AssignmentMemoHdr."Employee No.");
        AssignmentMemoLine.Validate("Approval Status", AssignmentMemoLine."Approval Status"::Open);
        AssignmentMemoLine.Validate("From Date", AssignmentMemoHdr."To date");
        AssignmentMemoLine.Validate("To Date", AssignmentMemoHdr."To Date");
        AssignmentMemoLine.Validate("Payroll Attribute Code", AssignmentMemoHdr."Payroll Attribute Code");
        AssignmentMemoLine.Validate("Allowance Amount", LeaveEarn."Encashment Amount");
        AssignmentMemoLine.Insert();

        LeaveEarn."Claimed Document No." := AssignmentMemoHdr."No.";
        LeaveEarn.Claimed := true;
        LeaveEarn.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Assignment Memo Header", OnAfterInsertEvent, '', false, false)]
    local procedure OnafterInsertAssignmentMemoHeader(var Rec: Record "Assignment Memo Header")
    var
        AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
        AllowanceConfig, AllowanceConfig2 : Record "Allowance Configuration";
        IsEligibleForShiftAllowance: Boolean;
    begin
        if Rec."Activity Type" = Rec."Activity Type"::"Request Allowance" then begin
            if not GuiAllowed then begin
                CheckAllowanceELIgibility(Rec."Employee No.", Rec."Payroll Attribute Code");
                AssignmentMemoMgt.CreateAllowanceAssignmentLineFromRequest(Rec."No.");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approver Mgt", OnRejectDocumentOnBeforeRecRefModify, '', false, false)]
    local procedure OnRejectDocumentOnBeforeRecRefModify(var RecRef: RecordRef; var Approved: Boolean; var SkipRecRefModifyOnReject: Boolean)
    begin
        if not Approved and (RecRef.Number = Database::"Assignment Memo Header") then
            SkipRecRefModifyOnReject := true;
    end;

    [IntegrationEvent(false, false)]
    local procedure AssignmentMemoOnbeforeSendForApproval(var AssignmentMemoHdr: Record "Assignment Memo Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnafterApproveAssignmentMemo(var AssignmentMemoHdr: Record "Assignment Memo Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure CheckSkipAssignmentLedgerCreation(var AssignmentMemoLine: Record "Assignment Memo Line"; var SkipAssignmentLedgerCreation: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnOtherAllowanceConfigurationCheck(AssignmentMemoLine: Record "Assignment Memo Line"; var AllConfig2: Record "Allowance Configuration"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckDuplicateShiftLine(docNo: Code[20]; lineNo: Integer; fromDate: Date; toDate: Date; empCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReverseAssignmentMemo(docNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAmountCheck(AssignmentMemoLine: Record "Assignment Memo Line"; var SkipCheck: Boolean)
    begin
    end;
}
