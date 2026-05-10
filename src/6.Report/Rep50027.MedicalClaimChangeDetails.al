report 50027 MedicalClaimChangeDetails
{
    Caption = 'Medical Claim Change Details';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(grpAction)
                {
                    Caption = 'Select Action';

                    field("Insurance Status"; InsuranceStatus)
                    {
                        Caption = 'Action';
                        ApplicationArea = All;
                        ShowMandatory = true;
                        ToolTip = 'Select the action to perform on the selected Medical Insurance Claim records.';

                        trigger OnValidate()
                        begin
                            UpdateFieldVisibility();
                        end;
                    }
                }

                group(grpSendToInsurance)
                {
                    Caption = 'Send to Insurance Company';
                    Visible = ShowSendToInsuranceCom;

                    field(BatchId; BatchId)
                    {
                        Caption = 'Batch ID';
                        ApplicationArea = All;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the Batch ID to assign when sending claims to the insurance company.';

                        trigger OnValidate()
                        begin
                            if BatchId <= 0 then
                                Error('Batch ID must be a positive number.');
                        end;
                    }
                }

                group(grpReimbursed)
                {
                    Caption = 'Reimbursement Details';
                    Visible = ShowReimbursement;

                    field(ReimbursedAmount; ReimbursedAmount)
                    {
                        Caption = 'Reimbursed Amount';
                        ApplicationArea = All;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the amount to be reimbursed to the employee.';

                        trigger OnValidate()
                        begin
                            if ReimbursedAmount <= 0 then
                                Error('Reimbursed Amount must be greater than zero.');
                        end;
                    }
                }

                group(grpReject)
                {
                    Caption = 'Reject Submission';
                    Visible = ShowRejectSubmitRequest;

                    field(RejectionReason; RejectionReason)
                    {
                        Caption = 'Rejection Reason';
                        ApplicationArea = All;             // Bug #10 fix: missing ApplicationArea
                        ShowMandatory = true;
                        ToolTip = 'Specifies the reason for rejecting this insurance claim submission.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            UpdateFieldVisibility();
        end;
    }

    trigger OnPreReport()
    begin
        // Validate mandatory request-page inputs BEFORE touching any record.
        ValidateMandatoryFields();

        // ClaimNos is populated by the List page via SetClaimNos() before Run().
        // Bug #1/#2/#4/#5 fix: replaced the non-existent Report.SetSelectionFilter()
        // pattern with a pipe-delimited string injected from the calling page.
        // This is the correct cross-boundary pattern for multi-record selection
        // in a ProcessingOnly report in AL.
        if ClaimNos = '' then
            Error('No claim numbers were passed to this report. Please select records from the list and try again.');

        ProcessClaims();
    end;

    var
        InsuranceStatus: Enum "Insurance Status";
        BatchId: Integer;
        ReimbursedAmount: Decimal;
        RejectionReason: Text[250];
        ShowSendToInsuranceCom: Boolean;
        ShowReimbursement: Boolean;
        ShowRejectSubmitRequest: Boolean;
        // Bug #7 fix: removed the meaningless global SelectedRec record variable.
        // The record set is now passed as a pipe-separated string of No. values.
        ClaimNos: Text;

    // -------------------------------------------------------
    //  Public setter — called from the List page BEFORE Run().
    //  Receives a pipe-separated string of Claim No. values,
    //  e.g.  'MIC-0001|MIC-0002|MIC-0003'
    // -------------------------------------------------------
    procedure SetClaimNos(Nos: Text)
    begin
        ClaimNos := Nos;
    end;

    // -------------------------------------------------------
    //  Visibility helper
    // -------------------------------------------------------
    local procedure UpdateFieldVisibility()
    begin
        ShowSendToInsuranceCom := (InsuranceStatus = InsuranceStatus::"Forwarded to Insurance Co.");
        ShowReimbursement := (InsuranceStatus = InsuranceStatus::Reimbursed);
        ShowRejectSubmitRequest := (InsuranceStatus = InsuranceStatus::Rejected);
    end;

    // -------------------------------------------------------
    //  Guard — validate mandatory request-page inputs
    // -------------------------------------------------------
    local procedure ValidateMandatoryFields()
    begin
        case InsuranceStatus of
            InsuranceStatus::"Forwarded to Insurance Co.":
                if BatchId <= 0 then
                    Error('Batch ID is mandatory and must be a positive number for "Send to Insurance Company".');

            InsuranceStatus::Reimbursed:
                if ReimbursedAmount <= 0 then
                    Error('Reimbursed Amount is mandatory and must be greater than zero.');

            InsuranceStatus::Rejected:
                if RejectionReason = '' then
                    Error('A Rejection Reason is mandatory when rejecting a submission.');

            else
                Error('Please select a valid Action before proceeding.');
        end;
    end;

    // -------------------------------------------------------
    //  Main dispatcher — walks the injected pipe-delimited
    //  claim number list and processes each record.
    // -------------------------------------------------------
    local procedure ProcessClaims()
    var
        MedicalClaimRec: Record "Medical Insurance Claim";
        ClaimNo: Code[20];
        RemainingNos: Text;
        Pos: Integer;
        Processed: Integer;
        Errors: Text;
    begin
        Processed := 0;
        Errors := '';
        RemainingNos := ClaimNos;

        // Walk the pipe-delimited list one token at a time.
        repeat
            Pos := StrPos(RemainingNos, '|');
            if Pos > 0 then begin
                ClaimNo := CopyStr(RemainingNos, 1, Pos - 1);
                RemainingNos := CopyStr(RemainingNos, Pos + 1);
            end else begin
                ClaimNo := CopyStr(RemainingNos, 1, MaxStrLen(ClaimNo));
                RemainingNos := '';
            end;

            if ClaimNo <> '' then begin
                if MedicalClaimRec.Get(ClaimNo) then begin
                    // Bug #8 fix: TryFunction isolates each record's failure.
                    // One bad record does not roll back or abort the others.
                    if not TryProcessSingleClaim(MedicalClaimRec) then
                        Errors += StrSubstNo('  - %1: %2\', ClaimNo, GetLastErrorText());
                    Processed += 1;
                end else
                    Errors += StrSubstNo('  - %1: Record not found.\', ClaimNo);
            end;
        until RemainingNos = '';

        // Bug #6 fix: single summary dialog instead of one popup per record.
        if Errors = '' then
            Message('%1 claim(s) processed successfully.', Processed)
        else
            Message('%1 claim(s) attempted.\nErrors:\n%2', Processed, Errors);
    end;

    // -------------------------------------------------------
    //  Per-record logic — [TryFunction] captures runtime
    //  errors so callers can inspect GetLastErrorText().
    // -------------------------------------------------------
    [TryFunction]
    local procedure TryProcessSingleClaim(var MedicalClaimRec: Record "Medical Insurance Claim")
    begin
        case InsuranceStatus of

            InsuranceStatus::"Forwarded to Insurance Co.":
                begin
                    if MedicalClaimRec."Insurance Status" <> MedicalClaimRec."Insurance Status"::Rejected then
                        Error('Insurance Status is Rejected.');
                    MedicalClaimRec.Validate("Batch Id", BatchId);
                    MedicalClaimRec.Validate(
                        "Insurance Status",
                        MedicalClaimRec."Insurance Status"::"Forwarded to Insurance Co.");
                    MedicalClaimRec.Modify(true);
                end;

            InsuranceStatus::Reimbursed:
                begin
                    if MedicalClaimRec."Insurance Status" <> MedicalClaimRec."Insurance Status"::"Forwarded to Insurance Co." then
                        Error('Insurance Status must be Forward to Insurance Co.');
                    MedicalClaimRec.Validate("Reimbursed Amount", ReimbursedAmount);
                    MedicalClaimRec.Validate(
                        "Insurance Status",
                        MedicalClaimRec."Insurance Status"::Reimbursed);
                    MedicalClaimRec.Modify(true);
                end;

            InsuranceStatus::Rejected:
                begin
                    MedicalClaimRec.Validate("Rejection Remarks", RejectionReason);
                    MedicalClaimRec.Validate(
                        "Insurance Status",
                        MedicalClaimRec."Insurance Status"::Rejected);
                    MedicalClaimRec.Modify(true);
                end;
        end;
    end;
}
