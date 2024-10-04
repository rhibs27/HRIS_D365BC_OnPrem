// page 33019992 "Attendance Journal"
// {
//     // version AMS6.1.0

//     AutoSplitKey = true;
//     DataCaptionFields = "Employee No.";
//     DelayedInsert = true;
//     InsertAllowed = false;
//     PageType = Worksheet;
//     PromotedActionCategories = 'New,Process,Report,Attendance';
//     SaveValues = true;
//     SourceTable = "Employee Insurance Information";
//     UsageCategory = Tasks;
//     ApplicationArea = All;

//     layout
//     {
//         area(content)
//         {
//             field(CurrentJnlBatchName; CurrentJnlBatchName)
//             {
//                 Caption = 'Batch Name';
//                 Lookup = true;
//                 ToolTip = 'Specifies the value of the Batch Name field.';
//                 ApplicationArea = All;

//                 trigger OnLookup(var Text: Text): Boolean
//                 begin
//                     CurrPage.SaveRecord;
//                     AttJnlManagement.LookupName(CurrentJnlBatchName, Rec);
//                     CurrPage.Update(false);
//                 end;

//                 trigger OnValidate()
//                 begin
//                     AttJnlManagement.CheckName(CurrentJnlBatchName, Rec);
//                     CurrentJnlBatchNameOnAfterVali;
//                 end;
//             }
//             repeater(Control1000000001)
//             {
//                 ShowCaption = false;
//                 field("Insurance Company"; Rec."Insurance Company")
//                 {
//                     Style = Unfavorable;
//                     StyleExpr = ConflictionExist;
//                     ToolTip = 'Specifies the value of the Insurance Company field.';
//                     ApplicationArea = All;
//                 }
//                 field("Policy Number"; Rec."Policy Number")
//                 {
//                     Style = Unfavorable;
//                     StyleExpr = ConflictionExist;
//                     ToolTip = 'Specifies the value of the Policy Number field.';
//                     ApplicationArea = All;
//                 }
//                 field("Insurance Amount"; Rec."Insurance Amount")
//                 {
//                     Style = Unfavorable;
//                     StyleExpr = ConflictionExist;
//                     ToolTip = 'Specifies the value of the Insurance Amount field.';
//                     ApplicationArea = All;
//                 }
//                 field("Annual Premium Amount"; Rec."Annual Premium Amount")
//                 {
//                     Style = Unfavorable;
//                     StyleExpr = ConflictionExist;
//                     ToolTip = 'Specifies the value of the Annual Premium Amount field.';
//                     ApplicationArea = All;
//                 }
//                 field("Life Insurance Company"; Rec."Life Insurance Company")
//                 {
//                     Style = Unfavorable;
//                     StyleExpr = ConflictionExist;
//                     ToolTip = 'Specifies the value of the Life Insurance Company field.';
//                     ApplicationArea = All;
//                 }
//                 // field("Medical/Property Ins Company"; Rec."Medical/Property Ins Company")
//                 // {
//                 //     Style = Unfavorable;
//                 //     StyleExpr = ConflictionExist;
//                 //     ToolTip = 'Specifies the value of the Medical/Property Ins Company field.';
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Present Days"; "Present Days")
//                 // {
//                 //     Style = Unfavorable;
//                 //     StyleExpr = ConflictionExist;
//                 //     ToolTip = 'Specifies the value of the Present Days field.';
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Absent Days"; "Absent Days")
//                 // {
//                 //     Style = Unfavorable;
//                 //     StyleExpr = ConflictionExist;
//                 //     ToolTip = 'Specifies the value of the Absent Days field.';
//                 //     ApplicationArea = All;
//                 // }
//                 // field(Holidays; Holidays)
//                 // {
//                 //     ToolTip = 'Specifies the value of the Holidays field.';
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Paid Days"; "Paid Days")
//                 // {
//                 //     Style = Unfavorable;
//                 //     StyleExpr = ConflictionExist;
//                 //     ToolTip = 'Specifies the value of the Paid Days field.';
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Unpaid Days"; "Unpaid Days")
//                 // {
//                 //     ToolTip = 'Specifies the value of the Unpaid Days field.';
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Late Deduction"; "Late Deduction")
//                 // {
//                 //     ToolTip = 'Specifies the value of the Late Deduction field.';
//                 //     ApplicationArea = All;
//             }
//             // field("Actual PaidDays"; "Actual PaidDays")
//             // {
//             //     ToolTip = 'Specifies the value of the Actual PaidDays field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Conflict Exists"; "Conflict Exists")
//             // {
//             //     Style = Unfavorable;
//             //     StyleExpr = ConflictionExist;
//             //     ToolTip = 'Specifies the value of the Conflict Exists field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Posting Date"; "Posting Date")
//             // {
//             //     Style = Unfavorable;
//             //     StyleExpr = ConflictionExist;
//             //     ToolTip = 'Specifies the value of the Posting Date field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Source Code"; "Source Code")
//             // {
//             //     Style = Unfavorable;
//             //     StyleExpr = ConflictionExist;
//             //     Visible = false;
//             //     ToolTip = 'Specifies the value of the Source Code field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Posting No. Series"; "Posting No. Series")
//             // {
//             //     Style = Unfavorable;
//             //     StyleExpr = ConflictionExist;
//             //     Visible = false;
//             //     ToolTip = 'Specifies the value of the Posting No. Series field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Evening Counter"; "Evening Counter")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Evening Counter field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Friday Counter"; "Friday Counter")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Friday Counter field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Holiday Counter"; "Holiday Counter")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Holiday Counter field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Festival Allowance"; "Festival Allowance")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Festival Allowance field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Risk Allowance"; "Risk Allowance")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Risk Allowance field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Vault Key"; "Vault Key")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Vault Key field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Bulk Cash Transfer"; "Bulk Cash Transfer")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Bulk Cash Transfer field.';
//             //     ApplicationArea = All;
//             // }
//             // field("Out of Office"; "Out of Office")
//             // {
//             //     Editable = false;
//             //     ToolTip = 'Specifies the value of the Out of Office field.';
//             //     ApplicationArea = All;
//             // }
//         }
//     }
//         area(factboxes)
//         {
//             systempart(Control1000000018; Links)
//             {
//                 Visible = false;
//                 ApplicationArea = All;
//             }
//             systempart(Control1000000017; Notes)
//             {
//                 Visible = false;
//                 ApplicationArea = All;
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group("A&ttendance")
//             {
//                 Caption = 'A&ttendance';
//                 action("<Action1000000004>")
//                 {
//                     Caption = 'Journal D&etail';
//                     Image = SelectEntries;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     RunObject = Page "Attendance Journal Details";
//                                     RunPageLink = "No." = FIELD("Insurance No."),
//                                   "Employee No." = FIELD("Employee No."),
//                                   "Fiscal Year" = FIELD("Insurance Company"),
//                                   "Employee Name" = FIELD("Employee Name"),
//                                   "By Laws Policies" = FIELD("Insurance Amount");
//                                     ToolTip = 'Executes the Journal D&etail action.';
//                                     ApplicationArea = All;

