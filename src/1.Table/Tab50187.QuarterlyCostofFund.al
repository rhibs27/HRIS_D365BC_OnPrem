table 50187 "Quarterly Cost of Fund"
{
    Caption = 'Quarterly Cost of Fund';
    DrillDownPageId = "Quarterly Cost of Fund";
    LookupPageId = "Quarterly Cost of Fund";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            ToolTip = 'Specifies the first date of the quarter for which this Cost of Fund rate is effective.';
            NotBlank = true;
        }
        field(2; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            ToolTip = 'Specifies the last date of the quarter for which this Cost of Fund rate is effective.';
            NotBlank = true;

            trigger OnValidate()
            begin
                if ("Ending Date" <> 0D) and ("Starting Date" <> 0D) then
                    if "Ending Date" < "Starting Date" then
                        Error('Ending Date must be greater than or equal to Starting Date.');
            end;
        }
        field(3; "Cost of Fund Rate"; Decimal)
        {
            Caption = 'Cost of Fund Rate (%)';
            ToolTip = 'Specifies the quarterly published Cost of Fund rate. For loans above the threshold, effective interest = Cost of Fund Rate + Spread from Loan Interest setup.';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2 : 4;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description for this quarterly rate entry, e.g. ''Q1 FY2081-82''.';
        }
    }

    keys
    {
        key(Key1; "Starting Date") { Clustered = true; }
        key(Key2; "Ending Date") { }
    }

    fieldgroups { }
}
