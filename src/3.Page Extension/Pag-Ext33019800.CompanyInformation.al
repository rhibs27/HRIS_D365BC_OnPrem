pageextension 33019800 CompanyInformation extends "Company Information"
{
    actions
    {
        addafter("Reason Codes")
        {
            action("Update KPI")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Update KPI action.';

                trigger OnAction()
                var
                    KPIMgt: Codeunit "KPI Mgt.";
                begin
                    KPIMgt.calculatefinalscoreforprobatation('APP-112');
                end;
            }
        }
    }
}
