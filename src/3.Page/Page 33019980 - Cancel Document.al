page 33019980 "Cancel Document"
{
    PageType = Card;
    SourceTable = "Employee Activity";
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
                    Editable = true;
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
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Cancelled Document No."; Rec."Cancelled Document No.")
                {
                    Visible = IsLeaveRequest;
                    ToolTip = 'Specifies the value of the Cancelled Document No. field.';
                    ApplicationArea = All;
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
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Visible = not IsOpen;
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
            }
            group(Reason)
            {
                Visible = not IsLeaveRequest;
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    ApplicationArea = All;
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ToolTip = 'Specifies the value of the Reason Description field.';
                    ApplicationArea = All;
                }
            }
            part(Control32; "Attachment Subform")
            {
                SubPageLink = "No." = field("No.");
                SubPageView = where("No." = filter(<> ''));
                ApplicationArea = All;
            }
            group(Approval)
            {
                Editable = IsOpen;
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

                    HRMgt.ApplyCancelEmployeeActivity(Rec);
                    IsApplied := true;
                    Message('Applied');
                    CurrPage.Close;
                end;
            }
            action(Approve)
            {
                Visible = not IsOpen;
                ToolTip = 'Executes the Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve this document?', false) then begin
                        HRMgt.ApproveRejectCancelAttendanceMissed(Rec, true);
                        CurrPage.Close;
                    end;
                end;
            }
            action(Reject)
            {
                Visible = not IsOpen;
                ToolTip = 'Executes the Reject action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject this document?', false) then begin
                        HRMgt.ApproveRejectCancelAttendanceMissed(Rec, false);
                        CurrPage.Close;
                    end;
                end;
            }
            action(Screen)
            {
                Visible = IsLeaveRequest;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to screen this document?', false) then begin
                        HRMgt.ScreenCancelledLeave(Rec);
                        Message('Screened');
                    end;
                end;
            }
            action("Change Recommender/Approver")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec.Type = Rec.Type::"Attendance Missed";
                ToolTip = 'Executes the Change Recommender/Approver action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ReopenDocument;
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
        if Rec.Type = Rec.Type::"Attendance Missed" then
            CurrPage.Caption('Attendance Missed');
        IsLeaveRequest := Rec.Type = Rec.Type::"Leave Request";
        IsOpen := (Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::" ");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            if not IsApplied then
                if not Confirm('The data will be erased. Do you want to continue?', true) then
                    Error('');
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        IsApplied: Boolean;
        [InDataSet]
        IsLeaveRequest: Boolean;
        [InDataSet]
        IsOpen: Boolean;
        TypeFilter: Text;
}
