report 50017 "Generate Leave Balance"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                TestField("Employment Type");
                TestField(Gender);
                TestField("Employment Date");
                if Employee."Employment Type" = Employee."Employment Type"::Permanent then
                    Employee.TestField("Confirmation Date");
                LeaveMgt.GenerateLeave(Employee."No.", LeaveCreditDate);

                //code will be placed seperately
                // if Type = Type::"New Fiscal Year" then begin
                //     if Employee."Employment Type" = Employee."Employment Type"::Contract then
                //         LeaveMgt.UpdateLeaveEmployeeContract("No.", "Employment Date", "Employment Type", Gender, "Marital Status")
                //     else if Employee."Employment Type" = Employee."Employment Type"::Permanent then
                //         //LeaveMgt.UpdateLeaveEmployee("No.", "Employment Date", "Employment Type", Gender, "Marital Status")
                //         LeaveMgt.GenerateLeave(Employee."No.")
                //     else if Employee."Employment Type" = Employee."Employment Type"::Probation then
                //         //LeaveMgt.UpdateLeaveEmployee("No.", "Employment Date", "Employment Type", Gender, "Marital Status")
                //         LeaveMgt.GenerateLeave(Employee."No.")
                // end else if Type = Type::"Employeement Type Change" then begin
                //     if ConfirmationDate = 0D then
                //         Error('Please fill confirmation date.');
                //     Employee.Validate("Confirmation Date", ConfirmationDate);
                //     Employee.Modify;

                //     LeaveMgt.UpdateLeaveForEmpTypeChanged(Employee."No.", Employee."Employment Type"::Probation, Employee."Employment Type"::Permanent);
                //     Employee."Employment Type" := Employee."Employment Type"::Permanent;
                //     if SalaryLevel <> '' then
                //         Employee.Validate("Salary Level", SalaryLevel);
                //     Employee.Modify;
                //     PayrollEngine.InsertPayrollAttributesUsage(Employee."No.");
                //     ServiceHistory.Reset;
                //     ServiceHistory.SetRange("Employee No.", "No.");
                //     ServiceHistory.SetRange("Service Event", ServiceHistory."Service Event"::Confirmation);
                //     if ServiceHistory.FindFirst then begin
                //         ServiceHistory.Validate("Salary Level (To)", SalaryLevel);
                //         ServiceHistory.Modify;
                //     end;
                // end;
                // Message('Confirmed');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                // group("Select Leave Balance Options")
                // {
                //     Caption = 'Select Leave Balance Options';
                //     field(Type; Type)
                //     {
                //         ToolTip = 'Specifies the value of the Type field.';
                //         ApplicationArea = All;

                //         trigger OnValidate()
                //         begin
                //             if Type = Type::"Employeement Type Change" then
                //                 IsTypeEmploymentTypeChanged := true
                //             else
                //                 IsTypeEmploymentTypeChanged := false;
                //         end;
                //     }
                // }
                //  group(Control4)
                // {
                //     Caption = 'Confirmation Date';
                //     Visible = IsTypeEmploymentTypeChanged;
                //     field("Confirmation Date"; ConfirmationDate)
                //     {
                //         ToolTip = 'Specifies the value of the ConfirmationDate field.';
                //         ApplicationArea = All;
                //     }
                //     field("Salary Level"; SalaryLevel)
                //     {
                //         TableRelation = "Salary Level";
                //         ToolTip = 'Specifies the value of the SalaryLevel field.';
                //         ApplicationArea = All;
                //     }
                // }
                field("Leave Credit Date"; LeaveCreditDate)
                {
                    ApplicationArea = all;
                }
            }
        }

    }

    trigger OnPreReport()
    begin
        if LeaveCreditDate = 0D then
            LeaveCreditDate := WorkDate();
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        LeaveMgt: Codeunit "Leave Mgt.";
        Type: Option " ","Employeement Type Change","New Fiscal Year";
        ConfirmationDate: Date;
        ServiceHistory: Record "Employee Service History";
        IsTypeEmploymentTypeChanged: Boolean;
        SalaryLevel: Code[20];
        PayrollEngine: Codeunit "Payroll Engine";
        LeaveCreditDate: Date;
}
