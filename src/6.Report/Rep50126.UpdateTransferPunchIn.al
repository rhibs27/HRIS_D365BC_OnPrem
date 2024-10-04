report 50126 "Update Transfer Punch In"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.") order(ascending) where(Status = filter(Active));

            trigger OnAfterGetRecord()
            begin
                TransferVar.Reset;
                TransferVar.SetRange("Employee No.", "No.");
                TransferVar.SetFilter(Type, '%1|%2', TransferVar.Type::"HR Transfer", TransferVar.Type::"Employee Transfer");
                TransferVar.SetRange("Approval Status", TransferVar."Approval Status"::Approved);
                TransferVar.SetFilter("Transfer Effective Date", '<=%1', Today);
                if TransferVar.FindFirst then
                    repeat
                        Employee."Disable Punch in" := true;
                        Employee.Modify;
                    until TransferVar.Next = 0;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        TransferVar: Record "Employee Activity";
}
