table 50087 "Selection Commitee"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vacancy Code"; Code[20]) { }
        field(2; "Employee No"; Code[20])
        {
            //TableRelation = Employee where("Selection committee" = const(true));

            trigger OnValidate()
            begin
                Employee.Get("Employee No");
                "Functional Title" := Employee."Functional Title";
                "Salary Level" := Employee."Salary Level";
                "Full Name" := Employee."Full Name";
                Email := Employee."Company E-Mail";
            end;
        }
        field(3; "Salary Level"; Code[20]) { }
        field(4; "Functional Title"; Code[20]) { }
        field(5; "Full Name"; Text[100]) { }
        field(6; Email; Text[100]) { }
        field(7; Approved; Boolean) { }
    }

    keys
    {
        key(Key1; "Vacancy Code", "Employee No") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        VacancyHeader.Get("Vacancy Code");
    end;

    var
        Employee: Record Employee;
        VacancyHeader: Record "Vacancy Header";

    procedure SendMailToSelectionCommitee()
    var
        // SMTPSetup: Record "SMTP Mail Setup";
        // SMTPmail: Codeunit "SMTP Mail";
        SelectionCommitee: Record "Selection Commitee";
        EmailTemplate: Record "Email Template";
        CompanyInfo: Record "Company Information";
        EmailMessage: Record "Email Template Message";
        SendmailTo: Text;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin

        SelectionCommitee.SetRange("Vacancy Code", "Vacancy Code");
        if SelectionCommitee.FindFirst then begin
            repeat
                if SendmailTo = '' then
                    SendmailTo := SelectionCommitee.Email
                else
                    SendmailTo += ';' + SelectionCommitee.Email;
            until SelectionCommitee.Next = 0;
        end;

        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        EmailTemplate.SetRange("Document Type", EmailTemplate."Document Type"::Vacancy);
        EmailTemplate.SetRange("Sub Type", EmailTemplate."Sub Type"::"Selection Committee");
        if EmailTemplate.FindFirst then begin
            // SMTPmail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", SendmailTo, EmailTemplate.Subject, '', true);
            CodeunitEmailMessage.Create(SendmailTo, EmailTemplate.Subject, '');

            EmailMessage.SetRange("Template Code", EmailTemplate.Code);
            if EmailMessage.FindFirst then begin
                EmailMessage.SetRange(Type, EmailMessage.Type::Header);
                if EmailMessage.FindFirst then begin
                    repeat
                        CodeunitEmailMessage.AppendToBody(EmailMessage."Body Message");
                    until EmailMessage.Next = 0;
                end;

                EmailMessage.SetRange(Type, EmailMessage.Type::Body);
                if EmailMessage.FindFirst then begin
                    repeat
                        CodeunitEmailMessage.AppendToBody(EmailMessage."Body Message");
                    until EmailMessage.Next = 0;
                end;

                EmailMessage.SetRange(Type, EmailMessage.Type::Footer);
                if EmailMessage.FindFirst then begin
                    repeat
                        CodeunitEmailMessage.AppendToBody(EmailMessage."Body Message");
                    until EmailMessage.Next = 0;
                end;
            end;
            Email.Send(CodeunitEmailMessage);
        end;
    end;
}
