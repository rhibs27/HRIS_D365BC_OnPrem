// page 50245 "EOD/BOD Subform"
// {
//     DelayedInsert = true;
//     PageType = ListPart;
//     SourceTable = "BOD/EOD Line";
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Control9)
//             {
//                 ShowCaption = false;
//                 field("Entry No"; Rec."Entry No")
//                 {
//                     Visible = NotGuiAllowed;
//                     ToolTip = 'Specifies the value of the Entry No field.';
//                     ApplicationArea = All;
//                 }
//                 field("Line No."; Rec."Line No.")
//                 {
//                     Visible = NotGuiAllowed;
//                     ToolTip = 'Specifies the value of the Line No. field.';
//                     ApplicationArea = All;
//                 }
//                 field("Task Description"; Rec."Task Description")
//                 {
//                     ToolTip = 'Specifies the value of the Task Description field.';
//                     ApplicationArea = All;
//                 }
//                 field("Task Status"; Rec."Task Status")
//                 {
//                     ToolTip = 'Specifies the value of the Task Status field.';
//                     ApplicationArea = All;
//                 }
//                 field("Is Created on EOD"; Rec."Is Created on EOD")
//                 {
//                     ToolTip = 'Specifies the value of the Is Created on EOD field.';
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions { }

//     trigger OnOpenPage()
//     begin
//         if not GuiAllowed then
//             NotGuiAllowed := true
//     end;

//     var
//         [InDataSet]
//         NotGuiAllowed: Boolean;
// }
