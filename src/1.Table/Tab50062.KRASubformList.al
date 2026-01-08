table 50062 "KRA Subform List"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "KRA Category"; Code[50])
        {
            TableRelation = "Appraisal KRA Master".Code where(Type = const("KRA Master"));
        }
        field(2; Description; Text[250]) { }
        field(3; "Key Result Area"; Code[20])
        {
            TableRelation = "Appraisal KRA Master".Code where(Type = const("KRA Subtype"));
        }
        field(4; "Weightage (%)"; Integer) { }
        field(5; "Appraisal Code"; Code[20]) { }
        field(6; "Final Score"; Decimal) { }
        field(7; "Employee Code"; Code[20]) { }
        field(8; Remarks; Text[250]) { }
        field(9; "Reviewers Score"; Decimal)
        {
            trigger OnValidate()
            begin
                CalcReviewerFinalScore;
            end;
        }
        field(10; "Reviewers Remarks"; Text[250]) { }
        field(11; "Check Reviewers Score"; Decimal)
        {
            trigger OnValidate()
            begin
                CalcCheckReviewFinalScore;
            end;
        }
        field(12; "Check Reviewers Remarks"; Text[250]) { }
        field(13; Score; Decimal) { }
        field(14; "HR Score"; Decimal) { }
        field(15; "HR Remarks"; Text[250]) { }
        field(16; "Check Reviewers Final Score"; Decimal) { }
        field(17; "Reviewers Final Score"; Decimal) { }
    }

    keys
    {
        key(Key1; "Appraisal Code", "Key Result Area") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        /*AppraisalForm.Reset();
        IF AppraisalForm.GET("Employee Code","Fiscal Year","KPI Quater") THEN
          IF AppraisalForm.Department THEN
            ERROR('Cannot delete posted documents.');

        KPIActions.Reset();
        KPIActions.SetRange(KPIActions."Employee Code","Employee Code");
        KPIActions.SetRange(KPIActions."Fiscal Year","Fiscal Year");
        KPIActions.SetRange(KPIActions."KPI Quater","KPI Quater");
        KPIActions.SetRange(KPIActions."Line No.","Line No.");
        IF KPIActions.FINDSET THEN
          KPIActions.DELETEALL;
        QASubjective.Reset();
        QASubjective.SetRange("Employee No.","Employee Code");
        QASubjective.SetRange("KPI No.","KPI No.");
        QASubjective.MODIFYALL(Answers,'');
        */
    end;

    trigger OnInsert()
    begin
        //GetKPINo;
        CalcCheckReviewFinalScore;
        CalcReviewerFinalScore;
    end;

    trigger OnModify()
    begin
        //HRMgt.CalculateTotalAppraisalScore("Appraisal Code");
    end;

    local procedure CalcCheckReviewFinalScore()
    var
        AppraisalForm: Record Appraisal;
    begin
        if AppraisalForm.Get("Appraisal Code") then begin
            if AppraisalForm.Status = AppraisalForm.Status::Reviewed then
                "Check Reviewers Final Score" := "Check Reviewers Score" * ("Weightage (%)" / 100);
        end;
    end;

    local procedure CalcReviewerFinalScore()
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get("Appraisal Code") then begin
            if AppraisalRec.Status = AppraisalRec.Status::Submitted then
                "Reviewers Final Score" := "Reviewers Score" * ("Weightage (%)" / 100);
        end;
    end;
}
