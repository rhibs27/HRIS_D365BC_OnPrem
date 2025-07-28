page 50031 "Payroll General Setup"
{
    // version PRM19.01.01

    PageType = Card;
    SourceTable = "Payroll General Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Payroll Fiscal Year Start Date"; Rec."Payroll Fiscal Year Start Date")
                {
                    ToolTip = 'Specifies the value of the Payroll Fiscal Year Start Date field.';
                    ApplicationArea = All;
                }
                field("Payroll Fiscal Year End Date"; Rec."Payroll Fiscal Year End Date")
                {
                    ToolTip = 'Specifies the value of the Payroll Fiscal Year End Date field.';
                    ApplicationArea = All;
                }
                field("Previous Year Payroll Enable"; Rec."Previous Year Payroll Enable")
                {
                    ToolTip = 'Specifies the value of the Previous Year Payroll Enable field.';
                    ApplicationArea = All;
                }
                field("Prev Fiscal Year Start Date"; Rec."Prev Fiscal Year Start Date")
                {
                    Caption = 'Previous Fiscal Year Start Date';
                    ToolTip = 'Specifies the value of the Previous Fiscal Year Start Date field.';
                    ApplicationArea = All;
                }
                field("Prev Fiscal Year End Date"; Rec."Prev Fiscal Year End Date")
                {
                    Caption = 'Previous Fiscal Year End Date';
                    ToolTip = 'Specifies the value of the Previous Fiscal Year End Date field.';
                    ApplicationArea = All;
                }
                field("Next Fiscal Year Start Date"; Rec."Next Fiscal Year Start Date")
                {
                    Caption = 'Next Fiscal Year Start Date';
                    ToolTip = 'Specifies the value of the Next Fiscal Year Start Date field.';
                    ApplicationArea = All;
                }
                field("Next Fiscal Year End Date"; Rec."next Fiscal Year End Date")
                {
                    Caption = 'Next Fiscal Year End Date';
                    ToolTip = 'Specifies the value of the Next Fiscal Year End Date field.';
                    ApplicationArea = All;
                }
                field("Dashain Start Date"; Rec."Dashain Start Date")
                {
                    ToolTip = 'Specifies the value of the Dashain Start Date field.';
                    ApplicationArea = All;
                }
                field("Distributable Amt. for Statuto"; Rec."Distributable Amt. for Statuto")
                {
                    Caption = 'Distributable Amt. for Statutory Bonus';
                    ToolTip = 'Specifies the value of the Distributable Amt. for Statutory Bonus field.';
                    ApplicationArea = All;
                }
                field("Base Calendar"; Rec."Base Calendar")
                {
                    ToolTip = 'Specifies the value of the Base Calendar field.';
                    ApplicationArea = All;
                }
                field("Posting Method"; Rec."Posting Method")
                {
                    ToolTip = 'Specifies the value of the Posting Method field.';
                    ApplicationArea = All;
                }
                field("HRMS Month"; Rec."HRMS Month")
                {
                    ToolTip = 'Specifies the value of the HRMS Month field.';
                    ApplicationArea = All;
                }
                field("Tax Calculation Type"; Rec."Tax Calculation Type")
                {
                    ToolTip = 'Specifies the value of the Tax Calculation Type field.';
                    ApplicationArea = All;
                }
                field("Make Payroll Slip Confidential"; Rec."Make Payroll Slip Confidential")
                {
                    ToolTip = 'Specifies the value of the Make Payroll Slip Confidential field.';
                    ApplicationArea = All;
                }
                field("Per Step Salary Percentage"; Rec."Per Step Salary Percentage")
                {
                    ToolTip = 'Specifies the value of the Per Step Salary Percentage field.';
                    ApplicationArea = All;
                }
                field("Total Days"; Rec."Total Days")
                {
                    ToolTip = 'Specifies the value of the Total Days field.';
                    ApplicationArea = All;
                }
                field("Total Days From"; Rec."Total Days From")
                {
                    ToolTip = 'Specifies the value of the Total Days From field.';
                    ApplicationArea = All;
                }
                field("LFA Source"; Rec."LFA Source")
                {
                    ToolTip = 'Specifies the value of the LFA Source field.';
                    ApplicationArea = All;
                }
                field("Parking Account No."; Rec."Parking Account No.")
                {
                    ToolTip = 'Specifies the value of the Parking Account No. field.';
                    ApplicationArea = All;
                }
                field("Allowance Grace Period"; Rec."Allowance Grace Period")
                {
                    ToolTip = 'Specifies the value of the Allowance Grace Period field.';
                    ApplicationArea = All;
                }
                field("TA Salary Level"; Rec."TA Salary Level")
                {
                    ToolTip = 'Specifies the value of the TA Salary Level field.';
                    ApplicationArea = All;
                }
                field("Return Tax"; Rec."Return Tax")
                {
                    ToolTip = 'Specifies the value of the Return Tax field.';
                    ApplicationArea = All;
                }
                field("Approval Grace Period"; Rec."Approval Grace Period")
                {
                    ToolTip = 'Specifies the value of the Approval Grace Period field.';
                    ApplicationArea = All;
                }
                field("Default Work Shift"; Rec."Default Work Shift")
                {
                    ToolTip = 'Specifies the value of the Default Work Shift field.';
                    ApplicationArea = All;
                }
                field("Allowance Email Days"; Rec."Allowance Email Days")
                {
                    ToolTip = 'Specifies the value of the Allowance Email Days field.';
                    ApplicationArea = All;
                }
                field("Enable RF Lumpsump Plan"; Rec."Enable RF Lumpsump Plan")
                {
                    ToolTip = 'Specifies the value of the Enable RF Lumpsump Plan field.';
                    ApplicationArea = All;
                }
                field("OT Start Time"; Rec."OT Start Time")
                {
                    ToolTip = 'Specifies the value of the OT Start Time field.';
                    ApplicationArea = All;
                }
                field("OT End Time"; Rec."OT End Time")
                {
                    ToolTip = 'Specifies the value of the OT End Time field.';
                    ApplicationArea = All;
                }
                field("Friday OT End Time"; Rec."Friday OT End Time")
                {
                    ToolTip = 'Specifies the value of the Friday OT End Time field.';
                    ApplicationArea = All;
                }
            }
            group("Posting Group")
            {
                field("Net Payable Account Type"; Rec."Net Payable Account Type")
                {
                    ToolTip = 'Specifies the value of the Net Payable Account Type field.';
                    ApplicationArea = All;
                }
                field("Net Payable Account Code"; Rec."Net Payable Account Code")
                {
                    ToolTip = 'Specifies the value of the Net Payable Account Code field.';
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Payment Method Code field.';
                    ApplicationArea = All;
                }
            }
            group("Payment Attribute Group")
            {
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    OptionCaption = 'G/L Account,,,Bank Account';
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                    ApplicationArea = All;
                }
                field("Payroll Journal Template"; Rec."Payroll Journal Template")
                {
                    ToolTip = 'Specifies the value of the Payroll Journal Template field.';
                    ApplicationArea = All;
                }
                field("Payroll Journal Batch"; Rec."Payroll Journal Batch")
                {
                    ToolTip = 'Specifies the value of the Payroll Journal Batch field.';
                    ApplicationArea = All;
                }
                field("TA - Out of Pocket"; Rec."TA - Out of Pocket")
                {
                    Caption = 'TA - Out of Pocket Allowance';
                    LookupPageId = "Payroll Attributes";
                    ToolTip = 'Specifies the value of the TA - Out of Pocket Allowance field.';
                    ApplicationArea = All;
                }
                field("TA - Lodging Expense"; Rec."TA - Lodging Expense")
                {
                    Caption = 'TA - Lodging Expense Allowance';
                    LookupPageId = "Payroll Attributes";
                    ToolTip = 'Specifies the value of the TA - Lodging Expense Allowance field.';
                    ApplicationArea = All;
                }
                field("TA - Food Expense"; Rec."TA - Food Expense")
                {
                    Caption = 'TA - Food Expense Allowance';
                    LookupPageId = "Payroll Attributes";
                    ToolTip = 'Specifies the value of the TA - Food Expense Allowance field.';
                    ApplicationArea = All;
                }
                field("Outstn/Discomfort Allowance"; Rec."Outstn/Discomfort Allowance")
                {
                    Caption = 'Outstation/Discomfort Allowance';
                    LookupPageId = "Payroll Attributes";
                    ToolTip = 'Specifies the value of the Outstation/Discomfort Allowance field.';
                    ApplicationArea = All;
                }
                field("BM Accomendation"; Rec."BM Accomendation")
                {
                    Caption = 'BM Accomendation Allowance';
                    ToolTip = 'Specifies the value of the BM Accomendation Allowance field.';
                    ApplicationArea = All;
                }
                field("Remote Area Allowance"; Rec."Remote Area Allowance")
                {
                    ToolTip = 'Specifies the value of the Remote Area Allowance field.';
                    ApplicationArea = All;
                }
                field("COPO/COSPO Allowance"; Rec."COPO/COSPO Allowance")
                {
                    ToolTip = 'Specifies the value of the COPO/COSPO Allowance field.';
                    ApplicationArea = All;
                }
                field("Faciliator Allowance"; Rec."Faciliator Allowance")
                {
                    ToolTip = 'Specifies the value of the Faciliator Allowance field.';
                    ApplicationArea = All;
                }
                field("Dashain Renumeration"; Rec."Dashain Renumeration")
                {
                    ToolTip = 'Specifies the value of the Dashain Renumeration field.';
                    ApplicationArea = All;
                }
                field("Bulk Cash Allowance"; Rec."Bulk Cash Allowance")
                {
                    ToolTip = 'Specifies the value of the Bulk Cash Allowance field.';
                    ApplicationArea = All;
                }
                field("Holiday Counter"; Rec."Holiday Counter")
                {
                    Caption = 'Holiday Counter Allowance';
                    ToolTip = 'Specifies the value of the Holiday Counter Allowance field.';
                    ApplicationArea = All;
                }
                field("Evening Counter"; Rec."Evening Counter")
                {
                    Caption = 'Evening Counter Allowance';
                    ToolTip = 'Specifies the value of the Evening Counter Allowance field.';
                    ApplicationArea = All;
                }
                field("Morning Counter"; Rec."Morning Counter")
                {
                    ToolTip = 'Specifies the value of the Morning Counter field.';
                    ApplicationArea = All;
                }
                field("Festival Counter"; Rec."Festival Counter")
                {
                    Caption = 'Festival Counter Allowance';
                    ToolTip = 'Specifies the value of the Festival Counter Allowance field.';
                    ApplicationArea = All;
                }
                field("Risk Allowance"; Rec."Risk Allowance")
                {
                    ToolTip = 'Specifies the value of the Risk Allowance field.';
                    ApplicationArea = All;
                }
                field("Vault Key"; Rec."Vault Key")
                {
                    Caption = 'Vault Key Allowance';
                    ToolTip = 'Specifies the value of the Vault Key Allowance field.';
                    ApplicationArea = All;
                }
                field("Officiating Allowance Code"; Rec."Officiating Allowance Code")
                {
                    Caption = 'Officiating Allowance';
                    ToolTip = 'Specifies the value of the Officiating Allowance field.';
                    ApplicationArea = All;
                }
                field("Comm. Reimbursement"; Rec."Comm. Reimbursement")
                {
                    Caption = 'Communication Reimbursement';
                    ToolTip = 'Specifies the value of the Communication Reimbursement field.';
                    ApplicationArea = All;
                }
                field("Officiating Allowance"; Rec."Officiating Allowance")
                {
                    ToolTip = 'Specifies the value of the Officiating Allowance field.';
                    ApplicationArea = All;
                }
                field("Staff Vehicle Allowance"; Rec."Staff Vehicle Allowance")
                {
                    ToolTip = 'Specifies the value of the Staff Vehicle Allowance field.';
                    ApplicationArea = All;
                }
                field("Friday Counter"; Rec."Friday Counter")
                {
                    Caption = 'Friday Counter Allowance';
                    ToolTip = 'Specifies the value of the Friday Counter Allowance field.';
                    ApplicationArea = All;
                }
                field("Relocation Allowance"; Rec."Relocation Allowance")
                {
                    ToolTip = 'Specifies the value of the Relocation Allowance field.';
                    ApplicationArea = All;
                }
                field("Leave Fare Allowance"; Rec."Leave Fare Allowance")
                {
                    ToolTip = 'Specifies the value of the Leave Fare Allowance field.';
                    ApplicationArea = All;
                }
                field("BM Functional Title"; Rec."BM Functional Title")
                {
                    ToolTip = 'Specifies the value of the BM Functional Title field.';
                    ApplicationArea = All;
                }
                field("Salary Advance"; Rec."Salary Advance")
                {
                    ToolTip = 'Specifies the value of the Salary Advance field.';
                    ApplicationArea = All;
                }
                field("COPO Functional Title"; Rec."COPO Functional Title")
                {
                    ToolTip = 'Specifies the value of the COPO Functional Title field.';
                    ApplicationArea = All;
                }
                field("COSPO Functioal Title"; Rec."COSPO Functioal Title")
                {
                    ToolTip = 'Specifies the value of the COSPO Functioal Title field.';
                    ApplicationArea = All;
                }
                field("Contract Basic"; Rec."Contract Basic")
                {
                    ToolTip = 'Specifies the value of the Contract Basic field.';
                    ApplicationArea = All;
                }
                field("Loan Attribute"; Rec."Loan Attribute")
                {
                    ToolTip = 'Specifies the value of the Loan Attribute field.';
                    ApplicationArea = All;
                }
                field("Head Teller Allowance"; Rec."Head Teller Allowance")
                {
                    ToolTip = 'Specifies the value of the Head teller allowance field.';
                    ApplicationArea = All;
                }
                field("Teller Allowance"; Rec."Teller Allowance")
                {
                    ToolTip = 'Specifies the value of the teller allowance field.';
                    ApplicationArea = All;
                }
                field("ATM Custodian"; Rec."ATM Custodian")
                {
                    ApplicationArea = All;
                }

            }
            group("Encashment Code Group")
            {
                field("Extra Mileage"; Rec."Extra Mileage")
                {
                    ToolTip = 'Specifies the value of the Extra Mileage field.';
                    ApplicationArea = All;
                }
                field(Overtime; Rec.Overtime)
                {
                    ToolTip = 'Specifies the value of the Overtime field.';
                    ApplicationArea = All;
                }
                field("Compensatory Leave"; Rec."Compensatory Leave")
                {
                    ToolTip = 'Specifies the value of the Compensatory Leave field.';
                    ApplicationArea = All;
                }
                field("Year End Encashment"; Rec."Year End Encashment")
                {
                    ToolTip = 'Specifies the value of the Year End Encashment field.';
                    ApplicationArea = All;
                }
            }
            group("Basic For PF on Adjustment")
            {
                field("Basic Adjustment Code"; Rec."Basic Adjustment Code")
                {
                    ToolTip = 'Specifies the value of the Basic Adjustment Code field.';
                    ApplicationArea = All;
                }
                field("Grade Adjustment Code"; Rec."Grade Adjustment Code")
                {
                    ToolTip = 'Specifies the value of the Grade Adjustment Code field.';
                    ApplicationArea = All;
                }
                field("Officiat Basic Adjustment Code"; Rec."Officiat Basic Adjustment Code")
                {
                    ToolTip = 'Specifies the value of the Officiat Basic Adjustment Code field.';
                    ApplicationArea = All;
                }
            }
            group(Tax)
            {
                group("Tax Exemption on Retirement fund")
                {
                    field("Tax Ex. Amt. (%) on Retirement"; Rec."Tax Ex. Amt. (%) on Retirement")
                    {
                        Visible = false;
                        ToolTip = 'Specifies the value of the Tax Ex. Amt. (%) on Retirement field.';
                        ApplicationArea = All;
                    }
                    field("Tax Ex. Amt Divsion"; Rec."Tax Ex. Amt Divsion")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Amt Divsion field.';
                        ApplicationArea = All;
                    }
                    field("Tax Ex. Amt. not Exceeding"; Rec."Tax Ex. Amt. not Exceeding")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Amt. not Exceeding field.';
                        ApplicationArea = All;
                    }
                }
                group("Tax Exemption on Insurance Policy")
                {
                    Caption = 'Tax Exemption on Insurance Policy';
                    field("Tax Ex. Life Insurance Amt."; Rec."Tax Ex. Life Insurance Amt.")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Life Insurance Amt. field.';
                        ApplicationArea = All;
                    }
                    field("Tax Ex. Health Insur. Amount"; Rec."Tax Ex. Health Insur. Amount")
                    {
                        Caption = 'Tax Ex. Health Insurance Amount';
                        ToolTip = 'Specifies the value of the Tax Ex. Health Insurance Amount field.';
                        ApplicationArea = All;
                    }
                    field("Tax Ex. Property Insurance Amt"; Rec."Tax Ex. Property Insurance Amt")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Property Insurance Amt field.';
                        ApplicationArea = All;
                    }
                }
                group("Tax Exemption on Donation")
                {
                    Caption = 'Tax Exemption on Donation';
                    field("Tax Ex. Amt. (%) on Donation"; Rec."Tax Ex. Amt. (%) on Donation")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Amt. (%) on Donation field.';
                        ApplicationArea = All;
                    }
                    field("Tax Ex. Amt. not Exeed on Don."; Rec."Tax Ex. Amt. not Exeed on Don.")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Amt. not Exeed on Don. field.';
                        ApplicationArea = All;
                    }
                }
                group(Control19)
                {
                    ShowCaption = false;
                    field("Tax Ex. Amt. (%) on Medical"; Rec."Tax Ex. Amt. (%) on Medical")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Amt. (%) on Medical Reimbursment field.';
                        ApplicationArea = All;
                    }
                    field("Tax Ex. Amt. not Exeed on Med."; Rec."Tax Ex. Amt. not Exeed on Med.")
                    {
                        ToolTip = 'Specifies the value of the Tax Ex. Amt. not Exeed on Medical Reimbursment field.';
                        ApplicationArea = All;
                    }
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Salary Plan No. Series"; Rec."Salary Plan No. Series")
                {
                    ToolTip = 'Specifies the value of the Salary Plan No. Series field.';
                    ApplicationArea = All;
                }
                field("Salary Plan Posting No. Series"; Rec."Salary Plan Posting No. Series")
                {
                    ToolTip = 'Specifies the value of the Salary Plan Posting No. Series field.';
                    ApplicationArea = All;
                }
                field("Settlement No. Series"; Rec."Settlement No. Series")
                {
                    ToolTip = 'Specifies the value of the Settlement No. Series field.';
                    ApplicationArea = All;
                }
                field("Settlement Posting No. Series"; Rec."Settlement Posting No. Series")
                {
                    ToolTip = 'Specifies the value of the Settlement Posting No. Series field.';
                    ApplicationArea = All;
                }
                field("Payroll Adj No. Series"; Rec."Payroll Adj No. Series")
                {
                    ToolTip = 'Specifies the value of the Payroll Adj No. Series field.';
                    ApplicationArea = All;
                }
                field("Posted Payroll Adj No. Series"; Rec."Posted Payroll Adj No. Series")
                {
                    ToolTip = 'Specifies the value of the Posted Payroll Adj No. Series field.';
                    ApplicationArea = All;
                }
                field("Resignation Plan No. Series"; Rec."Resigned Plan No. Series")
                {
                    ToolTip = 'Specifies the value of the Resignation Plan No. Series field.';
                    ApplicationArea = All;
                }
                field("Posted Resignation Plan No. Series"; Rec."Posted ResignedPlan No. Series")
                {
                    ToolTip = 'Specifies the value of the Posted Resignation Plan No. Series field.';
                    ApplicationArea = All;
                }
            }
            group("Specific Components")
            {
                field("Late Deduction Component"; Rec."Late Deduction Component")
                {
                    ToolTip = 'Specifies the value of the Late Deduction Component field.';
                    ApplicationArea = All;
                }
                field("OT Benefit Component"; Rec."OT Benefit Component")
                {
                    ToolTip = 'Specifies the value of the OT Benefit Component field.';
                    ApplicationArea = All;
                }
                field("Evening Counter (Regular)"; Rec."Evening Counter (Regular)")
                {
                    ToolTip = 'Specifies the value of the Evening Counter (Regular) field.';
                    ApplicationArea = All;
                }
                field("Evening Counter (Contract)"; Rec."Evening Counter (Contract)")
                {
                    ToolTip = 'Specifies the value of the Evening Counter (Contract) field.';
                    ApplicationArea = All;
                }
                field("Holiday All. Amt (Regular)"; Rec."Holiday All. Amt (Regular)")
                {
                    ToolTip = 'Specifies the value of the Holiday All. Amt (Regular) field.';
                    ApplicationArea = All;
                }
                field("Holiday All. Amt (Contract)"; Rec."Holiday All. Amt (Contract)")
                {
                    ToolTip = 'Specifies the value of the Holiday All. Amt (Contract) field.';
                    ApplicationArea = All;
                }
                field("bulk Cash Amt"; Rec."bulk Cash Amt")
                {
                    Caption = 'Bulk Cash Transfer Amount';
                    ToolTip = 'Specifies the value of the Bulk Cash Transfer Amount field.';
                    ApplicationArea = All;
                }
                field("Festival Counter(Contract)"; Rec."Festival Counter(Contract)")
                {
                    ToolTip = 'Specifies the value of the Festival Counter(Contract) field.';
                    ApplicationArea = All;
                }
                field("Festival Counter(Regular)"; Rec."Festival Counter(Regular)")
                {
                    ToolTip = 'Specifies the value of the Festival Counter(Regular) field.';
                    ApplicationArea = All;
                }
                field("Vault Key Allowance(Regular)"; Rec."Vault Key Allowance(Regular)")
                {
                    Caption = 'Vault Key Allowence(Regular) (Months)';
                    ToolTip = 'Specifies the value of the Vault Key Allowence(Regular) (Months) field.';
                    ApplicationArea = All;
                }
                field("Vault Key Allowance (Contract)"; Rec."Vault Key Allowance (Contract)")
                {
                    Caption = 'vault Key Allowence (Contract) (Months)';
                    ToolTip = 'Specifies the value of the vault Key Allowence (Contract) (Months) field.';
                    ApplicationArea = All;
                }
                field("Base Teaching Hours"; Rec."Base Teaching Hours")
                {
                    Caption = 'Base Teaching Hours (facilitator Allowance)';
                    ToolTip = 'Specifies the value of the Base Teaching Hours (facilitator Allowance) field.';
                    ApplicationArea = All;
                }
                field("Morning Counter (Regular)"; Rec."Morning Counter (Regular)")
                {
                    ToolTip = 'Specifies the value of the Morning Counter (Regular) field.';
                    ApplicationArea = All;
                }
                field("Morning Counter (Contract)"; Rec."Morning Counter (Contract)")
                {
                    ToolTip = 'Specifies the value of the Morning Counter (Contract) field.';
                    ApplicationArea = All;
                }
                field("Cash Risk Percent"; Rec."Cash Risk Percent")
                {
                    ToolTip = 'Specifies the value of the Cash Risk Percent field.';
                    ApplicationArea = All;
                }
                field("Head Teller Allow. (Regular)"; Rec."Head Teller Allow. (Regular)")
                {
                    ToolTip = 'Specifies the value of the "Head Teller Allow. field.';
                    ApplicationArea = All;
                }
                field("Head Teller Allow. (Contract)"; Rec."Head Teller Allow. (Contract)")
                {
                    ToolTip = 'Specifies the value of the Head Teller Allow. (Contract) field.';
                    ApplicationArea = All;
                }
                field("Teller Allow. (Regular)"; Rec."Teller Allowance (Regular)")
                {
                    ToolTip = 'Specifies the value of the "Head Teller Allow. field.';
                    ApplicationArea = All;
                }
                field("Teller Allow. (Contract)"; Rec."Teller Allowance (Contract)")
                {
                    ToolTip = 'Specifies the value of the Head Teller Allow. (Contract) field.';
                    ApplicationArea = All;
                }
                field("ATM Custodian regular (month)"; Rec."ATM Custodian regular (month)")
                {
                    ToolTip = 'Specifies the value of the ATM Allow. (regular) field.';
                    ApplicationArea = All;
                }
                field("ATM Custodian contract (month)"; Rec."ATM Custodian contract (month)")
                {
                    ToolTip = 'Specifies the value of the ATM cust. Allow. (comtract) field.';
                    ApplicationArea = All;
                }

            }
            group(Settlement)
            {
                field(Gratuity; Rec.Gratuity)
                {
                    ToolTip = 'Specifies the value of the Gratuity field.';
                    ApplicationArea = All;
                }
                field("Leave Encashment"; Rec."Leave Encashment")
                {
                    Caption = 'Leave Encashment';
                    ToolTip = 'Specifies the value of the Leave Encashment field.';
                    ApplicationArea = All;
                }
                field("Settlement TAX Rate"; Rec."Settlement TAX Rate")
                {
                    ToolTip = 'Specifies the value of the Settlement TAX Rate field.';
                    ApplicationArea = All;
                }
                field("Annual Leave"; Rec."Annual Leave")
                {
                    ToolTip = 'Specifies the value of the Annual Leave field.';
                    ApplicationArea = All;
                }
                field("Sick Leave"; Rec."Sick Leave")
                {
                    ToolTip = 'Specifies the value of the Sick Leave field.';
                    ApplicationArea = All;
                }
                field("Settlement Recovery"; Rec."Settlement Recovery")
                {
                    ToolTip = 'Specifies the value of the Settlement Recovery field.';
                    ApplicationArea = All;
                }
                group(Recovery)
                {
                    field("LFA Recover"; Rec."LFA Recover")
                    {
                        ToolTip = 'Specifies the value of the LFA Recover field.';
                        ApplicationArea = All;
                    }
                    field("Insurance Recover"; Rec."Insurance Recover")
                    {
                        ToolTip = 'Specifies the value of the Insurance Recover field.';
                        ApplicationArea = All;
                    }
                }
            }
            group("Retirement Fund")
            {
                Caption = 'Retirement Fund';
                field("CIT (Monthly)"; Rec."CIT (Monthly)")
                {
                    ToolTip = 'Specifies the value of the CIT (Monthly) field.';
                    ApplicationArea = All;
                }
                field("CIT (Lumpsum)"; Rec."CIT (Lumpsum)")
                {
                    ToolTip = 'Specifies the value of the CIT (Lumpsum) field.';
                    ApplicationArea = All;
                }
                field("RTF (Monthly)"; Rec."RTF (Monthly)")
                {
                    ToolTip = 'Specifies the value of the RTF (Monthly) field.';
                    ApplicationArea = All;
                }
                field("RTF (Lumpsum)"; Rec."RTF (Lumpsum)")
                {
                    ToolTip = 'Specifies the value of the RTF (Lumpsum) field.';
                    ApplicationArea = All;
                }
            }
            group(Control117)
            {
                Caption = 'Over Time Calculation';
                field("Over Time Calculation"; Rec."Over Time Calculation")
                {
                    Caption = 'OverTime Calc (eq. % 1hr basic)';
                    ToolTip = 'Specifies the value of the OverTime Calc (eq. % 1hr basic) field.';
                    ApplicationArea = All;
                }
                field("Extra Mileage Calculation"; Rec."Extra Mileage Calculation")
                {
                    Caption = 'ExtraMileage Calc (eq. % 1hr basic)';
                    ToolTip = 'Specifies the value of the ExtraMileage Calc (eq. % 1hr basic) field.';
                    ApplicationArea = All;
                }
                field("Compensatory Leave Hour"; Rec."Compensatory Leave Hour")
                {
                    ToolTip = 'Specifies the value of the Compensatory Leave Hour field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
