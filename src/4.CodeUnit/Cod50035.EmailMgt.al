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
        TrainLine: Record "Training Line";
        TrainHead: Record "Training Header";
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
                //training header
                DATABASE::"Training Header":
                    begin
                        TrainHead.Get(DocumentNo);
                        TrainLine.Reset;
                        TrainLine.SetRange("Training No.", TrainHead."No.");
                        TrainLine.SetFilter("Trainer Type", '<>%1', TrainLine."Trainer Type"::External);
                        TrainLine.SetFilter(Type, '<>%1', TrainLine.Type::Vendor);
                        if TrainLine.Find('-') then
                            repeat
                                Employee.Get(TrainLine."Employee Code");
                                Employee.TestField("Company E-Mail");
                                EmailReceipientText.add(Employee."Company E-Mail");
                            until TrainLine.Next = 0;
                        GetTrainingBody(TrainHead);
                    end;
                //vacancy header
                DATABASE::Candidate:
                    begin
                        // EmailReceipientText.add(Candidate."E-Mail");
                        // GetCandidateBody(Candidate);
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

    procedure GetEmailReceipents(TraininNo: Code[20]): Text
    var
        TrainingLine: Record "Training Line";
        ReceipentText: Text;
    begin
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TraininNo);
        TrainingLine.SetRange(Type, TrainingLine.Type::Trainee);
        if TrainingLine.Find('-') then
            repeat
                Employee.Get(TrainingLine."Employee Code");
                if ReceipentText = '' then
                    ReceipentText := Employee."Company E-Mail"
                else
                    ReceipentText += ';' + Employee."Company E-Mail";
            until TrainingLine.Next = 0;
        exit(ReceipentText);
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

    local procedure GetTrainingBody(var TrainHeader: Record "Training Header")
    var
        BodyText1: Text;
        TrainLine: Record "Training Line";
    begin
        BodyText1 := '<table style="width:100%">' +
               '<tr>' +
                 '<td><strong>' + TrainLine.FieldCaption("Employee Name") + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("Trainer Date") + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("Name of Organization") + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("Start Time") + '</strong></td>' +
                 '<td><strong>' + TrainLine.FieldCaption("End Time") + '</strong></td>' +
               '</tr>';
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainHeader."No.");
        TrainLine.SetRange(Type, TrainLine.Type::Trainer);
        if TrainLine.Find('-') then
            repeat
                BodyText1 += '<tr>' +
                                '<td>' + TrainLine."Employee Name" + '</td>' +
                                '<td>' + Format(TrainLine."Trainer Date") + '</td>' +
                                '<td>' + TrainLine."Name of Organization" + '</td>' +
                                '<td>' + Format(TrainLine."Start Time") + '</td>' +
                                '<td>' + Format(TrainLine."End Time") + '</td>' +
                              '</tr>';
            until TrainLine.Next = 0;
        BodyText1 += '</table>';
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption(Description) + Colon + Format(TrainHeader.Description) + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption("Start Date") + Colon + Format(TrainHeader."Start Date") + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption("End Date") + Colon + Format(TrainHeader."End Date") + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption("Start Time") + Colon + Format(TrainHeader."Start Time") + '<br>');
        CodeunitEmailMessage.AppendToBody(TrainHeader.FieldCaption(Venue) + Colon + Format(TrainHeader.Venue) + '<br>');
        CodeunitEmailMessage.AppendToBody('<br>' + BodyText1 + '<br>');
    end;

    local procedure GetTransferBody(var EmployeeTransfer: Record "Employee Transfer")
    var
        BodyText1: Text;
        TrainLine: Record "Training Line";
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

    procedure SendEmailOfferLetter(VacancyCode: Code[20]; Candidate: Record Candidate)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Filename: Text;
        EmailReceipent: List of [Text];
        OfferLetter: Report "Offer Letter2";
        Cand: Record Candidate;
        EmailReceipentRec: Record "Email Template Recipient";
        CC: List of [Text];
        bCC: List of [Text];
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        if EmailTemplate.Get(HRSetup."Offer Letter Sent") then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
            // CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate.Subject, '');nilesh
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
            CodeunitEmailMessage.AppendToBody(Footer);
            EmailReceipentRec.Reset;
            EmailReceipentRec.SetRange("Email Template Code", EmailTemplate.Code);
            EmailReceipentRec.SetRange("Recipient Type", EmailReceipentRec."Recipient Type"::Cc);
            if EmailReceipentRec.FindFirst then
                repeat
                    cc.Add(EmailReceipentRec."Email Recipients");
                until EmailReceipentRec.Next = 0;
            EmailReceipent.add(Candidate."E-Mail");
            CodeunitEmailMessage.Create(EmailReceipent, EmailTemplate.Subject, '', true, CC, bcc);
            if Email.Send(CodeunitEmailMessage) then
                Message('Successfully Sent')
            else
                Message('Not Sent');
        end;
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

    procedure SendAppointmentLetter(VacancyCode: Code[20]; Candidate: Record Candidate)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Filename: Text;
        OfferLetter: Report "Offer Letter2";
        Cand: Record Candidate;
        tmpBlob: Codeunit "Temp Blob";
        recRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        format: ReportFormat;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        Clear(InStr);
        HRSetup.Get;
        //Candidate.Reset;
        //Candidate.SetRange("Vacancy Code",VacancyCode);
        //IF Candidate.GET(CandidateNo) THEN begin
        //IF Candidate.FindFirst() THEN begin
        /*repeat
          IF SendMailTo='' THEN
          SendMailTo+=Interviewer."Interviewer Email"
          ELSE
            SendMailTo+=Interviewer."Interviewer Email"+';'
        until Interviewer.NEXT =0;
        */
        if EmailTemplate.Get(HRSetup."Appointment Letter Sent") then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
            CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate.Subject, '');
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
            CodeunitEmailMessage.AppendToBody(Footer);
            Filename := 'C:\Business Central\Setup\appointmentletter.pdf';
            Cand.Reset;
            Cand.SetRange("No.", Candidate."No.");
            recRef.GetTable(Candidate);
            tmpBlob.CreateOutStream(OutStr);
            REPORT.SaveAs(REPORT::"Appointment Letter", '', format::Pdf, OutStr, recRef);
            tmpBlob.CreateInStream(InStr);
            CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
            //    OfferLetter.SAVEASPDF(Filename);
            // SMTPMail.AddAttachment(Filename, 'appointmentletter.pdf');
            if Email.Send(CodeunitEmailMessage) then
                Message('Successfully Sent')
            else
                Message('Not Sent');
        end;
        //  end;
    end;

    procedure SendOfferLetter(VacancyCode: Code[20]; Candidate: Record Candidate)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Filename: Text;
        OfferLetter: Report "Offer Letter2";
        Cand: Record Candidate;
        tmpBlob: Codeunit "Temp Blob";
        recRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        format: ReportFormat;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        Clear(InStr);
        HRSetup.Get;
        //Candidate.Reset;
        //Candidate.SetRange("Vacancy Code",VacancyCode);
        //IF Candidate.GET(CandidateNo) THEN begin
        //IF Candidate.FindFirst() THEN begin
        /*repeat
          IF SendMailTo='' THEN
          SendMailTo+=Interviewer."Interviewer Email"
          ELSE
            SendMailTo+=Interviewer."Interviewer Email"+';'
        until Interviewer.NEXT =0;
        */
        if EmailTemplate.Get(HRSetup."Offer Letter Sent") then begin
            Clear(Footer);
            Clear(Header);
            Clear(Body);
            // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
            CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate.Subject, '');
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
            CodeunitEmailMessage.AppendToBody(Footer);
            Filename := 'C:\Business Central\Setup\offerletter.pdf';
            Cand.Reset;
            Cand.SetRange("No.", Candidate."No.");
            recRef.GetTable(Candidate);
            tmpBlob.CreateOutStream(OutStr);
            REPORT.SaveAs(REPORT::"Offer Letter", '', format::Pdf, OutStr, recRef);
            tmpBlob.CreateInStream(InStr);
            CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
            //    OfferLetter.SAVEASPDF(Filename);
            // SMTPMail.AddAttachment(Filename, 'offerletter.pdf');
            if Email.send(CodeunitEmailMessage) then
                Message('Successfully Sent')
            else
                Message('Not Sent');
        end;
        //  end;
    end;

    procedure InterviewScheduleEmailToCandidate(VacancyCode: Code[20]; IsReschedule: Boolean)
    var
        Candidate: Record Candidate;
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        CodeunitEmailMessage: Codeunit "Email Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Counter: Integer;
        CCReceipientEmail: List of [Text];
        BCCReciepientEmail: List of [Text];
        Email: Codeunit Email;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        Candidate.Reset;
        Counter := 0;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        if IsReschedule then begin
            HRSetup.TestField("Reschedule Vacancy Mail Cand.");
            EmailTemplate.Get(HRSetup."Reschedule Vacancy Mail Cand.");
        end else begin
            HRSetup.TestField("Interview Schedule Candidate");
            EmailTemplate.Get(HRSetup."Interview Schedule Candidate");
        end;
        if Candidate.FindFirst then
            repeat
                Clear(Footer);
                Clear(Header);
                Clear(Body);
                // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", Candidate."E-Mail", EmailTemplate.Subject, '', true);
                CodeunitEmailMessage.Create(Candidate."E-Mail", EmailTemplate."Subject", '');
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
                CodeunitEmailMessage.AppendToBody(Candidate.FieldCaption("Interview Date") + Colon + Format(Candidate."Interview Date"));
                CodeunitEmailMessage.AppendToBody(Candidate.FieldCaption("Interview Time") + Colon + Format(Candidate."Interview Time"));
                CodeunitEmailMessage.AppendToBody('<br><br>');
                CodeunitEmailMessage.AppendToBody(Footer);
                if Email.Send(CodeunitEmailMessage) then
                    Counter += 1;
            until Candidate.Next = 0;
        if Counter <> 0 then
            Message('Mail Sent');
    end;

    procedure CandidateListmailToInterviewer(VacancyCode: Code[20]; Reschedule: Boolean)
    var
        CompanyInfo: Record "Company Information";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailTemplate: Record "Email Template";
        HRSetup: Record "Human Resources Setup";
        EmailMessage: Record "Email Template Message";
        Header: Text;
        Body: Text;
        Footer: Text;
        Interviewer: Record Interviewer;
        SendMailTo: Text;
        InterviewerEmail: Report "Interviewer Email";
        Filename: Text;
        VacancyHeader: Record "Vacancy Header";
        // FileMgt: Codeunit "File Management";
        Candidate: Record Candidate;
        OutStr: OutStream;
        InStr: InStream;
        TempBlob: Codeunit "Temp Blob";
        // tmpBlob: Codeunit "Temp Blob";
        recRef: RecordRef;
        format: ReportFormat;
        CodeunitEmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        inStreamReport: InStream;
    begin
        CompanyInfo.Get;
        // SMTPSetup.Get;
        Clear(inStreamReport);
        Clear(CodeunitEmailMessage);
        HRSetup.Get;
        VacancyHeader.Get(VacancyCode);
        Candidate.Reset;
        Candidate.SetRange("Vacancy Code", VacancyCode);
        Candidate.SetRange(Status, Candidate.Status::"Interview Scheduled");
        //Filename:='C:\Business Central\Setup\interviewerlist.pdf';
        recRef.GetTable(Candidate);
        TempBlob.CreateOutStream(OutStr);
        Filename := VacancyCode + '.pdf';
        REPORT.SaveAs(REPORT::"Interviewer Email", '', format::Pdf, OutStr, recRef);
        Interviewer.Reset;
        Interviewer.SetRange("Vacancy Code", VacancyCode);
        if Interviewer.FindFirst then
            repeat
                if SendMailTo = '' then
                    SendMailTo += Interviewer."Interviewer Email"
                else
                    SendMailTo += ';' + Interviewer."Interviewer Email";
            until Interviewer.Next = 0;
        if Reschedule then begin
            HRSetup.TestField("ReSchedule Vancacy Mail Int.");
            EmailTemplate.Get(HRSetup."ReSchedule Vancacy Mail Int.");
        end else begin
            HRSetup.TestField("Interview Schedule Interviewer");
            EmailTemplate.Get(HRSetup."Interview Schedule Interviewer");
        end;
        Clear(Footer);
        Clear(Header);
        Clear(Body);
        // SMTPMail.CreateMessage(CompanyInfo.Name, SMTPSetup."User ID", SendMailTo, EmailTemplate.Subject, '', true);
        CodeunitEmailMessage.Create(SendMailTo, EmailTemplate.Subject, '');
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
        CodeunitEmailMessage.AppendToBody(Footer);
        TempBlob.CreateInStream(InStr);
        CodeunitEmailMessage.AddAttachment(Filename, '.pdf', InStr);
        // SMTPMail.AddAttachment(Filename, 'interviewerlist');
        if Email.send(CodeunitEmailMessage) then
            Message('Successfully Sent')
        else
            Message('Not Sent');
        Clear(Filename);
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
