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
                column(Document_No_; "Document No.") { }
                column(SST; SSTField) { }
                column(EmployeeNo; "Employee No.") { }
                column(EmployeeName; "Employee Name") { }
                column(PanNo; "Pan No.") { }
                column(SST_Base_Amount; "SST Base Amount") { }
                trigger OnAfterGetRecord()
                var
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(PostedPayrollLine);
                    SSTField := RecRef.Field(GetSSTColumn).Value;
                    if (SSTField <= 0) and ("SST Base Amount" <= 0) then
                        CurrReport.Skip();
                end;
            }
            dataitem(PostedPayrollLine2; "Posted Payroll Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_2; "Document No.") { }
                column(RIT; ROUND(RITField, GlSetup."Amount Rounding Precision")) { }
                column(EmployeeNo2; "Employee No.") { }
                column(EmployeeName2; "Employee Name") { }
                column(PanNo2; "Pan No.") { }
                column(RIT_Base_Amount; "RIT Base Amount") { }
                trigger OnAfterGetRecord()
                var
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(PostedPayrollLine2);
                    RITField := RecRef.Field(GetRITColumn).Value;
                    if (RITField <= 0) and ("RIT Base Amount" <= 0) then
                        CurrReport.Skip();
                end;
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
    local procedure GetRITColumn(): Integer
    begin
        PayrollAttributes.Reset();
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::"Tax on Remuneration & Benefits");
        if PayrollAttributes.FindFirst() then;

        PayrollColConfig.Reset();
        PayrollColConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
        if PayrollColConfig.FindFirst() then
            exit(PayrollColConfig."Field No.")
    end;

    local procedure GetSSTColumn(): Integer
    begin
        PayrollAttributes.Reset();
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::"Social Security Tax");
        if PayrollAttributes.FindFirst() then;

        PayrollColConfig.Reset();
        PayrollColConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
        if PayrollColConfig.FindFirst() then
            exit(PayrollColConfig."Field No.")
    end;

    var
        CompanyInfo: Record "Company Information";
        SSTField: Decimal;
        RITField: Decimal;
        PayrollAttributes: Record "Payroll Attributes";
        PayrollColConfig: Record "Payroll Column Configuration";
        GlSetup: Record "General Ledger Setup";
}
