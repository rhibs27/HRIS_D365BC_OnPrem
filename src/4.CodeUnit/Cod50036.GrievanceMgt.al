codeunit 50036 "Grievance Mgt"
{
    procedure OpenGrievanceRequest(EmpCode: Code[20]): Text
    var
        Grievance, Grievance2 : Record "Grievance Header";
        AlreadyOpen: Label 'This employee already has an open grievance. Click Ok to open it.';
    begin
        Grievance.Reset();
        Grievance.SetRange("Employee No.", EmpCode);
        Grievance.SetFilter("Approval Status", '%1|%2', Grievance."Approval Status"::" ", Grievance."Approval Status"::Open);
        if Grievance.FindFirst() then begin
            if GuiAllowed then begin
                Message(AlreadyOpen);
                Page.Run(Page::"Grievance Card", Grievance);
                exit;
            end else
                Error('You Already have OpenGrievanceRequest %1', Grievance."No.");
        end;
        Grievance2.Init();
        Grievance2.Validate("Employee No.", EmpCode);
        Grievance2.Validate("Approval Status", Grievance2."Approval Status"::Open);
        Grievance2.Validate("Grievance Date", Today);
        Grievance2.Insert(true);
        if GuiAllowed then
            Page.Run(Page::"Grievance Card", Grievance2)
        else
            exit(Grievance2."No.")
    end;

    procedure SubmitGrievance(var Grievance: Record "Grievance Header"): Boolean
    var
        ConfirmSubmit: Label 'Do you want to submit this grievance for review?';
        SubmitSuccess: Label 'Grievance has been submitted for HR review.';
    begin
        if GuiAllowed then
            if not Confirm(ConfirmSubmit, false) then
                exit;
        if not Grievance.Anonymous then
            Grievance.TestField("Employee No.");
        Grievance.TestField("Subject Code");
        Grievance.TestField(Description);
        Grievance.Validate("Approval Status", "Approval Status"::Submitted);
        Grievance.Modify(true);
        AddComment(Grievance."No.", 'Grievance submitted for review.', Grievance.Anonymous);
        SendGrievanceNotificationEmail(Grievance);
        if GuiAllowed then begin
            Message(SubmitSuccess);
        end;
        exit(true);
    end;

    procedure ApproveGrievance(var Grievance: Record "Grievance Header")
    var
        AlreadyResolved: Label 'This grievance has already been resolved.';
    begin
        if Grievance."Approval Status" = Grievance."Approval Status"::Settled then
            Error(AlreadyResolved);
        AddComment(Grievance."No.", 'Grievance approved and resolved.', false);
        Grievance.TestField("HR Remarks");
        Grievance.Validate("Approval Status", "Approval Status"::Settled);
        if Grievance."Resolution Date" = 0D then
            Grievance.Validate("Resolution Date", Today);
        Grievance.Validate("Resolved By", HRMgt.GetEmployeeNo());
        Grievance.Modify(true);
    end;

    procedure RejectGrievance(var Grievance: Record "Grievance Header")
    var
        AlreadyRejected: Label 'This grievance has already been rejected.';
    begin
        if Grievance."Approval Status" = Grievance."Approval Status"::Rejected then
            Error(AlreadyRejected);
        Grievance.TestField("Rejection Remarks");
        Grievance.Validate("Approval Status", "Approval Status"::Rejected);
        Grievance.Modify(true);
        AddComment(Grievance."No.", StrSubstNo('Grievance rejected. Reason: %1', Grievance."Rejection Remarks"), false);
    end;

    procedure WithdrawGrievance(var Grievance: Record "Grievance Header"): Boolean
    var
        CannotWithdraw: Label 'Only grievances in submitted status can be withdrawn.';
        WithdrawSuccess: Label 'Grievance withdrawn';
    begin
        if not (Grievance."Approval Status" in [Grievance."Approval Status"::" ", Grievance."Approval Status"::Submitted]) then
            Error(CannotWithdraw);
        Grievance.Validate("Approval Status", "Approval Status"::Withdrawn);
        Grievance.Modify(true);
        AddComment(Grievance."No.", 'Grievance withdrawn by employee.', Grievance.Anonymous);
        if GuiAllowed then
            Message(WithdrawSuccess);
        exit(true);
    end;

    procedure AddComment(GrievanceNo: Code[20]; CommentText: Text[2000]; IsAnonymous: Boolean)
    var
        GrievanceComment: Record "Grievance Comment";
        GrievanceHeader: Record "Grievance Header";
        EmpNo: Code[20];
    begin
        if CommentText = '' then
            Error('Add Comment text First.');
        if GrievanceHeader.Get(GrievanceNo) then
            if GrievanceHeader."Approval Status" = GrievanceHeader."Approval Status"::Settled then
                Error('Grievance is already settled.');
        EmpNo := HRMgt.GetEmployeeNo();
        GrievanceComment.Init();
        GrievanceComment.Validate("Grievance No.", GrievanceNo);
        if not IsAnonymous then
            GrievanceComment.Validate("Commented By", HRMgt.GetEmployeeNo())
        else begin
            Clear(GrievanceComment.SystemCreatedBy);
            Clear(GrievanceComment.SystemModifiedBy);
            GrievanceComment.Validate("Commented By", '')
        end;
        GrievanceComment.Validate("Comment Date", CurrentDateTime);
        GrievanceComment.Comment := CommentText;
        GrievanceComment.Insert(true);
    end;

    procedure CheckOpenGrievance(EmpNo: Code[20]): Boolean
    var
        Grievance: Record "Grievance Header";
    begin
        Grievance.Reset();
        Grievance.SetRange("Employee No.", EmpNo);
        Grievance.SetFilter("Approval Status", '%1|%2', Grievance."Approval Status"::" ", Grievance."Approval Status"::Open);
        exit(not Grievance.IsEmpty);
    end;

    procedure LookupEmployee(): Text[500]
    var
        Employee: Record Employee;
        EmployeePage: Page "Employee List";
        EmailIDs: Text;
    begin
        Clear(Employee);
        Clear(EmployeePage);
        EmployeePage.SetRecord(Employee);
        EmployeePage.SetTableView(Employee);
        EmployeePage.LookupMode(true);
        if EmployeePage.RunModal = ACTION::LookupOK then begin
            EmployeePage.SetSelectionFilter(Employee);
            if Employee.FindSet() then begin
                repeat
                    if EmailIDs <> '' then
                        EmailIDs += ';';
                    EmailIDs += Employee."Company E-Mail";
                until Employee.Next() = 0;
            end;
            exit(EmailIDs);
        end;
    end;

    procedure SendGrievanceNotificationEmail(GrievanceHeader: Record "Grievance Header"): Boolean
    var
        EmailTemplate: Record "Email Template";
        EmailTemplateMessage: Record "Email Template Message";
        EmailTemplateRecipient: Record "Email Template Recipient";
        Employee: Record Employee;
        EmailBody: Text;
        EmailSubject: Text;
        Recipients: Text;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
    begin
        EmailTemplate.Reset();
        EmailTemplate.SetRange("Document Type", EmailTemplate."Document Type"::Grievance);
        if not EmailTemplate.FindFirst() then
            Error('Email template is not configured.');

        if not GrievanceHeader.Anonymous then
            if not (Employee.Get(GrievanceHeader."Employee No.")) then
                Error('Employee %1 not found.', GrievanceHeader."Employee No.");

        // Build email subject
        EmailSubject := EmailTemplate.Subject;
        EmailSubject := StrSubstNo(EmailSubject, GrievanceHeader."No.", GrievanceHeader."Employee Name");

        // Build HTML email body with visually appealing format
        EmailBody := BuildGrievanceEmailBody(GrievanceHeader, EmailTemplate);
        if not GrievanceHeader.Anonymous then
            Recipients := GetGrievanceEmailRecipients(GrievanceHeader."Subject Code", GrievanceHeader."Employee No.")
        else
            Recipients := GetGrievanceEmailRecipients(GrievanceHeader."Subject Code", '');

        if Recipients = '' then
            Error('No email recipients configured for grievance with %1 as subject.', GrievanceHeader."Subject Desc");

        // Create and send email
        EmailMessage.Create(Recipients, EmailSubject, EmailBody, true);
        if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            LogGrievanceEmailError(GrievanceHeader."No.", EmailSubject, Recipients, GrievanceHeader.Anonymous);
            exit(false);
        end;

        // Log successful email send
        LogGrievanceEmailSuccess(GrievanceHeader."No.", EmailSubject, Recipients, GrievanceHeader.Anonymous);
        exit(true);
    end;

    local procedure BuildGrievanceEmailBody(GrievanceHeader: Record "Grievance Header"; EmailTemplate: Record "Email Template"): Text
    var
        EmailBody: Text;
        Employee: Record Employee;
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        if Employee.Get(GrievanceHeader."Employee No.") then;

        // Build HTML email with professional styling
        EmailBody := '<html>';
        EmailBody += '<head>';
        EmailBody += '<style>';
        EmailBody += 'body { font-family: "Segoe UI", Arial, sans-serif; line-height: 1.6; color: #333; }';
        EmailBody += '.container { max-width: 600px; margin: 0 auto; }';
        EmailBody += '.header { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); color:  #333; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }';
        EmailBody += '.header h1 { margin: 0; font-size: 24px; }';
        EmailBody += '.header p { margin: 5px 0 0 0; font-size: 14px; opacity: 0.9; }';
        EmailBody += '.content { background: #f9f9f9; padding: 30px; border-left: 4px solid #2a5298; }';
        EmailBody += '.section { margin-bottom: 25px; }';
        EmailBody += '.section-title { background: #2a5298; color: white; padding: 10px 15px; font-weight: bold; margin-bottom: 15px; border-radius: 4px; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }';
        EmailBody += '.section-content { background: white; padding: 15px; border-radius: 4px; }';
        EmailBody += '.field-row { display: flex; margin-bottom: 12px; }';
        EmailBody += '.field-label { font-weight: bold; color: #1e3c72; min-width: 150px; }';
        EmailBody += '.field-value { color: #555; flex: 1; word-break: break-word; }';
        EmailBody += '.status { padding: 8px 12px; border-radius: 4px; display: inline-block; font-size: 12px; font-weight: bold; }';
        EmailBody += '.status-open { background-color: #fff3cd; color: #856404; }';
        EmailBody += '.status-submitted { background-color: #cce5ff; color: #004085; }';
        EmailBody += '.status-settled { background-color: #d4edda; color: #155724; }';
        EmailBody += '.status-rejected { background-color: #f8d7da; color: #721c24; }';
        EmailBody += '.divider { border-top: 1px solid #ddd; margin: 20px 0; }';
        EmailBody += '.footer { background: #f0f0f0; padding: 15px; text-align: center; font-size: 12px; color: #666; border-radius: 0 0 8px 8px; }';
        EmailBody += '.footer p { margin: 5px 0; }';
        EmailBody += '.button { display: inline-block; background: #2a5298; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; font-weight: bold; margin-top: 10px; }';
        EmailBody += '.priority-high { color: #dc3545; font-weight: bold; }';
        EmailBody += '.priority-medium { color: #fd7e14; font-weight: bold; }';
        EmailBody += '.priority-low { color: #28a745; font-weight: bold; }';
        EmailBody += '.description-box { background: #f5f5f5; padding: 12px; border-left: 3px solid #2a5298; margin-top: 10px; border-radius: 3px; white-space: pre-wrap; word-wrap: break-word; }';
        EmailBody += '</style>';
        EmailBody += '</head>';
        EmailBody += '<body>';
        EmailBody += '<div class="container">';

        // Header
        EmailBody += '<div class="header">';
        EmailBody += '<h1>Grievance Management System</h1>';
        EmailBody += StrSubstNo('<p>%1</p>', CompanyInfo.Name);
        EmailBody += '</div>';

        // Main Content
        EmailBody += '<div class="content">';

        // Greeting
        if not GrievanceHeader.Anonymous then
            EmailBody += StrSubstNo('<p>Dear <strong>%1</strong>,</p>', Employee."Full Name");
        EmailBody += '<p>The grievance has been received and registered in our system. Below are the details of your grievance:</p>';

        // Grievance Details Section
        EmailBody += '<div class="section">';
        EmailBody += '<div class="section-title">Grievance Details</div>';
        EmailBody += '<div class="section-content">';
        EmailBody += '<div class="field-row">';
        EmailBody += StrSubstNo('<div class="field-label">Grievance No.:</div><div class="field-value"><strong>%1</strong></div>', GrievanceHeader."No.");
        EmailBody += '</div>';
        EmailBody += '<div class="field-row">';
        EmailBody += StrSubstNo('<div class="field-label">Grievance Date:</div><div class="field-value">%1</div>', Format(GrievanceHeader."Grievance Date", 0, '<Day>, <Month text>, <Year4>'));
        EmailBody += '</div>';
        EmailBody += '<div class="field-row">';
        EmailBody += StrSubstNo('<div class="field-label">Subject:</div><div class="field-value">%1</div>', GrievanceHeader."Subject Desc");
        EmailBody += '</div>';
        EmailBody += '<div class="field-row">';
        EmailBody += '<div class="field-label">Status:</div>';
        EmailBody += '<div class="field-value">';
        EmailBody += GetStatusBadgeHTML(GrievanceHeader."Approval Status");
        EmailBody += '</div>';
        EmailBody += '</div>';
        EmailBody += '<div class="field-row">';
        EmailBody += StrSubstNo('<div class="field-label">Priority:</div><div class="field-value"><span class="priority-%1">%2</span></div>',
            GetPriorityClass(GrievanceHeader.Priority), Format(GrievanceHeader.Priority));
        EmailBody += '</div>';
        EmailBody += '</div>';
        EmailBody += '</div>';

        // Grievance Description
        EmailBody += '<div class="section">';
        EmailBody += '<div class="section-title"> Description</div>';
        EmailBody += '<div class="section-content">';
        EmailBody += StrSubstNo('<div class="description-box">%1</div>', GrievanceHeader.Description);
        EmailBody += '</div>';
        EmailBody += '</div>';

        // Additional Information
        if GrievanceHeader."Against Employee No." <> '' then begin
            EmailBody += '<div class="section">';
            EmailBody += '<div class="section-title">Against Employee</div>';
            EmailBody += '<div class="section-content">';
            EmailBody += '<div class="field-row">';
            EmailBody += StrSubstNo('<div class="field-label">Name:</div><div class="field-value">%1</div>', GrievanceHeader."Against Employee Name");
            EmailBody += '</div>';
            EmailBody += '</div>';
            EmailBody += '</div>';
        end;

        // Next Steps
        EmailBody += '<div class="section">';
        EmailBody += '<div class="section-title">Next Steps</div>';
        EmailBody += '<div class="section-content">';
        EmailBody += '<p>The grievance will be reviewed by the HR department within the stipulated timeframe based on its priority. You will be notified of any updates or actions taken regarding your grievance.</p>';
        EmailBody += '<p><strong>What to expect:</strong></p>';
        EmailBody += '<ul>';
        EmailBody += '<li>Initial review by HR department</li>';
        EmailBody += '<li>Investigation if required</li>';
        EmailBody += '<li>Resolution or further action</li>';
        EmailBody += '</ul>';
        EmailBody += '</div>';
        EmailBody += '</div>';

        // Support Section
        EmailBody += '<div class="section">';
        EmailBody += '<div class="section-title">Need Help?</div>';
        EmailBody += '<div class="section-content">';
        EmailBody += '<p>If you have any questions or need to provide additional information, please contact the HR department.</p>';
        EmailBody += '</div>';
        EmailBody += '</div>';

        EmailBody += '</div>';

        // Footer
        EmailBody += '<div class="footer">';
        EmailBody += '<p><strong>This is an automated message</strong></p>';
        EmailBody += StrSubstNo('<p>Sent on: %1</p>', Format(CurrentDateTime, 0, '<Day>, <Month text>, <Year4> at <Hours24>:<Minutes>:<Seconds>'));
        EmailBody += '<p>Please do not reply to this email. Contact HR for assistance.</p>';
        EmailBody += StrSubstNo('<p>© %1</p>', CompanyInfo.Name);
        EmailBody += '</div>';

        EmailBody += '</div>';
        EmailBody += '</body>';
        EmailBody += '</html>';

        exit(EmailBody);
    end;

    local procedure GetStatusBadgeHTML(Status: Enum "Approval Status"): Text
    var
        StatusHTML: Text;
    begin
        case Status of
            Status::" ":
                StatusHTML := '<span class="status status-open">● DRAFT</span>';
            Status::Open:
                StatusHTML := '<span class="status status-open">● OPEN</span>';
            Status::Submitted:
                StatusHTML := '<span class="status status-submitted">● SUBMITTED</span>';
            Status::Settled:
                StatusHTML := '<span class="status status-settled">✓ RESOLVED</span>';
            Status::Rejected:
                StatusHTML := '<span class="status status-rejected">✕ REJECTED</span>';
            Status::Withdrawn:
                StatusHTML := '<span class="status status-open">↶ WITHDRAWN</span>';
            else
                StatusHTML := '<span class="status">PENDING</span>';
        end;
        exit(StatusHTML);
    end;

    local procedure GetPriorityClass(Priority: Enum "Grievance Priority"): Text
    begin
        case Priority of
            Priority::P1:
                exit('high');
            Priority::P2:
                exit('medium');
            Priority::P3:
                exit('low');
            else
                exit('medium');
        end;
    end;

    local procedure GetGrievanceEmailRecipients(SubjectCode: Code[20]; EmployeeNo: Code[20]): Text
    var
        GrievanceCategories: Record "Grievance Category";
        Employee: Record Employee;
        Recipients: Text;
    begin
        Clear(Recipients);

        if Employee.Get(EmployeeNo) and (Employee."Company E-Mail" <> '') then
            Recipients += Employee."Company E-Mail" + ';';

        GrievanceCategories.Reset();
        GrievanceCategories.SetRange(Code, SubjectCode);
        if GrievanceCategories.FindFirst() then
            Recipients += GrievanceCategories."Email IDs";

        exit(Recipients);
    end;

    local procedure LogGrievanceEmailSuccess(GrievanceNo: Code[20]; EmailSubject: Text; Recipients: Text; IsAnonymous: Boolean)
    begin
        AddComment(GrievanceNo, StrSubstNo('Email notification sent successfully. Subject: %1', EmailSubject), IsAnonymous);
    end;

    local procedure LogGrievanceEmailError(GrievanceNo: Code[20]; EmailSubject: Text; Recipients: Text; IsAnonymous: Boolean)
    var
        GrievanceComment: Record "Grievance Comment";
    begin
        AddComment(GrievanceNo, StrSubstNo('Email notification FAILED. Subject: %1.', EmailSubject), IsAnonymous);
    end;

    procedure GenerateUserFriendlyToken(): Text
    var
        RawGuid: Text;
        CleanGuid: Text;
        Token: Text;
    begin
        RawGuid := Format(CreateGuid());
        CleanGuid := UpperCase(DelChr(RawGuid, '=', '{}-')); // 32 hex chars

        // Format as XXXXXXXXXXXX (12 chars + 2 dashes)
        Token := CopyStr(CleanGuid, 1, 4) + '-' +
                 CopyStr(CleanGuid, 5, 4) + '-' +
                 CopyStr(CleanGuid, 9, 4);

        exit(Token); // e.g. A3F9-C2E1-B847
    end;

    procedure GenerateAnonymousToken(var GrievanceRec: Record "Grievance Header"; UserPIN: Text): Text
    var
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        PlainToken: Text;
        TokenHash: Text;
    begin
        if StrLen(UserPIN) < 6 then
            Error('PIN should not be less than 6 characters.');
        PlainToken := UserPIN + CopyStr(GrievanceRec."No.", 10, 5); //GenerateUserFriendlyToken();

        TokenHash := CryptographyMgmt.GenerateHash(PlainToken, HashAlgorithmType::SHA256);

        GrievanceRec."Grievance Token Hash" := TokenHash;
        GrievanceRec.Modify(true);

        exit(PlainToken); // Returned once to show the user, never stored
    end;

    procedure ValidateTokenAndGetGrievance(InputToken: Text; var GrievanceRec: Record "Grievance Header"): Boolean
    var
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        InputHash: Text;
        NormalizedToken: Text;
    begin

        NormalizedToken := InputToken;

        // Normalize: uppercase and strip any spaces the user may have typed
        // NormalizedToken := UpperCase(DelChr(InputToken, '=', ' '));

        // Re-add dashes if user typed without them e.g. "A3F9C2E1B847"
        // if StrLen(NormalizedToken) = 12 then
        //     NormalizedToken := CopyStr(NormalizedToken, 1, 4) + '-' +
        //                        CopyStr(NormalizedToken, 5, 4) + '-' +
        //                        CopyStr(NormalizedToken, 9, 4);

        InputHash := CryptographyMgmt.GenerateHash(NormalizedToken, HashAlgorithmType::SHA256);

        GrievanceRec.Reset();
        GrievanceRec.SetRange(Anonymous, true);
        GrievanceRec.SetRange("Grievance Token Hash", InputHash);

        exit(GrievanceRec.FindFirst());
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        CryptographyMgmt: Codeunit "Cryptography Management";
}

