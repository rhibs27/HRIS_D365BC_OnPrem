page 50057 "Employee Activity Card"
{
    // version ATM.19.01.01

    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Employee Activity Details";
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

                    trigger OnValidate()
                    begin
                        EnableOpeningEntryVisible := Rec.IsValidApprover;
                        CurrPage.Update;
                    end;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Leave Balance");
                        SetControlVisibility;
                    end;
                }
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
            group(Overtime)
            {
                Visible = EnableOvertimeVisible;
                field("Overtime Hours"; Rec."Total Hours")
                {
                    ToolTip = 'Specifies the value of the Total Hours field.';
                    ApplicationArea = All;
                }
            }
            group(Details)
            {
                Visible = not EnableOpeningEntry;
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
            group(Opening)
            {
                Visible = EnableOpeningEntry;
                field("Opening Total Days"; Rec."Total Days")
                {
                    Caption = 'Total Days';
                    ToolTip = 'Specifies the value of the Total Days field.';
                    ApplicationArea = All;
                }
                field("Opening Remarks"; Rec.Remarks)
                {
                    Caption = 'Remarks';
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ActionGroup32)
            {
                action("Enter Opening")
                {
                    Image = EditForecast;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Enter Opening action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Rec.IsValidApprover then
                            SetEnableOpeningEntry;
                    end;
                }
            }
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
                        Rec.SetOpeningEntry(EnableOpeningEntry);
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
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Delegate action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
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
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Send A&pproval Request action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Rec.SendDocumentForApproval then begin
                            Message(Text000, Rec."No.", SentForApprovalTxt);
                            CurrPage.Close;
                        end;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Cancel A&pproval Request action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if Rec.CancelDocument then begin
                            Message(Text000, Rec."No.", ReopenTxt);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
    end;

    trigger OnOpenPage()
    begin
        EnableOpeningEntryVisible := Rec.IsValidApprover;
    end;

    var

        EnableLeave: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;

        EnableOpeningEntry: Boolean;

        EnableOpeningEntryVisible: Boolean;
        Text000: Label 'Document %1 is %2 successfully.';
        ApproveTxt: Label 'approved';
        RejectTxt: Label 'rejected';
        ReopenTxt: Label 'reopened';
        SentForApprovalTxt: Label 'sent for approval';

        EnableOvertimeVisible: Boolean;

    local procedure SetControlVisibility()
    begin
        Rec.Opening := false;
        SetEnableLeave;
        SetOvertime;
        OpenApprovalEntriesExistForCurrUser := Rec.HasOpenApprovalEntriesForCurrentUser;
    end;

    local procedure SetEnableLeave()
    begin
        if Rec.Opening then
            exit;
        if Rec.Type in [Rec.Type::"Full Day Leave", Rec.Type::"Half Day Leave"] then
            EnableLeave := true
        else
            EnableLeave := false;
    end;

    local procedure SetEnableOpeningEntry()
    begin
        Rec.EnterOpeningEntry;
        EnableOpeningEntry := true;
    end;

    local procedure SetOvertime()
    begin
        if Rec.Opening then
            exit;
        if Rec.Type = Rec.Type::Overtime then
            EnableOvertimeVisible := true
        else
            EnableOvertimeVisible := false;
    end;
}
