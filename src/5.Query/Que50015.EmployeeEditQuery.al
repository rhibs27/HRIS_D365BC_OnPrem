query 50015 "Employee Edit Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'employeeEditApproval';
    EntitySetName = 'employeeEditApprovalEntity';
    QueryType = API;
    OrderBy = descending(no);

    elements
    {
        dataitem(employee; Employee)
        {
            column(empNo; "No.")
            {
            }
            column(navLoginID; "NAV Login ID")
            {
            }
            dataitem(ApprovalHRMS; "Approval HRMS")
            {
                DataItemLink = "Approver No" = employee."No.";
                column(no; "Document No.")
                {

                }
                column(approverCode; "Approver No")
                {

                }
                column(approverName; "Approver Name")
                {

                }
                column(approvalStatusLine; "Approval Status")
                {

                }
                column(approvalSequence; "Approval Sequence")
                {

                }
                dataitem(EmployeeEdit; "Employee Edit")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    //(General)

                    column(employeeNo; "Employee No.")
                    {
                    }
                    column(employeeName; "Employee Name")
                    {
                    }
                    column(type; Type) { }
                    column(changesInEmployeeType; "Changes In Employee Type")
                    {
                    }
                    column(approvalStatus; "Approval Status")
                    {
                    }
                    column(status; Status)
                    {
                    }
                    column(requestedDate; "Requested Date")
                    { }

                    column(approvedDate; "Approved Date")
                    {
                    }
                    column(rejectionRemarks; "Rejection Remarks")
                    {
                    }
                    column(attachment; Attachment)
                    {
                    }
                    //"Employee Information")

                    column(mobileNo; "Mobile No.") { }
                    column(maritalStatus; "Marital Status") { }
                    column(emailPersonal; "Email (Personal)") { }
                    column(differentlyAble; "Differently Able") { }
                    column(vehicleType; "Vehicle Type") { }
                    column(temporaryAddress; "Temporary Address") { }
                    column(temporaryProvince; "Temporary Province") { }
                    column(vDC; VDC) { }
                    column(temporaryDistrict; "Temporary District") { }
                    column(house; House)
                    {
                    }
                    column(email; "Email (Personal)")
                    {
                    }
                    column(bloodGroup; "Blood Group")
                    { }
                    column(emergencyContactName; "Emergency Contact Name")
                    {
                    }
                    column(emergencyContactEmail; "Emergency Contact Email")
                    {
                    }
                    //"Employee Qualification")
                    column(percentage; Percentage)
                    {
                    }
                    column(cGPA; CGPA)
                    {
                    }
                    column(stream; Stream)
                    {
                    }
                    column(year; Year)
                    {
                    }
                    column(empDocumentType; "Emp Document Type")
                    {
                    }

                    column(fromDate; "From Date")
                    {
                    }
                    column(toDate; "To Date")
                    {
                    }
                    column(qualificationCode; "Qualification Code")
                    {
                    }
                    // column(qualificationType; "Qualification Type")
                    // {

                    // }
                    column(description; Description)
                    {
                    }
                    column(institutionCompany; "Institution/Company")
                    {
                    }
                    column(designation; Designation)
                    {
                    }
                    column(remuneration; Remuneration)
                    {
                    }

                    //"Official Document")

                    column(passportNo; "Passport No.")
                    {
                    }
                    column(citizenShipNo; "CitizenShip No.")
                    {
                    }
                    column(citizenShipIssueDate; "CitizenShip Issue Date")
                    {
                    }
                    column(nIDNo; "NID No.")
                    {
                    }
                    column(drivingLicenseNo; "Driving License No.")
                    {
                    }

                    //(Relative)

                    column(relativeCode; "Relative Code")
                    {
                    }
                    column(fullName; "Full Name")
                    {
                    }
                    column(relativeBirthDate; "Birth Date")
                    {
                    }
                    column(relativePhoneNo; "Relative Phone No.")
                    {
                    }
                    column(employeeRelativeInBank; "Employee Relative In Bank")
                    {
                    }
                    column(relativesEmployeeNo; "Relative's Employee No.")
                    {
                    }
                    column(relativeCitizenShipNo; "Relative CitizenShip No.")
                    {
                    }
                    column(relativeDistrict; "Relative District")
                    {
                    }
                    column(relativeVDCMunicipality; "Relative VDC/Municipality")
                    {
                    }
                    column(wardNo; "Ward No.")
                    {
                    }

                    //Language Proficiency
                    column(language; Language)
                    {
                    }
                    column(reading; Reading)
                    {
                    }
                    column(writing; Writing)
                    {
                    }
                    column(speaking; Speaking)
                    {
                    }
                    column(typing; Typing)
                    {
                    }
                }
            }
        }
    }
    trigger OnBeforeOpen()
    var
        Hrmgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, Hrmgt.GetEmployeeNo());
        CurrQuery.SetRange(type, type::"Employee Edit");
    end;
}