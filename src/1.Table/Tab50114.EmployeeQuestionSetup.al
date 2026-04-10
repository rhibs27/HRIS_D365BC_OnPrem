table 50114 "Employee Question Setup"
{
    Caption = 'Employee Question Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Question Code"; Code[20])
        {
            Editable = false;
            trigger OnValidate()
            begin
                if Type = Type::Training then
                    if "Question Code" <> '' then begin
                        HRSetup.Get;
                        NoMgmt.TestManual(HRSetup."Training Question");
                        "No. Series" := '';
                    end;
            end;
        }
        field(2; "Is Subjective"; Boolean) { }
        field(3; Question; Text[250]) { }
        field(4; Type; Enum "Employee Question Type") { }
        field(5; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Sub Type"; Enum "Employee Question SubType") { }
    }

    keys
    {
        key(Key1; "Question Code") { }
    }

    fieldgroups { }
    trigger OnInsert()
    begin
        if Type = Type::Training then begin
            if "Question Code" = '' then begin
                HRSetup.Get;
                HRSetup.TestField("Training Question");
                HRMgt.InitNoSeriesNew(HRSetup."Training Question", xRec."No. Series", Today, "Question Code", "No. Series");
                EmpQuestSetupRec.ReadIsolation(IsolationLevel::ReadCommitted);
                EmpQuestSetupRec.SetLoadFields("Question Code");
                while EmpQuestSetupRec.Get("Question Code") do
                    "Question Code" := NoMgmt.GetNextNo("No. Series");
            end;
        end;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        NoMgmt: Codeunit "No. Series";
        HRMgt: Codeunit "HR Mgt.";
        EmpQuestSetupRec: Record "Employee Question Setup";

    procedure AssistEdit(OldTrainQuest: Record "Employee Question Setup"): Boolean
    var
        TrainQuest: Record "Employee Question Setup";
    begin
        TrainQuest := Rec;
        HRSetup.Get;
        if TrainQuest.Type = TrainQuest.Type::Training then begin
            HRSetup.TestField("Training Question");
            if NoMgmt.LookupRelatedNoSeries(HRSetup."Training Question", OldTrainQuest."No. Series", TrainQuest."No. Series") then begin
                NoMgmt.GetNextNo(TrainQuest."Question Code");
                Rec := TrainQuest;
                exit(true);
            end;
        end;
    end;
}
