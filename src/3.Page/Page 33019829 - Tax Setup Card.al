page 33019829 "Tax Setup Card"
{
    // version PRM19.01.01

    PageType = Card;
    SourceTable = "Tax Setup Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Effective from"; Rec."Effective from")
                {
                    ToolTip = 'Specifies the value of the Effective from field.';
                    ApplicationArea = All;
                }
                field("Effective to"; Rec."Effective to")
                {
                    ToolTip = 'Specifies the value of the Effective to field.';
                    ApplicationArea = All;
                }
                field("Special Tax Exempt %"; Rec."Special Tax Exempt %")
                {
                    ToolTip = 'Specifies the value of the Special Tax Exempt % field.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
            }
            part(Control8; "Tax Setup Subform")
            {
                SubPageLink = Code = field(Code);
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
