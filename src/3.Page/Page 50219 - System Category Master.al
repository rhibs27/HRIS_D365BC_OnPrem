// page 50219 "System Category Master"
// {
//     // version Access Control 1.00

//     PageType = List;
//     SourceTable = "System Access Control";
//     SourceTableView = where("Type of Masters" = const("System Category"));
//     UsageCategory = Lists;
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Group)
//             {
//                 field("Code"; Rec.Code)
//                 {
//                     Caption = 'System Category Code';
//                     ToolTip = 'Specifies the value of the System Category Code field.';
//                     ApplicationArea = All;
//                 }
//                 field(Name; Rec.Name)
//                 {
//                     Caption = 'System Category Name';
//                     ToolTip = 'Specifies the value of the System Category Name field.';
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions { }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Rec."Type of Masters" := Rec."Type of Masters"::"System Category";
//     end;
// }
