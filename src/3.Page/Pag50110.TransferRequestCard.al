page 50110 "Transfer Request Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Employee Transfer";
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
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Salary Level Name"; Rec."Salary Level Name")
                {
                    ToolTip = 'Specifies the value of the Salary Level Name field.';
                    ApplicationArea = All;
                }
                field("Transfer Category"; Rec."Transfer Category")
                {
                    ToolTip = 'Specifies the value of the Transfer Category field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        GetTransferEditibility;
                    end;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Editable = TransferCategoryEditable;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = TransferCategoryEditable;
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Curr. Placement Period(Month)"; Rec."Curr. Placement Period(Month)")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Curr. Placement Period(Month) field.';
                    ApplicationArea = All;
                }
                field("Transfer Propose Date"; Rec."Transfer Propose Date")
                {
                    ToolTip = 'Specifies the value of Transfer Propose Date field.';
                    ApplicationArea = All;
                }
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ToolTip = 'Specifies the value of the Transfer Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
            }
            group(Transfer)
            {
                field("Reason For Transfer"; Rec."Reason for transfer")
                {
                    ToolTip = 'Specifies the value of the Reason for Resignation field.';
                    ApplicationArea = All;
                    Caption = 'Reason For Transfer';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Requested Province"; Rec."Requested Province")
                {
                    ToolTip = 'Specifies the value of the Transfer To Province field.';
                    ApplicationArea = All;
                }
                field("Requested Province Name"; Rec."Requested Province Name")
                {
                    ToolTip = 'Specifies the value of the Transfer To Province Name field.';
                    ApplicationArea = All;
                }
                field("Requested Branch"; Rec."Requested Branch")
                {
                    ToolTip = 'Specifies the value of the Requested Branch field.', Comment = '%';
                }
                field("Requested Branch Name"; Rec."Requested Branch Name")
                {
                    ToolTip = 'Specifies the value of the Requested Branch Name field.', Comment = '%';
                }
                field("Requested Province 2"; Rec."Requested Province 2")
                {
                    ToolTip = 'Specifies the value of the Requested Province 2 field.', Comment = '%';
                }
                field("Requested Province Name 2"; Rec."Requested Province Name 2")
                {
                    ToolTip = 'Specifies the value of the Requested Province Name 2 field.', Comment = '%';
                }
                field("Requested Branch 2"; Rec."Requested Branch 2")
                {
                    ToolTip = 'Specifies the value of the Requested Branch 2 field.', Comment = '%';
                }
                field("Requested Branch Name 2"; Rec."Requested Branch Name 2")
                {
                    ToolTip = 'Specifies the value of the Requested Branch Name 2 field.', Comment = '%';
                }
                field("Requested Province 3"; Rec."Requested Province 3")
                {
                    ToolTip = 'Specifies the value of the Requested Province 3 field.', Comment = '%';
                }
                field("Requested Province Name 3"; Rec."Requested Province Name 3")
                {
                    ToolTip = 'Specifies the value of the Requested Province Name 3 field.', Comment = '%';
                }
                field("Requested Branch 3"; Rec."Requested Branch 3")
                {
                    ToolTip = 'Specifies the value of the Requested Branch 3 field.', Comment = '%';
                }
                field("Requested Branch Name 3"; Rec."Requested Branch Name 3")
                {
                    ToolTip = 'Specifies the value of the Requested Branch Name 3 field.', Comment = '%';
                }
            }
            part(Attachment; "Attachment Subform")
            {
                Editable = false;
                SubPageLink = "No." = field("No."),
                                "Employee Code" = field("Employee No."),
                                "Employee Activity Type" = field(Type);
                ApplicationArea = All;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
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
                Visible = (Rec."Approval Status" = Rec."Approval Status"::Open);
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ConfirmTransfer: Label 'Do you want to send transfer request ?';
                begin
                    if Confirm(ConfirmTransfer, false) then begin
                        TransferMgt.SendTransferApproval(Rec);
                        IsApplied := true;
                        CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetTransferEditibility;
    end;


    trigger OnOpenPage()
    begin
        case rec.Type of
            rec.Type::"Employee Transfer":
                begin
                    ApproverMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::"Employee Transfer", rec."Approval Status");
                end;
            rec.Type::"HR Transfer":
                begin
                    ApproverMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::"HR Transfer", rec."Approval Status");
                end;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."No." <> '' then
            exit;
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            if not IsApplied then
                if not Confirm('The data will be erased.Do you want to continue?', false) then
                    Error('')
                else begin
                    Approval.Reset();
                    Approval.SetRange("Document No.", '');
                    Approval.setRange("Document Type", Approval."Document Type"::"Employee Transfer");
                    Approval.SetRange("Employee No", Rec."Employee No.");
                    Approval.DeleteAll();
                end;
    end;

    var
        TransferMgt: Codeunit "Transfer Mgt.";
        Approval: Record "Approval HRMS";
        IsApplied: Boolean;
        IsOpen: Boolean;
        TransferCategoryEditable: Boolean;
        ApproverMgt: Codeunit "Approver Mgt";

    procedure GetTransferEditibility()
    begin
        TransferCategoryEditable := Rec."Transfer Category" in [Rec."Transfer Category"::Officiating, Rec."Transfer Category"::"Temporary"];
    end;
}
