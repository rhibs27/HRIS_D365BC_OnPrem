table 50058 "KPI Master"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "KPI No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "KPI No." <> xRec."KPI No." then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."KPI No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(4; "Weightage (%)"; Integer)
        {
            Description = 'Weightage given in percentage';
        }
        field(5; "Target Assigned"; Integer)
        {
            Description = 'Target always given as 100';
        }
        field(6; Remarks; Text[150]) { }
        field(7; "Appraisal Type"; Enum "Appraisal Type")
        {
            trigger OnValidate()
            begin
                if "Appraisal Type" <> xRec."Appraisal Type" then begin
                    Clear("Appraisal Subtype Monthly");
                    Clear("Appraisal Subtype Quarterly");
                end;
            end;
        }
        field(8; "Fiscal Year"; Code[20])
        {
            Editable = false;
        }
        field(9; Description; Text[250]) { }
        field(10; "Appraisal Subtype Monthly"; Enum "Nepali Month")
        {
            Caption = 'Appraisal Subtype Monthly';
        }
        field(11; "Appraisal Subtype Quarterly"; Enum Quater)
        {
            Caption = 'Appraisal Subtype Quarterly';
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Created Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Created Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year");
            end;
        }
        field(14; "Created By"; Text[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "KPI No.") { }
    }
    trigger OnInsert()
    begin
        if "KPI No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("KPI No. Series");
            HrMgt.InitNoSeriesNew(HRSetup."KPI No. Series", xRec."No. Series", Today, "KPI No.", "No. Series");
        end;

        Validate("Created By", UserId);
        Validate("Created Date", Today);
        Validate("Target Assigned", 100);
    end;

    var
        EngNepDate: Record "English-Nepali Date";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HrMgt: Codeunit "HR Mgt.";
}
