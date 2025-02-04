page 50088 "Leave Request"
{
    // version NIC Asia1.00,Leave

    SourceTable = "Leave";
    // SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
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
                        IsCompensatory := LeaveType.Compensatory;
                        IsBereavement := LeaveType."Bereavement Leave";
                        if IsCompensatory then
                            RemainingDays := 0;
                        if Rec."Leave Code" <> xRec."Leave Code" then
                            GenerateAttachment;
                        IsPaternity := LeaveType."Maternity/Paternity Leave";
                    end;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    Editable = false;
                    OptionCaption = 'Full Day';
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

                    trigger OnValidate()
                    begin
                        LeaveType.Get(Rec."Leave Code");
                        if Rec."No. of Days" <> xRec."No. of Days" then
                            if LeaveType."Sick Leave" then
                                GenerateAttachment
                    end;
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
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
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
                    Editable = IsPaternity;
                    ToolTip = 'Specifies the value of the Child''s Gender field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
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
                }
                field("Remaining Days"; RemainingDays)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the RemainingDays field.';
                    ApplicationArea = All;
                }
                field(BalacingRemDays; RemainingDays - Rec."No. of Days")
                {
                    Caption = 'Balancing Remaining Days';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Balancing Remaining Days field.';
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
            }
            // group(Approval)
            // {
            //     Caption = 'Approval';
            //     field("Recommender Code"; Rec."Recommender Code")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Code field.';
            //         ApplicationArea = All;
            //     }
            //     field("Recommender Name"; Rec."Recommender Name")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Name field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Code"; Rec."Approver Code")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Code field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Name"; Rec."Approver Name")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Name field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Type"; Rec."Approver Type")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Type field.';
            //         ApplicationArea = All;
            //     }
            //}
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
            action(delete)
            {
                trigger OnAction()
                var
                    leave: Record Leave;
                begin
                    leave.Reset();
                    leave.SetFilter("No.", '%1', '');
                    leave.FindFirst();
                    leave.Delete();
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Leave Request";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not IsApplied then begin
            if not Confirm('The data will be erased. Do you want to continue?', true) then
                Error('')
            else begin
                TempIncomingDoc.Reset;
                TempIncomingDoc.SetRange("Employee Code", Rec."Employee No.");
                TempIncomingDoc.SetRange("Leave Type Code", LeaveType.Code);
                TempIncomingDoc.SetRange("No.", '');
                if TempIncomingDoc.Find('-') then
                    repeat
                        LoanMgt.DeleteAttachment(TempIncomingDoc);
                        if TempIncomingDoc."File Name" <> '' then
                            Clear(TempIncomingDoc."File Name");

                    until TempIncomingDoc.Next = 0;
                TempIncomingDoc.DeleteAll;
                Approval.Reset();
                Approval.SetRange("Document No.", '');
                if Approval.FindSet() then
                    Approval.DeleteAll();

            end;
        end;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        LoanMgt: Codeunit "Loan Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        RemainingDays: Decimal;
        [InDataSet]
        IsCompensatory: Boolean;
        LeaveType: Record "Leave Type Setup";
        IsApplied: Boolean;
        [InDataSet]
        IsBereavement: Boolean;
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        [InDataSet]
        IsPaternity: Boolean;
        Approval: Record "Approval HRMS";

    local procedure GenerateAttachment()
    begin
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", Rec."Employee No.");
        TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
        TempIncomingDoc.SETRANGE("Leave Type Code", LeaveType.Code);
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" <> '' then
                    Clear(TempIncomingDoc."File Name");
            until TempIncomingDoc.Next = 0;
        TempIncomingDoc.DeleteAll;
        Rec.TestField("Leave Code");
        if LeaveType."Sick Leave" then
            if Rec."No. of Days" < LeaveType."No. of Days for Attachment" then
                exit;
        IF LeaveType."Bereavement Leave" OR LeaveType."Maternity/Paternity Leave" OR LeaveType."Sick Leave" THEN BEGIN
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
        END;
    end;
}
