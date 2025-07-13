page 50313 "Employee On Leave Months"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'EmployeeOnLeave';
    DelayedInsert = true;
    EntityName = 'employeeOnLeaveMonth';
    EntitySetName = 'employeeOnLeavesMonth';
    PageType = API;
    SourceTable = Leave;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(employeeNo; Rec."Employee No.")
                {

                }
                field(employeeName; Rec."Employee Name")
                {

                }
                field(startDate; Rec."Start Date")
                {

                }
                field(endDate; Rec."End Date")
                {

                }
                field(leaveType; Rec."Leave Type")
                {
                }
                field(noOfDays; Rec."No. of Days")
                {
                }
                field(ApprovalStatus; Rec."Approval Status")
                {

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        FirstDate := CalcDate('<-CM>', Today);
        LastDate := CalcDate('<+CM>', Today);
        Rec.SetRange("Start Date", FirstDate, LastDate);
        rec.SetRange("Deputation On Code", HrMgt.getDeputation(HrMgt.GetEmployeeNo()));
        Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
        FirstDate: Date;
        LastDate: Date;
}
