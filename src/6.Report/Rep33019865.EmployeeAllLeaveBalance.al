report 33019865 "Employee All Leave Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019865.EmployeeAllLeaveBalance.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "Employment Type";
            column(No_; "No.") { }
            column(EmployeeName_; "Full Name") { }
            column(Title; Title) { }
            column(FilterCaption; FilterCaption) { }
            dataitem("Leave Type Setup"; "Leave Type Setup")
            {
                DataItemLink = "Employee No. Filter" = field("No.");
                column(LeaveCode_; Code) { }
                column(LeaveDescription_; Description) { }
                column(RemainingDays_; "Remaining Days") { }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Remaining Days");
                end;
            }

            trigger OnPreDataItem()
            begin
                FilterCaption := Employee.GetFilters;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        FilterCaption: Text;
}
