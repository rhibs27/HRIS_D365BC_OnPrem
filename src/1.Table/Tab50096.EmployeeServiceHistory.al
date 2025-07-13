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
                if Employee.Get("Employee No.") then
                    Validate("Employee Name", Employee."Full Name");
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
        field(9; "Deputation Code (From)"; Code[20]) { }
        field(10; "Deputation Value (From)"; Text[100]) { }
        field(11; "Functional Title (From)"; Code[20])
        {
            trigger OnValidate()
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
            begin
                if FunctionalTitle.Get("Functional Title (To)") then
                    Validate("Functional Title Desc. (To)", FunctionalTitle.Description);

                // if ("Functional Title (From)" <> "Functional Title (To)") and ("Service Event" <> "Service Event"::Appointment) then begin
                //     KPIMgt.CreateAppriasalAfterEmployeeTransfer("Employee No.");
                //     KPIMgt.ExpireKPITarget("Functional Title (From)", "Employee No.");
                // end;  //this code need to move to company specific
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
        field(19; "Effective Date"; Date) { }
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
    }

    keys
    {
        key(Key1; "Service History Code") { }
    }

    fieldgroups { }

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
        FunctionalTitle: Record "Functional Title";
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
        KPIMgt: Codeunit "KPI Mgt.";
        HrMgt: Codeunit "HR Mgt.";
}
