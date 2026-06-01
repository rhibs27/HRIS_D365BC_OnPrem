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
            trigger OnValidate()
            begin
                if "Expire Date" < "Effective Date" then
                    Error('expire date cannot be Greater than Effective date.');
            end;
        }
        field(8; "Table Name"; Text[30]) { }
        field(9; "User Id"; Code[50]) { }
        field(10; "Salary Level"; Code[20])
        {
            Caption = 'Salary Level';
            TableRelation = "Salary Level";
        }
        field(11; "Grade Code"; Code[20]) { }
        //Salary Level Archive
        field(100; Rank; Integer)
        {
            Caption = 'Rank';
        }
        field(101; "Basic Salary"; Decimal)
        {
            Caption = 'Basic Salary';
        }
        field(102; Allowances; Decimal) { }
        field(113; "Nepal Fooding Allowance"; Decimal) { }

        field(114; "Nepal Lodging Allowance"; Decimal) { }
        field(115; "Out of Pocket Expense(Nepal)"; Decimal) { }
        field(116; "Vehicle Allowance"; Decimal) { }
        field(118; "Net Learning"; Decimal) { }
        field(119; "Friday Allowance"; Decimal) { }
        field(120; "Vehicle Loan Limit"; Decimal) { }
        field(121; "Housing Loan Limit"; Decimal) { }
        field(122; "OT Eligible"; Boolean) { }
        field(123; "Reapply Year (Vehicle Loan)"; Decimal)
        {
            Description = 'For reapplying of Vehicle loan';
        }
        field(124; Darbandi; Integer) { }
        field(125; "Banking Experience"; Decimal) { }
        field(126; "Non-Banking Experience"; Decimal) { }
        field(127; "Minimum Age"; Integer) { }
        field(128; "India Fooding Allowance"; Decimal) { }
        field(129; "India Lodging Allowance"; Decimal) { }
        field(130; "Senior Officer Level"; Boolean)
        {
        }
        field(131; "Leave Balance (Contract Staff)"; Decimal)
        {
            Description = 'For contract staffs';
        }
        field(132; "OT Attachment Mandatory"; Boolean) { }
        field(133; "Travel With Not Eligible"; Boolean) { }
        field(134; "Vault Key Eligible"; Boolean) { }
        field(135; "Maximum Age"; Decimal) { }
        field(136; "Qualification Code"; Code[20])
        {
            TableRelation = Qualification.Code where(Type = const(Education));
        }
        field(137; "Good Service Period"; Integer)
        {
            Description = 'Promotion';
        }
        field(138; "Extra Mileage Eligible"; Boolean) { }
        field(139; "Compensatory Leave"; Boolean) { }
        field(140; "Holiday Counter Eligible"; Boolean) { }
        field(141; "Festive Counter Eligible"; Boolean) { }
        field(142; "Year End Encashment"; Boolean) { }
        field(143; "TA OT Basic Salary"; Decimal) { }
        field(144; "Others Fooding Allowance"; Decimal)
        {
            Caption = 'Other Country Fooding Allowance';
        }
        field(145; "Others Lodging Allowance"; Decimal)
        {
            Caption = 'Other Country Lodging Allowance';
        }
        field(146; "Out of Pocket Expense(India)"; Decimal) { }
        field(147; "Out of Pocket Expense(Other)"; Decimal) { }
        field(148; "Leave Fare Allowance"; Decimal) { }
        field(149; "Staff Level"; Enum "Staff Type") { }
        field(150; "Grades Limit"; Integer) { }

        field(105; "Employee Maintenence Allowance"; Decimal) { }
        field(106; "Transportation Allowance"; Decimal) { }
        field(107; "Vehicle Maintenence Allowance"; Decimal) { }
        field(109; "No. of grade"; Integer) { }
        field(110; "EV Allowance"; Decimal) { }
        field(111; "Fuel Limit (Ltrs)"; Decimal) { }
        field(112; "Is AM"; Boolean) { }

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

        //Specific Attributes   //Allowance configuration
        field(210; "Payroll Attribute"; Code[20]) { }
        field(211; "Attribute Amount"; Decimal) { }
        field(212; "Province Code"; Code[1000])
        {
            Caption = 'Province Code';
            Description = 'Filter by Province Code.';
            TableRelation = "Payroll Attributes";
        }
        field(213; "Branch Code"; Code[1000])
        {
            Caption = 'Branch Code';
            Description = 'Filter by Branch Code.';
        }
        field(214; "Department Code"; Code[1000])
        {
            Caption = 'Department Code';
            Description = 'Filter by Department Code.';
        }
        field(215; "Min Service Yr. Eligibility"; Decimal) { }
        field(216; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(217; Formula; Text[20]) { }
        field(218; Region; Enum Region) { }
        field(219; "Outside/Inside Valley"; enum "Outside/Inside Valley") { }
        field(220; "Remote Area Category"; Code[20])
        {
            TableRelation = "Remote Area Category";
        }
        field(221; "ATM Site"; Enum "ATM Site") { }
        field(222; "Specific Payroll Attribute"; Enum "Specific Payroll Attributes")
        {
            Caption = 'Specific Payroll Attribute';
            Editable = false;
        }
        field(223; "Earning Cycle"; Enum "Encashment Period") { }
        field(224; "Employment Type"; Enum "Employee Type")
        {
            Caption = 'Employment Type';
        }
        field(225; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift";
        }
        field(226; Source; Enum "Allowance Config. Source") { }
        field(227; "Day Type"; Enum "Day Type")
        {
            DataClassification = ToBeClassified;
            InitValue = " ";
        }
        field(228; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";
        }
        //level wise attribute
        field(206; Grade; Decimal) { }

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

    procedure RunArchive(TableNo: Integer; EffectiveDate: Date)
    var
        FilterPageB: FilterPageBuilder;
        EndDate: Date;
        PArch: Record "Payroll Archive";
        Text001: Label 'Specify the date';
    begin
        Clear(FilterPageB);
        FilterPageB.AddTable(Text001, Database::"Payroll Archive");
        FilterPageB.AddField(Text001, PArch."Expire Date");
        if FilterPageB.RunModal() then begin
            PArch.SetView(FilterPageB.GetView(Text001));
            Evaluate(EndDate, PArch.GetFilter("Expire Date"));
            if (EffectiveDate = 0D) or (EndDate = 0D) then
                Error('Effective date and Expire Date Cannot be Blank.');
            CheckForDuplicate(TableNo, EffectiveDate, EndDate);
            ArchivePayroll(TableNo, EndDate);
            Message('Record is Archived');
        end;
    end;

    procedure ArchivePayroll(TableNo: Integer; ExpireDate: Date)
    var
        PayrollArchive: Record "Payroll Archive";
        SalaryLevel: Record "Salary Level";
        LevelWiseAttribute: Record "Level Wise Attributes";
        lastEntryNo: Integer;
        DocNo: Code[20];
        PGSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";
        RACategory: Record "Remote Area Category";
        AllowanceConfiguration: Record "Allowance Configuration";
    begin
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
                    PayrollArchive.Validate("Entry No.", lastEntryNo);
                    PayrollArchive.Validate("Table No.", TableNo);
                    PayrollArchive.Validate("Table Name", SalaryLevel.TableCaption);
                    PayrollArchive.Validate("Effective Date", SalaryLevel."Effective Date");
                    PayrollArchive.Validate("Expire Date", ExpireDate);
                    PayrollArchive.Validate("Document No.", DocNo);
                    PayrollArchive.Insert(true);
                    PayrollArchive.CopyFromSalaryLevel(SalaryLevel);
                    PayrollArchive.Modify(true);
                    SalaryLevel.Validate("Effective Date", ExpireDate + 1);
                    SalaryLevel.Modify(true);
                    lastEntryNo += 1;
                until SalaryLevel.Next() = 0;
        end else if TableNo = Database::"Remote Area Category" then begin
            RACategory.Reset();
            if RACategory.FindSet() then
                repeat
                    Clear(PayrollArchive);
                    PayrollArchive.Init();
                    PayrollArchive.Validate("Entry No.", lastEntryNo);
                    PayrollArchive.Validate("Table No.", TableNo);
                    PayrollArchive.Validate("Table Name", RACategory.TableCaption);
                    PayrollArchive.Validate("Effective Date", RACategory."Effective Date");
                    PayrollArchive.Validate("Expire Date", ExpireDate);
                    PayrollArchive.Validate("Document No.", DocNo);
                    PayrollArchive.Insert(true);
                    PayrollArchive.CopyFromRemoteAreaCategory(RACategory);
                    PayrollArchive.Modify(true);
                    RACategory.Validate("Effective Date", ExpireDate + 1);
                    RACategory.Modify(true);
                    lastEntryNo += 1;
                until RACategory.Next() = 0;
        end else if TableNo = Database::"Level Wise Attributes" then begin
            LevelWiseAttribute.Reset();
            if LevelWiseAttribute.FindSet() then
                repeat
                    Clear(PayrollArchive);
                    PayrollArchive.Init();
                    PayrollArchive.Validate("Entry No.", lastEntryNo);
                    PayrollArchive.Validate("Table No.", TableNo);
                    PayrollArchive.Validate("Table Name", LevelWiseAttribute.TableCaption);
                    PayrollArchive.Validate("Effective Date", LevelWiseAttribute."Effective Date");
                    PayrollArchive.Validate("Expire Date", ExpireDate);
                    PayrollArchive.Validate("Document No.", DocNo);
                    PayrollArchive.Insert(true);
                    PayrollArchive.CopyFromLevelWiseAttribute(LevelWiseAttribute);
                    PayrollArchive.Modify(true);
                    LevelWiseAttribute.Validate("Effective Date", ExpireDate + 1);
                    LevelWiseAttribute.Modify(true);
                    lastEntryNo += 1;
                until LevelWiseAttribute.Next() = 0;
        end else if TableNo = Database::"Allowance Configuration" then begin
            AllowanceConfiguration.Reset();
            if AllowanceConfiguration.FindSet() then
                repeat
                    Clear(PayrollArchive);
                    PayrollArchive.Init();
                    PayrollArchive.Validate("Entry No.", lastEntryNo);
                    PayrollArchive.Validate("Table No.", TableNo);
                    PayrollArchive.Validate("Table Name", AllowanceConfiguration.TableCaption);
                    PayrollArchive.Validate("Effective Date", AllowanceConfiguration."Effective Date");
                    PayrollArchive.Validate("Expire Date", ExpireDate);
                    PayrollArchive.Validate("Document No.", DocNo);
                    PayrollArchive.Insert(true);
                    PayrollArchive.CopyFromAllowanceConfiguration(AllowanceConfiguration);
                    PayrollArchive.Modify(true);
                    AllowanceConfiguration.Validate("Effective Date", ExpireDate + 1);
                    AllowanceConfiguration.Modify(true);
                    lastEntryNo += 1;
                until AllowanceConfiguration.Next() = 0;
        end;
    end;

    procedure CopyFromSalaryLevel(SalaryLevel: Record "Salary Level")
    begin
        "Salary Level" := SalaryLevel.Code;
        Rank := SalaryLevel.Rank;
        "Basic Salary" := SalaryLevel."Basic Salary";
        "Nepal Fooding Allowance" := SalaryLevel."Nepal Fooding Allowance";
        "Nepal Lodging Allowance" := SalaryLevel."Nepal Lodging Allowance";
        "Out of Pocket Expense(Nepal)" := SalaryLevel."Out of Pocket Expense(Nepal)";
        "Vehicle Allowance" := SalaryLevel."Vehicle Allowance";
        Allowances := SalaryLevel.Allowance;
        "Net Learning" := SalaryLevel."Net Learning";
        "Friday Allowance" := SalaryLevel."Friday Allowance";
        "Vehicle Loan Limit" := SalaryLevel."Vehicle Loan Limit";
        "Housing Loan Limit" := SalaryLevel."Housing Loan Limit";
        "OT Eligible" := SalaryLevel."OT Eligible";
        "Reapply Year (Vehicle Loan)" := SalaryLevel."Reapply Year (Vehicle Loan)";
        Darbandi := SalaryLevel.Darbandi;
        "Banking Experience" := SalaryLevel."Banking Experience";
        "Non-Banking Experience" := SalaryLevel."Non-Banking Experience";
        "Minimum Age" := SalaryLevel."Minimum Age";
        "India Fooding Allowance" := SalaryLevel."India Fooding Allowance";
        "Senior Officer Level" := SalaryLevel."Senior Officer Level";
        "Leave Balance (Contract Staff)" := SalaryLevel."Leave Balance (Contract Staff)";
        "OT Attachment Mandatory" := SalaryLevel."OT Attachment Mandatory";
        "Travel With Not Eligible" := SalaryLevel."Travel With Not Eligible";
        "Vault Key Eligible" := SalaryLevel."Vault Key Eligible";
        "Maximum Age" := SalaryLevel."Maximum Age";
        "Qualification Code" := SalaryLevel."Qualification Code";
        "Good Service Period" := SalaryLevel."Good Service Period";
        "Is AM" := SalaryLevel."Is AM";
        "Extra Mileage Eligible" := SalaryLevel."Extra Mileage Eligible";
        "Compensatory Leave" := SalaryLevel."Compensatory Leave";
        "Holiday Counter Eligible" := SalaryLevel."Holiday Counter Eligible";
        "Festive Counter Eligible" := SalaryLevel."Festive Counter Eligible";
        "Year End Encashment" := SalaryLevel."Year End Encashment";
        "TA OT Basic Salary" := SalaryLevel."TA OT Basic Salary";
        "Others Fooding Allowance" := SalaryLevel."Others Fooding Allowance";
        "Others Lodging Allowance" := SalaryLevel."Others Lodging Allowance";
        "Out of Pocket Expense(India)" := SalaryLevel."Out of Pocket Expense(India)";
        "Out of Pocket Expense(Other)" := SalaryLevel."Out of Pocket Expense(Other)";
        "Leave Fare Allowance" := SalaryLevel."Leave Fare Allowance";
        "Staff Level" := SalaryLevel."Staff Level";
        "Grades Limit" := SalaryLevel."Grades Limit";
        "Employee Maintenence Allowance" := SalaryLevel."Employee Maintenence Allowance";
        "Vehicle Maintenence Allowance" := SalaryLevel."Vehicle Maintenence Allowance";
        "Transportation Allowance" := SalaryLevel."Transportation Allowance";
        "No. of grade" := SalaryLevel."Grades Limit";
        "EV Allowance" := SalaryLevel."EV Allowance";
        "Fuel Limit (Ltrs)" := SalaryLevel."Fuel Limit (ltr)";
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

    procedure CopyFromAllowanceConfiguration(AllowanceConfiguration: Record "Allowance Configuration")
    begin
        "Payroll Attribute" := AllowanceConfiguration."Payroll Attribute";
        "Employment Type" := AllowanceConfiguration."Employment Type";
        "Employee Work Shift" := AllowanceConfiguration."Employee Work Shift";
        "Salary Level" := AllowanceConfiguration."Salary Level";
        "Province Code" := AllowanceConfiguration."Province Code";
        "Branch Code" := AllowanceConfiguration."Branch Code";
        "Department Code" := AllowanceConfiguration."Department Code";
        "Attribute Amount" := AllowanceConfiguration.Amount;
        "Day Type" := AllowanceConfiguration."Day Type";
        "Min Service Yr. Eligibility" := AllowanceConfiguration."Min Service Yr. Eligibility";
        "Functional Title" := AllowanceConfiguration."Functional Title";
        "Earning Cycle" := AllowanceConfiguration."Earning Cycle";
        "ATM Site" := AllowanceConfiguration."ATM Site";
        Source := AllowanceConfiguration.Source;
        "Leave Code" := AllowanceConfiguration."Leave Code";
        Region := AllowanceConfiguration.Region;
        "Outside/Inside Valley" := AllowanceConfiguration."Outside/Inside Valley";
        "Remote Area Category" := AllowanceConfiguration."Remote Area Category";
        Formula := AllowanceConfiguration.Formula;
        "Specific Payroll Attribute" := AllowanceConfiguration."Specific Payroll Attribute";
        AllowanceConfiguration.CalcFields("Specific Payroll Attribute");
        "Specific Payroll Attribute" := AllowanceConfiguration."Specific Payroll Attribute";
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
