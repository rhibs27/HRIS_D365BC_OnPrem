page 50285 "KPI Appraisal Yearly Subform"
{
    // version KPI1.00

    PageType = ListPart;
    SourceTable = "KPI Appraisal Bank Lines";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("KPI Code"; Rec."KPI Code")
                {
                    ToolTip = 'Specifies the value of the KPI Code field.';
                    ApplicationArea = All;
                }
                field("KPI Description"; Rec."KPI Description")
                {
                    ToolTip = 'Specifies the value of the KPI Description field.';
                    ApplicationArea = All;
                }
                field("Weightage %"; Rec."Weightage %")
                {
                    ToolTip = 'Specifies the value of the Weightage % field.';
                    ApplicationArea = All;
                }
                field(Target; Rec.Target)
                {
                    // DrillDownPageID = 60286;
                    ToolTip = 'Specifies the value of the Target field.';
                }
                field(Actual; Rec.Actual)
                {
                    ToolTip = 'Specifies the value of the Actual field.';
                    // DrillDownPageID = 60286;
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.';
                    // DrillDownPageID = 60286;
                }
                field("Reviewer's Score"; Rec."Reviewer's Score")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Reviewer''s Score field.';
                    ApplicationArea = All;
                }
                field("Check Reviewer's Score"; Rec."Check Reviewer's Score")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Check Reviewer''s Score field.';
                    ApplicationArea = All;
                }
                field("Final Reviewer's Score"; Rec."Final Reviewer's Score")
                {
                    ToolTip = 'Specifies the value of the Final Reviewer''s Score field.';
                    ApplicationArea = All;
                }
                field("KPI Type"; Rec."KPI Type")
                {
                    ToolTip = 'Specifies the value of the KPI Type field.';
                    ApplicationArea = All;
                }
                field(Quarter; Rec.Quarter)
                {
                    ToolTip = 'Specifies the value of the Quarter field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        KPIAppriasalRecordLine.Reset;
        KPIAppriasalRecordLine.SetRange("Employee Code", Rec."Employee Code");
        KPIAppriasalRecordLine.SetRange("Fiscal Year", Rec."Fiscal Year");
        KPIAppriasalRecordLine.SetRange("KPI Code", Rec."KPI Code");
        if KPIAppriasalRecordLine.FindSet then
            repeat
                if KPIAppriasalRec.Get(KPIAppriasalRecordLine."Appraisal Code") then begin
                    if not KPIAppriasalRec."Closed KPI" then begin
                        KPIAppriasalRecordLine.CalcFields(KPIAppriasalRecordLine.Score);
                        NetKPIScore += KPIAppriasalRecordLine.Score;
                    end
                    else if KPIAppriasalRec."Closed KPI" then
                        NetKPIScore += KPIAppriasalRecordLine."Final Reviewer's Score";
                end;
            until KPIAppriasalRecordLine.Next = 0;
        KPIAppriasalRecordLine1.Reset;
        KPIAppriasalRecordLine1.SetRange("Employee Code", Rec."Employee Code");
        KPIAppriasalRecordLine1.SetRange("Fiscal Year", Rec."Fiscal Year");
        KPIAppriasalRecordLine1.SetRange("KPI Code", Rec."KPI Code");
        NoOfAppriasalPeriod := KPIAppriasalRecordLine1.Count;
        YearlyKPIScore := NetKPIScore / NoOfAppriasalPeriod;
    end;

    var
        YearlyKPIScore: Decimal;
        KPIAppriasalRecordLine: Record "KPI Appraisal Bank Lines";
        KPIAppriasalRec: Record "KPI Appraisal Header Bank";
        NetKPIScore: Decimal;
        KPIAppriasalRecordLine1: Record "KPI Appraisal Bank Lines";
        NoOfAppriasalPeriod: Decimal;
}
