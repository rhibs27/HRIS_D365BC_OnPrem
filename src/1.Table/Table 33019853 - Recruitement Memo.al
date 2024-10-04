table 33019853 "Recruitement Memo"
{
    // version NIC Asia 1.0,Recruitement

    DrillDownPageId = "Recruitment Memo List";
    LookupPageId = "Recruitment Memo List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Reference No."; Code[30]) { }
        field(2; Subject; Text[80]) { }
        field(3; "Date of Request"; Date) { }
        field(4; "HRSC Meeting No."; Text[30]) { }
        field(5; Posted; Boolean)
        {
            Editable = false;
        }
        field(6; "Memo No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Memo No." <> '' then begin
                    HRSetup.Get;
                    HRSetup.TestField("Recruitment No. Series");
                    NoSeriesMgt.TestManual(HRSetup."Recruitment No. Series");
                end;
            end;
        }
        field(7; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(8; Type; Enum InternalExternal)
        {

            trigger OnValidate()
            begin
                RecruitementLine.Reset;
                RecruitementLine.SetRange("Memo No.", "Memo No.");
                if RecruitementLine.FindFirst then
                    Error('Please delete the recruitement lines first.');
            end;
        }
        field(9; "Created DateTime"; DateTime)
        {
            Editable = false;
        }
        field(10; "Created by"; Text[50])
        {
            Editable = false;
        }
        field(11; "No. Series"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Memo No.") { }
        key(Key2; "Reference No.") { }
    }

    fieldgroups
    {
        fieldgroup("Drop-Down"; Type, Subject) { }
    }

    trigger OnDelete()
    begin
        TestField(Posted, false);
        RecruitementLine.Reset;
        RecruitementLine.SetRange("Memo No.", "Memo No.");
        RecruitementLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        "Created by" := UserId;
        "Created DateTime" := CurrentDateTime;
        if "No. Series" = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Recruitment No. Series");
            NoSeriesMgt.InitSeries(HRSetup."Recruitment No. Series", xRec."No. Series", Today, "Memo No.", "No. Series");
        end;
    end;

    trigger OnModify()
    begin
        TestField(Posted, false);
    end;

    var
        RecruitementLine: Record "Recruitement Memo Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        RecruitmentMemo: Record "Recruitement Memo";

    procedure AssistEdit(OldRecruitmentMemo: Record "Recruitement Memo"): Boolean
    begin
        RecruitmentMemo := Rec;
        HRSetup.Get;
        HRSetup.TestField("Recruitment No. Series");
        if NoSeriesMgt.SelectSeries(HRSetup."Recruitment No. Series", OldRecruitmentMemo."No. Series", RecruitmentMemo."No. Series") then begin
            NoSeriesMgt.SetSeries(RecruitmentMemo."Memo No.");
            Rec := RecruitmentMemo;
            exit(true);
        end;
    end;
}
