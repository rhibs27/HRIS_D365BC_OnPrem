codeunit 50035 "Email Mgt"
{
    var
        CodeunitEmailMessage: Codeunit "Email Message";
        CompanyInfo: Record "Company Information";
        Colon: Label ' : ';
        Email: Codeunit Email;
        Leave: Record Leave;
        AttendanceMissed: Record "Attendance Missed";
        Employee: Record Employee;
        TravelRequest: Record "Travel Request";
        Overtime: Record OverTime;
        MedicalInsuranceClaim: Record "Medical Insurance Claim";
        Resignation: Record Resignation;
        Employee1: Record Employee;
        EmpLoan: Record "Employee Loan/Advance";
        HRSetup: Record "Human Resources Setup";
        EmployeeTransfer: Record "Employee Transfer";
        loanMgt: Codeunit "Loan Mgt.";
        EngNep: Record "English-Nepali Date";
        EmployeeActivityJournal: Record "Employee Activity Journal";
        PRSetup: Record "Payroll General Setup";
        HrMgt: Codeunit "HR Mgt.";


    procedure ResignationEmailSend(EmployeeNo: Code[20])
    var
        EmpRec: Record Employee;
        EmailMessage: Record "Email Template Message";
        EmailReceipientText: Text;
        ListEmailReceipientText: List of [Text];
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
        EmailReceipent: Record "Email Template Recipient";
        EmailReceipentRec: Record "Email Template Recipient";
        EmailccReceipientText: List of [Text];
        EmailbccReceipientText: List of [Text];
    begin
        HRSetup.Get;
        clear(CodeunitEmailMessage);
        CompanyInfo.Get;
        if EmpRec.Get(EmployeeNo) then begin
            EmailReceipientText := EmpRec."Company E-Mail";
            EmailTemplate.Reset;
            EmailTemplate.SetRange(Code, HRSetup."Resignation Submit Email Temp");
            if EmailTemplate.FindFirst then begin
                Clear(Footer);
                Clear(Header);
                Clear(Body);
                CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, '');
                EmailMessage.Reset;
                EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                if EmailMessage.FindFirst then
                    repeat
                        case EmailMessage.Type of
                            EmailMessage.Type::Header:
                                Header := Header + EmailMessage."Body Message" + '<br>';
                            EmailMessage.Type::Body:
                                Body := Body + EmailMessage."Body Message" + '<br>';
                            EmailMessage.Type::Footer:
                                Footer := Footer + EmailMessage."Body Message" + '<br>';
                        end;
                    until EmailMessage.Next = 0;
            end;
            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Body);
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Full Name") + Colon + EmpRec."Full Name");
            CodeunitEmailMessage.AppendToBody(', ');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("No.") + Colon + EmpRec."No.");
            CodeunitEmailMessage.AppendToBody(', ');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Province Code") + Colon + EmpRec."Province Code");
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);
            EmailReceipent.Reset;
            EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipent.SetRange("Province Code", EmpRec."Province Code");
            EmailReceipent.SetRange("Recipient Type", EmailReceipent."Recipient Type"::"To");
            if EmailReceipent.FindFirst then
                repeat
                    ListEmailReceipientText.Add(EmailReceipent."Email Recipients");
                until EmailReceipent.Next = 0;
            EmailReceipentRec.Reset;
            EmailReceipentRec.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipentRec.SetFilter("Province Code", '');
            EmailReceipentRec.SetRange("Recipient Type", EmailReceipentRec."Recipient Type"::Cc);
            if EmailReceipentRec.FindFirst then
                repeat
                    EmailccReceipientText.Add(EmailReceipentRec."Email Recipients");
                until EmailReceipentRec.Next = 0;
            CodeunitEmailMessage.Create(ListEmailReceipientText, EmailTemplate.Subject, '', true, EmailccReceipientText, EmailbccReceipientText);
            Email.send(CodeunitEmailMessage);
        end;
    end;
    //Email
    procedure GetEmailTemplate(var Header: Text; Var Body: text; var Footer: text; var Disclaimer: text; TemplateCode: Code[20])
    var
        EmailMessage: Record "Email Template Message";
    begin
        EmailMessage.Reset;
        EmailMessage.SetRange("Template Code", TemplateCode);
        if EmailMessage.FindFirst then
            repeat
                case EmailMessage.Type of
                    EmailMessage.Type::Header:
                        Header := Header + EmailMessage."Body Message" + '<br>';
                    EmailMessage.Type::Body:
                        Body := Body + EmailMessage."Body Message" + '<br>';
                    EmailMessage.Type::Footer:
                        Footer := Footer + EmailMessage."Body Message" + '<br>';
                    EmailMessage.Type::Disclaimer:
                        Disclaimer := Disclaimer + EmailMessage."Body Message" + '<br>';
                end;
            until EmailMessage.Next = 0;
    end;

    procedure GetEmailReceipent(DocumentNo: Code[20]; DocumentType: Enum "Employee Activity Type"; DocumentStatus: Enum "Approval Status"; var EmailReceipientText: List of [Text]; var EmailCCReceipent: List of [Text]; var EmailBCCReceipent: List of [Text]; TemplateCode: Code[20])
    var
        EmailReceipent: Record "Email Template Recipient";
        ApprovalHRMS: Record "Approval HRMS";
        Employee: Record Employee;
        IsHandled: Boolean;
    begin
        case DocumentType of
            DocumentType::"Candiadte offer letter":
                begin
                    EmailReceipent.Reset;
                    EmailReceipent.SetRange("Email Template Code", TemplateCode);
                    if EmailReceipent.FindFirst then
                        repeat
                            if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" then
                                EmailReceipientText.Add(EmailReceipent."Email Recipients");
                            if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Bcc then
                                EmailBCCReceipent.Add(EmailReceipent."Email Recipients");
                            if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Cc then
                                EmailCCReceipent.Add(EmailReceipent."Email Recipients");
                        until EmailReceipent.Next = 0;
                end;
            DocumentType::"Leave Request", DocumentType::"Travel Request", DocumentType::"Attendance Missed":
                begin
                    case DocumentStatus of
                        DocumentStatus::Pending:
                            begin
                                ApprovalHRMS.Reset();
                                ApprovalHRMS.SetRange("Document No.", DocumentNo);
                                ApprovalHRMS.SetRange("Approval Status", ApprovalHRMS."Approval Status"::Open);
                                if ApprovalHRMS.FindSet() then
                                    repeat
                                        if Employee.Get(ApprovalHRMS."Approver No") then begin
                                            CheckForSkipMail(Employee, IsHandled);
                                            if not IsHandled then
                                                EmailReceipientText.Add(Employee."Company E-Mail");
                                        end;
                                    until ApprovalHRMS.Next() = 0;
                            end;
                        DocumentStatus::Approved, DocumentStatus::Rejected:
                            begin
                                ApprovalHRMS.Reset();
                                ApprovalHRMS.SetRange("Document No.", DocumentNo);
                                if ApprovalHRMS.Findfirst() then begin
                                    if Employee.Get(ApprovalHRMS."Employee No") then
                                        EmailReceipientText.Add(Employee."Company E-Mail");
                                end;
                            end;
                    end;
                end;
            DocumentType::Loan:
                begin
                    case DocumentStatus of
                        DocumentStatus::Pending:
                            begin
                                EmailReceipent.SetRange("Email Template Code", TemplateCode);
                                if EmailReceipent.FindSet() then
                                    repeat
                                        if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" then
                                            EmailReceipientText.Add(EmailReceipent."Email Recipients");
                                        if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Bcc then
                                            EmailBCCReceipent.Add(EmailReceipent."Email Recipients");
                                        if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Cc then
                                            EmailCCReceipent.Add(EmailReceipent."Email Recipients");
                                    until EmailReceipent.next = 0;
                                ApprovalHRMS.SetRange("Document No.", DocumentNo);
                                ApprovalHRMS.SetRange("Approval Status", ApprovalHRMS."Approval Status"::Open);
                                if ApprovalHRMS.FindFirst() then begin
                                    Employee.Get(ApprovalHRMS."Approver No");
                                    Employee.TestField("Company E-Mail");
                                    EmailReceipientText.add(Employee."Company E-Mail");
                                end;

                            end;
                        DocumentStatus::Approved, DocumentStatus::Rejected:
                            begin
                                EmailReceipent.SetRange("Email Template Code", TemplateCode);
                                if EmailReceipent.FindSet() then
                                    repeat
                                        if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" then
                                            EmailReceipientText.Add(EmailReceipent."Email Recipients");
                                        if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Bcc then
                                            EmailBCCReceipent.Add(EmailReceipent."Email Recipients");
                                        if EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::Cc then
                                            EmailCCReceipent.Add(EmailReceipent."Email Recipients");
                                    until EmailReceipent.next = 0;
                                ApprovalHRMS.Reset();
                                ApprovalHRMS.SetRange("Document No.", DocumentNo);
                                if ApprovalHRMS.Findfirst() then begin
                                    if Employee.Get(ApprovalHRMS."Employee No") then begin
                                        Employee.TestField("Company E-Mail");
                                        EmailReceipientText.Add(Employee."Company E-Mail");
                                    end;
                                end;
                            end;
                    end;
                end;
        end;
    end;

    procedure SendMailFromTemplate(TableNo: Integer;
            DocumentType:
                enum "Employee Activity Type";
            ApprovalStatus:
                Enum "approval status";
            EmployeeNo:
                Text;
            DocumentNo:
                Code[20];
            Cancelled:
                Boolean)
    var
        EmailTemplate: Record "Email Template";
        Header, Footer, Body, Disclaimer : text;
        JournalDocumentType: Label 'Document Type';
        EmailReceipientText: List of [Text];
        EmailCCReceipent: List of [Text];
        EmailBCCReceipent: List of [Text];
        AddEmailReceipentFromTemplate, IsHandled : Boolean;
        AllowanceBodyText: Label '<br>The allowance assignment from %1 Branch/Extension Counter for the week %2 of month %3 has not been recorded till date.<br>Request you to assign it till EOD.<br>';
        CalcuationDate: Date;
        Week: Integer;
        ApprovalHRMS: Record "Approval HRMS";
        SalaryLevel: Record "Salary Level";
        EmployeeVar: Record Employee;
    begin
        OnBeforeCreateEmailFromTemplate(TableNo, DocumentType, ApprovalStatus, EmployeeNo, DocumentNo, Cancelled, IsHandled);
        if IsHandled then
            exit;
        Clear(EmailReceipientText);
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        if ApprovalStatus = ApprovalStatus::Pending then
            Employee.Get(EmployeeNo);
        EmailTemplate.Reset;
        EmailTemplate.SetRange("Document Type", DocumentType);
        EmailTemplate.SetRange("Approval Status", ApprovalStatus);
        if (EmailTemplate.FindFirst) and (not Cancelled) then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            GetEmailTemplate(Header, Body, Footer, Disclaimer, EmailTemplate.Code);
            GetEmailReceipent(DocumentNo, DocumentType, ApprovalStatus, EmailReceipientText, EmailCCReceipent, EmailBCCReceipent, EmailTemplate.Code);
            if EmailReceipientText.Count = 0 then
                exit;
            CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, CodeunitEmailMessage.GetBody(), true, EmailCCReceipent, EmailBCCReceipent);
            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(body);
            CodeunitEmailMessage.AppendToBody('<br>');
            case TableNo of
                DATABASE::Leave:
                    begin
                        if DocumentType = DocumentType::"Leave Request" then begin
                            if Leave.Get(DocumentNo) then;
                            CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Employee No.") + Colon + Format(Leave."Employee No.") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Employee Name") + Colon + Format(Leave."Employee Name") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Leave Type") + Colon + Format(Leave."Leave Description") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Start Date") + Colon + Format(Leave."Start Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("End Date") + Colon + Format(Leave."End Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("No. of Days") + Colon + Format(Leave."No. of Days") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Leave.FieldCaption(Remarks) + Colon + Format(Leave.Remarks) + '<br>');
                            if ApprovalStatus = ApprovalStatus::Rejected then
                                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Rejection Remarks") + Colon + Format(Leave."Rejection Remarks") + '<br>');
                        end;
                    end;
                Database::"Attendance Missed":
                    begin
                        if DocumentType = DocumentType::"Attendance Missed" then begin
                            if AttendanceMissed.Get(DocumentNo) then;
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Employee No.") + Colon + Format(AttendanceMissed."Employee No.") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Employee Name") + Colon + Format(AttendanceMissed."Employee Name") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Start Date") + Colon + Format(AttendanceMissed."Start Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Previous Check In Time") + Colon + Format(AttendanceMissed."Previous Check In Time") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Previous Check Out Time") + Colon + Format(AttendanceMissed."Previous Check Out Time") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Check In Time") + Colon + Format(AttendanceMissed."Check In Time") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Check Out Time") + Colon + Format(AttendanceMissed."Check Out Time") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Checkout OverNight") + Colon + Format(AttendanceMissed."Checkout OverNight") + '<br>');
                            CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption(Remarks) + Colon + Format(AttendanceMissed.Remarks) + '<br>');
                            if ApprovalStatus = ApprovalStatus::Rejected then
                                CodeunitEmailMessage.AppendToBody(AttendanceMissed.FieldCaption("Rejection Remarks") + Colon + Format(AttendanceMissed."Rejection Remarks") + '<br>');
                        end;
                    end;
                DATABASE::"Travel Request":
                    begin
                        if DocumentType = DocumentType::"Travel Request" then begin
                            TravelRequest.Get(DocumentNo);
                            AddEmailReceipentFromTemplate := (TravelRequest."Advance Cash Required") and (ApprovalStatus = ApprovalStatus::Approved);
                            if TravelRequest."Travel Order No." <> '' then
                                CodeunitEmailMessage.AppendToBody('Extension of ' + TravelRequest.FieldCaption("Travel Order No.") + Colon + TravelRequest."Travel Order No." + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Employee No.") + Colon + Format(TravelRequest."Employee No.") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Type Of Visit") + Colon + Format(TravelRequest."Type Of Visit") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Start Date") + Colon + Format(TravelRequest."Start Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("End Date") + Colon + Format(TravelRequest."End Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("No. of Days") + Colon + Format(TravelRequest."No. of Days") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption(Destination) + Colon + TravelRequest.Destination + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Purpose of Travel") + Colon + TravelRequest."Purpose of Travel" + '<br>');
                            if AddEmailReceipentFromTemplate then begin
                                CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Advance Cash") + Colon + Format(TravelRequest."Advance Cash") + '<br>');
                                CodeunitEmailMessage.AppendToBody(Employee.FieldCaption("Bank Account No.") + Colon + TravelRequest."Auth. Account No." + '<br>');
                            end;
                        end else if DocumentType = DocumentType::"Travel Claim" then begin
                            TravelRequest.Get(DocumentNo);
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Employee No.") + Colon + Format(TravelRequest."Employee No.") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Type Of Visit") + Colon + Format(TravelRequest."Type Of Visit") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Start Date") + Colon + Format(TravelRequest."Start Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("End Date") + Colon + Format(TravelRequest."End Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("No. of Days") + Colon + Format(TravelRequest."No. of Days") + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption(Destination) + Colon + TravelRequest.Destination + '<br>');
                            CodeunitEmailMessage.AppendToBody(TravelRequest.FieldCaption("Purpose of Travel") + Colon + TravelRequest."Purpose of Travel" + '<br>');
                        end;
                    end;
                Database::OverTime:
                    begin
                        if DocumentType = DocumentType::Overtime then begin
                            Overtime.Get(DocumentNo);
                            CodeunitEmailMessage.AppendToBody(Overtime.FieldCaption("Employee No.") + Colon + Format(Overtime."Employee No.") + '<br>');
                            CodeunitEmailMessage.AppendToBody('Date ' + Colon + Format(Overtime."Start Date") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Overtime.FieldCaption("Check In Time") + format(Overtime."Check In Time") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Overtime.FieldCaption("Check Out Time") + format(Overtime."Check Out Time") + '<br>');
                            CodeunitEmailMessage.AppendToBody(Overtime.FieldCaption("Check Out Time") + format(Overtime."Check Out Time") + '<br>');
                            CodeunitEmailMessage.AppendToBody('Purpose ' + Colon + Format(Overtime.Remarks) + '<br>');
                        end;
                    end;
                Database::"Employee Transfer":
                    begin
                        if DocumentType = DocumentType::"Employee Transfer" then begin
                            EmployeeTransfer.Get(DocumentNo);
                            GetTransferBody(EmployeeTransfer);
                        end;
                    end;
                DATABASE::"Employee Loan/Advance":
                    begin
                        if EmpLoan.Get(DocumentNo) then begin
                            SalaryLevel.Get(EmpLoan."Salary Level");
                            EmployeeVar.Get(EmpLoan."Employee No.");
                            CodeunitEmailMessage.AppendToBody(EmpLoan.FieldCaption("Requested Date") + Colon + Format(EmpLoan."Requested Date", 0, '<Day,2>/<Month,2>/<Year4>') + '<br>');
                            CodeunitEmailMessage.AppendToBody(EmpLoan.FieldCaption("Employee No.") + Colon + Format(EmpLoan."Employee No.") + '<br>');
                            CodeunitEmailMessage.AppendToBody(EmpLoan.FieldCaption("Employee Name") + Colon + Format(EmpLoan."Employee Name") + '<br>');
                            CodeunitEmailMessage.AppendToBody('Designation' + Colon + Format(SalaryLevel.Description) + '<br>');
                            CodeunitEmailMessage.AppendToBody('Working Office' + Colon + Format(EmpLoan."Branch Name") + '<br>');
                            CodeunitEmailMessage.AppendToBody(EmpLoan.FieldCaption("Purpose of Advance Salary") + Colon + Format(EmpLoan."Purpose of Advance Salary") + '<br>');
                            CodeunitEmailMessage.AppendToBody(EmpLoan.FieldCaption("Applied Loan/Advance") + Colon + Format(EmpLoan."Applied Loan/Advance") + '<br>');
                            CodeunitEmailMessage.AppendToBody('Bank A/C' + Colon + Format(EmpLoan."Account No.") + '<br>');
                            if ApprovalStatus = ApprovalStatus::Rejected then
                                CodeunitEmailMessage.AppendToBody(EmpLoan.FieldCaption("Rejection Remark") + Colon + Format(EmpLoan."Rejection Remark") + '<br>');
                            loanMgt.GetLoanBody(EmpLoan);
                        end;
                    end;
                Database::Resignation:
                    begin
                        if DocumentType = DocumentType::Resignation then begin
                            CodeunitEmailMessage.AppendToBody(StrSubstNo('Please approve document for resignation of employee %1(%2)', Resignation."Employee No.", Resignation."Employee Name"));
                        end;
                    end;
                Database::"Medical Insurance Claim":
                    begin
                        if DocumentType = DocumentType::"Medical Insurance Claim" then begin
                            MedicalInsuranceClaim.Get(DocumentNo);
                            CodeunitEmailMessage.AppendToBody(MedicalInsuranceClaim.FieldCaption("Employee No.") + Colon + Format(MedicalInsuranceClaim."Employee No.") + '<br>');
                            CodeunitEmailMessage.AppendToBody('Medical Claim No' + Colon + Format(DocumentNo));
                            CodeunitEmailMessage.AppendToBody('Claim Option' + Colon + Format(MedicalInsuranceClaim."Insurance Claim"));
                            CodeunitEmailMessage.AppendToBody('Claim forwarded to Insurance Company Date' + Colon);
                            CodeunitEmailMessage.AppendToBody('Amount received from Insurance Company Date' + Colon);
                            CodeunitEmailMessage.AppendToBody('Insurance Amount Reimbursed Date' + Colon);
                            CodeunitEmailMessage.AppendToBody('Total Amount Reimbursed Date' + Colon);
                            CodeunitEmailMessage.AppendToBody('Reason for variation in claim amount' + Colon);
                        end;
                    end;
                DATABASE::"Allowance Assignment Header":
                    begin
                        PRSetup.Get;
                        EngNep.Reset;
                        EngNep.SetRange("English Date", Today - PRSetup."Allowance Email Days");
                        if EngNep.FindFirst then
                            CalcuationDate := CalcDate('-CM', Today - PRSetup."Allowance Email Days");
                        Week := Round(((Today - PRSetup."Allowance Email Days" - CalcuationDate) + 1) / 7, 1, '>');
                        if Week > 4 then
                            Week := 4;
                        if Body <> '' then begin
                            CodeunitEmailMessage.AppendToBody(Body);
                            CodeunitEmailMessage.AppendToBody('<br><br>');
                        end;
                        CodeunitEmailMessage.AppendToBody(StrSubstNo(AllowanceBodyText, Week, EngNep."English Month"));
                        CodeunitEmailMessage.AppendToBody('<br><br>');
                    end;
                DATABASE::"Employee Activity Journal":
                    begin
                        if EmployeeActivityJournal.Get(DocumentNo) then
                            if EmployeeActivityJournal."Employee Act Type" = EmployeeActivityJournal."Employee Act Type"::"Leave Request" then begin
                                CodeunitEmailMessage.AppendToBody(JournalDocumentType + Colon + Format(EmployeeActivityJournal."Employee Act Type") + '<br>');
                                CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption("Employee No.") + Colon + Format(EmployeeActivityJournal."Employee No.") + '<br>');
                                CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption("Employee Name") + Colon + Format(EmployeeActivityJournal."Employee Name") + '<br>');
                                CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption("Leave Type") + Colon + Format(EmployeeActivityJournal."Leave Description") + '<br>');
                                CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption("Start Date") + Colon + Format(EmployeeActivityJournal."Start Date") + '<br>');
                                CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption("End Date") + Colon + Format(EmployeeActivityJournal."End Date") + '<br>');
                                CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption("No. of Days") + Colon + Format(EmployeeActivityJournal."No. of Days") + '<br>');
                                CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption(Remarks) + Colon + Format(EmployeeActivityJournal.Remarks) + '<br>');
                                if ApprovalStatus = ApprovalStatus::Rejected then
                                    CodeunitEmailMessage.AppendToBody(EmployeeActivityJournal.FieldCaption("Rejection Remarks") + Colon + Format(EmployeeActivityJournal."Rejection Remarks") + '<br>');
                            end;
                    end;
            end;
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(Footer);
            if ApprovalStatus = ApprovalStatus::Pending then
                CodeunitEmailMessage.AppendToBody(Format(Employee."Full Name"))
            else if ApprovalStatus in [ApprovalStatus::Rejected, ApprovalStatus::Approved] then
                CodeunitEmailMessage.AppendToBody(Format(EmployeeNo));
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(Disclaimer);
            if not ((EmailReceipientText.Count = 1) and (EmailReceipientText.Get(1) = '')) then
                Email.Send(CodeunitEmailMessage);
        end;
    end;

    procedure SendLeaveFromTemplate(DocumentType: enum "Employee Activity Type";
            ApprovalStatus:
                Enum "approval status";
            EmployeeNo:
                Text;
            DocumentNo:
                Code[20];
            Leave:
                Record leave)
    var
        Colon: Label ' : ';
        EmailTemplate: Record "Email Template";
        Header, Footer, Body, Disclaimer : text;
        Email: Codeunit Email;
        CodeunitEmailMessage: Codeunit "Email Message";
        EmailReceipientText: List of [Text];
        EmailCCReceipent: List of [Text];
        EmailBCCReceipent: List of [Text];
    begin
        Clear(EmailReceipientText);
        Clear(CodeunitEmailMessage);
        EmailTemplate.Reset;
        EmailTemplate.SetRange("Document Type", DocumentType);
        EmailTemplate.SetRange("Approval Status", ApprovalStatus);
        if EmailTemplate.FindFirst then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            GetEmailTemplate(Header, Body, Footer, Disclaimer, EmailTemplate.Code);
            GetEmailReceipent(DocumentNo, DocumentType, ApprovalStatus, EmailReceipientText, EmailCCReceipent, EmailBCCReceipent, EmailTemplate.Code);
            CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, CodeunitEmailMessage.GetBody(), true, EmailCCReceipent, EmailBCCReceipent);
            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(body);
            CodeunitEmailMessage.AppendToBody('<br>');
            if DocumentType = DocumentType::"Leave Request" then begin
                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Employee No.") + Colon + Format(Leave."Employee No.") + '<br>');
                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Employee Name") + Colon + Format(Leave."Employee Name") + '<br>');
                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Leave Type") + Colon + Format(Leave."Leave Description") + '<br>');
                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("Start Date") + Colon + Format(Leave."Start Date") + '<br>');
                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("End Date") + Colon + Format(Leave."End Date") + '<br>');
                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption("No. of Days") + Colon + Format(Leave."No. of Days") + '<br>');
                CodeunitEmailMessage.AppendToBody(Leave.FieldCaption(Remarks) + Colon + Format(Leave.Remarks) + '<br>');
            end;
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(Footer);
            if ApprovalStatus = ApprovalStatus::Pending then
                CodeunitEmailMessage.AppendToBody(Format(Employee."Full Name"));
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(Disclaimer);
            Email.Send(CodeunitEmailMessage);
        end;
    end;

    procedure SendResignEmailFromTemplate(DocumentType: enum "Employee Activity Type"; ApprovalStatus: Enum "approval status"; EmployeeNo: Text; DocumentNo: Code[20]; Resignation: Record Resignation)
    var
        Colon: Label ' : ';
        EmailTemplate: Record "Email Template";
        Header, Footer, Body, Disclaimer : text;
        Email: Codeunit Email;
        CodeunitEmailMessage: Codeunit "Email Message";
        EmailReceipientText: List of [Text];
        EmailCCReceipent: List of [Text];
        EmailBCCReceipent: List of [Text];
    begin
        Clear(EmailReceipientText);
        Clear(CodeunitEmailMessage);
        EmailTemplate.Reset;
        EmailTemplate.SetRange("Document Type", DocumentType);
        EmailTemplate.SetRange("Approval Status", ApprovalStatus);
        if EmailTemplate.FindFirst then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            GetEmailTemplate(Header, Body, Footer, Disclaimer, EmailTemplate.Code);
            GetEmailReceipent(DocumentNo, DocumentType, ApprovalStatus, EmailReceipientText, EmailCCReceipent, EmailBCCReceipent, EmailTemplate.Code);
            CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, CodeunitEmailMessage.GetBody(), true, EmailCCReceipent, EmailBCCReceipent);
            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(body);
            CodeunitEmailMessage.AppendToBody('<br>');
            if DocumentType = DocumentType::Resignation then begin
                CodeunitEmailMessage.AppendToBody(Resignation.FieldCaption("Employee No.") + Colon + Format(Resignation."Employee No.") + '<br>');
                CodeunitEmailMessage.AppendToBody(Resignation.FieldCaption("Employee Name") + Colon + Format(Resignation."Employee Name") + '<br>');
                CodeunitEmailMessage.AppendToBody(Resignation.FieldCaption("Requested Last Working Day") + Colon + Format(Resignation."Employee Name") + '<br>');
                CodeunitEmailMessage.AppendToBody(Resignation.FieldCaption("Reason for Resignation") + Colon + Format(Resignation."Employee Name") + '<br>');
            end;
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(Footer);
            if ApprovalStatus = ApprovalStatus::Pending then
                CodeunitEmailMessage.AppendToBody(Format(Employee."Full Name"));
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(Disclaimer);
            Email.Send(CodeunitEmailMessage);
        end;
    end;

    local procedure GetTransferBody(var EmployeeTransfer: Record "Employee Transfer")
    var
        BodyText1: Text;
        ProvinceVar: Record Province;
        GLSetup: Record "General Ledger Setup";
        OrganizationStructureList: Record "Organization Structure List";
        FunctionalTitle: Record "Functional Title";
        Email: Codeunit Email;
        CodeunitEmailMessage: Codeunit "Email Message";
    begin
        GLSetup.Get;
        //Outgoing Placement
        //CodeunitEmailMessage.AppendToBody(FIELDCAPTION("Employee No.") + Colon + "Employee No." + '<br>');
        CodeunitEmailMessage.AppendToBody(EmployeeTransfer.FieldCaption("Employee Name") + Colon + EmployeeTransfer."Employee Name" + '<br>');
        CodeunitEmailMessage.AppendToBody(EmployeeTransfer.FieldCaption("Transfer Effective Date") + Colon + HrMgt.getDateinFormat(EmployeeTransfer."Transfer Effective Date") + '<br>');
        CodeunitEmailMessage.AppendToBody(EmployeeTransfer.FieldCaption("Transfer Category") + Colon + Format(EmployeeTransfer."Transfer Category") + '<br>');
        if (EmployeeTransfer."Start Date" <> 0D) and (EmployeeTransfer."End Date" <> 0D) then begin //Min 12.9.2022 -- for cover general transfer
            CodeunitEmailMessage.AppendToBody(EmployeeTransfer.FieldCaption("Start Date") + Colon + Format(EmployeeTransfer."Start Date") + '<br>');
            CodeunitEmailMessage.AppendToBody(EmployeeTransfer.FieldCaption("End Date") + Colon + Format(EmployeeTransfer."End Date") + '<br>');
        end;
        /*IF EmployeeActivity."Transfer Category" IN
          [EmployeeActivity."Transfer Category"::Officiating,EmployeeActivity."Transfer Category"::"Temporary"] THEN begin
          CodeunitEmailMessage.AppendToBody(FIELDCAPTION("Start Date") + Colon + FORMAT("Start Date") +'<br>');
          CodeunitEmailMessage.AppendToBody(FIELDCAPTION("End Date") + Colon + FORMAT("End Date") +'<br>');
        end;*/
        CodeunitEmailMessage.AppendToBody('<br><br>' + 'Current Placement ' + Colon + '<br>');
        CodeunitEmailMessage.AppendToBody('Deputation on' + Colon + Format(EmployeeTransfer."Deputation On") + '<br>');
        Clear(OrganizationStructureList);
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::"Extension Counter", EmployeeTransfer."Extension Counter Code") then
            CodeunitEmailMessage.AppendToBody('Extension Counter' + Colon + OrganizationStructureList.Name + '<br>');
        // EmpHie.SetRange(Code, EmployeeActivity."Extension Counter Code");
        // if EmpHie.FindFirst then
        // Clear(DimValue);
        if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, EmployeeTransfer."Shortcut Dimension 1 Code") then
            CodeunitEmailMessage.AppendToBody('Branch' + Colon + OrganizationStructureList.Name + '<br>');
        // Clear(SubProvinceVar);
        // SubProvinceVar.SetRange(Code, EmployeeActivity."Sub Province Code");
        // if SubProvinceVar.FindFirst then
        //     CodeunitEmailMessage.AppendToBody('Sub Province' + Colon + SubProvinceVar.City + '<br>');
        // Clear(EmpHie);
        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::Unit);
        // EmpHie.SetRange(Code, EmployeeActivity."Unit Code");
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::unit, EmployeeTransfer."Unit Code") then
            CodeunitEmailMessage.AppendToBody('Unit' + Colon + OrganizationStructureList.Name + '<br>');
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::Department, EmployeeTransfer.Department) then
            CodeunitEmailMessage.AppendToBody('Department' + Colon + OrganizationStructureList.Name + '<br>');
        Clear(ProvinceVar);
        if ProvinceVar.Get(EmployeeTransfer."Province Code") then
            CodeunitEmailMessage.AppendToBody('Province' + Colon + ProvinceVar.Description + '<br>');
        Clear(FunctionalTitle);
        if FunctionalTitle.Get(EmployeeTransfer."Functional Title") then
            CodeunitEmailMessage.AppendToBody('Functional Title' + Colon + FunctionalTitle.Description + '<br><br>');
        CodeunitEmailMessage.AppendToBody('Current Reporting Person<br>');
        Clear(Employee1);
        if Employee1.Get(EmployeeTransfer."Outgoing Branch Rep. Person") then begin
            CodeunitEmailMessage.AppendToBody('Employee Name ' + Colon + Employee1."Full Name" + '<br>');
            CodeunitEmailMessage.AppendToBody('Employee No. ' + Colon + Employee1."No." + '<br>');
            Clear(FunctionalTitle);
            if FunctionalTitle.Get(Employee1."Functional Title") then
                CodeunitEmailMessage.AppendToBody('Functional title ' + Colon + FunctionalTitle.Description + '<br>');
        end;
        //Incoming Placement
        CodeunitEmailMessage.AppendToBody('<br>' + 'Reporting Placement ' + Colon + '<br>');
        CodeunitEmailMessage.AppendToBody('Deputation on' + Colon + Format(EmployeeTransfer."Deputation On (To)") + '<br>');
        // Clear(EmpHie);
        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        // EmpHie.SetRange(Code, EmployeeActivity."Extension Counter (To)");
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::"Extension Counter", EmployeeTransfer."Extension Counter (To)") then
            CodeunitEmailMessage.AppendToBody('Extension Counter' + Colon + OrganizationStructureList.Name + '<br>');
        // Clear(DimValue);
        // if DimValue.Get(GLSetup."Global Dimension 1 Code", EmployeeActivity."Shortcut Dimension 1 Code (To)") then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::Branch, EmployeeTransfer."Shortcut Dimension 1 Code (To)") then
            CodeunitEmailMessage.AppendToBody('Branch' + Colon + OrganizationStructureList.Name + '<br>');
        // Clear(SubProvinceVar);
        // SubProvinceVar.SetRange(Code, EmployeeActivity."Sub Province Code (To)");
        // if SubProvinceVar.FindFirst then
        //     CodeunitEmailMessage.AppendToBody('Sub Province' + Colon + SubProvinceVar.City + '<br>');
        // Clear(EmpHie);
        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::Unit);
        // EmpHie.SetRange(Code, EmployeeActivity."Unit (To)");
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::unit, EmployeeTransfer."Unit (To)") then
            CodeunitEmailMessage.AppendToBody('Unit' + Colon + OrganizationStructureList.Name + '<br>');
        // Clear(Depart);
        // if Depart.Get(EmployeeActivity."Department Code (To)") then
        // if EmpHie.FindFirst then
        OrganizationStructureList.Reset;
        if OrganizationStructureList.get(OrganizationStructureList.type::Department, EmployeeTransfer."Department Code (To)") then
            CodeunitEmailMessage.AppendToBody('Department' + Colon + OrganizationStructureList.Name + '<br>');
        Clear(ProvinceVar);
        if ProvinceVar.Get(EmployeeTransfer."Province Code (To)") then
            CodeunitEmailMessage.AppendToBody('Province' + Colon + ProvinceVar.Description + '<br>');
        Clear(FunctionalTitle);
        if FunctionalTitle.Get(EmployeeTransfer."Functional Title (To)") then
            CodeunitEmailMessage.AppendToBody('Functional Title' + Colon + FunctionalTitle.Description + '<br><br>');
        CodeunitEmailMessage.AppendToBody('Incoming Reporting Person<br>');
        Clear(Employee1);
        if Employee1.Get(EmployeeTransfer."Incoming Supervisior") then begin
            CodeunitEmailMessage.AppendToBody('Employee Name ' + Colon + Employee1."Full Name" + '<br>');
            CodeunitEmailMessage.AppendToBody('Employee No. ' + Colon + Employee1."No." + '<br>');
            Clear(FunctionalTitle);
            if FunctionalTitle.Get(Employee1."Functional Title") then
                CodeunitEmailMessage.AppendToBody('Functional title ' + Colon + FunctionalTitle.Description + '<br>');
        end;
    end;

    procedure CreateNewLine(): Text
    begin
        CodeunitEmailMessage.AppendToBody('<br><br>');
    end;

    procedure ResignationRejectEmailSend(EmployeeNo: Code[20])
    var
        EmpRec: Record Employee;
        EmailMessage: Record "Email Template Message";
        EmailReceipientText: Text;
        ListEmailReceipientText: List of [Text];
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
        EmailReceipent: Record "Email Template Recipient";
        EmailReceipentRec: Record "Email Template Recipient";
        cc: List of [Text];
        bcc: List of [Text];
    begin
        HRSetup.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        CompanyInfo.Get;
        if EmpRec.Get(EmployeeNo) then begin
            EmailReceipientText := EmpRec."Company E-Mail";
            EmailTemplate.Reset;
            EmailTemplate.SetRange(Code, HRSetup."Resignation Reject Email Temp");
            if EmailTemplate.FindFirst then begin
                Clear(Footer);
                Clear(Header);
                Clear(Body);
                // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", EmailReceipientText, EmailTemplate.Subject, '', true);
                CodeunitEmailMessage.Create(EmailReceipientText, EmailTemplate.Subject, '');
                EmailMessage.Reset;
                EmailMessage.SetRange("Template Code", EmailTemplate.Code);
                if EmailMessage.FindFirst then
                    repeat
                        case EmailMessage.Type of
                            EmailMessage.Type::Header:
                                Header := Header + EmailMessage."Body Message" + '<br>';
                            EmailMessage.Type::Body:
                                Body := Body + EmailMessage."Body Message" + '<br>';
                            EmailMessage.Type::Footer:
                                Footer := Footer + EmailMessage."Body Message" + '<br>';
                        end;
                    until EmailMessage.Next = 0;
            end;
            CodeunitEmailMessage.AppendToBody(Header);
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Body);
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Full Name") + Colon + EmpRec."Full Name");
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("No.") + Colon + EmpRec."No.");
            CodeunitEmailMessage.AppendToBody('<br>');
            CodeunitEmailMessage.AppendToBody(EmpRec.FieldCaption("Province Code") + Colon + EmpRec."Province Code");
            CodeunitEmailMessage.AppendToBody('<br><br>');
            CodeunitEmailMessage.AppendToBody(Footer);
            EmailReceipent.Reset;
            EmailReceipent.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipent.SetRange("Province Code", EmpRec."Province Code");
            EmailReceipent.SetRange("Recipient Type", EmailReceipent."Recipient Type"::"To");
            if EmailReceipent.FindFirst then
                repeat
                    //IF EmailReceipent."Recipient Type" = EmailReceipent."Recipient Type"::"To" THEN
                    ListEmailReceipientText.Add(EmailReceipent."Email Recipients");
                until EmailReceipent.Next = 0;
            EmailReceipentRec.Reset;
            EmailReceipentRec.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipentRec.SetFilter("Province Code", '');
            EmailReceipentRec.SetRange("Recipient Type", EmailReceipentRec."Recipient Type"::Cc);
            if EmailReceipentRec.FindFirst then
                repeat
                    cc.Add(EmailReceipentRec."Email Recipients");
                    CodeunitEmailMessage.Create(ListEmailReceipientText, EmailTemplate.Subject, '', true, cc, bcc);
                until EmailReceipentRec.Next = 0;
            Email.Send(CodeunitEmailMessage);
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure CheckForSkipMail(Employee: Record Employee; var IsHandled: Boolean);
    begin
        //Can be Used to skp mail for paticular employee
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateEmailFromTemplate(var TableNo: Integer; var DocumentType: enum "Employee Activity Type";
                          var ApprovalStatus: Enum "approval status";
                          var EmployeeNo: Text;
                          var DocumentNo: Code[20];
                          var Cancelled: Boolean;
                          var IsHandled: Boolean);
    begin
        //Can be used to changes or modify any paramater before Create Email From Template
    end;

}
