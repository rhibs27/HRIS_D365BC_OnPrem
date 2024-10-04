report 33019831 "Acceptance of Resign Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019831.AcceptanceofResignLetter.rdl';
    Caption = 'Acceptance of Resignation Letter Memo';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(FullName_Employee; Employee."Full Name") { }
            column(NoteTxt; NoteTxt) { }
            column(BodyText2; BodyText2) { }
            column(Cname; CompanyInfo.Name) { }
            column(CAddress; CompanyInfo.Address) { }
            column(CPic; CompanyInfo.Picture) { }

            trigger OnAfterGetRecord()
            begin
                if Employee.Salutation = Employee.Salutation::"Mr." then begin
                    Pronoun1 := 'he';
                    Pronoun2 := 'his';
                    Pronoun3 := 'him';
                end
                else if Employee.Salutation = Employee.Salutation::"Ms." then begin
                    Pronoun1 := 'she';
                    Pronoun2 := 'her';
                    Pronoun3 := 'her';
                end;

                NL := '  ';
                NL[1] := 13;
                NL[2] := 10;

                SalaryLevel.Get(Employee."Salary Level");
                if Emp.Get(Employee."Manager No.") then;
                EmpActRec.Reset;
                EmpActRec.SetRange("Employee No.", Employee."No.");
                EmpActRec.SetRange(Type, EmpActRec.Type::Resignation);
                if EmpActRec.FindLast then
                    ResignationSubDate := EmpActRec."Proposed Date of Resignation";

                BodyText1 := StrSubstNo(Body001, Employee."Full Name", SalaryLevel.Description,
                              HRMgt.WorkStationFunction(Employee), Pronoun2, Format(ResignationSubDate), Emp."Full Name",
                              Emp."Salary Level", HRMgt.WorkStationFunction(Emp), Pronoun3, EmpActRec."Reason for Resignation");

                EmpActRec.Reset;
                EmpActRec.SetRange("Employee No.", Employee."No.");
                EmpActRec.SetRange(Type, EmpActRec.Type::Resignation);
                if EmpActRec.FindLast then begin
                    if EmpActRec."Waiver Case" = EmpActRec."Waiver Case"::Recovery then
                        BodyText2 := BodyText1 + NL + NL + Body002 + StrSubstNo(Body004, ' recover ', StrSubstNo(Body005, Pronoun2) +
                                      ' and ', Pronoun2, EmpActRec."HR Proposed Date") + NL + NL + Body003
                    else if EmpActRec."Waiver Case" = EmpActRec."Waiver Case"::Normal then
                        BodyText2 := BodyText1 + NL + NL + Body002 + StrSubstNo(Body004, ' waive ', StrSubstNo(Body005, Pronoun2) +
                                      ' and ', Pronoun2, EmpActRec."HR Proposed Date") + NL + NL + Body003
                    else
                        BodyText2 := BodyText1 + ' ' + StrSubstNo(Body004, ' ', ' ', Pronoun2, EmpActRec."HR Proposed Date") + NL + NL + Body003;
                end;
                NoteTxt := StrSubstNo(Note, Pronoun2);
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        Emp: Record Employee;
        EmpActRec: Record "Employee Activity";
        Note: Label 'Note: Izone User ID, Finacle User ID and Email ID shall be disabled on %1 Close of Business Hour.';
        SalaryLevel: Record "Salary Level";
        HRMgt: Codeunit "HR Mgt.";
        NL: Text;
        NoteTxt: Text;
        Pronoun1: Text;
        Pronoun2: Text;
        Pronoun3: Text;
        Body001: Label '%1, %2, %3, has submitted %4 resignation on %5. %6-%7-%8 had tried to counsel %9 and convince %9 to continue service with the Bank and provided Staff Counseling Report and Resignation Recommendation Memo in prescribed format as attached but %1 has made up %4 mind to leave the organization because of %4 %10.';
        BodyText1: Text;
        ResignationSubDate: Date;
        Body002: Label 'According to Staff Service Bylaws 2073, Clause No, 64, Permanent stall needs to give 30 days'' prior notice in case of leaving the Bank on his/her own accord. If an employee decides to leave the Bank, for whatever the reason, without giving 30 days'' prior notice period, staff shall be required to pay salary and allowance for shortfall notice period as per staff service bylaws. ';
        Body003: Label 'As per Annexure 21 of Integrated Organization Development and Human Resource Management policy 2019 i.e. Standard Operating Procedure-Staff Settlement-Resignation, Retirement and Termination, confirmation regarding any records of investigation and/or disciplinary action was sought with Head-Internal Audit, Chief Risk Officer (CRO) and Chief Support Officer (CSO) & Head-Legal confirmation regarding any dues, receivable from the staff was sought from Finance and Accounts, General Administration and Protect, Branch Operation and Re conciliation Department. However, response from Reconciliation Department (IRMD) was obtained. Further no response from CRO, CSO, Head-Legal, Head Internal Audit and Finance and Accounts Department has been considered as no any disciplinary actions or any dues, receivables at their ends. Hence, we seek your approval for the acceptance of resignation of staff.';
        Body004: Label 'Hence, it is recommended to%1%2accept %3 resignation with effect from close of business hour %4.';
        BodyText2: Text;
        Body005: Label 'shortfall notice period charge as per recommendation of %1 line manager';
        CompanyInfo: Record "Company Information";
}
