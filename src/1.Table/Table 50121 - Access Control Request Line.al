// table 50121 "Access Control Request Line"
// {
//     DataClassification = CustomerContent;

//     fields
//     {
//         field(1; "Document No."; Code[20]) { }
//         field(2; "Employee No."; Code[20])
//         {
//             TableRelation = if ("Request Case" = const(Recruitement)) Employee
//             else
//             Employee."No.";

//             trigger OnValidate()
//             begin
//                 if Employee.Get("Employee No.") then
//                     Validate("Employee Name", Employee."Full Name")
//                 else
//                     Clear("Employee Name");
//             end;
//         }
//         field(3; "Employee Name"; Text[50]) { }
//         field(4; "Employee Document No."; Code[20]) { }
//         field(5; "System Type"; Code[20])
//         {
//             TableRelation = "System Access Control".Code where("Type of Masters" = const("System Type"));

//             trigger OnValidate()
//             begin
//                 SystemAccessControl.Reset;
//                 SystemAccessControl.SetRange(Code, "System Type");
//                 SystemAccessControl.SetRange("Type of Masters", SystemAccessControl."Type of Masters"::"System Type");
//                 if SystemAccessControl.FindFirst then begin
//                     Validate("System Type Name", SystemAccessControl.Name);
//                     Validate("System Category Code", SystemAccessControl."System Category Code");
//                     Validate("System Category Name", SystemAccessControl."System Category Name");
//                 end else begin
//                     Clear("System Type Name");
//                     Clear("System Category Name");
//                     Clear("System Category Code");
//                 end;

//                 if EmployeeActivity.Get("Document No.") then
//                     Validate("Employee Activity Type", Format(EmployeeActivity.Type));
//             end;
//         }
//         field(6; "System Type Name"; Text[50])
//         {
//             Editable = false;
//         }
//         field(7; "Line No."; Integer)
//         {
//         }
//         field(8; Status; Enum "Attendance Status")
//         {

//         }
//         field(9; "Employee Activity Type"; Text[30]) { }
//         field(10; "System Category Code"; Code[20])
//         {
//             Editable = false;
//         }
//         field(11; "System Category Name"; Text[50])
//         {
//             Editable = false;
//         }
//         field(12; "Access Type"; Enum "Access Type")
//         {

//         }
//         field(13; "Approved Date"; Date)
//         {
//             Editable = false;
//         }
//         field(14; "Approved By"; Code[20])
//         {
//             Editable = false;
//         }
//         field(15; "Request Case"; Enum "Request Case")
//         {
//             Description = 'Access Control';

//         }
//         field(16; "Employee Filter"; Code[20])
//         {
//             CalcFormula = lookup("Employee Activity"."Employee No." where("No." = field("Document No.")));
//             FieldClass = FlowField;
//         }
//     }

//     keys
//     {
//         key(Key1; "Document No.", "Line No.") { }
//     }

//     fieldgroups { }

//     var
//         SystemAccessControl: Record "System Access Control";
//         EmployeeActivity: Record "Employee Activity";
//         Employee: Record Employee;
// }
