// pageextension 50004 GLBudgetNames extends "G/L Budget Names"
// {
//     actions
//     {
//         addafter(EditBudget)
//         {
//             action("Open Ceiling")
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 Image = OpenJournal;
//                 PromotedCategory = Category4;
//                 ToolTip = 'Executes the Open Ceiling action.';
//                 trigger OnAction()
//                 begin
//                 end;
//             }
//         }
//     }
// }
