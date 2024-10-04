table 33019931 "KPI Master NIC"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "KPI No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "KPI No." <> xRec."KPI No." then begin//KPI1.00
                    HRSetups.Get;
                    NoSeriesMgt.TestManual(HRSetups."KPI No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[250]) { }
        field(3; Blocked; Boolean) { }
        field(4; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(6; "Department Code"; Code[20])
        {
            TableRelation = Department;
        }
        field(7; Type; Enum "KPI Master Type")
        {

        }
        field(8; "Is Department"; Boolean) { }
        field(9; "Is Operating Profit"; Boolean) { }
        field(10; "Is Adjustment KPI"; Boolean) { }
    }

    keys
    {
        key(Key1; "KPI No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "KPI No." = '' then begin //KPI1.00
            HRSetups.Get;
            HRSetups.TestField("KPI No. Series");
            Clear(NoSeriesMgt);
            NoSeriesMgt.InitSeries(HRSetups."KPI No. Series", xRec."No. Series", Today, "KPI No.", Rec."No. Series");
        end;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetups: Record "Human Resources Setup";
}
