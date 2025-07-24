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
        EmployeeQualification1: Record "Employee Qualification";
    begin
        EmployeeQualification1.Reset();
        EmployeeQualification.Init();
        EmployeeQualification1.SetRange("Employee No.", EmployeeEdit."Employee No.");
        if EmployeeQualification1.FindLast() then
            EmployeeQualification.Validate("Line No.", EmployeeQualification1."Line No." + 10000)
        else
            EmployeeQualification.Validate("Line No.", 10000);
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

    local procedure EmployeeAchievementAdd(var EmployeeEdit: Record "Employee Edit")
    var
        EmployeeQualification: Record "Employee Qualification";
        EmployeeQualification1: Record "Employee Qualification";
    begin
        EmployeeQualification1.Reset();
        EmployeeQualification.Init();
        EmployeeQualification1.SetRange("Employee No.", EmployeeEdit."Employee No.");
        if EmployeeQualification1.FindLast() then
            EmployeeQualification.Validate("Line No.", EmployeeQualification1."Line No." + 10000)
        else
            EmployeeQualification.Validate("Line No.", 10000);
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

    local procedure EmployeeWorkAdd(var EmployeeEdit: Record "Employee Edit")
    var
        EmployeeQualification: Record "Employee Qualification";
        EmployeeQualification1: Record "Employee Qualification";
    begin
        EmployeeQualification1.Reset();
        EmployeeQualification.Init();
        EmployeeQualification1.SetRange("Employee No.", EmployeeEdit."Employee No.");
        if EmployeeQualification1.FindLast() then
            EmployeeQualification.Validate("Line No.", EmployeeQualification1."Line No." + 10000)
        else
            EmployeeQualification.Validate("Line No.", 10000);
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

    local procedure EmployeeRelativeAdd(var EmployeeEdit: Record "Employee Edit")
    var
        EmployeeRelative: Record "Employee Relative";
        EmployeeRelative1: Record "Employee Relative";
    begin
        EmployeeRelative1.Reset();
        EmployeeRelative.Init();
        EmployeeRelative1.SetRange("Employee No.", EmployeeEdit."Employee No.");
        if EmployeeRelative1.FindLast() then
            EmployeeRelative.Validate("Line No.", EmployeeRelative1."Line No." + 10000)
        else
            EmployeeRelative.Validate("Line No.", 10000);
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
        EmployeeRelative.Insert();
    end;

    local procedure EmployeeLanguageAdd(var EmployeeEdit: Record "Employee Edit")
    var
        LanguageProficiency: Record "Language Proficiency";
        LanguageProficiency1: Record "Language Proficiency";
    begin
        //Check same Language Code
        LanguageProficiency1.Reset();
        LanguageProficiency1.SetRange("Employee Code", EmployeeEdit."Employee No.");
        LanguageProficiency1.SetRange(Language, EmployeeEdit.Language);
        if LanguageProficiency1.findfirst then
            LanguageProficiency1.Deleteall();
        //Insert New language 
        LanguageProficiency1.Reset();
        LanguageProficiency.Init();
        LanguageProficiency1.SetRange("Employee Code", EmployeeEdit."Employee No.");
        if LanguageProficiency1.FindLast() then
            LanguageProficiency.Validate("Line No.", LanguageProficiency1."Line No." + 10000)
        else
            LanguageProficiency.Validate("Line No.", 10000);
        LanguageProficiency.Validate("Employee Code", EmployeeEdit."Employee No.");
        LanguageProficiency.Validate(Language, EmployeeEdit.Language);
        LanguageProficiency.Validate(Reading, EmployeeEdit.Reading);
        LanguageProficiency.Validate(Writing, EmployeeEdit.Writing);
        LanguageProficiency.Validate(Speaking, EmployeeEdit.Speaking);
        LanguageProficiency.Validate(Typing, EmployeeEdit.Typing);
        LanguageProficiency.Insert();
    end;
}