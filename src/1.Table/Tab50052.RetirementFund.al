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
        field(2; "Fiscal Year"; Code[20])
        {
        }
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
        field(7; "Annual Assessable Income"; Decimal)
        {

        }
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
        field(23; "Created Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Requested Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; "Screened Date"; DateTime)
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
        field(35; Cancelled; Boolean)
        {

        }
        field(36; "Type"; enum "RF Contribution Type")
        {
            Caption = 'Type';
        }
    }

    keys
    {
        key(Key1; "No.") { }
    }
    trigger OnInsert()
    var
        EmpActivityType: Enum "Employee Activity Type";
                             RetirementFund: Record "Retirement Fund";
    begin
        if not GuiAllowed then begin
            TempRF := Rec;
            HRMgt.OpenRFRequest(TempRF."Employee No.", TempRF2);
            Rec := TempRF2;
            "RTF Amount (Lumpsum)" := TempRF."RTF Amount (Lumpsum)";
            "RTF Amount (Month)" := TempRF."RTF Amount (Month)";
            "CIT Amount (Month)" := TempRF."CIT Amount (Month)";
            "CIT Amount( Lumpsum)" := TempRF."CIT Amount( Lumpsum)";
            "Approval Status" := "Approval Status"::Pending;
            "Actual Lumpsump CIT" := TempRF."Actual Lumpsump CIT";
            "Actual Lumpsump RTF" := TempRF."Actual Lumpsump RTF";
            HRMgt.CalculateRetirementFund(Rec, "Projection Month")
        end;

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
    end;

    trigger OnModify()
    begin
        if not GuiAllowed then begin
            TestField("Approval Status", "Approval Status"::Open);
            HRMgt.CalculateRetirementFund(Rec, "Projection Month");
            "Approval Status" := "Approval Status"::Pending;
        end;
    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
        ApprovalEntry: Record "Approval HRMS";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Created]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
        end;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        NoSeries: Codeunit "No. Series";
        HRMgt: Codeunit "HR Mgt.";
        TempRF: Record "Retirement Fund" temporary;
        TempRF2: Record "Retirement Fund" temporary;
        Employee: Record Employee;
        PayrollGeneralSetup: Record "Payroll General Setup";
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
