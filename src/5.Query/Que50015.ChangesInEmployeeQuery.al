query 50015 "Changes In Employee Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'changesinEmployeeApproval';
    EntitySetName = 'changesinEmployeeApprovalEntity';
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
                    //"Employee Information")

                    column(mobileNo; "Mobile No.") { }
                    column(maritalStatus; "Marital Status") { }
                    column(emailPersonal; "Email (Personal)") { }
                    column(differentlyAble; "Differently Able") { }
                    column(vehicleType; "Vehicle Type") { }
                    column(temporaryAddress; "Temporary Address") { }
                    column(temporaryProvince; "Temporary Province") { }
                    column(VDC; VDC) { }
                    column(temporaryDistrict; "Temporary District") { }
                    column(house; House)
                    {
                    }
                    column(email; "Email (Personal)")
                    {
                    }
                    column(bloodGroup; "Blood Group")
                    { }

                    //"Employee Qualification")
                    column(percentage; Percentage)
                    {
                    }
                    column(CGPA; CGPA)
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
                    column(qualificationType; "Qualification Type")
                    {

                    }
                    column(description; Description)
                    {
                    }
                    column(institutionCompany; "Institution/Company")
                    {
                    }
                    column(designation; Designation)
                    {
                        // Visible = WorkExperienceChanges;
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
                    column(relativePhoneNo; "Relative Phone No.")
                    {
                    }
                    column(employeeRelativeInBank; "Employee Relative In Bank")
                    {
                    }
                    column(relativeEmployeeNo; "Relative's Employee No.")
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
                    column(Language; Language)
                    {
                    }
                    column(Reading; Reading)
                    {
                    }
                    column(Writing; Writing)
                    {
                    }
                    column(Speaking; Speaking)
                    {
                    }
                    column(Typing; Typing)
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
    end;
}