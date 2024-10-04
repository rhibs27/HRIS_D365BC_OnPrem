report 33019866 "No Punch In Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019866.NoPunchInReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Attendance & Activity"; "Employee Attendance & Activity")
        {
            column(EmployeeNo_; "Employee No.") { }
            column(EmployeeName_; Employee."Full Name") { }
            column(AttendanceDate_; "Attendance Date") { }
            column(DeputationOn_; Employee."Deputation on") { }
            column(ProvinceName_; Employee."Province Name") { }
            column(SubProvinceName_; Employee."Sub Province Name") { }
            column(BranchName_; Employee."Branch Name") { }
            column(DepartmentName_; Employee."Department Name") { }
            column(FilterCaption; FilterCaption) { }
            column(Title; Title) { }
            column(DeputationOn; Employee."Deputation on") { }
            column(DeputationName; DeputationName) { }

            trigger OnAfterGetRecord()
            begin
                Clear(Employee);
                if Employee.Get("Employee No.") then;
                Clear(DeputationName);
                DeputationName := ExitTransferDeputationWise(Employee."Deputation on");
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Attendance Date", StartDate, EndDate);
                SetFilter("Check In Time", '%1', 0T);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Start Date"; StartDate)
                {
                    ToolTip = 'Specifies the value of the StartDate field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Clear(EndDate);
                    end;
                }
                field("End Date"; EndDate)
                {
                    ToolTip = 'Specifies the value of the EndDate field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if StartDate = 0D then
                            Error('Start Date must have value.');
                        if StartDate > EndDate then
                            Error('End Date must be greater than start date.');
                    end;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        if StartDate = 0D then
            Error('Start Date must have value.');
        if EndDate = 0D then
            Error('End Date must have value.');
        if StartDate = EndDate then
            FilterCaption := 'Date Filter: ' + Format(StartDate)
        else
            FilterCaption := 'Date Filter: ' + Format(StartDate) + ' To ' + Format(EndDate);
    end;

    var
        Employee: Record Employee;
        StartDate: Date;
        EndDate: Date;
        Title: Label 'No Punch In Report';
        FilterCaption: Text;
        DeputationName: Text;

    local procedure ExitTransferDeputationWise(DeputationOn: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department): Text
    var
        DimValue: Record "Dimension Value";
        Depart: Record Department;
        EmpHie: Record "Employee Hierarchy Master";
        SubProvince: Record "Sub Province";
        Province: Record Province;
        GLSetup: Record "General Ledger Setup";
    begin
        Clear(DimValue);
        Clear(Depart);
        Clear(EmpHie);
        Clear(SubProvince);
        Clear(Province);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if DimValue.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then
                        exit(DimValue.Name);
                end;

            DeputationOn::Department:
                begin
                    if Depart.Get(Employee."Department Code") then
                        exit(Depart.Name);
                end;

            DeputationOn::"Extension Counter":
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Description);
                end;

            DeputationOn::"Sub Province":
                begin
                    SubProvince.Reset;
                    SubProvince.SetRange(Code, Employee."Sub Province Code");
                    if SubProvince.FindFirst then
                        exit(SubProvince.City);
                end;

            DeputationOn::Unit:
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    EmpHie.SetRange(Code, Employee."Extension Counter Code");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Description);
                end;

            DeputationOn::Province:
                begin
                    if Province.Get(Employee."Province Code") then
                        exit(Province.Description);
                end;
        end;
    end;
}
