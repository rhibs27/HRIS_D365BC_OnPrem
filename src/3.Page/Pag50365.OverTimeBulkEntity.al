page 50365 "OverTime Bulk Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'overTimeEntity';
    DelayedInsert = true;
    EntityName = 'overtimeBulk';
    EntitySetName = 'overtimeBulkEntity';
    PageType = API;
    SourceTable = OverTime;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(no; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeNo; Rec."Employee No.")
                {
                }
                field(employeeName; Rec."Employee Name") { }
                field(employeeWorkShift; Rec."Employee Work Shift") { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(requestedDate; Rec."Requested Date") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(remarks; Rec.Remarks) { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }
                field(status; Rec.status) { }
                field(deputationType; Rec."Deputation Type") { }
                field(deputationCode; Rec."Deputation Code") { }
                field(deputationName; Rec."Deputation Name") { }
            }
            part(overtimeLines; "Overtime Subform")
            {
                ApplicationArea = All;
                EntityName = 'overtimeLine';
                EntitySetName = 'overtimeLines';
                Caption = 'Overtime Lines';
                SubPageLink = "No." = field("No.");
            }
        }
    }
    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetRange(Type, Rec.Type::"Overtime Bulk");
        Rec.SetAscending("No.", false);
    end;

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
}