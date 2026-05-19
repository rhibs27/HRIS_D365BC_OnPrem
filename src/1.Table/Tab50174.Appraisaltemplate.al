table 50174 "Appraisal Template"
{
    Caption = 'Appraisal Template';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Template Master No."; Code[50])
        {
            Caption = 'Template Master No.';
            TableRelation = "Appraisal Setup".Code where(Type = filter("Appraisal Template"));

        }
        field(2; "Fiscal Year"; Code[20])
        {
            Caption = 'Fiscal Year';
            TableRelation = "Pay Cycle Term".Term;
        }
        field(3; "Functional Title"; Text[250])
        {
            Caption = 'Functional Title';
            TableRelation = "Functional Title";
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                ApplyFunctionalTitleFilterLookup("Functional Title");
            end;
        }
        field(4; "Employment Type"; Enum "Employee Type")
        {
            Caption = 'Employment Type';
        }
        field(5; "Appraisal Type"; Enum "Appraisal Type")
        {
            Caption = 'Appraisal Type';
            trigger OnValidate()
            begin
                if "Appraisal Type" <> xRec."Appraisal Type" then begin
                    Clear("Appraisal Subtype Monthly");
                    Clear("Appraisal Subtype Quarterly");
                end;
            end;
        }
        field(6; "Appraisal Subtype Monthly"; Enum "Nepali Month")
        {
            Caption = 'Appraisal Subtype Monthly';
        }
        field(7; "Appraisal Subtype Quarterly"; Enum Quarter)
        {
            Caption = 'Appraisal Subtype Quarterly';
        }
        field(8; "Check Date From"; Enum "Check Date From")
        {
            Caption = 'Check Date From';
        }
        field(9; "Minimum Service Period"; DateFormula)
        {
            Caption = 'Minimum Service Period';
        }
        field(10; "KPI Rating Type"; Enum "KPI Rating Type") { }
    }

    keys
    {
        key(PK; "Template Master No.")
        {
            Clustered = true;
        }
    }
    trigger OnModify()
    var
        KPIMaster: Record "Appraisal KPI Master";
    begin
        KPIMaster.SetRange("Appraisal Template", "Template Master No.");
        if KPIMaster.FindSet() then
            repeat
                KPIMaster."Fiscal Year" := "Fiscal Year";
                KPIMaster."Appraisal Type" := "Appraisal Type";
                KPIMaster."Appraisal Subtype Monthly" := "Appraisal Subtype Monthly";
                KPIMaster."Appraisal Subtype Quarterly" := "Appraisal Subtype Quarterly";
                KPIMaster.Validate("KPI Rating Type", "KPI Rating Type");
                KPIMaster.Modify();
            until KPIMaster.Next() = 0;
    end;


    procedure ApplyFunctionalTitleFilterLookup(var FunctionalTitleFilter: Text)
    var
        FunctionalTitle: Record "Functional Title";
        FunctionalTitles: Page "Functional Title List";
    begin
        Clear(FunctionalTitles);
        FunctionalTitle.Reset();
        FunctionalTitles.SetTableView(FunctionalTitle);
        FunctionalTitles.SetRecord(FunctionalTitle);
        FunctionalTitles.LookupMode(true);
        FunctionalTitles.Editable(false);

        if FunctionalTitles.RunModal() = Action::LookupOK then begin
            FunctionalTitles.SetSelectionFilter(FunctionalTitle);
            if FunctionalTitle.FindSet() then
                repeat
                    AppendFunctionalTitleData(FunctionalTitle.Code, FunctionalTitleFilter, '|');
                until FunctionalTitle.Next() = 0;
        end;
    end;

    procedure AppendFunctionalTitleData(FieldText: Text; var MainText: Text; AppendText: Text)
    var
        SplitText: List of [Text];
    begin
        SplitText := MainText.Split(AppendText);
        if SplitText.IndexOf(FieldText) > 0 then
            exit;
        if FieldText <> '' then
            if MainText <> '' then
                MainText += AppendText + FieldText
            else
                MainText := FieldText;
    end;
}
