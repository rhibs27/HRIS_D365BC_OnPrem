page 50206 "Medical Insurance Claim"
{
    PageType = Card;
    SourceTable = "Medical Insurance Claim";
    ApplicationArea = All;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group("Employee Details")
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.';
                    ApplicationArea = All;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    Caption = 'Job Title';
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Visible = not SkipApproval;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    Editable = false;
                    Visible = StatusView;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contact No. field';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Insurance Status"; Rec."Insurance Status")
                {
                    ToolTip = 'Specifies the value of the Insurance Status field.';
                    ApplicationArea = All;
                    Visible = IsPending;
                }
                field("Batch Id"; Rec."Batch Id")
                {
                    ToolTip = 'Specifies the value of the Batch Id field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = not IsOpen;
                }
                field("Reimbursed Amount"; Rec."Reimbursed Amount")
                {
                    ToolTip = 'Specifies the Value of the Reimbursed Amount field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = not IsOpen;
                }
                field("HR Remarks"; Rec."HR Remarks")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
            }
            group("Insurance Details")
            {
                Editable = IsOpen;
                field("Insurance Claim"; Rec."Insurance Claim")
                {
                    ToolTip = 'Specifies the value of the Insurance Claim field.';
                    ApplicationArea = All;
                }
                field("Insured Name"; Rec."Insured Name")
                {
                    ToolTip = 'Specifies the value of the Insured Name field.';
                    ApplicationArea = All;
                }
                field(Relation; Rec.Relation)
                {
                    Caption = 'Relation';
                    ToolTip = 'Specifies the value of the Relation field';
                }
                field("Total Insurance Claim Amount"; Rec."Total Insurance Claim Amount")
                {
                    ToolTip = 'Specifies the value of the Total Insurance Claim Amount field.';
                    ApplicationArea = All;
                }
                field("Medical Prescription Date"; Rec."Medical Prescription Date")
                {
                    ToolTip = 'Specifies the value of the Medical Prescription Date field.';
                    ApplicationArea = All;
                }
                field("Medical Prescription Date (BS)"; Rec."Medical Prescription Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Medical Prescription Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Discharge Date"; Rec."Discharge Date")
                {
                    ToolTip = 'Specifies the value of the Discharge Date field.';
                    ApplicationArea = All;
                }
                field("Discharge Date (BS)"; Rec."Discharge Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Discharge Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Policy Start Date"; Rec."Policy Start Date")
                {
                    ToolTip = 'Specifies the value of the Policy Start Date field.';
                    ApplicationArea = All;
                }
                field("Policy Start Date (BS)"; Rec."Policy Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Policy Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Policy End Date"; Rec."Policy End Date")
                {
                    ToolTip = 'Specifies the value of the Policy End Date field.';
                    ApplicationArea = All;
                }
                field("Policy End Date (BS)"; Rec."Policy End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Policy End Date (BS) field.';
                    ApplicationArea = All;
                }

            }
            part(Attachment; "Attachment Subform")
            {
                Editable = IsOpen;
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                Visible = not SkipApproval;
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Send Approve Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsOpen;
                ToolTip = 'Executes the Send Request to DTMD action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    InsuranceMgt.SendMedicalInsuranceApproval(Rec);
                    Message('Medical Insurance Claim request has been sent.');
                    CurrPage.Update();
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending and not SkipApproval;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Message('Medical Insurance Claim is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                Visible = IsPending and IsSubmittedHRD;

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."HR Remarks" = '' then
                            Error('HR Remarks is Empty')
                        else begin
                            if not HRSetup."Skip Medical Approval Setup" then
                                ApprovalMgt.ApproveRejectDocument(RecRef, false)
                            else begin
                                Rec.TestField("HR Remarks");
                                Rec."Insurance Status" := Rec."Insurance Status"::Rejected;
                                Rec."Approval Status" := Rec."Approval Status"::Rejected;
                                Rec.Modify();
                            end;
                            Message('Medical Insurance Claim is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            // action(Screen)
            // {
            //     Image = Approve;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Visible = false;
            //     ToolTip = 'Executes the Screen action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         InsuranceMgt.ScreenMedicalInsurance(Rec);
            //         CurrPage.Close();
            //     end;
            // }
            action("Send to Insurance Company")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsSubmittedHRD;
                ToolTip = 'Forwards this medical insurance claim to the insurance company.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ApprovalRequestSent: Label 'Insurance Claim to company has been sent.';
                    FilterPageBuilder: FilterPageBuilder;
                    EnteredBatchId: Integer;
                    BatchIdFilter: Text;
                begin
                    FilterPageBuilder.AddRecord('Medical Insurance Claim', Rec);
                    FilterPageBuilder.AddField('Medical Insurance Claim', Rec."Batch Id");

                    if FilterPageBuilder.RunModal() then begin
                        BatchIdFilter := FilterPageBuilder.GetView('Medical Insurance Claim');
                        Rec.SetView(BatchIdFilter);
                        BatchIdFilter := Rec.GetFilter("Batch Id");

                        if BatchIdFilter = '' then
                            Error('Batch ID must not be empty before sending to the insurance company.');

                        Evaluate(EnteredBatchId, BatchIdFilter);
                        Rec."Batch Id" := EnteredBatchId;

                        Rec.SetRange("Batch Id");

                        // HRMgt.SendMailFromTemplate(Database::"Medical Insurance Claim", EmpAct.Type::"Medical Insurance Claim", EmpAct."Approval Status"::Rejected, '', EmpAct."Employee No.", EmpAct."No.", 0);   //For email
                        Rec.Validate("Insurance Status", Rec."Insurance Status"::"Forwarded to Insurance Co.");
                        Rec.Modify;
                        Message(ApprovalRequestSent);
                        CurrPage.Update(false);
                    end;
                end;
            }
            // action(Reimbursed)
            // {
            //     Image = Approve;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Visible = ApproveReject;
            //     ToolTip = 'Executes the Reimbursed action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         InsuranceMgt.ApproveRejectMedicalInsurance(true, Rec);
            //     end;
            // }
            action(Reimbursed)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ApproveReject;
                ToolTip = 'Executes the Reimbursed action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    FilterPageBuilder: FilterPageBuilder;
                    ReimbursedAmount: Decimal;
                    FilterText: Text;
                begin
                    if Rec."Insurance Status" <> Rec."Insurance Status"::"Forwarded to Insurance Co." then
                        Error('Insurance Status must be Forwarded to Insurance Co.', Rec."No.");
                    FilterPageBuilder.AddRecord('Reimbursed', Rec);
                    FilterPageBuilder.AddField('Reimbursed', Rec."Reimbursed Amount");
                    if FilterPageBuilder.RunModal() then begin
                        FilterText := FilterPageBuilder.GetView('Reimbursed');
                        Rec.SetView(FilterText);
                        FilterText := Rec.GetFilter("Reimbursed Amount");
                        if FilterText = '' then
                            Error('Reimbursed Amount cannot be blank');

                        if not Evaluate(ReimbursedAmount, FilterText) then
                            Error('Invalid value entered for Reimbursed Amount.');

                        if ReimbursedAmount <= 0 then
                            Error('Reimbursed Amount must be greater than zero.');

                        Rec.Validate("Reimbursed Amount", ReimbursedAmount);
                        Rec.Validate("Approval Status", Rec."Approval Status"::Approved);
                        Rec.Validate("Insurance Status", Rec."Insurance Status"::Reimbursed);
                        Rec.Modify(true);
                    end;
                end;
            }
            action("Return Request")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Return;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Return Request action.';
                Visible = IsPending;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to return this insurance?', false) then
                        exit;
                    if not HRSetup."Skip Medical Approval Setup" then
                        ApprovalMgt.ReopenDocument(RecRef)
                    else begin
                        InsuranceMgt.TestfieldReturnRequest(Rec);
                    end;
                    Message('Request Returned');
                    CurrPage.Update(false);
                end;
            }
            action("Rejected by Insurance Company")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ApproveReject;
                ToolTip = 'Executes the Rejected by Insurance Company action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    InsuranceMgt.ApproveRejectMedicalInsurance(false, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()

    begin
        HRSetup.Get();
        SetLayout();
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        InsuranceMgt: Codeunit "Insurance Mgt";
        ApprovalMgt: Codeunit "Approver Mgt";
        ApproveReject: Boolean;
        IsOpen: Boolean;
        IsPending: Boolean;
        IsApproved: Boolean;
        StatusView: Boolean;
        IsRejected: Boolean;
        ApprovalStatusView: Boolean;
        RecRef: RecordRef;
        NameFieldVisible: Boolean;
        NameCaptionTxt: Text;
        HRSetup: Record "Human Resources Setup";
        SkipApproval, IsInsuranceCoRejected, IsSubmittedHRD : Boolean;

    procedure SetLayout()
    begin
        IsPending := rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApproved := rec."Approval Status" = rec."Approval Status"::Approved;
        IsRejected := rec."Approval Status" = rec."Approval Status"::Rejected;
        SkipApproval := HRSetup."Skip Medical Approval Setup";
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);
        // ApprovalSent := Rec."Insurance Status" in [Rec."Insurance Status"::" ", Rec."Insurance Status"::"Request to DTMD"];
        ApproveReject := Rec."Insurance Status" = Rec."Insurance Status"::"Forwarded to Insurance Co.";
        IsSubmittedHRD := Rec."Insurance Status" = Rec."Insurance Status"::"Submitted to HRD";
        IsInsuranceCoRejected := Rec."Insurance Status" = Rec."Insurance Status"::Rejected;
    end;
}
