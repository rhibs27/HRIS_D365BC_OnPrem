page 50264 PayrollGeneralSetupAPI
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'payrollGeneralSetupAPI';
    DelayedInsert = true;
    EntityName = 'payrollGeneralSetupAPI';
    EntitySetName = 'payrollGeneralSetupAPIs';
    PageType = API;
    SourceTable = "Payroll General Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(taxExAmtNotExceeding; Rec."Tax Ex. Amt. not Exceeding")
                {
                    Caption = 'Tax Ex. Amt. not Exceeding';
                }
            }
        }
    }
}
