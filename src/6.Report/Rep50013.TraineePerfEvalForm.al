report 50013 "Trainee Perf. Eval. Form"
{
    // version HRM1.00

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019813.TraineePerfEvalForm.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Evaluation Entry"; "Evaluation Entry")
        {
            DataItemTableView = where(Type = const(Probation));
            RequestFilterFields = "No.";
            column(No_Employee; Employee."No.") { }
            column(EmployeeName; Employee.FullName) { }
            column(EmpDept; EmpDept) { }
            column(EmploymentDate_Employee; Format(Employee."Employment Date")) { }
            column(ApplicationInfo; ApplicationInfo) { }
            column(JobTitleName_Employee; Employee."Job Title Code") { }
            column(AttributeCode_EvaluationEntry; "Evaluation Entry"."Attribute Code") { }
            column(AttributeDescription_EvaluationEntry; "Evaluation Entry"."Attribute Description") { }
            column(GenderCode; GenderCode) { }
            column(Interviewer1_EvaluationEntry; "Evaluation Entry"."Interviewer Code") { }
            column(Interviewer2_EvaluationEntry; "Evaluation Entry"."Interviewer Name") { }
            column(Interviewer3_EvaluationEntry; "Evaluation Entry".Marks) { }
            column(RatingScaleIndex_1; RatingScaleIndex[1]) { }
            column(RatingScaleIndex_2; RatingScaleIndex[2]) { }
            column(RatingScaleIndex_3; RatingScaleIndex[3]) { }
            column(RatingScaleIndex_4; RatingScaleIndex[4]) { }
            column(RatingScaleIndex_5; RatingScaleIndex[5]) { }

            trigger OnAfterGetRecord()
            begin
                if Type = Type::Probation then begin
                    if Employee.Get("No.") then begin
                        if Employee.Gender = Employee.Gender::Male then
                            GenderCode := 'his'
                        else if Employee.Gender = Employee.Gender::Female then
                            GenderCode := 'her';
                        EmpDept := Employee."Company Code";
                    end;
                end;
                ApplicationInfo := 'We would like to update HR department that <b>' + Format(Employee.Salutation) + Employee.FullName +
                                    '</b> who has joined our organization from ' + Format(Employee."Employment Date") + ' has successfully completed ' +
                                    'Trainiee/Probationary period. We have evaluated ' + GenderCode + ' performances as per the given parameters ' +
                                    'and would like to confirm/reject ' + GenderCode + ' service. We  would like to request you to do the needful';
            end;

            trigger OnPreDataItem()
            begin
                i := 0;
                RatingScale.Reset;
                RatingScale.SetRange(Type, RatingScale.Type::Probation);
                if RatingScale.FindFirst then
                    repeat
                        i += 1;
                        RatingScaleIndex[i] := Format(RatingScale.Code) + ' = ' + RatingScale.Remarks + '(' + RatingScale.Description + ')';
                    until RatingScale.Next = 0;
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
        RatingScaleIndex: array[10] of Text;
        RatingScale: Record "Rating Scale";
        i: Integer;
        EmpDept: Text;
}
