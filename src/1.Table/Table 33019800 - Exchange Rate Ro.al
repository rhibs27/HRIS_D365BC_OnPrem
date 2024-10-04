table 33019800 "Exchange Rate Ro"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Date; Date) { }
        field(2; OrigCurrency; Code[10]) { }
        field(3; Currency; Code[10]) { }
        field(4; Multiplier; Decimal) { }
        field(5; Rate; Decimal)
        {
            DecimalPlaces = 4 : 4;
        }
    }

    keys
    {
        key(Key1; Date, OrigCurrency, Currency) { }
    }

    fieldgroups { }
}
