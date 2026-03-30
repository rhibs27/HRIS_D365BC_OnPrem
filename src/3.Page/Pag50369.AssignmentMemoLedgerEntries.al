page 50369 "Assignment Memo Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Assignment Memo Ledger Entries';
    PageType = List;
    SourceTable = "Assignment Memo Ledger Entry";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Enrty No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Enrty No. field.', Comment = '%';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    Editable = false;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.', Comment = '%';
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.', Comment = '%';
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ToolTip = 'Specifies the value of the Nepali Month field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(Open; Rec.Open)
                {
                    ToolTip = 'Specifies the value of the Open field.', Comment = '%';
                }
                field("Employee Activity Type"; Rec."Employee Activity Type")
                {
                    ToolTip = 'Specifies the value of the Employee Activity Type field.', Comment = '%';
                    Editable = false;
                }
                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.', Comment = '%';
                    Editable = false;
                }
                field("Substituted Employee No."; Rec."Substituted Employee No.")
                {
                    ToolTip = 'Specifies the value of the Substituted Employee No. field.', Comment = '%';
                    Editable = false;
                }
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
                    Editable = false;
                }
                field(Claimed; Rec.Claimed)
                {
                    ToolTip = 'Specifies the value of the Claimed field.', Comment = '%';
                }
                field("Claimed Doc No."; Rec."Claimed Doc No.")
                {
                    ToolTip = 'Specifies the value of the Claimed Doc No. field.', Comment = '%';
                }
                field(Pannel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Pannel field.', Comment = '%';
                    Editable = false;
                }
                field("Valid From Date"; Rec."Valid From Date")
                {
                    ToolTip = 'Specifies the value of the Valid From Date field.', Comment = '%';
                }
                field("Valid To Date"; Rec."Valid To Date")
                {
                    ToolTip = 'Specifies the value of the Valid To Date field.', Comment = '%';
                }
                field("Blocked for Payroll"; Rec."Blocked for Payroll")
                {
                    ToolTip = 'Specifies the value of the Blocked for Payroll field.', Comment = '%';
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                }
                field("Attendance Checked"; Rec."Attendance Checked")
                {
                    ToolTip = 'Specifies the value of the Attendance Checked field.', Comment = '%';
                    Editable = false;
                }
                field("Payroll Document No."; Rec."Payroll Document No.")
                {
                    ToolTip = 'Specifies the value of the Payroll Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Payroll Posted"; Rec."Payroll Posted")
                {
                    ToolTip = 'Specifies the value of the Payroll Posted field.', Comment = '%';
                    Editable = false;
                }
                field("Payroll Posted Date"; Rec."Payroll Posted Date")
                {
                    ToolTip = 'Specifies the value of the Payroll Posted Date field.', Comment = '%';
                    Editable = false;
                }
                field("Payroll Posted Month"; Rec."Payroll Posted Month")
                {
                    ToolTip = 'Specifies the value of the Payroll Posted Month field.', Comment = '%';
                    Editable = false;
                }
                field("No. of Children"; Rec."No. of Children")
                {
                    ToolTip = 'Specifies the value of the No. of Children field.', Comment = '%';
                    Editable = false;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Update Nepali Months")
            {
                Caption = 'Update Nepali Months';
                ToolTip = 'Updates the Nepali Month field for the selected ledger entries.';
                Image = Update;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    AssignMemoLedgEntry: Record "Assignment Memo Ledger Entry";
                begin
                    AssignMemoLedgEntry.SetRange("Nepali Month", AssignMemoLedgEntry."Nepali Month"::" ");
                    if AssignMemoLedgEntry.FindSet() then
                        repeat
                            AssignMemoLedgEntry.Validate("Posting Date");
                            AssignMemoLedgEntry.Modify();
                        until AssignMemoLedgEntry.Next() = 0;
                    Message('Updated Nepali Months for all entries with blank Nepali Month.');
                end;
            }
            action("Update Payroll Months")
            {
                Caption = 'Update Payroll Posted Months';
                ToolTip = 'Updates the Payroll Posted Month field for the selected ledger entries.';
                Image = Update;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    AssignMemoLedgEntry: Record "Assignment Memo Ledger Entry";
                    PostedPayrollHdr: Record "Posted Payroll Header";
                begin
                    AssignMemoLedgEntry.SetRange("Payroll Posted", true);
                    AssignMemoLedgEntry.SetRange("Payroll Posted Month", AssignMemoLedgEntry."Payroll Posted Month"::" ");
                    if AssignMemoLedgEntry.FindSet() then
                        repeat
                            PostedPayrollHdr.Get(AssignMemoLedgEntry."Payroll Document No.");
                            AssignMemoLedgEntry."Payroll Posted Month" := PostedPayrollHdr."Nepali Month";
                            AssignMemoLedgEntry."Payroll Posted Date" := PostedPayrollHdr."Posting Date";
                            AssignMemoLedgEntry.Modify();
                        until AssignMemoLedgEntry.Next() = 0;
                    Message('Complete.');
                end;
            }

        }
    }
    trigger OnModifyRecord(): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());
        if not UserSetup."Is Admin" then
            Error('You do not have permission to modify records in this page.');
    end;
}