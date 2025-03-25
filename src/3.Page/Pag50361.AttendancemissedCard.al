page 50361 "Attendance missed Card"
{
    ApplicationArea = All;
    Caption = 'Attendance missed Card';
    PageType = Card;
    SourceTable = "Attendance Missed";
    SourceTableView = WHERE(Type = CONST("Attendance Missed"));
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
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
                field("Start Date"; Rec."Start Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    ApplicationArea = All;
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ToolTip = 'Specifies the value of the Reason Description field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = StatusView;
                    Caption = 'Approval Status';
                }
            }
            // part(Control32; "Attachment Subform")
            // {
            //     SubPageLink = "No." = field("No."),
            //                   Type = const(" "),
            //                   "Employee Code" = field("Employee No."),
            //                   "Leave Type Code" = field("Leave Code");
            //     SubPageView = where("No." = filter(<> ''));
            //     ApplicationArea = All;
            // }
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
            action(Apply)
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsOpen;
                ToolTip = 'Executes the Apply action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DocCancelMgt.ApplyAttendanceMissed(Rec);
                    Message('Applied');
                    IsApplied := true;
                    CurrPage.Close;
                end;
            }
            action(Approve)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Approve;
                Visible = IsPending;
                ToolTip = 'Executes the Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Message('Document is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action(Reject)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                Image = Reject;
                ToolTip = 'Executes the Reject action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Document is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.FilterGroup(2);
        TypeFilter := Rec.GetFilter(Type);
        Rec.FilterGroup(0);
        if TypeFilter = Format(Rec.Type::"Attendance Missed") then
            Rec.Type := Rec.Type::"Attendance Missed";
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    begin
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsOpen := (Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::" ");
        RecRef.GetTable(Rec);
        if IsOpen then
            ApproverMgt.InsertApprovalTemp(Rec."Employee No.", '', Rec.Type::"Attendance Missed");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            if not IsApplied then
                if not Confirm('The data will be erased. Do you want to continue?', true) then
                    Error('')
                else begin
                    Approval.Reset();
                    Approval.SetRange("Document No.", '');
                    Approval.setRange("Document Type", Approval."Document Type"::"Attendance Missed");
                    Approval.SetRange("Employee No", Rec."Employee No.");
                    Approval.DeleteAll();
                end;
    end;


    var
        HRMgt: Codeunit "HR Mgt.";
        DocCancelMgt: Codeunit "AttendanceMiss Mgt";
        [InDataSet]
        [InDataSet]
        IsOpen: Boolean;
        TypeFilter: Text;
        ApproverMgt: Codeunit "Approver Mgt";
        IsPending: Boolean;
        Approval: Record "Approval HRMS";
        RecRef: RecordRef;
        ApprovalStatusView: Boolean;
        StatusView: Boolean;
        IsApplied: Boolean;
}

