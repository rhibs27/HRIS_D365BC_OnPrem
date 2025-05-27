page 50206 "Medical Insurance Claim"
{
    PageType = Card;
    SourceTable = "Medical Insurance Claim";
    ApplicationArea = All;

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
                    Visible = ApprovalStatusView;
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
                field(Remarks; Rec.Remarks)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = IsPending;
                    Visible = IsPending;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }

                field("Insurance Status"; Rec."Insurance Status")
                {
                    ToolTip = 'Specifies the value of the Insurance Status field.';
                    ApplicationArea = All;
                    Visible = IsApproved;
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
                field("Father Name"; Rec."Father Name")
                {
                    ToolTip = 'Specifies the value of the Father Name field.';
                    ApplicationArea = All;
                }
                field("Mother Name"; Rec."Mother Name")
                {
                    ToolTip = 'Specifies the value of the Mother Name field.';
                    ApplicationArea = All;
                }
                field("Spouse Name"; Rec."Spouse Name")
                {
                    ToolTip = 'Specifies the value of the Spouse Name field.';
                    ApplicationArea = All;
                }
                field("Child Name"; Rec."Child Name")
                {
                    ToolTip = 'Specifies the value of the Child Name field.';
                    ApplicationArea = All;
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
                field("Discharge Date"; Rec."Discharge Date")
                {
                    ToolTip = 'Specifies the value of the Discharge Date field.';
                    ApplicationArea = All;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
            }
            part(Attachment; "Attachment Subform")
            {
                Editable = IsOpen;
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
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
                    CurrPage.Close();
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
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
                Visible = IsPending;

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
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
                Visible = IsApproved;
                ToolTip = 'Executes the Send to Insurance Company action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                    EmpAct: Record "Employee Activity";
                    ApprovalRequestSent: Label 'Insurance Claim email to company has been sent.';
                begin
                    if Rec."Insurance Status" = Rec."Insurance Status"::Screened then begin
                        HRMgt.SendMailFromTemplate(Database::"Employee Activity", EmpAct.Type::"Medical Insurance Claim", EmpAct."Approval Status"::Rejected, '', EmpAct."Employee No.", EmpAct."No.", 0);   //For email
                        Message(ApprovalRequestSent);
                        Rec.Validate("Insurance Status", Rec."Insurance Status"::"Forwarded to Insurance Co.");
                        Rec.Modify;
                    end;
                    CurrPage.Close();
                end;
            }
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
                begin
                    InsuranceMgt.ApproveRejectMedicalInsurance(true, Rec);
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

    var
        HRMgt: Codeunit "HR Mgt.";
        InsuranceMgt: Codeunit "Insurance Mgt";
        ApprovalMgt: Codeunit "Approver Mgt";
        ApprovalSent: Boolean;
        ApproveReject: Boolean;
        IsOpen: Boolean;
        IsPending: Boolean;
        IsApproved: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        RecRef: RecordRef;

    procedure SetLayout()
    begin
        IsPending := rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApproved := rec."Approval Status" = rec."Approval Status"::Approved;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);
        // ApprovalSent := Rec."Insurance Status" in [Rec."Insurance Status"::" ", Rec."Insurance Status"::"Request to DTMD"];
        ApproveReject := Rec."Insurance Status" = Rec."Insurance Status"::"Forwarded to Insurance Co.";
    end;
}
