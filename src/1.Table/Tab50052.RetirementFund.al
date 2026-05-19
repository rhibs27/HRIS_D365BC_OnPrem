table 50052 "Retirement Fund"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HRSetup.Get;
                    NoSeries.TestManual(HRSetup."Retirement Fund Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Fiscal Year"; Code[20]) { }
        field(3; "Payroll Month"; Enum "Nepali Month")
        {
            Description = 'Month for next Payroll';
        }
        field(4; "No. Series"; Code[20]) { }
        field(5; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                HRMgt.GetEmployeeName("Employee No.", "Employee Name");
            end;
        }
        field(6; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Annual Assessable Income"; Decimal) { }
        field(8; "RF Contribution Eligible Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Max Limit';
        }
        field(9; "Provident Fund Deposited"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "RF Contribution Deposited"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Provident Fund Projected"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Actual/Projected Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Additional Space for RF Cont."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "RTF Amount (Month)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                HRMgt.CalculateRetirementFund(Rec, "Projection Month");
            end;
        }
        field(15; "CIT Amount (Month)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                HRMgt.CalculateRetirementFund(Rec, "Projection Month");
            end;
        }
        field(16; "Total Committed Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Total of (monthly*12)+ Lumpsum';
        }
        field(17; "RTF Amount (Lumpsum)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                HRMgt.CalculateRetirementFund(Rec, "Projection Month");
            end;
        }
        field(18; "CIT Amount( Lumpsum)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                HRMgt.CalculateRetirementFund(Rec, "Projection Month");
            end;
        }
        field(19; Difference; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Total Deduction"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Projection Month"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Approval Status"; Enum "Approval Status")
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(23; "Created Date"; date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Requested Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; "Screened Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "Screened By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(27; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Actual Lumpsump CIT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Actual Lumpsump RTF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Lumpsum Committed Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "CIT Contribution Deposited"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Lumpsum Space Max Benefit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Rejection Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Rejection Remarks';
        }
        field(34; "Recommended Monthly CIT/RF"; Decimal)
        {
            Description = 'Optimal monthly retirement deposit for minimise TAX';
        }
        field(35; Cancelled; Boolean) { }
        field(36; "Type"; enum "RF Contribution Type")
        {
            Caption = 'Type';
            trigger OnValidate()
            var
                RFContribution: Record "RF Contribution";
                PayCyclePeriod: Record "Pay Cycle Period";
                i: Integer;
            begin
                if xRec.Type <> Type then begin
                    RFContribution.SetRange("Document No.", "No.");
                    RFContribution.SetRange("Employee No.", "Employee No.");
                    RFContribution.DeleteAll();
                end;

                if Type = Type::Manual then begin
                    PayCyclePeriod.SetRange("Pay Cycle Code", "Pay Cycle Code");
                    PayCyclePeriod.SetRange("Pay Cycle Term", "Pay Cycle Term");
                    PayCyclePeriod.SetRange(Posted, false);
                    if PayCyclePeriod.FindSet() then
                        repeat
                            InsertRFcontribution(i, PayCyclePeriod);
                        until PayCyclePeriod.Next() = 0

                end else
                    InsertRFcontribution(i, PayCyclePeriod);
            end;
        }
        field(40; "One Time Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(100; Status; Text[100])
        {
            Caption = 'Status';
        }
        field(101; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(102; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(103; "Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes Usage".Code where("Employee Code" = field("Employee No."), Subtype = filter(CIT | RF));
            Caption = 'Attribute Code';
            trigger OnValidate()
            var
                RFContr: Record "RF Contribution";
            begin
                if Type = Type::Manual then
                    exit;

                RFContr.SetRange("Document No.", '');
                RFContr.SetRange("Employee No.", "Employee No.");
                RFContr.SetRange("Attribute Code", "Attribute Code");
                if RFContr.FindFirst() then
                    Error('RF Contribution record already exists for Employee %1 and Attribute %2', "Employee No.", "Attribute Code");
            end;
        }
        field(301; "Access Token"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.") { }
        key(Key2; "Access Token")
        {

        }
    }
    trigger OnInsert()
    var
        EmpActivityType: Enum "Employee Activity Type";
        RetirementFund: Record "Retirement Fund";
        PayrollGeneralSetup: Record "Payroll General Setup";
    begin

        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Retirement Fund Nos.");

            HRMgt.InitNoSeriesNew(HRSetup."Retirement Fund Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            RetirementFund.ReadIsolation(IsolationLevel::ReadUncommitted);
            RetirementFund.SetLoadFields("No.");
            while RetirementFund.get("No.") do
                "No." := NoSeries.GetNextNo("No. Series");

            if "Approval Status" <> "Approval Status"::Approved then
                ApproverMgt.InsertApproval("Employee No.", "No.", EmpActivityType::Retirement, "Approval Status");
        end;

        if ("CIT Amount (Month)" <> 0) or ("CIT Amount( Lumpsum)" <> 0) then begin
            Employee.Get(TempRF."Employee No.");
            if Employee."CIT No." = '' then
                Error('Your CIT no. is blank. Please verify with HR department.');
        end;
        PayrollGeneralSetup.Get();
        "Pay Cycle Code" := PayrollGeneralSetup."Pay Cycle Code";
        "Pay Cycle Term" := PayrollGeneralSetup."Pay Cycle Term";
    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
        ApprovalEntry: Record "Approval HRMS";
        RFContributionLine: Record "RF Contribution";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Created, "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
            RFContributionLine.Reset();
            RFContributionLine.SetRange("Document No.", "No.");
            RFContributionLine.DeleteAll();
        end;
    end;

    local procedure InsertRFcontribution(var LineNo: Integer; PayCyclePeriod: Record "Pay Cycle Period")
    var
        RFContribution: Record "RF Contribution";

    begin
        TestField(Type);
        TestField("Attribute Code");

        LineNo += 10000;

        RFContribution.Init;
        RFContribution."Document No." := "No.";
        RFContribution."Line No." += LineNo;
        RFContribution."Employee No." := "Employee No.";
        RFContribution."Employee Name" := "Employee Name";
        RFContribution."Pay Cycle Code" := "Pay Cycle Code";
        RFContribution."Pay Cycle Term" := "Pay Cycle Term";
        RFContribution.Type := Type;
        RFContribution."Attribute Code" := "Attribute Code";
        RFContribution."Pay Cycle Period" := PayCyclePeriod.Period;
        RFContribution."Nepali Month" := PayCyclePeriod."Nepali Month";
        RFContribution."Approval Status" := RFContribution."Approval Status"::Created;
        RFContribution.Insert;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        NoSeries: Codeunit "No. Series";
        HRMgt: Codeunit "HR Mgt.";
        TempRF: Record "Retirement Fund" temporary;
        TempRF2: Record "Retirement Fund" temporary;
        Employee: Record Employee;
        ApproverMgt: Codeunit "Approver Mgt";

    procedure AssistEdit(OldRF: Record "Retirement Fund"): Boolean
    var
        RetirementFund: Record "Retirement Fund";
    begin
        RetirementFund := Rec;
        HRSetup.Get;
        HRSetup.TestField("Retirement Fund Nos.");
        if NoSeries.LookupRelatedNoSeries(HRSetup."Retirement Fund Nos.", OldRF."No. Series", RetirementFund."No. Series") then begin
            NoSeries.GetNextNo(RetirementFund."No.");
            Rec := RetirementFund;
            exit(true);
        end;
    end;
}
