report 50150 "Import Payroll Attributes"
{
    ApplicationArea = All;
    Caption = 'Payroll Attribute Import';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(PayrollAttributes; "Payroll Attributes")
        {
            RequestFilterFields = Code, "Employee Type", Irregular;
            trigger OnAfterGetRecord()
            var
                PayrollAttrUses: Record "Payroll Attributes Usage";
                PayrollAttrUses2: Record "Payroll Attributes Usage";
            begin
                Employee.Reset();
                Employee.SetLoadFields("No.", Status, "Employment Type", "Emplymt. Contract Code");
                if EmployeeNo <> '' then
                    employee.SetRange("No.", EmployeeNo);
                Employee.SetRange(Status, Employee.Status::Active);
                Employee.SetFilter("Tax Code", '<>%1', '');
                if PayrollAttributes."Employee Type" <> PayrollAttributes."Employee Type"::" " then
                    Employee.SetRange("Employment Type", PayrollAttributes."Employee Type");
                if PayrollAttributes."Emplymt. Contract Code" <> '' then
                    Employee.SetRange("Emplymt. Contract Code", PayrollAttributes."Emplymt. Contract Code");
                if Employee.FindSet() then
                    repeat
                        Clear(PayrollAttrUses);
                        if not PayrollAttrUses.Get(PayrollAttributes.Code, Employee."No.") then begin
                            PayrollAttrUses2.Init();
                            PayrollAttrUses2.Validate(Code, PayrollAttributes.Code);
                            PayrollAttrUses2.Validate("Employee Code", Employee."No.");
                            if PayrollAttrUses2.Insert() then;
                        end;
                    until Employee.Next() = 0;

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(EmployeeNo; EmployeeNo)
                    {
                        TableRelation = Employee;
                        Caption = 'Employee No';
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin

    end;

    var
        EmployeeNo: Code[20];
        Employee: Record Employee;

    procedure SetEmployeeNo(EmpNo: Code[20])
    begin
        EmployeeNo := EmpNo;
    end;
}
