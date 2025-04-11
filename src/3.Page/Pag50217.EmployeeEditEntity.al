page 50217 "Employee Edit Entity"
{
    EntityName = 'employeeEdit';
    EntitySetName = 'employeeEditEntity';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Employee Edit";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field(no; Rec."No.")
                {
                    Editable = false;
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = false;
                }
                field(employeeName; Rec."Employee Name")
                {
                }
                field(changesInEmployeeType; Rec."Changes In Employee Type")
                {
                }
                field(approvalStatus; Rec."Approval Status")
                {
                }
                field(status; rec.Status)
                {
                }
                field(requestedDate; Rec."Requested Date")
                { }

                field(approvedDate; Rec."Approved Date")
                {
                }
                field(rejectionRemarks; Rec."Rejection Remarks")
                {
                }

                field(attachment; ExportEmpImage)
                {
                    Editable = false;
                }
                field(attachmentImport; attachmentImport)
                {
                }
                field(ext; extension)
                {
                }
            }
            group("Employee Information")
            {
                field(mobileNo; Rec."Mobile No.") { }
                field(maritalStatus; Rec."Marital Status") { }
                field(emailPersonal; Rec."Email (Personal)") { }
                field(differentlyAble; Rec."Differently Able") { }
                field(vehicleType; Rec."Vehicle Type") { }
                field(temporaryProvince; Rec."Temporary Province") { }
                field(vDC; Rec.VDC) { }
                field(temporaryDistrict; Rec."Temporary District") { }
                field(house; Rec.House)
                {
                }
                field(email; Rec."Email (Personal)")
                {
                }
                field(bloodGroup; Rec."Blood Group")
                { }
            }
            group("Employee Qualification")
            {
                field(percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage field.';
                }
                field(cGPA; Rec.CGPA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CGPA field.';
                }
                field(stream; Rec.Stream)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stream field.';
                }
                field(year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year of completion field.';
                }
                field(empDocumentType; Rec."Emp Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Emp Document Type field.';
                }

                field(fromDate; Rec."From Date")
                {
                }
                field(toDate; Rec."To Date")
                {
                }
                field(qualificationCode; Rec."Qualification Code")
                {
                }
                field(qualificationType; rec."Qualification Type")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(institutionCompany; Rec."Institution/Company")
                {
                }
                field(designation; Rec.Designation)
                {
                }
                field(remuneration; Rec.Remuneration)
                {
                }
            }
            group("Official Document")
            {
                field(passportNo; Rec."Passport No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Passport No. field.';
                }
                field(citizenShipNo; Rec."CitizenShip No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CitizenShip No. field.';
                }
                field(citizenShipIssueDate; Rec."CitizenShip Issue Date")
                {
                    ApplicationArea = All;
                }
                field(nIDNo; Rec."NID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National ID No. field.';
                }
                field(drivingLicenseNo; Rec."Driving License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driving License No field.';
                }
            }
            group(Relative)
            {

                field(relativeCode; Rec."Relative Code")
                {
                }
                field(fullName; Rec."Full Name")
                {
                }
                field(relativeBirthDate; Rec."Birth Date")
                {
                }
                field(relativePhoneNo; Rec."Relative Phone No.")
                {
                }
                field(employeeRelativeInBank; rec."Employee Relative In Bank")
                {
                }
                field(relativeEmployeeNo; Rec."Relative's Employee No.")
                {
                }
                field(relativeCitizenShipNo; Rec."Relative CitizenShip No.")
                {
                }
                field(relativeDistrict; Rec."Relative District")
                {
                }
                field(relativeVDCMunicipality; Rec."Relative VDC/Municipality")
                {
                }
                field(wardNo; Rec."Ward No.")
                {
                }
            }
            group("Language Proficiency")
            {
                field(language; Rec.Language)
                {
                }
                field(reading; Rec.Reading)
                {
                }
                field(writing; Rec.Writing)
                {
                }
                field(speaking; Rec.Speaking)
                {
                }
                field(typing; Rec.Typing)
                {
                }
            }
        }
    }
    trigger OnOpenPage()

    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if rec."Changes In Employee Type" in [rec."Changes In Employee Type"::Details, Rec."Changes In Employee Type"::Qualification] then
            uploadEmployeeChangesAttachment;
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
        attachmentImport: text;
        extension: text;

    local procedure ExportEmpImage(): Text;
    var
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
        FileMgt: Codeunit "File Management";
    begin
        Clear(extension);
        if Rec.Attachment.HasValue then begin
            if ItemTenantMedia.Get(Rec.Attachment.MediaId) then begin
                extension := FileMgt.GetExtension(ItemTenantMedia.Description);
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;

    local procedure uploadEmployeeChangesAttachment();
    var
        TempBlob: Codeunit "Temp Blob";
        Instream: InStream;
        base64: Codeunit "Base64 Convert";
        Outstream: OutStream;
        FileName: text;
        AttachmentMgt: Codeunit "Attachment Mgt.";
    begin
        // if rec."Changes In Employee Type" = Rec."Changes In Employee Type"::Details then begin
        //     case LowerCase(extension) of
        //         'jpg', 'jpeg', 'png', '':
        //             begin
        //             end;
        //         else
        //             Error('Invalid file extension. Please upload a jpg, jpeg or png');
        //     end;

        // end;
        AttachmentMgt.checkAttachmentExtension(extension);
        FileName := Rec."Employee No." + '.' + extension;
        TempBlob.CreateOutStream(outStream);
        base64.FromBase64(attachmentImport, Outstream);
        TempBlob.CreateInStream(InStream); // Get the data back from TempBlob
        AttachmentMgt.CheckAttachmentSizeLimit(InStream, Rec.RecordId.TableNo);//checkfileSIze
        Rec.Attachment.ImportStream(Instream, FileName);
    end;
}