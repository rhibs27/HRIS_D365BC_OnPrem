page 50032 "Payroll Attributes"
{
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
                    ToolTip = 'Specifies payroll attributes nature, such as benifit, deduction etc.';
                    ApplicationArea = All;
                }
                field(Subtype; Rec.Subtype)
                {
                    ToolTip = 'Specifies nature of payroll attributes in more details such as TAX, retirements and so on';
                    ApplicationArea = All;
                }
                field("Activity Type"; rec."Activity Type")
                {
                    ToolTip = 'Specifies the value of the Activity Type  field.';
                    ApplicationArea = All;
                }
                field("Non-Taxable"; Rec."Non-Taxable")
                {
                    ToolTip = 'Specifies the value of the Non-Taxable field. Amount in non-taxable will increase the netpay without increasing taxable amount.';
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field. Where amount will get posted';
                    ApplicationArea = All;
                }
                field("Column Name"; Rec."Column Name")
                {
                    ToolTip = 'Specifies the value of the Column Name field. Content in this field is used to make a formula expression.';
                    ApplicationArea = All;
                }
                field("Column No."; Rec."Column No.")
                {
                    ToolTip = 'Specifies the value of the Column No. field.';
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies how dependent attributes calculated.';
                    ApplicationArea = All;
                }
                field("Usage Flexible"; Rec."Usage Flexible")
                {
                    ToolTip = 'If checked user is allowed to change the Amount of that attribute in "Payroll Attribute Uses" page. Otherwise can not';
                    ApplicationArea = All;
                }
                field("Plan Flexible"; Rec."Plan Flexible")
                {
                    ToolTip = 'If checked user is allowed to modify the value of payroll attribute in "Payroll Plan", else can not';
                    ApplicationArea = All;
                }
                field("Claim Flexible"; Rec."Transfer Claim Flexible")
                {
                    ToolTip = 'Specifies the value of the Claim Flexible field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field. Only Active attributes can be used in payroll';
                    ApplicationArea = All;
                }
                field("Apply Every Month"; Rec."Apply Every Month")
                {
                    ToolTip = 'Specifies the value of the Apply Every Month field. If checkd amount will be forcasted';
                    ApplicationArea = All;
                }
                field("Delete Amount After Posting"; Rec."Delete Amount After Posting")
                {
                    ToolTip = 'Specifies the value of the Delete Amount on Employee Attribute Usage After Posting field. If checked, value will be cleared from "Payroll attributes uses" on posting payroll plan';
                    ApplicationArea = All;
                }
                field("Tax at once"; Rec."Tax at once")
                {
                    ToolTip = 'Specifies the value of the Tax at once field. If checked, TAX incured due to the attribute will not be forcasted. Generally use for Insentive, Bonus etc.';
                    ApplicationArea = All;
                }
                field("Deduct on Absent"; Rec."Deduct on Absent")
                {
                    ToolTip = 'Specifies the value of the Deduct on Absent field. If checked amount will be deducted based on absent and unpaid days';
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
                    ToolTip = 'Specifies the value of the Pay Cycle Period field. Use it if you have specific attributes that need to be posted in certain time period such as Dashin';
                    ApplicationArea = All;
                }
                field("Pay Frequency"; Rec."Pay Frequency")
                {
                    ToolTip = 'Specifies the value of the Pay Frequency field. Use it if you need to used such attribute for certain times only. Normally checked for bonus, dasin and insentives';
                    ApplicationArea = All;
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ToolTip = 'Specifies the value of the Employee Type field.';
                    ApplicationArea = All;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ToolTip = 'Specifies the value of the Emplymt. Contract Code field.', Comment = '%';
                }
                field(Irregular; Rec.Irregular)
                {
                    ToolTip = 'Specifies the value of the Irregular field.';
                    ApplicationArea = All;
                }
                field("Specific Attributes"; Rec."Specific Attributes")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specify the payroll nature in deep level. It is used to identify very specific payroll attributes such as leave encash, walefare etc';
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
                field("RF Contribution Type"; Rec."RF Contribution Type")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Type field.';
                    ApplicationArea = All;
                }
                field("Formula Column ID"; Rec."Formula Column ID")
                {
                    ToolTip = 'Specifies the value of the Formula Column ID field.';
                    ApplicationArea = All;
                }
                field("Use Attribute for Home loan"; rec."Use Attr. for Home loan GS")
                {
                    Caption = 'Use Attr. for Home loan Gross Salary';
                    ApplicationArea = All;
                }
                field("Use Attribute for Vehicle loan"; rec."Use Attr. for vehicle loan GS")
                {
                    Caption = 'Use Attr. for Vehicle loan Gross Salary';
                    ApplicationArea = All;
                }
                field("Use Attr. for Salary Adv. GS"; rec."Use Attr. for Salary Adv. GS")
                {
                    Caption = 'Use Attr. for Salary Adv. Gross Salary';
                    ApplicationArea = All;
                }
                field("Use Attr. for Home loan EL"; Rec."Use Attr. for Home loan EL")
                {
                    ApplicationArea = All;
                    Caption = 'Use Attribute for Home Loan Eligible Amount';
                    ToolTip = 'Specifies whether this payroll attribute will be used to determine the eligible amount for Home Loan.';
                }
                field("Use Attr. for Vehicle loan EL"; Rec."Use Attr. for Vehicle loan EL")
                {
                    ApplicationArea = All;
                    Caption = 'Use Attribute for Vehicle Loan Eligible Amount';
                    ToolTip = 'Specifies whether this payroll attribute will be used to determine the eligible amount for Vehicle Loan.';
                }
                field("Use Attr. for Salary Adv. EL"; Rec."Use Attr. for Salary Adv. EL")
                {
                    ApplicationArea = All;
                    Caption = 'Use Attribute for Salary Advance Eligible Amount';
                    ToolTip = 'Specifies whether this payroll attribute will be used to determine the eligible amount for Salary Advance.';
                }
            }
        }
    }

    actions { }
}
