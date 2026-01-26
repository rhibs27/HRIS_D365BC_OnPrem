report 50052 "Employee Leave Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50052.EmployeeLeaveBalance.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(Title; Title) { }
            column(ToDate; TillDate) { }

        }
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Employment Type", Status;
            column(EmpNo; "No.") { }
            column(EmpName; "Full Name") { }
            dataitem("Leave Type Setup"; "Leave Type Setup")
            {
                DataItemLink = "Employee No. Filter" = field("No.");
                RequestFilterFields = "Code";
                column(LeaveCode; Code) { }
                column(LeaveDescription; Description) { }
                column(LeaveBalance; Format(ClosingLeave)) { }
                column(OpeningLeave; Format(OpeningLeave)) { }
                column(UsedLeave; Format(UsedDays)) { }
                column(EarnedLeave; Format(EarnedLeave)) { }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Remaining Days");
                    Clear(OpeningLeave);
                    Clear(EarnedLeave);
                    Clear(UsedDays);
                    Clear(ClosingLeave);
                    LeaveEarn.Reset;
                    LeaveEarn.SetLoadFields("Balancing Days");
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", Code);
                    LeaveEarn.SetFilter("Posted Date", '<%1', LeaveYearStartDate);
                    LeaveEarn.CalcSums("Balancing Days");
                    OpeningLeave := LeaveEarn."Balancing Days";

                    LeaveEarn.Reset;
                    LeaveEarn.SetLoadFields("Balancing Days");
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", Code);
                    LeaveEarn.Setfilter(Type, '%1|%2', LeaveEarn.Type::Earned, LeaveEarn.Type::Adjustment);
                    LeaveEarn.SetRange("Posted Date", LeaveYearStartDate, LeaveYearEndDate);
                    LeaveEarn.CalcSums("Balancing Days");
                    EarnedLeave := LeaveEarn."Balancing Days";

                    LeaveEarn.Reset;
                    LeaveEarn.SetLoadFields("Balancing Days");
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", Code);
                    LeaveEarn.SetRange("Posted Date", LeaveYearStartDate, LeaveYearEndDate);
                    LeaveEarn.Setfilter(Type, '%1|%2|%3|%4',
                      LeaveEarn.Type::Used,
                      LeaveEarn.Type::Cancelled,
                      LeaveEarn.Type::Encashed,
                      LeaveEarn.Type::Collapsed);
                    LeaveEarn.CalcSums("Balancing Days");
                    UsedDays := Abs(LeaveEarn."Balancing Days");

                    ClosingLeave := OpeningLeave + EarnedLeave - UsedDays;
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
                field("As of"; TillDate)
                {
                    ToolTip = 'Specifies the value of the TillDate field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        TillDate := WorkDate();
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        if TillDate = 0D then
            TillDate := Today;

        LeaveYearStartDate := Leaveperiod.GetLeaveYearStartDate(TillDate);
        LeaveYearEndDate := Leaveperiod.GetLeaveYearEndDate(TillDate);
    end;

    var
        CompanyInfo: Record "Company Information";
        TillDate: Date;
        Title: Label 'Employee Leave Balance';
        UsedDays: Decimal;
        EarnedLeave: Decimal;
        OpeningLeave: Decimal;
        LeaveEarn: Record "Leave Earn";
        ClosingLeave: Decimal;
        Leaveperiod: Record "Accounting Period";
        LeaveYearStartDate, LeaveYearEndDate : Date;

}
