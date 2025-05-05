page 50103 "Allowance Assignments (Screen)"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Allowance Assignment Line";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Control27)
            {
                ShowCaption = false;
                field(EnglishMonth; EnglishMonth)
                {
                    Caption = 'English Month';
                    ToolTip = 'Specifies the value of the English Month field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        GetEnglishDateFilter;
                    end;
                }
                field(EnglishYear; EnglishYear)
                {
                    BlankZero = true;
                    Caption = 'English Year';
                    ToolTip = 'Specifies the value of the English Year field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        GetEnglishDateFilter;
                    end;
                }
            }
            repeater(Control2)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(Week; Rec.Week)
                {
                    ToolTip = 'Specifies the value of the Week field.';
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                }
                field("Allowance Type"; Rec."Allowance Type")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.';
                    ApplicationArea = All;
                }
                field("Allowance Amount"; Rec."Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Allowance Amount field.';
                    ApplicationArea = All;
                }
                // field("Is Substitute"; Rec."Is Substitute")
                // {
                //     ToolTip = 'Specifies the value of the Is Substitute field.';
                //     ApplicationArea = All;
                // }
                field("Substitute of Line No."; Rec."Substitute of Line No.")
                {
                    ToolTip = 'Specifies the value of the Substitue of Line No. field.';
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                    ApplicationArea = All;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                // field("Approved Id"; Rec."Approved Id")
                // {
                //     Visible = false;
                //     ToolTip = 'Specifies the value of the Approved Id field.';
                //     ApplicationArea = All;
                // }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Screen)
            {
                Image = StepInto;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to screen all filtered assignments?', false) then
                        exit;

                    AllowanceMgt.ScreenAllowanceAssignment(Rec, true, Rec.GetFilter("From Date"));

                    Message('Updated.');
                    CurrPage.Update;
                end;
            }
            action(Unscreen)
            {
                Image = Stop;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Unscreen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to unscreen the selected assignment?', false) then
                        exit;

                    AllowanceMgt.ScreenAllowanceAssignment(Rec, false, Rec.GetFilter("From Date"));
                    Message('Updated.');
                    CurrPage.Update;
                end;
            }
            action("Update to Employee Attendance")
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Update to Employee Attendance action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you update to employee attendance and activity?', false) then begin
                        AllowanceMgt.InsertAllowanceAssignmentDays;
                    end;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Reject action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject this document?', false) then
                        AllowanceMgt.RejectAllowanceAssigment(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnglishMonth := EnglishMonth::" ";
        EnglishYear := 0;
    end;

    var
        LoanMgt: Codeunit "Loan Mgt.";
        EnglishMonth: Enum "English Month";
        EnglishYear: Integer;
        FromDate: Date;
        ToDate: Date;
        HRMgt: Codeunit "HR Mgt.";
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";

    local procedure GetEnglishDateFilter()
    var
        EnglishNepaliDate: Record "English-Nepali Date";
    begin
        if (EnglishYear <> 0) and (EnglishMonth <> EnglishMonth::" ") then begin
            EnglishNepaliDate.Reset;
            EnglishNepaliDate.SetRange("English Year", EnglishYear);
            EnglishNepaliDate.SetRange("English Month", EnglishMonth);
            EnglishNepaliDate.FindFirst;
            FromDate := EnglishNepaliDate."English Date";

            EnglishNepaliDate.FindLast;
            ToDate := EnglishNepaliDate."English Date";
            //FILTERGROUP(2);
            Rec.SetFilter("From Date", '%1..%2', FromDate, ToDate);
            //FILTERGROUP(0);
        end else begin
            Rec.Reset;
        end;

        CurrPage.Update(false);
    end;
}
