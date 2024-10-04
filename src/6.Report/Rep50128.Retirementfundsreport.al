report 50128 "Retirement funds report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019929.RetirementfundsReport.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Retirement Fund"; "Retirement Fund")
        {
            DataItemTableView = sorting("No.") order(ascending);
            column(ActualLumpsumpCIT_RetirementFund; "Retirement Fund"."Actual Lumpsump CIT") { }
            column(ActualLumpsumpRTF_RetirementFund; "Retirement Fund"."Actual Lumpsump RTF") { }
            column(No_RetirementFund; "Retirement Fund"."No.") { }
            column(EmployeeNo_RetirementFund; "Retirement Fund"."Employee No.") { }
            column(EmployeeName_RetirementFund; "Retirement Fund"."Employee Name") { }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }
}
