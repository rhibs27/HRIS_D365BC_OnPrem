page 50339 "Employee Resignation Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'employeeResignationEntity';
    DelayedInsert = true;
    EntityName = 'employeeResignation';
    EntitySetName = 'employeeResignationEntity';
    PageType = API;
    SourceTable = Resignation;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeeName; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmentName; Rec."Department Name") { }
                field(branchCode; Rec."Shortcut Dimension 1 Code") { }
                field(branchName; Rec."Branch Name") { }
                field(functionalTitle; Rec."Functional Title") { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(noOfDays; Rec."No. of Days") { }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(cancelled; Rec.Cancelled) { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.") { }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
                field(remarks; Rec.Remarks) { }
                field(screenerRemarks; Rec."Screener Remarks") { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }
            }
            group(Resignation)
            {
                field(proposedDateOfResignation; Rec."Proposed Date of Resignation") { }
                field(supervisorProposedDate; Rec."Supervisor Proposed Date") { }
                field(hRProposedDate; Rec."HR Proposed Date") { }
                field(waiverCase; Rec."Waiver Case") { }
                field(reasonForResignation; Rec."Reason for Resignation") { }
                field(clearanceStatement; ClearanceStatement) { }
                field(applyForWaiver; Rec."Apply for Waiver") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
            part(docApproverEntities; "Document Approver Resignation")
            {
                EntityName = 'docApproverEntity';
                EntitySetName = 'docApproverEntities';
                SubPageLink = "Document No." = field("No.");
            }
            group(Approval)
            {
                field(recommenderCode; Rec."Recommender Code")
                {
                }
                field(recommenderName; Rec."Recommender Name") { }
                field(approverCode; Rec."Approver Code") { }
                field(approverName; Rec."Approver Name") { }
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    begin
        SetControlAppearance;
    end;

    var
        ClearanceStatement: Text;
        HRSetup: Record "Human Resources Setup";

    local procedure SetControlAppearance()
    var
        EmpVar: Record Employee;
        DocApprover: Record "Document Approver";
        EmpActFilter: Text;
        AccessControlLine: Record "Access Control Request Line";
        SystemAccessControl: Record "System Access Control";
    begin

        if Rec.Type = Rec.Type::Resignation then begin
            HRSetup.Get;
            ClearanceStatement := HRSetup."Clearance Statement I" + HRSetup."Clearance Statement II";
            Clear(EmpActFilter);
            EmpVar.Reset;
            EmpVar.SetRange("No.", Rec.GetFilter("Employee No."));
            if EmpVar.FindFirst then begin
                DocApprover.Reset;
                DocApprover.SetRange("Document Type", DocApprover."Document Type"::Resignation);
                DocApprover.SetRange("Employee No.", EmpVar."No.");
                if DocApprover.Find('-') then begin
                    repeat
                        if EmpActFilter = '' then
                            EmpActFilter := DocApprover."Document No."
                        else
                            EmpActFilter += '|' + DocApprover."Document No.";
                    until DocApprover.Next = 0;
                    Rec.FilterGroup(-1);
                    if EmpActFilter = '' then
                        Rec.SetRange("No.", EmpActFilter)
                    else
                        Rec.SetFilter("No.", EmpActFilter);
                    Rec.SetRange("Employee No.", EmpVar."No.");
                    Rec.SetRange("Approver Code", EmpVar."No.");
                    Rec.SetRange("Recommender Code", EmpVar."No.");
                    Rec.FilterGroup(0);
                end;
            end;
        end;

        if Rec.Type = Rec.Type::"Access Control" then begin
            Clear(EmpActFilter);
            EmpVar.Reset;
            EmpVar.SetRange("No.", Rec.GetFilter("Employee No."));
            if EmpVar.FindFirst then begin
                if not EmpVar."System Owner" then begin
                    Rec.FilterGroup(-1);
                    Rec.SetRange("Employee No.", EmpVar."No.");
                    Rec.SetRange("Recommender Code", EmpVar."No.");
                    Rec.SetRange("Approver Code", EmpVar."No.");
                    Rec.FilterGroup(0);
                end else begin
                    AccessControlLine.Reset;
                    //AccessControlLine.SETRANGE("Document No.","No.");
                    if AccessControlLine.FindFirst then
                        repeat
                            SystemAccessControl.Reset;
                            SystemAccessControl.SetRange(Code, AccessControlLine."System Type");
                            SystemAccessControl.SetRange("Type of Masters", SystemAccessControl."Type of Masters"::"System Control Setup");
                            SystemAccessControl.SetRange("System Department Owner", EmpVar."Department Code");
                            if SystemAccessControl.FindFirst then begin
                                if EmpActFilter = '' then
                                    EmpActFilter := AccessControlLine."Document No."
                                else
                                    EmpActFilter += '|' + AccessControlLine."Document No.";
                            end;
                        until AccessControlLine.Next = 0;
                    Rec.FilterGroup(-1);
                    Rec.SetRange("Employee No.", EmpVar."No.");
                    Rec.SetRange("Recommender Code", EmpVar."No.");
                    Rec.SetRange("Approver Code", EmpVar."No.");
                    if EmpActFilter <> '' then
                        Rec.SetFilter("No.", EmpActFilter);
                    Rec.FilterGroup(0);
                end;
            end;
        end;
    end;
}
