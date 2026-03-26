table 50106 "Employee Loan/Advance"
{
    DataCaptionFields = "No.", "Employee No.", "Employee Name";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    case "Loan Type" of
                        "Loan Type"::"Salary Advance":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Salary Advance No.");
                                "No. Series" := '';
                            end;

                        "Loan Type"::"Personal Loan":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Personal Loan No.");
                                "No. Series" := '';
                            end;

                        "Loan Type"::"Home Loan":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Home Loan No.");
                                "No. Series" := '';
                            end;

                        "Loan Type"::"Vehicle Loan":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Vehicle Loan No.");
                                "No. Series" := '';
                            end;
                    end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type") { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                    if not LoanMgt.CheckLoanEligibility(Employee) then
                        Error('You are not Eligible for loan apply.');
                    "Employee Name" := Employee.FullName();
                    Validate("Employee Type", "Employee Type");
                    Validate("Job Title", Employee."Job Title");
                    Validate(Gender, Employee.Gender);
                    Validate("Deputation On", Employee."Deputation on");
                    Validate("Deputation On Code", Employee."Deputation On Code");
                    Validate("Province Code", Employee."Province Code");
                    Validate("Branch Code", Employee."Branch Code");
                    Validate("Department Code", Employee."Department Code");
                    Validate("Extension Counter Code", Employee."Extension Counter Code");
                    Validate("Unit Code", Employee."Unit Code");
                    Validate("Province Name", Employee."Province Name");
                    Validate("Branch Name", Employee."Branch Name");
                    Validate("Department Name", Employee."Department Name");
                    Validate("Extension Counter Name", Employee."Extension Counter Name");
                    Validate("Unit Name", Employee."Unit Name");
                    Validate("Functional title", Employee."Functional Title");
                    Validate("Salary Account Number", Employee."Bank Account No.");
                    Validate("Employee Name in Nepali", Employee."Full Name (Nepali)");
                    Validate("Father's Name In Nepali", Employee."Father's Name (Nepali)");
                    Validate("Grandfather's Name In Nepali", Employee."GrandFather's Name (Nepali)");
                    Validate("License No.", Employee."Driving License No.");

                    if "Loan Type" = "Loan Type"::"Salary Advance" then
                        LoanMgt.NewSalaryAdvanceCheck("Employee No.");
                    Validate("Salary Level", Employee."Salary Level");
                end;
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Employee Type"; enum "Employee Type")
        {
            Editable = false;
        }
        field(6; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
            Editable = false;
        }
        field(7; "Confirmation Service Period"; Decimal)
        {
            Editable = false;
        }
        field(8; "Employment Date"; Date)
        {
            Editable = false;
        }
        field(9; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(10; "Gross Salary"; Decimal) { }
        field(11; "Fiscal Year"; Code[20]) { }
        field(13; "Date of Birth"; Date)
        {
            Editable = false;
        }
        field(14; Age; Integer) { }
        field(16; "Approval Status"; Enum "Approval Status") { }
        field(17; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Total Loan Amount"; Decimal)
        {
            Editable = false;
        }
        field(22; "Vehicle Purchase Type"; Enum "Vehicle Purchase Type") { }
        field(23; "Citizenship No."; Code[30])
        {
            Editable = false;
        }
        field(24; "Citizenship Issue Date"; Date)
        {
            Editable = false;
        }
        field(25; Remarks; Text[250]) { }
        field(26; "Eligible Loan/Advance"; Decimal) { }
        field(27; "Applied Loan/Advance"; Decimal) { }
        field(28; "Payback Months"; Enum "Payback Months") { }
        field(29; "DBR Ratio"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(30; "Requested Loan Date"; Date)
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Requested Loan Date"));
            end;
        }
        field(31; "Remaining Service Period"; Decimal)
        {
            Editable = false;
        }
        field(32; "Loan Type"; Enum "Loan Type")
        {
            Editable = false;
        }
        field(33; "Vehicle Loan Type"; Enum "Vehicle Type")
        {
            Description = 'Vehicle';
        }
        field(34; "Repayment Period"; Decimal)
        {
            Description = 'Vehicle,Home';
            InitValue = 1;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Loan Type" in ["Loan Type"::"Personal Loan", "Loan Type"::"Home Loan", "Loan Type"::"Vehicle Loan"] then
                    LoanMgt.CheckRankforEmployeeLoan(Rec);
            end;
        }
        field(35; "Name of Supplier"; Text[30])
        {
            Description = 'Vehicle';
        }
        field(36; "Cost of Vehicle"; Decimal)
        {
            Description = 'Vehicle';
        }
        field(37; "Approved Date"; Date) { }
        field(38; "Max. Loan Amount"; Decimal) { }
        field(39; "Purpose of Loan"; Text[250])
        {
            Description = 'Personal';
        }
        field(40; "Interest Rate"; Decimal) { }
        field(41; EMI; Decimal) { }
        field(42; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                if Description = '' then
                    Description := CopyStr(IncomingDocument.Description, 1, MaxStrLen(Description));
                if "Incoming Document Entry No." = xRec."Incoming Document Entry No." then
                    exit;

                if "Incoming Document Entry No." = 0 then
                    IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                else
                    IncomingDocument.SetEmployeeLoan(Rec);
            end;
        }
        field(43; Description; Text[30]) { }
        field(44; "Purpose of Housing Loan"; Enum "Purpose of Housing Loan")
        {
            Description = 'Home';
        }
        field(45; "Repayment Mode"; Enum "Repayment Mode")
        {
            Description = 'Home';
            trigger OnValidate()
            begin
                if GuiAllowed then begin
                    if xRec."Repayment Mode" <> "Repayment Mode" then begin
                        Clear("Insurance Tieup");
                        Clear("Insurance Company Code");
                        Clear("Name of Insurance Company");
                        Clear("Applied Loan/Advance");
                        Modify(true);
                    end;
                    if "Repayment Mode" = "Repayment Mode"::"Insurance Tieup" then
                        Clear("Interest Rate");
                end;
            end;
        }
        field(46; "Commercial Value of Property"; Decimal)
        {
            Description = 'Home';

            trigger OnValidate()
            begin
                "Estimated Cost of Construction" := 0;
            end;
        }
        field(47; "Insurance Tieup"; Enum "Insurance Tieup")
        {
            trigger OnValidate()
            var
                InsurancePremiumSetup: Record "Insurance Premium Setup";
            begin
                if "Insurance Tieup" <> "Insurance Tieup"::" " then begin
                    InsurancePremiumSetup.Reset;
                    //InsurancePremiumSetup.SetRange("Insurance Company", "Insurance Tieup");
                    InsurancePremiumSetup.SetRange(Age, Age);
                    InsurancePremiumSetup.SetRange(Period, "Repayment Period");
                    if not InsurancePremiumSetup.FindFirst then
                        Error('Insurance Premium Setup is not available for this insurance company. Please contact HR department.');
                end;
            end;
        }
        field(12; "Insurance Company Code"; Code[20])
        {
            TableRelation = "Insurance Company";
            trigger OnValidate()
            var
                InsuranceCompany: Record "Insurance Company";
            begin
                if InsuranceCompany.Get("Insurance Company Code") then
                    "Name of Insurance Company" := InsuranceCompany.Name;
            end;
        }
        field(15; "Name of Insurance Company"; Text[50])
        {
            Editable = false;
        }
        field(48; "Property in the name of"; Text[50]) { }
        field(49; "Name of Spouse"; Text[50]) { }
        field(50; "Name of Owner"; Text[50]) { }
        field(51; "Address of Owner"; Text[50]) { }
        field(52; "Area of Plot"; Text[50])
        {
            trigger OnValidate()
            begin
                CheckAreaofPlotFormat("Area of Plot", FieldCaption("Area of Plot"), "Area Format");
            end;
        }
        field(53; "Estimated Cost of Construction"; Decimal)
        {
            Description = 'Home';

            trigger OnValidate()
            begin
                if GuiAllowed then
                    "Commercial Value of Property" := 0;
            end;
        }
        field(54; Frequency; Integer)
        {
            Editable = false;
        }
        field(58; "Address of Supplier"; Text[50])
        {
            Description = 'Vehicle';
        }
        field(59; "Rejection Remark"; Text[150])
        {
            trigger OnValidate()
            begin
                Clear(Remarks);
            end;
        }
        field(60; Disbursed; Boolean)
        {
            Editable = false;
        }
        field(61; "Disbursement Date"; Date)
        {
            Editable = false;
        }
        field(62; Settled; Boolean)
        {
            Description = '50';
            // Editable = false;
        }
        field(63; "Settlement Date"; Date)
        {
            Editable = false;
        }
        field(64; "Loan Enhancement"; Boolean) { }
        field(65; "Account No."; Code[20])
        {
            Editable = false;
        }
        field(66; "Area Format"; Enum "Area Format")
        {
            trigger OnValidate()
            begin
                Clear("Area of Plot");
                Clear("Area of Propty. tobe Purchased");
            end;
        }
        field(67; "Purpose of Advance Salary"; Text[250])
        {
            Description = 'Salary Advance';
        }
        field(68; "Settler User ID"; Code[50])
        {
            Editable = false;
        }
        field(69; "Screener Remarks"; Text[250])
        {
            Description = 'Salary Advance';
        }
        field(70; "Employee Name in Nepali"; Text[50])
        {
            Description = 'vehicle loan';
            Editable = false;
        }
        field(71; "Father's Name In Nepali"; Text[50])
        {
            Description = 'vehicle loan';
            Editable = false;
        }
        field(72; "Grandfather's Name In Nepali"; Text[50])
        {
            Description = 'vehicle loan';
            Editable = false;
        }
        field(73; "Vehicle Model"; Text[20])
        {
            Description = 'vehicle loan';
        }
        field(74; "Transportation Management off."; Text[30])
        {
            Description = 'vehicle loan';
        }
        field(75; "Vehicle Engine No."; Text[20])
        {
            Description = 'vehicle loan';
            Editable = false;
        }
        field(76; "Vehicle Chasis No."; Text[20])
        {
            Description = 'vehicle loan';
            Editable = false;
        }
        field(77; "Vehicle Registration No."; Text[20])
        {
            Description = 'vehicle loan';
            Editable = false;
        }
        field(78; "Disbursed Amount"; Decimal)
        {
            Description = 'vehicle loan';
            Editable = false;
        }
        field(79; "Outstanding Amount"; Decimal)
        {
            Description = 'vehicle loan';
        }
        field(80; Screener; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(81; "Complete Address of Property"; Text[80])
        {
            Description = 'home loan';
        }
        field(82; "Plot No. of Property"; Text[20]) { }
        field(83; "Recommendation Remarks"; Text[30]) { }
        field(84; "Offer Letter Issued Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            begin
                "Offer Letter Date(Nepali)" := HRMgt.GetNepaliDate("Offer Letter Issued Date");
            end;
        }
        field(85; "Amount In Words (Nepali)"; Text[50])
        {
            Description = 'In Nepali';
            Editable = false;
        }
        field(86; "Proposed Owner (Nepali)"; Text[30])
        {
            Description = 'In Nepali';
        }
        field(87; "Address of Property (Nepali)"; Text[50])
        {
            Description = 'In Nepali';
        }
        field(88; "Offer Letter Date(Nepali)"; Text[30])
        {
            Description = 'In Nepali';
            Editable = false;
        }
        field(89; "Loan Expiry Date"; Date)
        {
            Editable = false;
        }
        field(90; "Loan Expiry Date( Nepali)"; Text[10])
        {
            Editable = false;
        }
        field(91; "Vehicle Type (Nepali)"; Text[30]) { }
        field(92; "Approved By Board"; Boolean) { }
        field(93; "Previous Loan Amount"; Decimal)
        {
            Editable = false;
        }
        field(94; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(95; "Remaining Amount"; Decimal) { }
        field(96; "Screened Date"; Date) { }
        field(97; "Salary Advance Paid"; Decimal)
        {
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("Employee No."),
                                                                              "Salary Advance No." = field("No."),
                                                                              "Payroll Attribute Code" = const('SALARY ADVANCE'),
                                                                              Reversed = const(false)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(98; "Equity Financing Declaration"; Boolean) { }
        field(99; "Returned Loan"; Boolean) { }
        field(100; "Status"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Reinstate Date"; Date) { }
        field(102; "Age Home Loan"; Decimal) { }
        field(188; "Deputation On"; Enum "Deputation Type")
        {
            Caption = 'Deputation On';
        }
        field(189; "Deputation On Code"; Code[20])
        {
            Caption = 'Deputation On Code';
        }
        field(190; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Province));
        }
        field(191; "Province Name"; Text[50]) { }
        field(192; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
        }
        field(193; "Branch Name"; Text[50]) { }
        field(194; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
        }
        field(195; "Department Name"; Text[50]) { }
        field(196; "Extension Counter Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const("Extension Counter"));
        }
        field(197; "Extension Counter Name"; Text[50]) { }
        field(198; "Unit Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Unit));
        }
        field(199; "Unit Name"; Text[50]) { }
        //flow loan journal
        field(201; "Loan Account No."; text[30])
        {
            Description = 'Loan Account No.';
        }
        field(202; "Loan Account Name"; text[50])
        {
            Description = 'Loan Account Name';
        }
        field(204; "Loan Acc. Open Date"; Date)
        {
            Description = 'Loan Account Open Date';
        }
        field(205; "Yearly Premium Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(206; "Insurance Company"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(207; "Policy No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(208; "First Premium Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(209; "Monthly Deduction"; Decimal)
        {
            Caption = 'Monthly Deduction';
            DataClassification = ToBeClassified;
        }
        field(210; "Functional title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(211; "Salary Account Number"; Text[50])
        {
        }
        field(212; "Area of Propty. tobe Purchased"; Text[50])
        {
            trigger OnValidate()
            begin
                CheckAreaofPlotFormat("Area of Propty. tobe Purchased", FieldCaption("Area of Propty. tobe Purchased"), "Area Format");
            end;
        }
        field(213; "License No."; Text[30])
        {
        }
        field(214; "License Expiry Date"; Date)
        {
        }
        field(215; "License Category"; Enum "Driving License Category")
        {
        }
        field(216; "Driving License Owner"; Option)
        {
            OptionMembers = Self,Spouse;
        }
        field(217; "Staff VL previously"; Boolean)
        {
            trigger OnValidate()
            begin
                if not "Staff VL previously" then begin
                    Clear("HR Recommended Tenure");
                    Clear("HR VL Recommended Amount");
                end;
            end;
        }
        field(218; "HR VL Recommended Amount"; Decimal)
        {
        }
        field(219; "HR Recommended Tenure"; Integer)
        {
        }

    }

    keys
    {
        key(Key1; "No.") { }
        key(Key2; "Employee No.", "Loan Type", Settled)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    var
        incomingAttachmentDoc: Record "Incoming Document";
    begin
        // if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
        //     Error(CannotDelete);
        incomingAttachmentDoc.Reset();
        incomingAttachmentDoc.SetRange("No.", "No.");
        incomingAttachmentDoc.DeleteAll();
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        ApprovalEntry.DeleteAll();
    end;

    trigger OnInsert()
    var
        EmployeeAdvanceLoan: Record "Employee Loan/Advance";
    begin
        Validate(Type, Rec.Type::Loan);

        HRSetup.Get;
        if "No." = '' then begin
            Validate("Approval Status", "Approval Status"::Open);
            case "Loan Type" of
                "Loan Type"::"Salary Advance":
                    begin
                        HRSetup.TestField("Salary Advance No.");
                        HRMgt.InitNoSeriesNew(HRSetup."Salary Advance No.", xRec."No. Series", "Requested Loan Date", "No.", "No. Series");
                        SalaryAdvanceControl();
                        SalaryAdvanceFiscalYearControl();
                    end;
                "Loan Type"::"Personal Loan":
                    begin
                        HRSetup.TestField("Personal Loan No.");
                        HRMgt.InitNoSeriesNew(HRSetup."Personal Loan No.", xRec."No. Series", "Requested Loan Date", "No.", "No. Series");
                    end;
                "Loan Type"::"Home Loan":
                    begin
                        HRSetup.TestField("Home Loan No.");
                        HRMgt.InitNoSeriesNew(HRSetup."Home Loan No.", xRec."No. Series", "Requested Loan Date", "No.", "No. Series");
                    end;
                "Loan Type"::"Vehicle Loan":
                    begin
                        HRSetup.TestField("Vehicle Loan No.");
                        HRMgt.InitNoSeriesNew(HRSetup."Vehicle Loan No.", xRec."No. Series", "Requested Loan Date", "No.", "No. Series");
                    end;
            end;
            EmployeeAdvanceLoan.ReadIsolation(IsolationLevel::ReadUncommitted);
            EmployeeAdvanceLoan.SetLoadFields("No.");
            while EmployeeAdvanceLoan.Get("No.") do
                "No." := NoSeriesMgt.GetNextNo("No. Series");

            ApproverMgt.InsertApprovalLoan("Employee No.", "No.", Type, "Loan Type");
        end;
        if "Approval Status" = "Approval Status"::Open then
            LoanMgt.CalculateFields(Rec);
        CheckForAlreadyExitsLoan();
    end;

    trigger OnModify()
    begin
        if "Approval Status" = "Approval Status"::Open then
            LoanMgt.CalculateFields(Rec);
    end;

    var
        LoanMgt: Codeunit "Loan Mgt.";
        HRMgt: Codeunit "HR Mgt.";
        Employee: Record Employee;
        CannotDelete: Label 'Cannot delete document.';
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Text2: Label 'Invalid format of %1 for %2.';
        ErrorSalAdv: Label 'You cannot apply before %1 days of previous salary advance approved date %2';
        ErrorFY: Label 'You cannot apply Salary Advance more than %1 times in a Fiscal Year %2.';
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalEntry: Record "Approval HRMS";

    local procedure CheckAreaOfPlotFormat(FieldValue: Text; FieldCaptionText: Text; AreaFormat: Enum "Area Format")
    var
        ValueLength: Integer;
        FormatLength: Integer;
        FormatText: Text;
        FormatText1: Text;
        FormatText2: Text;
        i: Integer;
    begin
        if AreaFormat = AreaFormat::" " then
            Error('Area Format must be set for %1', FieldCaptionText);

        FormatText := CopyStr(FieldValue, StrLen(FieldValue), 1);
        if FormatText = '-' then
            Error(Text2, FieldValue, FieldCaptionText);

        if StrPos(FieldValue, '-') = 1 then
            Error(Text2, FieldValue, FieldCaptionText);

        if StrPos(FieldValue, '-') = (StrLen(FieldValue) - 1) then
            Error(Text2, FieldValue, FieldCaptionText);

        FormatLength := StrLen(DelChr(Format(AreaFormat), '=', DelChr(Format(AreaFormat), '=', '-')));
        ValueLength := StrLen(DelChr(FieldValue, '=', DelChr(FieldValue, '=', '-')));
        if FormatLength <> ValueLength then
            Error(Text2, FieldValue, Format(AreaFormat));

        for i := 1 to ValueLength do begin
            FormatText1 := CopyStr(FieldValue, StrPos(FieldValue, '-'), i);
            FormatText2 := CopyStr(FieldValue, StrPos(FieldValue, '-') + i + 1, i + 1);
            if (FormatText1 = '--') or (FormatText2 = '--') then
                Error(Text2, FieldValue, FieldCaptionText);
        end;
    end;

    local procedure CheckForAlreadyExitsLoan()
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
    begin
        EmpSalaryAdv.SetLoadFields("No.", "Loan Type", "Approval Status", "Employee No.", Settled);
        EmpSalaryAdv.SetRange("Employee No.", "Employee No.");
        EmpSalaryAdv.SetRange("Loan Type", "Loan Type");
        if "Loan Type" in ["Loan Type"::"Personal Loan"] then
            EmpSalaryAdv.SetFilter("Approval Status", '<>%1&<>%2', EmpSalaryAdv."Approval Status"::Rejected, EmpSalaryAdv."Approval Status"::Approved);
        if "Loan Type" in ["Loan Type"::"Salary Advance", "Loan Type"::"Vehicle Loan", "Loan Type"::"Home Loan"] then
            EmpSalaryAdv.SetFilter("Approval Status", '<>%1', EmpSalaryAdv."Approval Status"::Rejected);
        EmpSalaryAdv.SetRange(Settled, false);
        if EmpSalaryAdv.FindFirst then
            Error('%1 already exist for employee %2.Settle this Loan First.', EmpSalaryAdv."Loan Type", EmpSalaryAdv."No.");
    end;

    procedure DisburseLoan()
    begin
        if not Confirm('Do you want to disburse the loan?', false) then
            exit;

        if "Loan Type" <> "Loan Type"::"Salary Advance" then begin
            LoanMgt.PopUpForDisbursement(Rec);
        end;
        Message('The Loan has been disbursed.');
    end;

    local procedure SalaryAdvanceControl()
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
    begin
        HRSetup.Get;
        EmpSalaryAdv.SetLoadFields("No.", "Loan Type", "Approval Status", "Employee No.", Settled);
        EmpSalaryAdv.SetRange("Employee No.", "Employee No.");
        EmpSalaryAdv.SetRange("Loan Type", EmpSalaryAdv."Loan Type"::"Salary Advance");
        EmpSalaryAdv.SetRange("Approval Status", EmpSalaryAdv."Approval Status"::Approved);
        if EmpSalaryAdv.FindLast then begin
            if "Requested Loan Date" < EmpSalaryAdv."Approved Date" + HRSetup."Salary Advance Apply Days" then
                Error(ErrorSalAdv, HRSetup."Salary Advance Apply Days", EmpSalaryAdv."Approved Date");
        end;
    end;

    local procedure SalaryAdvanceFiscalYearControl()
    var
        EmpSalaryAdvance: Record "Employee Loan/Advance";
    begin
        HRSetup.Get;
        EmpSalaryAdvance.SetLoadFields("No.", "Loan Type", "Approval Status", "Employee No.", Settled, "Fiscal Year");
        EmpSalaryAdvance.SetRange("Employee No.", "Employee No.");
        EmpSalaryAdvance.SetRange("Loan Type", EmpSalaryAdvance."Loan Type"::"Salary Advance");
        EmpSalaryAdvance.SetRange("Approval Status", EmpSalaryAdvance."Approval Status"::Approved);
        EmpSalaryAdvance.SetRange("Fiscal Year", "Fiscal Year");
        if EmpSalaryAdvance.FindSet then begin
            if EmpSalaryAdvance.Count >= HRSetup."No of Salary Advance" then
                Error(ErrorFY, HRSetup."No of Salary Advance", EmpSalaryAdvance."Fiscal Year");
        end;
    end;
}
