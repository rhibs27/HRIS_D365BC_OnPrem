report 50057 "Mail for Payroll"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    dataset
    {
        dataitem("Posted Payroll Header"; "Posted Payroll Header")
        {
            trigger OnPreDataItem()
            begin
                if YearFilter <> 0 then
                    SetRange("Nepali Year", YearFilter);
                if MonthFilter <> MonthFilter::" " then
                    SetRange("Nepali Month", MonthFilter);
            end;

            trigger OnAfterGetRecord()
            var
                CodeunitEmailMessage: Codeunit "Email Message";
                Email: Codeunit Email;
                recRef: RecordRef;
                tmpBlob: Codeunit "Temp Blob";
                OutStr: OutStream;
                format: ReportFormat;
                InStr: InStream;
            begin
                CompanyInfo.Get;
                PostedPayHeader.SetRange("No.", "No.");
                PosPayLine.Reset;
                PosPayLine.SetRange("Document No.", "No.");
                if EmpFilter <> '' then
                    PosPayLine.SetFilter("Employee No.", EmpFilter);
                if BranchCode <> '' then
                    PosPayLine.SetFilter("Global Dimension 2 Code", BranchCode);

                if PosPayLine.FindSet() then
                    repeat
                        Clear(Body);
                        Clear(Header);
                        Clear(Footer);

                        if Employee.Get(PosPayLine."Employee No.") then begin
                            EmailTemplate.Reset;
                            EmailTemplate.SetRange("Sub Type", "Email Sub Type"::Payroll);
                            if EmailTemplate.FindFirst then begin
                                if not CheckValidEmailAddress(Employee."Company E-Mail") then begin
                                    Clear(CodeunitEmailMessage);
                                    CodeunitEmailMessage.Create(
                                        Employee."Company E-Mail",
                                        EmailTemplate.Subject + ' ' + Format("Nepali Month") + ',' + Format("Nepali Year"),
                                        ' ',
                                        true
                                    );

                                    EmailMessage.Reset;
                                    EmailMessage.SetRange("Template Code", EmailTemplate.Code);

                                    if EmailMessage.FindSet() then
                                        repeat
                                            case EmailMessage.Type of
                                                EmailMessage.Type::Header:
                                                    begin
                                                        Header := StrSubstNo(EmailMessage."Body Message", Employee."Full Name");
                                                    end;

                                                EmailMessage.Type::Body:
                                                    begin
                                                        Body := StrSubstNo(EmailMessage."Body Message", Format("Nepali Month"), Format("Nepali Year"));
                                                    end;

                                                EmailMessage.Type::Footer:
                                                    begin
                                                        if Footer = '' then
                                                            Footer := EmailMessage."Body Message"
                                                        else
                                                            Footer := Footer + '<br>' + EmailMessage."Body Message";
                                                    end;
                                            end;
                                        until EmailMessage.Next() = 0;
                                    CodeunitEmailMessage.AppendToBody(Header);
                                    CodeunitEmailMessage.AppendToBody('<br><br>');
                                    CodeunitEmailMessage.AppendToBody(Body);
                                    CodeunitEmailMessage.AppendToBody('<br><br>');
                                    CodeunitEmailMessage.AppendToBody(Footer);
                                    CodeunitEmailMessage.AppendToBody('<br><br>');
                                    Clear(tmpBlob);
                                    tmpBlob.CreateOutStream(OutStr);
                                    PostedPayHeader.Reset();
                                    PostedPayHeader.SetRange("No.", "No.");
                                    if PostedPayHeader.FindFirst() then begin
                                        Clear(PaySlip);
                                        PaySlip.SetEmployeeFilter(PosPayLine."Employee No.");
                                        PaySlip.SetTableView(PostedPayHeader);
                                        PaySlip.SaveAs('', format::Pdf, OutStr);
                                        tmpBlob.CreateInStream(InStr);
                                        CodeunitEmailMessage.AddAttachment('Payslip.pdf', 'application/pdf', InStr);

                                        Email.Send(CodeunitEmailMessage);
                                    end;

                                    Clear(FilePath);
                                end;
                            end;
                        end;
                    until PosPayLine.Next() = 0;

                Message('Payslip has been sent successfully.');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Employee Filter"; EmpFilter)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmpFilter field.';
                    ApplicationArea = All;
                }
                field("Branch FIlter"; BranchCode)
                {
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                                  Blocked = const(false));
                    ToolTip = 'Specifies the value of the BranchCode field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
    end;

    var
        CompanyInfo: Record "Company Information";
        EmailTemplate: Record "Email Template";
        Footer: Text;
        Header: Text;
        Body: Text;
        EmailMessage: Record "Email Template Message";
        Employee: Record Employee;
        PosPayLine: Record "Posted Payroll Line";
        PostedPayHeader: Record "Posted Payroll Header";
        PaySlip: Report "Payroll Payslip";
        FilePath: Text;
        EmpFilter: Text;
        BranchCode: Code[20];
        YearFilter: Integer;
        MonthFilter: Enum "Nepali Month";

    local procedure CheckValidEmailAddress(EmailAddress: Text): Boolean
    var
        i: Integer;
        NoOfAtSigns: Integer;
    begin
        EmailAddress := DelChr(EmailAddress, '<>');
        if EmailAddress = '' then
            exit(true);
        if StrLen(EmailAddress) = 0 then
            exit(true);
        if (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then
            exit(true);
        for i := 1 to StrLen(EmailAddress) do begin
            if EmailAddress[i] = '@' then
                NoOfAtSigns := NoOfAtSigns + 1
            else
                if EmailAddress[i] = '' then
                    exit(true);
        end;
        if NoOfAtSigns <> 1 then
            exit(true);
        exit(false);
    end;

    procedure SetYearMonth(Year: Integer; Month: Enum "Nepali Month")
    begin
        YearFilter := Year;
        MonthFilter := Month;
    end;
}