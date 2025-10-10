report 50068 "Resignation Memo"
{
    RDLCLayout = './src/6.Report/Rep33019869.ResignationMemo.rdl';
    WordLayout = './src/6.Report/Rep33019869.ResignationMemo.docx';
    DefaultLayout = Word;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Activity"; "Employee Activity")
        {
            DataItemTableView = where(Type = const(Resignation));
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(EmployeeName; "Employee Name") { }
            column(EmployeeNo; "Employee No.") { }
            column(DeputationName; DeputationName) { }
            column(SalaryLevelDescription; SalaryLevel.Description) { }
            column(FunctionalTitleDescription; FunctionalTitle.Description) { }
            column(ResignedDate; GetDateFormat("HR Proposed Date")) { }
            column(RecommenderName; "Recommender Name") { }
            column(FunctionalTitleDescription1; FunctionTitle1.Description) { }
            column(RequestedDate; GetDateFormat("Requested Date")) { }
            column(Pronoun1; Pronoun1) { }
            column(Pronoun2; Pronoun2) { }
            column(Pronoun3; Pronoun3) { }
            column(ReasonforResignation; Reasontxt) { }
            column(EmploymentType; Employee."Employment Type") { }
            column(NoDays; NoDays) { }
            column(Body2; Body2) { }
            column(No; "No.") { }
            column(WaiverCase; "Waiver Case") { }
            column(Body1; Body1) { }
            column(CurrentDate; GetDateFormat(Today)) { }
            column(IzoneUserId; Format("Izone User Id")) { }
            column(VPN; Format(VPN)) { }
            column(OCAS; Format(OCAS)) { }
            column(FinacleUserId; Format("Finacle User Id")) { }
            column(EmailId; Format("Email Id")) { }
            column(SwiftUserId; Format("Swift User Id")) { }
            column(OtherIfAny; Format("Other If Any")) { }
            column(Whatsapp; Whatsapp) { }
            column(PreparedByName; PreparedBy."Full Name") { }
            column(PreparedDes; PreparedDes) { }
            column(SupportedBy1FullName; SupportedBy1."Full Name") { }
            column(SupportBy1Desc; SupportBy1Desc) { }
            column(SupportBy2Desc; SupportBy2Desc) { }
            column(SupportedBy2FullName; SupportedBy2."Full Name") { }
            column(SupportedBy3FullName; SupportedBy3."Full Name") { }
            column(SupportBy3Desc; SupportBy3Desc) { }
            column(SupportedBy4FullName; SupportedBy4."Full Name") { }
            column(SupportBy4Desc; SupportBy4Desc) { }
            column(ApprovedByFullName; ApprovedBy."Full Name") { }
            column(ApprovedByDesc; ApprovedByDesc) { }

            trigger OnAfterGetRecord()
            begin
                Clear(Pronoun1);
                Clear(Pronoun2);
                Clear(Pronoun3);
                Clear(Body1);
                Clear(Body2);
                SalaryLevel.Get("Salary Level Code");
                Clear(DeputationName);
                FunctionalTitle.Get("Functional Title");
                Employee.Get("Employee No.");
                DeputationName := ExitTransferDeputationWise(Employee."Deputation on");
                Employee1.Get("Recommender Code");
                FunctionTitle1.Get(Employee1."Functional Title");
                if Employee.Gender = Employee.Gender then begin
                    Pronoun1 := 'he';
                    Pronoun2 := 'his';
                    Pronoun3 := 'him';
                end else begin
                    Pronoun1 := 'she';
                    Pronoun2 := 'her';
                    Pronoun3 := 'her';
                end;
                if Employee."Employment Type" = Employee."Employment Type"::Contract then
                    NoDays := HRSetup."Resignation Period Contract"
                else if Employee."Employment Type" = Employee."Employment Type"::Permanent then
                    NoDays := HRSetup."Resignation Period Permanent"
                else
                    NoDays := HRSetup."Resignation Period Probation";
                if "Employee Activity"."Waiver Case" = "Employee Activity"."Waiver Case"::Normal then
                    Body1 := StrSubstNo('Hence, it is recommended to accept his resignation with effect from close of business hour %1.', GetDateFormat("HR Proposed Date"))
                else begin
                    Body2 := StrSubstNo(Bodytwo, Employee."Employment Type", NoDays);
                    if "Apply for Waiver" then
                        Body2 += ' ' + StrSubstNo(AppliedWaiver, Pronoun2, GetDateFormat("HR Proposed Date"))
                    else
                        Body2 += ' ' + StrSubstNo(NotAppliedWaiver, Pronoun2, GetDateFormat("HR Proposed Date"));
                end;
                if "Employee Activity"."Reason Code" = 'FUTHER STUDY' then
                    Reasontxt := StrSubstNo('%1 wants to continue %2 futher studies.', Pronoun1, Pronoun2)
                else if "Employee Activity"."Reason Code" = 'GOING ABROAD' then
                    Reasontxt := StrSubstNo('%1 is going abroad.', Pronoun1)
                else if "Employee Activity"."Reason Code" = 'DISSATISFY' then
                    Reasontxt := StrSubstNo('%1 is not statisfied with %2 job.', Pronoun1, Pronoun2)
                else if "Employee Activity"."Reason Code" = 'START UP' then
                    Reasontxt := StrSubstNo('%1 wants to start up %2 own business.', Pronoun1, Pronoun2)
                else
                    Reasontxt := '(reason for resignation)';
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Supported By"; SupportedBy1."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        HRSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
         if not HrMgt.IsSaaS() then
        PreparedBy.Get(HRMgt.GetEmployeeNo);
        PreparedDes := GetSalaryLevel(PreparedBy) + '-' + GetFunctionalTitle(PreparedBy);
        SupportBy1Desc := GetSalaryLevel(SupportedBy1) + '-' + GetFunctionalTitle(SupportedBy1);

        SupportedBy2.Reset;
        SupportedBy2.SetRange("Functional Title", 'MDTMD');
        if SupportedBy2.FindFirst then
            SupportBy2Desc := GetSalaryLevel(SupportedBy2) + '-' + GetFunctionalTitle(SupportedBy2);

        SupportedBy3.Reset;
        SupportedBy3.SetRange("Functional Title", 'HDTMDGB');
        if SupportedBy3.FindFirst then
            SupportBy3Desc := GetSalaryLevel(SupportedBy3) + '-' + GetFunctionalTitle(SupportedBy3);
        SupportedBy4.Reset;
        SupportedBy4.SetRange("Salary Level", 'DCEO');
        if SupportedBy4.FindFirst then
            SupportBy4Desc := GetSalaryLevel(SupportedBy4);

        ApprovedBy.Reset;
        ApprovedBy.SetRange("Salary Level", 'CEO');
        if ApprovedBy.FindFirst then
            ApprovedByDesc := GetSalaryLevel(ApprovedBy);
    end;

    var
        SalaryLevel: Record "Salary Level";
        FunctionalTitle: Record "Functional Title";
        Employee: Record Employee;
        DeputationName: Text;
        Employee1: Record Employee;
        FunctionTitle1: Record "Functional Title";
        Pronoun1: Text;
        Pronoun2: Text;
        Pronoun3: Text;
        HRSetup: Record "Human Resources Setup";
        NoDays: Integer;
        Body2: Text;
        NotAppliedWaiver: Label 'Hence, it is recommended to recover shortfall notice period charge and accept %1 resignation with effect from close of business hour %2.';
        AppliedWaiver: Label 'However, it is recommended to waive shortfall notice period charge as per recommendation of %1 line manager and accept %1 resignation with effect from close of business hour %2.';
        CompanyInfo: Record "Company Information";
        Body1: Text;
        Bodytwo: Label 'According to Staff Service ByLaws 2073, Clause No. 64, %1 staff needs to give %2 days'' prior notice in case of leaving the Bank on his/her own accord. If an employee decides to leave the bank for whatever the whatever reason, without giving %2 days'' prior notice period, staff shall be required to pay salary and allowance for shortfall notice period as per staff service bylaws.';
        Reasontxt: Text;
        PreparedBy: Record Employee;
        SupportedBy1: Record Employee;
        SupportedBy2: Record Employee;
        SupportedBy3: Record Employee;
        ApprovedBy: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        PreparedDes: Text;
        SupportBy1Desc: Text;
        SupportBy2Desc: Text;
        SupportBy3Desc: Text;
        ApprovedByDesc: Text;
        SupportedBy4: Record Employee;
        SupportBy4Desc: Text;

    local procedure ExitTransferDeputationWise(DeputationOn: Enum "Deputation Type"): Text
    var
    // DimValue: Record "Dimension Value";
    // Depart: Record Department;
    // EmpHie: Record "Employee Hierarchy Master";
    // SubProvince: Record "Sub Province";
    // Province: Record Province;
    begin
        // Clear(DimValue);
        // Clear(Depart);
        // Clear(EmpHie);
        // Clear(SubProvince);
        // Clear(Province);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    // if DimValue.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then
                    exit(Employee."Branch Name");
                end;

            DeputationOn::Department:
                begin
                    // if Depart.Get(Employee."Department Code") then
                    exit(Employee."Department Name");
                end;

            DeputationOn::"Extension Counter":
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    // EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    // if EmpHie.FindFirst then
                    exit(Employee."Extension Counter Name");
                end;

            // DeputationOn::"Sub Province":
            //     begin
            //         SubProvince.Reset;
            //         SubProvince.SetRange(Code, Employee."Sub Province Code");
            //         if SubProvince.FindFirst then
            //             exit(SubProvince.City);
            //     end;

            DeputationOn::Unit:
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    // EmpHie.SetRange(Code, Employee."Unit Code");
                    // if EmpHie.FindFirst then
                    exit(Employee."Unit Name");
                end;

            DeputationOn::Province:
                begin
                    // if Province.Get(Employee."Province Code") then
                    exit(Employee."Province Name");
                end;
        end;
    end;

    procedure GetDateFormat(parameterDate: Date): Text
    var
        EngNepDate: Record "English-Nepali Date";
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", parameterDate);
        if EngNepDate.FindFirst then
            exit(StrSubstNo('%1 %2, %3', EngNepDate."English Month", EngNepDate."English Day", EngNepDate."English Year"));
    end;

    local procedure GetFunctionalTitle(EmpVar: Record Employee): Text
    var
        FunctTiltle: Record "Functional Title";
        OrganizationStructureList: Record "Organization Structure List";
    // Depart: Record Department;
    begin
        if OrganizationStructureList.Get(OrganizationStructureList.type::Department, EmpVar."Department Code") then
            exit(OrganizationStructureList.Name)
        else
            if FunctTiltle.Get(EmpVar."Functional Title") then
                exit(FunctTiltle.Description);
    end;

    local procedure GetSalaryLevel(EmpVar: Record Employee): Text
    var
        SalLevel: Record "Salary Level";
    begin
        if SalLevel.Get(EmpVar."Salary Level") then
            exit(SalLevel.Description);
    end;
}
