report 50025 "Daily Update"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field("Update Emp. Age & Service Period"; UpdateAgeAndServicePeriod)
                    {
                        ToolTip = 'Specifies the value of the _UpdateAgeAndServicePeriod field.';
                        ApplicationArea = All;
                    }
                    field(UpdatePromotionDetails; UpdatePromotionDetails)
                    {
                        ToolTip = 'Specifies the value of the Update Promotion Details field.';
                        ApplicationArea = All;
                    }
                    field(UpdateLastPlacementDate; UpdateLastPlacementDate)
                    {
                        Caption = 'Update Last Placement Date of Employees';
                        ToolTip = 'Specifies whether to update the last placement date of employees.';
                        ApplicationArea = All;
                    }
                    field(UpdateServiceDurationForInactiveEmployees; UpdateServiceDurationForInactiveEmployees)
                    {
                        Caption = 'Update Service Duration for Inactive Employees';
                        ToolTip = 'Specifies whether to update service duration for inactive employees.';
                        ApplicationArea = All;
                    }
                    field(UpdateEmployeeSeniority; UpdateEmployeeSeniority)
                    {
                        Caption = 'Update Employee Seniority';
                        ToolTip = 'Specifies whether to update employee seniority.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        if UpdateAgeAndServicePeriod then begin
            UpdateAgeServicePeriod();
            UpdateEmployeeServiceDuration
        end;
        if UpdatePromotionDetails then
            UpdatePromotion;
        if UpdateLastPlacementDate then
            UpdateLastPlacementDateOfEmployees();

        if UpdateEmployeeSeniority then
            HRMgt.AssignEmployeeSeniority();
    end;

    var
        UpdateAgeAndServicePeriod: Boolean;
        UpdatePromotionDetails: Boolean;

        HRMgt: Codeunit "HR Mgt.";
        AgeDays: Integer;
        IsBirthDay: Boolean;

        UpdateLastPlacementDate: Boolean;
        UpdateServiceDurationForInactiveEmployees: Boolean;
        UpdateEmployeeSeniority: Boolean;

    local procedure UpdateAgeServicePeriod()
    var
        Employee: Record Employee;
    begin
        Employee.SetRange(Settled, false);
        if not UpdateServiceDurationForInactiveEmployees then
            Employee.SetRange(Status, Employee.Status::Active);
        if Employee.FindSet() then
            repeat
                if Employee."Resignation Date" = Today - 1 then
                    Employee.Status := Employee.Status::Terminated;
                if Employee."Birth Date" <> 0D then begin
                    HRMgt.CheckAgeAndBirthday(Employee."Birth Date", Today, Employee.Age, AgeDays, IsBirthDay);
                    Employee.Validate("Birth Date");
                end;
                if Employee."Employment Date" <> 0D then begin
                    HRMgt.CheckAgeAndBirthday(Employee."Employment Date", Today, Employee."Service Period", AgeDays, IsBirthDay);
                    Employee.Validate("Employment Date");
                end;
                Employee.Modify;
            until Employee.Next = 0;
    end;

    local procedure SendEmailOnMaxService()
    begin
    end;

    local procedure SendEmailOnMaxAge()
    begin
    end;

    procedure UpdateEmployeeServiceDuration()
    var
        Employee: Record Employee;
        EmpServiceHistory: Record "Employee Service History";
    begin
        Employee.Reset();
        Employee.SetLoadFields("No.", Status);
        Employee.SetRange(Status, Employee.Status::Active);
        if Employee.FindSet() then
            repeat
                EmpServiceHistory.SetRange("Employee No.", Employee."No.");
                if EmpServiceHistory.FindSet() then
                    repeat
                        EmpServiceHistory.UpdateDuration(EmpServiceHistory);
                    until EmpServiceHistory.Next() = 0;
            until Employee.Next() = 0;
    end;

    local procedure UpdatePromotion()
    var
        ServiceHistory: Record "Employee Service History";
        PromotionMgt: Codeunit "Promotion Mgt";
    begin
        ServiceHistory.Reset();
        ServiceHistory.SetLoadFields("Service Event", "Effective Date", "Service History Code");
        ServiceHistory.SetRange("Service Event", ServiceHistory."Service Event"::Promotion);
        ServiceHistory.SetRange("Effective Date", Today);
        if ServiceHistory.FindSet() then
            repeat
                PromotionMgt.UpdateInEmployeeProfile(ServiceHistory."Service History Code");
            until ServiceHistory.Next() = 0;
    end;

    local procedure UpdateLastPlacementDateOfEmployees()
    var
        Employee: Record Employee;
        ServiceHistory: Record "Employee Service History";
    begin
        if not UpdateLastPlacementDate then
            exit;

        Employee.SetRange(Settled, false);
        if Employee.FindSet() then
            repeat
                ServiceHistory.SetLoadFields("Employee No.", "Service Event", "Effective Date");
                ServiceHistory.SetCurrentKey("Effective Date");
                ServiceHistory.SetRange("Employee No.", Employee."No.");
                ServiceHistory.SetRange("Service Event", ServiceHistory."Service Event"::Transfer);
                if ServiceHistory.FindLast() then begin
                    Employee.Validate("Last Placement Date", ServiceHistory."Effective Date");
                    Employee.Modify(true);
                end;
            until Employee.Next() = 0;
    end;
}
