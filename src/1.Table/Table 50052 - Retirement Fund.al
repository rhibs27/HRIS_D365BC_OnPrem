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
                    NoSeriesMgt.TestManual(HRSetup."Retirement Fund Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Fiscal Year"; Code[10])
        {
        }
        field(3; "Payroll Month"; Enum "Nepali Month")
        {
            Description = 'Month for next Payroll';
        }
        field(4; "No. Series"; Code[10]) { }
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
        field(7; "Annual Accessible Income"; Decimal)
        {
            // Description = 'Assesable Income for the year (incuding\'
            //               '\'
            //               'up to last voucher/mpl oyee\'
            //               '\'
            //               '\'
            //               '\'
            //               'nnual assessable income is';
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
            // Description = 'Max limit - Actual/Projected contribution\'
            //               '\'
            //               '';
        }
        field(14; "NICA RTF Amount (Month)"; Decimal)
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
        field(17; "NICA RTF Amount (Lumpsum)"; Decimal)
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
        field(22; "Approval Status"; Enum "Retirement Approval Status")
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

            trigger OnValidate()
            begin
                PayrollGeneralSetup.Get; //Min
                if PayrollGeneralSetup."Enable RF Lumpsump Plan" then begin
                    Employee.Get(HRMgt.GetEmployeeNo);
                    if Employee."CIT No." <> '' then
                        TestField("Actual Lumpsump CIT");
                end;
            end;
        }
        field(29; "Actual Lumpsump RTF"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*PayrollGeneralSetup.GET; //Min
                IF PayrollGeneralSetup."Enable RF Lumpsump Plan" THEN BEGIN
                  IF "Actual Lumpsump RTF" <= 0 THEN
                    ERROR('Actual Lumpsum RTF Contribution Amount must be greater then 0.');
                  END;*/
            end;
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
    }

    keys
    {
        key(Key1; "No.") { }
    }
    trigger OnInsert()
    begin
        if not GuiAllowed then begin
            TempRF := Rec;
            HRMgt.OpenRFRequest(HRMgt.GetEmployeeNo(), RF);
            Rec := RF;
            "NICA RTF Amount (Lumpsum)" := TempRF."NICA RTF Amount (Lumpsum)";
            "NICA RTF Amount (Month)" := TempRF."NICA RTF Amount (Month)";
            "CIT Amount (Month)" := TempRF."CIT Amount (Month)";
            "CIT Amount( Lumpsum)" := TempRF."CIT Amount( Lumpsum)";
            "Approval Status" := "Approval Status"::"Pending Approval";
            "Actual Lumpsump CIT" := TempRF."Actual Lumpsump CIT"; //Min
            "Actual Lumpsump RTF" := TempRF."Actual Lumpsump RTF";
            HRMgt.CalculateRetirementFund(Rec, "Projection Month")
        end;

        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Retirement Fund Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Retirement Fund Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        if ("CIT Amount (Month)" <> 0) or ("CIT Amount( Lumpsum)" <> 0) then begin
            Employee.Get(HRMgt.GetEmployeeNo);
            if Employee."CIT No." = '' then
                Error('Your CIT no. is blank. Please verify with HR department.');
        end;
        /*PayrollGeneralSetup.GET; //Min
        IF PayrollGeneralSetup."Enable RF Lumpsump Plan" THEN BEGIN
          TESTFIELD("NICA RTF Amount (Lumpsum)",0);
          TESTFIELD("CIT Amount( Lumpsum)",0);
          IF "Actual Lumpsump RTF" <= 0 THEN
            ERROR('Actual Lumpsum RTF Contribution Amount must be greater then 0.');
          Employee.GET(HRMgt.GetEmployeeNo);
          IF Employee."CIT No." <> '' THEN
            TESTFIELD("Actual Lumpsump CIT");
          END;*/
    end;

    trigger OnModify()
    begin
        if not GuiAllowed then begin
            TestField("Approval Status", "Approval Status"::Open);
            HRMgt.CalculateRetirementFund(Rec, "Projection Month");
            "Approval Status" := "Approval Status"::"Pending Approval";
        end;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

        HRMgt: Codeunit "HR Mgt.";
        TempRF: Record "Retirement Fund" temporary;
        RF: Record "Retirement Fund" temporary;
        Employee: Record Employee;
        PayrollGeneralSetup: Record "Payroll General Setup";

    [Scope('Personalization')]
    procedure AssistEdit(OldRF: Record "Retirement Fund"): Boolean
    var
        RF: Record "Retirement Fund";
    begin
        with RF do begin
            RF := Rec;
            HRSetup.Get;
            HRSetup.TestField("Retirement Fund Nos.");
            if NoSeriesMgt.SelectSeries(HRSetup."Retirement Fund Nos.", OldRF."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := RF;
                exit(true);
            end;
        end;
    end;
}
