table 50179 "Appraisal KPI Master"
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
        field(3; "KRA"; Code[50])
        {
            TableRelation = "Appraisal Setup".Code where(Type = filter("KRA"));
        }
        field(4; "KPI"; Code[20])
        {
            TableRelation = "Appraisal Setup".Code where(Type = filter("KPI"));
        }
        field(5; "Appraisal Type"; Enum "Appraisal Type")
        {
            Editable = false;
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
            Editable = false;
            Caption = 'Appraisal Subtype Monthly';
        }
        field(7; "Appraisal Subtype Quarterly"; Enum Quarter)
        {
            Editable = false;
            Caption = 'Appraisal Subtype Quarterly';
        }
        field(8; "Employee No."; Code[20])
        {
            TableRelation = Employee."No." WHERE(Status = CONST(Active));
        }
        field(9; "Functional Title"; Text[30])
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
        field(17; "KPI Rating Type"; Enum "KPI Rating Type")
        {
            trigger OnValidate()
            begin
                Clear("Max Score");
                if "KPI Rating Type" = "KPI Rating Type"::Rating then
                    "Max Score" := 5;
                if "KPI Rating Type" <> "KPI Rating Type"::Scoring then begin
                    "Group Based" := false;
                    Clear("Group Performance Based Score");
                end;
                if "Group Based" then begin
                    Clear("Self Rating Applicable");
                    "Self Rating Applicable" := false;

                end;
            end;
        }
        field(18; "Weightage"; Decimal)
        {
            Description = 'Weightage';
            MinValue = 0;
        }
        field(19; "Self Rating Applicable"; Boolean) { }
        field(20; "Group Performance Based Score"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            begin
                if "Group Based" and ("Group Performance Based Score" > "Max Score") then
                    Error('Group Performance Based Score %1 cannot exceed Max Score %2.',
                          "Group Performance Based Score", "Max Score");
            end;
        }
        field(21; "KPI Master Remarks"; Text[150]) { }
        field(22; "Created Date"; Date)
        {
            Editable = false;
        }
        field(23; "Created By"; Text[50])
        {
            Editable = false;
        }
        field(24; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(25; "Appraisal Template"; Code[50])
        {
            TableRelation = "Appraisal Template"."Template Master No.";
            trigger OnValidate()
            var
                AppraisalTemplate: Record "Appraisal Template";
            begin
                if "Appraisal Template" <> xRec."Appraisal Template" then begin
                    if AppraisalTemplate.Get("Appraisal Template") then begin
                        "Fiscal Year" := AppraisalTemplate."Fiscal Year";
                        "Appraisal Type" := AppraisalTemplate."Appraisal Type";
                        "Appraisal Subtype Monthly" := AppraisalTemplate."Appraisal Subtype Monthly";
                        "Appraisal Subtype Quarterly" := AppraisalTemplate."Appraisal Subtype Quarterly";
                        Validate("KPI Rating Type", AppraisalTemplate."KPI Rating Type");

                    end else begin
                        Clear("Fiscal Year");
                        Clear("Appraisal Type");
                        Clear("Appraisal Subtype Monthly");
                        Clear("Appraisal Subtype Quarterly");
                        Clear("KPI Rating Type");
                    end;
                end;
            end;
        }
        field(26; "Group Based"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Group Based" then begin
                    Clear("Self Rating Applicable");
                    "Self Rating Applicable" := false;
                    Clear("Group Performance Based Score");
                end else begin
                    Clear("Group Performance Based Score");
                    "Self Rating Applicable" := true;
                end;
            end;
        }
        field(27; "Max Score"; Decimal)
        {
            MinValue = 0;
            trigger OnValidate()
            begin
                if "Group Based" and ("Group Performance Based Score" > "Max Score") then
                    Error('Group Performance Based Score %1 cannot exceed Max Score %2.',
                 "Group Performance Based Score", "Max Score");
            end;
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
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HrMgt: Codeunit "HR Mgt.";
}
