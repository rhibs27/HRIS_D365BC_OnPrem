report 50135 "Extra Mileage EMail Send"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(SendEmailToBranch; SendEmailToBranch)
                {
                    Caption = 'Send Email To Branch';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Send Email To Branch field.';
                }
                field(SendEmailToProvince; SendEmailToProvince)
                {
                    Caption = 'Send Email To Province';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Send Email To Province field.';
                }
                field(SendEmailToSubProvince; SendEmailToSubProvince)
                {
                    Caption = 'Send Email To Sub Province';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Send Email To Sub Province field.';
                }
                field(SendEmailToDepartmentHead; SendEmailToDepartmentHead)
                {
                    Caption = 'Send Email To Department Head';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Send Email To Department Head field.';
                }
                field(SendEmailToEcosystemHead; SendEmailToEcosystemHead)
                {
                    Caption = 'Send Email To Ecosystem Head';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Send Email To Ecosystem Head field.';
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        //MESSAGE('Success')
    end;

    trigger OnPreReport()
    begin
        SendMailExtraMileage;
    end;

    var
        EmployeeRec: Record Employee;
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Agile Email Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Filename: Text;
        ExtraMileageReport: Report "Extra Working Hour Report";
        SendEmailToBranch: Boolean;
        SendEmailToProvince: Boolean;
        SendEmailToSubProvince: Boolean;
        Colon: Label ' : ';
        SendEmailToDepartmentHead: Boolean;
        SendEmailToEcosystemHead: Boolean;
        EmailReceipent: Record "Agile Email Recipient";
        EmailReceipentRec: Record "Agile Email Recipient";
        EmailText: Text;
    // Department: Record Department;

    local procedure SendMailExtraMileage()
    var
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        format: ReportFormat;
        tmpBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        recRef: RecordRef;
        Recipients: List of [Text];
        cc: List of [Text];
        bcc: List of [Text];
        InStr: InStream;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(InStr);
        Clear(OutStr);
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        EmployeeRec.Reset;
        EmployeeRec.SetRange(Status, EmployeeRec.Status::Active);
        if SendEmailToBranch then
            EmployeeRec.SetFilter("Functional Title", 'BM|OBM')
        // else if SendEmailToProvince then
        //     EmployeeRec.SetRange(COPO, true)
        else if SendEmailToSubProvince then
            EmployeeRec.SetFilter("Functional Title", 'COSPO|COSPOMN');
        // else if SendEmailToDepartmentHead then
        //     EmployeeRec.SetRange("Department Head", true)
        // else if SendEmailToEcosystemHead then
        //     EmployeeRec.SetRange("Chief Of Eco-System", true);
        if EmployeeRec.FindFirst then
            repeat
                Clear(ExtraMileageReport);
                if EmailTemplate.Get(HRSetup."Attendance Email") then begin
                    Clear(Footer);
                    Clear(Header);
                    Clear(Body);
                    CodeunitEmailMessage.Create(EmployeeRec."Company E-Mail", EmailTemplate.Subject, '');
                    // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", EmployeeRec."Company E-Mail", EmailTemplate.Subject, '', true);
                    EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                    if EmailMessage.FindFirst then
                        repeat
                            case EmailMessage.Type of
                                EmailMessage.Type::Header:
                                    Header := Header + EmailMessage."Body Message";
                                EmailMessage.Type::Body:
                                    Body := Body + EmailMessage."Body Message";
                                EmailMessage.Type::Footer:
                                    Footer := Footer + EmailMessage."Body Message";
                            end;
                        until EmailMessage.Next = 0;
                    CodeunitEmailMessage.AppendToBody(Header);
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                    CodeunitEmailMessage.AppendToBody(Body);
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                    if SendEmailToProvince then begin
                        ExtraMileageReport.PassProvinceEmailSend(EmployeeRec."Province Code");
                        CodeunitEmailMessage.AppendToBody(EmployeeRec.FieldCaption("Province Name") + Colon + EmployeeRec."Province Name");
                    end else if SendEmailToBranch then begin
                        ExtraMileageReport.PassBranchEmailSend(EmployeeRec."Global Dimension 1 Code");
                        CodeunitEmailMessage.AppendToBody(EmployeeRec.FieldCaption("Branch Name") + Colon + EmployeeRec."Branch Name");
                        // end else if SendEmailToSubProvince then begin
                        //     ExtraMileageReport.PassSubProvinceEmailSend(EmployeeRec."Sub Province Code");
                        //     CodeunitEmailMessage.AppendToBody(EmployeeRec.FieldCaption("Sub Province Name") + Colon + EmployeeRec."Sub Province Name");
                    end else if SendEmailToDepartmentHead then begin
                        ExtraMileageReport.PassDepartmentEmailSend(EmployeeRec."Department Code");
                        CodeunitEmailMessage.AppendToBody(EmployeeRec.FieldCaption("Department Name") + Colon + EmployeeRec."Department Name");
                    end;
                    // else if SendEmailToEcosystemHead then begin
                    //     ExtraMileageReport.PassEcoSystemEmailSend(EmployeeRec."Eco-System");
                    //     Department.Get(EmployeeRec."Department Code");
                    //     CodeunitEmailMessage.AppendToBody('Eco-System Name' + Colon + Department."Eco-System Description");
                    // end;
                    CodeunitEmailMessage.AppendToBody('<br><br>');
                    CodeunitEmailMessage.AppendToBody(Footer);
                    if SendEmailToProvince then begin
                        EmailReceipent.Reset();
                        EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
                        EmailReceipent.SetRange("Province Code", EmployeeRec."Province Code");
                        EmailReceipent.SetRange("Recipient Type", EmailReceipent."Recipient Type"::"To");
                        if EmailReceipent.FindFirst then
                            repeat
                                Recipients.Add(EmailReceipent."Email Recipients");
                            until EmailReceipent.Next = 0;

                        EmailReceipentRec.Reset;
                        EmailReceipentRec.SetRange("Email Template Code", EmailTemplate.Code);
                        EmailReceipentRec.SetFilter("Province Code", '');
                        EmailReceipentRec.SetRange("Recipient Type", EmailReceipentRec."Recipient Type"::Cc);
                        if EmailReceipentRec.FindFirst then
                            repeat
                                cc.Add(EmailReceipentRec."Email Recipients");
                            until EmailReceipentRec.Next = 0;
                    end;
                    Clear(EmailText);
                    EmailText := CreateGuid;
                    EmailText := DelChr(EmailText, '=', '{}-01');
                    EmailText := CopyStr(EmailText, 5, 4);
                    Filename := StrSubstNo('C:/ExtraWorkingHour/%1.pdf', EmployeeRec."No." + '_' + EmailText);
                    recRef.GetTable(EmployeeRec);
                    tmpBlob.CreateOutStream(OutStr);
                    Report.SaveAs(Report::"Extra Working Hour Report", '', format::Pdf, OutStr, recRef);
                    // ExtraMileageReport.SaveAsPdf(Filename);
                    tmpBlob.CreateInStream(InStr);
                    CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
                    // CodeunitEmailMessage.AddAttachment(Filename, 'ExtraWorkingHourReport.pdf');
                    CodeunitEmailMessage.Create(Recipients, EmailTemplate.Subject, '', false, cc, bcc);
                    if Email.Send(CodeunitEmailMessage) then
                        Message('Successfully Sent')
                    else
                        Message('Not Sent');
                end;
            until EmployeeRec.Next = 0;
    end;
    //COPO001|DPAECOPOOR|DPAE/COPO|CRAEDPAEIR
}
