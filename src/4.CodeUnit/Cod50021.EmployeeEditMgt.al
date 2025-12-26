codeunit 50021 "Employee Edit Mgt."
{
    trigger OnRun()
    begin
    end;

    procedure ApproveChangesInEmployee(EmployeeEditCode: Code[100])
    var
        EmployeeEdit: Record "Employee Edit";
        EmployeeEditType: Enum "Employee Edit Type";
    begin
        EmployeeEdit.get(EmployeeEditCode);
        EmployeeEditOnBeforeApprove(EmployeeEdit);
        case EmployeeEdit."Changes In Employee Type" of
            EmployeeEditType::Details:
                begin
                    EmployeeDetails(EmployeeEdit);
                end;
            EmployeeEditType::Qualification:
                begin
                    EmployeeQualificationAdd(EmployeeEdit);
                end;
            EmployeeEditType::"Work Experience":
                begin
                    EmployeeWorkAdd(EmployeeEdit);
                end;
            EmployeeEditType::Relative:
                begin
                    EmployeeRelativeAdd(EmployeeEdit);
                end;
            EmployeeEditType::Language:
                begin
                    EmployeeLanguageAdd(EmployeeEdit);
                end;
            EmployeeEditType::"Additional Documents":
                ImportEditLineAttachmentsToEmployee(EmployeeEdit."No.");
            EmployeeEditType::"Vehicle Info Update":
                EmployeevehicleInfoUpdate(EmployeeEdit."No.");
            EmployeeEditType::"Marital Status Update":
                EmployeeMaritalStatusUpdate(EmployeeEdit."No.");
        end;
        CreatePayrollAttrUsesOnApprovedEmployeeEdit(EmployeeEdit);
    end;

    local procedure EmployeeDetails(Var EmployeeEdit: Record "Employee Edit")
    var
        Employee: Record Employee;
    begin
        if EmployeeEdit."Changes In Employee Type" = EmployeeEdit."Changes In Employee Type"::Details then begin
            if Employee.Get(EmployeeEdit."Employee No.") then begin
                if EmployeeEdit."Mobile No." <> '' then
                    Employee.Validate("Mobile Phone No.", EmployeeEdit."Mobile No.");
                if EmployeeEdit."Marital Status" <> EmployeeEdit."Marital Status"::" " then
                    Employee.Validate("Marital Status", EmployeeEdit."Marital Status");
                if EmployeeEdit."Email (Personal)" <> '' then
                    Employee.Validate("E-Mail", EmployeeEdit."Email (Personal)");
                Employee.Validate(Disabled, EmployeeEdit."Differently Able");
                if EmployeeEdit."Vehicle Type" <> EmployeeEdit."Vehicle Type"::" " then
                    Employee.Validate("Vehicle Type", EmployeeEdit."Vehicle Type");
                if EmployeeEdit."Permanent Province" <> '' then
                    Employee.Validate("Permanent Province", EmployeeEdit."Permanent Province");
                if EmployeeEdit."Permanent District" <> '' then
                    Employee.Validate("Permanent District", EmployeeEdit."Permanent District");
                if EmployeeEdit."Permanent VDC" <> '' then
                    Employee.Validate("Permanent VDC", EmployeeEdit."Permanent VDC");
                if EmployeeEdit."Permanent Ward No" <> 0 then
                    Employee.Validate("Permanent Ward No", EmployeeEdit."Permanent Ward No");
                if EmployeeEdit."Permanent Locality" <> '' then
                    Employee.Validate("Permanent Locality", EmployeeEdit."Permanent Locality");
                if EmployeeEdit."Permanent House" <> '' then
                    Employee.Validate("Permanent House", EmployeeEdit."Permanent House");
                if EmployeeEdit."Temporary Province" <> '' then
                    Employee.Validate("Temporary Province", EmployeeEdit."Temporary Province");
                if EmployeeEdit."Temporary District" <> '' then
                    Employee.Validate("Temporary District", EmployeeEdit."Temporary District");
                if EmployeeEdit."Temporary VDC" <> '' then
                    Employee.Validate("Temporary VDC", EmployeeEdit."Temporary VDC");
                if EmployeeEdit."Temporary Ward No" <> 0 then
                    Employee.Validate("Temporary Ward No", EmployeeEdit."Temporary Ward No");
                if EmployeeEdit."Temporary Locality" <> '' then
                    Employee.Validate("Temporary Locality", EmployeeEdit."Temporary Locality");
                if EmployeeEdit."Temporary House" <> '' then
                    Employee.Validate("Temporary House", EmployeeEdit."Temporary House");
                if EmployeeEdit."Blood Group" <> EmployeeEdit."Blood Group"::" " then
                    Employee.Validate("Blood Group", EmployeeEdit."Blood Group");
                if EmployeeEdit.Religion <> EmployeeEdit.Religion::" " then
                    Employee.Validate(Religion, EmployeeEdit.Religion);
                if EmployeeEdit.Attachment.HasValue() then
                    Employee.Validate(Image, EmployeeEdit.Attachment);
                //Official document
                if EmployeeEdit."Passport No." <> '' then
                    Employee.Validate("Passport Number", EmployeeEdit."Passport No.");
                if EmployeeEdit."CitizenShip No." <> '' then
                    Employee.Validate("Citizen Number", EmployeeEdit."CitizenShip No.");
                if EmployeeEdit."CitizenShip Issue Date" <> 0D then
                    Employee.Validate("Citizenship Issue Date", EmployeeEdit."CitizenShip Issue Date");
                if EmployeeEdit."NID No." <> '' then
                    Employee.Validate("NID No", EmployeeEdit."NID No.");
                if EmployeeEdit."Driving License No." <> '' then
                    Employee.Validate("Driving License No.", EmployeeEdit."Driving License No.");
                OnApproveEmployeeEditOnbeforeModifyEmployee(EmployeeEdit, Employee);
                Employee.Modify();
            end;
        end;
    end;

    local procedure EmployeeQualificationAdd(Var EmployeeEdit: Record "Employee Edit")
    var
        EmployeeQualification: Record "Employee Qualification";
        EmployeeEditLine: Record "Employee Edit Line";
    begin
        EmployeeEditLine.SetRange("Document No.", EmployeeEdit."No.");
        if EmployeeEditLine.FindSet() then begin
            repeat
                EmployeeQualificationAddFromLine(EmployeeEditLine);
            until EmployeeEditLine.Next() = 0;
        end else begin
            //old code will be removed
            EmployeeQualification.Init();
            EmployeeQualification.Validate("Line No.", GetNextLineNoQualification(EmployeeEdit."Employee No."));
            EmployeeQualification.Validate("Employee No.", EmployeeEdit."Employee No.");
            EmployeeQualification.Validate("Qualification Code", EmployeeEdit."Qualification Code");
            EmployeeQualification.Validate("Qualification Type", EmployeeEdit."Qualification Type");
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeEdit."Emp Document Type"::Education);
            EmployeeQualification.Validate(Stream, EmployeeEdit.Stream);
            EmployeeQualification.Validate("Institution/Company", EmployeeEdit."Institution/Company");
            EmployeeQualification.Validate("From Date", EmployeeEdit."From Date");
            EmployeeQualification.Validate("To Date", EmployeeEdit."To Date");
            EmployeeQualification.Validate(Year, EmployeeEdit.Year);
            EmployeeQualification.Validate(Percentage, EmployeeEdit.Percentage);
            EmployeeQualification.Validate(CGPA, EmployeeEdit.CGPA);
            EmployeeQualification.Validate(Description, EmployeeEdit.Description);
            EmployeeQualification.Validate(Attachment, EmployeeEdit.Attachment);
            EmployeeQualification.Insert();
        end;
    end;

    procedure GetNextLineNoQualification(EmpNo: Code[20]): Integer
    var
        EmployeeQualification1: Record "Employee Qualification";
    begin
        EmployeeQualification1.SetRange("Employee No.", EmpNo);
        if EmployeeQualification1.FindLast() then
            exit(EmployeeQualification1."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure EmployeeQualificationAddFromLine(EmployeeEditLine: Record "Employee Edit Line")
    var
        EmployeeQualification: Record "Employee Qualification";
        EmployeeNo: Code[20];
        QualificationMaster: Record Qualification;
    begin
        if EmployeeEditLine."Original Line No." = 0 then begin
            EmployeeQualification.Init();
            EmployeeQualification.Validate("Line No.", GetNextLineNoQualification(EmployeeEditLine."Employee No."));
        end
        else begin
            EmployeeQualification.SetRange("Employee No.", EmployeeEditLine."Employee No.");
            EmployeeQualification.SetRange("Line No.", EmployeeEditLine."Original Line No.");
            EmployeeQualification.FindFirst();
        end;
        EmployeeQualification.Validate("Employee No.", EmployeeEditLine."Employee No.");
        if EmployeeEditLine."Change in Emp Type" = EmployeeEditLine."Change in Emp Type"::Qualification then begin
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeQualification."Emp Qualification Type"::Education);
            EmployeeQualification.Validate("Qualification Code", EmployeeEditLine."Qualification Code");
            EmployeeQualification.Validate(Stream, EmployeeEditLine.Stream);
            EmployeeQualification.Validate(Percentage, EmployeeEditLine.Percentage);
            EmployeeQualification.Validate("GPA Scale", EmployeeEditLine."GPA Scale");
            EmployeeQualification.Validate(CGPA, EmployeeEditLine.CGPA);
        end;
        if EmployeeEditLine."Change in Emp Type" = EmployeeEditLine."Change in Emp Type"::"Work Experience" then begin
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeEditLine."employee Document Type");
            QualificationMaster.SetRange(Type, EmployeeEditLine."Employee Document Type");
            if QualificationMaster.FindFirst() then
                EmployeeQualification.Validate("Qualification Code", QualificationMaster.Code);
            EmployeeQualification.Validate(Designation, EmployeeEditLine.Designation);
            EmployeeQualification.Validate(Remuneration, EmployeeEditLine.Remuneration);
            EmployeeQualification.Validate(Description, EmployeeEditLine.Description);
        end;
        EmployeeQualification.Validate(Running, EmployeeEditLine.Running);
        EmployeeQualification.Validate("Institution/Company", EmployeeEditLine."Institution/Company");
        EmployeeQualification.Validate("From Date", EmployeeEditLine."From Date");
        EmployeeQualification.Validate("To Date", EmployeeEditLine."To Date");
        if EmployeeEditLine.Year <> '' then
            EmployeeQualification.Validate(Year, EmployeeEditLine.Year);
        EmployeeQualification.Validate(Attachment, EmployeeEditLine.Attachment);
        if EmployeeEditLine."Original Line No." = 0 then
            EmployeeQualification.Insert()
        else
            EmployeeQualification.Modify();
    end;

    local procedure EmployeeWorkAdd(var EmployeeEdit: Record "Employee Edit")
    var
        EmployeeQualification: Record "Employee Qualification";
        EmployeeQualification1: Record "Employee Qualification";
        EmployeeEditLine: Record "Employee Edit Line";
    begin
        EmployeeEditLine.SetRange("Document No.", EmployeeEdit."No.");
        if EmployeeEditLine.FindSet() then begin
            repeat
                EmployeeQualificationAddFromLine(EmployeeEditLine);
            until EmployeeEditLine.Next() = 0;
        end else begin
            //old code will be removed
            EmployeeQualification.Init();
            EmployeeQualification.Validate("Line No.", GetNextLineNoQualification(EmployeeEdit."Employee No."));
            EmployeeQualification.Validate("Employee No.", EmployeeEdit."Employee No.");
            EmployeeQualification.Validate("Qualification Code", EmployeeEdit."Qualification Code");
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeEdit."Emp Document Type"::Work);
            EmployeeQualification.Validate("Institution/Company", EmployeeEdit."Institution/Company");
            EmployeeQualification.Validate("From Date", EmployeeEdit."From Date");
            EmployeeQualification.Validate("To Date", EmployeeEdit."To Date");
            EmployeeQualification.Validate(Description, EmployeeEdit.Description);
            EmployeeQualification.Validate(Designation, EmployeeEdit.Designation);
            EmployeeQualification.Validate(Remuneration, EmployeeEdit.Remuneration);
            EmployeeQualification.Validate(Attachment, EmployeeEdit.Attachment);
            EmployeeQualification.Insert();
        end;
    end;

    local procedure EmployeeRelativeAdd(var EmployeeEdit: Record "Employee Edit")
    var
        EmployeeRelative: Record "Employee Relative";
        EmployeeRelative1: Record "Employee Relative";
        EmployeeEditLine: Record "Employee Edit Line";
        LineNo: Integer;
    begin
        EmployeeEditLine.SetRange("Document No.", EmployeeEdit."No.");
        if EmployeeEditLine.FindSet() then begin
            repeat
                EmployeeRelativeAddFromLine(EmployeeEditLine);
            until EmployeeEditLine.Next() = 0;
        end else begin
            EmployeeRelative.Init();
            EmployeeRelative.Validate("Line No.", GetNextLineNoRelative(EmployeeEdit."Employee No."));
            EmployeeRelative.Validate("Employee No.", EmployeeEdit."Employee No.");
            EmployeeRelative.Validate("Relative Code", EmployeeEdit."Relative Code");
            EmployeeRelative.Validate("Full Name", EmployeeEdit."Full Name");
            EmployeeRelative.Validate("Relative's Employee No.", EmployeeEdit."Relative's Employee No.");
            EmployeeRelative.Validate("Phone No.", EmployeeEdit."Relative Phone No.");
            EmployeeRelative.Validate(Employee_BOD, EmployeeEdit."Employee Relative In Bank");
            EmployeeRelative.Validate("Citizenship No.", EmployeeEdit."CitizenShip No.");
            EmployeeRelative.Validate("Birth Date", EmployeeEdit."Birth Date");
            EmployeeRelative.Validate(District, EmployeeEdit."Relative District");
            // EmployeeRelative.Validate("VDC/Municipality", EmployeeEdit.VDC);
            EmployeeRelative.Validate("Ward No", EmployeeEdit."Ward No.");
            EmployeeRelative.Validate("E-mail", EmployeeEdit."Relative Mail");
            EmployeeRelative.Validate("Set Emergency Contact", EmployeeEdit."Set Emergency Contact");
            EmployeeRelative.Validate("Set Nominee", EmployeeEdit."Set Nominee");
            EmployeeRelative.Insert();
        end;
    end;

    procedure EmployeeRelativeAddFromLine(EmployeeEditLine: Record "Employee Edit Line")
    var
        EmployeeRelative: Record "Employee Relative";
    begin
        if EmployeeEditLine."Original Line No." = 0 then begin
            EmployeeRelative.Init();
            EmployeeRelative.Validate("Line No.", GetNextLineNoRelative(EmployeeEditLine."Employee No."));
        end else begin
            EmployeeRelative.SetRange("Employee No.", EmployeeEditLine."Employee No.");
            EmployeeRelative.SetRange("Line No.", EmployeeEditLine."Original Line No.");
            EmployeeRelative.FindFirst();
        end;
        EmployeeRelative.Validate("Employee No.", EmployeeEditLine."Employee No.");
        EmployeeRelative.Validate("Relative Code", EmployeeEditLine."Relative Code");
        EmployeeRelative.Validate("First Name", EmployeeEditLine."First Name");
        EmployeeRelative.Validate("Middle Name", EmployeeEditLine."Middle Name");
        EmployeeRelative.Validate("Last Name", EmployeeEditLine."Last Name");
        EmployeeRelative.Validate("Full Name", EmployeeEditLine."Full Name");
        EmployeeRelative.Validate("Relative's Employee No.", EmployeeEditLine."Relative's Employee No.");
        EmployeeRelative.Validate("Phone No.", EmployeeEditLine."Relative Phone No.");
        EmployeeRelative.Validate(Employee_BOD, EmployeeEditLine."Employee Relative In Bank");
        EmployeeRelative.Validate("Citizenship No.", EmployeeEditLine."Relative CitizenShip No.");
        EmployeeRelative.Validate("Birth Date", EmployeeEditLine."Birth Date");
        EmployeeRelative.Validate(District, EmployeeEditLine."Relative District");
        EmployeeRelative.Validate("VDC/Municipality", EmployeeEditLine.VDC);
        EmployeeRelative.Validate("Ward No", EmployeeEditLine."Ward No.");
        EmployeeRelative.Validate("E-mail", EmployeeEditLine."Relative Mail");
        EmployeeRelative.Validate("Set Emergency Contact", EmployeeEditLine."Set Emergency Contact");
        EmployeeRelative.validate("Set Nominee", EmployeeEditLine."Set Nominee");
        EmployeeRelative.Validate("lt.", EmployeeEditLine."lt.");
        if EmployeeEditLine."Original Line No." = 0 then
            EmployeeRelative.Insert()
        else
            EmployeeRelative.Modify();
    end;

    procedure GetNextLineNoRelative(EmpNo: Code[20]): Integer
    var
        EmployeeRelative: Record "Employee Relative";
    begin
        EmployeeRelative.SetRange("Employee No.", EmpNo);
        if EmployeeRelative.FindLast() then
            exit(EmployeeRelative."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure GetNextLineNoLanguageProficency(EmpNo: Code[20]): Integer
    var
        LanguageProficiency: Record "Language Proficiency";
    begin
        LanguageProficiency.SetRange("Employee Code", EmpNo);
        if LanguageProficiency.FindLast() then
            exit(LanguageProficiency."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure AddEmployeeLanguageproficifromLine(EmployeeEditLine: Record "Employee Edit Line")
    var
        LanguageProficiency: Record "Language Proficiency";
    begin
        if EmployeeEditLine."Original Line No." = 0 then begin
            LanguageProficiency.init();
            LanguageProficiency.Validate("Line No.", GetNextLineNoLanguageProficency(EmployeeEditLine."Employee No."));
        end else begin
            LanguageProficiency.SetRange("Employee Code", EmployeeEditLine."Employee No.");
            LanguageProficiency.SetRange("Line No.", EmployeeEditLine."Original Line No.");
            LanguageProficiency.FindFirst();
        end;
        LanguageProficiency.Validate("Employee Code", EmployeeEditLine."Employee No.");
        LanguageProficiency.Validate(Language, EmployeeEditLine.Language);
        LanguageProficiency.Validate(Reading, EmployeeEditLine.Reading);
        LanguageProficiency.Validate(Writing, EmployeeEditLine.Writing);
        LanguageProficiency.Validate(Speaking, EmployeeEditLine.Speaking);
        LanguageProficiency.Validate(Typing, EmployeeEditLine.Typing);
        if EmployeeEditLine."Original Line No." = 0 then
            LanguageProficiency.Insert()
        else
            LanguageProficiency.Modify();
    end;

    local procedure EmployeeLanguageAdd(var EmployeeEdit: Record "Employee Edit")
    var
        LanguageProficiency: Record "Language Proficiency";
        LanguageProficiency1: Record "Language Proficiency";
        EmployeeEditLine: Record "Employee Edit Line";
    begin
        EmployeeEditLine.SetRange("Document No.", EmployeeEdit."No.");
        if EmployeeEditLine.FindSet() then begin
            repeat
                AddEmployeeLanguageproficifromLine(EmployeeEditLine);
            until EmployeeEditLine.Next() = 0;
        end else begin
            //old code will removed
            //Check same Language Code
            LanguageProficiency1.Reset();
            LanguageProficiency1.SetRange("Employee Code", EmployeeEdit."Employee No.");
            LanguageProficiency1.SetRange(Language, EmployeeEdit.Language);
            if LanguageProficiency1.findfirst then
                LanguageProficiency1.Deleteall();
            //Insert New language
            LanguageProficiency.Init();
            LanguageProficiency.Validate("Line No.", GetNextLineNoLanguageProficency(EmployeeEdit."Employee No."));
            LanguageProficiency.Validate("Employee Code", EmployeeEdit."Employee No.");
            LanguageProficiency.Validate(Language, EmployeeEdit.Language);
            LanguageProficiency.Validate(Reading, EmployeeEdit.Reading);
            LanguageProficiency.Validate(Writing, EmployeeEdit.Writing);
            LanguageProficiency.Validate(Speaking, EmployeeEdit.Speaking);
            LanguageProficiency.Validate(Typing, EmployeeEdit.Typing);
            LanguageProficiency.Insert();
        end;
    end;

    procedure EmployeeEditOnBeforeApprove(EmployeeEdit: Record "Employee Edit")
    var
        EmployeeEditLine: Record "Employee Edit Line";
        EmployeeEdit2: Record "Employee Edit";
        AssignmentMemoHeader: Record "Assignment Memo Header";
        PayrollAttributes: Record "Payroll Attributes";
        IsHandled: Boolean;
    begin
        EmployeeEdit.TestField("Employee No.");
        EmployeeEditLine.SetRange("Document No.", EmployeeEdit."No.");
        if EmployeeEditLine.FindSet() then
            EmployeeEditLine.ModifyAll("Employee No.", EmployeeEdit."Employee No.", false);

        //This has link to transportation and transportation reimbursement. If not needed you can skip this via setup or integration event.
        if EmployeeEdit."Changes In Employee Type" = EmployeeEdit."Changes In Employee Type"::"Vehicle Info Update" then begin
            EmployeeEdit.TestField("Vehicle Type");
            EmployeeEdit.TestField("Claim Type");
            EmployeeEdit.TestField("Claimed Type Effective Date");

            if EmployeeEdit."Vehicle Type" in [EmployeeEdit."Vehicle Type"::" ", EmployeeEdit."Vehicle Type"::"No Vehicle"] then begin
                EmployeeEdit.TestField("Vehicle No.", '');
                EmployeeEdit.TestField("Vehicle Owner Name", '');
            end else begin
                EmployeeEdit.TestField("Vehicle No.");
                EmployeeEdit.TestField("Vehicle Owner Name");
                EmployeeEdit.TestField("Ownership Start/End Date");
                if EmployeeEdit."Vehicle Type" = EmployeeEdit."Vehicle Type"::"Four Wheeler" then
                    EmployeeEdit.TestField("Fuel Type");
            end;
        end;

        //check for attachment mandatory
        CheckAttachmentmandatoryForEmployeeEdit(EmployeeEdit)
    end;

    procedure ImportEditLineAttachmentsToEmployee(EmployeeEditNo: Code[20])
    var
        EmployeeEditLine: Record "Employee Edit Line";
        EmployeeEdit: Record "Employee Edit";
        Employee: Record Employee;
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        FileExtension: Text;
        ToTableId: Integer;
        DocumentAttachment: Record "Document Attachment";
        InStr: InStream;
        OutStr: OutStream;
    begin
        ToTableId := Database::Employee;
        if not EmployeeEdit.Get(EmployeeEditNo) then
            exit;
        if not Employee.Get(EmployeeEdit."Employee No.") then
            exit;
        EmployeeEditLine.SetRange("Document No.", EmployeeEditNo);
        if EmployeeEditLine.FindSet() then
            repeat
                if EmployeeEditLine.Attachment.HasValue() then begin
                    FileName := EmployeeEditLine.Description;
                    if FileName = '' then
                        FileName := 'Attachment';
                    // Get file extension from Attachment field
                    FileExtension := GetMediaFileExtension(EmployeeEditLine.Attachment.MediaId(), FileName);
                    TempBlob.CreateOutStream(OutStr);
                    EmployeeEditLine.Attachment.ExportStream(OutStr);
                    Employee.Get(EmployeeEditLine."Employee No.");
                    FromRecRef.GetTable(Employee);
                    Clear(DocumentAttachment);
                    DocumentAttachment.Init();
                    DocumentAttachment."Table ID" := Database::Employee;
                    DocumentAttachment."No." := EmployeeEditLine."Employee No.";
                    DocumentAttachment."Line No." := EmployeeEditLine."Line No.";
                    DocumentAttachment."File Name" := FileName;
                    DocumentAttachment."File Extension" := FileExtension;
                    DocumentAttachment."Attachment Document Type" := EmployeeEditLine."Attachment Document Type";
                    DocumentAttachment.SaveAttachment(FromRecRef, FileName, TempBlob);
                end;
            until EmployeeEditLine.Next() = 0;
    end;

    procedure GetMediaFileExtension(MediaId: Guid; var FileName: Text): Text
    var
        TenantMedia: Record "Tenant Media";
        InStr: InStream;
    begin
        if not TenantMedia.Get(MediaId) then
            exit('');
        if TenantMedia.Description <> '' then
            FileName := TenantMedia.Description;
        exit(LowerCase(GetFileExtension(FileName)));
    end;

    procedure GetFileExtension(FileName: Text): Text
    var
        DotPos: Integer;
    begin
        DotPos := StrPos(FileName, '.');
        if DotPos > 0 then
            exit(CopyStr(FileName, DotPos + 1))
        else
            exit('');
    end;

    procedure EmployeeMaritalStatusUpdate(EmpEditNo: Code[20])
    var
        Employee: Record Employee;
        EmployeeEdit: Record "Employee Edit";
        EmployeeRelative: Record "Employee Relative";
        Relative: Record Relative;
    begin
        EmployeeEdit.Get(EmpEditNo);
        if EmployeeEdit."Changes In Employee Type" = EmployeeEdit."Changes In Employee Type"::"Marital Status Update" then begin
            if Employee.Get(EmployeeEdit."Employee No.") then begin
                Employee.Validate("Marital Status", EmployeeEdit."Marital Status");
                Employee.Modify();
            end;
            //also update the employee relatives
            EmployeeRelative.SetRange("Employee No.", EmployeeEdit."Employee No.");
            EmployeeRelative.SetRange(Relationship, EmployeeRelative.Relationship::Spouse);
            if EmployeeRelative.FindFirst() then begin
                EmployeeRelative.Validate("Full Name", EmployeeEdit."Spouse Name");
                EmployeeRelative.Validate("Birth Date", EmployeeEdit."Spouse DOB");
                EmployeeRelative.Validate("Citizenship No.", EmployeeEdit."Spouse citizenship No.");
                EmployeeRelative.Validate("Citizenship Issued District", EmployeeEdit."Spouse Citiz. Issued Place");
                EmployeeRelative.Modify();
            end
            else begin
                Relative.SetRange(Relation, Relative.Relation::Spouse);
                Relative.FindFirst();

                EmployeeRelative.Init();
                EmployeeRelative.Validate("Line No.", GetNextLineNoRelative(EmployeeEdit."Employee No."));
                EmployeeRelative.Validate("Employee No.", EmployeeEdit."Employee No.");
                EmployeeRelative.Validate("Relative Code", Relative.Code);
                EmployeeRelative.Validate("Full Name", EmployeeEdit."Spouse Name");
                EmployeeRelative.Validate("Birth Date", EmployeeEdit."Spouse DOB");
                EmployeeRelative.Validate("Citizenship No.", EmployeeEdit."Spouse citizenship No.");
                EmployeeRelative.Validate("Citizenship Issued District", EmployeeEdit."Spouse Citiz. Issued Place");
                EmployeeRelative.Insert();
            end;
            ImportEmployeeEditLineAttachmentsToEmployee(EmpEditNo);
        end;
    end;

    procedure EmployeevehicleInfoUpdate(EmpEditNo: Code[20])
    var
        Employee: Record Employee;
        EmployeeEdit: Record "Employee Edit";
        isHandled: Boolean;
    begin
        EmployeeEdit.Get(EmpEditNo);
        if EmployeeEdit."Changes In Employee Type" = EmployeeEdit."Changes In Employee Type"::"Vehicle Info Update" then begin
            if Employee.Get(EmployeeEdit."Employee No.") then begin
                if EmployeeEdit."Vehicle Type" <> EmployeeEdit."Vehicle Type"::" " then begin
                    Employee.Validate("Vehicle Type", EmployeeEdit."Vehicle Type");
                    Employee.Validate("Vehicle No.", EmployeeEdit."Vehicle No.");
                    Employee.Validate("Vehicle Owner Name", EmployeeEdit."Vehicle Owner Name");
                    Employee.Validate("Ownership Start/End Date", EmployeeEdit."Ownership Start/End Date");
                    Employee.Modify();
                end;
                ImportEmployeeEditLineAttachmentsToEmployee(EmpEditNo);

                OnAfterEmployeeVehicleInfoUpdate(EmployeeEdit, Employee, isHandled);  //auto insert transportation request if clain type is transportation
            end;
        end;
    end;

    procedure ImportEmployeeEditLineAttachmentsToEmployee(EmployeeEditNo: Code[20])
    var

        EmployeeEdit: Record "Employee Edit";
        Employee: Record Employee;
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        FileExtension: Text;
        ToTableId: Integer;
        DocumentAttachment: Record "Document Attachment";
        InStr: InStream;
        OutStr: OutStream;
    begin
        ToTableId := Database::Employee;
        if not EmployeeEdit.Get(EmployeeEditNo) then
            exit;
        if not Employee.Get(EmployeeEdit."Employee No.") then
            exit;

        if EmployeeEdit.Attachment.HasValue() then begin
            FileName := Format(EmployeeEdit."Changes In Employee Type") + '-Attachment-' + EmployeeEdit."Employee No.";
            if FileName = '' then
                FileName := 'Attachment';
            // Get file extension from Attachment field
            FileExtension := GetMediaFileExtension(EmployeeEdit.Attachment.MediaId(), FileName);
            if FileName = '.' + FileExtension then
                FileName := Format(EmployeeEdit."Changes In Employee Type") + '-Attachment-' + EmployeeEdit."Employee No." + '.' + FileExtension;
            TempBlob.CreateOutStream(OutStr);
            EmployeeEdit.Attachment.ExportStream(OutStr);
            Employee.Get(EmployeeEdit."Employee No.");
            FromRecRef.GetTable(Employee);
            Clear(DocumentAttachment);
            DocumentAttachment.Init();
            DocumentAttachment."Table ID" := Database::Employee;
            DocumentAttachment."No." := EmployeeEdit."Employee No.";
            DocumentAttachment."File Name" := FileName;
            DocumentAttachment."File Extension" := FileExtension;
            DocumentAttachment."Attachment Document Type" := EmployeeEdit."Attachment Code";
            DocumentAttachment.SaveAttachment(FromRecRef, FileName, TempBlob);
        end;
    end;

    procedure EmployeeEditSendForApproval(EmployeeEditCode: Code[20])
    var
        EmployeeEdit: Record "Employee Edit";
        ApprovalHRMS: Record "Approval HRMS";
    begin
        EmployeeEdit.get(EmployeeEditCode);
        EmployeeEditOnBeforeApprove(EmployeeEdit);
        EmployeeEdit."Approval Status" := EmployeeEdit."Approval Status"::Pending;
        EmployeeEdit.Modify();

        ApprovalHRMS.SetRange("Document No.", EmployeeEdit."No.");
        ApprovalHRMS.SetRange("Approval Sequence", 1);
        ApprovalHRMS.SetRange("Approval Status", ApprovalHRMS."Approval Status"::Created);
        if ApprovalHRMS.FindSet() then
            ApprovalHRMS.ModifyAll("Approval Status", ApprovalHRMS."Approval Status"::Open);

        Message('Approval request has been sent.');
    end;

    procedure CheckAttachmentmandatoryForEmployeeEdit(var EmployeeEdit: Record "Employee Edit")
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        AttachmentSetup.SetRange(Mandatory, true);
        case EmployeeEdit."Changes In Employee Type" of
            EmployeeEdit."Changes In Employee Type"::Qualification:
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Education);
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
                end;
            EmployeeEdit."Changes In Employee Type"::"Work Experience",
            EmployeeEdit."Changes In Employee Type"::Achievement:
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Work Experience");
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
                end;
            EmployeeEdit."Changes In Employee Type"::"Vehicle Info Update":
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Profile");
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Vehicle Info Update");
                    if AttachmentSetup.FindFirst() then begin
                        if not EmployeeEdit.Attachment.HasValue() then
                            if not (EmployeeEdit."Vehicle Type" in [EmployeeEdit."Vehicle Type"::" ", EmployeeEdit."Vehicle Type"::"No Vehicle"]) then
                                Error('Attachment is mandatory for %1. Please attach the required document.', Format(EmployeeEdit."Changes In Employee Type"));
                    end;
                end;
            EmployeeEdit."Changes In Employee Type"::Details:
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Profile");
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
                end;
        end;
    end;

    procedure CreatePayrollAttrUsesOnApprovedEmployeeEdit(var EmployeeEdit: Record "Employee Edit")
    var
        PayrollAtttrUses, PayrollAtttrUses2 : Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
    begin
        if EmployeeEdit."Claim Type" = '' then
            exit;
        if not PayrollAttributes.Get(EmployeeEdit."Claim Type") then
            exit;

        PayrollAtttrUses2.SetRange("Employee Code", EmployeeEdit."Employee No.");
        PayrollAtttrUses2.SetRange(code, EmployeeEdit."Claim Type");
        if not PayrollAtttrUses2.FindFirst() then begin
            PayrollAtttrUses.Init();
            PayrollAtttrUses.Validate("Employee Code", EmployeeEdit."Employee No.");
            PayrollAtttrUses.Validate(code, EmployeeEdit."Claim Type");
            if PayrollAtttrUses.Insert(true) then;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApproveEmployeeEditOnbeforeModifyEmployee(var EmployeeEdit: Record "Employee Edit"; var Employee: Record Employee);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterEmployeeVehicleInfoUpdate(var EmployeeEdit: Record "Employee Edit"; var Employee: Record Employee; var IsHandled: Boolean)
    begin
    end;
}