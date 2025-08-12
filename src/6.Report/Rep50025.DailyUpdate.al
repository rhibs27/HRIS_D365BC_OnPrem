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
                    field("Update Emp. Age & Service Period"; _UpdateAgeAndServicePeriod)
                    {
                        ToolTip = 'Specifies the value of the _UpdateAgeAndServicePeriod field.';
                        ApplicationArea = All;
                    }
                    field("Send Acknowledgement Email"; _SendEmailForTransferAcknowledgement)
                    {
                        ToolTip = 'Specifies the value of the _SendEmailForTransferAcknowledgement field.';
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
        if _UpdateAgeAndServicePeriod then
            UpdateAgeServicePeriod();
    end;

    var
        _UpdateAgeAndServicePeriod: Boolean;
        _SendEmailForTransferAcknowledgement: Boolean;
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        AgeDays: Integer;
        IsBirthDay: Boolean;

    local procedure UpdateAgeServicePeriod()
    begin
        Employee.Reset;
        if Employee.FindFirst then
            repeat
                if Employee."Resignation Date" = Today - 1 then
                    Employee.Status := Employee.Status::Terminated;
                HRMgt.CheckAgeAndBirthday(Employee."Birth Date", Today, Employee.Age, AgeDays, IsBirthDay);
                HRMgt.CheckAgeAndBirthday(Employee."Employment Date", Today, Employee."Service Period", AgeDays, IsBirthDay);
                if Employee."Employment Date" <> 0D then
                    Employee.Validate("Employment Date");
                Employee.Modify;
            until Employee.Next = 0;
    end;

    // local procedure SendEmailTransferAcknowledgement()
    // var
    //     EmpAct: Record "Employee Activity";
    // begin
    //     EmpAct.Reset;
    //     EmpAct.SetRange(Type, EmpAct.Type::"Employee Transfer");
    //     EmpAct.SetRange("Approval Status", EmpAct."Approval Status"::Approved);
    //     EmpAct.SetRange("Transfer Effective Date", Today, 99990101D);
    //     if EmpAct.FindFirst then
    //         repeat
    //             Clear(HRMgt);
    //             HRMgt.SendMailFromTemplate(Database::"Employee Activity",
    //                                   EmpAct.Type::"Employee Transfer",
    //                                   EmpAct."Approval Status"::Approved,
    //                                   '',
    //                                   EmpAct."Employee No.",
    //                                   EmpAct."No.",
    //                                   1);   //For email
    //         until EmpAct.Next = 0;
    // end;

    local procedure SendEmailOnMaxService()
    begin
    end;

    local procedure SendEmailOnMaxAge()
    begin
    end;
}
