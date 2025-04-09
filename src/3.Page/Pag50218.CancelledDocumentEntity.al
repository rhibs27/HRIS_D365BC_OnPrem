page 50218 "Cancelled Document Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'cancelledDocument';
    DelayedInsert = true;
    EntityName = 'cancelledDoc';
    EntitySetName = 'cancelledDocEntity';
    PageType = API;
    SourceTable = "Cancel Document";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Editable = false;
                    Caption = 'No.';
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(employeeWorkShift; Rec."Employee Work Shift")
                {
                    Caption = 'Employee Work Shift';
                }
                field(cancelled; Rec.Cancelled)
                {
                    Caption = 'Cancelled';
                }
                field(cancelledDocumentNo; Rec."Cancelled Document No.")
                {
                    Caption = 'Cancelled Document No.';
                }
                field(approvedDate; Rec."Approved Date")
                {
                    Caption = 'Approved Date';
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                }
                field(endDate; Rec."End Date")
                {
                    Caption = 'End Date';
                }
                field(endDateBS; Rec."End Date (BS)")
                {
                    Caption = 'End Date (BS)';
                }
                field(fiscalYear; Rec."Fiscal Year")
                {
                    Caption = 'Fiscal Year';
                }
                field(functionalTitle; Rec."Functional Title")
                {
                    Caption = 'Functional Title';
                }
                field(leaveCode; Rec."Leave Code")
                {
                    Caption = 'Leave Code';
                }
                field(leaveDescription; Rec."Leave Description")
                {
                    Caption = 'Leave Description';
                }
                field(noOfDays; Rec."No. of Days")
                {
                    Caption = 'No. of Days';
                }
                field(rejectionRemarks; Rec."Rejection Remarks")
                {
                    Caption = 'Rejection Remarks';
                }
                field(remarks; Rec.Remarks)
                {
                    Caption = 'Remarks';
                }
                field(requestedDate; Rec."Requested Date")
                {
                    Caption = 'Requested Date';
                }
                field(startDate; Rec."Start Date")
                {
                    Caption = 'Start Date';
                }
                field(startDateBS; Rec."Start Date (BS)")
                {
                    Caption = 'Start Date (BS)';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
    end;

    trigger OnInsertRecord(BelowRec: Boolean): Boolean
    begin
        Rec.Validate("Employee No.", HrMgt.GetEmployeeNo());
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
}
