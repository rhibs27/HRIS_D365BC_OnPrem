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
            trigger OnValidate()
            var
                PayrollAttributesRec: Record "Payroll Attributes";
            begin
                if not PayrollAttributesRec.Get("Payroll Attribute") then
                    exit;

                if not (PayrollAttributesRec."Specific Attributes" in [PayrollAttributesRec."Specific Attributes"::"ATM Allowance",
                                                                      PayrollAttributesRec."Specific Attributes"::"Vault Key Allowance"]) then
                    Error('Invalid attribute type selected. Please select either ATM Allowance or Vault Key Allowance.');
            end;
        }
        field(5; "ATM Site"; Enum "ATM Site")
        {
            Caption = 'ATM Site';
        }
        field(6; "Vault Name"; Code[100])
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

    procedure GetATMVaultsCountForOrgStruct(OrgStructCode: Code[20];
                                            Date: Date;
                                            ATMSite: Enum "ATM Site";
                                            VaultName: Code[100];
                                            Panel: Enum Panel
                                            ): Integer
    var
        VaultsATMsRec: Record "Orgwise Vaults & ATM";
    begin
        VaultsATMsRec.SetCurrentKey("Effective Date");
        VaultsATMsRec.SetRange(Code, OrgStructCode);
        VaultsATMsRec.SetFilter("Effective Date", '<>%1&<=%2', 0D, Date);
        if ATMSite <> ATMSite::" " then
            VaultsATMsRec.SetRange("ATM Site", ATMSite);
        if VaultName <> '' then
            VaultsATMsRec.SetRange("Vault Name", VaultName);
        if Panel <> Panel::" " then
            VaultsATMsRec.SetRange(Panel, Panel);
        if VaultsATMsRec.FindLast() then
            exit(VaultsATMsRec."No. of ATM/Vaults")
        else
            exit(0);
    end;
}
