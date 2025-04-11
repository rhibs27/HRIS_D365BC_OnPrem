// page 50261 "Departments API"
// {
//     // version HR Transfer

//     //     //Inserting to temp table     12th Jan 2020
//     //     //Deleting from temp table    12th Jan 2020
//     //     //Checking if selected        12th Jan 2020

//     Caption = 'Departments API';
//     EntityName = 'DepartmentEntity';
//     EntitySetName = 'DepartmentEntities';
//     PageType = API;
//     APIVersion = 'v2.0';
//     DelayedInsert = true;
//     APIGroup = 'HRMS';
//     APIPublisher = 'Agile';
//     SourceTable = Department;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Control1)
//             {
//                 ShowCaption = false;
//                 field("Code"; Rec.Code)
//                 {
//                     ApplicationArea = BasicHR;
//                     ToolTip = 'Specifies a union code.';
//                 }
//                 field(Name; Rec.Name)
//                 {
//                     ApplicationArea = BasicHR;
//                     ToolTip = 'Specifies the name of the union.';
//                 }
//                 field(Blocked; Rec.Blocked) { }
//             }
//         }
//     }

//     actions
//     {
//         area(Creation)
//         {
//             action("Payroll Attributes")
//             {
//                 Image = Add;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 RunObject = page "Quick Links";
//                 RunPageLink = "Link Code" = field(Code);
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         Selected := CheckSelected(Rec.Code);
//     end;

//     trigger OnOpenPage()
//     begin
//         Rec.SetRange(Blocked, false); //Min
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         if ShowSelected then begin
//             Clear(DepartmentText);
//             TempDepart.Reset;
//             if TempDepart.Find('-') then
//                 repeat
//                     if DepartmentText = '' then
//                         DepartmentText := TempDepart.Code
//                     else
//                         DepartmentText += '|' + TempDepart.Code;
//                 until TempDepart.Next = 0;
//         end;
//     end;

//     var
//         Selected: Boolean;
//         [InDataSet]
//         ShowSelected: Boolean;
//         TempDepart: Record Department temporary;
//         Depart: Record Department;
//         DepartmentText: Text;

//     procedure AssignShowSelected()
//     begin
//         ShowSelected := true;
//     end;

//     procedure InsertTempDepart(DepartText: Text)
//     begin
//         //Inserting to temp table
//         if DepartText = '' then
//             exit;
//         Depart.Reset;
//         Depart.SetFilter(Code, DepartText);
//         if Depart.Find('-') then
//             repeat
//                 TempDepart.Init;
//                 TempDepart.Validate(Code, Depart.Code);
//                 TempDepart.Insert;
//             until Depart.Next = 0;
//     end;

//     local procedure CheckSelected(DepartText: Text): Boolean
//     begin
//         //Checking if selected
//         TempDepart.Reset;
//         TempDepart.SetRange(Code, DepartText);
//         if TempDepart.FindFirst then
//             exit(true);
//     end;

//     local procedure DeleteUnselected(DepartText: Text)
//     begin
//         //Deleting from temp table
//         TempDepart.Reset;
//         TempDepart.SetRange(Code, DepartText);
//         TempDepart.Delete;
//     end;

//     procedure ReturnDepartText(): Text
//     begin
//         exit(DepartmentText);
//     end;
// }
