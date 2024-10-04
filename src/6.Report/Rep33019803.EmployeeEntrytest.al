report 33019803 "Employee Entry test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019803.EmployeeEntrytest.rdl';

    dataset
    {
        dataitem("Employee Ledger Entry"; "Employee Ledger Entry")
        {
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; PostedPayroll."Employee Name") { }
            column(emplNetpay; Amount) { }
            column(postednetpay; PostedPayroll."Net Pay") { }

            trigger OnAfterGetRecord()
            begin
                CalcFields(Amount);
                Clear(PostedPayroll);
                PostedPayroll.Reset;
                PostedPayroll.SetRange("Employee No.", "Employee Ledger Entry"."Employee No.");
                PostedPayroll.SetRange("Document No.", "Employee Ledger Entry"."Document No.");
                if PostedPayroll.FindFirst then;
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
        PostedPayroll: Record "Posted Payroll Line";
}
