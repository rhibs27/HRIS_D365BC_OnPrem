table 50138 "Payroll Archive"
{
    Caption = 'Payroll Archive';
    DataClassification = AccountData;

    fields
    {
        field(1; "Table No."; Integer) { }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Document No."; Code[20]) { }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(5; "Archive Version"; Integer)
        {
            Caption = 'Archive Version';
        }
        field(6; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(7; "Expire Date"; Date)
        {
            Caption = 'Expire Date';
        }
        field(8; "Table Name"; Text[30]) { }
        field(9; "User Id"; Code[50]) { }
        field(10; "Salary Level"; Code[20])
        {
            Caption = 'Salary Level';
            TableRelation = "Salary Level";
        }
        field(11; "Grade Code"; Code[20]) { }
        field(100; Rank; Integer)
        {
            Caption = 'Rank';
        }
        field(101; "Basic Salary"; Decimal)
        {
            Caption = 'Basic Salary';
        }
        field(102; Allowances; Decimal) { }
        field(103; "Transportation Allowances"; Decimal) { }
        field(104; "Store /Acc Allowance"; Decimal) { }
        field(105; "Employee Maintenence Allowance"; Decimal) { }
        field(106; "Transportation Allowance"; Decimal) { }
        field(107; "Vehicle Maintenence Allowance"; Decimal) { }
        field(109; "No. of grade"; Integer) { }

        //Remote area category
        field(200; Category; Code[20]) { }
        field(201; "Remote allowance Percentage"; Decimal) { }
        field(202; "Remote Allowance Amount"; Decimal) { }
        field(203; "BM Accomodation Amount"; Decimal) { }
        field(204; "Remote Area Deduction"; Decimal) { }
        field(205; "KPI Incentive %"; Decimal)
        {
            Description = 'KPI1.00';
        }
        //level wise attribute
        field(206; Grade; Decimal) { }
        //Allowance configuration
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PK2; "Table No.", "Table Name") { }
    }
    trigger OnInsert()
    begin
        "User Id" := UserId;
    end;

    procedure RunArchive(TableNo: Integer)
    var
        FilterPageB: FilterPageBuilder;
        StartDate: Date;
        EndDate: Date;
        PArch: Record "Payroll Archive";
        Text001: Label 'Specify the date';
    begin
        Clear(FilterPageB);
        FilterPageB.AddTable(Text001, Database::"Payroll Archive");
        FilterPageB.AddField(Text001, PArch."Effective Date");
        FilterPageB.AddField(Text001, PArch."Expire Date");
        if FilterPageB.RunModal() then begin
            PArch.SetView(FilterPageB.GetView(Text001));
            Evaluate(StartDate, PArch.GetFilter("Effective Date"));
            Evaluate(EndDate, PArch.GetFilter("Expire Date"));

            if (StartDate <> 0D) and (EndDate <> 0D) then
                ArchivePayroll(TableNo, StartDate, EndDate);
        end;
    end;

    procedure ArchivePayroll(TableNo: Integer; EffectiveDate: Date; ExpireDate: Date)
    var
        PayrollArchive: Record "Payroll Archive";
        SalaryLevel: Record "Salary Level";
        LevelwiseAttribute: Record "Level Wise Attributes";
        lastEntryNo: Integer;
        DocNo: Code[20];
        PGSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";
        RACategory: Record "Remote Area Category";
    begin
        PayrollArchive.CheckForDuplicate(TableNo, EffectiveDate, ExpireDate);

        PayrollArchive.Reset();
        if PayrollArchive.FindLast() then
            lastEntryNo := PayrollArchive."Entry No." + 1
        else
            lastEntryNo := 1;

        Clear(PayrollArchive);

        //get code
        PGSetup.Get();
        PGSetup.TestField("Payroll Archive Nos.");
        DocNo := NoSeriesMgt.GetNextNo(PGSetup."Payroll Archive Nos.", WorkDate(), true);

        if TableNo = Database::"Salary Level" then begin
            SalaryLevel.Reset();
            if SalaryLevel.FindSet() then
                repeat
                    Clear(PayrollArchive);
                    PayrollArchive.Init();
                    PayrollArchive."Entry No." := lastEntryNo;
                    PayrollArchive."Table No." := TableNo;
                    PayrollArchive."Table Name" := SalaryLevel.TableCaption;
                    PayrollArchive."Effective Date" := EffectiveDate;
                    PayrollArchive."Expire Date" := ExpireDate;
                    PayrollArchive."Document No." := DocNo;
                    PayrollArchive.Insert(true);
                    PayrollArchive.CopyFromSalaryLevel(SalaryLevel);
                    PayrollArchive.Modify(true);
                    lastEntryNo += 1;
                until SalaryLevel.Next() = 0;

        end else if TableNo = Database::"Remote Area Category" then begin
            RACategory.Reset();
            if RACategory.FindSet() then
                repeat
                    Clear(PayrollArchive);
                    PayrollArchive.Init();
                    PayrollArchive."Entry No." := lastEntryNo;
                    PayrollArchive."Table No." := TableNo;
                    PayrollArchive."Table Name" := RACategory.TableCaption;
                    PayrollArchive."Effective Date" := EffectiveDate;
                    PayrollArchive."Expire Date" := ExpireDate;
                    PayrollArchive."Document No." := DocNo;
                    PayrollArchive.Insert(true);
                    PayrollArchive.CopyFromRemoteAreaCategory(RACategory);
                    PayrollArchive.Modify(true);
                    lastEntryNo += 1;
                until RACategory.Next() = 0;

        end else if TableNo = Database::"Level Wise Attributes" then begin
            LevelwiseAttribute.Reset();
            if LevelwiseAttribute.FindSet() then
                repeat
                    Clear(PayrollArchive);
                    PayrollArchive.Init();
                    PayrollArchive."Entry No." := lastEntryNo;
                    PayrollArchive."Table No." := TableNo;
                    PayrollArchive."Table Name" := LevelwiseAttribute.TableCaption;
                    PayrollArchive."Effective Date" := EffectiveDate;
                    PayrollArchive."Expire Date" := ExpireDate;
                    PayrollArchive."Document No." := DocNo;
                    PayrollArchive.Insert(true);
                    PayrollArchive.CopyFromLevelWiseAttribute(LevelwiseAttribute);
                    PayrollArchive.Modify(true);
                    lastEntryNo += 1;
                until LevelwiseAttribute.Next() = 0;
        end;
    end;

    procedure CopyFromSalaryLevel(SalaryLevel: Record "Salary Level")
    begin
        "Salary Level" := SalaryLevel.Code;
        Rank := SalaryLevel.Rank;
        "Basic Salary" := SalaryLevel."Basic Salary";
        Allowances := SalaryLevel.Allowance;
        "Employee Maintenence Allowance" := SalaryLevel."Employee Maintenence Allowance";
        "Vehicle Maintenence Allowance" := SalaryLevel."Vehicle Maintenence Allowance";
        "Transportation Allowances" := SalaryLevel."Transportation Allowance";
        "No. of grade" := SalaryLevel."Grades Limit";
    end;

    procedure CopyFromRemoteAreaCategory(RACategory: Record "Remote Area Category")
    begin
        Category := RACategory.Category;
        "Remote allowance Percentage" := RACategory."Remote allowance Percentage";
        "Remote Allowance Amount" := RACategory."Remote Allowance Amount";
        "BM Accomodation Amount" := RACategory."BM Accomodation Amount";
        "Remote Area Deduction" := RACategory."Remote Area Deduction";
        "KPI Incentive %" := RACategory."KPI Incentive %";
    end;

    procedure CopyFromLevelWiseAttribute(LevelwiseAttribute: Record "Level Wise Attributes")
    begin
        Grade := LevelwiseAttribute.Grade;
        "Salary Level" := LevelwiseAttribute."Level Code";
        "Basic Salary" := LevelwiseAttribute."Standard Basic Salary";
    end;

    procedure CheckForDuplicate(TableNo: Integer; EffectiveDate: Date; ExpireDate: Date)
    var
        payrollArchive: Record "Payroll Archive";
    begin
        payrollArchive.Reset();
        payrollArchive.SetRange("Table No.", TableNo);
        payrollArchive.SetRange("Effective Date", EffectiveDate, ExpireDate);
        if payrollArchive.FindFirst() then
            Error('Duplicate archive please review the date');
        payrollArchive.SetRange("Effective Date");
        payrollArchive.SetRange("Expire Date", EffectiveDate, ExpireDate);
        if payrollArchive.FindFirst() then
            Error('Duplicate archive please review the date');
    end;
}
