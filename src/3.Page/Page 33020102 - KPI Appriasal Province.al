page 33020102 "KPI Appriasal Province"
{
    // version KPI1.00

    PageType = Card;
    SourceTable = "KPI Appraisal Header NIC";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
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
                    Editable = false;
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
                field("KPI Score"; Rec."KPI Score")
                {
                    // DrillDownPageID = 60285;
                    ToolTip = 'Specifies the value of the KPI Score field.';
                    ApplicationArea = All;
                }
                field("KPI Score With Location Inc"; Rec."KPI Score With Location Inc")
                {
                    // DrillDownPageID = 60285;
                    ToolTip = 'Specifies the value of the Location Incentive field.';
                    ApplicationArea = All;
                }
                field("KPI Score With Role Incentive"; Rec."KPI Score With Role Incentive")
                {
                    ToolTip = 'Specifies the value of the Role Incentive field.';
                    ApplicationArea = All;
                    // DrillDownPageID = 60285;
                }
                field("Net KPI Score"; Rec."Net KPI Score")
                {
                    DrillDownPageId = "KPI Daily Incentive";
                    ToolTip = 'Specifies the value of the Net KPI Score field.';
                    ApplicationArea = All;
                }
                field("Approved KPI Score"; Rec."Approved KPI Score")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approved KPI Score field.';
                    ApplicationArea = All;
                }
                field("Net Approved KPI Score"; Rec."Net Approved KPI Score")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Net Approved KPI Score field.';
                    ApplicationArea = All;
                }
            }
            part("KPI Appraisal (NIC) Line"; "KPI Appraisal (NIC) Line")
            {
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Close Quarter")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Close Quarter action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    KPIAppriasalLine.Reset;
                    KPIAppriasalLine.SetRange("Appraisal Code", Rec."Appraisal Code");
                    KPIAppriasalLine.SetRange("Check Reviewer's Score", 0);
                    if KPIAppriasalLine.FindFirst then
                        Error('Check Reviewer Score Cannot be zero in line No. %1', KPIAppriasalLine."Line No.");
                    KPIAppriasalLine.CalcSums("Final Reviewer's Score");
                    Rec."Approved KPI Score" := KPIAppriasalLine."Final Reviewer's Score";
                    Rec.CalcFields("KPI Score With Location Inc");
                    Rec.CalcFields("KPI Score With Role Incentive");
                    Rec."Net Approved KPI Score" := Rec."KPI Score With Location Inc" + Rec."KPI Score With Role Incentive" + Rec."Approved KPI Score";
                    Rec."Closed KPI" := true;
                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //FilterMonthlyKPI;
    end;

    var
        KPIAppriasalLine: Record "KPI Appraisal (NIC) Lines";

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
