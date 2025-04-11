report 50016 "Employee Approval Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019816.EmployeeApprovalReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(FullName_Employee; Employee."Full Name") { }
            column(FunctionalTitle_Employee; Employee."Functional Title") { }
            column(No_Employee; Employee."No.") { }
            column(GlobalDimension1Code_Employee; Employee."Global Dimension 1 Code") { }
            column(Province_Employee; Employee."Province Code") { }
            // column(PostCode_Employee; Employee."Sub Province Code") { }
            column(Unit_Employee; Employee."Unit Code") { }
            column(DepartmentCode_Employee; Employee."Department Code") { }
            // column(ReportingLine1_Employee; Employee."Reporting Line 1") { }
            // column(ReprotingLine2_Employee; Employee."Reporting Line 2") { }
            // column(EcoSystem_Employee; Employee."Eco-System") { }
            // column(Office_Employee; Employee.Office) { }
            column(EmpRankValue; FunctionalTitle."Rank Value") { }
            column(EmpRankCheck; FunctionalTitle."Rank Check Range") { }
            column(temp1; Temp1) { }
            column(temp2; Temp2) { }
            column(temp3; Temp3) { }
            column(temp4; Temp4) { }
            column(RecommenderFunctional; Emp1."Functional Title") { }
            column(ApproverFunctional; Emp2."Functional Title") { }

            trigger OnAfterGetRecord()
            begin
                if not FunctionalTitle.Get(Employee."Functional Title") then
                    CurrReport.Skip;

                Clear(LoanMgt);
                Temp1 := '';
                Temp2 := '';
                Temp3 := '';
                Temp4 := '';

                LoanMgt.UpdateApproval(Employee, Temp1, Temp2, Temp3, Temp4, false);

                // if UpdateEmployee then begin
                //     Employee.Validate("KPI Deputation Value", CopyStr(Temp1, 1, 20));
                //     Employee.Validate("Approver Code", CopyStr(Temp2, 1, 20));
                //     Modify;
                // end;

                Clear(Emp1);
                Clear(Emp2);
                if StrPos(Temp1, '|') = 0 then
                    if Emp1.Get(Temp1) then;
                if StrPos(Temp2, '|') = 0 then
                    if Emp2.Get(Temp2) then;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field("Update Employee Table"; UpdateEmployee)
                    {
                        ToolTip = 'Specifies the value of the UpdateEmployee field.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    var
        FunctionalTitle: Record "Functional Title";
        Emp1: Record Employee;
        Emp2: Record Employee;
        LoanMgt: Codeunit "Loan Mgt.";
        Temp1: Code[150];
        Temp2: Code[250];
        Temp3: Text;
        Temp4: Text;
        UpdateEmployee: Boolean;
}
