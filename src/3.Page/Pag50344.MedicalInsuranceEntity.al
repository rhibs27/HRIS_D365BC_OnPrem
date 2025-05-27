page 50344 "Medical Insurance Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'medicalInsuranceEntity';
    DelayedInsert = true;
    EntityName = 'medicalInsuranceEntity';
    EntitySetName = 'medicalInsuranceEntities';
    PageType = API;
    SourceTable = "Medical Insurance Claim";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeNo; Rec."Employee No.") { }
                field(employeeName; Rec."Employee Name") { }

                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(status; Rec.Status) { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.")
                {
                    Editable = true;
                }
                field(remarks; Rec.Remarks) { }
                field(insuranceClaim; Rec."Insurance Claim") { }
                field(fatherName; Rec."Father Name") { }
                field(motherName; Rec."Mother Name") { }
                field(spouseName; Rec."Spouse Name") { }
                field(childName; Rec."Child Name") { }
                field(totalInsuranceClaimAmount; Rec."Total Insurance Claim Amount") { }
                field(medicalPrescriptionDate; Rec."Medical Prescription Date") { }
                field(dischargeDate; Rec."Discharge Date")
                {
                }
                part(Attachment; "Attachment Subform")
                {
                    EntityName = 'attachmentEntity';
                    EntitySetName = 'attachmentEntities';
                    SubPageLink = "No." = field("No.");
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetAscending("No.", false);
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
}
