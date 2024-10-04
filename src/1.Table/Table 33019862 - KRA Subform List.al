table 33019862 "KRA Subform List"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "KRA Category"; Code[50])
        {
            TableRelation = "Key Value Master".Code where(Type = const("KRA Category"));
        }
        field(2; Description; Text[250]) { }
        field(3; "Key Result Area"; Code[20])
        {
            TableRelation = "Key Value Master".Code where(Type = const("Key Result Area"));
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
                CalcReviewerFinalScore; //Min
            end;
        }
        field(10; "Reviewers Remarks"; Text[250]) { }
        field(11; "Check Reviewers Score"; Decimal)
        {
            trigger OnValidate()
            begin
                CalcCheckReviewFinalScore; //Min
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
        /*AppraisalForm.RESET;
        IF AppraisalForm.GET("Employee Code","Fiscal Year","KPI Quater") THEN
          IF AppraisalForm.Department THEN
            ERROR('Cannot delete posted documents.');

        KPIActions.RESET;
        KPIActions.SETRANGE(KPIActions."Employee Code","Employee Code");
        KPIActions.SETRANGE(KPIActions."Fiscal Year","Fiscal Year");
        KPIActions.SETRANGE(KPIActions."KPI Quater","KPI Quater");
        KPIActions.SETRANGE(KPIActions."Line No.","Line No.");
        IF KPIActions.FINDSET THEN
          KPIActions.DELETEALL;
        QASubjective.RESET;
        QASubjective.SETRANGE("Employee No.","Employee Code");
        QASubjective.SETRANGE("KPI No.","KPI No.");
        QASubjective.MODIFYALL(Answers,'');
        */
    end;

    trigger OnInsert()
    begin
        //GetKPINo;
        CalcCheckReviewFinalScore; //Min
        CalcReviewerFinalScore; //Min
    end;

    trigger OnModify()
    begin
        //HRMgt.CalculateTotalAppraisalScore("Appraisal Code");
    end;

    local procedure CalcCheckReviewFinalScore()
    var
        AppraisalForm: Record Appraisal;
    begin
        if AppraisalForm.Get("Appraisal Code") then begin //Min
            if AppraisalForm.Status = AppraisalForm.Status::Reviewed then
                "Check Reviewers Final Score" := "Check Reviewers Score" * ("Weightage (%)" / 100);
        end;
    end;

    local procedure CalcReviewerFinalScore()
    var
        AppraisalRec: Record Appraisal;
    begin
        if AppraisalRec.Get("Appraisal Code") then begin //Min
            if AppraisalRec.Status = AppraisalRec.Status::Submitted then
                "Reviewers Final Score" := "Reviewers Score" * ("Weightage (%)" / 100);
        end;
    end;
}
