table 33019897 "HR Budget Plan"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Fiscal Year"; Code[10]) { }
        field(2; "Code"; Code[20])
        {
            TableRelation = if ("Deputation On" = const(Department)) Department.Code
            //else if ("Deputation On" = const(Branch)) "Dimension Value".Code where("Dimension Code" = const('Branch'))
            else if ("Deputation On" = filter(<> Department)) "Reporting Category".Code;

            trigger OnValidate()
            begin
                case "Deputation On" of
                    "Deputation On"::Department:
                        begin
                            if Department.Get(Code) then
                                Description := Department.Name
                            else
                                Description := '';
                        end;
                    "Deputation On"::Branch, "Deputation On"::"Extension Counter", "Deputation On"::Province, "Deputation On"::"Sub Province", "Deputation On"::Unit:
                        begin
                            if ReportingCategory.Get(Code) then
                                Description := ReportingCategory.Description
                            else
                                Description := '';
                        end;
                end;
            end;
        }
        field(3; "Functional Title Code"; Code[20])
        {
            TableRelation = "Functional Title";

            trigger OnValidate()
            begin
                if FunctionalTitle.Get("Functional Title Code") then
                    "Functional Title" := FunctionalTitle.Description
                else
                    "Functional Title" := '';
            end;
        }
        field(4; "Functional Title"; Text[100])
        {
            Editable = false;
        }
        field(5; "Salary Level Code"; Code[10])
        {
            TableRelation = "Salary Level";

            trigger OnValidate()
            begin
                if SalaryLevel.Get("Salary Level Code") then
                    "Salary Level" := SalaryLevel.Description
                else
                    "Salary Level" := '';
            end;
        }
        field(6; "Salary Level"; Text[50])
        {
            Editable = false;
        }
        field(7; "No. of Employees"; Integer)
        {
            BlankZero = true;
        }
        field(8; "Created DateTime"; DateTime)
        {
            Editable = false;
        }
        field(9; "Created By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(10; Posted; Boolean) { }
        field(11; "Posted By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(12; "Posted DateTime"; DateTime)
        {
            Editable = false;
        }
        field(13; Description; Text[50])
        {
            Editable = false;
        }
        field(14; "Deputation On"; Enum "Deputation Type")
        {


            trigger OnValidate()
            begin
                Validate(Code, '');
                Validate("Functional Title Code", '');
                Validate("Salary Level Code", '');
                "No. of Employees" := 0;
            end;
        }
    }

    keys
    {
        key(Key1; "Fiscal Year", "Code", "Functional Title Code", "Salary Level Code") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        TestField(Posted, false);
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        TestField(Posted, false);
    end;

    trigger OnRename()
    begin
        TestField(Posted, false);
    end;

    var
        FunctionalTitle: Record "Functional Title";
        HRBudgetPlan: Record "HR Budget Plan";
        SalaryLevel: Record "Salary Level";
        Department: Record Department;
        ReportingCategory: Record "Reporting Category";
        RequiredEmpInBranch: Record "Required Emp In Branch";

    procedure InsertHRBudgetCombination(FiscalYear: Text)
    var
        Branch: Record "Dimension Value";
        Province: Record Province;
        SubProvince: Record "Sub Province";
        EmployeeHierarchyMaster: Record "Employee Hierarchy Master";
    begin
        if not Confirm('Do you want to generate HR Budget as per the plan?', false) then
            exit;

        HRBudgetPlan.Reset;
        HRBudgetPlan.SetRange("Fiscal Year", FiscalYear);
        HRBudgetPlan.SetRange(Posted, false);
        if HRBudgetPlan.FindFirst then
            repeat
                case HRBudgetPlan."Deputation On" of
                    HRBudgetPlan."Deputation On"::Department:
                        begin
                            InitHRBudgetCombination(false, '', '');
                        end;
                    HRBudgetPlan."Deputation On"::Branch:
                        begin
                            Branch.Reset;
                            Branch.SetRange("Reporting Category", HRBudgetPlan.Code);
                            Branch.SetRange(Blocked, false);
                            if Branch.FindSet then
                                repeat
                                    InitHRBudgetCombination(true, Branch.Code, Branch.Name);
                                until Branch.Next = 0;
                        end;
                    HRBudgetPlan."Deputation On"::Province:
                        begin
                            Province.Reset;
                            Province.SetRange("Reporting Category", HRBudgetPlan.Code);
                            Province.SetRange(Blocked, false);
                            if Province.FindSet then
                                repeat
                                    InitHRBudgetCombination(true, Province.Code, Province.Description);
                                until Province.Next = 0;
                        end;
                    HRBudgetPlan."Deputation On"::"Sub Province":
                        begin
                            SubProvince.Reset;
                            SubProvince.SetRange("Reporting Category", HRBudgetPlan.Code);
                            SubProvince.SetRange(Blocked, false);
                            if SubProvince.FindSet then
                                repeat
                                    InitHRBudgetCombination(true, SubProvince.Code, SubProvince.Code);
                                until SubProvince.Next = 0;
                        end;
                    HRBudgetPlan."Deputation On"::"Extension Counter":
                        begin
                            EmployeeHierarchyMaster.Reset;
                            EmployeeHierarchyMaster.SetRange("Reporting Category", HRBudgetPlan.Code);
                            EmployeeHierarchyMaster.SetRange(Type, EmployeeHierarchyMaster.Type::"Extension Counter");
                            EmployeeHierarchyMaster.SetRange(Blocked, false);
                            if EmployeeHierarchyMaster.FindSet then
                                repeat
                                    InitHRBudgetCombination(true, EmployeeHierarchyMaster.Code, EmployeeHierarchyMaster.Description);
                                until EmployeeHierarchyMaster.Next = 0;
                        end;
                    HRBudgetPlan."Deputation On"::Unit:
                        begin
                            EmployeeHierarchyMaster.Reset;
                            EmployeeHierarchyMaster.SetRange("Reporting Category", HRBudgetPlan.Code);
                            EmployeeHierarchyMaster.SetRange(Type, EmployeeHierarchyMaster.Type::Unit);
                            EmployeeHierarchyMaster.SetRange(Blocked, false);
                            if EmployeeHierarchyMaster.FindSet then
                                repeat
                                    InitHRBudgetCombination(true, EmployeeHierarchyMaster.Code, EmployeeHierarchyMaster.Description);
                                until EmployeeHierarchyMaster.Next = 0;
                        end;
                end;
                HRBudgetPlan.Posted := true;
                HRBudgetPlan."Posted By" := UserId;
                HRBudgetPlan."Posted DateTime" := CurrentDateTime;
                HRBudgetPlan.Modify;
            until HRBudgetPlan.Next = 0;

        Message('HR budget created successfully.');
    end;

    local procedure InitHRBudgetCombination(NeedReportingCategory: Boolean; DeputationCode: Code[20]; DeputaionName: Text)
    begin
        RequiredEmpInBranch.Init;
        RequiredEmpInBranch."Fiscal Year" := HRBudgetPlan."Fiscal Year";
        RequiredEmpInBranch."Deputation On" := HRBudgetPlan."Deputation On";
        RequiredEmpInBranch."Functional Title" := HRBudgetPlan."Functional Title Code";
        RequiredEmpInBranch."Functional Tilte Description" := HRBudgetPlan."Functional Title";
        RequiredEmpInBranch."Salary Level Code" := HRBudgetPlan."Salary Level Code";
        RequiredEmpInBranch."Salary Level" := HRBudgetPlan."Salary Level";
        RequiredEmpInBranch."Required Employee" := HRBudgetPlan."No. of Employees";
        if NeedReportingCategory then begin
            RequiredEmpInBranch."Reporting Category" := HRBudgetPlan.Code;
            RequiredEmpInBranch.Code := DeputationCode;
            RequiredEmpInBranch.Description := DeputaionName;
        end else begin
            RequiredEmpInBranch.Code := HRBudgetPlan.Code;
            RequiredEmpInBranch.Description := HRBudgetPlan.Description;
        end;
        RequiredEmpInBranch.Insert;
    end;
}
