// page 50000 "Exchange Currencies RO"
// {
//     PageType = List;
//     SourceTable = "Exchange Rate Ro";
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Group)
//             {
//                 field(Date; Rec.Date)
//                 {
//                     ToolTip = 'Specifies the value of the Date field.';
//                     ApplicationArea = All;
//                 }
//                 field(OrigCurrency; Rec.OrigCurrency)
//                 {
//                     ToolTip = 'Specifies the value of the OrigCurrency field.';
//                     ApplicationArea = All;
//                 }
//                 field(Currency; Rec.Currency)
//                 {
//                     ToolTip = 'Specifies the value of the Currency field.';
//                     ApplicationArea = All;
//                 }
//                 field(Multiplier; Rec.Multiplier)
//                 {
//                     ToolTip = 'Specifies the value of the Multiplier field.';
//                     ApplicationArea = All;
//                 }
//                 field(Rate; Rec.Rate)
//                 {
//                     ToolTip = 'Specifies the value of the Rate field.';
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action("Update Rates")
//             {
//                 Image = Import;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 ToolTip = 'Executes the Update Rates action.';
//                 ApplicationArea = All;
//                 // RunObject = Codeunit 50005;
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         if Rec.IsEmpty then
//             Rec.Insert;

//         Rec.SetCurrentKey(Date);
//         Rec.Ascending(false);
//         Rec.FindFirst;
//     end;
// }
