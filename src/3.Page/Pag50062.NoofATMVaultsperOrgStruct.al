page 50062 "No of ATM/Vaults per OrgStruct"
{
    ApplicationArea = All;
    Caption = 'No of ATM/Vaults per OrgStruct';
    PageType = ListPart;
    SourceTable = "Orgwise Vaults & ATM";
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Attribute"; Rec."Payroll Attribute")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute field.', Comment = '%';
                }
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
                }
                field("Vault Name"; Rec."Vault Name")
                {
                    ToolTip = 'Specifies the value of the Vault Name field.', Comment = '%';
                }
                field(Panel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Panel field.', Comment = '%';
                }
                field("No. of ATM/Vaults"; Rec."No. of ATM/Vaults")
                {
                    ToolTip = 'Specifies the value of the No. of ATM/Vaults field.', Comment = '%';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                }
                field("Effective Date (B.S.)"; Rec."Effective Date (B.S.)")
                {
                    ToolTip = 'Specifies the value of the Effective Date (B.S.) field.', Comment = '%';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        VaultATMperOrgStruct: Record "Orgwise Vaults & ATM";
    begin
        VaultATMperOrgStruct.SetRange("Code", Rec."Code");
        if VaultATMperOrgStruct.FindSet() then
            repeat
                VaultATMperOrgStruct.TestField("Effective Date");
            until VaultATMperOrgStruct.Next() = 0;
    end;
}
