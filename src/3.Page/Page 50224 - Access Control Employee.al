// page 50224 "Access Control Employee"
// {
//     // version Access Control 1.00

//     InsertAllowed = false;
//     PageType = Card;
//     SourceTable = "Employee Activity";
//     SourceTableView = where(Type = filter("Access Control"));
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 Editable = IsOpen;
//                 field("No."; Rec."No.")
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the No. field.';
//                     ApplicationArea = All;

//                     trigger OnLookup(var Text: Text): Boolean
//                     begin
//                         if Rec.AssistEdit(xRec) then
//                             CurrPage.Update;
//                     end;
//                 }
//                 field("Employee No."; Rec."Employee No.")
//                 {
//                     Caption = 'Requested by';
//                     Visible = false;
//                     ToolTip = 'Specifies the value of the Requested by field.';
//                     ApplicationArea = All;
//                 }
//                 field("Employee Name"; Rec."Employee Name")
//                 {
//                     Caption = 'Requested Name';
//                     Visible = false;
//                     ToolTip = 'Specifies the value of the Requested Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Request Case"; Rec."Request Case")
//                 {
//                     ToolTip = 'Specifies the value of the Request Case field.';
//                     ApplicationArea = All;
//                 }
//                 field("Approval Status"; Rec."Approval Status")
//                 {
//                     ToolTip = 'Specifies the value of the Approval Status field.';
//                     ApplicationArea = All;
//                 }
//                 field("Recommender Code"; Rec."Recommender Code")
//                 {
//                     ToolTip = 'Specifies the value of the Recommender Code field.';
//                     ApplicationArea = All;
//                 }
//                 field("Recommender Name"; Rec."Recommender Name")
//                 {
//                     ToolTip = 'Specifies the value of the Recommender Name field.';
//                     ApplicationArea = All;
//                 }
//             }
//             group(Rejection)
//             {
//                 Visible = not IsOpen;
//                 field("Rejection Remarks"; Rec."Rejection Remarks")
//                 {
//                     ToolTip = 'Specifies the value of the Rejection Remarks field.';
//                     ApplicationArea = All;
//                 }
//             }
//             group("Recommender Remarks")
//             {
//                 Visible = not IsOpen;
//                 field(Remarks; Rec.Remarks)
//                 {
//                     ToolTip = 'Specifies the value of the Remarks field.';
//                     ApplicationArea = All;
//                 }
//             }
//             group(Screener)
//             {
//                 Visible = Rec."Approval Status" = Rec."Approval Status"::Recommended;
//                 field("Screener Remarks"; Rec."Screener Remarks")
//                 {
//                     ToolTip = 'Specifies the value of the Screener Remarks field.';
//                     ApplicationArea = All;
//                 }
//             }
//             part(Control7; "Access Control Emp Subforms")
//             {
//                 SubPageLink = "Document No." = field("No.");
//                 ApplicationArea = All;
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action("Send for Apporval")
//             {
//                 Image = Approval;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = IsOpen;
//                 ToolTip = 'Executes the Send for Apporval action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Do you want to send this document for approval?', false) then begin
//                         HRMgt.SendAccessControlApproval(Rec);
//                         CurrPage.Close;
//                     end;
//                 end;
//             }
//             action(Recommend)
//             {
//                 Image = Delivery;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 PromotedOnly = true;
//                 Visible = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
//                 ToolTip = 'Executes the Recommend action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Do your want to recommend this document?', false) then begin
//                         HRMgt.RecommendAccessControl(Rec);
//                         CurrPage.Close;
//                     end;
//                 end;
//             }
//             action(Screen)
//             {
//                 Image = SelectField;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = Rec."Approval Status" = Rec."Approval Status"::Recommended;
//                 ToolTip = 'Executes the Screen action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Do you want to screen this document?', false) then begin
//                         HRMgt.ScreenAccessControl(Rec);
//                         CurrPage.Close;
//                     end;
//                 end;
//             }
//             action(Rejected)
//             {
//                 Image = Reject;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 PromotedOnly = true;
//                 Visible = ForRejected;
//                 ToolTip = 'Executes the Rejected action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Do you want to reject this document?', false) then begin
//                         HRMgt.RejectAccessControl(Rec);
//                         CurrPage.Close;
//                     end;
//                 end;
//             }
//             action("Get Access Control Line")
//             {
//                 Image = Add;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 PromotedOnly = true;
//                 Visible = (IsOpen) and (not IsFromTransfer);
//                 ToolTip = 'Executes the Get Access Control Line action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     if Confirm('Do you get access control line?', false) then begin
//                         Rec.TestField("Request Case");
//                         if Rec."Request Case" <> Rec."Request Case"::Recruitement then
//                             HRMgt.GenerateAccessControl(Rec)
//                         else
//                             HRMgt.AccessControlEmployeeSelection(Rec);
//                         CurrPage.Update;
//                     end;
//                 end;
//             }
//         }
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Rec."Approval Status" := Rec."Approval Status"::Open;
//     end;

//     trigger OnOpenPage()
//     begin
//         IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
//         ForRejected := Rec."Approval Status" in [Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Recommended];
//         if Rec."Travel Order No." <> '' then
//             IsFromTransfer := true;
//     end;

//     var
//         [InDataSet]
//         IsOpen: Boolean;
//         HRMgt: Codeunit "HR Mgt.";
//         [InDataSet]
//         ForRejected: Boolean;
//         IsFromTransfer: Boolean;
// }
