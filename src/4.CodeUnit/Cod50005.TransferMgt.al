codeunit 50005 "Transfer Mgt."
{
    procedure OpenTransferRequest(EmpCode: Code[20])
    var
        EmpTransfer: Record "Employee Transfer" temporary;
        RequestError: Label 'You are not eligible to request for a transfer.';
        ApprovalEntry: Record "Approval HRMS";
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Employee Transfer");
        ApprovalEntry.SetRange("Employee No", EmpCode);
        ApprovalEntry.SetRange("Document No.", '');
        ApprovalEntry.DeleteAll();
        EmpTransfer.Init;
        EmpTransfer.Validate(Type, EmpTransfer.Type::"Employee Transfer");
        EmpTransfer.Validate("Employee No.", EmpCode);
        EmpTransfer.Validate("Approval Status", EmpTransfer."Approval Status"::Open);
        EmpTransfer.Insert;
        PAGE.Run(PAGE::"Transfer Request Card", EmpTransfer);
    end;

    procedure SendTransferApproval(TempEmpHRtransfer: Record "Employee Transfer" temporary): Boolean
    var
        EmphrTransfer: Record "Employee Transfer";
        ConfirmTransfer: Label 'Do you want to send transfer request ?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        TransferSent: Label 'Transfer request approval has been sent.';
        NoRecommender: Label 'No Recommender Code.';
        NoApprover: Label 'No Approver Code.';
        IncomingDoc: Record "Incoming Document";
        AttachSetup: Record "Attachment Setup";
    begin
        if not GuiAllowed then
            TempEmphrtransfer."Transfer Category" := TempEmphrtransfer."Transfer Category"::General;
        TempEmphrtransfer.TestField(Description);
        TempEmphrtransfer.TestField("Reason for Transfer"); //here reason for transfer
        TempEmphrtransfer.TestField("Transfer Category");
        if TempEmphrtransfer."Transfer Category" = TempEmphrtransfer."Transfer Category"::"Temporary" then begin
            TempEmphrtransfer.TestField("Start Date");
            TempEmphrtransfer.TestField("End Date");
        end;
        EmphrTransfer.Reset;
        EmphrTransfer.SetFilter(Type, '%1|%2', EmphrTransfer.Type::"HR Transfer", EmphrTransfer.Type::"Employee Transfer");
        EmphrTransfer.SetRange("Employee No.", TempEmphrtransfer."Employee No.");
        EmphrTransfer.SetFilter("Approval Status", '%1|%2|%3', EmphrTransfer."Approval Status"::Pending, EmphrTransfer."Approval Status"::Approved, EmphrTransfer."Approval Status"::"On Hold");
        EmphrTransfer.SetFilter("No.", '<>%1', TempEmphrtransfer."No.");
        if EmphrTransfer.FindFirst then
            Error('Transfer No %2 of employee %1 is still not Acknowledge.', EmphrTransfer."Employee Name", EmphrTransfer."No.");
        EmphrTransfer.Reset;
        EmphrTransfer.Init;
        EmphrTransfer.Validate("Requested Date", Today);
        EmphrTransfer.TransferFields(TempEmphrtransfer);
        EmphrTransfer.Validate("Approval Status", EmphrTransfer."Approval Status"::"Pending");
        EmphrTransfer.Validate("User ID", UserId);
        EmphrTransfer.Insert(true);
        HRMgt.SendMailFromTemplate(DATABASE::"Employee Transfer", EmphrTransfer.Type::"Employee Transfer", EmphrTransfer."Approval Status"::Open, EmphrTransfer."Employee No.", EmphrTransfer."No.", false);   //For email
        Message(TransferSent);
        exit(true);
    end;

    procedure ConfirmTransferDetails(Var EmpHrTransfer: Record "Employee Transfer")// to be reviewd
    var
    begin
        HRSetup.Get();
        HRSetup.TestField("HR Department Code");
        if not HrMgt.IsSaaS() then
            Employee.Get(HRMgt.GetEmployeeNo());
        if HRSetup."HR Department Code" <> Employee."Department Code" then
            Error('Only Employee from HR department can confirm transfer Details');
        if Today > EmpHrTransfer."Transfer Effective Date" then
            Error(TransferError, EmpHrTransfer."Transfer Effective Date", Today);
        EmpHrTransfer.TestField("Transfer Category");
        EmpHrTransfer.TestField("Transfer Effective Date");
        EmpHrTransfer.TestField("Functional Title (To)");
        EmpHrTransfer.TestField("Deputation On (To)");
        if EmpHrTransfer.Type = EmpHrTransfer.Type::"Employee Transfer" then
            EmpHrTransfer.TestField(Description);
        EmpHrTransfer.TestField("Transfer Type");
        EmpHrTransfer.TestField("Reason for Transfer");
        EmpHrTransfer.TestField("Incoming Supervisior");
        EmpHrTransfer.TestField("Outgoing Branch Rep. Person");
        // EmpHrTransfer.TestField("Notify to");
        if EmpHrTransfer."Transfer Category" in [EmpHrTransfer."Transfer Category"::"Temporary", EmpHrTransfer."Transfer Category"::Officiating] then begin
            EmpHrTransfer.TestField("Start Date");
            EmpHrTransfer.TestField("End Date");
        end;
        if not HrMgt.IsSaaS() then
            Employee.Get(HRMgt.GetEmployeeNo);
        case EmpHrTransfer."Deputation On (To)" of
            EmpHrTransfer."Deputation On (To)"::Branch:
                EmpHrTransfer.TestField("To Branch");
            EmpHrTransfer."Deputation On (To)"::Department:
                EmpHrTransfer.TestField("Department Code (To)");
            EmpHrTransfer."Deputation On (To)"::"Extension Counter":
                EmpHrTransfer.TestField("Extension Counter (To)");
            EmpHrTransfer."Deputation On (To)"::Province:
                EmpHrTransfer.TestField("Province Code (To)");
            EmpHrTransfer."Deputation On (To)"::Unit:
                EmpHrTransfer.TestField("Unit (To)");
        end;
        EmpHrTransfer.Validate("Is Transfer Details Added", true);
        EmpHrTransfer.Modify();
        HRMgt.SendMailFromTemplate(DATABASE::"Employee Transfer", EmpHrTransfer.Type::"Employee Transfer", EmpHrTransfer."Approval Status"::Approved, EmpHrTransfer.Remarks, EmpHrTransfer."No.", false);
        if EmpHrTransfer."Transfer Effective Date" <= Today then begin
            if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin
                EmployeeRec."Disable Punch in" := true;
                EmployeeRec.Modify;
            end;
        end;
    end;

    procedure HoldTransfer(var EmpHrTransfer: Record "Employee Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        TransferPageBuilder: FilterPageBuilder;
        EmpTransfer: Record "Employee Transfer";
        GetHoldDate, TransferEffectiveDate : Date;
        EmpServiceActivityRec: Record "Employee Service History";
    begin
        EmpHrTransfer.TestField("Approval Status", EmpTransfer."Approval Status"::Approved);
        TransferPageBuilder.AddRecord('Transfer Document', EmpTransfer);
        TransferPageBuilder.ADdField('Transfer Document', EmpTransfer."On Hold Date");
        TransferPageBuilder.AddField('Transfer Document', EmpTransfer."Transfer Effective Date");
        TransferPageBuilder.ADdField('Transfer Document', EmpTransfer."Reason For Hold");
        if TransferPageBuilder.RunModal then begin
            EmpTransfer.SetView(TransferPageBuilder.GetView('Transfer Document'));
            //IF EmpActivity.FindFirst() THEN;
            Evaluate(GetHoldDate, EmpTransfer.GetFilter("On Hold Date"));
            Evaluate(TransferEffectiveDate, EmpTransfer.GetFilter("Transfer Effective Date"));
            if (GetHoldDate = 0D) and (TransferEffectiveDate = 0D) then
                Error('Please enter on date.');
            if EmpTransfer.GetFilter("Reason For Hold") = '' then
                Error('Please enter reason.');
            EmpHrTransfer.Validate("On Hold Date", GetHoldDate);
            EmpHrTransfer.Validate("Transfer Effective Date", TransferEffectiveDate);
            EmpHrTransfer.Validate("Reason For Hold", EmpTransfer.GetFilter("Reason For Hold"));
            EmpHrTransfer.Validate("Approval Status", EmpTransfer."Approval Status"::"On Hold");
            EmpHrTransfer.Modify;
            Message('Document has been put on hold.');
        end;
    end;

    procedure RequestTransferAllowanceClaim(var EmpHrTransfer: Record "Employee Transfer")
    var
        BMandOutStationError: Label 'You cannot apply for both BM Accomodation Allowance and Outstation/Discomfort Allowance.';
        UnauthorizedApprover: Label 'You are not authorized to approve.';
        EmployeeTransfer: Record "Employee Transfer";
        EmployeeTransfer1: Record "Employee Transfer";
        ApprovalMgt: Codeunit "Approver Mgt";
        IsHandled: Boolean;
    begin
        OnBeforeSubmitClaimRequest(EmpHrTransfer, IsHandled);
        EmployeeTransfer1.Get(EmpHrTransfer."Transfer Request No");
        EmployeeTransfer1."Transfer Claim" := true;
        EmployeeTransfer1.Modify();
        // EmployeeTransfer.Init();
        EmployeeTransfer.TransferFields(EmpHrTransfer);
        CheckClaimAttachments(EmployeeTransfer."No.", EmployeeTransfer."Employee No.");
        ApprovalMgt.UpdateFirstApproverStatus(EmployeeTransfer."No.");
        EmployeeTransfer.Validate("Approval Status", EmployeeTransfer."Approval Status"::Pending);
        EmployeeTransfer.Modify();
        if GuiAllowed then
            Message('Document has been sent for approval.');
    end;

    procedure ApproveTransferClaim(transferClaimNo: Code[20])
    var
        TransferClaim: Record "Employee Transfer";
        ServiceHistory: Record "Employee Service History";
        IsHandled: Boolean;
    begin
        TransferClaim.Get(transferClaimNo);
        if TransferClaim."Outstation/Discomfort Allow." <> 0 then begin
            ServiceHistory.Reset;
            ServiceHistory.SetRange("Document No.", TransferClaim."Transfer Request No");
            if ServiceHistory.FindFirst then begin
                ServiceHistory."Outstation Eligible" := true;
                ServiceHistory.Modify;
            end;
        end;
    end;

    procedure RejectTransferClaim(transferClaimNo: Code[20])
    var
        TransferClaim: Record "Employee Transfer";
        TransferClaim2: Record "Employee Transfer";
    begin
        TransferClaim.Get(transferClaimNo);
        if TransferClaim2.Get(TransferClaim."Transfer Request No") then
            TransferClaim2."Transfer Claim" := false;
        TransferClaim2.Modify();
    end;

    procedure CalculateAllowance(var EmpTransfer: Record "Employee Transfer")
    var
        Employee: Record Employee;
        TotalDays: Integer;
        GrossSalary: Decimal;
        SalaryLevel1: Record "Salary Level";
        RemoteArea: Record "Remote Area Category";
        DimensionValue: Record "Dimension Value";
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        IsHandled: Boolean;
    begin
        OnBeforeCalculateAllowance(EmpTransfer, IsHandled);
        if not IsHandled then begin
            EmpTransfer.TestField("Transfer Effective Date");
            TotalDays := CalcDate('CM', EmpTransfer."Transfer Effective Date") - EmpTransfer."Transfer Effective Date";
            EmpTransfer."Relocation Allow." := 0;
            EmpTransfer."Outstation/Discomfort Allow." := 0;
            EmpTransfer."BM Accomodation Allow." := 0;
            EmpTransfer."Remote Area Allow." := 0;
            EmpTransfer."Officiating Allow." := 0;
            //"transfer claim approver" := '';
            // GetTransferClaimApprover(EmpAct);
            EmpTransfer."Relocation Allow." := CalculateRelocationAllowance(EmpTransfer, EmpTransfer."Relocation Distance");
            EmpTransfer."Outstation/Discomfort Allow." := CalculateOutstationAllowance(EmpTransfer, EmpTransfer."Outstation Distance");
            EmpTransfer."BM Accomodation Allow." := CalculateBMAccomodationAllowance(EmpTransfer, EmpTransfer."BMAF Distance");
            EmpTransfer."Officiating Allow." := CalculateOfficiatingAllowance(EmpTransfer);
            EmpTransfer."Remote Area Allow." := CalculateRemoteAreaAllowance(EmpTransfer);
            if GuiAllowed then
                EmpTransfer.Modify;
        end;
    end;

    procedure CalculateRelocationAllowance(var EmpTransfer: Record "Employee Transfer"; relocationDistance: Decimal): Decimal
    var
        DimensionValueCurrent: Record "Dimension Value";
        LevelWiseAttribute: Record "Level Wise Attributes";
    begin
        HRSetup.Get;
        HRSetup.TestField("Relocation Dist. Criteria (H)");
        HRSetup.TestField("Relocation Dist. Criteria (T)");
        Employee.Get(EmpTransfer."Employee No.");
        LevelWiseAttribute.Get(Employee."Salary Grade", Employee."Salary Level");
        if relocationDistance = 0 then begin
            exit(0);
        end;
        if Employee."Inside/Outside Valley" = Employee."Inside/Outside Valley"::Outside then begin
            if Employee."Posting Region" = Employee."Posting Region"::Hilly then begin
                if relocationDistance >= HRSetup."Relocation Dist. Criteria (H)" then
                    exit(LevelWiseAttribute."Total Basic Salary");
            end else if Employee."Posting Region" = Employee."Posting Region"::Terai then begin
                if relocationDistance >= HRSetup."Relocation Dist. Criteria (T)" then
                    exit(LevelWiseAttribute."Total Basic Salary");
            end;
        end;
    end;

    procedure CalculateOutstationAllowance(var EmpTransfer: Record "Employee Transfer"; outStationDistance: Decimal): Decimal
    var
        DimensionValueCurrent: Record "Dimension Value";
        LevelWiseAttribute: Record "Level Wise Attributes";
    begin
        if outStationDistance = 0 then begin
            EmpTransfer."Outstation/Discomfort Allow." := 0;
            exit(0);
        end;
        Employee.Get(EmpTransfer."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit(0);
        HRSetup.Get;
        HRSetup.TestField("Outstation Dist. Criteria (H)");
        HRSetup.TestField("Outstation Dist. Criteria (T)");
        LevelWiseAttribute.Get(Employee."Salary Grade", Employee."Salary Level");
        // TestField("Outstation Distance");
        if Employee."Posting Region" = Employee."Posting Region"::Hilly then begin
            if outStationDistance >= HRSetup."Outstation Dist. Criteria (H)" then
                exit(LevelWiseAttribute."Total Basic Salary" * 25 / 100);
        end else if Employee."Posting Region" = Employee."Posting Region"::Terai then begin
            if outStationDistance >= HRSetup."Outstation Dist. Criteria (T)" then
                exit(LevelWiseAttribute."Total Basic Salary" * 25 / 100);
        end;
    end;

    procedure CalculateBMAccomodationAllowance(var EmpTransfer: Record "Employee Transfer"; BMAFDistance: Decimal): Decimal
    var
        OrganizationStructureListCurrent: Record "Organization Structure List";
        RemoteArea: Record "Remote Area Category";
        PGSetup: Record "Payroll General Setup";
    begin
        if BMAFDistance = 0 then begin
            exit(0);
        end;
        PGSetup.Get;
        PGSetup.TestField("BM Functional Title");
        if EmpTransfer."Functional Title (To)" <> PGSetup."BM Functional Title" then
            exit;
        if OrganizationStructureListCurrent.Get(OrganizationStructureListCurrent.Type::Branch, EmpTransfer."From Branch") then
            if not OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, EmpTransfer."To Branch") then
                exit;
        if OrganizationStructureListCurrent."InsideOutside Valley" = OrganizationStructureListCurrent."InsideOutside Valley"::Inside then
            if OrganizationStructureList."InsideOutside Valley" = OrganizationStructureList."InsideOutside Valley"::Inside then
                exit(0);
        HRSetup.Get;
        HRSetup.TestField("BMAF Dist. Criteria (H)");
        HRSetup.TestField("BMAF Dist. Criteria (T)");
        if RemoteArea.Get(OrganizationStructureList."Remote Area Category") then begin
            if OrganizationStructureList."InsideOutside Valley" = OrganizationStructureList."InsideOutside Valley"::Outside then begin
                //  TestField("BMAF Distance");
                if OrganizationStructureList."Region" = OrganizationStructureList."Region"::Hilly then begin
                    if BMAFDistance >= HRSetup."BMAF Dist. Criteria (H)" then
                        exit(RemoteArea."BM Accomodation Amount");
                end else if OrganizationStructureList."Region" = OrganizationStructureList."Region"::Terai then begin
                    if BMAFDistance >= HRSetup."BMAF Dist. Criteria (T)" then
                        exit(RemoteArea."BM Accomodation Amount");
                end;
            end;
        end;
    end;

    procedure CalculateOfficiatingAllowance(var EmpTransfer: Record "Employee Transfer"): Decimal
    var
        OrganizationStructureListCurrent: Record "Organization Structure List";
        SalaryLevel1: Record "Salary Level";
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
    begin
        Employee.Get(EmpTransfer."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit(0);
        if EmpTransfer."Transfer Type" <> EmpTransfer."Transfer Type"::"Intra Provincial" then
            exit(0);
        Employee.Get(EmpTransfer."Employee No.");
        SalaryLevel.Get(Employee."Salary Level");
        SalaryLevel1.Reset;
        SalaryLevel1.SetCurrentKey(Rank);
        SalaryLevel1.SetFilter(Rank, '>%1', SalaryLevel.Rank);
        if SalaryLevel1.FindFirst then begin
            SalaryGrade.Get(0);
            GrossSalary := SalaryLevel1."Basic Salary" +
                            SalaryLevel1.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel1."Basic Salary";
            exit(GrossSalary);
        end;
    end;

    procedure CalculateRemoteAreaAllowance(var EmpTransfer: Record "Employee Transfer"): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        RemoteArea: Record "Remote Area Category";
        RemoteAreaAllowance: Decimal;
    begin
        if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, EmpTransfer."To Branch") then begin
            if RemoteArea.Get(OrganizationStructureList."Remote Area Category") then begin
                Employee.Get(EmpTransfer."Employee No.");
                SalaryLevel.Get(Employee."Salary Level");
                SalaryGrade.Get(Employee."Salary Grade");
                GrossSalary := SalaryLevel."Basic Salary" +
                                  SalaryLevel.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel."Basic Salary";
                RemoteAreaAllowance := RemoteArea."Remote allowance Percentage" / 100 * GrossSalary;
                if RemoteArea."Remote Allowance Amount" < EmpTransfer."Remote Area Allow." then
                    RemoteAreaAllowance := RemoteArea."Remote Allowance Amount";
                exit(RemoteAreaAllowance);
            end;
        end;
    end;

    procedure AcknowledgeTransfer(var EmpHrTransfer: Record "Employee Transfer")
    var
        ConfirmAcknowledge: Label 'Do you want to acknowledge this transfer?';
        Acknowledged: Label 'Acknowledged.';
        IncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        ServiceHistoryCode: Code[20];
        ServiceHistory: Record "Employee Service History";
    begin
        if GuiAllowed then
            if not Confirm(ConfirmAcknowledge, false) then
                exit;
        EmpHrTransfer.TestField(TakeOver, true);
        if not (EmpHrTransfer."Approval Status" in [EmpHrTransfer."Approval Status"::Approved, EmpHrTransfer."Approval Status"::"On Hold"]) and not EmpHrTransfer.Handover then
            Error('Approval Status must be approved or on hold');
        if not HrMgt.IsSaaS() then
            if EmpHrTransfer."Incoming Supervisior" <> HRMgt.GetEmployeeNo then
                Error('You are not Eligible for Employee Acknowledge');
        EmpHrTransfer.TestField("Date of Joining Of Transfer");
        EmpHrTransfer.TestField("Transfer Remarks");
        EmpHrTransfer.Validate("Acknowledged Date", Today);
        IF EmpHrTransfer."Transfer Category" = "Transfer Category"::"Temporary" THEN //Santosh Add Service History After Transfe Approved and acknowledge>>
            ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(EmpHrTransfer."No.", ServiceHistory."Service Event"::"Temporary Deputation", EmpHrTransfer.Remarks, EmpHrTransfer."Date of Joining Of Transfer");
        IF EmpHrTransfer."Transfer Category" = "Transfer Category"::Officiating THEN
            ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(EmpHrTransfer."No.", ServiceHistory."Service Event"::"Officiating Arrangement", EmpHrTransfer.Remarks, EmpHrTransfer."Date of Joining Of Transfer");
        IF EmpHrTransfer."Transfer Category" = "Transfer Category"::General THEN
            ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(EmpHrTransfer."No.", ServiceHistory."Service Event"::Transfer, EmpHrTransfer.Remarks, EmpHrTransfer."Date of Joining Of Transfer");
        //checking for attachment mandatory
        if EmpHrTransfer."Date of Joining Of Transfer" > Today then
            Error('You Cannot Acknowledge Before Date of Joining');
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Transfer");
        AttachmentSetup.SetFilter(Subtype, '%1|%2', AttachmentSetup.Subtype::Acknowledge, AttachmentSetup.Subtype::" ");
        AttachmentSetup.SetRange("Transfer Category", EmpHrTransfer."Transfer Category");
        AttachmentSetup.SetRange(Mandatory, true);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.SetRange("No.", EmpHrTransfer."No.");
                IncomingDoc.SetRange("File Name", '');
                if IncomingDoc.FindFirst then
                    Error('Attachment file not Uploaded for attachment %1', AttachmentSetup."Attachment Code");
            until AttachmentSetup.Next = 0;
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Acknowledged);
        EmpHrTransfer.Modify;
        if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin
            case EmpHrTransfer."Deputation On (To)" of
                EmpHrTransfer."Deputation On (To)"::Branch:
                    begin
                        EmployeeRec.Validate("Deputation on", EmpHrTransfer."Deputation On (To)");
                        EmployeeRec.Validate("Deputation On Code", EmpHrTransfer."To Branch");
                        EmployeeRec.Validate("Province Code", EmpHrTransfer."Province Code (To)");
                        EmployeeRec.Validate("Branch Code", EmpHrTransfer."To Branch");
                        if EmpHrTransfer."Extension Counter (To)" <> '' then
                            EmployeeRec.Validate("Extension Counter Code", EmpHrTransfer."Extension Counter (To)");
                    end;
                EmpHrTransfer."Deputation On (To)"::Department:
                    begin
                        EmployeeRec.Validate("Deputation on", EmpHrTransfer."Deputation On (To)");
                        EmployeeRec.Validate("Deputation On Code", EmpHrTransfer."Department Code (To)");
                        EmployeeRec.Validate("Department Code", EmpHrTransfer."Department Code (To)");
                        if EmpHrTransfer."Unit (To)" <> '' then
                            EmployeeRec.Validate("Unit Code", EmpHrTransfer."Unit (To)");
                    end;
                EmpHrTransfer."Deputation On (To)"::Province:
                    begin
                        EmployeeRec.Validate("Deputation on", EmpHrTransfer."Deputation On (To)");
                        EmployeeRec.Validate("Deputation On Code", EmpHrTransfer."Province Code (To)");
                        EmployeeRec.Validate("Province Code", EmpHrTransfer."Province Code (To)");
                    end;
            end;
            EmployeeRec.Validate("Approver Role", EmpHrTransfer."Approver Role To");
            EmployeeRec.Validate("Functional Title", EmpHrTransfer."Functional Title (To)");
        end;
        OnAfterTransferAcknowledge(EmpHrTransfer, EmployeeRec);
        EmployeeRec.Modify;
        Message(Acknowledged);
        HRMgt.SendMailFromTemplate(DATABASE::"Employee Transfer", EmpHrTransfer.Type::"Employee Transfer", EmpHrTransfer."Approval Status"::Acknowledged, EmpHrTransfer."Incoming Supervisior", EmpHrTransfer."No.", false);
    end;

    procedure OpenTransferClaim(EmpCode: Code[20]; TransferOrderNo: Code[20])
    var
        EmployeeTransfer, EmployeeTransfer2 : Record "Employee Transfer";
        Approval: Record "Approval HRMS";
    begin
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::"Transfer Claim");
        Approval.SetRange("Employee No", EmpCode);
        Approval.DeleteAll();
        EmployeeTransfer2.Reset();
        EmployeeTransfer2.SetRange("Employee No.", EmpCode);
        EmployeeTransfer2.SetRange("Transfer Request No", TransferOrderNo);
        EmployeeTransfer2.SetRange("Approval Status", EmployeeTransfer2."Approval Status"::open);
        if EmployeeTransfer2.Findfirst() then begin
            Message('This Employee Already has open Transfer claim Request.Click Ok to Open');
            PAGE.Run(PAGE::"Transfer Claim Form", EmployeeTransfer2)
        end else begin
            EmployeeTransfer2.get(TransferOrderNo);
            EmployeeTransfer2.TestField("Approval Status", EmployeeTransfer2."Approval Status"::Acknowledged);
            EmployeeTransfer.Init;
            EmployeeTransfer.TransferFields(EmployeeTransfer2);
            EmployeeTransfer."No." := '';
            EmployeeTransfer."Approved Date" := 0D;
            EmployeeTransfer.Validate("Transfer Request No", EmployeeTransfer2."No.");
            EmployeeTransfer.Validate(Type, EmployeeTransfer.Type::"Transfer Claim");
            EmployeeTransfer.Validate("Approval Status", EmployeeTransfer."Approval Status"::Open);
            EmployeeTransfer.Validate(Status, '');
            EmployeeTransfer.Validate("Requested Date", Today);
            EmployeeTransfer.Insert(true);
            Commit();
            PAGE.Run(PAGE::"Transfer Claim Form", EmployeeTransfer);
        end;
    end;

    procedure HandoverApprove(var EmpHrTransfer: Record "Employee Transfer")
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Approved);
        EmpHrTransfer.TestField("Is Transfer Details Added", true);

        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Transfer");
        AttachmentSetup.setfilter(Subtype, '%1|%2', AttachmentSetup.Subtype::Handover, AttachmentSetup.Subtype::" ");
        AttachmentSetup.SetRange(Mandatory, true);
        if AttachmentSetup.FindFirst() then begin
            IncomingDocument.Reset;
            IncomingDocument.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
            IncomingDocument.SetRange("No.", EmpHrTransfer."No.");
            IncomingDocument.SetRange("File Name", '');
            if IncomingDocument.FindFirst then
                Error('Attachment file not Uploaded for attachment %1', AttachmentSetup."Attachment Code");
        end;

        if not HrMgt.IsSaaS() then
            if (EmpHrTransfer."Employee No.") <> (HRMgt.GetEmployeeNo) then
                Error('You arenot Eligible')
            else begin
                EmpHrTransfer.Validate(Handover, true);
                EmpHrTransfer.Modify();
                if GuiAllowed then
                    Message('Handover Submitted Successfully');
            end;
    end;

    procedure TakeoverApprove(var EmpHrTransfer: Record "Employee Transfer")
    var
        IncomingDocument: Record "Incoming Document";
    begin
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Approved);
        EmpHrTransfer.TestField(Handover, true);
        if not HrMgt.IsSaaS() then
            if (EmpHrTransfer."Outgoing Branch Rep. Person") <> (HRMgt.GetEmployeeNo) then
                Error('You are not Eligible')
            else begin
                EmpHrTransfer.Validate(Takeover, true);
                EmpHrTransfer.Modify();
                if GuiAllowed then
                    Message('Takeover Successfull');
            end
    end;

    procedure CheckClaimAttachments(EmpActNo: Code[20]; EmpNo: Code[20])
    var
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", EmpNo);
        TempIncomingDoc.SetRange("No.", EmpActNo);
        if TempIncomingDoc.FindSet() then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange("Attachment Code", TempIncomingDoc."Attachment Code");
                AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Transfer Claim");
                AttachmentSetup.SetRange("Transfer Claim Attributes", TempIncomingDoc."Transfer Claim Attributes");
                if AttachmentSetup.FindFirst then begin
                    if AttachmentSetup.Mandatory then
                        if TempIncomingDoc."File Name" = '' then
                            Error('Attachment for %1 must be uploaded', AttachmentSetup."Attachment Code");
                end;
            until TempIncomingDoc.Next = 0;
    end;

    procedure CancelTransfer(var EmpHrTransfer: Record "Employee Transfer")
    var
        ApprovalStatus: Enum "Approval Status";
    begin
        if (EmpHrTransfer."Approval Status" in [ApprovalStatus::Approved, ApprovalStatus::"On Hold"]) then begin
            if EmpHrTransfer."Approval Status" <> EmpHrTransfer."Approval Status"::Acknowledged then begin
                EmpHrTransfer.TestField("Reason For Cancel");
                EmpHrTransfer.Validate("Cancelled Date", Today);
                EmpHrTransfer.Validate(EmpHrTransfer."Approval Status", EmpHrTransfer."Approval Status"::Canceled);
                EmpHrTransfer.Modify();
                if GuiAllowed then
                    Message('Transfer is cancelled');
            end;
        end else
            Error('Approval status must be in Approved or Onhold');
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCalculateAllowance(Var TransferClaim: Record "Employee Transfer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeSubmitClaimRequest(Var TransferClaim: Record "Employee Transfer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterTransferAcknowledge(var transfer: Record "Employee Transfer"; Var Employee: Record Employee)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterTransferJournalPost(var TransferEmployeeJournalACK: Record "Employee Activity Journal"; var TransferRequest: Record "Employee Transfer")
    begin
    end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        Employee1: Record Employee;
        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        EmployeeRec: Record Employee;
        OverTimeMgt: Codeunit "OverTime Mgt";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        OrganizationStructureList: Record "Organization Structure List";
        TransferError: Label 'You cannot Approve HR Transfer of Effective Date %1 in %2.';
}
