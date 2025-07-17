page 50329 "Employee Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    Caption = 'employeeEntity';
    DelayedInsert = true;
    EntityName = 'employees';
    EntitySetName = 'employees';
    PageType = API;
    SourceTable = Employee;
    SourceTableView = where(Status = const(Active));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(employeeNo; Rec."No.") { }
                field(employeeName; Rec."Full Name")
                {
                    Caption = 'Full Name';
                }
                field(jobTitle; Rec."Job Title")
                {
                    Caption = 'Job Title';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(extension; Rec.Extension)
                {
                    Caption = 'Extension';
                }
                field(mobileNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                }
                // field(secondaryMobileNo; Rec."Mobile No.")
                // {
                //     Caption = 'Secondary Mobile No.';
                // }
                field(relationWithEmergencyCont; Rec."Relation With Emergency Cont")
                {
                    Caption = 'Relation With Emergency Cont';
                }
                field(emergencyMobileNo; Rec."Emergency Mobile No.")
                {
                    Caption = 'Emergency Mobile No.';
                }
                field(companyEMail; Rec."Company E-Mail")
                {
                    Caption = 'Company Email';
                }
                field(navLoginID; Rec."NAV Login ID")
                {
                    Caption = 'NAV Login ID';
                }
                field(emailPersonal; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(employmentDate; Rec."Employment Date")
                {
                    Caption = 'Employment Date';
                }
                field(terminationDate; Rec."Termination Date")
                {
                    Caption = 'Termination Date';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(birthDate; Rec."Birth Date")
                {
                    Caption = 'Birth Date';
                }
                field(religion; Rec.Religion)
                {
                    Caption = 'Religion';
                }
                field(motherTongue; Rec."Mother Tongue")
                {
                    Caption = 'Mother Tongue';
                }
                field(emergencyContactName; Rec."Emergency Contact Name")
                {
                    Caption = 'Emergency Contact Name';
                }
                field(emergencyContactEmail; Rec."Emergency Contact Email")
                {
                    Caption = 'Emergency Contact Email';
                }
                field(gender; Rec.Gender)
                {
                    Caption = 'Gender';
                }
                field(dateOfBirthBS; Rec."Date of Birth (B.S.)")
                {
                    Caption = 'Date of Birth (B.S.)';
                }
                field(age; Rec.Age)
                {
                    Caption = 'Age';
                }
                field(maritalStatus; Rec."Marital Status")
                {
                    Caption = 'Marital Status';
                }
                field(drivingLicenseNo; Rec."Driving License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driving License No field.';
                }
                field(nIDNo; Rec."NID No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National ID No. field.';
                }
                field(citizenShipNo; Rec."Citizen Number")
                {
                    Caption = 'Citizen Number';
                }
                field(citizenshipIssuePlaceCode; Rec."Citizenship Issue Place Code")
                {
                    Caption = 'Citizenship Issue Place Code';
                }
                field(citizenshipIssuePlace; Rec."Citizenship Issue Place")
                {
                    Caption = 'Citizenship Issue Place';
                }
                field(citizenShipIssueDate; Rec."Citizenship Issue Date")
                {
                    Caption = 'Citizenship Issue Date';
                }
                field(passportNo; Rec."Passport Number")
                {
                    Caption = 'Passport Number';
                }
                field(bloodGroup; Rec."Blood Group")
                {
                    Caption = 'Blood Group';
                }
                field(differentlyAble; Rec.Disabled)
                {
                    Caption = 'Disabled';
                }
                field(vehicleType; Rec."Vehicle Type")
                {
                    Caption = 'Vehicle Type';
                }
                field(permanentDistrict; Rec."Permanent District")
                {
                    Caption = 'Permanent District';
                }
                field(permanentProvince; Rec."Permanent Province")
                {
                    Caption = 'Permanent Province';
                }
                field(kpiDeputation; Rec."KPI Deputation")
                {
                    Caption = 'KPI Deputation';
                }
                field(permanentVDC; Rec."Permanent VDC")
                {
                    Caption = 'Permanent VDC';
                }
                field(permanentHouse; Rec."Permanent House")
                {
                    Caption = 'Permanent House';
                }
                field(temporaryDistrict; Rec."Temporary District")
                {
                    Caption = 'Temporary District';
                }
                field(temporaryProvince; Rec."Temporary Province")
                {
                    Caption = 'Temporary Province';
                }
                field(wardNo; Rec."Temporary Ward No")
                {
                    Caption = 'Temporary Ward No';
                }
                field(vDC; Rec."Temporary VDC")
                {
                    Caption = 'Temporary VDC';
                }
                field(house; Rec."Temporary House")
                {
                    Caption = 'Temporary House';
                }
                field(salaryLevel; Rec."Salary Level")
                {
                    Caption = 'Salary Level';
                }
                field(functionalTitle; Rec."Functional Title")
                {
                    Caption = 'Functional Title';
                }
                field(functionalTitleDesc; Rec."Functional Title Desc")
                {
                    Caption = 'Functional Title Desc';
                }
                field(employmentType; Rec."Employment Type")
                {
                    Caption = 'Employment Type';
                }
                field(deputationOn; Rec."Deputation on")
                {
                    Caption = 'Deputation on';
                }
                field(deputationOnCode; Rec."Deputation on Code")
                {
                    Caption = 'Deputation on Code';
                }
                field(departmentCode; Rec."Department Code")
                {
                    Caption = 'Department Code';
                }
                field(departmentName; Rec."Department Name")
                {
                    Caption = 'Department Name';
                }
                field(unitCode; Rec."Unit Code")
                {
                    Caption = 'Unit Code';
                }
                field(unitName; Rec."Unit Name")
                {
                    Caption = 'Unit Name';
                }
                // field(ecoSystem; Rec."Eco-System")
                // {
                //     Caption = 'Eco-System';
                // }
                // field(office; Rec.Office)
                // {
                //     Caption = 'Office';
                // }
                field(provinceCode; Rec."Province Code")
                {
                    Caption = 'Province Code';
                }
                field(provinceName; Rec."Province Name")
                {
                    Caption = 'Province Name';
                }
                field(branchCode; Rec."Branch Code")
                {
                    Caption = '"Branch Code"';
                }
                field(branchName; Rec."Branch Name")
                {
                    Caption = 'Branch Name';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(extensionCounterCode; Rec."Extension Counter Code")
                {
                    Caption = 'Extension Counter Code';
                }
                field(extensionCounterName; Rec."Extension Counter Name")
                {
                    Caption = 'Extension Counter Name';
                }
                field(postingRegion; Rec."Posting Region")
                {
                    Caption = 'Posting Region';
                }
                field(salaryGrade; Rec."Salary Grade")
                {
                    Caption = 'Salary Grade';
                }
                field(promotionDate; Rec."Promotion Date")
                {
                    Caption = 'Promotion Date';
                }
                field(solId; Rec."Sol Id")
                {
                    Caption = 'Sol Id';
                }
                field(outStationEligible; Rec."Out-Station eligible")
                {
                    Caption = 'Out-Station eligible';
                }
                field(groundsForTermCode; Rec."Grounds for Term. Code")
                {
                    Caption = 'Grounds for Term. Code';
                }
                field(emplymtContractCode; Rec."Emplymt. Contract Code")
                {
                    Caption = 'Emplymt. Contract Code';
                }
                field(statisticsGroupCode; Rec."Statistics Group Code")
                {
                    Caption = 'Statistics Group Code';
                }
                field(resourceNo; Rec."Resource No.")
                {
                    Caption = 'Resource No.';
                }
                field(salespersPurchCode; Rec."Salespers./Purch. Code")
                {
                    Caption = 'Salespers./Purch. Code';
                }
                field(kpiDeputationValue; Rec."KPI Deputation Value")
                {
                    Caption = 'KPI Deputation Value';
                }
                // field(approverCode; Rec."Approver Code")
                // {
                //     Caption = 'Approver Code';
                // }
                field(facebookUrl; Rec."Facebook Url")
                {
                    Caption = 'Facebook Url';
                }
                field(lastPlacementDate; Rec."Last Placement Date")
                {
                    Caption = 'Last Placement Date';
                }
                field(bankAccountNo; Rec."Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                }
                field(DisplayName; DisplayName)
                {
                    Caption = 'Bank Account No.';
                }
                field(taxCode; Rec."Tax Code")
                {
                    Caption = 'Tax Code';
                }
                field(attachment; ExportEmpImage)
                {
                    Caption = 'Employee Image';
                }
                // part(attachment; "Attachment Subform")
                // {
                //     EntityName = 'attachmentEntity';
                //     EntitySetName = 'attachmentEntities';
                //     SubPageLink = "Employee Code" = field("No.");
                // }
                field(permanentLocality; Rec."Permanent Locality")
                {

                }
                field(temporaryLocality; Rec."Temporary Locality")
                {

                }
                field(permanentWardNo; Rec."Permanent Ward No")
                {

                }
                field(servicePeriodText; Rec."Service Period Text")
                {

                }
                field(salarylevelDescription; Rec."Salary Level Description")
                {

                }

            }
        }
    }
    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        Rec.SetRange("No.", HrMgt.GetEmployeeNo());
    end;

    trigger OnAfterGetRecord()

    begin
        SetCalculatedFields;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        GraphMgtEmployee: Codeunit "Graph Mgt - Employee";
        RecRef: RecordRef;
    begin
        Insert(true);

        GraphMgtEmployee.ProcessComplexTypes(Rec, PostalAddressJSON);

        RecRef.GetTable(Rec);
        GraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef, TempFieldSet, CurrentDateTime);
        RecRef.SetTable(Rec);

        Modify(true);
        SetCalculatedFields;
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        Employee: Record Employee;
        GraphMgtEmployee: Codeunit "Graph Mgt - Employee";
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
    begin
        if xRec.SystemId <> SystemId then
            GraphMgtGeneralTools.ErrorIdImmutable;
        Employee.SetRange(SystemId, SystemId);
        Employee.FindFirst;

        GraphMgtEmployee.ProcessComplexTypes(Rec, PostalAddressJSON);

        if "No." = Employee."No." then
            Modify(true)
        else begin
            Employee.TransferFields(Rec, false);
            Employee.Rename("No.");
            TransferFields(Employee);
        end;

        SetCalculatedFields;
    end;

    var
        TempFieldSet: Record Field temporary;
        PostalAddressJSON: Text;
        DisplayName: Text;

    local procedure ExportEmpImage(): Text;
    var
        InStr: InStream;
        TempBlob: CodeUnit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        base64: Codeunit "Base64 Convert";
    begin
        if Rec.Image.HasValue then begin
            if ItemTenantMedia.Get(Rec.Image.MediaId) then begin
                ItemTenantMedia.CalcFields(Content);
                TempBlob.FromRecord(ItemTenantMedia, ItemTenantMedia.FieldNo(Content));
                TempBlob.CreateInStream(InStr);
                exit(base64.ToBase64(InStr));
            end;
        end;
    end;

    local procedure SetCalculatedFields();
    var
        GraphMgtEmployee: Codeunit "Graph Mgt - Employee";
    begin
        PostalAddressJSON := GraphMgtEmployee.PostalAddressToJSON(Rec);

        DisplayName := StrSubstNo('%1 %2 %3', "First Name", "Middle Name", "Last Name");
    end;

    local procedure ClearCalculatedFields();
    begin
        Clear(SystemId);
        Clear(PostalAddressJSON);
        TempFieldSet.DeleteAll;
    end;

    local procedure RegisterFieldSet(FieldNo: Integer);
    begin
        if TempFieldSet.Get(Database::Employee, FieldNo) then
            exit;

        TempFieldSet.Init;
        TempFieldSet.TableNo := Database::Employee;
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;
}
