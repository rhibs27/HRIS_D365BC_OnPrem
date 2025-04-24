table 50092 "Allowance Assignment Header"
{
    DataCaptionFields = "No.", "Code", "From Date", "To date";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    case "Activity Type" of
                        //for Allowance Assignment Header
                        "Activity Type"::"Allowance Assignment":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Allowance Assignment Series");
                                "No. Series" := '';
                            end;
                    end;
            end;

        }
        field(2; "Activity Type"; Enum "Employee Activity Type")
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = if (Type = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Organization Structure list"::Branch), Blocked = filter(false))
            else if (Type = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure Line"."Reporting Code" where(Type = Filter("Organization Structure list"::"Branch"), Code = field("Branch Code"), "Reporting Type" = filter("Organization Structure list"::"Extension Counter"));

            trigger OnValidate()
            begin
                // CheckLineExist();
                GLsetup.Get;
                Clear(Name);
                if GuiAllowed then
                    Employee.Get(HrMgt.GetEmployeeNo())
                else
                    Employee.Get("Employee No.");
                if Type = Type::Branch then begin
                    if Code <> '' then
                        TestField(Code, Employee."Branch Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::"Extension Counter" then begin
                    if Code <> '' then
                        // TestField(Code, Employee."Extension Counter Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Code) then
                            Name := OrganizationStructureList.Name;
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
        field(6; "Type"; Enum "Branchwise/Extension Type")
        {
            trigger OnValidate()
            begin
                if Type <> xRec.Type then begin
                    Clear(Code);
                    Clear(Name);
                end;
            end;
        }
        field(7; "Created Date"; Date) { }
        field(8; "Created By"; Code[50]) { }
        field(9; "Last Modified Date"; Date) { }
        field(10; "Last Modified By"; Code[50]) { }

        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        // field(12; "Approver ID"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnValidate()
        //     begin
        //         if Employee.Get("Approver ID") then
        //             Validate("Approver Name", Employee."Full Name")
        //         else
        //             Clear("Approver ID");
        //     end;
        // }
        field(14; Posted; Boolean) { }
        field(15; "Allowance Type Filter"; Code[20])
        {
            TableRelation = "Branchwise/Extension Allowance"."Allowance Type" where(Code = field(Code),
                                                                                     Type = field(Type));
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }
        // field(16; "Approver Name"; Text[50])
        // {
        //     Editable = false;
        // }
        field(17; Week; Enum WeekNumber)
        {
            trigger OnValidate()
            begin
                // CheckLineExist;
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
                // CheckLineExist;
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
            trigger OnValidate()
            begin
                "Branch Code" := HrMgt.GetBranchCode;
            end;
        }
        field(22; "Branch Code"; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(37; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(100; "Status"; Text[20])
        {
        }
        // field(22; "Requested Date"; Date) { }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        // TestField("Approval Status", "Approval Status"::Open);
        AllowanceLine.Reset;
        AllowanceLine.SetRange("No.", "No.");
        AllowanceLine.DeleteAll(true);
        ApprovalHrms.Reset;
        ApprovalHrms.SetRange("Document No.", "No.");
        ApprovalHrms.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        // GetEntryNo;
        "Created By" := UserId;
        "Created Date" := Today;
        // "Activity Type" := "Activity Type"::"Allowance Assignment";
        // Validate("Employee No.", HrMgt.GetEmployeeNo());
        // TestField(Code);
        if not GuiAllowed then
            CheckForSameWeek;
        HRSetup.Get;
        if "No." = '' then
            case "Activity Type" of
                //for AllowanceAssignment
                "Activity Type"::"Allowance Assignment":
                    begin
                        HRSetup.TestField("Allowance Assignment Series");
                        NoSeriesMgt.InitSeries(HRSetup."Allowance Assignment Series", xRec."No. Series", "Created Date", "No.", "No. Series");
                        ApproverMgt.InsertApproval("Employee No.", "No.", "Activity Type");
                    end;
            end;
    end;
    // if not GuiAllowed then
    //     if "Approver ID" = '' then
    //         Error('Please select an approver.');
    // end;

    trigger OnModify()
    begin
        "Last Modified Date" := Today;
        "Last Modified By" := UserId;

        // if not GuiAllowed then
        //     if "Approver ID" = '' then
        //         Error('Please select an approver.');
    end;

    var
        Employee: Record Employee;
        AllowanceLine: Record "Allowance Assignment Line";
        HrMgt: Codeunit "HR Mgt.";
        ApprovalHrms: Record "Approval HRMS";
        HRSetup: Record "Human Resources Setup";
        OrganizationStructureList: Record "Organization Structure List";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApproverMgt: Codeunit "Approver Mgt";
        // DimensionValue: Record "Dimension Value";
        GLsetup: Record "General Ledger Setup";
        AllowanceHeader: Record "Allowance Assignment Header";
    // EmployeeHie: Record "Employee Hierarchy Master";

    // local procedure GetEntryNo()
    // var
    //     AllowanceEntry: Record "Allowance Assignment Header";
    // begin
    //     AllowanceEntry.Reset;
    //     AllowanceEntry.SetCurrentKey("Entry No.");
    //     if AllowanceEntry.FindLast then
    //         "Entry No." := AllowanceEntry."Entry No." + 1
    //     else
    //         "Entry No." := 1;
    // end;

    // local procedure CheckLineExist()
    // var
    //     AllowanceLine: Record "Allowance Assignment Line";
    // begin
    //     AllowanceLine.Reset;
    //     AllowanceLine.SetRange("No.", "No.");
    //     if AllowanceLine.FindFirst then
    //         Error('Line exists. ');
    // end;

    // procedure GetApprover()
    // begin
    //     if Code = '' then
    //         exit;

    //     Employee.Reset;
    //     Employee.SetRange(Status, Employee.Status::Active);
    //     Employee.SetRange("Global Dimension 1 Code", Code);
    //     Employee.SetRange("Functional Title", 'BM');
    //     if Employee.FindFirst then
    //         Validate("Approver ID", Employee."No.")

    //     else begin
    //         Employee.SetFilter("Functional Title", 'ACOSP|OBM');
    //         if Employee.FindFirst then
    //             Validate("Approver ID", Employee."No.");
    //     end;
    // end;

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
        AllowanceHeader.SetFilter("No.", '<>%1', "No.");
        AllowanceHeader.SetRange(Week, Week);
        AllowanceHeader.SetRange("English Year", "English Year");
        AllowanceHeader.SetRange("English Month", "English Month");
        AllowanceHeader.SetRange(Code, Code);
        AllowanceHeader.SetFilter("Approval Status", '<>%1', AllowanceHeader."Approval Status"::Rejected);
        if AllowanceHeader.FindFirst then
            Error('Allowance for this %1 of month %2 and week %3 has already been assigned.', type, "English Month", Week);
    end;
}
