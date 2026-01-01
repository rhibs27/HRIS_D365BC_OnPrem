table 50132 "KPI Setup Bank"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; Type; Enum "KPI Setup Type") { }
        field(2; "Code"; Code[20])
        {
            TableRelation = if (Type = const(Functional)) "Functional Title"
            else if (Type = const(Department)) "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false))
            else if (Type = const("Department Central & Province Level")) "Functional Title";
        }
        field(3; "KPI Code"; Code[20])
        {
            TableRelation = "KPI Master Bank";

            trigger OnValidate()
            begin
                if KPIMaster.Get("KPI Code") then //KPI1.00
                    "KPI Description" := KPIMaster.Description;
            end;
        }
        field(4; "KPI Description"; Text[250]) { }
        field(5; "Weightage %"; Decimal) { }
        field(6; Indentation; Integer) { }
        field(7; "Account Type"; Enum "KPI SetUp Account Type")
        {
            Caption = 'Account Type';
            trigger OnValidate()
            begin
                /*IF ("Account Type" <> "Account Type"::Posting) AND
                   (xRec."Account Type" = xRec."Account Type"::Posting)
                THEN begin
                  GLEntry.SetRange("G/L Account No.","No.");
                  IF NOT GLEntry.ISEMPTY THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION("Account Type"));
                  GLBudgetEntry.SetRange("G/L Account No.","No.");
                  IF NOT GLBudgetEntry.ISEMPTY THEN
                    ERROR(
                      Text001,
                      FIELDCAPTION("Account Type"));
                end;
                Totaling := '';
                IF "Account Type" = "Account Type"::Posting THEN begin
                  IF "Account Type" <> xRec."Account Type" THEN
                    "Direct Posting" := TRUE;
                END ELSE
                  "Direct Posting" := FALSE;*/
            end;
        }
        field(8; Totaling; Text[250]) { }
        field(9; "KPI Category"; Code[20])
        {
            TableRelation = "KPI Category";
        }
    }

    keys
    {
        key(Key1; Type, "Code", "KPI Code") { }
    }

    fieldgroups { }

    var
        KPIMaster: Record "KPI Master bank";
}
