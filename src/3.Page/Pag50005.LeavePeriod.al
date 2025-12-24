page 50005 "Leave Period"
{
    ApplicationArea = All;
    Caption = 'Leave Period';
    PageType = List;
    SourceTable = "Accounting Period";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Starting date of the period.';
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ApplicationArea = All;
                    // Editable = false;
                    ToolTip = 'Nepali Month for the period';
                }
                field(Quarterly; Rec.Quarterly)
                {
                    ApplicationArea = All;
                    ToolTip = 'Quarterly  for the period';
                }
                field("New Leave Year"; Rec."New Leave Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the start of a leave year';
                }
                field("Leave Year Closed"; Rec."Leave Year Closed")
                {
                    ApplicationArea = All;
                    Editable = LeaveYearClosedBoolean;
                    ToolTip = 'Specify whether a leave year is closed';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Close Leave Year")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Closes the leave periods of the first open year.';
                trigger OnAction()
                begin
                    Rec.CloseLeaveYear(false);
                    CurrPage.Update();
                end;
            }
            action("Lapse Leave")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Closes the leave periods of the first open year.';
                trigger OnAction()
                var
                    Employee: Record Employee;
                begin
                    Employee.SetRange(Status, Employee.Status::Active);
                    Rec.CloseLeaveYear(true);
                    CurrPage.Update();
                end;
            }
        }
    }
    var
        LeaveYearClosedBoolean: Boolean;
}
