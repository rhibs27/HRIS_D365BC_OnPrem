page 50260 "Shift Assignment Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'shiftAssignmentEntity';
    DelayedInsert = true;
    EntityName = 'ShiftAssignment';
    EntitySetName = 'ShiftAssignmentEntity';
    PageType = API;
    SourceTable = "Shift Assignment Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(fromDate; Rec."From Date")
                {
                    Caption = 'From Date';
                }
                field(toDate; Rec."To Date")
                {
                    Caption = 'To Date';
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                }
                field(approvedDate; Rec."Approved Date")
                {
                    Caption = 'Approved Date';
                }
                field(deputationCode; Rec."Deputation Code")
                {
                    Caption = 'Deputation Code';
                }
                field(deputationName; Rec."Deputation Name")
                {
                    Caption = 'Deputation Name';
                }
                field(deputationType; Rec."Deputation Type")
                {
                    Caption = 'Deputation Type';
                }
                field(rejectionRemarks; Rec."Rejection Remarks")
                {
                    Caption = 'Rejection Remarks';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
            }
            part(ShiftLine; "shift subform")
            {
                ApplicationArea = All;
                EntityName = 'shiftLine';
                EntitySetName = 'shiftLines';
                Caption = 'Shift Lines';
                SubPageLink = "No." = field("No.");
            }
        }
    }
    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetRange(Type, Rec.Type::"Shift Assignment");
        Rec.SetAscending("No.", false);
    end;
}
