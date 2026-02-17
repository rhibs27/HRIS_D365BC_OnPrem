report 50027 "Resignation Acceptance Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019828.ResignationAcceptanceLetter.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(FullName_Employee; Header) { }
            column(Declaration; Subject) { }
            column(BodyText; BodyText) { }
            column(ClosureText; ClosureText) { }
            column(Text003; Text003) { }
            column(Text004; Text004) { }
            column(Text005; Text005) { }
            column(Text008; Text008) { }
            column(Text007; Text007) { }
            column(SignOffText; SignOffText) { }
            column(WorkStationText; WorkStationText) { }
            column(EmploymentType; EmploymentType) { }
            column(RefNo; RefNo) { }
            column(CompanyLogo; CompanyInformation.Picture) { }
            column(CompanyName; companyNameAddress[1]) { }
            column(CompanyAddress; companyNameAddress[2]) { }
            column(CompanyCommunicationAddr; companyNameAddress[3]) { }
            column(PrintedBy; UserId) { }

            trigger OnAfterGetRecord()
            begin
                EmploymentType := '';
                RequestedResignDate := 0D;
                AcceptedResignDate := 0D;
                BodyText := '';

                EmploymentType := Format(Employee."Salary Level Description") + ' Staff,';
                WorkStationText := HRMgt.WorkStationFunction(Employee);

                NL := '  ';
                NL[1] := 13;
                NL[2] := 10;
                Resignation.Reset;
                Resignation.SetRange("Employee No.", Employee."No.");
                Resignation.SetRange(Type, Resignation.Type::Resignation);
                Resignation.SetRange("Approval Status", Resignation."Approval Status"::Approved);
                if Resignation.FindFirst then begin
                    RefNo := 'Ref No: ' + Resignation."No.";
                    RequestedResignDate := Resignation."Proposed Date of Resignation";
                    AcceptedResignDate := Resignation."HR Proposed Date";
                end else
                    Error('%1 is not the Resigned Employee', Employee."Full Name");
                BodyText := NL + StrSubstNo(Text001, Employee.Salutation, Employee."Last Name") + NL + NL +
                              StrSubstNo(Text002, RequestedResignDate, NL, AcceptedResignDate, NL, NL);
                ClosureText := StrSubstNo(Text006, NL);
                SignOffText := StrSubstNo(Text008, NL);
                Header := StrSubstNo(Text001, Salutation, Employee."Full Name");
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }
    trigger OnPreReport()
    begin
        if CompanyInformation.get() then;
        CompanyInformation.CalcFields(Picture);
        HrMgt.GetCompanyOneLineAddress(CompanyNameAddress[1], CompanyNameAddress[2], CompanyNameAddress[3]);
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyNameAddress: array[3] of Text;
        EmploymentType: Text;
        Text001: Label 'Dear %1 %2,';
        Text002: Label 'This has reference to your resignation dated %1 regarding resigning from the Bank''s service. %2 %2Your resignation has been accepted with effect from close of business hour %3. However, you shall be responsible for all liabilities (if any in future) incurred by your action during your tenure in the bank. %2 %2You are required to:%2';
        Text003: Label 'Hand-over the Bank''s Identity Card.';
        Text004: Label 'Submit Handover Note as per Handover and Takeover Guideline.';
        Text005: Label 'Clear all your dues to the Bank including loans outstanding, if any.';
        Text006: Label 'We take this opportunity to thank you for your services to this Bank and wish you all success in your future endeavors.';
        Text007: Label 'Yours Sincerely,';
        Text008: Label 'Authorized Signature %1 Human Resource Management Department';
        NL: Text;
        BodyText: Text;
        Resignation: Record Resignation;
        RequestedResignDate: Date;
        AcceptedResignDate: Date;
        ClosureText: Text;
        Subject: Label 'Subject: Acceptance of Resignation';
        SignOffText: Text;
        WorkStationText: Text;
        HRMgt: Codeunit "HR Mgt.";
        RefNo: text;
        Header: text;
}
