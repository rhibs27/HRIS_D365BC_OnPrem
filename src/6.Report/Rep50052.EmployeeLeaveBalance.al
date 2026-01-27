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
                    OpeningLeave := 0;
                    EarnedLeave := 0;
                    UsedDays := 0;
                    ClosingLeave := 0;

                    LeaveEarn[1].SetLoadFields("Balancing Days");
                    LeaveEarn[1].SetRange("Employee No.", Employee."No.");
                    LeaveEarn[1].SetRange("Leave Code", Code);
                    LeaveEarn[1].SetFilter("Posted Date", '<%1', LeaveYearStartDate);
                    LeaveEarn[1].CalcSums("Balancing Days");
                    OpeningLeave := LeaveEarn[1]."Balancing Days";

                    LeaveEarn[2].SetLoadFields("Balancing Days");
                    LeaveEarn[2].SetRange("Employee No.", Employee."No.");
                    LeaveEarn[2].SetRange("Leave Code", Code);
                    LeaveEarn[2].Setfilter(Type, '%1|%2', LeaveEarn[2].Type::Earned, LeaveEarn[2].Type::Adjustment);
                    LeaveEarn[2].SetRange("Posted Date", LeaveYearStartDate, LeaveYearEndDate);
                    LeaveEarn[2].CalcSums("Balancing Days");
                    EarnedLeave := LeaveEarn[2]."Balancing Days";

                    LeaveEarn[3].SetLoadFields("Balancing Days");
                    LeaveEarn[3].SetRange("Employee No.", Employee."No.");
                    LeaveEarn[3].SetRange("Leave Code", Code);
                    LeaveEarn[3].SetRange("Posted Date", LeaveYearStartDate, LeaveYearEndDate);
                    LeaveEarn[3].Setfilter(Type, '%1|%2|%3|%4',
                      LeaveEarn[3].Type::Used,
                      LeaveEarn[3].Type::Cancelled,
                      LeaveEarn[3].Type::Encashed,
                      LeaveEarn[3].Type::Collapsed);
                    LeaveEarn[3].CalcSums("Balancing Days");
                    UsedDays := Abs(LeaveEarn[3]."Balancing Days");

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
        LeaveEarn: array[5] of Record "Leave Earn";
        ClosingLeave: Decimal;
        Leaveperiod: Record "Accounting Period";
        LeaveYearStartDate, LeaveYearEndDate : Date;

}
