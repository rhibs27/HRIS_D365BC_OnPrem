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
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
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
        LeaveMgt: Codeunit "Leave Mgt.";
        LeaveCreditDate: Date;
}
