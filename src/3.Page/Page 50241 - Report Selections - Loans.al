page 50241 "Report Selections - Loans"
{
    // version NAVW113.00

    ApplicationArea = Basic, Suite;
    Caption = 'Report Selections - Loans';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(ReportUsage; ReportUsage2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage';
                OptionCaption = 'Salary Advance,Personal Loan,Home Loan,Vehicle Loan';
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate()
                begin
                    SetUsageFilter(true);
                end;
            }
            repeater(Control1)
            {
                FreezeColumn = "Report Caption";
                ShowCaption = false;
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageId = Objects;
                    ToolTip = 'Specifies the object ID of the report.';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    LookupPageId = Objects;
                    ToolTip = 'Specifies the display name of the report.';
                }
                field("Use for Email Attachment"; Rec."Use for Email Attachment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the related document will be attached to the email.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.NewRecord;
    end;

    trigger OnOpenPage()
    begin
        SetUsageFilter(false);
    end;

    var
        ReportUsage2: Option "Salary Advance","Personal Loan","Home Loan","Vehicle Loan";

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
            if Rec.Modify then;
        Rec.FilterGroup(2);
        case ReportUsage2 of
            ReportUsage2::"Salary Advance":
                Rec.SetRange(Usage, Rec.Usage::"Salary Advance");
            ReportUsage2::"Personal Loan":
                Rec.SetRange(Usage, Rec.Usage::"Personal Loan");
            ReportUsage2::"Home Loan":
                Rec.SetRange(Usage, Rec.Usage::"Home Loan");
            ReportUsage2::"Vehicle Loan":
                Rec.SetRange(Usage, Rec.Usage::"Vehicle Loan");
        end;
        Rec.FilterGroup(0);
        CurrPage.Update;
    end;
}
