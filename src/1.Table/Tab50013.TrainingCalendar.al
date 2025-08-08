table 50013 "Training Calendar"
{
    DrillDownPageId = "Training Calendar Lists";
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
        field(2; "Training Master code"; Code[20])
        {
            TableRelation = "Training Master";

            trigger OnValidate()
            begin
                if TrainingMaster.Get("Training Master code") then
                    Validate(Description, TrainingMaster.Description)
                else
                    Clear(Description);
            end;
        }
        field(3; Description; Text[250])
        {
            Editable = false;
        }
        field(4; "Coverage Branch"; Code[100])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            // trigger OnLookup()
            // begin
            //     Validate("Coverage Branch", HRMgt.LookupBranch("Coverage Branch", Province, "Sub-Province"));
            // end;
        }
        field(5; "Coverage Department"; Code[100])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            // trigger OnLookup()
            // begin
            //     Validate("Coverage Department", HRMgt.LookupDepartment("Coverage Department"));
            // end;
        }
        field(6; "Coverage Functional Title"; Code[100])
        {
            trigger OnLookup()
            begin
                Validate("Coverage Functional Title", HRMgt.LookupFunctionalTitile("Coverage Functional Title"));
            end;
        }
        field(7; Valley; Enum "Outside/Inside Valley")
        {

        }
        field(8; "Resouce person"; enum "Resouce person")
        {

        }
        field(9; "Assigned Person"; Code[20]) { }
        field(10; "Expected Venue"; Text[30])
        {
            Description = '//not needed';
        }
        field(11; District; Code[20])
        {
            TableRelation = District;
        }
        field(12; "Minimum Participant"; Integer)
        {
        }
        field(13; "Maximum Participant"; Integer)
        {
        }
        field(14; "Function"; Enum "Training Function Type")
        {
        }
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
        field(18; "Training Type"; Enum "Training Type")
        {

        }
        field(19; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; Quater; Enum Quater)
        {
        }
        field(21; Province; Code[100])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            // trigger OnLookup()
            // begin
            //     Validate(Province, HRMgt.SetCalendarHolidayProvience(Province));
            // end;
        }
        // field(22; "Sub-Province"; Code[250])
        // {
        //     trigger OnLookup()
        //     begin
        //         Validate("Sub-Province", HRMgt.LookupSubProvinceTraining("Sub-Province", Province));
        //     end;
        // }
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

        //NoseriesNew
        // if "No." = '' then begin
        //     HRSetup.Get();
        //     HRSetup.TestField("Training Calendar No.");
        //     "No. Series" := HRSetup."KPI No. Series";
        //     if NoSeries.AreRelated(HRSetup."KPI No. Series", xRec."No. Series") then
        //         "No. Series" := xRec."No. Series";
        //     "No." := NoSeries.GetNextNo("No. Series");
        // end;
    end;

    var
        TrainingMaster: Record "Training Master";
        NoSeriesMgt: Codeunit "No. Series";
        // NOseries: Codeunit "No. Series";
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
