report 50057 "Mail for Payroll"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Posted Payroll Header"; "Posted Payroll Header")
        {
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
                if DocumentProfile = DocumentProfile::"Posted Payroll" then begin
                    //  IF PostedPayHeader.GET(DocumentNo) THEN;
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
                            EmailTemplate.SetRange("Document Profile", DocumentProfile);
                            if EmailTemplate.FindFirst then begin
                                if CheckValidEmailAddress(Employee."Company E-Mail") then begin
                                    if Confirm('Invalid email of employee %1. Do you want to skip it?', false, Employee."Full Name") then
                                        break
                                    else
                                        Error('');
                                end;
                                // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Employee."Company E-Mail", EmailTemplate.Subject + ' ' + Format("Nepali Month") + ',' + Format("Nepali Year"), '', true);
                                CodeunitEmailMessage.Create(Employee."Company E-Mail", EmailTemplate.Subject, ' ');
                                EmailMessage.Reset;
                                EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                                if EmailMessage.Find('-') then
                                    repeat
                                        case EmailMessage.Type of
                                            EmailMessage.Type::Header:
                                                begin
                                                    Header += EmailMessage."Body Message";
                                                end;

                                            EmailMessage.Type::Body:
                                                begin
                                                    Body += EmailMessage."Body Message" + ' ' + Format("Nepali Month") + ',' + Format("Nepali Year");
                                                end;
                                            EmailMessage.Type::Footer:
                                                begin
                                                    Footer += EmailMessage."Body Message" + '<br>';
                                                end;
                                        end;
                                    until EmailMessage.Next = 0;
                                CodeunitEmailMessage.AppendToBody(Header);
                                CodeunitEmailMessage.AppendToBody('<br><br>');
                                CodeunitEmailMessage.AppendToBody(Body);
                                CodeunitEmailMessage.AppendToBody('<br><br>');
                                Clear(PaySlip);
                                PaySlip.SetEmployeeFilter(PosPayLine."Employee No.");
                                PaySlip.SetTableView(PostedPayHeader);
                                // FilePath := ThreeTierMgt.ClientTempFileName('pdf');//+'\Salary Slip.pdf';
                                FilePath := 'D:\Salary slip.pdf';
                                recRef.GetTable(PostedPayHeader);
                                tmpBlob.CreateOutStream(OutStr);
                                Report.SaveAs(Report::"Payroll Payslip", '', format::Pdf, OutStr, recRef);

                                // PaySlip.SaveAsPdf(FilePath);
                                tmpBlob.CreateInStream(InStr);
                                CodeunitEmailMessage.AddAttachment(FilePath, '.pdf', InStr);
                                // CodeunitEmailMessage.AddAttachment(FilePath, 'salary slip.pdf');
                                CodeunitEmailMessage.AppendToBody(Footer);
                                if Email.Send(CodeunitEmailMessage) then;
                                Clear(FilePath);
                            end;
                        until PosPayLine.Next = 0;
                end;
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
        DocumentProfile := DocumentProfile::"Posted Payroll";
    end;

    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        // SMTPMail: Codeunit "SMTP Mail";
        EmailTemplate: Record "Email Template";
        Footer: Text;
        Header: Text;
        Body: Text;
        EmailMessage: Record "Agile Email Message";
        Employee: Record Employee;
        PosPayLine: Record "Posted Payroll Line";
        PostedPayHeader: Record "Posted Payroll Header";
        PaySlip: Report "Payroll Payslip";
        FilePath: Text;
        DocumentProfile: Option " ","Employee Actvity","Posted Payroll";
        EmpFilter: Text;
        BranchCode: Code[20];

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
}
