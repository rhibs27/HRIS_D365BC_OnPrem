table 50177 "Score Detail"
{
    Caption = 'Score Detail';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Appraisal Template"; Code[20])
        {
            Caption = 'Appraisal Template';
        }

        field(2; "Fiscal Year"; Code[20])
        {
            Caption = 'Fiscal Year';
        }

        field(3; "Reviewer Type"; Code[20])
        {
            Caption = 'Reviewer Type';
            TableRelation = "Reviewer Setup".Code;

            trigger OnValidate()
            var
                ReviewerSetup: Record "Reviewer Setup";
                AppraisalHeader: Record "Appraisal";
            begin
                Clear("Score/Rating By");

                if not ReviewerSetup.Get("Reviewer Type") then
                    exit;

                if ReviewerSetup."Is Self Review" or ReviewerSetup."Is Group Based" then begin

                    if ("Appraisal Code" = '') or
                       ("Appraisal Template" = '') or
                       ("Fiscal Year" = '') then
                        exit;

                    AppraisalHeader.Reset();
                    AppraisalHeader.SetRange("Appraisal Code", "Appraisal Code");
                    AppraisalHeader.SetRange("Appraisal Template", "Appraisal Template");
                    AppraisalHeader.SetRange("Fiscal Year", "Fiscal Year");

                    if AppraisalHeader.FindFirst() then
                        Validate("Score/Rating By", AppraisalHeader."Employee Code");
                end;
            end;
        }
        field(4; "Score/Rating By"; Code[20])
        {
            Caption = 'Score/Rating By';
            TableRelation = Employee."No.";


        }
        field(5; Sequence; Integer)
        {
            Caption = 'Sequence';
        }

        field(6; Weightage; Decimal)
        {
            Caption = 'Weightage';
        }
        field(7; Total; Decimal)
        {
            Caption = 'Total';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("KPI Employee"."Score Total" where("Appraisal Code" = field("Appraisal Code"), "Reviewer Type" = field("Reviewer Type")));
        }
        field(8; Submitted; Boolean)
        {
            Caption = 'Submitted';
            Editable = false;
        }
        field(9; "Submitted Date"; Date)
        {
            Caption = 'Submitted Date';
        }
        field(10; "Appraisal Code"; Code[20])
        {
            Caption = 'Appraisal Code';
            TableRelation = Appraisal."Appraisal Code";
        }
        field(11; "Line No."; Integer) { }
    }
    keys
    {
        key(PK; "Appraisal Template", "Fiscal Year", "Reviewer Type", "Appraisal Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo("Appraisal Code");
    end;
    local procedure GetNextLineNo(AppraisalCode: Code[20]): Integer
    var
        ScoreDetail: Record "Score Detail";
    begin
        ScoreDetail.Reset();
        ScoreDetail.SetRange("Appraisal Code", AppraisalCode);
        if ScoreDetail.FindLast() then
            exit(ScoreDetail."Line No." + 1);
        exit(1);
    end;

}
