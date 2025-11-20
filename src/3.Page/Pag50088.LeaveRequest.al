page 50088 "Leave Request"
{
    SourceTable = "Leave";
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
                field("Employee Work Shift"; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.';
                    ApplicationArea = All;
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Requested Date" <> 0D then
                            RemainingDays := LeaveMgt.CalculateRemainingDays(Rec."Employee No.", Rec."Leave Code", Rec."Requested Date");
                        LeaveType.Get(Rec."Leave Code");
                        IsCompensatory := LeaveType."Leave Category" = Leavetype."Leave Category"::Substitute;
                        IsBereavement := LeaveType."Leave Category" = LeaveType."Leave Category"::"Bereavement Leave";
                        IsPaternity := LeaveType."Leave Category" = leavetype."Leave Category"::"Paternity Leave";
                        CurrPage.Update();
                    end;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.';
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
                field("Start Time"; Rec."Start Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("Branch"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ApplicationArea = All;
                }
                field("Department"; Rec."Department")
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Province"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
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
                field("Child's Gender"; Rec."Child's Gender")
                {
                    // Editable = IsPaternity;
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Child''s Gender field.';
                    ApplicationArea = All;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ToolTip = 'Specifies the value of the Pay Type field.';
                    ApplicationArea = All;
                }
                field("Compensatory Date"; Rec."Compensatory Date")
                {
                    Enabled = IsCompensatory;
                    ToolTip = 'Specifies the value of the Compensatory Date field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("For Death Of"; Rec."For Death Of")
                {
                    Editable = IsBereavement;
                    ToolTip = 'Specifies the value of the For Death Of field.';
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Days"; RemainingDays)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the RemainingDays field.';
                    ApplicationArea = All;
                }
                field(BalancingRemDays; RemainingDays - Rec."No. of Days")
                {
                    Caption = 'Balancing Remaining Days';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Balancing Remaining Days field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No."),
                              Type = const(" "),
                              "Employee Code" = field("Employee No."),
                              "Leave Type Code" = field("Leave Code"),
                              "Employee Activity Type" = field(Type);
                ApplicationArea = All;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Apply for Leave")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Apply for Leave action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if LeaveMgt.ApplyForLeave(Rec) <> '' then begin
                        IsApplied := true;
                        Message('Leave has been sent for apporval.');
                        CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Leave Request";
    end;

    var
        LeaveMgt: Codeunit "Leave Mgt.";
        RemainingDays: Decimal;

        IsCompensatory, IsBereavement, IsPaternity : Boolean;
        LeaveType: Record "Leave Type Setup";
        IsApplied: Boolean;
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        Approval: Record "Approval HRMS";

    local procedure GenerateAttachment()
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", Rec."Employee No.");
        TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
        TempIncomingDoc.SetRange("Leave Type Code", LeaveType.Code);
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" <> '' then
                    Clear(TempIncomingDoc."File Name");
            until TempIncomingDoc.Next = 0;
        TempIncomingDoc.DeleteAll;
        Rec.TestField("Leave Code");
        if LeaveType."Leave Category" = LeaveType."Leave Category"::"Sick Leave" then
            if Rec."No. of Days" < LeaveType."No. of Days for Attachment" then
                exit;
        IF LeaveType."Leave Category" in [LeaveType."Leave Category"::"Bereavement Leave", LeaveType."leave category"::"Maternity Leave",
                               LeaveType."leave category"::"Paternity Leave", LeaveType."leave category"::"Sick Leave"] THEN begin
            AttachmentSetup.Reset;
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Leave Request");
            AttachmentSetup.SetRange("Leave Type Code", LeaveType.Code);
            if AttachmentSetup.Find('-') then
                repeat
                    TempIncomingDoc.Reset;
                    TempIncomingDoc.Init;
                    TempIncomingDoc."No." := Rec."No.";
                    TempIncomingDoc.Validate(Type, TempIncomingDoc.Type::" ");
                    TempIncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                    TempIncomingDoc.Validate(Description, Format(Rec.Type) + ': ' + Rec."Leave Description");
                    TempIncomingDoc.Validate("Employee Code", Rec."Employee No.");
                    TempIncomingDoc.Validate("Leave Type Code", LeaveType.Code);
                    TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::"Leave Request");
                    TempIncomingDoc.Insert(true);
                until AttachmentSetup.Next = 0;
        end;
    end;
}
