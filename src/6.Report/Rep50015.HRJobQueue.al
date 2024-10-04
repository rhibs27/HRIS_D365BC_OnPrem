report 50015 "HR Job Queue"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Send Training Mail"; IsToSendMailTrain)
                {
                    Caption = 'Send Training Mail';
                    ToolTip = 'Specifies the value of the Send Training Mail field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        if IsToSendMailTrain then
            SendingMailForTraining;
    end;

    var
        TrainHeader: Record "Training Header";
        HRMgt: Codeunit "HR Mgt.";
        EmailTemplate: Record "Email Template";
        IsToSendMailTrain: Boolean;

    local procedure SendingMailForTraining()
    begin
        TrainHeader.Reset;
        TrainHeader.SetRange("Start Date", Today + 1);
        TrainHeader.SetRange("Approval Status", TrainHeader."Approval Status"::Released);
        if TrainHeader.Find('-') then
            repeat
                HRMgt.SendMailFromTemplate(Database::"Training Header", EmailTemplate."Document Type"::Training, 0, '', TrainHeader."Prepared By", TrainHeader."No.", 0);
            until TrainHeader.Next = 0;
    end;
}
