report 50027 "Resignation Acceptance Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019828.ResignationAcceptanceLetter.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(FullName_Employee; Employee."Full Name") { }
            column(Declaration; Declaration) { }
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

            trigger OnAfterGetRecord()
            begin
                EmploymentType := '';
                RequestedResignDate := 0D;
                AcceptedResignDate := 0D;
                BodyText := '';

                EmploymentType := Format(Employee."Employment Type") + ' Staff,';
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
                    if Resignation."Supervisor Proposed Date" <> 0D then
                        AcceptedResignDate := Resignation."Supervisor Proposed Date"
                    else if Resignation."HR Proposed Date" <> 0D then
                        AcceptedResignDate := Resignation."HR Proposed Date";
                end;
                BodyText := NL + StrSubstNo(Text001, Employee.Salutation, Employee."Last Name") + NL + NL +
                              StrSubstNo(Text002, RequestedResignDate, NL, AcceptedResignDate, NL, NL);
                ClosureText := StrSubstNo(Text006, NL);
                SignOffText := StrSubstNo(Text008, NL);
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
        EmploymentType: Text;
        Text001: Label 'Dear %1 %2,';
        Text002: Label 'This has reference to your resignation dated %1 regarding resigning from the Bank''s service. %2 %2Your resignation has been accepted with effect from close of business hour %3. However, you shall be responsible for all liabilities (if any in future) incurred by your action during your tenure in the bank. %2 %2You are required to:%2';
        Text003: Label 'Hand-over the Bank''s Identity Card to the DNA & Talent Management Department.';
        Text004: Label 'Submit Handover Note as per Handover and Takeover Guideline 2019.';
        Text005: Label 'Clear all your dues to the Bank including loans outstanding, if any.';
        Text006: Label 'Please contact DNA & Talent Management Department to complete the necessary formalities. %1 %1Your release letter shall be provided to you upon completion of all the necessary formalities.';
        Text007: Label 'Yours Sincerely,';
        Text008: Label 'Authorized Signature %1DNA & Talent Management Department';
        NL: Text;
        BodyText: Text;
        Resignation: Record "Employee Activity";
        RequestedResignDate: Date;
        AcceptedResignDate: Date;
        ClosureText: Text;
        Declaration: Label 'Strictly Private & Confidential';
        SignOffText: Text;
        WorkStationText: Text;
        HRMgt: Codeunit "HR Mgt.";
        RefNo: Code[20];
}
