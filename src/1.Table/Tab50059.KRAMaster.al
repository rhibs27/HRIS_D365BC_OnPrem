table 50059 "KRA Master"
{
    DataClassification = CustomerContent;
    // version Remit1.00

    fields
    {
        field(1; "KRA Category"; Code[20])
        {
            trigger OnValidate()
            begin

                if "KRA Category" <> xRec."KRA Category" then begin
                    HRSetup.Get;
                    NoSeries.TestManual(HRSetup."KPI No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[150]) { }
        field(3; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; Type; Enum "KRA Master Type")
        {
            trigger OnValidate()
            begin
                if Type = Rec.Type::"Functional Title" then
                    Question := 'Click here for subjective question'
                else
                    Clear(Question);
            end;
        }
        field(5; Question; Text[50])
        {
            Editable = false;

            trigger OnLookup()
            begin
                if Type = Type::"Functional Title" then begin
                    SubjQuestion.Reset;

                    SubjQuestion.SetRange("Question Code", "KRA Category");
                    Page.RunModal(60056, SubjQuestion);
                end;
            end;
        }
        field(6; "Code"; Code[20])
        {
            TableRelation = if (Type = const("Functional Title")) "Functional Title".Code
            else if (Type = const(Department)) "Organization Structure List".Code where(Type = filter("Deputation Type"::Department));
        }
        field(7; "Weightage (%)"; Integer)
        {
            trigger OnValidate()
            begin

                AppraisalSetup.Get;
                KRAMaster.Reset;
                KRAMaster.SetRange(Code, Code);
                if KRAMaster.FindFirst then
                    repeat
                        Weightage += KRAMaster."Weightage (%)";
                        Message('%1', KRAMaster."Weightage (%)");
                    until KRAMaster.Next = 0;
                if Weightage >= AppraisalSetup.Weightage then
                    Error(Text001, AppraisalSetup.Weightage);
            end;
        }
    }

    keys
    {
        key(Key1; "KRA Category", "Code") { }
        key(Key2; Description) { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        SubjQuestion.Reset;
        SubjQuestion.SetRange("Question Code", "KRA Category");
        SubjQuestion.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if "KRA Category" = '' then begin
            HRSetup.Get;
            HRSetup.TestField("KPI No. Series");
            HrMgt.InitNoSeriesNew(HRSetup."KPI No. Series", xRec."No. Series", 0D, "KRA Category", "No. Series");
        end;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        NoSeries: Codeunit "No. Series";
        HrMgt: Codeunit "HR Mgt.";
        SubjQuestion: Record "Employee Question Setup";
        AppraisalSetup: Record "KRA Master Setup";
        Weightage: Integer;
        KRAMaster: Record "KRA Master";
        Text001: Label 'Total Weightage cannot exceed by %1';

    procedure AssistEdit(): Boolean
    begin
        if "KRA Category" = '' then begin
            HRSetup.Get;
            HRSetup.TestField("KPI No. Series");
            if NoSeries.LookupRelatedNoSeries(HRSetup."KPI No. Series", xRec."No. Series", "No. Series") then begin
                NoSeries.GetNextNo("KRA Category");
                exit(true);
            end;
        end;
    end;
}
