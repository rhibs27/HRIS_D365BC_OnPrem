page 50032 "Payroll Attributes"
{
    // version PRM19.01.01

    PageType = List;
    SourceTable = "Payroll Attributes";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
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
                field("Activity Type"; rec."Activity Type")
                {
                    ToolTip = 'Specifies the value of the Activity Type  field.';
                    ApplicationArea = All;

                }
                field("Non-Taxable"; Rec."Non-Taxable")
                {
                    ToolTip = 'Specifies the value of the Non-Taxable field.';
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                    ApplicationArea = All;
                }
                field("Column Name"; Rec."Column Name")
                {
                    ToolTip = 'Specifies the value of the Column Name field.';
                    ApplicationArea = All;
                }
                field("Column No."; Rec."Column No.")
                {
                    ToolTip = 'Specifies the value of the Column No. field.';
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.';
                    ApplicationArea = All;
                }
                field("Usage Flexible"; Rec."Usage Flexible")
                {
                    ToolTip = 'Specifies the value of the Usage Flexible field.';
                    ApplicationArea = All;
                }
                field("Plan Flexible"; Rec."Plan Flexible")
                {
                    ToolTip = 'Specifies the value of the Plan Flexible field.';
                    ApplicationArea = All;
                }
                field("Claim Flexible"; Rec."Transfer Claim Flexible")
                {
                    ToolTip = 'Specifies the value of the Claim Flexible field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Apply Every Month"; Rec."Apply Every Month")
                {
                    ToolTip = 'Specifies the value of the Apply Every Month field.';
                    ApplicationArea = All;
                }
                field("Delete Amount After Posting"; Rec."Delete Amount After Posting")
                {
                    ToolTip = 'Specifies the value of the Delete Amount on Employee Attribute Usage After Posting field.';
                    ApplicationArea = All;
                }
                field("Tax at once"; Rec."Tax at once")
                {
                    ToolTip = 'Specifies the value of the Tax at once field.';
                    ApplicationArea = All;
                }
                field("Deduct on Absent"; Rec."Deduct on Absent")
                {
                    ToolTip = 'Specifies the value of the Deduct on Absent field.';
                    ApplicationArea = All;
                }
                field("Posting Method"; Rec."Posting Method")
                {
                    ToolTip = 'Specifies the value of the Posting Method field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.';
                    ApplicationArea = All;
                }
                field("Pay Frequency"; Rec."Pay Frequency")
                {
                    ToolTip = 'Specifies the value of the Pay Frequency field.';
                    ApplicationArea = All;
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ToolTip = 'Specifies the value of the Employee Type field.';
                    ApplicationArea = All;
                }
                field(Irregular; Rec.Irregular)
                {
                    ToolTip = 'Specifies the value of the Irregular field.';
                    ApplicationArea = All;
                }
                field("Static GL Ledger"; Rec."Static GL Ledger")
                {
                    ToolTip = 'Specifies the value of the Static GL Ledger field.';
                    ApplicationArea = All;
                }
                field("Static GL Ledger Account"; Rec."Static GL Ledger Account")
                {
                    Editable = Rec."Static GL Ledger";
                    ToolTip = 'Specifies the value of the Static GL Ledger Account field.';
                    ApplicationArea = All;
                }
                field("GL Code For Branch"; Rec."CBS GL Code")
                {
                    ToolTip = 'Specifies the value of the GL Code For Branch field.';
                    ApplicationArea = All;
                }
                field("GL Code for Region"; Rec."CBS Expense Code")
                {
                    ToolTip = 'Specifies the value of the GL Code for Region field.';
                    ApplicationArea = All;
                }
                field("Finacle GL Name"; Rec."Finacle GL Name")
                {
                    ToolTip = 'Specifies the value of the Finacle GL Name field.';
                    ApplicationArea = All;
                }
                field("Mutually Exclusive"; Rec."Mutually Exclusive")
                {
                    ToolTip = 'Specifies the value of the Mutually Exclusive field.';
                    ApplicationArea = All;
                }
                field("Tax Info Report Type"; Rec."Tax Info Report Type")
                {
                    ToolTip = 'Specifies the value of the Tax Info Report Type field.';
                    ApplicationArea = All;
                }
                field("Differential Interest"; Rec."Differential Interest")
                {
                    ToolTip = 'Specifies the value of the Differential Interest field.';
                    ApplicationArea = All;
                }
                field("Column Id"; Rec."Column Id")
                {
                    ToolTip = 'Specifies the value of the Column Id field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
