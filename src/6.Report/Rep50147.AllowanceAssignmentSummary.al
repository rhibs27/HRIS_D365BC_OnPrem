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
            //RequestFilterFields = "No.";
            column(No; "No.") { }
            column(FromDate; "From Date") { }
            column(ToDate; "To Date") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(BranchName; BranchName) { }





            dataitem("Allowance Assignment Line"; "Allowance Assignment Line")
            {
                DataItemLink = "No." = field("No.");

                column(Date; "From Date") { }
                column(AtmAllowance; AtmAllowance) { }
                column(KeyCustodian; KeyCustodian) { }
                column(Teller; Teller) { }
                column(HeadTeller; HeadTeller) { }
                trigger OnPreDataItem()
                begin
                    SetRange("No.", No);
                end;




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
                        BranchName := Employee."Branch Name";

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
                    field(No; No)
                    {
                        ApplicationArea = All;
                        TableRelation = "Allowance Assignment Header"."No.";
                    }
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

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

    end;

    var
        Employee: Record Employee;
        PayrollGeneralSetup: Record "Payroll General Setup";
        AtmAllowance: Text;
        KeyCustodian: Text;
        Teller: Text;
        HeadTeller: Text;
        CompanyInfo: Record "Company Information";
        BranchName: Text;
        No: code[20];


    procedure PassParPortal(DocumentNo: code[20])
    var
        AllowanceAssignmentHeader: Record "Allowance Assignment Header";
    begin
        NO := DocumentNo;

    end;

}
