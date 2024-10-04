report 33019840 "Export Payroll Data"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Pay Cycle Code"; PayCycleCodeText)
                {
                    TableRelation = "Pay Cycle";
                    ToolTip = 'Specifies the value of the PayCycleCodeText field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; NepaliMonth)
                {
                    ToolTip = 'Specifies the value of the NepaliMonth field.';
                    ApplicationArea = All;
                }
                field("Payroll No."; PostedPayrollCode)
                {
                    TableRelation = "Posted Payroll Header";
                    ToolTip = 'Specifies the value of the PostedPayrollCode field.';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Clear(PostedPayrollCode);
                        if PayCycleCodeText = '' then
                            Error('You must choose pay cycle text first');
                        if NepaliMonth = NepaliMonth::" " then
                            Error('You must choose Nepali month first');
                        PostedPayrollHeader.Reset;
                        PostedPayrollHeader.FilterGroup(2);
                        PostedPayrollHeader.SetFilter("Pay Cycle Code", PayCycleCodeText);
                        PostedPayrollHeader.SetFilter("Nepali Month", '%1', NepaliMonth);
                        PostedPayrollHeader.FilterGroup(0);
                        Clear(PagePostedPayroll);
                        PagePostedPayroll.ToSelect;
                        PagePostedPayroll.SetRecord(PostedPayrollHeader);
                        PagePostedPayroll.SetTableView(PostedPayrollHeader);
                        PagePostedPayroll.Editable(true);

                        if PagePostedPayroll.RunModal = Action::OK then begin
                            ;
                            PostedPayrollCode := PagePostedPayroll.ReturnPostedDocext;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if PostedPayrollCode = '' then
                            Error('Please choose Payroll No.');
                    end;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        if PostedPayrollCode = '' then
            Error('Please choose Payroll No.');
        PayrollExportData;
    end;

    var
        TempPayrollData: Record "Name/Value Buffer";
        PayrollQuery: Query "Payroll Query";
        Counter: Integer;
        StringLength: Integer;
        i: Integer;
        DataToExport: Text;
        varText: Text;
        PostedPayrollHeader: Record "Posted Payroll Header";
        PGSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        EngNep: Record "English-Nepali Date";
        Employee: Record Employee;
        PayCycleCodeText: Text;
        NepaliMonth: Enum "Nepali Month";
        PostedPayrollCode: Text;
        PagePostedPayroll: Page "Posted Payroll Plan List";

    procedure PayrollExportData()
    var
        Space53: Label '                                                     ';
        Space20: Label '                    ';
        Space6: Label '      ';
        Space1: Label ' ';
        DetailedEmpledgerEntry: Record "Detailed Employee Ledger Entry";
    begin
        Counter := 0;

        //CLEAR(TempPayrollData);
        //TempPayrollData.DELETEALL;
        PayrollQuery.SetFilter(Document_No, PostedPayrollCode);
        PayrollQuery.SetFilter(FinacleGLName, '<>%1', ' ');
        PayrollQuery.SetFilter(Attribute_Sub_Type, '<>%1&<>%2', DetailedEmpledgerEntry."Attribute Sub Type"::"Lump Sum Contribution", DetailedEmpledgerEntry."Attribute Sub Type"::"Tax on Interest");
        PayrollQuery.Open;
        //benefits and deductions
        PGSetup.Get;
        while PayrollQuery.Read do begin
            Clear(StringLength);
            Clear(DataToExport);
            Clear(varText);
            StringLength := StrLen(PayrollQuery.FinacleAccNo);
            DataToExport := PayrollQuery.FinacleAccNo;
            if StringLength < 16 then
                for i := 1 to (16 - StringLength) do
                    DataToExport += Space1;

            varText := CopyStr(DataToExport, 1, 2);
            DataToExport += 'NPR' + varText + Space6;
            Clear(varText);
            Clear(StringLength);
            if PayrollQuery.Sum_Amount < 0 then
                varText := 'C' + Format(Abs(PayrollQuery.Sum_Amount))
            else
                varText := 'D' + Format(Abs(PayrollQuery.Sum_Amount));
            varText := DelChr(varText, '=', ',');
            StringLength := StrLen(varText);
            DataToExport += varText;
            if StringLength < 18 then
                for i := 1 to (18 - StringLength) do
                    DataToExport += Space1;

            Clear(varText);
            Clear(StringLength);
            varText := PayrollQuery.FinacleGLName;
            StringLength := StrLen(varText);
            DataToExport += varText;
            if StringLength < 40 then
                for i := 1 to (40 - StringLength) do
                    DataToExport += Space1;
            DataToExport += Space53;

            Clear(varText);
            Clear(StringLength);
            varText := Format(Abs(PayrollQuery.Sum_Amount));
            varText := DelChr(varText, '=', ',');
            StringLength := StrLen(varText);
            DataToExport += varText;
            if StringLength < 17 then
                for i := 1 to (17 - StringLength) do
                    DataToExport += Space1;
            DataToExport += 'NPR' + Space20;
            DataToExport += HRMgt.getDateinFormat(Today);

            TempPayrollData.Init;
            TempPayrollData.Validate(ID, Counter + 1);
            TempPayrollData.Validate(Name, DataToExport);
            TempPayrollData.Insert;
            Counter += 1;
        end;

        //net pay
        EmployeeLedgerEntry.Reset;
        EmployeeLedgerEntry.SetFilter("Document No.", PostedPayrollCode);
        if EmployeeLedgerEntry.Find('-') then
            repeat
                EngNep.Reset;
                EngNep.SetRange("English Date", EmployeeLedgerEntry."Posting Date");
                if EngNep.FindFirst then;
                EmployeeLedgerEntry.CalcFields(Amount);
                Employee.Get(EmployeeLedgerEntry."Employee No.");
                Clear(StringLength);
                Clear(DataToExport);
                Clear(varText);
                if Employee."Bank Account No." <> '' then begin
                    StringLength := StrLen(Employee."Bank Account No.");
                    DataToExport := Employee."Bank Account No.";
                end else begin
                    StringLength := StrLen(PGSetup."Parking Account No.");
                    DataToExport := PGSetup."Parking Account No.";
                end;
                if StringLength < 16 then
                    for i := 1 to (16 - StringLength) do
                        DataToExport += Space1;

                varText := CopyStr(DataToExport, 1, 2);
                DataToExport += 'NPR' + varText + Space6;
                Clear(varText);
                Clear(StringLength);
                if EmployeeLedgerEntry.Amount > 0 then
                    varText := 'C' + Format(Abs(EmployeeLedgerEntry.Amount))
                else
                    varText := 'D' + Format(Abs(EmployeeLedgerEntry.Amount));
                varText := DelChr(varText, '=', ',');
                StringLength := StrLen(varText);
                DataToExport += varText;
                if StringLength < 18 then
                    for i := 1 to (18 - StringLength) do
                        DataToExport += Space1;

                Clear(varText);
                Clear(StringLength);
                if Employee."Bank Account No." <> '' then
                    varText := StrSubstNo('Net Salary %1-%2', EngNep."Nepali Year", EngNep."Nepali Month")
                else
                    varText := StrSubstNo('%1 %2', Employee."No.", UpperCase(Employee."Full Name"));
                StringLength := StrLen(varText);
                DataToExport += varText;
                if StringLength < 40 then
                    for i := 1 to (40 - StringLength) do
                        DataToExport += Space1;
                DataToExport += Space53;

                Clear(varText);
                Clear(StringLength);
                varText := Format(Abs(EmployeeLedgerEntry.Amount));
                varText := DelChr(varText, '=', ',');
                StringLength := StrLen(varText);
                DataToExport += varText;
                if StringLength < 17 then
                    for i := 1 to (17 - StringLength) do
                        DataToExport += Space1;
                DataToExport += 'NPR' + Space20;
                DataToExport += HRMgt.getDateinFormat(Today);

                TempPayrollData.Init;
                TempPayrollData.Validate(ID, Counter + 1);
                TempPayrollData.Validate(Name, DataToExport);
                TempPayrollData.Insert;
                Counter += 1;
            until EmployeeLedgerEntry.Next = 0;
        //COMMIT;
        Xmlport.Run(Xmlport::"Export Payroll Data Fincale", false, false, TempPayrollData);
        Clear(TempPayrollData);
        TempPayrollData.DeleteAll;
    end;
}
