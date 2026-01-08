table 50055 "KPI Employee"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Appraisal Code"; Code[20])
        {
            trigger OnValidate()
            begin
                if AppraisalRec.Get("Appraisal Code") then begin
                    Validate("KRA Master", AppraisalRec."KRA Category");
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
        field(7; "KRA Master"; Code[50]) { }
        field(8; "KRA Subtype"; Code[20]) { }
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
                KPIEmployee.SetRange("KRA Subtype", "KRA Subtype");
                KPIEmployee.SetFilter("Line No.", '<>%1', "Line No.");
                KPIEmployee.CalcSums("Weightage");
                if KPIEmployee."Weightage" > 100 then
                    Error('Sum of KPIs cannot be greater than 100');
            end;
        }
        field(15; "Self Rating Applicable"; Boolean) { }
        field(17; "Group Performance Based Score"; Decimal) { }
        field(18; "KPI Master Remarks"; Text[150]) { }
        field(19; "Self Score"; Decimal)
        {
            trigger OnValidate()
            begin
                ValidateScoringWithinWeightage("Self Score");
            end;
        }

        field(20; "Self Remarks"; Text[250])
        {
            Caption = 'Self Remarks';
        }
        field(21; "Immediate Supervisor Score"; Decimal)
        {
            Caption = 'Immediate Supervisor Score';
            trigger OnValidate()
            begin
                ValidateScoringWithinWeightage("Immediate Supervisor Score");
            end;
        }

        field(22; "Immediate Supervisor Remarks"; Text[250])
        {
            Caption = 'Immediate Supervisor Remarks';
        }
        field(23; "Reviewer Score"; Decimal)
        {
            Caption = 'Reviewer Score';
            trigger OnValidate()
            begin
                ValidateScoringWithinWeightage("Reviewer Score");
            end;
        }
        field(24; "Reviewer Remarks"; Text[250])
        {
            Caption = 'Reviewer Remarks';
        }
        field(25; "HR Committee Score"; Decimal)
        {
            Caption = 'HR Committee Score';
            trigger OnValidate()
            begin
                ValidateScoringWithinWeightage("HR Committee Score");
            end;
        }
        field(26; "HR Committee Remarks"; Text[250])
        {
            Caption = 'HR Committee Remarks';
        }
        field(28; "Target Assigned"; Decimal) { }
        field(29; "Actual Achievement"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Self Score", Round(("Weightage" * "Actual Achievement") / 100, 0.01, '='));
            end;
        }
        field(30; "Action"; Boolean) { }
        field(31; "From Setup"; Boolean) { }
        field(32; "Deputation on"; Enum "Deputation Type")
        {
            Editable = false;
        }
        field(33; "Hide Delete Action"; Boolean) { }
        field(34; "Self Rating"; Enum "Rating Enum")
        {
            Caption = 'Self Rating';
        }
        field(35; "Immediate Supervisor Rating"; Enum "Rating Enum")
        {
            Caption = 'Immediate Supervisor Rating';
        }
        field(36; "Reviewer Rating"; Enum "Rating Enum")
        {
            Caption = 'Reviewer Rating';
        }
        field(37; "HR Committee Rating"; Enum "Rating Enum")
        {
            Caption = 'HR Committee Rating';
        }

    }
    keys
    {
        key(Key1; "Appraisal Code", "KRA Subtype", "Line No.") { }
    }
    trigger OnInsert()
    begin
        KPIEmployee.Reset;
        KPIEmployee.SetRange("Appraisal Code", "Appraisal Code");
        KPIEmployee.SetRange("KRA Subtype", "KRA Subtype");
        KPIEmployee.SetCurrentKey("Line No.");
        if KPIEmployee.FindLast then
            Validate("Line No.", KPIEmployee."Line No." + 10000)
        else
            Validate("Line No.", 10000);
        if "KPI No." = '' then
            Validate("KPI No.", 'SELF');
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
        if Value > "Weightage" then
            Error('Please enter value within Weightage limit (%1).', "Weightage");
    end;
}