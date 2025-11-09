table 50131 "KPI Master Bank"
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
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
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
            HRMgt.InitNoSeriesNew(HRSetups."KPI No. Series", xRec."No. Series", Today, "KPI No.", Rec."No. Series");
            KPIMasterBankRec.ReadIsolation(IsolationLevel::ReadCommitted);
            KPIMasterBankRec.SetLoadFields("KPI No.");
            while KPIMasterBankRec.Get("KPI No.") do
                "KPI No." := NoSeriesMgt.GetNextNo("No. Series");
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        HRSetups: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        KPIMasterBankRec: Record "KPI Master Bank";
}
