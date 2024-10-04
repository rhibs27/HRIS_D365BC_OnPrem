page 33019867 "Resignation Card"
{
    // version NIC Asia1.00

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
                    Editable = true;
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
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
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
                    field("Sub Province Code"; Rec."Sub Province Code")
                    {
                        ToolTip = 'Specifies the value of the Sub Province Code field.';
                        ApplicationArea = All;
                    }
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
                        Caption = 'Proposed Date of Closed of Business Hour';
                        ToolTip = 'Specifies the value of the Proposed Date of Closed of Business Hour field.';
                        ApplicationArea = All;
                    }
                    field("Supervisor Proposed Date"; Rec."Supervisor Proposed Date")
                    {
                        Editable = not DocumentEditable;
                        ToolTip = 'Specifies the value of the Supervisor Proposed Date field.';
                        ApplicationArea = All;
                    }
                    field("Reason Code"; Rec."Reason Code")
                    {
                        ToolTip = 'Specifies the value of the Reason Code field.';
                        ApplicationArea = All;
                    }
                    field("HR Proposed Date"; Rec."HR Proposed Date")
                    {
                        Editable = not DocumentEditable;
                        ToolTip = 'Specifies the value of the HR Proposed Date field.';
                        ApplicationArea = All;
                    }
                    field("Waiver Case"; Rec."Waiver Case")
                    {
                        Editable = not DocumentEditable;
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
                    }
                }
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
            group(Approver)
            {
                Caption = 'Approver';
                field("Recommender Code"; Rec."Recommender Code")
                {
                    Caption = 'Supervisor Code';
                    ToolTip = 'Specifies the value of the Supervisor Code field.';
                    ApplicationArea = All;
                }
                field("Recommender Name"; Rec."Recommender Name")
                {
                    Caption = 'Supervisor Name';
                    ToolTip = 'Specifies the value of the Supervisor Name field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Supervisor Remarks';
                    ToolTip = 'Specifies the value of the Supervisor Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
                field("Screener Remarks"; Rec."Screener Remarks")
                {
                    ToolTip = 'Specifies the value of the Screener Remarks field.';
                    ApplicationArea = All;
                }
            }
            part("Resign Clearance Verifier"; "Document Approver Resignation")
            {
                Caption = 'Resign Clearance Verifier';
                SubPageLink = "Document No." = field("No.");
                Visible = ApprovalSent;
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
                Visible = not ApprovalSent;
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.SendResignationApproval(Rec);
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
                Visible = ApprovalSent;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.ScreenResignationFoResignation(Rec);
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ApprovalSent;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.ApproveRejectResignation(true, Rec);
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ApprovalSent;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.ApproveRejectResignation(false, Rec);
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
                Visible = IsSettled;
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
                    Rec.Validate("Approval Status", Rec."Approval Status"::Settled);
                end;
            }
            action("Document Approval")
            {
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Recommended;
                ToolTip = 'Executes the Document Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocumentApprover: Record "Document Approver";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Recommended);
                    if Confirm('Do you want to approve this resignation.', false) then begin
                        DocumentApprover.Reset;
                        DocumentApprover.SetRange("Document No.", Rec."No.");
                        DocumentApprover.SetRange("Employee No.", HRMgt.GetEmployeeNo);
                        if DocumentApprover.FindFirst then begin
                            DocumentApprover.Validate("Approval Status", DocumentApprover."Approval Status"::Approved);
                            DocumentApprover.Modify;
                        end;
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
                Visible = ApprovalSent;
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
    end;

    var
        EmployeeActivity: Record "Employee Activity";
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt:Codeunit "Resignation Mgt";
        ApprovalSent: Boolean;
        [InDataSet]
        DocumentEditable: Boolean;
        Recommended: Boolean;
        IsSettled: Boolean;
        IsApproved: Boolean;

    local procedure SetLayout()
    begin
        ApprovalSent := not (Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "]);
        DocumentEditable := Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "];
        Recommended := Rec."Approval Status" = Rec."Approval Status"::Recommended;
        IsSettled := Rec."Approval Status" = Rec."Approval Status"::Settled;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
    end;
}
