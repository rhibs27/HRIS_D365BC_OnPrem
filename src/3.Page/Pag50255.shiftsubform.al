page 50255 "Shift subform"
{
    ApplicationArea = All;
    Caption = 'Shift subform';
    PageType = ListPart;
    SourceTable = "Shift Line";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(lineNo; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.', Comment = '%';
                    Caption = 'Line No';
                    ApplicationArea = All;
                }
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
                    Caption = 'Roster Date';
                    ApplicationArea = all;
                }
                field(remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    Caption = 'Remarks';
                    ApplicationArea = all;
                }
                field(substituteType; Rec."Substitute Type")
                {
                    ToolTip = 'Specifies the value of the Is Substitute field.';
                    ApplicationArea = All;
                    Caption = 'Substitute Type';
                }
                field(substituteOfLineNo; Rec."Substitute of Line No.")
                {
                    ToolTip = 'Specifies the value of the Substitute of Line No. field.';
                    ApplicationArea = All;
                    Caption = 'Substitute of Line No.';
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
            action("Import From Excel")
            {
                Image = ImportExcel;
                ToolTip = 'Executes the Import From Excel.';
                ApplicationArea = All;
                Visible = DocumentOpen;
                trigger OnAction()
                begin
                    if not Confirm('Do you want Import Shift line From Excel?', false) then
                        exit;
                    DocNo := Rec."No.";
                    ExcelImportMgt.ImportShiftLineFromExcelSheet(DocNo);
                end;
            }
            action("Export Format for Excel")
            {
                Image = ExportFile;
                ToolTip = 'Executes the Export Format for Excel action.';
                ApplicationArea = All;
                Visible = DocumentOpen;
                trigger OnAction()
                var
                begin
                    if not Confirm('Do you want Export Excel format for Shift line?', false) then
                        exit;
                    ExcelImportMgt.ExportShiftAssignmentLineFormat(Rec);
                end;
            }
            action("Shift Assignment In Range")
            {
                Image = Insert;
                ToolTip = 'Executes the Shift Assignment action.';
                ApplicationArea = All;
                Visible = DocumentOpen;
                trigger OnAction()
                var
                    FilterPage: FilterPageBuilder;
                    ShiftLine: Record "Shift Line";
                    EmployeeCode: Code[20];
                    ShiftAssignmentHeader: Record "Shift Assignment Header";
                begin
                    IF ShiftAssignmentHeader.Get(Rec."No.") THEN
                        if ShiftAssignmentHeader."Approval Status" = ShiftAssignmentHeader."Approval Status"::Open then begin
                            if ShiftAssignmentHeader."Deputation Sub Type" = ShiftAssignmentHeader."Deputation Sub Type"::" " then begin
                                ShiftLine.SetRange("Deputation Code", ShiftAssignmentHeader."Deputation Code");
                                ShiftLine.SetRange("Deputation Type", ShiftAssignmentHeader."Deputation Type");
                            end else begin
                                ShiftLine.SetRange("Deputation Code", ShiftAssignmentHeader."Deputation Sub Type Code");
                                ShiftLine.SetRange("Deputation Type", ShiftAssignmentHeader."Deputation Sub Type");
                            end;
                            FilterPage.AddRecord('Select Employee Details', ShiftLine);
                            FilterPage.AddField('Select Employee Details', ShiftLine."Employee No");
                            FilterPage.AddField('Select Employee Details', ShiftLine."Employee Work Shift");
                            if FilterPage.RunModal() then begin
                                ShiftLine.SetView(FilterPage.GetView('Select Employee Details'));
                                Evaluate(EmployeeCode, ShiftLine.GetFilter("Employee No"));
                            end;
                            if EmployeeCode = '' then
                                Error('Please Select Employee');
                            ShiftAssignmentMgt.ValidateEmployeeOnDate(ShiftLine);
                            ShiftAssignmentMgt.InsertShiftLine(rec."No.", EmployeeCode, ShiftLine.GetFilter("Employee Work Shift"), ShiftAssignmentHeader."From Date", ShiftAssignmentHeader."To Date");
                            CurrPage.Update();
                        end;
                end;
            }
            action(Substitute)
            {
                Image = Refresh;
                ToolTip = 'Executes the Substitute action.';
                ApplicationArea = All;
                Visible = DocumentApproved;
                trigger OnAction()
                var
                    ShiftLine: Record "Shift Line";
                    FilterPage: FilterPageBuilder;
                    EmployeeCode: Code[20];
                    Remarks: Text;
                begin
                    Rec.TestField("Substitute type", rec."Substitute Type"::" ");
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    ShiftLine.Reset();
                    ShiftLine.SetRange("Deputation Code", rec."Deputation Code");
                    ShiftLine.SetRange("Deputation Type", rec."Deputation Type");
                    FilterPage.AddRecord('Select Employee Details', ShiftLine);
                    FilterPage.AddField('Select Employee Details', ShiftLine."Employee No");
                    FilterPage.AddField('Select Employee Details', ShiftLine.Remarks);
                    if FilterPage.RunModal() then begin
                        ShiftLine.SetView(FilterPage.GetView('Select Employee Details'));
                        Evaluate(EmployeeCode, ShiftLine.GetFilter("Employee No"));
                        Evaluate(Remarks, ShiftLine.GetFilter(Remarks));
                    end;
                    if EmployeeCode = '' then
                        Error('Please Select Employee');
                    if Rec."Employee No" = EmployeeCode then
                        Error('You cannot substitute Same Employee');
                    ShiftAssignmentMgt.SubstituteShiftLine(rec, EmployeeCode, Remarks);
                end;
            }
            action("Approve Substitute")
            {
                Image = Approve;
                ToolTip = 'Executes the Approve Substitute action.';
                ApplicationArea = All;
                Visible = DocumentApproved;
                trigger OnAction()
                begin
                    Rec.TestField("Substitute Type", Rec."Substitute Type"::"Added as Substitute");
                    Rec.TestField("Approval Status", Rec."Approval Status"::"Pending");
                    Rec.Validate("Approval Status", Rec."Approval Status"::Approved);
                    Rec.Modify();
                    Message('Substitute Allowance is Approved');
                end;
            }
            action("Reject Substitute")
            {
                Image = Reject;
                ToolTip = 'Executes the Reject Substitute action.';
                ApplicationArea = All;
                Visible = DocumentApproved;
                trigger OnAction()
                var
                    Shiftline1: Record "Shift Line";
                begin
                    Rec.TestField("Substitute Type", Rec."Substitute Type"::"Added as Substitute");
                    Rec.TestField("Approval Status", Rec."Approval Status"::"Pending");
                    Rec.Validate("Approval Status", Rec."Approval Status"::Rejected);
                    if Shiftline1.Get(Rec."No.", Rec."Substitute of Line No.") then begin
                        Shiftline1."Substitute Type" := Rec."Substitute Type"::" ";
                        Shiftline1."Approved Date" := Today;
                        Shiftline1.Modify();
                    end;
                    rec.Modify();
                    Message('Substituted shift is Rejected');
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
        SetLayout();
        if not GuiAllowed then
            if ShiftAssignmentHeader.Get(rec."No.") then
                if not HrMgt.IsSaaS() then
                    if not (ShiftAssignmentHeader."Employee No." = HRMgt.GetEmployeeNo()) then
                        Error('Auth Error');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ShiftAssignmentHeader: Record "Shift Assignment Header";
    begin
        if ShiftAssignmentHeader.Get(Rec."No.") then begin
            if ShiftAssignmentHeader."Deputation Sub Type" = ShiftAssignmentHeader."Deputation Sub Type"::" " then begin
                Rec.Validate("Deputation Type", ShiftAssignmentHeader."Deputation Type");
                Rec.Validate("Deputation Code", ShiftAssignmentHeader."Deputation Code");
            end else begin
                Rec.Validate("Deputation Type", ShiftAssignmentHeader."Deputation Sub Type");
                Rec.Validate("Deputation Code", ShiftAssignmentHeader."Deputation Sub Type Code");
            end;
        end;
        SetLayout();
    end;

    var
        DocumentOpen: Boolean;
        DocumentApproved: Boolean;
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
        ShiftAssignmentHeader: Record "Shift Assignment Header";
        HRMgt: Codeunit "HR Mgt.";
        ExcelImportMgt: Codeunit "Excel Import";
        DocNo: Code[20];

    local procedure SetLayout()
    var
        ShiftAssignmentHeader: Record "Shift Assignment Header";
    begin
        if ShiftAssignmentHeader.Get(rec."No.") then begin
            DocumentOpen := ShiftAssignmentHeader."Approval Status" = ShiftAssignmentHeader."Approval Status"::Open;
            DocumentApproved := ShiftAssignmentHeader."Approval Status" = ShiftAssignmentHeader."Approval Status"::Approved;
        end;
    end;
}
