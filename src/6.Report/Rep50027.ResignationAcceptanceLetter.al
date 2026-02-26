report 50027 "Resignation Acceptance Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019828.ResignationAcceptanceLetter.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Resignation; Resignation)
        {
            column(FullName; "Employee Name") { }
            column(Employee_No_; "Employee No.") { }
            column(LastName; LastName) { }
            column(Salutation; Salutation) { }
            column(Designation; Designation) { }
            column(RequestedDate; "Requested Date") { }
            column(EffectiveDate; "Approved Last Working Day" + 1) { }
            column(LastWorkingDay; "Approved Last Working Day") { }
            column(CEO; CEO) { }
            column(PrintedBy; UserId) { }

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Employee No.");
                Salutation := Employee.Salutation;
                Designation := Employee."Salary Level Description";
                LastName := Employee."Last Name";

                Employee.Reset();
                Employee.SetFilter("Salary Level", 'CEO');
                if Employee.FindFirst() then
                    CEO := Employee."Full Name";
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    var
        Salutation: Enum Salutation;
        LastName: Text[20];
        Designation: Text[50];
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        CEO: Text[50];
}
