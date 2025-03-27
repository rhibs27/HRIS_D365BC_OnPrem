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
                    Validate("KRA Category", AppraisalRec."KRA Category");
                    Validate("Appraisal Type", AppraisalRec."Appraisal Type");
                    Validate("Appraisal Subtype Monthly", AppraisalRec."Appraisal Subtype Monthly");
                    Validate("Appraisal Subtype Quarterly", AppraisalRec."Appraisal Subtype Quarterly");
                end;
            end;
        }
        field(2; "Employee Code"; Code[20]) { }
        field(3; "KRA Category"; Code[50]) { }
        field(4; "Key Result Area"; Code[20]) { }
        field(5; "KPI No."; Code[20]) { }
        field(6; Description; Text[250]) { }
        field(7; "Weightage(%)"; Decimal)
        {
            trigger OnValidate()
            begin
                KPIEmployee.Reset;
                KPIEmployee.SetRange("Appraisal Code", "Appraisal Code");
                KPIEmployee.SetRange("Key Result Area", "Key Result Area");
                KPIEmployee.SetFilter("Line No.", '<>%1', "Line No.");
                KPIEmployee.CalcSums("Weightage(%)");
                if KPIEmployee."Weightage(%)" > 100 then
                    Error('Sum of KPIs cannot be greater than 100');
            end;
        }
        field(8; "Target Assigned"; Decimal) { }
        field(9; "Actual Achievement"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate(Score, Round(("Weightage(%)" * "Actual Achievement") / 100, 0.01, '='));
            end;
        }
        field(10; "Action"; Boolean) { }
        field(11; Score; Decimal)
        {
            trigger OnValidate()
            var
                //HRMgt: Codeunit "HR Mgt.";
                AppraisalMgt: Codeunit "AppraisalMgt.";
            begin
                Modify();
                AppraisalRec.Get("Appraisal Code");
                AppraisalMgt.CalculateKPIMarks(AppraisalRec);
            end;
        }
        field(12; "Fiscal Year"; Code[10])
        {
        }
        field(13; "Appraisal Type"; Enum "Appraisal Type")
        {

        }
        field(14; "Appraisal Subtype Monthly"; Enum "Nepali Month")
        {
            Caption = 'Appraisal Subtype Monthly';
        }
        field(15; "Appraisal Subtype Quarterly"; Enum Quater)
        {
            Caption = 'Appraisal Subtype Quarterly';

        }
        field(16; "From Setup"; Boolean)
        {
        }
        field(17; "Line No."; Integer)
        {
        }
        field(18; "Deputation on"; Enum "Deputation Type")
        {
            Editable = false;

        }
        field(19; "Hide Delete Action"; Boolean) { }
    }

    keys
    {
        key(Key1; "Appraisal Code", "Key Result Area", "Line No.") { }
        // key(Key2;'')
        // {
        //     Enabled = false;
        // }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        KPIEmployee.Reset;
        KPIEmployee.SetRange("Appraisal Code", "Appraisal Code");
        KPIEmployee.SetRange("Key Result Area", "Key Result Area");
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
}
