table 50180 "KPI Employee"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Appraisal Code"; Code[20])
        {
            trigger OnValidate()
            begin
                if AppraisalRec.Get("Appraisal Code") then begin
                    Validate("Appraisal Template", AppraisalRec."Appraisal Template");
                    Validate("Appraisal Type", AppraisalRec."Appraisal Type");
                    Validate("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly");
                    Validate("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");
                end;
            end;
        }
        field(2; "Fiscal Year"; Code[20]) { }
        field(3; "Line No."; Integer) { }
        field(4; "KPI No."; Code[20]) { }
        field(5; "Employee Code"; Code[20]) { }
        field(6; "Employee Name"; Text[50]) { }
        field(7; "KRA"; Code[50]) { }
        field(8; "KPI"; Code[20]) { }
        field(9; "Appraisal Type"; Enum "Appraisal Type") { }
        field(10; "Appraisal Subtype Monthly"; Enum "Nepali Month")
        {
            Caption = 'Appraisal Subtype Monthly';
        }
        field(11; "Appraisal Subtype Quarterly"; Enum Quater)
        {
            Caption = 'Appraisal Subtype Quarterly';
        }
        field(12; "Questionnaire/Description"; Text[500]) { }
        field(13; "KPI Rating Type"; Enum "KPI Rating Type") { }
        field(14; "Weightage"; Decimal)
        {
            trigger OnValidate()
            begin
                KPIEmployee.Reset;
                KPIEmployee.SetRange("Appraisal Code", "Appraisal Code");
                KPIEmployee.SetRange("KPI", "KPI");
                KPIEmployee.SetFilter("Line No.", '<>%1', "Line No.");
                KPIEmployee.CalcSums("Weightage");
                if KPIEmployee."Weightage" > 100 then
                    Error('Sum of KPIs cannot be greater than 100');
                CalculateScoreTotal();
            end;
        }
        field(15; "Self Rating Applicable"; Boolean) { }
        field(16; "KPI Master Remarks"; Text[150]) { }

        // field(28; "Target Assigned"; Decimal) { }
        // field(29; "Actual Achievement"; Decimal)
        // {
        //     trigger OnValidate()
        //     begin
        //         //Validate("Self Score", Round(("Weightage" * "Actual Achievement") / 100, 0.01, '='));
        //     end;
        // }
        // field(30; "Action"; Boolean) { }
        // field(31; "From Setup"; Boolean) { }

        // field(33; "Hide Delete Action"; Boolean) { }

        field(17; "Appraisal Template"; Code[50]) { }
        field(18; "Group Based"; Boolean)
        { }
        field(19; "Max Score"; Integer)
        {
            trigger OnValidate()
            begin
                CalculateScoreTotal();
            end;
        }
        field(20; Score; Decimal)
        {
            trigger OnValidate()
            begin
                ValidateScoringWithinWeightage(Score);
                CalculateScoreTotal();
            end;
        }
        field(21; Rating; Enum "Rating Enum")
        {
            trigger OnValidate()
            begin
                CalculateScoreTotal();
            end;
        }
        field(22; Remarks; Text[250])
        { }
        field(23; "Reviewer Type"; Code[20])
        {
            Caption = 'Reviewer Type';
            TableRelation = "Reviewer Setup".Code;

            trigger OnValidate()
            var
                ReviewerSetup: Record "Reviewer Setup";
                AppraisalKPIMaster: Record "Appraisal KPI Master";
            begin
                if ReviewerSetup.Get("Reviewer Type") then begin
                    if ReviewerSetup."Is Group Based" then begin
                        if AppraisalKPIMaster.Get("KPI No.") then begin
                            Validate(Score, AppraisalKPIMaster."Group Performance Based Score");
                            CalculateScoreTotal();
                        end else begin
                            Clear(Score);
                        end;
                    end else begin
                        Clear(Score);
                    end;
                end;
            end;
        }
        field(24; "Score Total"; Decimal)
        {
            Caption = 'Score Total';
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Appraisal Code", "KPI", "Line No.") { }
    }
    trigger OnInsert()
    begin
        KPIEmployee.Reset;
        KPIEmployee.SetRange("Appraisal Code", "Appraisal Code");
        KPIEmployee.SetRange("KPI", "KPI");
        KPIEmployee.SetCurrentKey("Line No.");
        if KPIEmployee.FindLast then
            Validate("Line No.", KPIEmployee."Line No." + 10000)
        else
            Validate("Line No.", 10000);
        CalculateScoreTotal();
    end;

    var
        AppraisalRec: Record Appraisal;
        KPIEmployee: Record "KPI Employee";

    local procedure ValidateScoringWithinWeightage(Value: Decimal)
    begin
        if "KPI Rating Type" <> "KPI Rating Type"::Scoring then
            exit;
        if Value < 0 then
            Error('Value cannot be less than 0.');
        if Value > "Max Score" then
            Error('Please enter value within Weightage limit (%1).', "Max Score");
    end;

    procedure CalculateScoreTotal()
    var
        RatingValue: Integer;
    begin
        if "Group Based" then begin
            if ("Max Score" <> 0) and (Weightage <> 0) then
                "Score Total" := ((Score / "Max Score") * 100) * (Weightage / 100)
            else
                "Score Total" := 0;
            exit;
        end;
        case "KPI Rating Type" of
            "KPI Rating Type"::Scoring:
                begin
                    if ("Max Score" <> 0) and (Weightage <> 0) then
                        "Score Total" := ((Score / "Max Score") * 100) * (Weightage / 100)
                    else
                        "Score Total" := 0;
                end;

            "KPI Rating Type"::Rating:
                begin
                    if ("Max Score" <> 0) and (Weightage <> 0) then begin
                        if Rating = Rating::" " then
                            RatingValue := 0
                        else if Evaluate(RatingValue, Format(Rating)) then
                            "Score Total" := ((RatingValue / "Max Score") * 100) * (Weightage / 100)
                        else
                            "Score Total" := 0;
                    end
                    else
                        "Score Total" := 0;
                end;

            else
                "Score Total" := 0;
        end;
    end;
}