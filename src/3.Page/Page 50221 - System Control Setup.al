// page 50221 "System Control Setup"
// {
//     // version Access Control 1.00

//     PageType = List;
//     SourceTable = "System Access Control";
//     SourceTableView = where("Type of Masters" = const("System Control Setup"));
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
//                     Caption = 'System Type Code';
//                     ToolTip = 'Specifies the value of the System Type Code field.';
//                     ApplicationArea = All;
//                 }
//                 field(Name; Rec.Name)
//                 {
//                     Caption = 'System Type Name';
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the System Type Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("System Category Code"; Rec."System Category Code")
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the System Category Code field.';
//                     ApplicationArea = All;
//                 }
//                 field("System Category Name"; Rec."System Category Name")
//                 {
//                     ToolTip = 'Specifies the value of the System Category Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("System Department Owner"; Rec."System Department Owner")
//                 {
//                     ToolTip = 'Specifies the value of the System Department Owner field.';
//                     ApplicationArea = All;
//                 }
//                 field("Department Name"; Rec."Department Name")
//                 {
//                     ToolTip = 'Specifies the value of the Department Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("System Owner Email ID"; Rec."System Owner Email ID")
//                 {
//                     ToolTip = 'Specifies the value of the System Owner Email ID field.';
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions { }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Rec."Type of Masters" := Rec."Type of Masters"::"System Control Setup";
//     end;
// }
