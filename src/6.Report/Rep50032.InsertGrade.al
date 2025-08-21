report 50032 "Insert Grade"
{
    Caption = 'Insert Grade';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            trigger OnAfterGetRecord()
            begin
                HRSetup.Get;
                HRSetup.TestField("Grade Adjustment Period");
                GradeEntry.Reset;
                GradeEntry.SetRange("Employee No.", Employee."No.");

                if GradeEntry.FindFirst then begin
                    if Today >= CalcDate(HRSetup."Grade Adjustment Period", GradeEntry."Posting Date") then begin
                        GradeEntry.Init;
                        GradeEntry."Employee No." := Employee."No.";

                        SalaryGradeRec.Get(Employee."Salary Grade");
                        GradePercent := SalaryGradeRec."Grade Percentage";

                        SalaryGradeRec.Reset;
                        SalaryGradeRec.SetCurrentKey("Grade Percentage");
                        SalaryGradeRec.SetFilter("Grade Percentage", '>%1', GradePercent);
                        if SalaryGradeRec.FindFirst then
                            GradeEntry.Grade := SalaryGradeRec.Code;
                        GradeEntry."Posting Date" := CalcDate(HRSetup."Grade Adjustment Period", GradeEntry."Posting Date");
                        GradeEntry.Insert(true);
                        Employee."Salary Grade" := GradeEntry.Grade;
                        Employee.Modify;
                    end;
                end;
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
        GradeEntry: Record "Grade Entry";
        SalaryGradeRec: Record "Salary Grade";
        GradePercent: Decimal;
        HRSetup: Record "Human Resources Setup";

    local procedure APRFY()
    var
        AppraisalRec: Record Appraisal;
        GradeEntry: Record "Grade Entry";
        TempGrade: Integer;
    begin
        HRSetup.Get;
        HRSetup.TestField("APR Grade 1 Increment");
        HRSetup.TestField("APR Grade 2 Increment");
        GradeEntry.Reset;
        GradeEntry.SetRange("Employee No.", Employee."No.");

        if GradeEntry.FindFirst then begin
            GradeEntry.Init;
            GradeEntry."Employee No." := Employee."No.";

            SalaryGradeRec.Get(Employee."Salary Grade");
            GradePercent := SalaryGradeRec."Grade Percentage";

            AppraisalRec.Reset;
            AppraisalRec.SetRange("Employee Code", Employee."No.");
            if AppraisalRec.FindFirst then begin
                if Format(AppraisalRec.Rating) = HRSetup."APR Grade 2 Increment" then begin
                    Evaluate(TempGrade, SalaryGradeRec.Code);
                    GradeEntry.Grade := Format(TempGrade + 2);
                end
                else if Format(AppraisalRec.Rating) = HRSetup."APR Grade 1 Increment" then begin
                    Evaluate(TempGrade, SalaryGradeRec.Code);
                    GradeEntry.Grade := Format(TempGrade + 2);
                end;
            end;
            GradeEntry."Posting Date" := CalcDate(HRSetup."Grade Adjustment Period", GradeEntry."Posting Date");
            GradeEntry.Insert(true);
            Employee."Salary Grade" := GradeEntry.Grade;
            Employee.Modify;
        end;
    end;
}
