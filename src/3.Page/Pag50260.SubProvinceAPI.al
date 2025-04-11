// page 50260 "Sub Province API"
// {
//     // version HR Transfer

//     Caption = 'Sub Province API';
//     EntityName = 'SubProvince';
//     EntitySetName = 'SubProvinces';
//     PageType = API;
//     APIVersion = 'v2.0';
//     DelayedInsert = true;
//     APIGroup = 'HRMS';
//     APIPublisher = 'Agile';
//     SourceTable = "Sub Province";

//     layout
//     {
//         area(Content)
//         {
//             repeater(Control1)
//             {
//                 ShowCaption = false;
//                 field("Code"; Rec.Code)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies the postal code that is associated with a city.';
//                 }
//                 field(ProvinceCode; Rec."Province Code") { }
//                 field(ProvinceName; Rec."Province Name") { }
//                 field(Blocked; Rec.Blocked) { }
//             }
//         }
//     }

//     actions { }

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
//             Clear(SubPovinceText);
//             TempSubProv.Reset;
//             if TempSubProv.Find('-') then
//                 repeat
//                     if SubPovinceText = '' then
//                         SubPovinceText := TempSubProv.Code
//                     else
//                         SubPovinceText += '|' + TempSubProv.Code;
//                 until TempSubProv.Next = 0;
//         end;
//     end;

//     var
//         Selected: Boolean;
//         [InDataSet]
//         ShowSelected: Boolean;
//         SubProv: Record "Sub Province";
//         TempSubProv: Record "Sub Province" temporary;
//         SubPovinceText: Text;

//     procedure AssignShowSelected()
//     begin
//         ShowSelected := true;
//     end;

//     procedure InsertTempSubProv(SubProvText: Text)
//     begin
//         //Inserting to temp table
//         if SubProvText = '' then
//             exit;
//         SubProv.Reset;
//         SubProv.SetFilter(Code, SubProvText);
//         if SubProv.Find('-') then
//             repeat
//                 TempSubProv.Init;
//                 TempSubProv.Code := SubProv.Code;
//                 TempSubProv.Insert;
//             until SubProv.Next = 0;
//     end;

//     local procedure CheckSelected(SubProvText: Text): Boolean
//     begin
//         //Checking if selected
//         TempSubProv.Reset;
//         TempSubProv.SetRange(Code, SubProvText);
//         if TempSubProv.FindFirst then
//             exit(true);
//     end;

//     local procedure DeleteUnselected(SubProvText: Text)
//     begin
//         //Deleting from temp table
//         TempSubProv.Reset;
//         TempSubProv.SetRange(Code, SubProvText);
//         TempSubProv.Delete;
//     end;

//     procedure ReturnSubProvText(): Text
//     begin
//         exit(SubPovinceText);
//     end;
// }
