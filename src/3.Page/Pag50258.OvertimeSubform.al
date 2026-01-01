page 50258 "Overtime Subform"
{
    ApplicationArea = All;
    Caption = 'Overtime Subform';
    PageType = ListPart;
    SourceTable = "Overtime Line";
    AutoSplitKey = true;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(employeeName; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    Caption = 'Employee Name';
                    ApplicationArea = All;
                }
                field(employeeWorkShift; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.', Comment = '%';
                    Caption = 'Employee Work Shift';
                    ApplicationArea = All;
                }
                field(dayType; Rec."Day Type")
                {
                    ToolTip = 'Specifies the value of the Day Type field.', Comment = '%';
                    Caption = 'Day Type';
                    ApplicationArea = All;
                }
                field(overtimeDate; Rec."Overtime Date")
                {
                    ToolTip = 'Specifies the value of the Overtime Date field.', Comment = '%';
                    Caption = 'Overtime Date';
                    ApplicationArea = All;
                }
                field(checkInTime; Rec."Check In Time")
                {
                    ToolTip = 'Specifies the value of the Check In Time field.', Comment = '%';
                    Caption = 'Check In Time';
                    ApplicationArea = All;
                }
                field(checkOutTime; Rec."Check Out Time")
                {
                    Caption = 'Check Out Time';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check Out Time field.', Comment = '%';
                }
                field(totalOTHours; Rec."Total OT Hours")
                {
                    Caption = 'Total OT Hours';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total OT Hours field.', Comment = '%';
                }
                field(actualOTHours; Rec."Actual OT hours")
                {
                    ToolTip = 'Specifies the value of the Actual OT hours field.', Comment = '%';
                    Caption = 'Actual OT Hours';
                    ApplicationArea = All;
                }
                field(oTAmount; Rec."OT Amount")
                {
                    ToolTip = 'Specifies the value of the OT Amount field.', Comment = '%';
                    Caption = 'OT Amount';
                    ApplicationArea = All;
                }
                field(overnightShift; Rec."OverNight Shift")
                {
                    ToolTip = 'Specifies the value of the OverNight Shift field.', Comment = '%';
                    Caption = 'OverNight Shift';
                    ApplicationArea = All;
                }
                field(remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    Caption = 'Remarks';
                    ApplicationArea = All;
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
        }
    }
    var
        Overtime: Record OverTime;
        HRMgt: Codeunit "HR Mgt.";

    trigger OnAfterGetRecord()
    begin
        if not GuiAllowed then
            if Overtime.Get(rec."No.") then
                if not HrMgt.IsSaaS() then
                    if not (Overtime."Employee No." = HRMgt.GetEmployeeNo()) then
                        Error('Auth Error');
    end;
}
