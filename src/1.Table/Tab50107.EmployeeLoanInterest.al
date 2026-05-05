table 50107 "Employee Loan Interest"
{
    DrillDownPageId = "Employee Loan Interest";
    LookupPageId = "Employee Loan Interest";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan Type"; Enum "Loan Type") { }
        field(2; "Starting Date"; Date) { }
        field(3; Description; Text[30]) { }
        field(4; "Interest Rate"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Loan Amount Threshold"; Decimal)
        {
            Caption = 'Loan Amount Threshold';
            ToolTip = 'Specifies the loan amount boundary for tiered interest. Loans at or below this amount use the Below Threshold Rate; loans above use Cost of Fund Rate + Above Threshold Spread.';
            MinValue = 0;
        }
        field(6; "Below Threshold Rate"; Decimal)
        {
            Caption = 'Below Threshold Rate (%)';
            ToolTip = 'Specifies the flat interest rate applied to loans at or below the Loan Amount Threshold.';
            MaxValue = 100;
            MinValue = 0;
        }
        field(7; "Above Threshold Spread"; Decimal)
        {
            Caption = 'Above Threshold Spread (%)';
            ToolTip = 'Specifies the percentage spread added to the Cost of Fund Rate for loans above the Loan Amount Threshold.';
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Loan Type", "Starting Date") { }
    }

    fieldgroups { }
}
