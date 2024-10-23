table 50092 "Allowance Assignment Header"
{
    DataCaptionFields = "Entry No.", "Code", "From Date", "To date";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = if (Type = const(Branch)) "Dimension Value".Code where("Dimension Code" = const('BRANCH'))
            else if (Type = const("Extension Counter")) "Employee Hierarchy Master".Code where(Type = const("Extension Counter"));

            trigger OnValidate()
            begin
                CheckLineExist();
                GLsetup.Get;
                Clear(Name);
                if GuiAllowed then
                    Employee.Get(HrMgt.GetEmployeeNo())
                else
                    Employee.Get("Employee No.");
                if Type = Type::Branch then begin
                    if Code <> '' then
                        TestField(Code, Employee."Global Dimension 1 Code");
                    DimensionValue.Get(GLsetup."Global Dimension 1 Code", Code);
                    Validate(Name, DimensionValue.Name);
                end else if Type = Type::"Extension Counter" then begin
                    if Code <> '' then
                        TestField(Code, Employee."Extension Counter Code");
                    EmployeeHie.Reset;
                    EmployeeHie.SetRange(Type, EmployeeHie.Type::"Extension Counter");
                    EmployeeHie.SetRange(Code, Code);
                    if EmployeeHie.FindFirst then
                        Validate(Name, EmployeeHie.Description);
                end;

                //GetApprover();
                CheckForSameWeek;
            end;
        }
        field(3; Name; Text[100])
        {
            Editable = false;
        }
        field(4; "From Date"; Date)
        {
            Editable = false;
        }
        field(5; "To date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TestField("From Date");
                if "From Date" > "To date" then
                    Error('Invalid date.');
            end;
        }
        field(6; Type; Enum "Branchwise/Extension Type")
        {

        }
        field(7; "Created Date"; Date) { }
        field(8; "Created By"; Code[50]) { }
        field(9; "Last Modified Date"; Date) { }
        field(10; "Last Modified By"; Code[50]) { }
        field(11; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(12; "Approver ID"; Code[50])
        {
            TableRelation = Employee;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Employee.Get("Approver ID") then
                    Validate("Approver Name", Employee."Full Name")
                else
                    Clear("Approver ID");
            end;
        }
        field(13; "Approval Status"; Enum "Attendance status")
        {

        }
        field(14; Posted; Boolean) { }
        field(15; "Allowance Type Filter"; Code[20])
        {
            TableRelation = "Branchwise/Extension Allowance"."Allowance Type" where(Code = field(Code),
                                                                                     Type = field(Type));
        }
        field(16; "Approver Name"; Text[50])
        {
            Editable = false;
        }
        field(17; Week; Enum WeekNumber)
        {

            trigger OnValidate()
            begin
                CheckLineExist;
                CalculateWeekStartEndDate;
                CheckForSameWeek;
            end;
        }
        field(18; "English Month"; Enum "English Month")
        {
            Editable = false;
            trigger OnValidate()
            begin
                TestField(Week);
                CheckLineExist;
                CalculateWeekStartEndDate;
                CheckForSameWeek;
            end;
        }
        field(19; "English Year"; Integer)
        {
            trigger OnValidate()
            begin
                CheckForSameWeek;
            end;
        }
        field(20; "Change Approver Remarks"; Text[250]) { }
        field(21; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Only for Portal functionalities.';
        }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        TestField("Approval Status", "Approval Status"::Open);
        AllowanceLine.Reset;
        AllowanceLine.SetRange("Entry No.", "Entry No.");
        AllowanceLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        GetEntryNo;
        "Created By" := UserId;
        "Created Date" := Today;
        TestField(Code);
        if not GuiAllowed then
            CheckForSameWeek;

        if not GuiAllowed then
            if "Approver ID" = '' then
                Error('Please select an approver.');
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := Today;
        "Last Modified By" := UserId;

        if not GuiAllowed then
            if "Approver ID" = '' then
                Error('Please select an approver.');
    end;

    var
        Employee: Record Employee;
        AllowanceLine: Record "Allowance Assignment Line";
        HrMgt: Codeunit "HR Mgt.";
        DimensionValue: Record "Dimension Value";
        GLsetup: Record "General Ledger Setup";
        AllowanceHeader: Record "Allowance Assignment Header";
        EmployeeHie: Record "Employee Hierarchy Master";

    local procedure GetEntryNo()
    var
        AllowanceEntry: Record "Allowance Assignment Header";
    begin
        AllowanceEntry.Reset;
        AllowanceEntry.SetCurrentKey("Entry No.");
        if AllowanceEntry.FindLast then
            "Entry No." := AllowanceEntry."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    local procedure CheckLineExist()
    var
        AllowanceLine: Record "Allowance Assignment Line";
    begin
        AllowanceLine.Reset;
        AllowanceLine.SetRange("Entry No.", "Entry No.");
        if AllowanceLine.FindFirst then
            Error('Line exists. ');
    end;

    procedure GetApprover()
    begin
        if Code = '' then
            exit;

        Employee.Reset;
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetRange("Global Dimension 1 Code", Code);
        Employee.SetRange("Functional Title", 'BM');
        if Employee.FindFirst then
            Validate("Approver ID", Employee."No.")

        else begin
            Employee.SetFilter("Functional Title", 'ACOSP|OBM');
            if Employee.FindFirst then
                Validate("Approver ID", Employee."No.");
        end;
    end;

    local procedure CalculateWeekStartEndDate()
    var
        EnglishNepaliDate: Record "English-Nepali Date";
        ToDate: Date;
    begin
        TestField(Week);
        if "English Month" = "English Month"::" " then
            "English Month" := Date2DMY(Today, 2);

        if "English Month" = "English Month"::" " then
            exit;

        "From Date" := 0D;
        "To date" := 0D;
        if "English Year" = 0 then begin
            if "English Month" < Date2DMY(Today, 2) then
                "English Year" := Date2DMY(Today, 3) + 1
            else
                "English Year" := Date2DMY(Today, 3);
        end;
        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Month", "English Month");
        EnglishNepaliDate.SetRange("English Year", "English Year");
        EnglishNepaliDate.FindFirst;
        case Week of
            Week::"Week 1":
                begin
                    "From Date" := EnglishNepaliDate."English Date";
                    "To date" := CalcDate('<1W>', EnglishNepaliDate."English Date") - 1;
                end;
            Week::"Week 2":
                begin
                    "From Date" := CalcDate('<1W>', EnglishNepaliDate."English Date");
                    "To date" := CalcDate('<2W>', EnglishNepaliDate."English Date") - 1;
                end;
            Week::"Week 3":
                begin
                    "From Date" := CalcDate('<2W>', EnglishNepaliDate."English Date");
                    "To date" := CalcDate('<3W>', EnglishNepaliDate."English Date") - 1;
                end;
            Week::"Week 4":
                begin
                    "From Date" := CalcDate('<3W>', EnglishNepaliDate."English Date");
                    EnglishNepaliDate.FindLast;
                    ToDate := CalcDate('<4W>', EnglishNepaliDate."English Date");
                    if EnglishNepaliDate."English Date" < ToDate then
                        "To date" := EnglishNepaliDate."English Date"
                    else
                        "To date" := ToDate;
                end;
        end;
        if Modify then;
    end;

    local procedure CheckForSameWeek()
    begin
        AllowanceHeader.Reset;
        AllowanceHeader.SetRange(Week, Week);
        AllowanceHeader.SetRange("English Year", "English Year");
        AllowanceHeader.SetRange("English Month", "English Month");
        AllowanceHeader.SetRange(Code, Code);
        if AllowanceHeader.FindFirst then
            Error('Allowance for branch %1 of month %2 and week %3 has already been assigned.', Name, "English Month", Week);
    end;
}
