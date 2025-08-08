page 50056 "Posted Employee Activity Card"
{
    // version ATM.19.01.01

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Employee Activity Details";
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Leave Balance");
                        SetEnableLeave;
                    end;
                }
                group(Leave)
                {
                    Visible = EnableLeave;
                    field("Leave Type"; Rec."Leave Type")
                    {
                        ToolTip = 'Specifies the value of the Leave Type field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            Rec.CalcFields("Leave Balance");
                        end;
                    }
                    field("Leave Balance"; Rec."Leave Balance")
                    {
                        ToolTip = 'Specifies the value of the Leave Balance field.';
                        ApplicationArea = All;
                    }
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Total Days"; Abs(Rec."Total Days"))
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Days) field.';
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                    ApplicationArea = All;
                }
                field("Manager ID"; Rec."Manager ID")
                {
                    ToolTip = 'Specifies the value of the Manager ID field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Approve action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Rec.ApproveDocument then begin
                            Message(Text000, Rec."No.", ApproveTxt);
                            CurrPage.Close;
                        end;
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Reject action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Rec.RejectDocument then begin
                            Message(Text000, Rec."No.", RejectTxt);
                            CurrPage.Close;
                        end;
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = page "Approval Comments";
                    RunPageLink = "Table ID" = const(60041),
                                  "Document No." = field("No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Comments action.';
                    ApplicationArea = All;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(Reopen)
                {
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Reopen action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Rec.CancelDocument then begin
                            Message(Text000, Rec."No.", ReopenTxt);
                            CurrPage.Close;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetEnableLeave;
        SetControlVisibility;
    end;

    var

        EnableLeave: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        Text000: Label 'Document %1 is %2 successfully.';
        ApproveTxt: Label 'approved';
        RejectTxt: Label 'rejected';
        ReopenTxt: Label 'reopened';

    local procedure SetControlVisibility()
    begin
        OpenApprovalEntriesExistForCurrUser := Rec.HasOpenApprovalEntriesForCurrentUser;
    end;

    local procedure SetEnableLeave()
    begin
        if Rec.Type in [Rec.Type::"Full Day Leave", Rec.Type::"Half Day Leave"] then
            EnableLeave := true
        else
            EnableLeave := false;
    end;
}
