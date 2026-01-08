table 50067 "Appraisal KPI Master"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Fiscal Year"; Code[20])
        {
            Editable = false;
        }
        field(2; "KPI No."; Code[20])
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
        field(3; "KRA Master"; Code[50])
        {
            TableRelation = "Appraisal KRA Master".Code where(Type = filter("KRA Master"));
        }
        field(4; "KRA Subtype"; Code[20])
        {
            TableRelation = "Appraisal KRA Master".Code where(Type = filter("KRA Subtype"));
        }
        field(5; "Appraisal Type"; Enum "Appraisal Type")
        {
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
        field(7; "Appraisal Subtype Quarterly"; Enum Quater)
        {
            Caption = 'Appraisal Subtype Quarterly';
        }
        field(8; "Employee No."; Code[20])
        {
            TableRelation = Employee."No." WHERE(Status = CONST(Active));
        }
        field(9; Designation; Text[30])
        {
            TableRelation = "Salary Level".code;
        }
        field(10; "Province code"; code[20])
        {
            TableRelation = "Organization Structure List".Code where
            ("Type" = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            begin

                if "Province code" <> xRec."Province code" then begin
                    Clear("Branch Code");
                    Clear("Extension Counter Code");
                end;
            end;
        }
        field(11; "Branch Code"; code[20])
        {
            TableRelation = "Organization Structure line"."Reporting Code" where
            (Type = filter("Deputation Type"::Province), Code = field("Province code"), "Reporting Type" = filter("Deputation Type"::Branch));
            trigger OnValidate()
            begin
                if "Branch Code" <> xRec."Branch Code" then
                    Clear("Extension Counter Code");
            end;
        }
        field(12; "Extension Counter Code"; code[20])
        {
            TableRelation = "Organization Structure line"."Reporting Code" where
            (Type = filter("Deputation Type"::Branch), Code = field("Branch Code"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"));
        }
        field(13; "Department Code"; code[20])
        {
            TableRelation = "Organization Structure List".Code where
            ("Type" = filter("Deputation Type"::Department), Blocked = filter(false));
            trigger OnValidate()
            begin
                if "Department Code" <> xRec."Department Code" then
                    Clear("Unit Code");
            end;
        }
        field(14; "Unit Code"; code[20])
        {
            TableRelation = "Organization Structure line"."Reporting Code" where
            (Type = filter("Deputation Type"::Department), Code = field("Department Code"), "Reporting Type" = filter("Deputation Type"::Unit));
            trigger OnValidate()
            begin
                if "Unit Code" <> xRec."Unit Code" then
                    Clear("Sub-Unit Code");
            end;
        }
        field(15; "Sub-Unit Code"; code[20])
        {
            TableRelation = "Organization Structure line"."Reporting Code" where
            (Type = filter("Deputation Type"::Unit), Code = field("Unit Code"), "Reporting Type" = filter("Deputation Type"::"Sub-Unit"));
        }
        field(16; "Questionnaire/Description"; Text[500]) { }
        field(17; "Rating Type"; Enum "Appraisal Rating") { }
        field(27; "KPI Rating Type"; Enum "KPI Rating Type")
        {
            trigger OnValidate()
            begin
                if "KPI Rating Type" <> "KPI Rating Type"::"Group Based" then
                    Clear("Group Performance Based Score");
                if "KPI Rating Type" = "KPI Rating Type"::"Group Based" then begin
                    Clear("Self Rating Applicable");
                    "Self Rating Applicable" := false;
                end;
            end;
        }
        field(18; "Weightage"; Integer)
        {
            Description = 'Weightage';
        }
        field(20; "Self Rating Applicable"; Boolean) { }
        field(22; "Group Performance Based Score"; Integer) { }
        field(23; "KPI Master Remarks"; Text[150]) { }
        field(24; "Created Date"; Date)
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
        field(25; "Created By"; Text[50])
        {
            Editable = false;
        }
        field(26; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
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
            "KPI No." := NoSeriesMgt.GetNextNo("No. Series");
        end;
        Validate("Created By", UserId);
        Validate("Created Date", Today);
    end;

    var
        EngNepDate: Record "English-Nepali Date";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HrMgt: Codeunit "HR Mgt.";
}
