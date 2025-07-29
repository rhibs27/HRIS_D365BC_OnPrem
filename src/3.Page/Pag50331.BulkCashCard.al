page 50331 "Bulk Cash Card"
{
    ApplicationArea = All;
    Caption = 'Bulk Cash';
    PageType = Card;
    SourceTable = "Employee Activity";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = FormEditable;
                Caption = 'General';


                field("From Branch"; Rec."From Branch")
                {

                }
                field("To Branch"; Rec."To Branch")
                {

                }
                field("Total Cash"; Rec."Total Cash")
                {

                }
                field("Total Distance (In KM)"; Rec."Total Distance (In KM)")
                {

                }
                field("Total Estimate Time (In Hour)"; Rec."Total Estimate Time (In Hour)")
                {

                }

            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No."),
                              Type = const(" "),
                              "Employee Code" = field("Employee No.");
                ApplicationArea = All;
            }
            group(Approval)
            {
                Caption = 'Approval';
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
                field("Approver Type"; Rec."Approver Type")
                {
                    ToolTip = 'Specifies the value of the Approver Type field.';
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
                    Rec.TestField("Approver Code");
                    Rec.TestField("Recommender Code");
                    Rec.TestField("Total Cash");
                    HRMgt.ApplyForApprovalForms(Rec);
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
                    // if Confirm('Do you want to approve the request?', false) then
                    //     HRMgt.ApprovedRejectApproval(true, Rec."No.");
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
                    // if Confirm('Do you want reject the request?', false) then
                    // HRMgt.ApprovedRejectApproval(false, Rec."No.");
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
        FormEditable := Rec."Approval Status" in [Rec."Approval Status"::" ", Rec."Approval Status"::Canceled,
                        Rec."Approval Status"::Open];

        case Rec."Approval Status" of
            Rec."Approval Status"::Rejected, Rec."Approval Status"::Open:
                begin
                    ForRecommend := false;
                    ForReject := false;
                    ForApprove := false;
                    ForScreen := false;
                end;
            Rec."Approval Status"::Pending:
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
