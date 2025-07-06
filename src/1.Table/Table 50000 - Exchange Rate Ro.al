// table 50000 "Exchange Rate Ro"
// {
//     DataClassification = CustomerContent;

//     fields
//     {
//         field(1; Date; Date) { }
//         field(2; OrigCurrency; Code[20]) { }
//         field(3; Currency; Code[20]) { }
//         field(4; Multiplier; Decimal) { }
//         field(5; Rate; Decimal)
//         {
//             DecimalPlaces = 4 : 4;
//         }
//     }

//     keys
//     {
//         key(Key1; Date, OrigCurrency, Currency) { }
//     }

//     fieldgroups { }
// }
