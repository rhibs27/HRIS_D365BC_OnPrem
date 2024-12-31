page 50343 "Medical Insurance Claim Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'medicalInsuranceClaimEntity';
    DelayedInsert = true;
    EntityName = 'tempMedicalInsuranceEntity';
    EntitySetName = 'tempMedicalInsuranceEntities';
    PageType = API;
    SourceTable = "Medical Insurance Claim";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeno; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(startdate; Rec."Start Date") { }
                field(startdateBS; Rec."Start Date (BS)") { }
                field(enddate; Rec."End Date") { }
                field(enddateBS; Rec."End Date (BS)") { }
                field(requesteddate; Rec."Requested Date") { }
                field(fiscalyear; Rec."Fiscal Year") { }
                field(approvalstatus; Rec."Approval Status") { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.")
                {
                    Editable = true;
                }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
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
                    trigger OnValidate()
                    var
                        //EmpActivity: Record "Employee Activity";
                        MedicalInsuranceClaim: Record "Medical Insurance Claim";
                    begin
                        if Rec.Type = Rec.Type::"Medical Insurance Claim" then begin
                            Rec."Insurance Status" := Rec."Insurance Status"::"Request to DTMD";
                            MedicalInsuranceClaim.Init;
                            MedicalInsuranceClaim.Copy(Rec);
                            MedicalInsuranceClaim.Insert(true);
                        end;
                    end;
                }
            }
        }
    }
}
