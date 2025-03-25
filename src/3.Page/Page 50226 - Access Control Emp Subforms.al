// page 50226 "Access Control Emp Subforms"
// {
//     // version Access Control 1.00

//     PageType = ListPart;
//     SourceTable = "Access Control Request Line";
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Group)
//             {
//                 field("Employee No."; Rec."Employee No.")
//                 {
//                     TableRelation = if ("Request Case" = const(Recruitement)) Employee
//                     else if ("Request Case" = filter(<> Recruitement)) Employee."No." where("No." = field("Employee Filter"));
//                     ToolTip = 'Specifies the value of the Employee No. field.';
//                     ApplicationArea = All;
//                 }
//                 field("Employee Name"; Rec."Employee Name")
//                 {
//                     ToolTip = 'Specifies the value of the Employee Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("System Type"; Rec."System Type")
//                 {
//                     ToolTip = 'Specifies the value of the System Type field.';
//                     ApplicationArea = All;
//                 }
//                 field("Line No."; Rec."Line No.")
//                 {
//                     ToolTip = 'Specifies the value of the Line No. field.';
//                     ApplicationArea = All;
//                 }
//                 field("Access Type"; Rec."Access Type")
//                 {
//                     ToolTip = 'Specifies the value of the Access Type field.';
//                     ApplicationArea = All;
//                 }
//                 field("System Type Name"; Rec."System Type Name")
//                 {
//                     ToolTip = 'Specifies the value of the System Type Name field.';
//                     ApplicationArea = All;
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the Status field.';
//                     ApplicationArea = All;
//                 }
//                 field("Approved Date"; Rec."Approved Date")
//                 {
//                     ToolTip = 'Specifies the value of the Approved Date field.';
//                     ApplicationArea = All;
//                 }
//                 field("Approved By"; Rec."Approved By")
//                 {
//                     ToolTip = 'Specifies the value of the Approved By field.';
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(Approve)
//             {
//                 Image = Approve;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 PromotedOnly = true;
//                 Visible = Rec.Status = Rec.Status::"pending approval";
//                 ToolTip = 'Executes the Approve action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Do you want to approve this document?', false) then
//                         HRMgt.ApproveRejectScreenAccessControl(Rec, true);
//                 end;
//             }
//             action(Reject)
//             {
//                 Image = Reject;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 PromotedOnly = true;
//                 Visible = Rec.Status = Rec.Status::"pending approval";
//                 ToolTip = 'Executes the Reject action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Do you want to reject this document?', false) then
//                         HRMgt.ApproveRejectScreenAccessControl(Rec, false);
//                 end;
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         EmpActivity.Get(Rec."Document No.");
//         if EmpActivity."Approval Status" = EmpActivity."Approval Status"::Open then
//             Isopen := true
//         else
//             Isopen := false;

//         CurrPage.Editable(Isopen);
//         Rec.CalcFields("Employee Filter");
//     end;

//     var
//         HRMgt: Codeunit "HR Mgt.";
//         EmpActivity: Record "Employee Activity";
//         Isopen: Boolean;
// }
