table 50046 "Orgwise Vaults & ATM"
{
    Caption = 'Orgwise Vaults & ATM';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "Deputation Type")
        {
            Caption = 'Type';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Payroll Attribute"; Code[20])
        {
            Caption = 'Payroll Attribute';
            TableRelation = "Payroll Attributes";
        }
        field(5; "ATM Site"; Enum "ATM Site")
        {
            Caption = 'ATM Site';
        }
        field(6; "Vault Name"; Text[100])
        {
            Caption = 'Vault Name';
        }
        field(7; Panel; Enum Panel)
        {
            Caption = 'Panel';
        }
        field(8; "No. of ATM/Vaults"; Integer)
        {
            Caption = 'No. of ATM/Vaults';
        }
        field(10; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            trigger OnValidate()
            begin
                "Effective Date (B.S.)" := EngNepDate.GetNepaliDate("Effective Date");
            end;
        }
        field(11; "Effective Date (B.S.)"; Code[20])
        {
            Caption = 'Effective Date (B.S.)';
            trigger OnValidate()
            begin
                "Effective Date" := EngNepDate.getEngDate("Effective Date (B.S.)");
            end;
        }


    }
    keys
    {
        key(PK; "Type", Code, "Line No.")
        {
            Clustered = true;
        }
    }
    var
        EngNepDate: Record "English-Nepali Date";
}
