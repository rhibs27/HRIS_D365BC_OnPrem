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
    }

    keys
    {
        key(Key1; "Loan Type", "Starting Date") { }
    }

    fieldgroups { }
}
