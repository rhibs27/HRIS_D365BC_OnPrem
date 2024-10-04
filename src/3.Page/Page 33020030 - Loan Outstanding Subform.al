page 33020030 "Loan Outstanding Subform"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Loan Outstanding from Finacle";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Scheme Type"; Rec."Scheme Type")
                {
                    ToolTip = 'Specifies the value of the Scheme Type field.';
                    ApplicationArea = All;
                }
                field("Account ID"; Rec."Account ID")
                {
                    ToolTip = 'Specifies the value of the Account ID field.';
                    ApplicationArea = All;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ToolTip = 'Specifies the value of the Outstanding Amount field.';
                    ApplicationArea = All;
                }
                field("Loan Limit"; Rec."Loan Limit")
                {
                    ToolTip = 'Specifies the value of the Loan Limit field.';
                    ApplicationArea = All;
                }
                field(EMI; Rec.EMI)
                {
                    ToolTip = 'Specifies the value of the EMI field.';
                    ApplicationArea = All;
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                    ToolTip = 'Specifies the value of the Scheme Code field.';
                    ApplicationArea = All;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the value of the Loan Type field.';
                    ApplicationArea = All;
                }
                field("Is Manual"; Rec."Is Manual")
                {
                    ToolTip = 'Specifies the value of the Is Manual field.';
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
