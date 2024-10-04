page 33019949 "Allowance Assignment Card"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Allowance Assignment Header";
    ApplicationArea = All;

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
                field("Allowance Type Filter"; Rec."Allowance Type Filter")
                {
                    ToolTip = 'Specifies the value of the Allowance Type Filter field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetLayout();
                    end;
                }
            }
            part(AllowanceSubform; "Allowance Assignment Subform")
            {
                SubPageLink = "Entry No." = field("Entry No."),
                              Code = field(Code),
                              Type = field(Type);
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            group(Approval)
            {
                Editable = FormEditable;
                field("Approval Status"; Rec."Approval Status")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ToolTip = 'Specifies the value of the Approver ID field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(Control19; "Allowance Factbox")
            {
                SubPageLink = "Entry No. Filter" = field("Entry No."),
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

                trigger OnAction()
                var
                    LoanMgt: Codeunit "Loan Mgt.";
                begin
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    AllowanceLine.Reset;
                    AllowanceLine.SetRange("Entry No.", Rec."Entry No.");
                    if Confirm('Do you want to send approval request?', false) then
                        LoanMgt.SendApprovalAllowanceAssignment(Rec, AllowanceLine, true);
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

                trigger OnAction()
                begin
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    AllowanceLine.Reset;
                    AllowanceLine.SetRange("Entry No.", Rec."Entry No.");
                    if Confirm('Do you want to cancel the document?', false) then
                        LoanMgt.SendApprovalAllowanceAssignment(Rec, AllowanceLine, false);
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

                trigger OnAction()
                var
                    LoanMgt: Codeunit "Loan Mgt.";
                begin
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    //AllowanceLine.RESET;
                    //AllowanceLine.SETRANGE("Entry No.", "Entry No.");
                    if Confirm('Do you want to approve the document?', false) then
                        LoanMgt.ApproveRejectAllowanceAssignment(true, Rec."Entry No.");
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

                trigger OnAction()
                var
                    LoanMgt: Codeunit "Loan Mgt.";
                begin
                    //CurrPage.AllowanceSubform.PAGE.GetSelectedLines(AllowanceLine);
                    //AllowanceLine.RESET;
                    //AllowanceLine.SETRANGE("Entry No.", "Entry No.");
                    if Confirm('Do you want to reject the document?', false) then
                        LoanMgt.ApproveRejectAllowanceAssignment(false, Rec."Entry No.");
                end;
            }
            action("Return Request")
            {
                ToolTip = 'Executes the Return Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to return this document?', false) then
                        LoanMgt.ApproveRejectAllowanceAssignment(false, Rec."Entry No.");
                end;
            }
            action(ChangeApprover)
            {
                Image = ChangeCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the ChangeApprover action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want changes approver?', false) then begin
                        LoanMgt.PopUpChangingApproverAllowance(Rec);
                    end;
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
        AllowanceLine: Record "Allowance Assignment Line";
        FormEditable: Boolean;
        LoanMgt: Codeunit "Loan Mgt.";
        Employee: Record Employee;

    local procedure SetLayout()
    begin
        CurrPage.AllowanceSubform.Page._SetFilter(Rec."Allowance Type Filter");
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then
            if Employee.Screener then
                FormEditable := Rec."Approval Status" in [Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Open, Rec."Approval Status"::Rejected]
            else
                FormEditable := Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::Rejected];
    end;
}
