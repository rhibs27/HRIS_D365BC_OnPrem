report 50063 "Employee Working Hour"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019864.EmployeeWorkingHour.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Attendance & Activity"; "Employee Attendance & Activity")
        {
            column(EmployeeNo_; "Employee No.") { }
            column(AttendanceDate_; "Attendance Date") { }
            column(CheckInTime_; Format("Check In Time")) { }
            column(CheckOutTime_; Format("Check Out Time")) { }
            column(ActualHour; Format(AcutalHour)) { }
            column(EmployeeName; Employee."Full Name") { }
            column(NavLoginID; Employee."NAV Login ID") { }
            column(Title; Title) { }
            column(FilterCaption; FilterCaption) { }
            column(DeputationOn; Employee."Deputation on") { }
            column(DeputationName; DeputationName) { }

            trigger OnAfterGetRecord()
            begin
                Clear(Employee);
                if Employee.Get("Employee No.") then;
                AcutalHour := Round("Actual Work Time" / 3600000, 0.01, '=');
                Clear(DeputationName);
                DeputationName := ExitTransferDeputationWise(Employee."Deputation on");
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Attendance Date", StartDate, EndDate);
                SetFilter("Actual Work Time", '>=%1', WorkingHour * 3600000);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(Year; Year)
                {
                    Caption = 'Nepali Year';
                    ToolTip = 'Specifies the value of the Nepali Year field.';
                    ApplicationArea = All;
                }
                field(Month; Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field("Working Hour"; WorkingHour)
                {
                    ToolTip = 'Specifies the value of the WorkingHour field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        WorkingHour := 12;
    end;

    trigger OnPreReport()
    begin
        if Year = 0 then
            Error('Please type the Year.');
        if Month = Month::" " then
            Error('Please choose the month.');
        EngNepDate.Reset;
        EngNepDate.SetRange("Nepali Year", Year);
        EngNepDate.SetRange("Nepali Month", Month);
        if EngNepDate.FindFirst then
            StartDate := EngNepDate."English Date";

        Clear(EngNepDate);
        EngNepDate.Reset;
        EngNepDate.SetRange("Nepali Year", Year);
        EngNepDate.SetRange("Nepali Month", Month);
        if EngNepDate.FindLast then
            EndDate := EngNepDate."English Date";
        FilterCaption := 'Year: ' + Format(Year);
        FilterCaption += ', Month: ' + Format(Month);
        FilterCaption += ',Hours More than: ' + Format(AcutalHour);
    end;

    var
        Year: Integer;
        Month: Enum "Nepali Month";
        WorkingHour: Integer;
        EngNepDate: Record "English-Nepali Date";
        FilterCaption: Text;
        StartDate: Date;
        EndDate: Date;
        Employee: Record Employee;
        AcutalHour: Decimal;
        Title: Label 'List of Employee Working Hours';
        DeputationName: Text;

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
}
