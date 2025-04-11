page 50291 "KPI Appraisals Bank List"
{
    // version KPI1.00

    CardPageId = "KPI Appriasal Province";
    PageType = List;
    SourceTable = "KPI Appraisal Header Bank";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
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
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(0);
        Rec.SetFilter(Type, '%1|%2|%3', Rec.Type::Functional, Rec.Type::"Department Central Level", Rec.Type::"Department Province Level");
        //FilterMonthlyKPI;
        Rec.FilterGroup(2);
    end;

    local procedure GetNextAccPeriodStartDate(CurrentDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.Reset;
        AccountingPeriod.SetFilter("Starting Date", '>%1', CurrentDate);
        if AccountingPeriod.FindFirst then
            exit(AccountingPeriod."Starting Date");
    end;

    local procedure FilterMonthlyKPI()
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetFilter("Starting Date", '<=%1', Today);
        if AccountingPeriod.FindLast then
            Rec.SetFilter("Date Filter", '%1..%2', AccountingPeriod."Starting Date", GetNextAccPeriodStartDate(Today) - 1);
    end;
}
