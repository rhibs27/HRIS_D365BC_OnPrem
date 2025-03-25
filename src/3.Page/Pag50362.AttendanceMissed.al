// page 50362 "Attendance Missed"
// {
//     PageType = Card;
//     SourceTable = "Attendance Missed";
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 Editable = IsOpen;
//                 field(Type; Rec.Type)
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the Type field.';
//                     ApplicationArea = All;
//                 }
//                 field("Employee No."; Rec."Employee No.")
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the Employee No. field.';
//                     ApplicationArea = All;
//                 }
//                 field("Employee Name"; Rec."Employee Name")
//                 {
//                     ToolTip = 'Specifies the value of the Employee Name field.';
//                     ApplicationArea = All;
//                 }
//                 field("Start Date"; Rec."Start Date")
//                 {
//                     ToolTip = 'Specifies the value of the Start Date field.';
//                     ApplicationArea = All;
//                 }
//                 field("End Date"; Rec."End Date")
//                 {
//                     ToolTip = 'Specifies the value of the End Date field.';
//                     ApplicationArea = All;
//                 }
//                 field("No. of Days"; Rec."No. of Days")
//                 {
//                     ToolTip = 'Specifies the value of the No. of Days field.';
//                     ApplicationArea = All;
//                 }
//                 field(Remarks; Rec.Remarks)
//                 {
//                     ToolTip = 'Specifies the value of the Remarks field.';
//                     ApplicationArea = All;
//                 }
//                 field("Requested Date"; Rec."Requested Date")
//                 {
//                     ToolTip = 'Specifies the value of the Requested Date field.';
//                     ApplicationArea = All;
//                 }
//                 field("Start Date (BS)"; Rec."Start Date (BS)")
//                 {
//                     ToolTip = 'Specifies the value of the Start Date (BS) field.';
//                     ApplicationArea = All;
//                 }
//                 field("End Date (BS)"; Rec."End Date (BS)")
//                 {
//                     ToolTip = 'Specifies the value of the End Date (BS) field.';
//                     ApplicationArea = All;
//                 }
//                 field("Reason Code"; Rec."Reason Code")
//                 {
//                     ToolTip = 'Specifies the value of the Reason Code field.';
//                     ApplicationArea = All;
//                 }
//                 field("Reason Description"; Rec."Reason Description")
//                 {
//                     ToolTip = 'Specifies the value of the Reason Description field.';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Rejection Remarks"; Rec."Rejection Remarks")
//                 {
//                     Visible = not IsOpen;
//                     ToolTip = 'Specifies the value of the Rejection Remarks field.';
//                     ApplicationArea = All;
//                     Editable = IsPending;
//                 }
//                 field("Approval Status"; Rec."Approval Status")
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the Approval Status field.';
//                     ApplicationArea = All;
//                     Visible = ApprovalStatusView;
//                 }
//                 field(Status; rec.Status)
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the Approval Status field.';
//                     ApplicationArea = All;
//                     Visible = StatusView;
//                     Caption = 'Approval Status';
//                 }
//             }
//             part("Approval Subform"; "HRMS Approval Entry")
//             {
//                 Editable = false;
//                 SubPageLink = "Document No." = field("No."),
//                                 "Employee No" = field("Employee No."),
//                                 "Document Type" = field(Type);
//                 ApplicationArea = all;
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(Apply)
//             {
//                 Image = Apply;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 PromotedOnly = true;
//                 Visible = IsOpen;
//                 ToolTip = 'Executes the Apply action.';
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     AttendanceMissedMgt.ApplyAttendanceMissed(Rec);
//                     IsApplied := true;
//                     Message('Applied');
//                     CurrPage.Close;
//                 end;
//             }
//         }
//     }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Rec.FilterGroup(2);
//         TypeFilter := Rec.GetFilter(Type);
//         Rec.FilterGroup(0);
//         if TypeFilter = Format(Rec.Type::"Attendance Missed") then
//             Rec.Type := Rec.Type::"Attendance Missed";
//         Rec."Approval Status" := Rec."Approval Status"::Open;
//     end;

//     trigger OnOpenPage()
//     begin
//         if Rec.Type = Rec.Type::"Attendance Missed" then
//             CurrPage.Caption('Attendance Missed');
//         if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
//             StatusView := true
//         else
//             ApprovalStatusView := true;
//         IsLeaveRequest := Rec.Type = Rec.Type::"Leave Request";
//         IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
//         IsOpen := (Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::" ");
//         case rec.Type of
//             rec.Type::"Attendance Missed":
//                 begin
//                     ApproverMgt.InsertApprovalTemp(Rec."Employee No.", '', Rec.Type::"Attendance Missed");
//                 end;
//         end;
//     end;


//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         if Rec."Approval Status" = Rec."Approval Status"::Open then
//             if not IsApplied then
//                 if not Confirm('The data will be erased. Do you want to continue?', true) then
//                     Error('')
//                 else begin
//                     Approval.Reset();
//                     Approval.SetRange("Document No.", '');
//                     Approval.setRange("Document Type", Approval."Document Type"::"Attendance Missed");
//                     Approval.SetRange("Employee No", Rec."Employee No.");
//                     Approval.DeleteAll();
//                 end;
//     end;

//     var
//         HRMgt: Codeunit "HR Mgt.";
//         AttendanceMissedMgt: Codeunit "AttendanceMiss Mgt";
//         IsApplied: Boolean;
//         [InDataSet]
//         IsLeaveRequest: Boolean;
//         [InDataSet]
//         IsOpen: Boolean;
//         TypeFilter: Text;
//         ApproverMgt: Codeunit "Approver Mgt";
//         IsPending: Boolean;
//         Approval: Record "Approval HRMS";
//         ApprovalStatusView: Boolean;
//         StatusView: Boolean;
// }
