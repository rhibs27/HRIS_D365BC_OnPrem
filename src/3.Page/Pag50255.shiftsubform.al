page 50255 "shift subform"
{
    ApplicationArea = All;
    Caption = 'shift subform';
    PageType = ListPart;
    SourceTable = "Shift Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(employeeNo; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                    Caption = 'Employee No';
                    ApplicationArea = all;
                }
                field(employeeName; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                }
                field(employeeWorkShift; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.', Comment = '%';
                    Caption = 'Employee Work Shift';
                    ApplicationArea = all;
                }
                field(rosterDate; Rec."Roster Date")
                {
                    ToolTip = 'Specifies the value of the Roster Date field.', Comment = '%';
                    Caption = 'rosterDate';
                    ApplicationArea = all;
                }
                field(remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    Caption = 'remarks';
                    ApplicationArea = all;
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    Caption = 'Approval Status';
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Shift Assignment In Range")
            {
                Image = Insert;
                ToolTip = 'Executes the Shift Assignment action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    FilterPage: FilterPageBuilder;
                    ShiftLine: Record "Shift Line";
                    FromDate: Date;
                    ToDate: Date;
                    EmployeeCode: Code[20];
                    ShiftAssignmentHeader: Record "Shift Assignment Header";
                    FromDates: Date;
                    ToDates: Date;
                    EmployeeWorkShift: Code[20];
                begin
                    IF ShiftAssignmentHeader.Get(Rec."No.") THEN
                        if ShiftAssignmentHeader."Approval Status" = ShiftAssignmentHeader."Approval Status"::Open then begin
                            ShiftLine.SetRange("Deputation Code", ShiftAssignmentHeader."Deputation Code");
                            ShiftLine.SetRange("Deputation Type", ShiftAssignmentHeader."Deputation Type");
                            FilterPage.AddRecord('Select Employee Details', ShiftLine);
                            FilterPage.AddField('Select Employee Details', ShiftLine."Employee No");
                            FilterPage.AddField('Select Employee Details', ShiftLine."Employee Work Shift");
                            if FilterPage.RunModal() then begin
                                ShiftLine.SetView(FilterPage.GetView('Select Employee Details'));
                                Evaluate(EmployeeCode, ShiftLine.GetFilter("Employee No"));
                            end;
                            ShiftAssignmentMgt.InsertShiftLine(rec."No.", EmployeeCode, ShiftLine.GetFilter("Employee Work Shift"), ShiftAssignmentHeader."From Date", ShiftAssignmentHeader."To Date");
                            CurrPage.Update();
                        end;
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        SetLayout
    end;

    trigger OnAfterGetRecord()
    begin

        if not GuiAllowed then
            if ShiftAssignmentHeader.Get(rec."No.") then
                if not (ShiftAssignmentHeader."Employee No." = HRMgt.GetEmployeeNo()) then
                    Error('Auth Error');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ShiftAssignmentHeader: Record "Shift Assignment Header";
    begin
        if ShiftAssignmentHeader.Get(Rec."No.") then begin
            Rec.Validate("Deputation Type", ShiftAssignmentHeader."Deputation Type");
            rec.Validate("Deputation Code", ShiftAssignmentHeader."Deputation Code");
        end;
    end;

    var
        DocumentOpen: Boolean;
        DocumentApproved: Boolean;
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
        ShiftAssignmentHeader: Record "Shift Assignment Header";
        HRMgt: Codeunit "HR Mgt.";

    local procedure SetLayout()
    var
        AllowanceHeader: Record "Allowance Assignment Header";
    begin
        if AllowanceHeader.Get(rec."No.") then begin
            DocumentOpen := AllowanceHeader."Approval Status" = AllowanceHeader."Approval Status"::Open;
            DocumentApproved := AllowanceHeader."Approval Status" = AllowanceHeader."Approval Status"::Approved;
        end;
    end;


}
