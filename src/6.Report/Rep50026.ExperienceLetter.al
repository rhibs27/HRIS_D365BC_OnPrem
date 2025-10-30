report 50026 "Experience Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019827.ExperienceLetter.rdl';
    Caption = 'Experience Letter';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(TEXT001; TEXT001) { }
            column(BodyText; BodyText1) { }
            column(TEXT003; BodyText2) { }
            column(TEXT004; TEXT004) { }
            column(TEXT005; TEXT005) { }
            column(ReportNo; ReportNo) { }
            column(Cname; CompanyInfo.Name) { }
            column(CAddress; CompanyInfo.Address) { }
            column(CPic; CompanyInfo.Picture) { }

            trigger OnAfterGetRecord()
            begin
                if Employee."Employment Type" = Employee."Employment Type"::Probation then
                    EmploymentType := 'under probation'
                else if Employee."Employment Type" = Employee."Employment Type"::Contract then
                    EmploymentType := 'under contract'
                else if Employee."Employment Type" = Employee."Employment Type"::Permanent then
                    EmploymentType := 'as a permanent staff';

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

                WorkStationTxt := HRMgt.WorkStationFunction(Employee);
                if (Employee."Employment Type" <> Employee."Employment Type"::Contract) or
                    (Employee."Employment Type" <> Employee."Employment Type"::" ") then
                    if SalaryLevel.Get(Employee."Salary Level") then
                        WorkStationTxt += ' in the internal job grade of ' + SalaryLevel.Description;

                BodyText1 := StrSubstNo(TEXT002, Employee.Salutation, Employee."Full Name",
                            EmploymentType, Employee."Employment Date", Employee."Resignation Date",
                            Pronoun2, Pronoun1, WorkStationTxt);

                BodyText2 := StrSubstNo(TEXT003, Pronoun3, Pronoun2);
            end;

            trigger OnPreDataItem()
            begin
                HRSetUp.Get;
                if not CurrReport.Preview then
                    ReportNo := NoSeries.GetNextNo(HRSetUp."Experience No. Series", Today, true);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        EmploymentType: Text;
        TEXT001: Label 'To Whom It May Concern';
        TEXT002: Label 'This is to certify that %1 %2 was an employee of the bank %3 from %4 to %5. At the time of %6 resignation, %7 was working at %8.';
        TEXT004: Label 'Authorized Signature';
        BodyText1: Text;
        BodyText2: Text;
        Pronoun1: Text;
        Pronoun2: Text;
        Pronoun3: Text;
        TEXT005: Label 'DNA & Talent Management Department';
        TEXT003: Label 'We wish %1 every success in %2 future endeavours.';
        NoSeries: Codeunit "No. Series";
        ReportNo: Code[30];
        HRSetUp: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        WorkStationTxt: Text;
        SalaryLevel: Record "Salary Level";
        CompanyInfo: Record "Company Information";
}
