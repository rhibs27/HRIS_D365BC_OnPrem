report 50100 "No objection letter(reg)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019901.NoObjectionletterReg.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where("Employment Type" = filter(Permanent));
            RequestFilterFields = "No.";
            column(No_Employee; Employee."No.") { }
            column(FullName_Employee; Employee."Full Name") { }
            column(EmploymentDate; Format(Employee."Employment Date")) { }
            column(DepartmentCode_Employee; Employee."Department Code") { }
            column(GlobalDimension1Code_Employee; Employee."Global Dimension 1 Code") { }
            column(CompanyPic; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(Amount; Amount) { }
            column(SalaryLevel_Employee; Employee."Salary Level") { }
            column(LevelName; LevelName) { }
            column(branch; branch) { }
            column(department; department) { }
            column(LastName_Employee; Employee."Last Name") { }
            column(referenceNo; ReferenceNo) { }
            column(TDate; Format(Today)) { }
            column(GenderValue; Gendervalue) { }
            column(GenderValue2; GenderValue2) { }
            column(GenderValue3; GenderValue3) { }
            column(GenderValue4; Gendervalue4) { }
            column(GenderValue5; Gendervalue5) { }
            column(deputation; deputation) { }
            column(DeputationCode; Employee."Deputation on") { }

            trigger OnAfterGetRecord()
            begin
                Employee.TestField("Employment Type", Employee."Employment Type"::Permanent);
                Amount := 0;
                SalaryLevelAttribute.Reset;
                SalaryLevelAttribute.SetRange("Level Code", Employee."Salary Level");
                SalaryLevelAttribute.SetRange("Grade Code", Employee."Salary Grade");
                if SalaryLevelAttribute.FindFirst then
                    Amount := SalaryLevelAttribute."Total Basic Salary" + SalaryLevelAttribute.Allowance;

                SalaryLevel.Reset;
                SalaryLevel.SetRange(Code, Employee."Salary Level");
                if SalaryLevel.FindFirst then
                    LevelName := SalaryLevel.Description;

                DimValue.Reset;
                DimValue.SetRange(Code, Employee."Global Dimension 1 Code");
                if DimValue.FindFirst then
                    branch := DimValue.Name;

                DimValue.Reset;
                DimValue.SetRange(Code, Employee."Department Code");
                if DimValue.FindFirst then
                    department := DimValue.Name;

                getGenderValue(Employee."No.");
                deputation := HRMgt.getDeputation(Employee."No.");

                LoanOutstandingfromFinacle.Reset;
                LoanOutstandingfromFinacle.SetRange("Employee No.", Employee."No.");
                LoanOutstandingfromFinacle.SetFilter("Loan Type", '<>%1', LoanOutstandingfromFinacle."Loan Type"::" ");
                if LoanOutstandingfromFinacle.FindFirst then
                    Error('You have outstanding loan pending');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Reference No."; ReferenceNo)
                {
                    ToolTip = 'Specifies the value of the ReferenceNo field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        SalaryLevelAttribute: Record "Level Wise Attributes";
        Amount: Decimal;
        SalaryLevel: Record "Salary Level";
        LevelName: Text;
        DimValue: Record "Dimension Value";
        branch: Text;
        department: Text;
        ReferenceNo: Text;
        Gendervalue: Text;
        GenderValue2: Text;
        GenderValue3: Text;
        Gendervalue4: Text;
        Gendervalue5: Text;
        deputation: Text;
        HRMgt: Codeunit "HR Mgt.";
        LoanOutstandingfromFinacle: Record "Loan Outstanding from Finacle";

    local procedure getGenderValue(empCode: Code[20])
    var
        Emp: Record Employee;
    begin
        Emp.Reset;
        Emp.SetRange("No.", empCode);
        if Emp.FindFirst then begin
            if Emp.Gender = Emp.Gender::Male then begin
                Gendervalue := 'Mr.';
                GenderValue2 := 'He';
                GenderValue3 := 'His';
                Gendervalue4 := 'he';
                Gendervalue5 := 'his';
            end else begin
                if Emp.Gender = Emp.Gender::Female then begin
                    if Emp."Marital Status" = Emp."Marital Status"::Single then
                        Gendervalue := 'Ms.'
                    else
                        Gendervalue := 'Mrs.';
                    GenderValue2 := 'She';
                    GenderValue3 := 'Her';
                    Gendervalue4 := 'she';
                    Gendervalue5 := 'her';
                end;
            end;
        end;
    end;
}
