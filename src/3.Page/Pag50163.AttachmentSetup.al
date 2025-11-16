page 50163 "Attachment Setup"
{
    PageType = List;
    SourceTable = "Attachment Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Attachment Code"; Rec."Attachment Code")
                {
                    ToolTip = 'Specifies the value of the Attachment Code field.';
                    ApplicationArea = All;
                }
                field("Table ID"; Rec."Table ID")
                {
                    //Visible = false;
                    ToolTip = 'Specifies the value of the Table ID field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Subtype; Rec."Sub Type")
                {
                    ToolTip = 'Specifies the value of the Subtype field.', Comment = '%';
                }

                field("Leave Type Code"; Rec."Leave Type Code")
                {
                    ToolTip = 'Specifies the value of the Leave Type Code field.';
                    ApplicationArea = All;
                }
                field("Transfer Claim Attributes"; Rec."Transfer Claim Attributes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Speficies the value of the Payroll Attributes for attachment of Transfer Claim';
                }
                field("Purpose of Housing Loan"; Rec."Purpose of Housing Loan")
                {
                    ToolTip = 'Specifies the value of the Purpose of Housing Loan field.';
                    ApplicationArea = All;
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ToolTip = 'Specifies the value of the Mandatory field.';
                    ApplicationArea = All;
                }
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                    ApplicationArea = All;
                }
                field(Enhancement; Rec.Enhancement)
                {
                    ToolTip = 'Specifies the value of the Enhancement field.';
                    ApplicationArea = All;
                }
                field("Board Approval"; Rec."Board Approval")
                {
                    ToolTip = 'Specifies the value of the Board Approval field.';
                    ApplicationArea = All;
                }
                field("Transfer Category"; Rec."Transfer Category")
                {
                    Editable = Rec.Type = Rec.Type::"Employee Transfer";
                    ToolTip = 'Specifies the value of the Transfer Category field.';
                    ApplicationArea = All;
                }
                field("Max File Size"; Rec."Max File Size")
                {
                    Caption = 'Max File Size(In MB)';
                }
            }
        }
    }

    actions { }
}
