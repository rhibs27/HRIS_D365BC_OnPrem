report 50143 EmployeeJobQue
{
    Caption = 'EmployeeJobQueue';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Employee; Employee)
        {
            trigger OnPostDataItem()
            var
            begin

            end;

            trigger OnAfterGetRecord()
            var

            begin
                Employee.Reset();
                Employee.SetRange("Resignation Date", Today);
                if Employee.FindSet() then
                    repeat
                        //Employee.Status := Employee.Status::Inactive;
                        Employee."Disable Punch in" := true;
                        Employee.Modify();
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
}

