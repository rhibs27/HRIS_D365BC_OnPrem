page 50149 "Allowance Assignment Card"
{
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
                    Editable = IsOpen and not AllowanceClaim;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                    Editable = IsOpen and not AllowanceClaim;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the English Year field.';
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("To date"; Rec."To date")
                {
                    ToolTip = 'Specifies the value of the To date field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Employee Name"; REc."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
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
                ApplicationArea = All;
                Editable = IsOpen;
            }
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
                begin
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
                Visible = (Rec."Approval Status" = rec."Approval Status"::Pending);
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the document?', false) then
                        ApproverMgt.ApproveRejectDocument(RecRef, true)
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
                Visible = (Rec."Approval Status" = rec."Approval Status"::Pending);
                trigger OnAction()
                begin
                    if Confirm('Do you want to reject the document?', false) then
                        ApproverMgt.ApproveRejectDocument(RecRef, false)
                end;
            }
            action("Allowance Assignment Summary")
            {
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Shows Allowance Assignment Summary Report';
                ApplicationArea = All;
                trigger OnAction()

                begin
                    Report.Run(Report::"Allowance Assignment Summary", true, false, Rec);
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
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
        ApproverMgt: Codeunit "Approver Mgt";
        IsOpen, IsPending, IsApprove : Boolean;
        RecRef: RecordRef;
        AllowanceClaim: Boolean;

    local procedure SetLayout()
    begin
        FormEditable := rec."Approval Status" = rec."Approval Status"::Open;
        IsPending := Rec."Approval Status" = rec."Approval Status"::"Pending";
        IsOpen := Rec."Approval Status" = rec."Approval Status"::Open;
        IsApprove := Rec."Approval Status" = rec."Approval Status"::Approved;
        RecRef.GetTable(Rec);
        AllowanceClaim := Rec."Activity Type" = Rec."Activity Type"::"Allowance Assignment Claim";
        if AllowanceClaim then
            CurrPage.Caption('Allowance Assignment claim Card');
    end;
}
