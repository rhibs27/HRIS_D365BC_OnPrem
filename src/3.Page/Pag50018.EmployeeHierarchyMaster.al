// page 50018 "Employee Hierarchy Master"
// {
//     Caption = 'Employee Hierarchy Master';
//     PageType = List;
//     SourceTable = "Employee Hierarchy Master";
//     UsageCategory = Lists;
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Group)
//             {
//                 field(Type; Rec.Type)
//                 {
//                     ToolTip = 'Specifies the value of the Type field.';
//                     ApplicationArea = All;
//                 }
//                 field("Code"; Rec.Code)
//                 {
//                     ToolTip = 'Specifies the value of the Code field.';
//                     ApplicationArea = All;
//                 }
//                 field(Description; Rec.Description)
//                 {
//                     ToolTip = 'Specifies the value of the Description field.';
//                     ApplicationArea = All;
//                 }
//                 field("Sub-Province"; Rec."Sub-Province")
//                 {
//                     ToolTip = 'Specifies the value of the Sub-Province field.';
//                     ApplicationArea = All;
//                 }
//                 field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
//                 {
//                     ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
//                     ApplicationArea = All;
//                 }
//                 field("Sol ID"; Rec."Sol ID")
//                 {
//                     ToolTip = 'Specifies the value of the Sol ID field.';
//                     ApplicationArea = All;
//                 }
//                 field("Department Code"; Rec."Department Code")
//                 {
//                     ToolTip = 'Specifies the value of the Department Code field.';
//                     ApplicationArea = All;
//                 }
//                 field("Reporting Category"; Rec."Reporting Category")
//                 {
//                     ToolTip = 'Specifies the value of the Reporting Category field.';
//                     ApplicationArea = All;
//                 }
//                 field(Blocked; Rec.Blocked)
//                 {
//                     ToolTip = 'Specifies the value of the Blocked field.';
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions { }

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Rec.Type := Rec.Type::"Extension Counter";
//     end;

//     trigger OnOpenPage()
//     begin
//         CapText := CurrPage.Caption('Extension Counter');

//         /*Filter := GETFILTER(Type);
//         IF Filter = FORMAT(Type::"Extension Counter") THEN BEGIN
//         END ELSE BEGIN
//           CapText := CurrPage.CAPTION('Cluster List');
//         END;
//         */
//         Rec.SetRange(Blocked, false); //Min
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         EmpHirerchyMaster.Reset; //Min
//         EmpHirerchyMaster.SetRange(Code, '');
//         if EmpHirerchyMaster.FindFirst then
//             repeat
//                 Error('Code Should not be blank of the Description %1', EmpHirerchyMaster.Description);
//             until EmpHirerchyMaster.Next = 0;
//     end;

//     var
//         CapText: Text;
//         EmpHirerchyMaster: Record "Employee Hierarchy Master";
// }
