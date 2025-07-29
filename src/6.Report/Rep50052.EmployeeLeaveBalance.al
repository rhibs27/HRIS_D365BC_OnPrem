report 50052 "Employee Leave Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019853.EmployeeLeaveBalance.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(Title; Title) { }
            column(FromDate; Today) { }
            column(ToDate; TillDate) { }
            column(FiscalYear; FiscalYear) { }
            column(xFiscalYear; xFiscalYear) { }
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
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", Code);
                    if Employee."Employment Type" = Employee."Employment Type"::Permanent then begin
                        LeaveEarn.SetRange("Fiscal year", FiscalYear);//LeaveEarn.SETFILTER("Posted Date",'%1..%2',0D,EngNepDate."English Date"-1);
                        LeaveEarn.SetRange(Type, LeaveEarn.Type::CarryForward);
                    end else
                        LeaveEarn.SetFilter("Posted Date", '<%1', PGSetup."Payroll Fiscal Year Start Date");

                    LeaveEarn.CalcSums("Balancing Days");
                    OpeningLeave := LeaveEarn."Balancing Days";

                    LeaveEarn.Reset;
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", Code);
                    LeaveEarn.SetRange("Fiscal year", FiscalYear);
                    LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                    LeaveEarn.CalcSums("Balancing Days");
                    EarnedLeave := LeaveEarn."Balancing Days";

                    LeaveEarn.Reset;
                    LeaveEarn.SetRange("Employee No.", Employee."No.");
                    LeaveEarn.SetRange("Leave Code", Code);
                    LeaveEarn.SetRange("Fiscal year", FiscalYear);
                    //LeaveEarn.SETRANGE(Type,LeaveEarn.Type::Used);
                    LeaveEarn.SetFilter(Type, '%1|%2', LeaveEarn.Type::Used, LeaveEarn.Type::Cancelled);
                    LeaveEarn.CalcSums("Balancing Days");
                    UsedDays := Abs(LeaveEarn."Balancing Days");

                    ClosingLeave := OpeningLeave + EarnedLeave - UsedDays;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Date Filter", '%1..%2', 0D, TillDate);
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
                field("Till Date"; TillDate)
                {
                    ToolTip = 'Specifies the value of the TillDate field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if TillDate <> 0D then
                            FiscalYear := HRMgt.ReturnFiscalYear(TillDate);
                    end;
                }
                field("Fiscal Year"; FiscalYear)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the FiscalYear field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        TillDate := Today;
        FiscalYear := HRMgt.ReturnFiscalYear(TillDate);
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        if TillDate = 0D then
            TillDate := Today;
        FiscalYear := HRMgt.ReturnFiscalYear(TillDate);
        if FiscalYear <> '' then begin
            EngNepDate.Reset;
            EngNepDate.SetRange("Fiscal Year", FiscalYear);
            EngNepDate.SetCurrentKey("English Date");
            if EngNepDate.FindFirst then;
            xFiscalYear := HRMgt.ReturnFiscalYear(CalcDate('<-1Y>', TillDate));
        end;
        PGSetup.Get;
    end;

    var
        CompanyInfo: Record "Company Information";
        TillDate: Date;
        Title: Label 'Employee Leave Balance';
        FiscalYear: Text[10];
        UsedDays: Decimal;
        EarnedLeave: Decimal;
        OpeningLeave: Decimal;
        HRMgt: Codeunit "HR Mgt.";
        LeaveEarn: Record "Leave Earn";
        EngNepDate: Record "English-Nepali Date";
        ClosingLeave: Decimal;
        xFiscalYear: Text[10];
        PGSetup: Record "Payroll General Setup";
}