//     trigger OnAction()
//     begin
//         Rec.CalcFields("Conflict Exists");
//         if "Conflict Exists" then
//             ConflictionExist := true
//         else
//             ConflictionExist := false;
//         CurrPage.Update(false);
//     end;
//                 }
//                 action("<Action1000000024>")
//                 {
//                     Caption = 'L&og';
//                     Image = BulletList;
//                     ToolTip = 'Executes the L&og action.';
//                     ApplicationArea = All;

//                     trigger OnAction()
//                     begin
//                         AttLog.Reset;
//                         AttLog.SetRange("Employee ID", Rec."Insurance Amount");
//                         AttLog.SetRange(Date, Rec."Life Insurance Company", Rec."Medical/Property Ins Company");
//                         AttLogPage.SetTableView(AttLog);
//                         AttLogPage.Run;
//                     end;
//                 }
//                 action("<Action1000000025>")
//                 {
//                     Caption = 'A&ctivities';
//                     Image = ItemWorksheet;
//                     ToolTip = 'Executes the A&ctivities action.';
//                     ApplicationArea = All;

//                     trigger OnAction()
//                     begin
//                         ActLog.Reset;
//                         ActLog.SetRange("Employee No.", Rec."Insurance Amount");
//                         ActLog.SetRange("Start Date", Rec."Life Insurance Company", Rec."Medical/Property Ins Company");
//                         ActLogPage.SetTableView(ActLog);
//                         ActLogPage.Run;
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             group("<Action1000000026>")
//             {
//                 Caption = 'P&osting';
//                 action(Post)
//                 {
//                     Caption = 'P&ost';
//                     Ellipsis = true;
//                     Image = Post;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ShortCutKey = 'F9';
//                     ToolTip = 'Executes the P&ost action.';
//                     ApplicationArea = All;

//                     trigger OnAction()
//                     var
//                         PurchaseHeader: Record "Purchase Header";
//                     begin
//                         CODEUNIT.Run(CODEUNIT::"Attendance-Post (Yes/No)", Rec);
//                     end;
//                 }
//             }
//             group("F&unctions")
//             {
//                 Caption = 'F&unctions';
//                 action("Process Activities")
//                 {
//                     Caption = 'Process &Activities';
//                     Image = SelectItemSubstitution;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ToolTip = 'Executes the Process &Activities action.';
//                     ApplicationArea = All;

//                     trigger OnAction()
//                     begin
//                         AttJnlManagement.ProcessActivities(Rec);
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         OnAfterGetCurrRecord;
//         Rec.CalcFields("Conflict Exists");
//         if "Conflict Exists" then
//             ConflictionExist := true
//         else
//             ConflictionExist := false;
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         Rec.CalcFields("Conflict Exists");
//         if "Conflict Exists" then
//             ConflictionExist := true
//         else
//             ConflictionExist := false;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         SetUpNewLine(xRec);
//         OnAfterGetCurrRecord;
//     end;

//     trigger OnOpenPage()
//     var
//         JnlSelected: Boolean;
//     begin
//         OpenedFromBatch := (Rec."Employee No." <> '') and (Rec."Insurance No." = '');
//         if OpenedFromBatch then begin
//             CurrentJnlBatchName := Rec."Employee No.";
//             AttJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
//             exit;
//         end;
//         AttJnlManagement.TemplateSelection(PAGE::"Attendance Journal", 0, Rec, JnlSelected);
//         if not JnlSelected then
//             Error('');
//         AttJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
//     end;

//     var
//         CurrentJnlBatchName: Code[20];
//         OpenedFromBatch: Boolean;
//         AttJnlManagement: Codeunit "Attendance Management";
//         EmpName: Code[20];
//         [InDataSet]
//         ConflictionExist: Boolean;
//         AttLogPage: Page "Attendance Logs";
//                         AttLog: Record "Attendance Log";
//                         ActLogPage: Page "Activity Logs";
//                         ActLog: Record "BOD/EOD Line";

//     local procedure CurrentJnlBatchNameOnAfterVali()
//     begin
//         CurrPage.SaveRecord;
//         AttJnlManagement.SetName(CurrentJnlBatchName, Rec);
//         CurrPage.Update(false);
//     end;

//     local procedure OnAfterGetCurrRecord()
//     begin
//         //xRec := Rec;
//     end;
// }
