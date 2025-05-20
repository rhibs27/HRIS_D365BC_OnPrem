page 50319 "Employee Insurance Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'employeeInsuranceEntity';
    DelayedInsert = true;
    EntityName = 'employeeInsuranceEntity';
    EntitySetName = 'employeeInsuranceEntities';
    PageType = API;
    SourceTable = "Employee Insurance Information";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(insuranceNo; Rec."Insurance No.")
                {
                    Caption = 'Insurance No.';
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(insuranceCompany; Rec."Insurance Company Code")
                {
                    Caption = 'Insurance Company';
                }
                field(insuranceCompanyName; Rec."Insurance Company Name")
                {
                    Caption = 'Insurance Company Name';
                }
                // field(lifeInsuranceCompany; Rec."Life Insurance Company")
                // {
                //     Caption = 'Life Insurance Company';
                // }
                // field(medicalPropertyInsCompany; Rec."Medical/Property Ins Company")
                // {
                //     Caption = 'Medical/Property Ins Company';
                // }
                field(policyNumber; Rec."Policy Number")
                {
                    Caption = 'Policy Number';
                }
                field(insuranceStartDateAD; Rec."Insurance Start Date (AD)")
                {
                    Caption = 'Insurance Start Date (AD)';
                }
                field(insuranceStartDateBS; Rec."Insurance Start Date (BS)")
                {
                    Caption = 'Insurance Start Date (BS)';
                }
                field(insuranceExpiryDateAD; Rec."Insurance Expiry Date (AD)")
                {
                    Caption = 'Insurance Expiry Date (AD)';
                }
                field(insuranceExpiryDateBS; Rec."Insurance Expiry Date (BS)")
                {
                    Caption = 'Insurance Expiry Date (BS)';
                }
                field(insuranceAmount; Rec."Insurance Amount")
                {
                    Caption = 'Insurance Amount';
                }
                field(monthlyPremiumAmount; Rec."Monthly Premium Amount")
                {
                    Caption = 'Monthly Premium Amount';
                }
                field(isHomeLoanTieUp; Rec."Is Home Loan TieUp")
                {
                    Caption = 'Is Home Loan TieUp';
                }
                field(requestedDate; Rec."Requested Date")
                {
                    Caption = 'Requested Date';
                }
                field(approvalStatus; Rec."Approval Status")
                {
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(insuranceType; Rec."Insurance Type")
                {
                    Caption = 'Type';
                }
                field(remarks; Rec.Remarks)
                {
                    Caption = 'Remarks';
                }
                field(annualPremiumAmount; Rec."Annual Premium Amount")
                {
                    Caption = 'Annual Premium Amount';
                }
                part(Attachments; "Attachment Subform")
                {
                    ApplicationArea = All;
                    SubPageLink = "No." = field("Insurance No.");
                    EntitySetName = 'attachmentEntities';
                    EntityName = 'attachmentEntity';
                    Editable = true;
                }
            }
        }
    }
}
