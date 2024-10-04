report 33019812 "Trainee Perf. Eval. Conf. Form"
{
    // version HRM1.00

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019812.TraineePerf.Eval.Conf.Form.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Evaluation Entry"; "Evaluation Entry")
        {
            RequestFilterFields = "No.";
            column(No_Employee; "No.") { }
            column(EmployeeName; Employee.FullName) { }
            column(EmploymentDate_Employee; Format(Employee."Employment Date")) { }
            column(ApplicationInfo; ApplicationInfo) { }

            trigger OnAfterGetRecord()
            begin
                if Employee.Get("Evaluation Entry"."No.") then begin
                    if Employee.Gender = Employee.Gender::Male then
                        GenderCode := 'his'
                    else if Employee.Gender = Employee.Gender::Female then
                        GenderCode := 'her';
                end;
                ApplicationInfo := 'We would like to update HR department that <b>' + Format(Employee.Salutation) + Employee."Full Name" +
                                    '</b> who has joined our organization from ' + Format(Employee."Employment Date") + ' has successfully completed ' +
                                    'Trainiee/Probationary period. We have evaluated ' + GenderCode + ' performances as per the given parameters ' +
                                    'and would like to confirm/reject ' + GenderCode + ' service. We  would like to request you to do the needful';
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
        ApplicationInfo: Text;
        GenderCode: Text;
        Employee: Record Employee;
}
