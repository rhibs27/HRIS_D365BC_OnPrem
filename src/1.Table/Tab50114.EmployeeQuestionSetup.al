table 50114 "Employee Question Setup"
{
    Caption = 'Employee Question Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Question Code"; Code[20])
        {
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
        field(2; "Line No."; Integer) { }
        field(3; Question; Text[250]) { }
        field(4; Type; Enum "Employee Question Type")
        {

        }
        field(5; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Sub Type"; Enum "Employee Question SubType")
        {

        }
    }

    keys
    {
        key(Key1; "Question Code", "Line No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        QASubj.Reset;
        QASubj.SetRange(Type, Type::Training);
        QASubj.SetRange("Question Code", "Question Code");
        QASubj.SetRange("Line No.", "Line No.");
        QASubj.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if Type = Type::Training then begin
            if "Question Code" = '' then begin
                HRSetup.Get;
                HRSetup.TestField("Training Question");
                NoMgmt.InitSeries(HRSetup."Training Question", xRec."No. Series", Today, "Question Code", "No. Series");
            end;
        end;
    end;

    var
        QASubj: Record "Employee Feedback";
        HRSetup: Record "Human Resources Setup";
        NoMgmt: Codeunit NoSeriesManagement;

    procedure AssistEdit(OldTrainQuest: Record "Employee Question Setup"): Boolean
    var
        TrainQuest: Record "Employee Question Setup";
    begin
        TrainQuest := Rec;
        HRSetup.Get;
        if TrainQuest.Type = TrainQuest.Type::Training then begin
            HRSetup.TestField("Training Question");
            if NoMgmt.SelectSeries(HRSetup."Training Question", OldTrainQuest."No. Series", TrainQuest."No. Series") then begin
                NoMgmt.SetSeries(TrainQuest."Question Code");
                Rec := TrainQuest;
                exit(true);
            end;
        end;
    end;
}
