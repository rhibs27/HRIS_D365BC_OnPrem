codeunit 50031 "Promotion Mgt"
{
    procedure UpdateInEmployeeProfile(ServiceHistoryCode: Code[20])
    begin
        if ServiceHistory.Get(ServiceHistoryCode) then
            if EmployeeRec.Get(ServiceHistory."Employee No.") then begin
                EmployeeRec.Validate("Salary Level", ServiceHistory."Salary Level (To)");
                EmployeeRec.Validate("Salary Grade", ServiceHistory."Salary Grade (To)");
                EmployeeRec.Validate("Approver Role", ServiceHistory."Approver Role (To)");
                EmployeeRec.Validate("Functional Title", ServiceHistory."Functional Title (To)");
                EmployeeRec.Validate("Staff level", ServiceHistory."Staff Level (To)");
                EmployeeRec.Validate("Promotion Date", ServiceHistory."Effective Date");
                EmployeeRec.Modify(true);
            end;
    end;

    var
        EmployeeRec: Record Employee;
        ServiceHistory: Record "Employee Service History";
}
