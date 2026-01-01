table 50133 "KPI Appraisal Header Bank"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Appraisal Code"; Code[20])
        {
            trigger OnValidate()
            begin
                if "Appraisal Code" <> xRec."Appraisal Code" then begin//KP1.00
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."KPI Appriasal No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee Code") then begin//KP1.00
                    "Employee Name" := Employee."Full Name";
                    "Branch Code" := Employee."Global Dimension 1 Code";
                    "Branch Name" := Employee."Branch Name";
                    Validate("Functional Title", Employee."KPI Functional Title");
                    Validate(Department, Employee."KPI Deputation Value");
                end;
            end;
        }
        field(3; "Employee Name"; Text[250])
        {
            Editable = false;
        }
        field(4; "Functional Title"; Text[250])
        {
            Editable = false;
            TableRelation = "Functional Title";

            trigger OnValidate()
            begin
                if Employee."KPI Deputation" in [Employee."KPI Deputation"::Department, Employee."KPI Deputation"::Unit] then //KPI1.00
                    Type := Type::"Department Central Level"
                else if Employee."KPI Deputation" in [Employee."KPI Deputation"::Branch, Employee."KPI Deputation"::"Extension Counter", Employee."KPI Deputation"::Province] then begin
                    if FunctionalTitle.Get("Functional Title") then begin
                        if FunctionalTitle."Is Specific Functional" then
                            Type := Type::Functional
                        else
                            Type := Type::"Department Province Level";
                    end;
                end;
                if "Appraisal Code" <> '' then //KP1.00
                    InsertAppraisalLine;
            end;
        }
        field(5; Department; Code[20])
        {
            Editable = true;
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));

            trigger OnValidate()
            begin
                if Type = Type::Department then begin
                    if "Appraisal Code" <> '' then//KP1.00
                        InsertAppraisalLine;
                end;
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, Department) then
                    "Department Name" := OrganizationStructureList.Name;
            end;
        }
        field(6; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
            Editable = false;
        }
        field(7; "Branch Name"; Text[250])
        {
            Editable = false;
        }
        field(8; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(9; "Date and Time"; DateTime) { }
        field(10; "No. Series"; Code[20]) { }
        field(11; "KPI Score"; Decimal)
        {
            CalcFormula = average("KPI Daily Incentive"."KPI Score" where("Employee Code" = field("Employee Code"),
                                                                           Quarter = field(Quarter),
                                                                           "Entry Date" = field("Date Filter"),
                                                                           "Functional Title" = field("Functional Title")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "KPI Score With Location Inc"; Decimal)
        {
            CalcFormula = average("KPI Daily Incentive"."Location Incentive" where("Employee Code" = field("Employee Code"),
                                                                                    Quarter = field(Quarter),
                                                                                    "Fiscal Year" = field("Fiscal Year"),
                                                                                    Type = const(Employee),
                                                                                    "Entry Date" = field("Date Filter"),
                                                                                    "Functional Title" = field("Functional Title")));
            Caption = 'Location Incentive';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "KPI Score With Role Incentive"; Decimal)
        {
            CalcFormula = average("KPI Daily Incentive"."Role Incentive" where("Employee Code" = field("Employee Code"),
                                                                                Quarter = field(Quarter),
                                                                                "Fiscal Year" = field("Fiscal Year"),
                                                                                Type = const(Employee),
                                                                                "Entry Date" = field("Date Filter"),
                                                                                "Functional Title" = field("Functional Title")));
            Caption = 'Role Incentive';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Net KPI Score"; Decimal)
        {
            CalcFormula = average("KPI Daily Incentive"."Net KPI Score" where("Employee Code" = field("Employee Code"),
                                                                               Quarter = field(Quarter),
                                                                               "Fiscal Year" = field("Fiscal Year"),
                                                                               Type = const(Employee),
                                                                               "Entry Date" = field("Date Filter"),
                                                                               "Functional Title" = field("Functional Title")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; Type; Enum "KPI Setup Type")
        {
            Editable = true;
        }
        field(16; "Department Name"; Text[100]) { }
        field(17; Quarter; Text[20]) { }
        field(18; "Created Date"; Date)
        {
            trigger OnValidate()
            begin
                if Employee.Get("Employee Code") then begin
                    if Employee."Employment Type" = Employee."Employment Type"::Probation then
                        "Fiscal Year" := '';
                end else
                    "Fiscal Year" := KPIMgt.CalculateFiscalYear("Created Date");//Aarkista KPI1.00
            end;
        }
        field(19; "Closed KPI"; Boolean) { }
        field(20; "End Date"; Date) { }
        field(21; "Fiscal Year"; Text[20]) { }
        field(22; "Approved KPI Score"; Decimal) { }
        field(23; "Net Approved KPI Score"; Decimal) { }
        field(24; "Net KPI Score Dept"; Decimal)
        {
            CalcFormula = average("KPI Daily Incentive"."Net KPI Score" where(Department = field(Department),
                                                                               Quarter = field(Quarter),
                                                                               "Fiscal Year" = field("Fiscal Year"),
                                                                               Type = const(Department)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(26; Rating; Enum "Appraisal Rating") { }
        field(27; Reviewer; Code[20])
        {
            TableRelation = Employee;
        }
        field(28; "Check Reviewer"; Code[20])
        {
            TableRelation = Employee;
        }
        field(29; Status; Enum "Appraisal Status") { }
        field(30; "Is Modified"; Boolean) { }
        field(31; "Reviewed KPI Score"; Decimal) { }
    }

    keys
    {
        key(Key1; "Appraisal Code") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "User ID" := UserId;//KP1.00
        "Date and Time" := CurrentDateTime;
        Validate("Created Date", Today);
        HumanResSetup.Get;
        if "Appraisal Code" = '' then begin
            HumanResSetup.TestField("Appraisal No.");
            HRMgt.InitNoSeriesNew(HumanResSetup."KPI Appriasal No.", xRec."No. Series", 0D, "Appraisal Code", "No. Series");
            KPIAppraisalHeaderBankRec.ReadIsolation(IsolationLevel::ReadCommitted);
            KPIAppraisalHeaderBankRec.SetLoadFields("Appraisal Code");
            while KPIAppraisalHeaderBankRec.Get("Appraisal Code") do
                "Appraisal Code" := NoSeriesMgt.GetNextNo("No. Series");
        end;
    end;

    trigger OnModify()
    begin
        "User ID" := UserId;
        "Date and Time" := CurrentDateTime;//KP1.00
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Employee: Record Employee;
        KPISetup: Record "KPI Setup Bank";
        KPIAppraisalLine: Record "KPI Appraisal Bank Lines";
        OrganizationStructureList: Record "Organization Structure List";
        FunctionalTitle: Record "Functional Title";
        KPIMgt: Codeunit "KPI Mgt.";
        KPIMaster: Record "KPI Master Bank";
        HRMgt: Codeunit "HR Mgt.";
        KPIAppraisalHeaderBankRec: Record "KPI Appraisal Header Bank";

    local procedure InsertAppraisalLine()
    var
        LineNo: Integer;
        KPIMgt: Codeunit "KPI Mgt.";
    begin
        KPIAppraisalLine.Reset;//Aakrista KPI1.00
        KPIAppraisalLine.SetRange("Appraisal Code", "Appraisal Code");
        if Type = Type::Functional then
            KPIAppraisalLine.SetRange(Type, KPIAppraisalLine.Type::Functional)
        else if Type = Type::Department then
            KPIAppraisalLine.SetRange(Type, KPIAppraisalLine.Type::Department)
        else if Type = Type::"Department Central Level" then
            KPIAppraisalLine.SetRange(Type, KPIAppraisalLine.Type::"Department Central Level")
        else if Type = Type::"Department Province Level" then
            KPIAppraisalLine.SetRange(Type, KPIAppraisalLine.Type::"Department Province Level");
        KPIAppraisalLine.DeleteAll;

        KPIAppraisalLine.Reset;
        KPIAppraisalLine.SetRange("Appraisal Code", "Appraisal Code");
        KPIAppraisalLine.SetCurrentKey("Line No.");
        if KPIAppraisalLine.FindLast then
            LineNo := KPIAppraisalLine."Line No."
        else
            LineNo := 0;
        KPISetup.Reset;
        if Type = Type::Functional then begin
            KPISetup.SetRange(Type, KPISetup.Type::Functional);
            KPISetup.SetRange(Code, "Functional Title");
        end else if Type = Type::Department then begin
            KPISetup.SetRange(Type, KPISetup.Type::Department);
            KPISetup.SetRange(Code, Department);
        end else if (Type = Type::"Department Central Level") or (Type = Type::"Department Province Level") then begin
            KPISetup.SetRange(Type, KPISetup.Type::"Department Central & Province Level");
            KPISetup.SetRange(Code, "Functional Title");
        end;
        if KPISetup.FindFirst then
            repeat
                KPIAppraisalLine.Reset;
                KPIAppraisalLine.SetRange("KPI Code", KPISetup."KPI Code");
                KPIAppraisalLine.SetRange("Employee Code", "Employee Code");
                KPIAppraisalLine.SetRange("Appraisal Code", "Appraisal Code");
                if not KPIAppraisalLine.FindFirst then begin
                    KPIAppraisalLine.Init;
                    KPIAppraisalLine."Appraisal Code" := "Appraisal Code";
                    KPIAppraisalLine."KPI Code" := KPISetup."KPI Code";
                    KPIAppraisalLine."KPI Description" := KPISetup."KPI Description";
                    KPIAppraisalLine."Weightage %" := KPISetup."Weightage %";
                    KPIAppraisalLine.Type := KPISetup.Type;
                    KPIAppraisalLine."Department Code" := Department;
                    KPIAppraisalLine."Employee Code" := "Employee Code";
                    KPIAppraisalLine.Quarter := Quarter;
                    KPIAppraisalLine."Fiscal Year" := KPIMgt.CalculateFiscalYear("Created Date");
                    KPIAppraisalLine."Line No." := LineNo + 10000;
                    if KPIMaster.Get(KPISetup."KPI Code") then begin
                        KPIAppraisalLine."KPI Type" := KPIMaster.Type;
                    end;
                    KPIAppraisalLine."KPI Category" := KPISetup."KPI Category";
                    LineNo += 10000;
                    KPIAppraisalLine.Insert;
                end;
            until KPISetup.Next = 0;
        //KPIMgt.InsertDeptScoreForEmployee(Department);
    end;
}
