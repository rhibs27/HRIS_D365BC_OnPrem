tableextension 50013 "Employee Ext" extends Employee
{
    fields
    {
        modify(Address)
        {
            Caption = 'Permanent Address';
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate()
            begin

                if "Bank Account No." <> '' then begin
                    EmployeeRec.Reset;
                    EmployeeRec.SetRange(Status, EmployeeRec.Status::Active);
                    EmployeeRec.SetRange("Bank Account No.", Rec."Bank Account No.");
                    if EmployeeRec.FindFirst then
                        Error(Text006, Rec."Bank Account No.", EmployeeRec."No.");
                end;
            end;
        }
        modify("Birth Date")
        {
            trigger OnAfterValidate()
            begin
                Age := (Today - "Birth Date") div 365;
                "Date of Birth (B.S.)" := EngNepDate.getNepaliDate("Birth Date");
                HrSetup.Get();
                if HrSetup."Calculate Age using Nepali C." then
                    "Age Text" := HRMgt.GetAgeBS(EngNepDate.getNepaliDate("Birth Date"), EngNepDate.getNepaliDate(Today))
                else
                    "Age Text" := HRMgt.GetAge("Birth Date", Today);
            end;
        }
        modify("Employment Date")
        {
            trigger OnAfterValidate()
            begin
                TestField("Employment Type");
                TestField(Gender);
                if "Contract Expiry Month" <> "Contract Expiry Month"::" " then
                    Validate("Contract Expiry Month");
                if "Employment Date" <> 0D then
                    HrMgt.getServicePeriodText(Rec);
                "Employment Date (B.S.)" := EngNepDate.getNepaliDate("Employment Date");
            end;
        }
        modify("First Name")
        {
            trigger OnAfterValidate()
            var
                Regex: Codeunit Regex;
                Pattern: Label '^[A-Za-z]+$';

            begin
                // if "Middle Name" <> '' then
                //     if not Regex.IsMatch("First Name", Pattern) then
                //         Error('Only Alphabet Character Allowed');
                "Full Name" := FullName;
            end;
        }

        modify(Gender)
        {
            trigger OnAfterValidate()
            begin
                Validate("Tax Code", HRMgt.ValidateTaxCode(Gender, "Marital Status"));
            end;
        }
        modify("Last Name")
        {
            trigger OnAfterValidate()
            var
                Regex: Codeunit Regex;
                Pattern: Label '^[A-Za-z .]+$';  //middle and last name can contain space and (.)
            begin
                // if "Middle Name" <> '' then
                //     if not Regex.IsMatch("Last Name", Pattern) then
                //         Error('Only Alphabet Character Allowed');
                "Full Name" := FullName;
            end;
        }
        modify("Middle Name")
        {
            trigger OnAfterValidate()
            var
                Regex: Codeunit Regex;
                Pattern: Label '^[A-Za-z .]+$';  //middle and last name can contain space and (.)
            begin
                // if "Middle Name" <> '' then
                //     if not Regex.IsMatch("Middle Name", Pattern) then
                //         Error('Only Alphabet Character Allowed');
                "Full Name" := FullName;
            end;
        }

        modify("Mobile Phone No.")
        {
            trigger OnAfterValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin

                if not TypeHelper.IsPhoneNumber(Rec."Mobile Phone No.") then
                    Error('Phone No Validation Error');
                if "Mobile Phone No." <> '' then begin
                    EmployeeRec.Reset;
                    EmployeeRec.SetFilter("No.", '<>%1', Rec."No.");
                    EmployeeRec.SetRange("Mobile Phone No.", Rec."Mobile Phone No.");
                    EmployeeRec.SetFilter("Employment Type", '%1|%2', EmployeeRec."Employment Type"::Permanent, EmployeeRec."Employment Type"::Probation);
                    if EmployeeRec.FindFirst then
                        Error(Text010, Rec."Mobile Phone No.", EmployeeRec."No.");
                end;
                if StrLen("Mobile Phone No.") > 15 then
                    Error(Text009);
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if "No." = '' then
                    Error('No. must have value.');
                "New Employee" := true;
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin

                if not TypeHelper.IsPhoneNumber(Rec."Phone No.") then
                    Error('Phone No Validation Error');
                if StrLen("Mobile Phone No.") > 15 then
                    Error(Text009);
            end;
        }
        modify("Termination Date")
        {
            trigger OnAfterValidate()
            begin
                "Termination Date (B.S.)" := EngNepDate.getNepaliDate("Termination Date");
            end;
        }
        modify(Title)
        {
            TableRelation = "Functional Title";
        }
        field(50001; "Branch Code"; Code[20])
        {
            TableRelation = if ("Deputation On" = Const(Branch)) "Organization Structure line"."Reporting Code" where(Type = const("Deputation Type"::Province), Code = field("Province Code"), "Reporting Type" = filter("Deputation Type"::Branch))
            else if ("Deputation On" = Const("Head Office")) "Organization Structure line"."Reporting Code" where(Type = const("Deputation Type"::Province), Code = field("Province Code"), "Reporting Type" = filter("Deputation Type"::"Head Office"));
            trigger OnValidate()
            var
                ishandled: Boolean;
            begin
                TestField("Province Code");
                if "Branch Code" <> xRec."Branch Code" then begin
                    Clear("Branch Name");
                    Clear("Extension Counter Code");
                    Clear("Extension Counter Name");
                    Clear("Posting Region");
                    Clear("Inside/Outside Valley");
                    Clear("Sol Id");
                end;
                if "Deputation on" = "Deputation on"::Branch then
                    ValidateDeputationOn()
                else begin
                    OnAfterValidationOfDeputationOn(Rec, ishandled);
                    if not ishandled then
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Branch Code") then
                            Validate("Branch Name", OrganizationStructureList.Name)
                        else
                            Clear("Branch Name");
                end;
            end;
        }
        field(50002; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Department), Blocked = filter(false));
            trigger OnValidate()
            begin

                if "Deputation on" = "Deputation on"::Department then
                    ValidateDeputationOn()
                else begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Department Code") then
                        Validate("Department Name", OrganizationStructureList.Name)
                    else
                        Clear("Department Name");
                end;
            end;
        }
        field(50003; "Deputation On Code"; Code[20])
        {
            Editable = false;
        }
        field(50004; "Advance Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("G/L Entry".Amount where("Posting Date" = field("Date Filter"), "G/L Account No." = field("G/L Account Filter"), "Shortcut Dimension 3 Code" = field("No.")));
            Caption = 'Advance Amount';
            Editable = false;
        }
        field(50005; "G/L Account Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "G/L Account"."No.";
        }
        field(50006; "Employee Work Shift"; Code[20])
        {
            TableRelation = "Employee Work Shift";
            DataClassification = CustomerContent;
        }
        field(50008; "Total Earning"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."), "Attribute Type" = filter("Basic Earning" | "Other Earnings"),
                                                                                                                  "Posting Date" = field("Date Filter"),
                                                                                                                  Reversed = const(false),
                                                                                                                  "Non-Taxable" = const(false)));
            Editable = false;
        }
        field(50009; "Total Retirement Contribution"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Payroll SubType"::CIT | "Payroll SubType"::"Employee Contribution" | "Payroll SubType"::"Employer Contribution" | "Payroll SubType"::RF | "Payroll SubType"::"Lump Sum Contribution" | "Payroll SubType"::Gratuity),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Document Type" = field("Document Type Filter")));
            Editable = false;
        }
        field(50010; "Total Donation Contribution"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."), "Attribute Type" = filter("Non-Payment"), "Attribute Sub Type" = filter(Donation), "Posting Date" = field("Date Filter"), Reversed = const(false)));
            Editable = false;
        }
        field(50011; "Premium of Life Insurance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Employee Insurance Information"."Annual Premium Amount" where("Employee No." = field("No."), "Insurance Type" = const("Employee Insurance Type"::"Life Insurance"),
                                                                                                                    "Approval Status" = const("Approval Status"::Approved), Expired = const(false)));
            Editable = false;
        }
        field(50012; "Tax Code"; Code[20])
        {
            TableRelation = "Tax Setup Header";
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(50013; "Total Medical Re-Imbursement"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                  "Attribute Type" = filter("Other Earnings"),
                                                                                                                  "Attribute Sub Type" = filter(Medical),
                                                                                                                  "Posting Date" = field("Date Filter"),
                                                                                                                  Reversed = const(false)));
            Editable = false;
        }
        field(50014; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                SalaryLevel: Record "Salary Level";
            begin
                if SalaryLevel.Get("Salary Level") then begin
                    "Salary Level Description" := SalaryLevel.Description;
                    "Staff Level" := SalaryLevel."Staff Level"
                end
                else begin
                    Clear("Salary Level Description");
                    Clear("Staff level");
                end;
                Validate("Job Title", "Salary Level");
            end;
        }
        field(50015; "Salary Grade"; Code[20])
        {
            TableRelation = "Salary Grade";
            DataClassification = CustomerContent;
        }
        field(50016; "Social Security Tax"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Attribute Sub Type" = const("Social Security Tax"),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false)));
            Editable = false;
        }
        field(50017; "Remuneration & Benefits Tax"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Attribute Sub Type" = const("Tax on Remuneration & Benefits"),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false)));
            Editable = false;
        }
        field(50018; "PF Loan Advance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                  "Attribute Sub Type" = filter(Advance),
                                                                                                                  "Posting Date" = field("Date Filter"),
                                                                                                                  Reversed = const(false),
                                                                                                                  "Payroll Attribute Code" = const('PF LOAN ADVANCE')));
            Editable = false;
        }
        field(50019; "Total Loan"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                  "Attribute Sub Type" = filter(Loan),
                                                                                                                  "Posting Date" = field("Date Filter"),
                                                                                                                  Reversed = const(false)));
            Editable = false;
        }
        field(50020; "Full Name (Nepali)"; Text[50])
        {
            Description = 'In Nepali';
        }
        field(50021; "Father's Name (Nepali)"; Text[50])
        {
            Description = 'In Nepali';
        }
        field(50022; "Mother's Name (Nepali)"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50023; "GrandFather's Name (Nepali)"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50024; "Promotion Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Promotion Date (B.S.)" := EngNepDate.getNepaliDate("Promotion Date");
            end;
        }
        field(50025; "CIT No."; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(50026; "PF No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50027; "PAN No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                if not TypeHelper.IsNumeric(Rec."PAN No.") then
                    Error(NumericError, FieldCaption("PAN No."));
                if StrLen("PAN No.") <> 9 then
                    Error(Text007);
            end;
        }
        field(50028; "Third Party Payroll Emp Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'not used';
        }
        field(50029; "Bank No."; Code[30])
        {
            TableRelation = "Bank Account";
            DataClassification = CustomerContent;
        }
        field(50030; "Bank Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50031; "Salary Advance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Employee Loan/Advance"."Remaining Amount" where("Employee No." = field("No."),
                                                                                                                     "Loan Type" = const("Salary Advance"),
                                                                                                                     Settled = const(false),
                                                                                                                     "Approval Status" = const(Approved)));
            Editable = false;
        }
        field(50032; "Total Renumeration"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                  "Attribute Sub Type" = filter(<> "Social Security Tax" & <> "Tax on Remuneration & Benefits"),
                                                                                                                  "Posting Date" = field("Date Filter"),
                                                                                                                  Reversed = const(false)));
            Editable = false;
        }
        field(50033; "Vehicle Advance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Payroll Attribute Code" = filter('VEHICLE ADVANCE')));
            Editable = false;
        }
        field(50034; "Maintenance Advance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Attribute Sub Type" = filter(Advance),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Payroll Attribute Code" = const('MAINTAINENCE ADV')));
            Editable = false;
        }
        field(50035; "PF Contribution"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Payroll SubType"::"Employee Contribution")));
            Editable = false;
        }
        field(50036; "CIT Deposit"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Payroll SubType"::CIT)));
            Editable = false;
        }
        field(50037; "PF Contribution (Office)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                 "Attribute Sub Type" = filter("Payroll SubType"::"Employer Contribution")));
            Editable = false;
        }
        field(50039; "Advance for Expenses"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("G/L Entry".Amount where("Shortcut Dimension 4 Code" = field("No."),
                                                                                             "Posting Date" = field("Date Filter"),
                                                                                             "G/L Account No." = const('121082')));
            Editable = false;
        }
        field(50041; "Document Type Filter"; Enum "Employee Document Type")
        {
            FieldClass = FlowFilter;
        }
        field(50042; Age; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50043; "Marital Status"; Enum "Marital Status")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Validate("Tax Code", HRMgt.ValidateTaxCode(Gender, "Marital Status"));
            end;
        }
        field(50044; "Citizen Number"; Code[30])
        {
            caption = 'Citizenship Number';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Clear("Citizenship Issue Place Code");
                Clear("Citizenship Issue Place");
            end;
        }
        field(50045; "Passport Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50046; "Blood Group"; Enum "Blood Group")
        {
            DataClassification = CustomerContent;
        }
        field(50047; "Employment Type"; enum "Employee Type")
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EmployeeWorkShift: Record "Employee Work Shift";
                IsHandled: Boolean;
            begin
                OnValidateEmploymentType(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;
                EmployeeWorkShift.SetRange("Default Employee Type", Rec."Employment Type");
                if EmployeeWorkShift.FindFirst() then
                    Rec."Employee Work Shift" := EmployeeWorkShift.Code
                else begin
                    EmployeeWorkShift.Reset();
                    EmployeeWorkShift.SetRange("Default Employee Type", EmployeeWorkShift."Default Employee Type"::" ");
                    if EmployeeWorkShift.FindFirst() then
                        Rec."Employee Work Shift" := EmployeeWorkShift.Code;
                end;
            end;
        }
        field(50048; "Province Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50049; "Non-Payment"; Decimal)
        {
            Caption = 'Monthly Salary (Serv. P. Contract)';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                            "Attribute Type" = const("Non-Payment"), "Posting Date" = field("Date Filter"), Reversed = const(false), "Non-Taxable" = const(false)));
            Editable = false;
        }
        field(50051; "Distance betwn Res and Office"; Decimal)
        {
            Caption = 'Distance between Residence and Office';
            DataClassification = CustomerContent;
        }
        field(50052; "Full Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50053; "Old Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50054; "Date of Birth (B.S.)"; Text[30])
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                if "Date of Birth (B.S.)" <> '' then begin
                    "Birth Date" := EngNepDate.getEngDate("Date of Birth (B.S.)");
                    "Age Text" := HRMgt.GetAge("Birth Date", Today);
                end
                else begin
                    "Age Text" := '';
                    Clear("Birth Date");
                end;
            end;
        }
        field(50055; "Citizenship Issue Place"; Text[30])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50056; "Citizenship Issue Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Citizenship Issue Date" > Today then
                    Error('Citizenship Issue Date Cannot be in Future Date');
                "Citizenship Date (B.S.)" := EngNepDate.getNepaliDate("Citizenship Issue Date");
            end;
        }
        field(50057; Religion; Enum Religion)
        {
            DataClassification = CustomerContent;
        }
        field(50058; "Unit Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Department), Code = field("Department Code"), "Reporting Type" = filter("Deputation Type"::unit));
            trigger OnValidate()
            begin
                TestField("Department Code");
                if "Deputation on" = "Deputation on"::Unit then
                    ValidateDeputationOn
                else if "Deputation on" = "Deputation on"::Department then
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, "Unit Code") then
                        Validate("Unit Name", OrganizationStructureList.Name);
                if "Unit Code" = '' then
                    Clear("Unit Code");
            end;
        }
        field(50059; "Branch Category"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50060; "Experience Years"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50061; "Sol Id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50062; "Reporting Person"; Text[40])
        {
            DataClassification = CustomerContent;
        }
        field(50063; Disabled; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50064; "Vehicle Type"; Enum "Vehicle Type")
        {
            DataClassification = CustomerContent;
        }
        field(50065; "Posting Region"; Enum Region)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50066; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                //OnValidateFunctionTitle;
                "Functional Title Desc" := '';
                if FunctionalTitle.Get("Functional Title") then begin
                    "Functional Title Desc" := FunctionalTitle.Description;
                    if FunctionalTitle."Is Specific Functional" then begin //Abhiral 01.29.2023
                        "KPI Functional Title" := "Functional Title";
                        "KPI Deputation" := "Deputation on";
                    end else begin
                        "KPI Functional Title" := '';
                        "KPI Deputation" := "KPI Deputation"::" ";
                    end;
                end;
                //                                                 {"Functional Title Desc" := '';
                // IF FunctionalTitle.GET("Functional Title") then
                //     "Functional Title Desc" := FunctionalTitle.Description;}
            end;
        }
        field(50067; "Out-Station eligible"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50068; "Inside/Outside Valley"; Enum "Outside/Inside Valley")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50069; "Temporary Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50070; "Job Title Code"; Code[20])
        {
            TableRelation = "Job Title";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalcFields("Job Title");
            end;
        }
        field(50071; "KPI Deputation Value"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department));
            DataClassification = CustomerContent;
            Description = 'KPI 1.00';
            trigger OnValidate()
            begin
                //HRMgt.GetEmployeeName("KPI Deputation Value", "Recommender Name");
            end;
        }
        field(50072; "Sub Unit Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::unit), Code = field("Unit Code"), "Reporting Type" = filter("Deputation Type"::"Sub-Unit"));
            trigger OnValidate()
            begin
                if OrganizationStructureList.Get(OrganizationStructureList.Type::"Sub-Unit", "Sub Unit Code") then
                    Validate("Sub Unit Name", OrganizationStructureList.Name);
            end;
        }
        field(50073; "Sub Unit Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50074; "Staff level"; Enum "Staff Type")
        { DataClassification = CustomerContent; }
        field(50075; "Service Period"; Integer)
        { DataClassification = CustomerContent; }
        field(50076; "Converted To Emp. Date"; Date)
        { DataClassification = CustomerContent; }
        field(50077; "NAV Login ID"; Code[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if ("NAV Login ID" <> xRec."NAV Login ID") and ("NAV Login ID" <> '') then begin
                    Employee.Reset;
                    Employee.SetRange("NAV Login ID", "NAV Login ID");
                    Employee.SetFilter("No.", '<>%1', "No.");
                    if Employee.FindFirst then
                        Error('NAV Login ID already exist in Employee %1 of code %2', Employee."Full Name", Employee."No.");
                end;
            end;
        }
        field(50079; Salutation; Enum Salutation)
        {
            DataClassification = CustomerContent;
            Caption = 'Salutation';
        }
        field(50080; "Permanent District"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'Permanent District';
            trigger OnValidate()
            begin
                HrSetup.Get();
                IF HrSetup."Validate Permanent Address" and (Rec."Permanent District" <> xRec."Permanent District") and ("Permanent District" <> '') then
                    HRMgt.CheckDistrictName("Permanent District");
                "Address" := ReturnAddress("Permanent VDC", "Permanent Ward No", "Permanent Locality", "Permanent District", "Permanent Province");
            end;

            trigger OnLookup()
            begin
                VALIDATE("Permanent District", HRMgt.LookupDistrict("Permanent Province", "Permanent District"));
            end;
        }
        field(50081; "Temporary District"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'Temporary District';
            trigger OnValidate()
            begin
                HrSetup.Get();
                if HrSetup."Validate Temporary Address" and (Rec."Temporary District" <> xRec."Temporary District") and ("Temporary District" <> '') then
                    HRMgt.CheckDistrictName("Temporary District");
                "Temporary Address" := ReturnAddress("Temporary VDC", "Temporary Ward No", "Temporary Locality", "Temporary District", "Temporary Province");
            end;

            trigger OnLookup()
            begin
                Validate("Temporary District", HRMgt.LookupDistrict("Temporary Province", "Temporary District"));
            end;
        }
        field(50082; "Permanent Province"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'Permanent Province address';
            trigger OnValidate()
            begin
                if (Rec."Permanent Province" <> xRec."Permanent Province") and ("Permanent Province" <> '') then begin
                    HrSetup.Get();
                    IF HrSetup."Validate Permanent Address" then
                        HRMgt.CheckProvience("Permanent Province");
                    Clear("KPI Deputation");
                    Clear("Permanent District");
                end;
                if "Permanent Province" = '' then begin
                    Clear("KPI Deputation");
                    Clear("Permanent District");
                end;
                Address := ReturnAddress("Permanent VDC", "Permanent Ward No", "Permanent Locality", "Permanent District", "Permanent Province");
            end;

            trigger OnLookup()
            begin
                Validate("Permanent Province", HRMgt.LookupProvience("Permanent Province"));
            end;
        }
        field(50083; "Temporary Province"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'Temporary Provience address';
            trigger OnValidate()
            begin
                if (Rec."Temporary Province" <> xRec."Temporary Province") and ("Temporary Province" <> '') then begin
                    HrSetup.Get();
                    IF HrSetup."Validate Temporary Address" then
                        HRMgt.CheckProvience("Temporary Province");
                    Clear("Temporary Ward No");
                    Clear("Temporary District");
                end;
                if "Temporary Province" = '' then begin
                    Clear("Temporary Ward No");
                    Clear("Temporary District");
                end;
                "Temporary Address" := ReturnAddress("Temporary VDC", "Temporary Ward No", "Temporary Locality", "Temporary District", "Temporary Province");
            end;

            trigger OnLookup()
            begin
                Validate("Temporary Province", HRMgt.LookupProvience("Temporary Province"));
            end;
        }
        field(50084; "KPI Deputation"; Enum "Deputation Type")
        {
            DataClassification = CustomerContent;
            Description = 'KPI1.00';
            trigger OnValidate()
            begin
                //                                                 {IF (Rec."KPI Deputation Code" <> xRec."KPI Deputation Code") AND ("KPI Deputation Code" <> '') then begin
                //     HRMgt.CheckSubProvience("KPI Deputation Code");
                //     CLEAR("Permanent District");
                // end;
                // IF "KPI Deputation Code" = '' then
                //     CLEAR("Permanent District");
                // "Permanent Address" := ReturnAddress("Permanent Province", "KPI Deputation Code", "Permanent District", "Permanent VDC", "Ward No");}
            end;

            trigger OnLookup()
            begin
                //VALIDATE("Permanent Sub Province",HRMgt.LookupSubProvience("Permanent Province","Permanent Sub Province"));
            end;
        }
        field(50085; "Temporary Ward No"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'temporary';
            MinValue = 1;
            trigger OnValidate()
            var
                Municipalities: Record Municipality;
            begin
                if ("Temporary Ward No" > 0) then begin
                    if ("Temporary VDC" = '') then
                        Error('Please select Temporary VDC first');
                    HrSetup.Get();
                    IF HrSetup."Validate Temporary Address" then begin
                        Municipalities.SetRange("Municipality Name", "Temporary VDC");
                        if Municipalities.FindFirst() then begin
                            if "Temporary Ward No" > Municipalities."No of ward" then
                                Error('Temporary Ward No. should be less than %1', Municipalities."No of ward");
                        end else
                            Error('Temporary VDC Not Found in Municipality Table');
                    end;
                    "Temporary Address" := ReturnAddress("Temporary VDC", "Temporary Ward No", "Temporary Locality", "Temporary District", "Temporary Province");
                end;
            end;
        }
        field(50086; "Permanent VDC"; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                HrSetup.Get();
                if HrSetup."Validate Permanent Address" and (Rec."Permanent VDC" <> xRec."Permanent VDC") and ("Permanent VDC" <> '') then
                    HRMgt.CheckMunicipalityName("Permanent VDC");
                "Address" := ReturnAddress("Permanent VDC", "Permanent Ward No", "Permanent Locality", "Permanent District", "Permanent Province");
            end;

            trigger OnLookup()
            begin
                Validate("Permanent VDC", HRMgt.LookupMunicipalityName("Permanent District", "Permanent VDC"));
            end;
        }
        field(50087; "Temporary VDC"; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                HrSetup.Get();
                if HrSetup."Validate Temporary Address" and (Rec."Temporary VDC" <> xRec."Temporary VDC") and ("Temporary VDC" <> '') then
                    HRMgt.CheckMunicipalityName("Temporary VDC");
                "Temporary Address" := ReturnAddress("Temporary VDC", "Temporary Ward No", "Temporary Locality", "Temporary District", "Temporary Province");
            end;

            trigger OnLookup()
            begin
                Validate("Temporary VDC", HRMgt.LookupMunicipalityName("Temporary District", "Temporary VDC"));
            end;
        }
        field(50088; "Permanent House"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50089; "Temporary House"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50090; "RF Deposit"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Payroll SubType"::RF)));
            Editable = false;
        }
        field(50091; "Citizenship Issue Place Code"; Code[20])
        {
            TableRelation = District;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                District: Record District;
            begin
                if District.Get("Citizenship Issue Place Code") then
                    Validate("Citizenship Issue Place", District."District Name")
                else
                    Clear("Citizenship Issue Place");
                if "Citizenship Issue Place Code" <> xRec."Citizenship Issue Place Code" then
                    HRMgt.CheckForCitizen("Citizen Number", "Citizenship Issue Place Code");
            end;
        }
        field(50092; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Province), Blocked = filter(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Deputation on" = "Deputation on"::Province then
                    ValidateDeputationOn()
                else begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Province Code") then
                        Validate("Province Name", OrganizationStructureList.Name)
                    else
                        Clear("Province Name");
                end;
            end;
        }
        field(50093; "Permanent Ward No"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 1;
            Description = 'Citizenship ward no';
            trigger OnValidate()
            var
                Municipalities: Record Municipality;
            begin
                if "Permanent VDC" = '' then
                    Error('Please select Permanent VDC first');

                HrSetup.Get();
                IF HrSetup."Validate Permanent Address" then begin
                    Municipalities.SetRange("Municipality Name", "Permanent VDC");
                    if Municipalities.FindFirst() then begin
                        if "Permanent Ward No" > Municipalities."No of ward" then
                            Error('Ward No. should be less than %1', Municipalities."No of ward");
                    end else
                        Error('Permanent VDC Not Found in Municipality Table');
                end;
                Address := ReturnAddress("Permanent VDC", "Permanent Ward No", "Permanent Locality", "Permanent District", "Permanent Province");
            end;
        }
        field(50094; "Disable Punch in"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50095; "Restrict Leave Earn"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50096; "Confirmation Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = true;
            trigger OnValidate()
            begin
                if "Confirmation Date" <> 0D then
                    if "Confirmation Date" < "Employment Date" then
                        Error('Confirmation date cannot be less than employment date');
                "Confirmation Date (B.S.)" := EngNepDate.getNepaliDate("Confirmation Date");
            end;
        }
        field(50097; "Extension Counter Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Branch), Code = field("Branch Code"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure list";
            begin
                TestField("Branch Code");
                if "Deputation on" = "Deputation on"::"Extension Counter" then
                    ValidateDeputationOn
                else if "Deputation on" = "Deputation on"::Branch then
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Extension Counter Code") then
                        Validate("Extension Counter Name", OrganizationStructureList.Name);
                if "Extension Counter Code" = '' then
                    Clear("Extension Counter Name");
            end;
        }
        field(50102; "Lump Sum CIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Employee Ledger Entry".Amount WHERE("Employee No." = FIELD("No."),
                                                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                                                   "Reversed" = CONST(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Payroll SubType"::"Lump Sum Contribution"),
                                                                                                                   "Disabled" = CONST(false)));
            Editable = false;
        }
        field(50103; "Resignation Approver"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                HRMgt.AddRemoveDocApprover("No.", "Resignation Approver");
            end;
        }
        field(50105; "Emergency Mobile No."; Text[15])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            VAR
                TypeHelper: Codeunit "Type Helper";
            begin
                if not TypeHelper.IsPhoneNumber(Rec."Emergency Mobile No.") then
                    Error('Phone No Validation Error');
            end;
        }
        field(50106; "Insurance Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50107; "Insurance Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
            CharAllowed = 'AZaz  ';
        }
        field(50108; "Policy No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50109; "Insurance Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
            trigger OnValidate()
            begin
                if EngNepDate.FindFirst then
                    Validate("Policy No.", EngNepDate."Nepali Date")
                else
                    Validate("Policy No.", '');
            end;
        }
        field(50110; "Insurance Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Insurance Expiry Date");
                if EngNepDate.FindFirst then
                    Validate("Insurance Expiry Date (B.S.)", EngNepDate."Nepali Date")
                else
                    Validate("Insurance Expiry Date (B.S.)", '');
            end;
        }
        field(50111; "Insurance Date (B.S.)"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50112; "Insurance Expiry Date (B.S.)"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50113; "Premium Property Insurance"; Decimal)
        {
            Description = 'Insurance';
            FieldClass = FlowField;
            CalcFormula = sum("Employee Insurance Information"."Annual Premium Amount" where("Employee No." = field("No."), "Insurance Type" = const("Employee Insurance Type"::"Property Insurance"),
                                                                                                                    "Approval Status" = const("Approval Status"::Approved), Expired = const(false)));
            Editable = false;
        }
        field(50114; "Premium Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50115; "Rebate Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50116; "Insurance Disabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Disabled';
            Description = 'Insurance';
        }
        field(50117; "Gratuity Eligibility"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Gratuity Eligibility" <> 0D then begin
                    if "Employment Type" = "Employment Type"::Contract then
                        Error(Text004, FieldCaption("Employment Type"), "Employment Type"::Contract);

                    if "Employment Date" > "Gratuity Eligibility" then
                        Error(Text005, FieldCaption("Employment Date"));
                end;
            end;
        }
        field(50118; "Contract Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                if "Contract Expiry Date" <> 0D then begin
                    TestField("Employment Type", "Employment Type"::Contract);
                    if "Contract Expiry Date" < "Employment Date" then
                        Error(Text005, FieldCaption("Contract Expiry Date"));
                end;
            end;
        }
        field(50119; "Resignation Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Resignation Date (B.S.)" := EngNepDate.getNepaliDate("Resignation Date");
            end;
        }
        // field(50120; "Selection committee"; Boolean)
        // {
        //     DataClassification = CustomerContent;
        // }
        field(50121; "Citizenship No. (Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In nepali';
        }
        field(50122; "VDC/Municipality (Nepali)"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50123; "Employee No. (Nepali)"; Text[20])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50124; "Citizenship Date (B.S.)"; Text[10])
        {
            DataClassification = CustomerContent;
            Description = 'In nepali';
            trigger OnValidate()
            begin
                "Citizenship Issue Date" := EngNepDate.getEngDate("Citizenship Date (B.S.)");
            end;
        }
        field(50125; "Portal Attendance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50126; "CIF ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Loan Integration';
            CharAllowed = '09';
        }
        field(50127; "Contract Salary Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50128; "Deputation on"; Enum "Deputation Type")
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if xRec."Deputation on" <> "Deputation on" then
                    ClearValues;
            end;
        }
        field(50129; "Contract Expiry Month"; Enum "Contract Expiry Date")
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Contract Renew Date" = 0D then
                    TestField("Employment Date");
                if "Contract Expiry Month" <> "Contract Expiry Month"::" " then begin
                    if "Contract Renew Date" = 0D then
                        Validate("Contract Expiry Date", CalcDate(StrSubstNo('<%1>', "Contract Expiry Month"), "Employment Date") - 1)
                    else
                        Validate("Contract Expiry Date", CalcDate(StrSubstNo('<%1>', "Contract Expiry Month"), "Contract Renew Date") - 1)
                end else
                    Clear("Contract Expiry Date");
            end;
        }
        field(50130; "Attendance Missed Count"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50131; "Attendance Missed On"; Date)
        { DataClassification = CustomerContent; }
        field(50132; "Unit Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50133; "Department Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50134; "Branch Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50135; "Extension Counter Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50136; "Facebook Url"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50137; "Functional Title Desc"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50138; "Salary Level Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50139; "Premium of Health Insurance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Employee Insurance Information"."Annual Premium Amount" where("Employee No." = field("No."), "Insurance Type" = const("Employee Insurance Type"::"Medical Insurance"),
                                                                                                                    "Approval Status" = const("Approval Status"::Approved), Expired = const(false)));
            Editable = false;
        }
        field(50140; "Last Placement Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Last Placement Date (B.S.)" := EngNepDate.getNepaliDate("Last Placement Date");
            end;
        }
        field(50141; "Contract Renew Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50142; "Contract Expiry Remaining Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50143; Settled; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50144; "Lumpsum CIT (Not Actual)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50145; "Lumpsum RF (Not Actual)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50146; "New Employee"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50147; "Old Employee ID (Regular)"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50148; "Probation Period"; Enum "Probation Period")
        {
            DataClassification = CustomerContent;
        }
        field(50149; "Relation With Emergency Cont"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50153; "KPI Functional Title"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'KPI1.00';
            TableRelation = "Functional Title";
            trigger OnValidate()
            begin
                //OnValidateFunctionTitle;
                "Functional Title Desc" := '';
                if FunctionalTitle.Get("Functional Title") then
                    "Functional Title Desc" := FunctionalTitle.Description;
            end;
        }
        field(50154; Saved; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50155; "Login"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50156; "NID No"; Code[20])
        {
            DataClassification = CustomerContent;
            CharAllowed = '09--';
        }
        field(50157; "Driving License No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CharAllowed = '09--';
        }
        field(50158; "Approver Role"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Approval Role";
            trigger OnValidate()
            var
                ApprovalRole: Record "Approval Role";
            begin
                if ApprovalRole.Get("Approver Role") then
                    Validate("Approver Role Name", ApprovalRole.Description);
            end;
        }
        field(50159; "Approver Role Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50160; "Attendance Device ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50161; "Employee Attendance ID"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50162; "Mother Tongue"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50163; "Emergency Contact Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50164; "Emergency Contact Email"; Text[80])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Emergency Contact Email");
            end;
        }
        field(50165; "Insurance Premium"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Employee Insurance Information"."Annual Premium Amount" where("Employee No." = field("No."),
                                                                                                                    "Approval Status" = const("Approval Status"::Approved), Expired = const(false)));
            Editable = false;
        }
        field(50166; "Service Period Text"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50167; "Permanent Locality"; Text[100])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                Address := ReturnAddress("Permanent VDC", "Permanent Ward No", "Permanent Locality", "Permanent District", "Permanent Province");
            end;
        }
        field(50168; "Temporary Locality"; Text[100])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Temporary Address" := ReturnAddress("Temporary VDC", "Temporary Ward No", "Temporary Locality", "Temporary District", "Temporary Province");
            end;
        }
        field(50169; Community; Enum "Community Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50170; "Passport Validity Date"; Date) { }
        field(50171; "Promotion Date (B.S.)"; Code[20])
        {
            trigger OnValidate()
            begin
                "Promotion Date" := EngNepDate.getEngDate("Promotion Date (B.S.)");
            end;
        }
        field(50172; "Confirmation Date (B.S.)"; Code[20])
        {
            trigger OnValidate()
            begin
                "Confirmation Date" := EngNepDate.getEngDate("Confirmation Date (B.S.)");
            end;
        }
        field(50173; "Termination Date (B.S.)"; Code[20])
        {
            trigger OnValidate()
            begin
                "Termination Date" := EngNepDate.getEngDate("Termination Date (B.S.)");
            end;
        }
        field(50174; "Gratuity Number"; Code[20]) { }
        field(50175; "Resignation Date (B.S.)"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Resignation Date" := EngNepDate.getEngDate("Resignation Date (B.S.)")
            end;
        }
        field(50176; "Employment Date (B.S.)"; Code[20])
        {
            trigger OnValidate()
            begin
                if "Employment Date (B.S.)" <> '' then begin
                    "Employment Date" := EngNepDate.getEngDate("Employment Date (B.S.)");
                    if "Employment Date" <> 0D then
                        HrMgt.getServicePeriodText(Rec);
                end
                else begin
                    Clear("Employment Date");
                    "Service Period Text" := ''
                end;
            end;
        }
        field(50177; "Age Text"; Text[30]) { }
        field(50178; "Digital Signature"; Blob)
        {
            SubType = Bitmap;
            Caption = 'Digital Signature';
        }
        field(50179; "Trainee Period"; Text[20])
        {
            Caption = 'Trainee Period';
        }
        field(50180; "Trainee/Probation End date"; Date)
        {
            Caption = 'Trainee/Probation End Date';
        }
        field(50181; "Appointment Letter Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Appointment Letter Date (B.S.)" := EngNepDate.getNepaliDate("Appointment Letter Date");
            end;
        }
        field(50182; "Appointment Letter Date (B.S.)"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Appointment Letter Date" := EngNepDate.getEngDate("Appointment Letter Date (B.S.)");
            end;
        }
        field(50183; "Automatic Attendance"; Boolean) { }
        field(50184; "Manual Approver User"; Boolean)
        {
            Caption = 'Manual Approver User';
        }
        field(50185; "Relation With Nominee"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50186; "Nominee Mobile No."; Text[15])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                if not TypeHelper.IsPhoneNumber(Rec."Nominee Mobile No.") then
                    Error('Phone No Validation Error');
            end;
        }
        field(50187; "Nominee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50188; "Nominee Email"; Text[80])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Nominee Email");
            end;
        }
        field(50189; "Last Placement Date (B.S.)"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Last Placement Date" := EngNepDate.getEngDate("Last Placement Date (B.S.)");
            end;
        }
        field(50190; "Vehicle Owner Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50191; "Vehicle No."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50192; "Ownership Start/End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50200; "Do not Calculate Salary"; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50201; "Identity Mark"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50202; Seniority; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Description = 'Calculated based on salary level and employment date';
        }
    }
    keys
    {
        key(key6; "First Name", "Last Name") { }
        key(key7; "Full Name") { }
        key(key8; Seniority) { }
    }
    fieldgroups
    {
        addlast(DropDown; "No.", "Full Name") { }
    }

    trigger OnModify()
    begin
        Saved := false;
        UpdateDimensionOnModifyRecord();
    end;

    trigger OnDelete()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if Not UserSetup."Is Admin" then
            Error('Not allowed');
    end;

    trigger OnRename()
    begin
        Error('');
    end;

    var
        Text002: Label 'New Employee Name %1 is created successfully.';
        Text003: Label 'ENU=%1 is not a contract Employee.';
        EngNepDate: Record "English-Nepali Date";
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        LoanMgt: Codeunit "Loan Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        Text004: Label '%1 is %2.';
        Text005: Label '%1 must be greater.';
        LeaveMgt: Codeunit "Leave Mgt.";
        OrganizationStructureList: Record "Organization Structure List";
        FunctionalTitle: Record "Functional Title";
        EmployeeRec: Record Employee;
        Text006: Label 'Bank Account No. %1 already used in Employee  No. %2.';
        Text007: Label 'PAN No. must be 9 digits.';
        NumericError: Label '%1 must be Numeric';
        Text010: Label 'Mobile No. %1 already used in Employee No. %2.';
        Text009: Label 'Mobile No. must be 15 digits.';
        HrSetup: Record "Human Resources Setup";

    procedure GenerateNewEmployeeCard(CurrentEmployee: Record Employee);
    var
        NewEmployee: Record Employee;
        PayrollAttributeUsage: Record "Payroll Attributes Usage";
        NewPayrollAttributeUsage: Record "Payroll Attributes Usage";
        PageFilterBuilder: FilterPageBuilder;
        ReasonCode: Record "Reason Code";
    begin
        PageFilterBuilder.AddTable('Generate New Employee', Database::"Reason Code");
        PageFilterBuilder.AddField('Generate New Employee', ReasonCode.Description);
        if PageFilterBuilder.RunModal then begin
            ReasonCode.SetView(PageFilterBuilder.GetView('Generate New Employee'));
            if ReasonCode.GetFilter(Description) = '' then
                Error('Please assign new employee no. first');
            CurrentEmployee.TestField("Employment Type", CurrentEmployee."Employment Type"::Contract);
            NewEmployee.Reset;
            if CurrentEmployee."Employment Type" = CurrentEmployee."Employment Type"::Contract then begin
                NewEmployee.Init;
                NewEmployee.TransferFields(CurrentEmployee);
                NewEmployee."No." := ReasonCode.GetFilter(Description);
                NewEmployee."Old Employee No." := CurrentEmployee."No.";
                NewEmployee.Validate("Deputation on", NewEmployee."Deputation on"::" ");
                NewEmployee.Status := NewEmployee.Status::Active;
                if CurrentEmployee.Image.HasValue then
                    NewEmployee.Validate(Image, CurrentEmployee.Image);

                NewEmployee."Employment Date" := Today;
                NewEmployee."Attendance Missed Count" := 0;
                NewEmployee."Attendance Missed On" := 0D;
                NewEmployee.Validate("Contract Expiry Month");
                NewEmployee.Settled := false;
                NewEmployee.Insert(true);
                CurrentEmployee.Status := CurrentEmployee.Status::Terminated; //CurrentEmployee.Status::Retired;
                CurrentEmployee.Modify;
                PayrollAttributeUsage.Reset;
                PayrollAttributeUsage.SetRange("Employee Code", CurrentEmployee."No.");
                if PayrollAttributeUsage.FindFirst then begin
                    repeat
                        NewPayrollAttributeUsage.Init;
                        NewPayrollAttributeUsage.TransferFields(PayrollAttributeUsage);
                        NewPayrollAttributeUsage."Employee Code" := '';
                        NewPayrollAttributeUsage."Employee Code" := NewEmployee."No.";
                        NewPayrollAttributeUsage.Insert(true);
                    until PayrollAttributeUsage.Next = 0;
                end;
            end else
                Error(Text003, CurrentEmployee."Full Name");
            Commit;
            Message(Text002, NewEmployee."Full Name");
            Page.RunModal(Page::"Employee Card", NewEmployee);
        end;
    end;

    procedure LeaveRequest();
    begin
        LeaveMgt.OpenLeaveRequest("No.");
    end;

    procedure TravelRequest();
    var
        EmployeeAct: enum "Employee Activity Type";
    begin
        TravelMgt.OpenTravelRequest("No.", FALSE, '', EmployeeAct::"Travel Request");
    end;

    local procedure ValidateDeputationOn()
    begin
        TestField("Deputation on");
        //For Province Code and Name Get
        case "Deputation on" of
            "Deputation on"::Branch:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Branch Code") then begin
                    Validate("Deputation On Code", OrganizationStructureList.Code);
                    Validate("Branch Name", OrganizationStructureList.Name);
                    Validate("Posting Region", OrganizationStructureList."Region");
                    Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                    Validate("Sol Id", OrganizationStructureList."Sol ID");
                end;
            "Deputation on"::Department:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Department Code") then begin
                    Validate("Deputation On Code", OrganizationStructureList.Code);
                    Validate("Department Name", OrganizationStructureList.Name);
                    Validate("Posting Region", OrganizationStructureList."Region");
                    Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                    Validate("Sol Id", OrganizationStructureList."Sol ID");
                end;
            "Deputation on"::Province:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Province Code") then begin
                    Validate("Deputation On Code", OrganizationStructureList.Code);
                    Validate("Province Name", OrganizationStructureList."Name");
                    Validate("Posting Region", OrganizationStructureList."Region");
                    Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                    Validate("Sol Id", OrganizationStructureList."Sol ID");
                end;
            "Deputation on"::"Extension Counter":
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Extension Counter Code") then begin
                        Validate("Deputation On Code", OrganizationStructureList.Code);
                        Validate("Extension Counter Name", OrganizationStructureList.Name);
                        Validate("Posting Region", OrganizationStructureList."Region");
                        Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                        Validate("Sol Id", OrganizationStructureList."Sol ID");
                    end;
                end;
            "Deputation on"::Unit:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::unit, "Unit code") then begin
                        Validate("Deputation On Code", OrganizationStructureList.Code);
                        Validate("Unit Name", OrganizationStructureList.Name);
                        Validate("Posting Region", OrganizationStructureList."Region");
                        Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                        Validate("Sol Id", OrganizationStructureList."Sol ID");
                    end;
                end;
        end;

    end;

    procedure TransferRequest();
    begin
        TransferMgt.OpenTransferRequest("No.");
    end;

    procedure OTRequest();
    begin
        OverTimeMgt.OpenOTForms("No.");
    end;

    procedure GetOutstandingAmt(): Decimal;
    begin
        LoanMgt.GetEmployeeSalaryOutstandingAmt("No.");
    end;

    local procedure ClearValues();
    begin
        Clear("Province Code");
        Clear("Province Name");
        Clear("Global Dimension 1 Code");
        Clear("Extension Counter Code");
        Clear("Department Code");
        Clear("Unit Code");
        Clear("Extension Counter Name");
        Clear("Department Name");
        Clear("Unit Name");
        Clear("Branch Name");
        Clear("Branch Code");
        Clear("Posting Region");
        Clear("Inside/Outside Valley");
        Clear("Deputation On Code");
        Clear("Sol Id");
    end;

    procedure ReturnAddress(VDCVar: Text; WardNoVar: Integer; LoacalityVar: Text; DistrictVara: Text; Prov: Text) ReturnText: Text;
    begin
        Clear(ReturnText);
        ReturnText := VDCVar + '- ' + Format(WardNoVar) + ', ' + LoacalityVar + ', ' + DistrictVara + ', ' + Prov;
    end;

    procedure RFRequest();
    var
        RF: Record "Retirement Fund";
    begin
        HRMgt.OpenRFRequest("No.", RF);
    end;

    procedure UpdateDimensionBasedOnDeputation(DeputationOn: Enum "Deputation Type"; DeputationCode: Code[20])
    var
        OrgStructureList: Record "Organization Structure List";
        DefaultDimension: Record "Default Dimension";
        DefaultDimension2: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
    begin
        if (DeputationOn = DeputationOn::" ") then
            exit;

        if DeputationCode = '' then begin
            ClearDimensionValue(DeputationOn);
            exit;
        end;

        OrgStructureList.SetRange(Type, DeputationOn);
        OrgStructureList.SetRange(Code, DeputationCode);
        if OrgStructureList.FindFirst() then;
        if OrgStructureList."Dimension Value Code" = '' then
            exit;

        DimensionValue.SetRange("Deputation On Type", DeputationOn);
        DimensionValue.SetRange(Code, OrgStructureList."Dimension Value Code");
        DimensionValue.SetRange(Blocked, false);
        if DimensionValue.FindFirst() then begin
            // if it is dimension 1 and 2 then validate the field
            if DimensionValue."Global Dimension No." = 1 then begin
                Validate("Global Dimension 1 Code", DimensionValue.Code);
                exit;
            end;
            if DimensionValue."Global Dimension No." = 2 then begin
                Validate("Global Dimension 2 Code", DimensionValue.Code);
                exit;
            end;
            //check if default dimension exist
            DefaultDimension.SetRange("Table ID", Database::Employee);
            DefaultDimension.SetRange("No.", "No.");
            DefaultDimension.SetRange("Dimension Code", DimensionValue."Dimension Code");
            if not DefaultDimension.FindFirst() then begin

                //if not exist insert
                DefaultDimension2.Init();
                DefaultDimension2.Validate("Table ID", Database::Employee);
                DefaultDimension2.Validate("No.", "No.");
                DefaultDimension2.Validate("Dimension Code", DimensionValue."Dimension Code");
                DefaultDimension2.Validate("Dimension Value Code", DimensionValue.Code);
                DefaultDimension2.Insert(true);
                Commit();
            end else begin

                //if exist modify
                DefaultDimension.Validate("Dimension Value Code", DimensionValue.Code);
                DefaultDimension.Modify(true);
            end;
        end;
    end;

    procedure UpdateDimensionOnModifyRecord()
    begin
        UpdateDimensionBasedOnDeputation("Deputation on"::Branch, "Branch Code");
        UpdateDimensionBasedOnDeputation("Deputation on"::Province, "Province Code");
        UpdateDimensionBasedOnDeputation("Deputation on"::Department, "Department Code");
        UpdateDimensionBasedOnDeputation("Deputation on"::Unit, "Unit Code");
        UpdateDimensionBasedOnDeputation("Deputation on"::"Sub-Unit", "Sub Unit Code");
        UpdateDimensionBasedOnDeputation("Deputation on"::"Head Office", "Branch Code");
    end;

    procedure ClearDimensionValue(DeputationOn: Enum "Deputation Type")
    var
        Dimension: Record Dimension;
        DefaultDimension: Record "Default Dimension";
    begin
        if DeputationOn = DeputationOn::" " then
            exit;

        Dimension.SetRange("Deputation On Type", DeputationOn);
        if not Dimension.FindFirst() then
            exit;

        DefaultDimension.SetRange("Table ID", Database::Employee);
        DefaultDimension.SetRange("No.", "No.");
        DefaultDimension.SetRange("Dimension Code", Dimension.Code);
        if DefaultDimension.FindFirst() then begin
            DefaultDimension."Dimension Value Code" := '';
            DefaultDimension.Modify();
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateEmploymentType(var Rec: Record "Employee"; var xRec: Record "Employee"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidationOfDeputationOn(var Employee: Record "Employee"; var ishandled: Boolean)
    begin
    end;
}