table 50127 "KPI Daily Score"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "KPI Code"; Code[20])
        {
            TableRelation = "KPI Master Bank";

            trigger OnValidate()
            begin
                //<<KPI1.00
                KPIMaster.Get("KPI Code");
                Validate("KPI Description", KPIMaster.Description);
                Validate("KPI Type", KPIMaster.Type);
                Validate("Is Operating Profit", KPIMaster."Is Operating Profit");
                Validate("Is Adjustment KPI", KPIMaster."Is Adjustment KPI");
                KPISetup.Reset;
                KPISetup.SetRange("KPI Code", "KPI Code");
                if Type = Type::Employee then begin
                    EmployeeRec.Get("Employee Code");
                    KPISetup.SetRange(Code, EmployeeRec."KPI Functional Title");
                end else if Type = Type::Department then
                        KPISetup.SetRange(Code, Department);
                if KPISetup.FindFirst then begin
                    "Weightage%" := KPISetup."Weightage %";
                    "KPI Category" := KPISetup."KPI Category";
                end;
                KPITargetRaw.Reset;
                if Type = Type::Employee then begin
                    KPITargetRaw.SetCurrentKey("Employee Code");
                    KPITargetRaw.SetRange("Employee Code", "Employee Code");
                end
                else if Type = Type::Department then begin
                    KPITargetRaw.SetCurrentKey(Department);
                    KPITargetRaw.SetRange(Department, Department);
                    EmpRec.Reset;
                    EmpRec.SetRange("Department Code", Department);
                    if EmployeeRec.FindFirst then
                        EmpCode := EmployeeRec."No.";
                end;
                KPITargetRaw.SetRange("KPI Code", "KPI Code");
                KPITargetRaw.SetFilter("Start Date", '<=%1', "Entry Date");
                KPITargetRaw.SetRange("Expire Target", false);
                if KPITargetRaw.FindLast then begin
                    if "KPI Type" = "KPI Type"::Quantitative then begin
                        if Type = Type::Employee then
                            //"Target Per Day" := KPITargetRaw."Target Score"/KPIMgt.CalculateNoOfWorkingDays(KPITargetRaw."Start Date",KPITargetRaw."End Date","Employee Code")
                            Validate("Target Per Day", KPITargetRaw."Target Score" / KPIMgt.CalculateNoOfWorkingDays(KPITargetRaw."Start Date", KPITargetRaw."End Date", "Employee Code"))
                        else if Type = Type::Department then
                            "Target Per Day" := KPITargetRaw."Target Score" / KPIMgt.CalculateNoOfWorkingDays(KPITargetRaw."Start Date", KPITargetRaw."End Date", EmpCode);
                    end
                    else
                        "Target Per Day" := KPITargetRaw."Target Score";
                end;
                //>KPI1.00
            end;
        }
        field(3; "KPI Description"; Text[250]) { }
        field(4; "Target Per Day"; Decimal) { }
        field(5; "Actual Score Per Day"; Decimal) { }
        field(6; "Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmployeeRec.Get("Employee Code") then //KPI1.00
                    Validate(Department, EmployeeRec."Department Code");
            end;
        }
        field(7; Calculated; Boolean) { }
        field(8; "Entry Date"; Date)
        {
            trigger OnValidate()
            begin
                if EmpRec.Get("Employee Code") then begin
                    if EmpRec."Employment Type" = EmpRec."Employment Type"::Probation then begin
                        Quarter := '';
                        "Fiscal Year" := '';
                    end else begin
                        Quarter := KPIMgt.GetQuarter("Entry Date");//KPI1.00
                        "Fiscal Year" := KPIMgt.CalculateFiscalYear("Entry Date");
                    end;
                end;
            end;
        }
        field(9; "Weightage%"; Decimal)
        {
        }
        field(10; "KPI Type"; Enum "KPI Master Type")
        {

        }
        field(11; "KPI Score"; Decimal) { }
        field(12; Quarter; Text[10]) { }
        field(13; Type; Enum EmployeeDepartment)
        {

        }
        field(14; Department; Code[20])
        {
            TableRelation = "Organization Structure List".code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            trigger OnValidate()
            begin
                if DepartmentRec.Get(Department) then //kpi1.00
                    "Department Name" := DepartmentRec.Name;
            end;
        }
        field(15; "Department Name"; Text[50]) { }
        field(16; "Fiscal Year"; Text[10]) { }
        field(17; "Calculated Date"; Date) { }
        field(18; "Is Department"; Boolean) { }
        field(19; "KPI Category"; Code[20])
        {
            TableRelation = "KPI Category";
        }
        field(20; "Is Adjustment KPI"; Boolean) { }
        field(21; "Is Operating Profit"; Boolean) { }
    }

    keys
    {
        key(Key1; "Line No.") { }
    }

    fieldgroups { }

    var
        KPIMaster: Record "KPI Master Bank";
        KPISetup: Record "KPI Setup Bank";
        EmployeeRec: Record Employee;
        KPITargetRaw: Record "KPI Target Raw";
        KPIMgt: Codeunit "KPI Mgt.";
        EmpRec: Record Employee;
        EmpCode: Code[20];
        DepartmentRec: Record "Organization Structure List";
}
