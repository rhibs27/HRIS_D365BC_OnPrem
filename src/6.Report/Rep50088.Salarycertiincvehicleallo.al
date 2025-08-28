report 50088 "Salary certi(inc vehicle allo)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019889.SalaryCertiIncVehicleAllo.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            dataitem(Employee; Employee)
            {
                DataItemTableView = where("Employment Type" = filter(Permanent | Probation));
                RequestFilterFields = "No.";
                column(No_Employee; Employee."No.") { }
                column(FullName_Employee; Employee."Full Name") { }
                column(Date; Format(Employee."Employment Date")) { }
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
                column(FromDate; Format(FromDate)) { }
                column(ToDate; Format(ToDate)) { }
                column(VehicleAllowance; VehicleAllowance) { }
                column(referenceNo; referenceNo) { }
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
                    //IF (Employee."Employment Type" <> Employee."Employment Type"::Permanent) OR (Employee."Employment Type" <> Employee."Employment Type"::Probation) THEN
                    //ERROR('Employee Type must be Probation or Permanent.');
                    Amount := 0;
                    PostedPayrollLine.Reset;
                    PostedPayrollLine.SetRange("Employee No.", Employee."No.");
                    //PostedPayrollLine.SetRange("Grade Code",Employee."Salary Grade");
                    PostedPayrollLine.SetRange(Reversed, false);
                    PostedPayrollLine.SetRange("Posting Date", FromDate, ToDate);
                    if PostedPayrollLine.FindFirst then
                        repeat
                            Amount := PostedPayrollLine."Basic Salary" + PostedPayrollLine."Current Benefit";
                        until PostedPayrollLine.Next = 0;

                    VehicleAllowance := 0;
                    SalaryLevelAttribute.Reset;
                    SalaryLevelAttribute.SetRange("Level Code", Employee."Salary Level");
                    SalaryLevelAttribute.SetRange("Grade Code", Employee."Salary Grade");
                    if SalaryLevelAttribute.FindFirst then
                        VehicleAllowance := SalaryLevelAttribute."Staff Vehicle Allowance";

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
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(FiscalYear; FiscalYear)
                {
                    Caption = 'Fiscal Year';
                    TableRelation = "Pay Cycle Term";
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Reference No."; referenceNo)
                {
                    ToolTip = 'Specifies the value of the referenceNo field.';
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

    trigger OnPreReport()
    begin
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Code", FiscalYear);
        PayCyclePeriod.FindFirst;
        FromDate := PayCyclePeriod."Start Date";

        PayCyclePeriod.FindLast;
        ToDate := PayCyclePeriod."End Date";

        if referenceNo = '' then
            Error('Please enter refernce no.');

        if Employee.GetFilter("No.") = '' then
            Error('Please enter No. in employee.');
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
        PostedPayrollLine: Record "Posted Payroll Line";
        FromDate: Date;
        ToDate: Date;
        VehicleAllowance: Decimal;
        PayCyclePeriod: Record "Pay Cycle Period";
        FiscalYear: Code[20];
        referenceNo: Text;
        Gendervalue: Text;
        GenderValue2: Text;
        GenderValue3: Text;
        Gendervalue4: Text;
        Gendervalue5: Text;
        deputation: Text;
        HRMgt: Codeunit "HR Mgt.";

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
