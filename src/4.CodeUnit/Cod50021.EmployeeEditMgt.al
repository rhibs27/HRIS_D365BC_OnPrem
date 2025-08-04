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
        EmployeeEditOnBeforeSendForApproval(EmployeeEdit);
        case EmployeeEdit."Changes In Employee Type" of
            EmployeeEditType::Details:
                begin
                    EmployeeDetails(EmployeeEdit);
                end;
            EmployeeEditType::Qualification:
                begin
                    EmployeeQualificationAdd(EmployeeEdit);
                end;
            EmployeeEditType::Achievement:
                begin
                    EmployeeAchievementAdd(EmployeeEdit);
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

        end;
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
                if EmployeeEdit."Temporary Province" <> '' then
                    Employee.Validate("Temporary Province", EmployeeEdit."Temporary Province");
                if EmployeeEdit."Temporary District" <> '' then
                    Employee.Validate("Temporary District", EmployeeEdit."Temporary District");
                if EmployeeEdit.VDC <> '' then
                    Employee.Validate("Temporary VDC", EmployeeEdit.VDC);
                if EmployeeEdit."Ward No." <> 0 then
                    Employee.Validate("Temporary Ward No", EmployeeEdit."Ward No.");
                if EmployeeEdit.House <> '' then
                    Employee.Validate("Temporary House", EmployeeEdit.House);
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
    begin
        EmployeeQualification.Init();
        EmployeeQualification.Validate("Line No.", GetNextLineNoQualification(EmployeeEditLine."Employee No."));
        EmployeeQualification.Validate("Employee No.", EmployeeEditLine."Employee No.");

        if EmployeeEditLine."Change in Emp Type" = EmployeeEditLine."Change in Emp Type"::Qualification then begin
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeQualification."Emp Qualification Type"::Education);
            EmployeeQualification.Validate("Qualification Type", EmployeeEditLine."Qualification Type");
            EmployeeQualification.Validate("Qualification Code", EmployeeEditLine."Qualification Code");
            EmployeeQualification.Validate(Stream, EmployeeEditLine.Stream);
            EmployeeQualification.Validate(Percentage, EmployeeEditLine.Percentage);
            EmployeeQualification.Validate(CGPA, EmployeeEditLine.CGPA);
        end;

        if EmployeeEditLine."Change in Emp Type" = EmployeeEditLine."Change in Emp Type"::"Work Experience" then begin
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeEditLine."employee Document Type"::Work);
            EmployeeQualification.Validate(Designation, EmployeeEditLine.Designation);
            EmployeeQualification.Validate(Remuneration, EmployeeEditLine.Remuneration);
        end;

        if EmployeeEditLine."Change in Emp Type" = EmployeeEditLine."Change in Emp Type"::Achievement then begin
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeEditLine."employee Document Type"::Achievement);
            EmployeeQualification.Validate(Designation, EmployeeEditLine.Designation);
            EmployeeQualification.Validate(Remuneration, EmployeeEditLine.Remuneration);
        end;

        EmployeeQualification.Validate("Institution/Company", EmployeeEditLine."Institution/Company");
        EmployeeQualification.Validate("From Date", EmployeeEditLine."From Date");
        EmployeeQualification.Validate("To Date", EmployeeEditLine."To Date");
        if EmployeeEditLine.Year <> '' then
            EmployeeQualification.Validate(Year, EmployeeEditLine.Year);
        EmployeeQualification.Validate(Description, EmployeeEditLine.Description);
        EmployeeQualification.Validate(Attachment, EmployeeEditLine.Attachment);
        EmployeeQualification.Insert();
    end;

    local procedure EmployeeAchievementAdd(var EmployeeEdit: Record "Employee Edit")
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
            EmployeeQualification.Init();
            EmployeeQualification.Validate("Line No.", GetNextLineNoQualification(EmployeeEdit."Employee No."));
            EmployeeQualification.Validate("Employee No.", EmployeeEdit."Employee No.");
            EmployeeQualification.Validate("Qualification Code", EmployeeEdit."Qualification Code");
            EmployeeQualification.Validate("Emp Qualification Type", EmployeeEdit."Emp Document Type"::Achievement);
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
            EmployeeRelative.Validate("VDC/Municipality", EmployeeEdit.VDC);
            EmployeeRelative.Validate("Ward No", EmployeeEdit."Ward No.");
            EmployeeRelative.Validate("E-mail", EmployeeEdit."Relative Mail");
            EmployeeRelative.Validate("Set Emergency Contact", EmployeeEdit."Set Emergency Contact");
            EmployeeRelative.Insert();
        end;
    end;

    procedure EmployeeRelativeAddFromLine(EmployeeEditLine: Record "Employee Edit Line")
    var
        EmployeeRelative: Record "Employee Relative";
    begin
        EmployeeRelative.Init();
        EmployeeRelative.Validate("Line No.", GetNextLineNoRelative(EmployeeEditLine."Employee No."));
        EmployeeRelative.Validate("Employee No.", EmployeeEditLine."Employee No.");
        EmployeeRelative.Validate("Relative Code", EmployeeEditLine."Relative Code");
        EmployeeRelative.Validate("Full Name", EmployeeEditLine."Full Name");
        EmployeeRelative.Validate("Relative's Employee No.", EmployeeEditLine."Relative's Employee No.");
        EmployeeRelative.Validate("Phone No.", EmployeeEditLine."Relative Phone No.");
        EmployeeRelative.Validate(Employee_BOD, EmployeeEditLine."Employee Relative In Bank");
        // EmployeeRelative.Validate("Citizenship No.", EmployeeEditLine."CitizenShip No.");
        EmployeeRelative.Validate("Birth Date", EmployeeEditLine."Birth Date");
        EmployeeRelative.Validate(District, EmployeeEditLine."Relative District");
        // EmployeeRelative.Validate("VDC/Municipality", EmployeeEditLine.VDC);
        EmployeeRelative.Validate("Ward No", EmployeeEditLine."Ward No.");
        // EmployeeRelative.Validate("E-mail", EmployeeEditLine."Relative Mail");
        // EmployeeRelative.Validate("Set Emergency Contact", EmployeeEditLine."Set Emergency Contact");
        EmployeeRelative.Insert();
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
        LanguageProficiency.init();
        LanguageProficiency.Validate("Line No.", GetNextLineNoLanguageProficency(EmployeeEditLine."Employee No."));
        LanguageProficiency.Validate("Employee Code", EmployeeEditLine."Employee No.");
        LanguageProficiency.Validate(Language, EmployeeEditLine.Language);
        LanguageProficiency.Validate(Reading, EmployeeEditLine.Reading);
        LanguageProficiency.Validate(Writing, EmployeeEditLine.Writing);
        LanguageProficiency.Validate(Speaking, EmployeeEditLine.Speaking);
        LanguageProficiency.Validate(Typing, EmployeeEditLine.Typing);
        LanguageProficiency.Insert();
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

    procedure EmployeeEditOnBeforeSendForApproval(EmployeeEdit: Record "Employee Edit")
    var
        EmployeeEditLine: Record "Employee Edit Line";
    begin
        EmployeeEdit.TestField("Employee No.");
        EmployeeEditLine.SetRange("Document No.", EmployeeEdit."No.");
        if EmployeeEditLine.FindSet() then
            EmployeeEditLine.ModifyAll("Employee No.", EmployeeEdit."Employee No.", false);
    end;
}