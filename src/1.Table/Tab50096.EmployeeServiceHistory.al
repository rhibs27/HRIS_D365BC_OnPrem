table 50096 "Employee Service History"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Service History Code"; Code[20])
        {
            trigger OnValidate()
            begin
                if "Service History Code" <> '' then begin
                    HRSetup.Get;
                    HRSetup.TestField("Service History No. Series");
                    NoSeriesMgt.TestManual(HRSetup."Service History No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                    Validate("Employee Name", Employee."Full Name");
                    Validate("Employee Attendance ID", Employee."Employee Attendance ID");

                    if not "Package Record" then begin
                        Validate("Deputation On(From)", Employee."Deputation on");
                        Validate("Deputation Code (From)", Employee."Deputation On Code");
                        Validate("Functional Title (From)", Employee."Functional Title");
                        Validate("Salary Level (From)", Employee."Salary Level");
                        Validate("Salary Grade (From)", Employee."Salary Grade");
                        Validate("Contract Code (From)", Employee."Emplymt. Contract Code");
                        Validate("Employment Type (From)", Employee."Employment Type");
                        Validate("Province Code (From)", Employee."Province Code");
                        Validate("Branch Code (From)", Employee."Branch Code");
                        Validate("Department Code (From)", Employee."Department Code");
                        Validate("Unit Code (From)", Employee."Union Code");

                        Validate("Deputation On (To)", Employee."Deputation on");
                        Validate("Deputation Code (To)", Employee."Deputation On Code");
                        Validate("Functional Title (To)", Employee."Functional Title");
                        Validate("Salary Level (To)", Employee."Salary Level");
                        Validate("Salary Grade (To)", Employee."Salary Grade");
                        Validate("Contract Code (To)", Employee."Emplymt. Contract Code");
                        Validate("Employment Type (To)", Employee."Employment Type");
                        Validate("Province Code (To)", Employee."Province Code");
                        Validate("Branch Code (To)", Employee."Branch Code");
                        Validate("Department Code (To)", Employee."Department Code");
                        Validate("Unit Code (To)", Employee."Unit Code");
                    end;
                end
                else
                    "Employee Name" := '';
            end;
        }
        field(3; "Employee Name"; Text[50])
        {
        }
        field(4; "Deputation On (To)"; Enum "Deputation Type")
        {

        }
        field(5; "Deputation Code (To)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get("Deputation On (To)", "Deputation Code (To)") then
                    Validate("Deputation Value (To)", OrgStructureList.Name);
            end;
        }
        field(6; "Deputation Value (To)"; Text[100])
        {
        }
        field(7; "Service Event"; Enum "Service Event")
        {
        }
        field(8; "Deputation On(From)"; Enum "Deputation Type")
        {

        }
        field(9; "Deputation Code (From)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get("Deputation On(From)", "Deputation Code (From)") then
                    Validate("Deputation Value (From)", OrgStructureList.Name);
            end;
        }
        field(10; "Deputation Value (From)"; Text[100]) { }
        field(11; "Functional Title (From)"; Code[20])
        {
            trigger OnValidate()
            var
                FunctionalTitle: Record "Functional Title";
            begin
                if FunctionalTitle.Get("Functional Title (From)") then
                    Validate("Functional Title Desc. (From)", FunctionalTitle.Description);
            end;
        }
        field(12; "Functional Title Desc. (From)"; Text[100]) { }
        field(13; "Salary Level (From)"; Code[20])
        {
            trigger OnValidate()
            begin
                if SalaryLevel.Get("Salary Level (From)") then
                    Validate("Salary level Desc. (From)", SalaryLevel.Description);
            end;
        }
        field(14; "Salary level Desc. (From)"; Text[100]) { }
        field(15; "Functional Title (To)"; Code[20])
        {
            trigger OnValidate()
            var
                FunctionalTitle: Record "Functional Title";
            begin
                if FunctionalTitle.Get("Functional Title (To)") then
                    Validate("Functional Title Desc. (To)", FunctionalTitle.Description);
            end;
        }
        field(16; "Functional Title Desc. (To)"; Text[100]) { }
        field(17; "Salary Level (To)"; Code[20])
        {
            trigger OnValidate()
            begin
                if SalaryLevel.Get("Salary Level (To)") then
                    Validate("Salary Level Desc. (To)", SalaryLevel.Description);
            end;
        }
        field(18; "Salary Level Desc. (To)"; Text[100]) { }
        field(19; "Effective Date"; Date)
        {
            trigger OnValidate()
            begin
                "Effective Date (B.S.)" := EngNep.getNepaliDate("Effective Date");
            end;
        }
        field(20; Remarks; Text[250]) { }
        field(21; "Created by"; Text[50]) { }
        field(22; "Created DateTime"; DateTime) { }
        field(23; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(24; "Salary Grade (From)"; Code[20])
        {
            TableRelation = "Salary Grade";
        }
        field(25; "Salary Grade (To)"; Code[20])
        {
            TableRelation = "Salary Grade";
        }
        field(26; "Document No."; Code[20]) { }
        field(27; "Outstation Eligible"; Boolean) { }
        field(30; "From Date"; Date) { }
        field(31; "To Date"; Date) { }
        field(32; "From Employee Status"; Enum "Employee Status") { }
        field(33; "To Employee Status"; Enum "Employee Status") { }

        field(34; "Contract Code (From)"; Code[20]) { }
        field(35; "Contract Code (To)"; Code[20]) { }
        field(36; "Employment Type (From)"; Enum "Employee Type") { }
        field(37; "Employment Type (To)"; Enum "Employee Type") { }
        field(50; Duration; text[50]) { }
        field(51; "Employment Type"; Enum "Employee Type") { }
        field(52; "Province Code (From)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Province, "Province Code (From)") then
                    "Province Description (From)" := OrgStructureList.Name
                else
                    "Province Description (From)" := '';
            end;
        }
        field(53; "Branch Code (From)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Branch, "Branch Code (From)") then
                    "Branch Description (From)" := OrgStructureList.Name
                else
                    "Branch Description (From)" := '';
            end;
        }
        field(54; "Department Code (From)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Department, "Department Code (From)") then
                    "Department Description (From)" := OrgStructureList.Name
                else
                    "Department Description (From)" := '';
            end;
        }
        field(55; "Unit Code (From)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Unit, "Unit Code (From)") then
                    "Unit Description (From)" := OrgStructureList.Name
                else
                    "Unit Description (From)" := '';
            end;
        }
        field(56; "Province Code (To)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Province, "Province Code (To)") then
                    "Province Description (To)" := OrgStructureList.Name
                else
                    "Province Description (To)" := '';
            end;
        }
        field(57; "Branch Code (To)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Branch, "Branch Code (To)") then
                    "Branch Description (To)" := OrgStructureList.Name
                else
                    "Branch Description (To)" := '';
            end;
        }
        field(58; "Department Code (To)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Department, "Department Code (To)") then
                    "Department Description (To)" := OrgStructureList.Name
                else
                    "Department Description (To)" := '';
            end;
        }

        field(59; "Unit Code (To)"; Code[20])
        {
            trigger OnValidate()
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Unit, "Unit Code (To)") then
                    "Unit Description (To)" := OrgStructureList.Name
                else
                    "Unit Description (To)" := '';
            end;
        }
        field(60; "Province Description (From)"; text[50]) { }
        field(61; "Branch Description (From)"; text[50]) { }
        field(62; "Department Description (From)"; text[50]) { }
        field(63; "Unit Description (From)"; text[50]) { }
        field(64; "Province Description (To)"; text[50]) { }
        field(65; "Branch Description (To)"; text[50]) { }
        field(66; "Department Description (To)"; text[50]) { }
        field(67; "Unit Description (To)"; text[50]) { }
        field(68; "Effective Date (B.S.)"; Code[10]) { }
        field(69; "Package Record"; Boolean) { }
        field(70; "Employee Attendance ID"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Service History Code") { }
        key(Key2; "Employee No.", "Effective Date") { }
    }


    trigger OnInsert()
    var
        EmpServiceHistory: Record "Employee Service History";
    begin
        "Created DateTime" := CurrentDateTime;
        "Created by" := UserId;
        if "Service History Code" = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Service History No. Series");
            HrMgt.InitNoSeriesNew(HRSetup."Service History No. Series", xRec."No. Series", Today, "Service History Code", "No. Series");

            EmpServiceHistory.ReadIsolation(IsolationLevel::ReadUncommitted);
            EmpServiceHistory.SetLoadFields("Service History Code");
            while EmpServiceHistory.Get("Service History Code") do
                "Service History Code" := NoSeriesMgt.GetNextNo(HRSetup."Service History No. Series");
        end;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
        HrMgt: Codeunit "HR Mgt.";
        OrgStructureList: Record "Organization Structure List";
        EngNep: Record "English-Nepali Date";

    procedure UpdateDuration(ServiceHistoryFrom: Record "Employee Service History")
    var
        EmpServiceHistory: Record "Employee Service History";
    begin
        EmpServiceHistory.SetRange("Employee No.", ServiceHistoryFrom."Employee No.");
        EmpServiceHistory.SetCurrentKey("Effective Date");
        EmpServiceHistory.SetAscending("Effective Date", true);
        if ServiceHistoryFrom."Service Event" = ServiceHistoryFrom."Service Event"::Appointment then
            EmpServiceHistory.SetRange("Service Event", ServiceHistoryFrom."Service Event"::Confirmation)
        else if ServiceHistoryFrom."Service Event" = ServiceHistoryFrom."Service Event"::"Period Extend" then
            EmpServiceHistory.SetFilter("Service Event", '%1|%2', ServiceHistoryFrom."Service Event"::"Period Extend", ServiceHistoryFrom."Service Event"::Confirmation)
        else if ServiceHistoryFrom."Service Event" = ServiceHistoryFrom."Service Event"::"Grade Increment" then
            EmpServiceHistory.SetFilter("Service Event", '%1|%2', ServiceHistoryFrom."Service Event"::"Grade Increment", ServiceHistoryFrom."Service Event"::Appraisal)
        else
            EmpServiceHistory.SetRange("Service Event", ServiceHistoryFrom."Service Event");
        EmpServiceHistory.SetFilter("Effective Date", '>%1', ServiceHistoryFrom."Effective Date");
        if EmpServiceHistory.FindFirst() then
            ServiceHistoryFrom.Duration := GetServiceDuration(ServiceHistoryFrom."Employee No.", ServiceHistoryFrom."Effective Date", EmpServiceHistory."Effective Date" - 1)
        else
            ServiceHistoryFrom.Duration := GetServiceDuration(ServiceHistoryFrom."Employee No.", ServiceHistoryFrom."Effective Date", Today);
        ServiceHistoryFrom.Modify();
    end;

    procedure GetServiceDuration(EmployeeNo: Code[20]; FromDate: Date; ToDate: Date): Text[50]
    var
        Employee: Record Employee;
        NewEffectiveDateDate: Date;
        ServiceDuration: Text[50];
    begin
        HRSetup.Get();
        Employee.Get(EmployeeNo);
        NewEffectiveDateDate := HrMgt.GetAdjustedEmploymentDate(Employee, FromDate, ToDate);
        if HRSetup."Calculate Age using Nepali C." then
            ServiceDuration := HrMgt.GetAgeBS(EngNep.getNepaliDate(NewEffectiveDateDate), EngNep.getNepaliDate(ToDate))
        else
            ServiceDuration := HrMgt.GetAge(NewEffectiveDateDate, ToDate);
        exit(ServiceDuration);
    end;
}
