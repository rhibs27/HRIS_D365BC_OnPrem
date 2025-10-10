// report 50067 "Allowance Assignment Mail"
// {
//     ProcessingOnly = true;
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;

//     dataset { }

//     requestpage
//     {
//         layout { }

//         actions { }
//     }

//     labels { }

//     trigger OnPostReport()
//     begin
//         Message('Success')
//     end;

//     trigger OnPreReport()
//     begin
//         SendMailAllowanceAssignment;
//     end;

//     var
//         // GLSetup: Record "General Ledger Setup";
//         // DimValue: Record "Dimension Value";
//         OrganizationStructureList: Record "Organization Structure List";
//         AllowanceHeader: Record "Allowance Assignment Header";
//         // EmpHie: Record "Employee Hierarchy Master";
//         HRMgt: Codeunit "HR Mgt.";
//         EmailTemplate: Record "Email Template";
//         PGSetup: Record "Payroll General Setup";
//         AllowanceLine: Record "Allowance Assignment Line";

//     local procedure SendMailAllowanceAssignment()
//     begin
//         PGSetup.Get;
//         // GLSetup.Get;
//         if (((Today) - CalcDate('<-CM>', Today - PGSetup."Allowance Email Days") + 1) mod 7) <= PGSetup."Allowance Email Days" then begin
//             OrganizationStructureList.SetRange(Type, OrganizationStructureList.type::Branch);
//             if OrganizationStructureList.Find('-') then
//                 repeat
//                     AllowanceHeader.Reset;
//                     AllowanceHeader.SetRange(Type, AllowanceHeader.Type::Branch);
//                     AllowanceHeader.SetFilter("From Date", '<=%1', Today - PGSetup."Allowance Email Days");
//                     AllowanceHeader.SetFilter("To date", '>=%1', Today - PGSetup."Allowance Email Days");
//                     AllowanceHeader.SetRange(Code, OrganizationStructureList.Code);
//                     if not AllowanceHeader.FindFirst then
//                         HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, OrganizationStructureList.Name, OrganizationStructureList.Code)
//                     else if AllowanceHeader.FindFirst then begin
//                         AllowanceLine.Reset;
//                         AllowanceLine.SetRange("No.", AllowanceHeader."No.");
//                         if not AllowanceLine.FindFirst then
//                             HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, OrganizationStructureList.Name, OrganizationStructureList.Code);
//                     end;
//                 until OrganizationStructureList.Next = 0;
//             OrganizationStructureList.Reset;
//             OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::"Extension Counter");
//             if OrganizationStructureList.Find('-') then begin
//                 AllowanceHeader.Reset;
//                 AllowanceHeader.SetRange(Type, AllowanceHeader.Type::"Extension Counter");
//                 AllowanceHeader.SetFilter("From Date", '<=%1', Today - PGSetup."Allowance Email Days");
//                 AllowanceHeader.SetFilter("To date", '>=%1', Today - PGSetup."Allowance Email Days");
//                 AllowanceHeader.SetRange(Code, OrganizationStructureList.Code);
//                 if not AllowanceHeader.FindFirst then
//                     HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, OrganizationStructureList.Name, OrganizationStructureList.Code)
//                 else if AllowanceHeader.FindFirst then begin
//                     AllowanceLine.Reset;
//                     AllowanceLine.SetRange("No.", AllowanceHeader."No.");
//                     if not AllowanceLine.FindFirst then
//                         HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, OrganizationStructureList.Name, OrganizationStructureList.Code);
//                 end;
//             end;
//         end;
//     end;

//     local procedure SendMailTo()
//     begin
//     end;
// }
