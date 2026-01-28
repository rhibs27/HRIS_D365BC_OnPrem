page 50055 "Salary Deduction Entries"
{
    ApplicationArea = All;
    Caption = 'Salary Deduction Entries';
    PageType = List;
    SourceTable = "Salary Deduction Entry";
    UsageCategory = Lists;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Deduction Type"; Rec."Deduction Type")
                {
                    ToolTip = 'Specifies the value of the Deduction Type field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Deduction Date"; Rec."Deduction Date")
                {
                    ToolTip = 'Specifies the value of the Deduction Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field("Attendance Posted"; Rec."Attendance Posted")
                {
                    ToolTip = 'Specifies the value of the Attendance Posted field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = not Rec."Attendance Posted";
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(ViewAttendance; "View Attendance") { }
            actionref(FilterAttendanceUpdated; "Filter Attendance Updated") { }
            actionref(ClearFilter; "Clear Filter") { }

        }
        area(Navigation)
        {
            action("View Attendance")
            {
                ApplicationArea = All;
                Scope = Repeater;
                Image = ViewCheck;
                RunObject = page "Employee Attendance & Activity";
                RunPageLink = "Employee No." = field("Employee No."), "Attendance Date" = field("Deduction Date");
                RunPageMode = View;
                RunPageView = sorting("Employee No.") order(ascending);
            }
            action("Filter Attendance Updated")
            {
                ApplicationArea = All;
                Scope = Repeater;
                Image = UseFilters;
                trigger OnAction()
                var
                    SalaryDeductionEntry, SalaryDeductionEntry1 : Record "Salary Deduction Entry";
                    EmployeeAttendance: Record "Employee Attendance & Activity";
                    EntryNumberFilter: Text[500];
                begin
                    SalaryDeductionEntry.SetRange("Attendance Document No", Rec."Attendance Document No");
                    SalaryDeductionEntry.SetRange("Deduction Type", Rec."Deduction Type"::Absent);
                    SalaryDeductionEntry.SetRange("Attendance Posted", false);
                    if SalaryDeductionEntry.FindSet() then
                        repeat
                            EmployeeAttendance.SetRange("Employee No.", SalaryDeductionEntry."Employee No.");
                            EmployeeAttendance.SetRange("Attendance Date", SalaryDeductionEntry."Deduction Date");
                            EmployeeAttendance.SetRange("Absent Day", 0);
                            if EmployeeAttendance.FindFirst() then
                                EntryNumberFilter += Format(SalaryDeductionEntry."Entry No.") + '|';
                        until SalaryDeductionEntry.Next() = 0;

                    if EntryNumberFilter.EndsWith('|') then
                        EntryNumberFilter := CopyStr(EntryNumberFilter, 1, StrLen(EntryNumberFilter) - 1);
                    Rec.FilterGroup(2);
                    Rec.SetFilter("Entry No.", EntryNumberFilter);
                    Rec.FilterGroup(0);
                end;
            }
            action("Clear Filter")
            {
                ApplicationArea = All;

                Image = ClearFilter;
                ToolTip = 'Executes the Clear filter action.';
                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    rec.SetRange("Entry No.");
                    Rec.FilterGroup(0);
                end;
            }
        }
    }
}