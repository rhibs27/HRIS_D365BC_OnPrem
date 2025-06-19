report 50147 "Allowance Assignment Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50147.AllowanceAssignmentSummary.rdl';
    ApplicationArea = All;
    Caption = 'Allowance Assignment Summary';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Allowance Assignment Header"; "Allowance Assignment Header")
        {
            RequestFilterFields = "No.";
            column(No; "No.") { }
            column(FromDate; "From Date") { }
            column(ToDate; "To Date") { }


            dataitem("Allowance Assignment Line"; "Allowance Assignment Line")
            {
                DataItemLink = "No." = field("No.");
                column(Date; "From Date") { }
                column(AtmAllowance; AtmAllowance) { }
                column(KeyCustodian; KeyCustodian) { }
                column(Teller; Teller) { }
                column(HeadTeller; HeadTeller) { }

                trigger OnAfterGetRecord()
                begin

                    Clear(AtmAllowance);
                    Clear(KeyCustodian);
                    Clear(Teller);
                    Clear(HeadTeller);

                    if Employee.Get("Employee Code") and PayrollGeneralSetup.Get() then begin
                        if "Allowance Type" = PayrollGeneralSetup."ATM Custodian" then
                            AtmAllowance := Employee."Full Name" + ' (' + "Employee Code" + ')';

                        if "Allowance Type" = PayrollGeneralSetup."Vault Key" then
                            KeyCustodian := Employee."Full Name" + ' (' + "Employee Code" + ')';

                        if "Allowance Type" = PayrollGeneralSetup."Teller Allowance" then
                            Teller := Employee."Full Name" + ' (' + "Employee Code" + ')';

                        if "Allowance Type" = PayrollGeneralSetup."Head Teller Allowance" then
                            HeadTeller := Employee."Full Name" + ' (' + "Employee Code" + ')';
                    end;
                end;



            }
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

    var

    var
        Employee: Record Employee;
        PayrollGeneralSetup: Record "Payroll General Setup";
        AtmAllowance: Text;
        KeyCustodian: Text;
        Teller: Text;
        HeadTeller: Text;




}
