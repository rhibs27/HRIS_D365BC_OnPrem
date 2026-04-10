table 50013 "Training Calendar"
{
    DrillDownPageId = "Training Calendar Card";
    LookupPageId = "Training Calendar Lists";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Training Calendar No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Master Code"; Code[20])
        {
            TableRelation = "Training Master".Code where("Master Type" = filter("Training Setup Type"::" "));
            trigger OnValidate()
            begin
                if TrainingMaster.Get("Master Code") then
                    Validate("Master Description", TrainingMaster.Description)
                else
                    Clear("Master Description");
            end;
        }
        field(3; "Master Description"; Text[250])
        {
            Editable = false;
        }
        field(4; "Coverage Branch"; Code[500])
        {
            trigger OnLookup()
            begin
                Validate("Coverage Branch", HRMgt.LookupBranch(''));
            end;
        }
        field(5; "Coverage Department"; Code[500])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            trigger OnLookup()
            begin
                Validate("Coverage Department", HRMgt.LookupDepartment(''));
            end;
        }
        field(6; "Coverage Functional Title"; Code[100])
        {
            trigger OnLookup()
            begin
                Validate("Coverage Functional Title", HRMgt.LookupFunctionalTitile("Coverage Functional Title"));
            end;
        }
        field(7; Valley; Enum "Outside/Inside Valley") { }
        field(8; "Resource person"; enum "Resource person") { }
        field(9; "Assigned Person"; Code[20]) { }
        field(10; "Expected Venue"; Text[30])
        {
        }
        field(11; District; Code[20])
        {
            TableRelation = District;
        }
        field(12; "Minimum Participant"; Integer) { }
        field(13; "Maximum Participant"; Integer) { }
        field(14; "Function"; Enum "Training Function Type") { }
        field(15; "Training Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Cost", "Training Cost" + "Trainer Cost");
            end;
        }
        field(16; "Trainer Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Cost", "Training Cost" + "Trainer Cost");
            end;
        }
        field(17; "Total Cost"; Decimal)
        {
            Editable = false;
        }
        field(19; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; Quarter; Enum Quarter) { }
        field(21; Province; Code[500])
        {
            trigger OnLookup()
            begin
                Validate(Province, HRMgt.LookupProvinceOrganization());
            end;
        }
        field(22; "Training Nature"; Enum "Training Nature") { }
        field(23; "Training Institute Name"; Text[250])
        {
            trigger OnLookup()
            var
                TrgMaster: Record "Training Master";
                TrgMasterPage: Page "Training Master";
            begin
                TrgMaster.SetRange("Master Type", TrgMaster."Master Type"::"Training Institute");
                TrgMasterPage.SetTableView(TrgMaster);
                TrgMasterPage.LookupMode(true);
                if TrgMasterPage.RunModal() = Action::LookupOK then begin
                    TrgMasterPage.GetRecord(TrgMaster);
                    "Training Institute Name" := TrgMaster.Description;
                end;
            end;
        }
        field(24; "Training Category"; Text[250])
        {
            trigger OnLookup()
            var
                TrgMaster: Record "Training Master";
                TrgMasterPage: Page "Training Master";
            begin
                TrgMaster.SetRange("Master Type", TrgMaster."Master Type"::"Training Category");
                TrgMasterPage.SetTableView(TrgMaster);
                TrgMasterPage.LookupMode(true);
                if TrgMasterPage.RunModal() = Action::LookupOK then begin
                    TrgMasterPage.GetRecord(TrgMaster);
                    "Training Category" := TrgMaster.Description;
                end;
            end;
        }
        field(25; "Training Module"; Text[250])
        {
            trigger OnLookup()
            var
                TrgMaster: Record "Training Master";
                TrgMasterPage: Page "Training Master";
            begin
                TrgMaster.SetRange("Master Type", TrgMaster."Master Type"::"Training Module");
                TrgMasterPage.SetTableView(TrgMaster);
                TrgMasterPage.LookupMode(true);
                if TrgMasterPage.RunModal() = Action::LookupOK then begin
                    TrgMasterPage.GetRecord(TrgMaster);
                    "Training Module" := TrgMaster.Description;
                end;
            end;
        }
        field(26; "Training Type"; Text[250])
        {
            trigger OnLookup()
            var
                TrgMaster: Record "Training Master";
                TrgMasterPage: Page "Training Master";
            begin
                TrgMaster.SetRange("Master Type", TrgMaster."Master Type"::"Training Type");
                TrgMasterPage.SetTableView(TrgMaster);
                TrgMasterPage.LookupMode(true);
                if TrgMasterPage.RunModal() = Action::LookupOK then begin
                    TrgMasterPage.GetRecord(TrgMaster);
                    "Training Type" := TrgMaster.Description;
                end;
            end;
        }
        field(27; "Training Mode"; Text[250])
        {
            trigger OnLookup()
            var
                TrgMaster: Record "Training Master";
                TrgMasterPage: Page "Training Master";
            begin
                TrgMaster.SetRange("Master Type", TrgMaster."Master Type"::"Training Mode");
                TrgMasterPage.SetTableView(TrgMaster);
                TrgMasterPage.LookupMode(true);
                if TrgMasterPage.RunModal() = Action::LookupOK then begin
                    TrgMasterPage.GetRecord(TrgMaster);
                    "Training Mode" := TrgMaster.Description;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    var
        TrainingCalender: Record "Training Calendar";
    begin
        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Training Calendar No.");
            HRMgt.InitNoSeriesNew(HRSetup."Training Calendar No.", xRec."No. Series", Today, "No.", "No. Series");

            TrainingCalender.ReadIsolation(IsolationLevel::ReadUncommitted);
            TrainingCalender.SetLoadFields("No.");
            while TrainingCalender.Get("No.") do
                "No." := NoSeriesMgt.GetNextNo("No. Series");
        end;
    end;

    var
        TrainingMaster: Record "Training Master";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";

    procedure AssistEdit(OldRecord: Record "Training Calendar"): Boolean
    var
        TrainCal: Record "Training Calendar";
    begin
        TrainCal := Rec;
        HRSetup.Get;
        HRSetup.TestField("Training Calendar No.");
        if NoSeriesMgt.LookupRelatedNoSeries(HRSetup."Training Calendar No.", OldRecord."No. Series", TrainCal."No. Series") then begin
            NoSeriesMgt.GetNextNo(TrainCal."No.");
            Rec := TrainCal;
            exit(true);
        end;
    end;
}
