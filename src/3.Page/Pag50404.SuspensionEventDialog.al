page 50404 "Suspension Event Dialog"
{
    PageType = Card;
    UsageCategory = None;
    Caption = 'Suspension Event';

    layout
    {
        area(Content)
        {
            group(SuspensionDetails)
            {
                Caption = 'Suspension Details';
                field(SuspensionLevelCodeCtrl; SuspensionLevelCode)
                {
                    Caption = 'Suspension Level Code';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    TableRelation = "Suspension Level";
                    ToolTip = 'Specifies the suspension level code affecting payroll.';
                }
                field(CauseOfInactivityCtrl; CauseOfInactivityCode)
                {
                    Caption = 'Cause of Inactivity';
                    ApplicationArea = All;
                    TableRelation = "Cause of Inactivity";
                    ToolTip = 'Specifies the type / cause of the suspension.';
                }
                field(SuspensionReasonCtrl; SuspensionReason)
                {
                    Caption = 'Suspension Reason';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason for the suspension.';
                }
                field(SuspensionStartDateCtrl; SuspensionStartDate)
                {
                    Caption = 'Suspension Start Date';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the date the suspension begins.';
                }
                field(SuspensionEndDateCtrl; SuspensionEndDate)
                {
                    Caption = 'Suspension End Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected end date of the suspension.';
                }
                field(SuspensionActiveCtrl; SuspensionActive)
                {
                    Caption = 'Suspension Active';
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the suspension is currently active.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionOK)
            {
                Caption = 'OK';
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Confirm and record the suspension event.';
                trigger OnAction()
                begin
                    ValidateAndConfirm();
                end;
            }
            action(ActionCancel)
            {
                Caption = 'Cancel';
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Discard and close without recording.';
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        SuspensionLevelCode: Code[20];
        CauseOfInactivityCode: Code[10];
        SuspensionReason: Text[100];
        SuspensionStartDate: Date;
        SuspensionEndDate: Date;
        SuspensionActive: Boolean;
        IsConfirmed: Boolean;

    procedure IsOKPressed(): Boolean
    begin
        exit(IsConfirmed);
    end;

    procedure GetValues(var LevelCode: Code[20]; var InactivityCode: Code[10]; var Reason: Text[100]; var StartDate: Date; var EndDate: Date; var Active: Boolean)
    begin
        LevelCode := SuspensionLevelCode;
        InactivityCode := CauseOfInactivityCode;
        Reason := SuspensionReason;
        StartDate := SuspensionStartDate;
        EndDate := SuspensionEndDate;
        Active := SuspensionActive;
    end;

    local procedure ValidateAndConfirm()
    var
        SuspensionLevel: Record "Suspension Level";
    begin
        if SuspensionStartDate = 0D then
            Error('Suspension Start Date must not be blank.');
        if (SuspensionEndDate <> 0D) and (SuspensionEndDate < SuspensionStartDate) then
            Error('Suspension End Date cannot be earlier than Suspension Start Date.');
        if (SuspensionLevelCode <> '') and not SuspensionLevel.Get(SuspensionLevelCode) then
            Error('Suspension Level Code %1 does not exist.', SuspensionLevelCode);
        IsConfirmed := true;
        CurrPage.Close();
    end;
}
