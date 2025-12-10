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
                // SMTPSetup.Get;
                Clear(CodeunitEmailMessage);
                PostedPayHeader.SetRange("No.", "No.");
                PosPayLine.Reset;
                PosPayLine.SetRange("Document No.", "No.");
                PosPayLine.SetFilter("Employee No.", EmpFilter);
                PosPayLine.SetFilter("Global Dimension 2 Code", BranchCode);

                if PosPayLine.Find('-') then
                    repeat
                        Clear(Body);
                        Clear(Header);
                        Clear(Footer);
                        Employee.Get(PosPayLine."Employee No.");
                        EmailTemplate.Reset;
                        EmailTemplate.SetRange("Sub Type", "Email Sub Type"::Payroll);

                        if EmailTemplate.FindFirst then begin
                            if CheckValidEmailAddress(Employee."Company E-Mail") then begin
                                if Confirm('Invalid email of employee %1. Do you want to skip it?', false, Employee."Full Name") then
                                    break
                                else
                                    Error('');
                            end;
                            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Employee."Company E-Mail", EmailTemplate.Subject + ' ' + Format("Nepali Month") + ',' + Format("Nepali Year"), '', true);
                            CodeunitEmailMessage.Create(Employee."Company E-Mail", EmailTemplate.Subject, ' ', true);
                            EmailMessage.Reset;
                            EmailMessage.SetRange("Template Code", EmailTemplate.Code);

                            if EmailMessage.Find('-') then
                                repeat
                                    case EmailMessage.Type of

                                        EmailMessage.Type::Header:
                                            begin
                                                Header :=
                                                    StrSubstNo(
                                                        EmailMessage."Body Message",
                                                        Employee."Full Name"
                                                    );
                                            end;

                                        EmailMessage.Type::Body:
                                            begin
                                                Body :=
                                                    StrSubstNo(
                                                        EmailMessage."Body Message",
                                                        Format("Nepali Month"),
                                                        Format("Nepali Year")
                                                    );
                                            end;

                                        EmailMessage.Type::Footer:
                                            begin
                                                if Footer = '' then
                                                    Footer := EmailMessage."Body Message"
                                                else
                                                    Footer := Footer + '<br>' + EmailMessage."Body Message";
                                            end;
                                    end;
                                until EmailMessage.Next = 0;
                            CodeunitEmailMessage.AppendToBody(Header);
                            CodeunitEmailMessage.AppendToBody('<br><br>');
                            CodeunitEmailMessage.AppendToBody(Body);
                            CodeunitEmailMessage.AppendToBody('<br><br>');
                            CodeunitEmailMessage.AppendToBody(Footer);
                            CodeunitEmailMessage.AppendToBody('<br><br>');
                            // Generate and attach payslip PDF
                            Clear(PaySlip);
                            PaySlip.SetEmployeeFilter(PosPayLine."Employee No.");
                            PaySlip.SetTableView(PostedPayHeader);
                            // FilePath := ThreeTierMgt.ClientTempFileName('pdf');//+'\Salary Slip.pdf';
                            //FilePath := 'D:\Salary slip.pdf';
                            recRef.GetTable(PostedPayHeader);
                            tmpBlob.CreateOutStream(OutStr);
                            Report.SaveAs(Report::"Payroll Payslip", '', format::Pdf, OutStr, recRef);
                            // PaySlip.SaveAsPdf(FilePath);
                            tmpBlob.CreateInStream(InStr);
                            CodeunitEmailMessage.AddAttachment('Payslip.pdf', 'application/pdf', InStr);
                            // CodeunitEmailMessage.AddAttachment(FilePath, 'salary slip.pdf');
                            if Email.Send(CodeunitEmailMessage) then;
                            Clear(FilePath);
                        end;
                    until PosPayLine.Next = 0;
                Message('Mail has been sent.');
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
        // SMTPSetup: Record "SMTP Mail Setup";
        // SMTPMail: Codeunit "SMTP Mail";
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

        if (EmailAddress = '') or (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then
            exit(true);

        for i := 1 to StrLen(EmailAddress) do begin
            if EmailAddress[i] = '@' then
                NoOfAtSigns := NoOfAtSigns + 1
            else
                if EmailAddress[i] = ' ' then
                    exit(true)
        end;

        if NoOfAtSigns <> 1 then
            exit(true);
    end;

    procedure SetYearMonth(Year: Integer; Month: Enum "Nepali Month")
    begin
        YearFilter := Year;
        MonthFilter := Month;
    end;
}