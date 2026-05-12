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
                field("Nepali Fiscal Year"; Rec."Nepali Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Nepali Fiscal Year field.', Comment = '%';
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    ToolTip = 'Specifies the value of the Nepali Year field.', Comment = '%';
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
            action("Create Nepali Fiscal Year")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create Nepali Fiscal Year for next period.';
                trigger OnAction()
                begin
                    Report.RunModal(Report::"Create Nepali Fiscal Year", true, false);
                end;
            }
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
                begin
                    Rec.CloseLeaveYear(true);
                    CurrPage.Update();
                end;
            }
        }
    }
    var
        LeaveYearClosedBoolean: Boolean;
}
