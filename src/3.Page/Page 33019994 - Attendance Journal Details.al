// page 33019994 "Attendance Journal Details"
// {
//     // version AMS6.1.0

//     DeleteAllowed = false;
//     InsertAllowed = false;
//     PageType = List;
//     ShowFilter = false;
//     SourceTable = "Employee Declaration";

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("By Laws Policies"; Rec."By Laws Policies")
//                 {
//                     ToolTip = 'Specifies the value of the By Laws Policies field.';
//                     ApplicationArea = All;
//                 }
//                 field("Corporate Communication"; Rec."Corporate Communication")
//                 {
//                     ToolTip = 'Specifies the value of the Corporate Communication field.';
//                     ApplicationArea = All;
//                 }
//                 field("Other Documents if Any"; Rec."Other Documents if Any")
//                 {
//                     ToolTip = 'Specifies the value of the Other Documents if Any field.';
//                     ApplicationArea = All;
//                 }
//                 field("Involved In Outside Business"; Rec."Involved In Outside Business")
//                 {
//                     ToolTip = 'Specifies the value of the Involved In Outside Business field.';
//                     ApplicationArea = All;
//                 }
//                 field("Souvenir Declaration"; Rec."Souvenir Declaration")
//                 {
//                     ToolTip = 'Specifies the value of the Souvenir Declaration field.';
//                     ApplicationArea = All;
//                 }
//                 field("Allowance Type"; "Allowance Type")
//                 {
//                     ToolTip = 'Specifies the value of the Allowance Type field.';
//                     ApplicationArea = All;
//                 }
//                 field(Days; Days)
//                 {
//                     ToolTip = 'Specifies the value of the Days field.';
//                     ApplicationArea = All;
//                 }
//                 field("Unpaid Days"; "Unpaid Days")
//                 {
//                     ToolTip = 'Specifies the value of the Unpaid Days field.';
//                     ApplicationArea = All;
//                 }
//                 field("Late Ded"; "Late Ded")
//                 {
//                     ToolTip = 'Specifies the value of the Late Ded field.';
//                     ApplicationArea = All;
//                 }
//                 field("No. Series"; Rec."No. Series")
//                 {
//                     ToolTip = 'Specifies the value of the No. Series field.';
//                     ApplicationArea = All;
//                 }
//                 field("Created Date"; Rec."Created Date")
//                 {
//                     ToolTip = 'Specifies the value of the Created Date field.';
//                     ApplicationArea = All;
//                 }
//                 field("Deputation Value"; Rec."Deputation Value")
//                 {
//                     ToolTip = 'Specifies the value of the Deputation Value field.';
//                     ApplicationArea = All;
//                 }
//                 field("Passport Attachment"; Rec."Passport Attachment")
//                 {
//                     ToolTip = 'Specifies the value of the Passport Attachment field.';
//                     ApplicationArea = All;
//                 }
//                 field("Outside Business Attachment"; Rec."Outside Business Attachment")
//                 {
//                     ToolTip = 'Specifies the value of the Outside Business Attachment field.';
//                     ApplicationArea = All;

//                     trigger OnValidate()
//                     begin
//                         if xRec."Outside Business Attachment" <> Rec."Outside Business Attachment" then
//                             CheckReason;
//                     end;
//                 }
//                 field("Property Declaration Attachmen"; Rec."Property Declaration Attachmen")
//                 {
//                     ToolTip = 'Specifies the value of the Property Declaration Attachmen field.';
//                     ApplicationArea = All;
//                 }
//                 field("System Remarks"; "System Remarks")
//                 {
//                     ToolTip = 'Specifies the value of the System Remarks field.';
//                     ApplicationArea = All;
//                 }
//                 field("Conflict Exists"; "Conflict Exists")
//                 {
//                     ToolTip = 'Specifies the value of the Conflict Exists field.';
//                     ApplicationArea = All;
//                 }
//                 field("Conflict Description"; "Conflict Description")
//                 {
//                     ToolTip = 'Specifies the value of the Conflict Description field.';
//                     ApplicationArea = All;
//                 }
//                 field(Correction; Correction)
//                 {
//                     ToolTip = 'Specifies the value of the Correction field.';
//                     ApplicationArea = All;
//                 }
//                 field("Corrected By"; "Corrected By")
//                 {
//                     ToolTip = 'Specifies the value of the Corrected By field.';
//                     ApplicationArea = All;
//                 }
//                 field("Correction Reason"; "Correction Reason")
//                 {
//                     ToolTip = 'Specifies the value of the Correction Reason field.';
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     procedure CheckReason()
//     var
//         Text000: Label 'You must first specify correction reason before modifying record.';
//     begin
//         if "Correction Reason" = '' then
//             Error(Text000);
//     end;
// }
