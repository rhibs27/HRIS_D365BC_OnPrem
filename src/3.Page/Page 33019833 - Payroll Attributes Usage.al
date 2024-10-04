page 33019833 "Payroll Attributes Usage"
{
    // version PRM19.01.01

    DataCaptionFields = "Employee Code";
    PageType = List;
    SourceTable = "Payroll Attributes Usage";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    LookupPageId = "Payroll Attributes";
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Subtype; Rec.Subtype)
                {
                    ToolTip = 'Specifies the value of the Subtype field.';
                    ApplicationArea = All;
                }
                field("Formula Exists"; Rec."Formula Exists")
                {
                    ToolTip = 'Specifies the value of the Formula Exists field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Is Loan EMI Applicable"; Rec."Is Loan EMI Applicable")
                {
                    ToolTip = 'Specifies the value of the Is Loan EMI Applicable field.';
                    ApplicationArea = All;
                }
                field("Last EMI Date"; Rec."Last EMI Date")
                {
                    ToolTip = 'Specifies the value of the Last EMI Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
