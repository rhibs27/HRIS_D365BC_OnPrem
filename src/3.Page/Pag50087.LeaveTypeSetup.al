page 50087 "Leave Type Setup"
{
    PageType = List;
    SourceTable = "Leave Type Setup";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Days Earned Per Year"; Rec."Days Earned Per Year")
                {
                    ToolTip = 'Specifies the value of the Days Earned Per Year field.';
                    ApplicationArea = All;
                }
                field("Limit Max. Leave at Once"; Rec."Limit Max. Leave at Once")
                {
                    ToolTip = 'Specifies the value of the Limit Max. Leave at Once field.';
                    ApplicationArea = All;
                }
                field("Half Leave Allowed"; Rec."Half Leave Allowed")
                {
                    ToolTip = 'Specifies the if half Leave Allowed';
                    ApplicationArea = All;
                }
                field("Maximum Leave at once"; Rec."Maximum Leave at once")
                {
                    Editable = Rec."Limit Max. Leave at Once";
                    ToolTip = 'Specifies the value of the Maximum Leave at once field.';
                    ApplicationArea = All;
                }
                field("Minimum Leave at once"; Rec."Minimum Leave at once")
                {
                    ToolTip = 'Specifies the value of the Minimum Leave at once field.';
                    ApplicationArea = All;
                }
                field("Exclude Non Working Days"; Rec."Exclude Non Working Days")
                {
                    ToolTip = 'Specifies the value of the Exclude Non Working Days field.';
                    ApplicationArea = All;
                }
                field("Bereavement Leave"; Rec."Bereavement Leave")
                {
                    ToolTip = 'Specifies the value of the Bereavement Leave field.';
                    ApplicationArea = All;
                }
                field("Sick Leave"; Rec."Sick Leave")
                {
                    ToolTip = 'Specifies the value of the Sick Leave field.';
                    ApplicationArea = All;
                }
                field("Maternity/Paternity Leave"; Rec."Maternity/Paternity Leave")
                {
                    ToolTip = 'Specifies the value of the Maternity/Paternity Leave field.';
                    ApplicationArea = All;
                }
                field("Services Period"; Rec."Services Period")
                {
                    ToolTip = 'Specifies the value of the Services Period field.';
                    ApplicationArea = All;
                }
                field("Times Per Service Period"; Rec."Times Per Service Period")
                {
                    Editable = Rec."Services Period";
                    ToolTip = 'Specifies the value of the Times Per Service Period field.';
                    ApplicationArea = All;
                }
                field("Carry Forwardable"; Rec."Carry Forwardable")
                {
                    ToolTip = 'Specifies the value of the Carry Forwardable field.';
                    ApplicationArea = All;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ToolTip = 'Specifies the value of the Pay Type field.';
                    ApplicationArea = All;
                }
                field("Leave For Employee Type"; Rec."Leave For Employee Type")
                {
                    ToolTip = 'Specifies the value of the Leave For Employee Type field.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field("Calculate Proratawise"; Rec."Calculate Proratawise")
                {
                    ToolTip = 'Specifies the value of the Calculate Proratawise field.';
                    ApplicationArea = All;
                }
                field("Compensatory Leave"; Rec.Compensatory)
                {
                    ToolTip = 'Specifies the value of the Compensatory field.';
                    ApplicationArea = All;
                }
                field("Encashable Limit"; Rec."Encashable Limit")
                {
                    ToolTip = 'Specifies the value of the Encashable Limit field.';
                    ApplicationArea = All;
                }
                field("Payroll Attribute"; Rec."Payroll Attribute")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
                field("Leave at Once"; Rec."Leave at Once")
                {
                    ToolTip = 'Specifies the value of the Leave at Once field.';
                    ApplicationArea = All;
                }
                field("Depending Leave"; Rec."Depending Leave")
                {
                    ToolTip = 'Specifies the value of the Depending Leave field.';
                    ApplicationArea = All;
                }
                field("Employment Limit"; Rec."Employment Limit")
                {
                    ToolTip = 'Specifies the value of the Employment Limit field.';
                    ApplicationArea = All;
                }
                field("Needed HR Permission"; Rec."Needed HR Permission")
                {
                    ToolTip = 'Specifies the value of the Needed HR Permission field.';
                    ApplicationArea = All;
                }
                field("No. of Days for Attachment"; Rec."No. of Days for Attachment")
                {
                    ToolTip = 'Specifies the value of the No. of Days for Attachment field.';
                    ApplicationArea = All;
                }
                field("Skip Balance Check"; Rec."Skip Balance Check")
                {
                    ToolTip = 'Specifies the value of the Skip Balance Check field.';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                    ApplicationArea = All;
                }
                field("AML Eligible"; Rec."AML Eligible")
                {
                    ToolTip = 'Specifies the value of the AML Eligible field.';
                    ApplicationArea = All;
                }
                field("Check Balance for Payroll"; Rec."Check Balance for Payroll")
                {
                    ToolTip = 'Specifies the value of the Check Balance for Payroll field.';
                    ApplicationArea = All;
                }
                field("Adjustment Sequence"; Rec."Adjustment Sequence")
                {
                    ToolTip = 'Leave Ajusted sequentially for absent days in Settlement';
                    ApplicationArea = All;
                }
                field("Exclude in Service Period"; Rec."Exclude in Service Period")
                {
                    ToolTip = 'If checked leave taken will not be counted in service period';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if IsLookuped then begin
            Clear(LeaveCodes);
            LeaveTypeSetup.Reset;
            CurrPage.SetSelectionFilter(LeaveTypeSetup);
            if LeaveTypeSetup.FindFirst then
                repeat
                    if LeaveCodes = '' then
                        LeaveCodes := LeaveTypeSetup.Code
                    else
                        LeaveCodes += '|' + LeaveTypeSetup.Code;
                until LeaveTypeSetup.Next = 0;
        end;
    end;

    var
        IsLookuped: Boolean;
        LeaveTypeSetup: Record "Leave Type Setup";
        LeaveCodes: Text[100];

    procedure LookedUpped()
    begin
        IsLookuped := true;
    end;

    procedure ExitLeaveCodes(): Text[100]
    begin
        exit(LeaveCodes);
    end;
}
