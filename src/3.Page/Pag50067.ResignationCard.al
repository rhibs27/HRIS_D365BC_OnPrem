page 50067 "Resignation Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Resignation";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Visible = ApprovalStatusView;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                // field(Remarks; Rec.Remarks)
                // {
                //     Caption = 'Supervisor Remarks';
                //     ToolTip = 'Specifies the value of the Supervisor Remarks field.';
                //     ApplicationArea = All;
                // }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                    Visible = StatusView;
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
            }
            group(Placements)
            {
                group("Current Placement")
                {
                    Editable = false;
                    field("Extension Counter Code"; Rec."Extension Counter Code")
                    {
                        ToolTip = 'Specifies the value of the Extension Counter Code field.';
                        ApplicationArea = All;
                    }
                    field("Functional Title"; Rec."Functional Title")
                    {
                        ToolTip = 'Specifies the value of the Functional Title field.';
                        ApplicationArea = All;
                    }
                    field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                    {
                        ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                        ApplicationArea = All;
                    }
                    // field("Sub Province Code"; Rec."Sub Province Code")
                    // {
                    //     ToolTip = 'Specifies the value of the Sub Province Code field.';
                    //     ApplicationArea = All;
                    // }
                    field("Province Code"; Rec."Province Code")
                    {
                        ToolTip = 'Specifies the value of the Province Code field.';
                        ApplicationArea = All;
                    }
                    field("Unit Code"; Rec."Unit Code")
                    {
                        ToolTip = 'Specifies the value of the Unit Code field.';
                        ApplicationArea = All;
                    }
                    field(Department; Rec.Department)
                    {
                        ToolTip = 'Specifies the value of the Department field.';
                        ApplicationArea = All;
                    }
                    field("Compensatory Days"; Rec."Compensatory Days")
                    {
                        ToolTip = 'Specifies the value of the Compensatory Days field.';
                        ApplicationArea = All;
                    }
                    field("Payroll No."; Rec."Payroll No.")
                    {
                        ToolTip = 'Specifies the value of the Payroll No. field.';
                        ApplicationArea = All;
                    }
                    field(Ecosystem; Rec.Ecosystem)
                    {
                        ToolTip = 'Specifies the value of the Ecosystem field.';
                        ApplicationArea = All;
                    }
                    field("Office Code"; Rec."Office Code")
                    {
                        ToolTip = 'Specifies the value of the Office Code field.';
                        ApplicationArea = All;
                    }
                }
                group("Resignation Details")
                {
                    Caption = 'Resignation Details';
                    field("Proposed Date of Resignation"; Rec."Proposed Date of Resignation")
                    {
                        // Caption = 'Proposed Date of Closed of Business Hour';
                        ToolTip = 'Specifies the value of the Proposed Date of Closed of Business Hour field.';
                        ApplicationArea = All;
                        Editable = IsOpen;
                    }
                    // field("Supervisor Proposed Date"; Rec."Supervisor Proposed Date")
                    // {
                    //     Editable = not DocumentEditable;
                    //     ToolTip = 'Specifies the value of the Supervisor Proposed Date field.';
                    //     ApplicationArea = All;
                    // }
                    field("Reason Code"; Rec."Reason Code")
                    {

                        ToolTip = 'Specifies the value of the Reason Code field.';
                        ApplicationArea = All;
                        Editable = IsOpen;
                    }
                    field("HR Proposed Date"; Rec."HR Proposed Date")
                    {
                        Editable = IsPending;
                        ToolTip = 'Specifies the value of the HR Proposed Date field.';
                        ApplicationArea = All;
                    }
                    field("Waiver Case"; Rec."Waiver Case")
                    {
                        Editable = IsOpen;
                        ToolTip = 'Specifies the value of the Waiver Case field.';
                        ApplicationArea = All;
                    }
                    field("Apply for Waiver"; Rec."Apply for Waiver")
                    {
                        Editable = Rec."Waiver Case" = Rec."Waiver Case"::Recovery;
                        ToolTip = 'Specifies the value of the Apply for Waiver field.';
                        ApplicationArea = All;
                    }
                    field("Reason for Waiver"; Rec."Reason for Waiver")
                    {
                        Editable = Rec."Waiver Case" = Rec."Waiver Case"::Recovery;
                        ToolTip = 'Specifies the value of the Reason for Waiver field.';
                        ApplicationArea = All;
                    }
                    field("Reason for Resignation"; Rec."Reason for Resignation")
                    {
                        ToolTip = 'Specifies the value of the Reason for Resignation field.';
                        ApplicationArea = All;
                        Editable = IsOpen;
                    }
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
            part(Attachment; "Attachment Subform")
            {
                Visible = IsApproved;
                SubPageLink = "No." = field("No."),
                                "Employee Code" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = All;
            }
            // group(Approver)
            // {
            //     Caption = 'Approver';
            // field("Recommender Code"; Rec."Recommender Code")
            // {
            //     Caption = 'Supervisor Code';
            //     ToolTip = 'Specifies the value of the Supervisor Code field.';
            //     ApplicationArea = All;
            // }
            // field("Recommender Name"; Rec."Recommender Name")
            // {
            //     Caption = 'Supervisor Name';
            //     ToolTip = 'Specifies the value of the Supervisor Name field.';
            //     ApplicationArea = All;
            // }

            // field("Screener Remarks"; Rec."Screener Remarks")
            // {
            //     ToolTip = 'Specifies the value of the Screener Remarks field.';
            //     ApplicationArea = All;
            // }
            // }

            part("Resign Clearance Verifier"; "Document Approver Resignation")
            {
                Caption = 'Resign Clearance Verifier';
                SubPageLink = "Document No." = field("No.");
                Visible = IsApproved;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsOpen;
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.SendResignationApproval(Rec);
                    IsApplied := true;
                    CurrPage.Close();
                end;
            }
            action("Cancel Resignation Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Resignation Request action.';
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    ResignationMgt.CancelResignationApproval(Rec);
                end;
            }
            action(Screen)
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // Visible = ApprovalSent;
                Visible = false;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.ScreenResignation(Rec);
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
                        Message('Resignation is Approved by %1', HRMgt.GetEmpName());
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
                Visible = IsPending;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Resignation is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action("Forward to HR")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Forward to HR action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    ResignationMgt.ForwardToHRForResignation(Rec);
                end;
            }
            action(Settlement)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                // Visible = IsSettled;
                ToolTip = 'Executes the Settlement action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    EmployeeActivity.Reset;
                    EmployeeActivity.SetRange(Type, EmployeeActivity.Type::Resignation);
                    EmployeeActivity.SetRange("Employee No.", Rec."Employee No.");
                    if EmployeeActivity.FindFirst then
                        Report.Run(Report::Settlement, true, true, EmployeeActivity);
                end;
            }
            action("Settle Resignation")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved;
                ToolTip = 'Executes the Settle Resignation action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // Rec.Validate("Approval Status", Rec."Approval Status"::Settled);
                end;
            }
            action("Document Approval")
            {
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // Visible = Recommended;
                Visible = IsApproved;
                ToolTip = 'Executes the Document Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocumentApprover: Record "Document Approver";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to approve this resignation.', false) then begin
                        DocumentApprover.Reset;
                        DocumentApprover.SetRange("Document No.", Rec."No.");
                        DocumentApprover.SetRange("Employee No.", HRMgt.GetEmployeeNo);
                        DocumentApprover.SetRange("Approval Status", DocumentApprover."Approval Status"::Open);
                        if DocumentApprover.FindFirst then begin
                            DocumentApprover.Validate("Approval Status", DocumentApprover."Approval Status"::Approved);
                            DocumentApprover.Modify;
                            Message('Resignation Document is Approved by %1', HRMgt.GetEmpName());
                        end else
                            Error('You arenot Eligible To Approve');
                    end;
                end;
            }
            action("Return Resignation")
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // Visible = ApprovalSent;
                Visible = false;
                ToolTip = 'Executes the Return Resignation action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.ReturnResignation(Rec);
                end;
            }
            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Print action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Resignation Memo", true, false, Rec);
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
        SetLayout();
        if IsOpen then
            ApprovalMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::Resignation);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF NOT IsApplied and IsOpen THEN
            IF NOT CONFIRM('The data will be erased. Do you want to continue?', TRUE) THEN
                ERROR('')
            else begin
                Approval.Reset();
                Approval.SetRange("Document No.", '');
                Approval.setRange("Document Type", Approval."Document Type"::Resignation);
                Approval.SetRange("Employee No", Rec."Employee No.");
                Approval.DeleteAll();
            end;
    end;

    var
        EmployeeActivity: Record "Employee Activity";
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        ApprovalSent: Boolean;
        [InDataSet]
        //DocumentEditable: Boolean;
        IsRejected: Boolean;
        IsPending: Boolean;
        IsApproved: Boolean;
        IsOpen: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        RecRef: RecordRef;
        ApprovalMgt: Codeunit "Approver Mgt";
        Approval: Record "Approval HRMS";
        IsApplied: Boolean;


    local procedure SetLayout()
    begin
        ApprovalSent := not (Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "]);
        //DocumentEditable := Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "];
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        RecRef.GetTable(Rec);
        if IsRejected then
            CurrPage.Editable := false;
    end;
}
