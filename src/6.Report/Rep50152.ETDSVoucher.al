report 50152 "ETDS Voucher"
{
    ApplicationArea = All;
    Caption = 'ETDS Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50152.ETDSVoucher.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Posted Payroll Header"; "Posted Payroll Header")
        {
            RequestFilterFields = "No.", "Pay Cycle Term", "Pay Cycle Period";
            column(NepaliMonth; "Nepali Month") { }
            column(NepaliYear; "Nepali Year") { }
            column(Posting_Date; "Posting Date") { }
            column(Narration; Narration) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyPicture; CompanyInfo.Picture) { }

            dataitem(PostedPayrollLine; "Posted Payroll Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Variable Field 50619" = filter(> 0));
                column(Document_No_; "Document No.") { }
                column(SST; "Variable Field 50619") { }
                column(EmployeeNo; "Employee No.") { }
                column(EmployeeName; "Employee Name") { }
                column(PanNo; "Pan No.") { }
                column(SST_Base_Amount; "SST Base Amount") { }
            }
            dataitem(PostedPayrollLine2; "Posted Payroll Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Variable Field 50620" = filter(> 0));
                column(Document_No_2; "Document No.") { }
                column(RIT; "Variable Field 50620") { }
                column(EmployeeNo2; "Employee No.") { }
                column(EmployeeName2; "Employee Name") { }
                column(PanNo2; "Pan No.") { }
                column(RIT_Base_Amount; "RIT Base Amount") { }
            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
}
