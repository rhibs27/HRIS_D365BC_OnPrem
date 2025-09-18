table 50137 "Tax Setup Reduction Line"
{
    Caption = 'Tax Setup Reduction Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Pay Cycle Term"; Code[10])
        {
            Caption = 'Pay Cycle Term';
            TableRelation = "Pay Cycle Term".Term;
        }
        field(3; "Special Tax Exempt"; Decimal)
        {
            Caption = 'Special Tax Exempt %';
        }
        field(4; "Special Red. on 1st Slab"; Decimal)
        {
            Caption = 'Special Reduction % on 1st Slab';
        }
        field(5; "Pension Reduction 1st Slab"; Decimal)
        {
            Caption = 'Pension Reduction % 1st Slab';
        }
    }
    keys
    {
        key(PK; "Code", "Pay Cycle Term")
        {
            Clustered = true;
        }
    }
}
