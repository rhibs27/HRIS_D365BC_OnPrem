page 50180 "Cancel Document"
{
    PageType = Card;
    SourceTable = "Cancel Document";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = IsOpen;
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
                field("Leave Code"; Rec."Leave Code")
                {
                    Editable = false;
                    Visible = IsLeaveRequest;
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    Visible = IsLeaveRequest;
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Visible = IsLeaveRequest;
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    Visible = IsLeaveRequest;
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Cancelled Document No."; Rec."Cancelled Document No.")
                {
                    Visible = IsLeaveRequest;
                    ToolTip = 'Specifies the value of the Cancelled Document No. field.';
                    ApplicationArea = All;
                }
                field("Previous Check In Time"; rec."Previous Check In Time")
                {
                    Visible = IsAttendanceMissed;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Previous Check Out Time"; rec."Previous Check Out Time")
                {
                    Visible = IsAttendanceMissed;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Requested Date"; Rec."Requested Date")
                {
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
                field("Substitute Person Code"; Rec."Substitute Person Code")
                {
                    ToolTip = 'Specifies the value of Substitute person code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Substitute Person Name"; Rec."Substitute Person Name")
                {
                    ToolTip = 'Specifies the value of Substitute person code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    ApplicationArea = All;
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ToolTip = 'Specifies the value of the Reason Description field.';
                    ApplicationArea = All;
                    Editable = false;
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
                field("CheckIn Time"; rec."CheckIn Time")
                {
                    Visible = IsAttendanceMissed;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("CheckOut Time"; rec."CheckOut Time")
                {
                    Visible = IsAttendanceMissed;
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            group("Remark")
            {
                Caption = 'Remark';
                field(Remarks; Rec.Remarks)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Visible = IsPending;
                    Editable = IsPending;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
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
                    if Confirm('Do you want to Send for Approval Request?', false) then begin
                        DocCancelMgt.ApplyCancelEmployeeActivity(Rec);
                        IsApplied := true;
                        Message('Applied');
                        CurrPage.Close;
                    end;
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Visible = IsPending;
                ToolTip = 'Executes the Approve action.';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Rec."Rejection Remarks" := '';
                        Message('Leave is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Visible = IsPending;
                ToolTip = 'Executes the Reject action.';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Leave is Rejected by %1', HRMgt.GetEmpName());
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
        SetLayout;
        if IsOpen then
            case rec.Type of
                rec.Type::"Attendance Missed":
                    begin
                        ApproverMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::"Attendance Missed", rec."Approval Status");
                    end;
                rec.Type::"Leave Request":
                    begin
                        ApproverMgt.InsertApproval(Rec."Employee No.", '', Rec.Type::"Leave Request", Rec."Approval Status");
                    end;
            end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            if not IsApplied then
                if not Confirm('The data will be erased. Do you want to continue?', true) then
                    Error('')
                else begin
                    Approval.Reset();
                    Approval.setRange("Document Type", Approval."Document Type"::"Travel Claim");
                    Approval.SetRange("Document No.", '');
                    Approval.DeleteAll();
                end;
    end;

    procedure SetLayout()
    begin
        if Rec.Type = Rec.Type::"Attendance Missed" then
            CurrPage.Caption('Attendance Missed');
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsAttendanceMissed := rec.Type = rec.Type::"Attendance Missed";
        IsLeaveRequest := Rec.Type = Rec.Type::"Leave Request";
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsOpen := (Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::" ");
        RecRef.GetTable(Rec);
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        DocCancelMgt: Codeunit "AttendanceMiss Mgt";
        IsApplied: Boolean;

        IsLeaveRequest, IsAttendanceMissed : Boolean;

        IsOpen: Boolean;
        TypeFilter: Text;
        ApproverMgt: Codeunit "Approver Mgt";
        IsPending: Boolean;
        Approval: Record "Approval HRMS";
        RecRef: RecordRef;
        ApprovalStatusView: Boolean;
        StatusView: Boolean;
}
