report 50125 "Posted Payroll Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019926.PostedPayrollSummary.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            dataitem("Posted Payroll Header"; "Posted Payroll Header")
            {
                RequestFilterFields = "No.";
                column(No_PostedPayrollHeader; "Posted Payroll Header"."No.") { }
                column(Narration_PostedPayrollHeader; "Posted Payroll Header".Narration) { }
                column(PostingDate_PostedPayrollHeader; "Posted Payroll Header"."Posting Date") { }
                column(NepaliMonth_PostedPayrollHeader; "Posted Payroll Header"."Nepali Month") { }
                column(Reversed_PostedPayrollHeader; "Posted Payroll Header".Reversed) { }
                dataitem("Posted Payroll Line"; "Posted Payroll Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    column(CurrentDeduction; CurrentDeduction) { }
                    // column(DepartmentVarCode; DepartmentVar.Code) { }
                    column(NetPay; NetPay) { }
                    column(MaritalStatus_PostedPayrollLine; "Posted Payroll Line"."Marital Status") { }
                    column(Gender_PostedPayrollLine; "Posted Payroll Line".Gender) { }
                    column(PayCycleTerm; PayCycleTerm) { }
                    column(Months; Months) { }
                    dataitem("Payroll Attributes"; "Payroll Attributes")
                    {
                        column(Amount; Amt) { }
                        column(PayrollDescription; Description) { }
                        column(PayrollCode; Code) { }
                        column(SortingOrder; "Column Id") { }
                        column(Type_PayrollAttributes; "Payroll Attributes".Type) { }

                        trigger OnAfterGetRecord()
                        begin
                            Clear(Amt);
                            if FirstTime then begin
                                NetPay := "Posted Payroll Line"."Net Pay";
                                CurrentDeduction := "Posted Payroll Line"."Current Deduction";
                            end else begin
                                NetPay := 0;
                                CurrentDeduction := 0;
                            end;
                            FirstTime := false;
                            RecRefs.Open(Database::"Posted Payroll Line");
                            PayrollColumnConfig.Reset;
                            PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                            PayrollColumnConfig.SetRange("Variable Field Code", Code);
                            if PayrollColumnConfig.FindFirst then begin
                                FieldRefs := RecRefs.Field(1);
                                FieldRefs.SetRange("Posted Payroll Line"."Document No.");
                                FieldRefs := RecRefs.Field(3);
                                FieldRefs.SetRange("Posted Payroll Line"."Employee No.");
                                RecRefs.FindFirst;
                                FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                                Evaluate(Amt, Format(FieldRefs.Value));
                                Amt := Round(Amt, 0.01, '=');
                            end;
                            RecRefs.Close;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(NetPay);
                        Clear(CurrentDeduction);
                        FirstTime := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        /*SETFILTER("Employee No.",EmployeeFilter);
                        SETFILTER("Salary Level",SalaryLevelFilter);
                        SETFILTER("Functional Title",FunctionalTitleFilter);*/
                    end;
                }

                trigger OnPreDataItem()
                begin

                    SetRange("Pay Cycle Term", PayCycleTerm);
                    if Months <> Months::" " then
                        SetRange("Nepali Month", Months);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*IF Months = Months::" " THEN
                  ERROR('Please select a month.');*/
                if PayCycleTerm = '' then
                    Error('Please select a pay cycle term.');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Pay Cycle Term"; PayCycleTerm)
                {
                    TableRelation = "Pay Cycle Term".Term;
                    ToolTip = 'Specifies the value of the PayCycleTerm field.';
                    ApplicationArea = All;
                }
                field(Month; Months)
                {
                    ToolTip = 'Specifies the value of the Months field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        Amt: Decimal;
        // DepartmentVar: Record Department;
        PayCycleTerm: Text;
        Months: Enum "Nepali Month";
        NetPay: Decimal;
        CurrentDeduction: Decimal;
        FirstTime: Boolean;
}
