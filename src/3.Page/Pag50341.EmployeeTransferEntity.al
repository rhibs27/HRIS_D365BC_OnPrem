page 50341 "Employee Transfer Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Employee Transfer Entity';
    DelayedInsert = true;
    EntityName = 'employeeTransfer';
    EntitySetName = 'employeeTransferEntity';
    PageType = API;
    SourceTable = "Employee/HR Transfer";
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(no; Rec."No.") { }
                field(type; Rec.Type)
                {
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeeName; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmenName; Rec."Department Name") { }
                field(branchCode; Rec."Shortcut Dimension 1 Code") { }
                field(branchName; Rec."Branch Name") { }
                field(functionalTitle; Rec."Functional Title") { }
                field(functionalTitleDesc; Rec."Functional Title Desc") { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(noOfdays; Rec."No. of Days") { }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(status;rec.Status)
                {
                }
                field(isTransferDetailsAdded;Rec."Is Transfer Details Added")
                {
                }
                field(transferProposeDate;rec."Transfer Propose Date")
                {
                }
                field(cancelled; Rec.Cancelled) { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
                field(reasonForTransfer; Rec."Reason for Transfer") { }
                field(provinceCode;Rec."Province Code") { }
                field(provinceName;Rec."Province Name") { }
                field(unitCode;Rec."Unit Code") { }
                field(unitName;Rec."Unit Name") { }
                field(departmentName;Rec."Department Name") { }
                field(ExtensionName;Rec."Extension Counter Name"){ }
                field(branchCodeTo;Rec."To Branch") { }
                field(remarks; Rec.Remarks) { }
                field(screenerRemarks; Rec."Screener Remarks") { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }
            }
            group(Transfer)
            {
                field(transferType; Rec."Transfer Type") { }
                field(deputationOn; Rec."Deputation On") { }
                field(extensionCounterCode; Rec."Extension Counter Code") { }
                field(functionalTitleTo; Rec."Functional Title (To)") { }
                field(functionalDescTo;Rec."Functional Desc To") { }
                field(provinceCodeTo; Rec."Province Code (To)") { }
                field(unitTo; Rec."Unit (To)") { }
                field(departmentCodeTo; Rec."Department Code (To)") { }
                field(extensionCounterTo; Rec."Extension Counter (To)") { }
                field(deputationOnTo; Rec."Deputation On (To)") { }
                field(extensionNameTo; Rec."Extension Name To")
                {
                    Editable = false;
                }
                field(branchNameTo; Rec."Branch Name To")
                {
                    Editable = false;
                }
                field(provinceNameTo; Rec."Province Name To")
                {
                    Editable = false;
                }
                field(unitNameTo; Rec."Unit Name To")
                {
                    Editable = false;
                }
                field(departmentNameTo; Rec."Department Name To")
                {
                    Editable = false;
                }
                field(incomingSupervisior; Rec."Incoming Supervisior") { }
                field(incomingSupervisiorName; Rec."Incoming Supervisior Name") { }
                field(outgoingBranchRepPerson; Rec."Outgoing Branch Rep. Person")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Outgoing Reporting Person Name");
                    end;
                }
                field(outgoingReportingPersonName; Rec."Outgoing Reporting Person Name") { }
                field(dateofJoiningOfTransfer; Rec."Date of Joining Of Transfer") { }
                field(description; rec.Description)
                {
                }
                field(transferClaim;Rec."Transfer Claim")
                {
                }
                field(handover;Rec.Handover)
                {
                }
                field(takeover;Rec.Takeover)
                {
                }
            }
            group("Transfer Claim")
            {
                field(transferRemarks; Rec."Transfer Remarks") { }
                field(relocationAllow; Rec."Relocation Allow.") { }
                field(outstationDiscomfortAllow; Rec."Outstation/Discomfort Allow.") { }
                field(BMAccomodationAllow; Rec."BM Accomodation Allow.") { }
                field(remoteAreaAllow; Rec."Remote Area Allow.") { }
                field(officiatingAllow; Rec."Officiating Allow.") { }
                field(relocationDistance; Rec."Relocation Distance") { }
                field(outstationDistance; Rec."Outstation Distance") { }
                field(bmafDistance; Rec."BMAF Distance") { }
                field(transferRequestNo;Rec."Transfer Request No")
                {
                }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetAscending("No.", false);
    end;
    var
        HRMgt: Codeunit "HR Mgt.";   
}
 

