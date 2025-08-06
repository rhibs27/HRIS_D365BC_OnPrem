table 50106 "Employee Loan/Advance"
{
    DataCaptionFields = "No.", "Employee Code", "Employee Name";
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
        field(9; "Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employee.Get("Employee Code");
                if Employee."Employment Type" <> employee."Employment Type"::"Permanent" then
                    Error('Employee is not Permanent. Cannot apply for loan/advance.');
                if Employee.Status <> employee.Status::Active then
                    Error('Employee is not active. Cannot apply for loan/advance.');
                Clear(Branch);
                Clear("Branch Name");
                Clear("Unit Name");
                if "Loan Type" = "Loan Type"::"Salary Advance" then
                    LoanMgt.NewSalaryAdvanceCheck("Employee Code");
                Validate("Salary Level", Employee."Salary Level");
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(5; "Job Type"; enum "Employee Type")
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
        field(8; "Date of Joining"; Date)
        {
            Editable = false;
        }
        field(2; Type; Enum "Employee Activity Type")
        {
        }
        field(10; "Gross Salary"; Decimal) { }
        field(11; FY; Code[20]) { }
        field(12; Department; Code[20])
        {
            Editable = false;
            TableRelation = Employee."Department Code";
        }
        field(13; "Date of Birth"; Date)
        {
            Editable = false;
        }
        field(14; Age; Integer) { }
        field(15; Branch; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
        field(31; "Remaining Service Period"; Decimal)
        {
            Editable = false;
        }
        field(17; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Total Loan Amount"; Decimal)
        {
            Editable = false;
        }
        field(19; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(21; "Unit Name"; Text[100])
        {
            Editable = false;
        }
        field(22; "Vehicle Purchase Type"; Enum "Vehicle Purchase Type")
        {
            trigger OnValidate()
            begin
                if "Vehicle Loan Type" = "Vehicle Loan Type"::"Two Wheeler" then
                    TestField("Vehicle Purchase Type", "Vehicle Purchase Type"::New);
            end;
        }
        field(23; "Employee Citizenship No."; Code[30])
        {
            Editable = false;
        }
        field(24; "Citizenship Issue Date"; Date)
        {
            Editable = false;
        }
        field(25; Remarks; Text[250])
        {
            trigger OnValidate()
            begin
                Clear("Rejection Remark");
            end;
        }
        field(26; "Eligible Loan/Advance"; Decimal) { }
        field(27; "Applied Loan/Advance"; Decimal) { }
        field(28; "Payback Months"; Enum "Payback Months")
        {
        }
        field(29; "DBR Ratio"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(30; "Requested Loan Date"; Date)
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                Validate(FY, HRMgt.ReturnFiscalYear("Requested Loan Date"));
            end;
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
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
        field(58; "Address of Supplier"; Text[50])
        {
            Description = 'Vehicle';
        }
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
                        Error('Premium Setup is not available for this insurance company. Please contact HR department.');
                end;
            end;
        }
        field(48; "Property in the name of"; Text[50]) { }
        field(49; "Name of Spouse"; Text[50]) { }
        field(50; "Name of Owner"; Text[50]) { }
        field(51; "Address of Owner"; Text[50]) { }
        field(52; "Area of Plot"; Text[50])
        {
            trigger OnValidate()
            begin
                CheckAreaofPlotFormat;
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
        // field(54; Recommender; Code[150])
        // {
        //     TableRelation = Employee;

        //     trigger OnValidate()
        //     begin
        //         if Employee.Get(Recommender) then
        //             "Recommender Name" := Employee."Full Name"
        //         else
        //             Clear("Recommender Name");
        //         // requirement not fixed
        //         if Recommender <> '' then begin
        //             if Recommender = Approver then
        //                 Error('Recommender and Approver cannot be same person.');
        //             Employee.Get(Recommender);
        //             if SalaryLevel.Get("Salary Level") then;
        //             if SalaryLevel1.Get(Employee."Salary Level") then;
        //             if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                 Error('Salary level of recommender (%1) must be greater than salary level of employee (%2)', Employee."Full Name", "Employee Name");
        //         end;
        //     end;
        // }
        // field(55; Approver; Code[150])
        // {
        //     Editable = false;
        //     TableRelation = Employee;

        //     trigger OnValidate()
        //     begin
        //         if GuiAllowed then begin
        //             Employee.Get(HRMgt.GetEmployeeNo);
        //             if not Employee.Screener then
        //                 Error('You are not eligible to change approver code.');
        //         end;
        //         if Employee.Get(Approver) then
        //             "Approver Name" := Employee."Full Name"
        //         else
        //             Clear("Approver Name");
        //         /* requirement not fixed
        //         IF Approver <> '' THEN BEGIN
        //           IF Recommender = Approver THEN
        //            ERROR('Recommender and Approver cannot be same person.');
        //             Employee.GET(Approver);
        //           IF SalaryLevel.GET("Salary Level") THEN;
        //           IF SalaryLevel1.GET(Employee."Salary Level") THEN;
        //           IF SalaryLevel.Rank >= SalaryLevel1.Rank THEN
        //             ERROR('Salary level of approver (%1) must be greater than salary level of employee (%2)',Employee."Full Name","Employee Name");
        //         END;
        //         */
        //     end;
        // }
        // field(56; "Recommender Name"; Text[250]) { }
        // field(57; "Approver Name"; Text[250])
        // {
        //     Editable = false;
        // }
        field(37; "Approved Date"; Date) { }
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
            Editable = false;
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
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("Employee Code"),
                                                                              "Salary Advance No." = field("No."),
                                                                              "Payroll Attribute Code" = const('SALARY ADVANCE'),
                                                                              Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(98; "Equity Financing Declaration"; Boolean) { }
        field(99; "Returned Loan"; Boolean) { }
        field(100; "Status"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Reinstate Date"; Date) { }
        field(102; "Age Home Loan"; Decimal) { }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete);
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        ApprovalEntry.DeleteAll();

    end;

    trigger OnInsert()
    var
        EmployeeAdvanceLoan: Record "Employee Loan/Advance";
    begin
        Validate("Requested Loan Date", Today);
        Validate(Type, Rec.Type::Loan);
        HRSetup.Get;
        if "No." = '' then
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

        ApproverMgt.InsertApproval("Employee Code", "No.", Type, "Loan Type");
        Validate("Approval Status", "Approval Status"::Open);
        LoanMgt.CalculateFields(Rec);
        CheckForAlreadyExitsLoan();
    end;

    trigger OnModify()
    begin
        // if (xRec."Approval Status" = "Approval Status") then
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
        SalaryLevel: Record "Salary Level";
        SalaryLevel1: Record "Salary Level";
        ErrorSalAdv: Label 'You cannot apply before 4 month of previous salary advance approved date %1';
        ErrorFY: Label 'You cannot apply Salary Advance more than 2 times in a Fiscal Year %1.';
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalEntry: Record "Approval HRMS";

    local procedure CheckAreaofPlotFormat()
    var
        ValueLength: Integer;
        FormatLength: Integer;
        FormatText: Text;
        i: Integer;
        FormatText1: Text;
        FormatText2: Text;
    begin
        Clear(FormatText);
        Clear(FormatLength);
        Clear(ValueLength);
        TestField("Area Format");
        if "Area Format" <> "Area Format"::" " then begin
            FormatText := CopyStr("Area of Plot", StrLen("Area of Plot"), StrLen("Area of Plot"));
            if FormatText = '-' then
                Error(Text2, "Area of Plot", FieldCaption("Area of Plot"));
            if StrPos("Area of Plot", '-') = 1 then
                Error(Text2, "Area of Plot", FieldCaption("Area of Plot"));
            if StrPos("Area of Plot", '-') = (StrLen("Area of Plot") - 1) then
                Error(Text2, "Area of Plot", FieldCaption("Area of Plot"));
            FormatLength := StrLen(DelChr(Format("Area Format"), '=', DelChr(Format("Area Format"), '=', '-')));
            ValueLength := StrLen(DelChr("Area of Plot", '=', DelChr("Area of Plot", '=', '-')));
            if FormatLength <> ValueLength then
                Error(Text2, "Area of Plot", "Area Format");
            for i := 1 to ValueLength do begin
                FormatText1 := CopyStr("Area of Plot", StrPos("Area of Plot", '-'), i);
                FormatText2 := CopyStr("Area of Plot", StrPos("Area of Plot", '-') + i + 1, i + 1);
                if (FormatText1 = '--') or (FormatText2 = '--') then
                    Error(Text2, "Area of Plot", FieldCaption("Area of Plot"));
            end;
        end;
    end;

    local procedure CheckForAlreadyExitsLoan()
    var
        EmpSalaryAdv: Record "Employee Loan/Advance";
    begin
        EmpSalaryAdv.Reset;
        EmpSalaryAdv.SetRange("Employee Code", "Employee Code");
        EmpSalaryAdv.SetRange("Loan Type", "Loan Type");
        if "Loan Type" in ["Loan Type"::"Personal Loan"] then
            EmpSalaryAdv.SetFilter("Approval Status", '<>%1&<>%2', EmpSalaryAdv."Approval Status"::Rejected, EmpSalaryAdv."Approval Status"::Approved);
        if "Loan Type" in ["Loan Type"::"Salary Advance", "Loan Type"::"Vehicle Loan", "Loan Type"::"Home Loan"] then
            EmpSalaryAdv.SetFilter("Approval Status", '<>%1', EmpSalaryAdv."Approval Status"::Rejected);
        EmpSalaryAdv.SetRange(Settled, false);
        if EmpSalaryAdv.FindFirst then
            Error('%1 already exist for employee %2.Settle this Loan First.', EmpSalaryAdv."Loan Type", EmpSalaryAdv."No.");
    end;

    // procedure ReOpenDocument(EmpLoanAdvance: Record "Employee Loan/Advance")
    // var
    //     Employee: Record Employee;
    // begin
    //     //TESTFIELD("Approval Status","Approval Status"::Recommended);
    //     Employee.Get(HRMgt.GetEmployeeNo);
    //     if not Employee.Screener then
    //         Error('Only screener can return these documents.');
    //     if not Confirm('Do you want to return the document?', false) then
    //         exit;
    //     EmpLoanAdvance."Approval Status" := EmpLoanAdvance."Approval Status"::Open;
    //     EmpLoanAdvance."Returned Loan" := true; //Min -- For Identify Return Document.
    //     EmpLoanAdvance.Modify;
    //     Message('The document has been returned.');
    // end;

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
        EmpSalaryAdv.Reset;
        EmpSalaryAdv.SetRange("Employee Code", "Employee Code");
        EmpSalaryAdv.SetRange("Loan Type", EmpSalaryAdv."Loan Type"::"Salary Advance");
        EmpSalaryAdv.SetRange("Approval Status", EmpSalaryAdv."Approval Status"::Approved);
        if EmpSalaryAdv.FindLast then begin
            if "Requested Loan Date" < EmpSalaryAdv."Approved Date" + HRSetup."Salary Advance Apply Days" then
                Error(ErrorSalAdv, EmpSalaryAdv."Approved Date");
        end;
    end;

    local procedure SalaryAdvanceFiscalYearControl()
    var
        EmpSalaryAdvance: Record "Employee Loan/Advance";
    begin
        EmpSalaryAdvance.Reset;
        EmpSalaryAdvance.SetRange("Employee Code", "Employee Code");
        EmpSalaryAdvance.SetRange("Loan Type", EmpSalaryAdvance."Loan Type"::"Salary Advance");
        EmpSalaryAdvance.SetRange("Approval Status", EmpSalaryAdvance."Approval Status"::Approved);
        EmpSalaryAdvance.SetRange(FY, FY);
        if EmpSalaryAdvance.FindSet then begin
            if EmpSalaryAdvance.Count >= 2 then
                Error(ErrorFY, EmpSalaryAdvance.FY);
        end;
    end;
}
