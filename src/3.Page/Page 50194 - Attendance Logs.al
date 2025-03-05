page 50194 "Attendance Logs"
{
    // version AMS6.1.0

    Editable = false;
    PageType = List;
    SourceTable = "Attendance Log";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    ToolTip = 'Specifies the value of the Employee ID field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field("Check In Time"; Rec."Check In Time")
                {
                    ToolTip = 'Specifies the value of the Check In Time field.';
                    ApplicationArea = All;
                }
                field("Check Out Time"; Rec."Check Out Time")
                {
                    ToolTip = 'Specifies the value of the Check Out Time field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    ApplicationArea = All;
                }
                field(Delayed; Rec.Delayed)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Delayed field.';
                    ApplicationArea = All;
                }
                field("Status Updated By"; Rec."Status Updated By")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Status Updated By field.';
                    ApplicationArea = All;
                }
                field("Status Updated Date"; Rec."Status Updated Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Status Updated Date field.';
                    ApplicationArea = All;
                }
                field("Late Remarks"; Rec."Late Remarks")
                {
                    ToolTip = 'Specifies the value of the Late Remarks field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
                field("Approver Remarks"; Rec."Approver Remarks")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Approver Remarks field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Punch out Remarks"; Rec."Punch out Remarks")
                {
                    ToolTip = 'Specifies the value of the Punch out Remarks field.';
                    ApplicationArea = All;
                }
                field("IP address"; Rec."IP address")
                {
                    ToolTip = 'Specifies the value of the IP address field.';
                    ApplicationArea = All;
                }
                field("Punch Out Reviewer"; Rec."Punch Out Reviewer")
                {
                    ToolTip = 'Specifies the value of the Punch Out Reviewer field.';
                    ApplicationArea = All;
                }
                field("Punch Out Check Reviewer"; Rec."Punch Out Check Reviewer")
                {
                    ToolTip = 'Specifies the value of the Punch Out Check Reviewer field.';
                    ApplicationArea = All;
                }
                field("Night Shift Check Out Time"; Rec."Night Shift Check Out Time")
                {
                    ToolTip = 'Specifies the value of the Night Shift Check Out Time field.';
                    ApplicationArea = All;
                }
                field("Training Check In Time"; Rec."Training Check In Time")
                {
                    ToolTip = 'Specifies the value of the Training Check In Time field.';
                    ApplicationArea = All;
                }
                field("Training Check Out Time"; Rec."Training Check Out Time")
                {
                    ToolTip = 'Specifies the value of the Training Check Out Time field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Edit Lists")
            {
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Edit Lists action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('You do not have authority to change Attendance Log.');
                end;
            }
            action(Delete)
            {
                trigger OnAction()
                var
                    AttendanceLog: Record "Attendance Log";
                begin
                    AttendanceLog.DeleteAll();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Is Admin" then
                CurrPage.Editable(true)
            else
                CurrPage.Editable(false);
        end else
            CurrPage.Editable(false);
    end;

    var
        UserSetup: Record "User Setup";
}
