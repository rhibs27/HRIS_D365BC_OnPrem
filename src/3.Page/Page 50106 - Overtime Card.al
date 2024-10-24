page 50106 "Overtime Card"
{
    // version NIC Asia1.00,OT,Bulk Cash,Out of Office

    PageType = Card;
    SourceTable = "OverTime";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = FormEditable;
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
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Caption = 'OT Date';
                    ToolTip = 'Specifies the value of the OT Date field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Estimated Hours"; Rec."Estimated Hours")
                {
                    ToolTip = 'Specifies the value of the Estimated Hours field.';
                    ApplicationArea = All;
                }
                field("Actual Hours"; Rec."Actual Hours")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Actual Hours field.';
                    ApplicationArea = All;
                }
                field("Encashment Code"; Rec."Encashment Code")
                {
                    ToolTip = 'Specifies the value of the Encashment Code field.';
                    ApplicationArea = All;
                }
                field("OT Amount"; Rec."OT Amount")
                {
                    ToolTip = 'Specifies the value of the OT Amount field.';
                    ApplicationArea = All;
                }
                field("OT Disbursed"; Rec."OT Disbursed")
                {
                    ToolTip = 'Specifies the value of the OT Disbursed field.';
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
                field("Updated Payroll Line"; Rec."Updated Payroll Line")
                {
                    ToolTip = 'Specifies the value of the Updated Payroll Line field.';
                    ApplicationArea = All;
                }
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No."),
                              Type = const(" "),
                              "Employee Code" = field("Employee No.");
                ApplicationArea = All;
            }
            group(Control6)
            {
                Caption = 'Remarks';
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Reason for OT';
                    Editable = true;
                    ToolTip = 'Specifies the value of the Reason for OT field.';
                    ApplicationArea = All;
                }
                field("Screener Remarks"; Rec."Screener Remarks")
                {
                    Editable = ForScreen;
                    ToolTip = 'Specifies the value of the Screener Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Editable = ForReject;
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Recommender Code"; Rec."Recommender Code")
                {
                    ToolTip = 'Specifies the value of the Recommender Code field.';
                    ApplicationArea = All;
                }
                field("Recommender Name"; Rec."Recommender Name")
                {
                    ToolTip = 'Specifies the value of the Recommender Name field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // Visible = false; santosh
                ToolTip = 'Executes the Submit action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TransferMgt.ApplyForApprovalForms(Rec);
                    IsApplied := true;
                    CurrPage.Close;
                end;
            }
        }
        area(Navigation)
        {
            action("Recommend Request")
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ForRecommend;
                ToolTip = 'Executes the Recommend Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to recommend the request?', false) then
                        HRMgt.RecommendEmployeeActivity(Rec."No.");
                end;
            }
            action("Screen Request")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ForScreen;
                ToolTip = 'Executes the Screen Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResignationMgt.ScreenResignationForOvertime(Rec);
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ForApprove;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then
                        HRMgt.ApprovedRejectApproval(true, Rec."No.");
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
                begin
                    if Confirm('Do you want reject the request?', false) then
                        HRMgt.ApprovedRejectApproval(false, Rec."No.");
                end;
            }
            action("Change Recommender Approver")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Change Recommender Approver action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ReopenDocument;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout
    end;

    trigger OnOpenPage()
    begin
        SetLayout;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //IF NOT IsApplied THEN
        //IF NOT CONFIRM('The data will be erased. Do you want to continue?',TRUE) THEN
        //ERROR('');
        //not required.
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        TransferMgt: Codeunit "Transfer Mgt.";
        IsApplied: Boolean;
        FormEditable: Boolean;
        ForRecommend: Boolean;
        ForReject: Boolean;
        ForApprove: Boolean;
        ForScreen: Boolean;

    local procedure SetLayout()
    begin
        FormEditable := Rec."Approval Status" in [Rec."Approval Status"::" ", Rec."Approval Status"::Cancelled,
                        Rec."Approval Status"::Open];

        case Rec."Approval Status" of
            Rec."Approval Status"::Rejected, Rec."Approval Status"::Open:
                begin
                    ForRecommend := false;
                    ForReject := false;
                    ForApprove := false;
                    ForScreen := false;
                end;
            Rec."Approval Status"::"Pending Approval":
                begin
                    ForRecommend := true;
                    ForReject := true;
                    ForApprove := false;
                    ForScreen := false;
                end;
            Rec."Approval Status"::Recommended:
                begin
                    ForRecommend := false;
                    ForReject := true;
                    ForApprove := true;
                    ForScreen := false;
                end;
            Rec."Approval Status"::Screened:
                begin
                    ForRecommend := false;
                    ForReject := false;
                    ForApprove := false;
                    ForScreen := false;
                end;
            Rec."Approval Status"::Approved:
                begin
                    ForRecommend := false;
                    ForApprove := false;
                    ForReject := true;
                    ForScreen := true;
                end;
        end;
    end;


}
