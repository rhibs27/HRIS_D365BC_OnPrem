report 50028 "Release Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019829.ReleaseLetter.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(FullName_Employee; Employee."Full Name") { }
            column(Declaration; Declaration) { }
            column(BodyText; BodyText) { }
            column(SignOffText; SignOffText) { }
            column(WorkStationText; WorkStationText) { }
            column(RefNo; RefNo) { }
            column(Text003; Text003) { }
            column(Cname; CompanyInfo.Name) { }
            column(CAddress; CompanyInfo.Address) { }
            column(CPic; CompanyInfo.Picture) { }

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
                    RequestedResignDate := Resignation."Requested Last Working Day";
                    // if Resignation."Supervisor Proposed Date" <> 0D then
                    //     AcceptedResignDate := Resignation."Supervisor Proposed Date"
                    // else if Resignation."HR Proposed Date" <> 0D then
                    //     AcceptedResignDate := Resignation."HR Proposed Date";
                end;
                BodyText := NL + StrSubstNo(Text001, Employee.Salutation, Employee."Last Name") + NL + NL +
                              StrSubstNo(Text002, AcceptedResignDate, NL, NL);
                SignOffText := StrSubstNo(Text004, NL);
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
        EmploymentType: Text;
        Text001: Label 'Dear %1 %2,';
        Text002: Label 'This has reference to your resignation from the Bank''s services; you have been released from the service of the Bank with effect from close of business hours %1. %2 %2The Bank shall have the right to claim for any damages or take legal actions arising out if your conduct during the service with the Bank which is against of Banks and Financial Institutions Act, Banking Offense and Punishment Act, Staff Service Bylaws or any laws of the land during the tenure of service in the Bank, even after your release from the service of the Bank.';
        Text003: Label 'Yours Sincerely,';
        Text004: Label 'Authorized Signature %1DNA & Talent Management Department';
        NL: Text;
        BodyText: Text;
        Resignation: Record Resignation;
        RequestedResignDate: Date;
        AcceptedResignDate: Date;
        Declaration: Label 'Strictly Private & Confidential';
        SignOffText: Text;
        WorkStationText: Text;
        HRMgt: Codeunit "HR Mgt.";
        RefNo: Code[100];
        CompanyInfo: Record "Company Information";
}
