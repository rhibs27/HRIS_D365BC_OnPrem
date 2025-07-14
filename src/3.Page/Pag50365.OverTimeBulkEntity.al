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
                field(return; Rec.Return)
                {
                }
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
}