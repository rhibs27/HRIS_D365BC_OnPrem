report 50062 "Employee on Leave"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019863.EmployeeonLeave.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Activity"; "Employee Activity")
        {
            DataItemTableView = where(Type = const("Leave Request"), Cancelled = const(false), "Cancelled No." = filter(''), "Cancelled Document No." = filter(''));
            column(No_; "No.") { }
            column(EmployeeNo_; "Employee No.") { }
            column(EmployeeName_; "Employee Name") { }
            column(ProvinceCode_; "Province Code") { }
            column(StartDate_; "Start Date") { }
            column(EndDate_; "End Date") { }
            column(LeaveCode_; "Leave Code") { }
            column(LeaveDescription_; "Leave Description") { }
            column(ApprovalStatus_; "Approval Status") { }
            column(RequestedDate_; "Requested Date") { }
            column(ApprovedDate_; "Approved Date") { }
            column(RecommenderName_; "Recommender Name") { }
            column(ApproverName_; "Approver Name") { }
            column(Title; Title) { }
            column(FilterCaption; FilterCaption) { }
            column(DeputationOn_; "Deputation On") { }
            column(ProvinceName_; Province.Description) { }
            column(NoofDays_; "No. of Days") { }
            column(DeputationName; DeputationName) { }

            trigger OnAfterGetRecord()
            begin
                Clear(Province);
                if Province.Get("Province Code") then;
                Clear(Employee);
                Clear(DeputationName);
                Employee.Get("Employee No.");
                DeputationName := ExitTransferDeputationWise(Employee."Deputation on");
            end;

            trigger OnPreDataItem()
            begin
                FilterGroup(-1);
                SetRange("Start Date", StartDate, EndDate);
                SetRange("End Date", StartDate, EndDate);
                FilterGroup(0);
            end;
        }
        dataitem(EmpActivity; "Employee Activity")
        {
            DataItemTableView = where(Type = const("Leave Request"), Cancelled = const(false), "Cancelled No." = filter(''), "Cancelled Document No." = filter(''));
            column(No2_; "No.") { }
            column(EmployeeNo2_; "Employee No.") { }
            column(EmployeeName2_; "Employee Name") { }
            column(ProvinceCode2_; "Province Code") { }
            column(StartDate2_; "Start Date") { }
            column(EndDate2_; "End Date") { }
            column(LeaveCode2_; "Leave Code") { }
            column(LeaveDescription2_; "Leave Description") { }
            column(ApprovalStatus2_; "Approval Status") { }
            column(RequestedDate2_; "Requested Date") { }
            column(ApprovedDate2_; "Approved Date") { }
            column(RecommenderName2_; "Recommender Name") { }
            column(ApproverName2_; "Approver Name") { }
            column(ProvinceName2_; Province2.Description) { }
            column(NoofDays2_; "No. of Days") { }
            column(DeputationOn2_; "Deputation On") { }
            column(DeputationName2; DeputationName2) { }

            trigger OnAfterGetRecord()
            begin
                Clear(Province2);
                if Province2.Get("Province Code") then;
                Clear(Employee);
                Employee.Get("Employee No.");
                Clear(DeputationName2);
                DeputationName2 := ExitTransferDeputationWise(Employee."Deputation on");
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Start Date", '<%1', StartDate);
                SetFilter("End Date", '>%1', EndDate);
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
                field(EndDate; EndDate)
                {
                    ToolTip = 'Specifies the value of the EndDate field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if StartDate = 0D then
                            Error('Start date must have value.');
                        if EndDate < StartDate then
                            Error('End date must be greater than start date.');
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
            StartDate := Today;
        if EndDate = 0D then
            EndDate := Today;
        if StartDate = EndDate then
            FilterCaption := 'Date Filter: ' + Format(StartDate)
        else
            FilterCaption := 'Date Filter: ' + Format(StartDate) + ' to ' + Format(EndDate);
        GLSetup.Get;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        Title: Label 'Employee on Leave';
        FilterCaption: Text;
        Province: Record Province;
        Province2: Record Province;
        DeputationName: Text;
        DeputationName2: Text;
        Employee: Record Employee;
        GLSetup: Record "General Ledger Setup";

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
