page 50058 "No of ATM and Vaults"
{
    ApplicationArea = All;
    Caption = 'No of ATM and Vaults';
    PageType = List;
    SourceTable = "Orgwise Vaults & ATM";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Payroll Attribute"; Rec."Payroll Attribute")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute field.', Comment = '%';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                }
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
                }
                field("No. of ATM/Vaults"; Rec."No. of ATM/Vaults")
                {
                    ToolTip = 'Specifies the value of the No. of ATM/Vaults field.', Comment = '%';
                }
                field("Vault Name"; Rec."Vault Name")
                {
                    ToolTip = 'Specifies the value of the Vault Name field.', Comment = '%';
                }
                field(Panel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Panel field.', Comment = '%';
                }

            }
        }
    }
}
