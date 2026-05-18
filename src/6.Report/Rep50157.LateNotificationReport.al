//must check pending attendance update/ attendnace transit update / leave request / travel and training
report 50157 "Late Notification Email"
{
    ApplicationArea = All;
    Caption = 'Late Notification Email';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    var
        Employee: Record Employee;
        EmployeeAttendance: Record "Employee Attendance & Activity";
        EmailsSent: Integer;
        EmployeesProcessed: Integer;
    begin
        // Set default date range if not specified
        if StartDate = 0D then
            StartDate := Today;
        if EndDate = 0D then
            EndDate := Today;
        EmailsSent := 0;
        EmployeesProcessed := 0;
        Employee.SetRange("Status", Employee.Status::Active);
        Employee.SetFilter("Company E-Mail", '<>%1', '');
        if Employee.FindSet() then
            repeat
                EmployeesProcessed += 1;
                EmployeeAttendance.SetRange("Employee No.", Employee."No.");
                EmployeeAttendance.SetRange("Attendance Date", StartDate, EndDate);
                EmployeeAttendance.SetRange("Late Day", 1);
                OnFilterEmployeeAttendance(EmployeeAttendance);
                if EmployeeAttendance.FindSet() then
                    if SendLateNotificationEmail(Employee, EmployeeAttendance, StartDate, EndDate) then
                        EmailsSent += 1;
            until Employee.Next() = 0;

        Message('Late notification email process completed.\Employees Processed: %1\Emails Sent: %2',
            EmployeesProcessed, EmailsSent);
    end;

    local procedure SendLateNotificationEmail(Employee: Record Employee; var EmployeeAttendance: Record "Employee Attendance & Activity"; FromDate: Date; ToDate: Date): Boolean
    var
        EmailAccount: Record "Email Account";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        LateDayCount: Integer;
        EmailBody: Text;
        EmailSubject: Text;
        RecipientEmail: Text;
    begin

        RecipientEmail := Employee."Company E-Mail";
        LateDayCount := EmployeeAttendance.Count;

        //email subject
        EmailSubject := StrSubstNo('Late Attendance Notification - %1 Late Day(s)', LateDayCount);

        //email body with table
        EmailBody := BuildEmailBody(Employee, EmployeeAttendance, FromDate, ToDate, LateDayCount);

        // Create email message
        EmailMessage.Create(RecipientEmail, EmailSubject, EmailBody, true);

        // Send email using the configured email account
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            exit(true)
        else begin
            Message('Failed to send email to %1 (%2). Please check SMTP configuration.', Employee."No.", Employee."Full Name");
            exit(false);
        end;
    end;

    local procedure BuildEmailBody(Employee: Record Employee; var EmployeeAttendance: Record "Employee Attendance & Activity"; FromDate: Date; ToDate: Date; LateDayCount: Integer): Text
    var
        CompanyInfo: Record "Company Information";
        EmailBody: TextBuilder;
        DeputationOn, DeputationOnDesc : Text[100];
        OrgStrucList: Record "Organization Structure List";
    begin
        CompanyInfo.Get();
        DeputationOn := Format(Employee."Deputation on");
        OrgStrucList.Get(Employee."Deputation on", Employee."Deputation On Code");
        DeputationOnDesc := OrgStrucList.Name;

        // Build HTML email
        EmailBody.AppendLine('<!DOCTYPE html>');
        EmailBody.AppendLine('<html>');
        EmailBody.AppendLine('<head>');
        EmailBody.AppendLine('<style>');
        EmailBody.AppendLine('body { font-family: Arial, sans-serif; margin: 20px; }');
        EmailBody.AppendLine('table { border-collapse: collapse; width: 100%; margin-top: 20px; }');
        EmailBody.AppendLine('th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }');
        EmailBody.AppendLine('th { background-color: #4CAF50; color: white; }');
        EmailBody.AppendLine('tr:nth-child(even) { background-color: #f2f2f2; }');
        EmailBody.AppendLine('.header { color: #333; }');
        EmailBody.AppendLine('.summary { background-color: #fff3cd; padding: 10px; border-left: 4px solid #ffc107; margin: 20px 0; }');
        EmailBody.AppendLine('</style>');
        EmailBody.AppendLine('</head>');
        EmailBody.AppendLine('<body>');

        // Email header
        EmailBody.AppendLine('<h2 class="header">Late Attendance Notification</h2>');
        EmailBody.AppendLine(StrSubstNo('<p>Dear %1,</p>', Employee."Full Name"));
        EmailBody.AppendLine('<p>This is to notify you that you have been marked late for the following day(s):</p>');

        // Summary box
        EmailBody.AppendLine('<div class="summary">');
        EmailBody.AppendLine(StrSubstNo('<strong>Employee No:</strong> %1<br>', Employee."No."));
        EmailBody.AppendLine(StrSubstNo('<strong>Employee Name:</strong> %1<br>', Employee."Full Name"));
        EmailBody.AppendLine(StrSubstNo('<strong>%1:</strong> %2<br>', DeputationOn, DeputationOnDesc));
        EmailBody.AppendLine(StrSubstNo('<strong>Period:</strong> %1 to %2<br>', Format(FromDate), Format(ToDate)));
        EmailBody.AppendLine(StrSubstNo('<strong>Total Late Days:</strong> %1', LateDayCount));
        EmailBody.AppendLine('</div>');

        // Attendance table
        EmailBody.AppendLine('<table>');
        EmailBody.AppendLine('<tr>');
        EmailBody.AppendLine('<th>Date</th>');
        EmailBody.AppendLine('<th>Check In Time</th>');
        EmailBody.AppendLine('<th>Check Out Time</th>');
        EmailBody.AppendLine('<th>Shift Start Time</th>');
        EmailBody.AppendLine('</tr>');

        // Add attendance records
        if EmployeeAttendance.FindSet() then
            repeat
                EmailBody.AppendLine('<tr>');
                EmailBody.AppendLine(StrSubstNo('<td>%1</td>', Format(EmployeeAttendance."Attendance Date")));
                EmailBody.AppendLine(StrSubstNo('<td>%1</td>', FormatTime(EmployeeAttendance."Check In Time")));
                EmailBody.AppendLine(StrSubstNo('<td>%1</td>', FormatTime(EmployeeAttendance."Check Out Time")));
                EmailBody.AppendLine(StrSubstNo('<td>%1</td>', FormatTime(EmployeeAttendance."Shift Start Time")));
                EmailBody.AppendLine('</tr>');
            until EmployeeAttendance.Next() = 0;

        EmailBody.AppendLine('</table>');

        // Footer
        EmailBody.AppendLine('<p style="margin-top: 20px;">Please ensure punctuality in your attendance. Repeated late arrivals may result in disciplinary action as per company policy.</p>');
        EmailBody.AppendLine('<p>If you have any questions or concerns, please contact the HR department.</p>');
        EmailBody.AppendLine('<br>');
        EmailBody.AppendLine('<p><strong>Best Regards,</strong><br>');
        EmailBody.AppendLine(StrSubstNo('%1<br>', CompanyInfo.Name));
        EmailBody.AppendLine('Human Resources Department</p>');

        EmailBody.AppendLine('</body>');
        EmailBody.AppendLine('</html>');

        exit(EmailBody.ToText());
    end;

    local procedure FormatTime(TimeValue: Time): Text
    begin
        if TimeValue = 0T then
            exit('-');
        exit(Format(TimeValue));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFilterEmployeeAttendance(var EmployeeAttendance: Record "Employee Attendance & Activity")
    begin
        //To add additional filter as required bu specific company.
    end;

    var
        EndDate: Date;
        StartDate: Date;
}
