report 50033 Darbandi
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019834.Darbandi.rdl';
    Caption = 'Darbandi';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Salary Level"; "Salary Level")
        {
            column(CountRec; CountRec) { }
            column(Darbandi; "Salary Level".Darbandi) { }
            column(Code_SalaryLevel; "Salary Level".Code) { }
            column(Description_SalaryLevel; "Salary Level".Description) { }
            column(Rank_SalaryLevel; "Salary Level".Rank) { }

            trigger OnAfterGetRecord()
            begin
                Clear(CountRec);
                EmpRec.Reset;
                EmpRec.SetRange(Status, EmpRec.Status::Active);
                EmpRec.SetRange("Salary Level", "Salary Level".Code);
                if EmpRec.FindFirst then
                    repeat
                        CountRec += 1;
                    until EmpRec.Next = 0;
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
        CountRec: Integer;
        EmpRec: Record Employee;
}
