page 50149 "Allowance Assignment Card"
{
    // DelayedInsert = true;
    PageType = Card;
    SourceTable = "Allowance Assignment Header";
    ApplicationArea = All;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Week; Rec.Week)
                {
                    ToolTip = 'Specifies the value of the Week field.';
                    ApplicationArea = All;
                }
                field("English Month"; Rec."English Month")
                {
                    ToolTip = 'Specifies the value of the English Month field.';
                    ApplicationArea = All;
                }
                field("English Year"; Rec."English Year")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the English Year field.';
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To date"; Rec."To date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the To date field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Change Approver Remarks"; Rec."Change Approver Remarks")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Change Approver Remarks field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Allowance Type Filter"; Rec."Allowance Type Filter")
                {
                    ToolTip = 'Specifies the value of the Allowance Type Filter field.';
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        SetLayout();
                    end;
                }
            }
            part(AllowanceSubform; "Allowance Assignment Subform")
            {
                SubPageLink = "No." = field("No."),
                              Code = field(Code),
                              Type = field(Type);
                UpdatePropagation = Both;
                ApplicationArea = All;
                Editable = IsOpen;
            }
            // group(Approval)
            // {
            //     Editable = FormEditable;

            // field("Approver ID"; Rec."Approver ID")
            // {
            //     ToolTip = 'Specifies the value of the Approver ID field.';
            //     ApplicationArea = All;
            // }
            // }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                "Employee No" = field("Employee No."),
                                "Document Type" = field("Activity Type");
                ApplicationArea = all;
            }
        }
        area(FactBoxes)
        {
            part(Control19; "Allowance Factbox")
            {
                SubPageLink = "Entry No. Filter" = field("No."),
                              "Branch Filter" = field(Code);
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
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;
                Visible = IsOpen;
                trigger OnAction()
                var
                // LoanMgt: Codeunit "Loan Mgt.";
                begin
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    AllowanceLine.Reset;
                    AllowanceLine.SetRange("No.", Rec."No.");
                    if Confirm('Do you want to send approval request?', false) then
                        AllowanceMgt.SendApprovalAllowanceAssignment(Rec, AllowanceLine);
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Request action.';
                ApplicationArea = All;
                // Visible = IsApprove;
                Visible = false;

                trigger OnAction()
                begin
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    // AllowanceLine.Reset;
                    // AllowanceLine.SetRange("No.", Rec."No.");
                    // if Confirm('Do you want to cancel the document?', false) then
                    //     AllowanceMgt.SendApprovalAllowanceAssignment(Rec, AllowanceLine, false);
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                Visible = IsPending;
                trigger OnAction()
                begin
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    //AllowanceLine.RESET;
                    //AllowanceLine.SETRANGE("Entry No.", "Entry No.");
                    if Confirm('Do you want to approve the document?', false) then
                        ApproverMgt.ApproveRejectDocument(RecRef, true)
                    // AllowanceMgt.ApproveRejectAllowanceAssignment(true, Rec."No.");
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
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    //AllowanceLine.RESET;
                    //AllowanceLine.SETRANGE("Entry No.", "Entry No.");
                    if Confirm('Do you want to reject the document?', false) then
                        ApproverMgt.ApproveRejectDocument(RecRef, false)
                    // AllowanceMgt.ApproveRejectAllowanceAssignment(false, Rec."No.");
                end;
            }
            // action("Return Request")
            // {
            //     ToolTip = 'Executes the Return Request action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         if Confirm('Do you want to return this document?', false) then
            //             AllowanceMgt.ApproveRejectAllowanceAssignment(false, Rec."No.");
            //     end;
            // }
            // action(ChangeApprover)
            // {
            //     Image = ChangeCustomer;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Executes the ChangeApprover action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         if Confirm('Do you want changes approver?', false) then begin
            //             LoanMgt.PopUpChangingApproverAllowance(Rec);
            //         end;
            //     end;
            // }
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
        AllowanceLine: Record "Allowance Assignment Line";
        FormEditable: Boolean;
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
        Employee: Record Employee;
        ApproverMgt: Codeunit "Approver Mgt";
        IsPending: Boolean;
        IsOpen: Boolean;
        IsApprove: Boolean;
        RecRef: RecordRef;

    local procedure SetLayout()
    begin
        CurrPage.AllowanceSubform.Page._SetFilter(Rec."Allowance Type Filter");
        FormEditable := rec."Approval Status" = rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApprove := Rec."Approval Status" = rec."Approval Status"::Approved;
        RecRef.GetTable(Rec);
        // Employee.Reset;
        // Employee.SetRange("NAV Login ID", UserId);
        // if Employee.FindFirst then
        //     if Employee.Screener then
        //         FormEditable := Rec."Approval Status" in [Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Open, Rec."Approval Status"::Rejected]
        //     else
        //         FormEditable := Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::Rejected];
    end;
}
