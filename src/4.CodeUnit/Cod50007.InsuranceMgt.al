codeunit 50007 "Insurance Mgt"
{
    procedure OpenMedicalInsurancePage(EmployeeCode: Code[20])
    var
        MedicalInsurance: Record "Medical Insurance Claim";
    begin
        Employee.Get(EmployeeCode);
        if Employee.Status <> Employee.Status::Active then
            Error('Employee is not active.');
        MedicalInsurance.Reset;
        MedicalInsurance.SetRange("Employee No.", EmployeeCode);
        MedicalInsurance.SetRange(Type, MedicalInsurance.Type::"Medical Insurance Claim");
        MedicalInsurance.SetRange("Approval Status", MedicalInsurance."Approval Status"::Open);
        if MedicalInsurance.FindFirst then begin
            Message('This Employee Already has open Leave Request.Click Ok to Open');
            PAGE.Run(PAGE::"Medical Insurance Claim", MedicalInsurance);
        end
        else begin
            MedicalInsurance.Init;
            MedicalInsurance.Validate(Type, MedicalInsurance.Type::"Medical Insurance Claim");
            MedicalInsurance.Validate("Employee No.", EmployeeCode);
            MedicalInsurance.Validate("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
            MedicalInsurance.Validate("Approval Status", MedicalInsurance."Approval Status"::Open);
            MedicalInsurance.Insert(true);
            PAGE.Run(PAGE::"Medical Insurance Claim", MedicalInsurance);
        end;
    end;

    procedure SendMedicalInsuranceApproval(var medicalInsuranceClaim: Record "Medical Insurance Claim")
    var
        MedicalInsurance: Record "Medical Insurance Claim";
        IncomingDoc: Record "Incoming Document";

    begin
        medicalInsuranceClaim.TestField("Insurance Claim");
        medicalInsuranceClaim.TestField("Medical Prescription Date");
        medicalInsuranceClaim.TestField("Discharge Date");
        medicalInsuranceClaim.TestField("Total Insurance Claim Amount");
        medicalInsurance.Reset();
        MedicalInsurance.SetRange("Employee No.", medicalInsuranceClaim."Employee No.");
        MedicalInsurance.SetRange(Type, MedicalInsurance.Type::"Medical Insurance Claim");
        MedicalInsurance.SetRange("Approval Status", MedicalInsurance."Approval Status"::Pending);
        if MedicalInsurance.FindFirst then
            Error('This Employee Already has Pending Medical Insurance Claim Request.');
        IncomingDoc.Reset();
        IncomingDoc.SetRange("No.", medicalInsuranceClaim."No.");
        if IncomingDoc.Findset() then begin
            if incomingDoc."File Name" = '' then      //attachment mandatory for leave
                Error('Attachment must be uploaded');
        end;
        if GuiAllowed then begin
            ApproverMgt.UpdateFirstApproverStatus(medicalInsuranceClaim."No.");
            medicalInsuranceClaim.Validate("Approval Status", medicalInsuranceClaim."Approval Status"::"Pending");
            medicalInsuranceClaim.Modify();
        end;
    end;

    procedure CancelMedicalInsuranceApproval(var EmpAct: Record "Employee Activity")
    var
        ConfirmCancel: Label 'Do you want to confirm cancel resignation request?';
    begin
        EmpAct.TestField("Approval Status", EmpAct."Approval Status"::Pending);
        if not Confirm(ConfirmCancel, false) then
            exit;
        EmpAct.Validate("Approval Status", EmpAct."Approval Status"::Canceled);
        EmpAct.Modify(true);
    end;

    procedure ApproveRejectMedicalInsurance(Approve: Boolean; var MedicalInsurance: Record "Medical Insurance Claim")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        if Approve then begin
            if not Confirm(ConfirmApprove, false) then
                exit;
            if MedicalInsurance."Insurance Status" = MedicalInsurance."Insurance Status"::"Forwarded to Insurance Co." then begin
                MedicalInsurance.Validate("Insurance Status", MedicalInsurance."Insurance Status"::Reimbursed);
                // HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", MedicalInsurance.Type::"Medical Insurance Claim", MedicalInsurance."Approval Status"::Open, '', MedicalInsurance."Employee No.", MedicalInsurance."No.", 0);   //For email
                Message('Insurance Claim reimbursement has been sent.');
            end;
        end
        else begin
            if not Confirm(ConfirmReject, false) then
                exit;
            MedicalInsurance.Validate("Insurance Status", MedicalInsurance."Insurance Status"::Rejected);
        end;

        MedicalInsurance.Modify;
    end;

    procedure ScreenMedicalInsurance(var Medicalinsurance: Record "Medical Insurance Claim")
    var
        ConfirmScreen: Label 'Do you want to confirm screen this document?';
    begin
        //check authorized user
        if Medicalinsurance."Insurance Status" = Medicalinsurance."Insurance Status"::"Request to DTMD" then begin

            if not HrMgt.IsSaaS() then
                Employee.Get(HRMgt.GetEmployeeNo());

            if not Confirm(ConfirmScreen, false) then
                exit;
            Medicalinsurance.Validate("Insurance Status", Medicalinsurance."Insurance Status"::"Forwarded to Insurance Co.");
            Medicalinsurance.Modify;
        end;
    end;

    procedure OpenEmployeeInsurance(EmployeeCode: Code[20])
    var
        Approval: Record "Approval HRMS";
        EmployeeInsurance, EmployeeInsurance1 : Record "Employee Insurance Information";
    begin
        Clear(Employee);
        // Clear Approval line 
        Approval.Reset();
        Approval.SetRange("Document No.", '');
        Approval.setRange("Document Type", Approval."Document Type"::Insurance);
        Approval.SetRange("Employee No", EmployeeCode);
        Approval.DeleteAll();

        Employee.Get(EmployeeCode);
        EmployeeInsurance.Reset();
        EmployeeInsurance.SetRange("Employee No.", EmployeeCode);
        EmployeeInsurance.SetRange("Approval Status", EmployeeInsurance."Approval Status"::open);
        if EmployeeInsurance.Findfirst() then begin
            Message('This Employee Already has open Insurance Request.Click Ok to Open');
            PAGE.Run(PAGE::"Employee Insurance Card", EmployeeInsurance)
        end else begin
            EmployeeInsurance1.Init;
            EmployeeInsurance1.Validate("Employee No.", EmployeeCode);
            EmployeeInsurance1.Validate(Type, EmployeeInsurance1.Type::Insurance);
            EmployeeInsurance1.Validate("Approval Status", EmployeeInsurance1."Approval Status"::Open);
            EmployeeInsurance1.Validate("Requested Date", Today);
            EmployeeInsurance1.Insert(true);
            if GuiAllowed then
                PAGE.Run(PAGE::"Employee Insurance Card", EmployeeInsurance1);
        end;
    end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        ApproverMgt: Codeunit "Approver Mgt";


}
