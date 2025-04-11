// page 50262 "Employee Hierarchy Master API"
// {
//     // version HR Transfer

//     Caption = 'Employee Hierarchy Master API';
//     EntityName = 'EmployeeHierarchyMaster';
//     EntitySetName = 'EmployeeHierarchyMasters';
//     PageType = API;
//     APIVersion = 'v2.0';
//     DelayedInsert = true;
//     APIGroup = 'HRMS';
//     APIPublisher = 'Agile';
//     SourceTable = "Employee Hierarchy Master";

//     layout
//     {
//         area(Content)
//         {
//             repeater(Group)
//             {
//                 field("Code"; Rec.Code) { }
//                 field(Description; Rec.Description) { }
//                 field(Type; Rec.Type) { }
//                 field(Blocked; Rec.Blocked) { }
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
