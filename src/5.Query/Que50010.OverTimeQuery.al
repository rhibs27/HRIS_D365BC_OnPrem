query 50010 "OverTime Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'overTimeApproval';
    EntitySetName = 'overtimeApprovalEntity';
    QueryType = API;
    OrderBy = descending(no);
    elements
    {
        dataitem(employee; Employee)
        {
            column(empNo; "No.")
            {
            }
            column(navLoginID; "NAV Login ID")
            {
            }
            column(fullName; "Full Name")
            {
            }
            dataitem(ApprovalHRMS; "Approval HRMS")
            {
                DataItemLink = "Approver No" = employee."No.";
                column(no; "Document No.")
                {

                }
                column(approverCode; "Approver No")
                {

                }
                column(approverName; "Approver Name")
                {

                }
                column(approvalStatusLine; "Approval Status")
                {

                }
                column(approvalSequence; "Approval Sequence")
                {

                }
                dataitem(OverTime; OverTime)
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(type; Type) { }
                    column(employeeNo; "Employee No.")
                    {
                    }
                    column(employeeName; "Employee Name") { }
                    column(salaryLevel; "Salary Level Code") { }
                    column(department; Department) { }
                    column(departmentName; "Department Name") { }
                    column(branchCode; "Shortcut Dimension 1 Code") { }
                    column(branchName; "Branch Name") { }
                    column(functionalTitle; "Functional Title") { }
                    column(startDate; "Start Date") { }
                    column(startDateBS; "Start Date (BS)") { }
                    column(checkInTime; "Check In Time") { }
                    column(checkOutTime; "Check Out Time") { }
                    // column(endDate; "End Date") { }
                    // column(endDateBS; "End Date (BS)") { }
                    // column(noOfDays; "No. of Days") { }
                    column(requestedDate; "Requested Date") { }
                    column(fiscalYear; "Fiscal Year") { }
                    column(approvalStatus; "Approval Status") { }
                    column(cancelled; Cancelled) { }

                    column(reasonCode; "Reason Code") { }
                    column(reasonDescription; "Reason Description") { }
                    column(remarks; Remarks) { }
                    column(rejectionRemarks; "Rejection Remarks") { }
                    column(Status; status) { }

                    column(TimeDuration; "Time Duration") { }
                    column(ActualHours; "Actual Hours") { }
                    column(EstimatedHours; "Estimated Hours") { }
                    column(EncashmentCode; "Encashment Code") { }
                    column(OTAmount; "OT Amount") { }
                    column(OTDisbursed; "OT Disbursed") { }
                }
            }
        }
    }
    local procedure getTimeinFormat(varTime: Time): Text
    var
        Milliseconds: Integer;
        Hours: Integer;
        Minutes: Integer;
        Seconds: Integer;
        HoursText: Text;
        MinutesText: Text;
        SecondsText: Text;
        TimeText: Text;
    begin
        if varTime = 0T then
            exit('');
        Milliseconds := varTime - 000000T;

        Hours := Round(Milliseconds div 1000 div 60 div 60, 1, '=');
        if Hours < 10 then
            HoursText := '0' + Format(Hours)
        else
            HoursText := Format(Hours);
        Milliseconds -= Hours * 1000 * 60 * 60;
        TimeText := 'AM';
        Minutes := Round(Milliseconds div 1000 div 60, 1, '=');
        if Minutes < 10 then
            MinutesText := '0' + Format(Minutes)
        else
            MinutesText := Format(Minutes);
        if Hours = 12 then
            TimeText := 'PM';
        Milliseconds -= Minutes * 1000 * 60;

        Seconds := Round(Milliseconds div 1000, 1, '=');
        if Seconds < 10 then
            SecondsText := '0' + Format(Seconds)
        else
            SecondsText := Format(Seconds);
        Milliseconds -= Seconds * 1000;

        if Hours > 12 then begin
            Hours := Hours mod 12;
            TimeText := 'PM';
            if Hours < 10 then
                HoursText := '0' + Format(Hours)
            else
                HoursText := Format(Hours);
        end;
        exit(HoursText + ':' + MinutesText + ' ' + TimeText);
    end;

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HRMgt.GetEmployeeNo());
    end;
}