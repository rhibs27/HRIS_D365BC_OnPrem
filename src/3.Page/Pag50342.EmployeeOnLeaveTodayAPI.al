page 50342 "Employee On Leave Today API"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'EmployeeOnLeave';
    DelayedInsert = true;
    EntityName = 'employeeOnLeave';
    EntitySetName = 'employeeOnLeaves';
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
                field(ApprovalStatus; Rec."Approval Status")
                {

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("Start Date", '<=%1', Today);
        Rec.Setfilter("End Date", '>=%1', Today);
        rec.SetRange("Deputation On Code", HrMgt.getDeputation(HrMgt.GetEmployeeNo()));
        Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
        Rec.SetRange(Cancelled, false);
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
}
