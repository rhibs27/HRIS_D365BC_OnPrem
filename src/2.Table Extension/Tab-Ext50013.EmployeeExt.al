tableextension 50013 "Employee Ext" extends Employee
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if "No." = '' then
                    Error('No. must have value.');
                "New Employee" := true; //Min
            end;
        }
        modify("First Name")
        {
            trigger OnAfterValidate()
            var
                Regex: Codeunit Regex;
                Pattern: Label '^[A-Za-z]+$';

            begin
                if not Regex.IsMatch("First Name", Pattern) then
                    Error('Only Alphabet Character Allowed');
                "Full Name" := FullName;
            end;
        }
        modify("Middle Name")
        {
            trigger OnAfterValidate()
            var
                Regex: Codeunit Regex;
                Pattern: Label '^[A-Za-z]+$';
            begin
                if not Regex.IsMatch("First Name", Pattern) then
                    Error('Only Alphabet Character Allowed');
                "Full Name" := FullName;
            end;
        }
        modify("Last Name")
        {
            trigger OnAfterValidate()
            var
                Regex: Codeunit Regex;
                Pattern: Label '^[A-Za-z]+$';
            begin
                if not Regex.IsMatch("First Name", Pattern) then
                    Error('Only Alphabet Character Allowed');
                "Full Name" := FullName;
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                // Clear(Len); //Min >> --- for Special Characters Control Add.
                // Len := StrLen(DelChr("Mobile Phone No.", '=', DelChr("Mobile Phone No.", '=', SpecialChars)));
                // if Len > 0 then
                //     Error(SpecialCharsErr);
                if not TypeHelper.IsPhoneNumber(Rec."Phone No.") then
                    Error('Phone No Validation Error');
                if StrLen("Mobile Phone No.") > 15 then //Min
                    Error(Text009);
            end;
        }

        modify("Mobile Phone No.")
        {
            trigger OnAfterValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                // Clear(Len); //Min >> --- for Special Characters Control Add.
                // Len := StrLen(DelChr("Mobile Phone No.", '=', DelChr("Mobile Phone No.", '=', SpecialChars)));
                // if Len > 0 then
                //     Error(SpecialCharsErr);
                if not TypeHelper.IsPhoneNumber(Rec."Mobile Phone No.") then
                    Error('Phone No Validation Error');
                EmployeeRec.Reset; //Min >> --- For add control in duplicate Mobile No.
                EmployeeRec.SetRange("Mobile Phone No.", Rec."Mobile Phone No.");
                EmployeeRec.SetFilter("Employment Type", '%1|%2', EmployeeRec."Employment Type"::Permanent, EmployeeRec."Employment Type"::Probation);
                if EmployeeRec.FindFirst then
                    Error(Text010, Rec."Mobile Phone No.", EmployeeRec."No.");
                if StrLen("Mobile Phone No.") > 15 then //Min
                    Error(Text009);
            end;
        }
        modify("Birth Date")
        {
            trigger OnAfterValidate()
            begin
                Age := (Today - "Birth Date") div 365;
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Birth Date");
                if EngNepDate.FindFirst then
                    "Date of Birth (B.S.)" := EngNepDate."Nepali Date"
                else
                    "Date of Birth (B.S.)" := '';
            end;
        }
        modify(Address)
        {
            Caption = 'Permanent Address';
        }
        modify("Address 2")
        {
            Caption = 'Temporary Address';
        }
        modify(Gender)
        {
            trigger OnAfterValidate()
            begin
                Validate("Tax Code", HRMgt.ValidateTaxCode(Gender, "Marital Status"));
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
            end;
        }
        modify(Title)
        {
            TableRelation = "Functional Title";
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate()
            begin
                TestField("CIF ID");
                EmployeeRec.Reset; //Min >> --- For add control in duplicate Bank A/C No.
                EmployeeRec.SetRange(Status, EmployeeRec.Status::Active);
                EmployeeRec.SetRange("Bank Account No.", Rec."Bank Account No.");
                if EmployeeRec.FindFirst then
                    Error(Text006, Rec."Bank Account No.", EmployeeRec."No.");
            end;
        }
        modify("Global Dimension 1 Code")
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Organization Structure list"::Branch), Blocked = filter(false));
            trigger OnAfterValidate()
            begin
                ValidateDeputationOn();
            end;
        }
        field(50001; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Organization Structure list"::Branch), Blocked = filter(false));
            trigger OnValidate()
            begin
                Validate("Global Dimension 1 Code", "Branch Code");
                ValidateDeputationOn();
            end;
        }
        field(50134; "Branch Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
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
        field(50003; "Deputation On Code"; Code[20])
        {
            Editable = false;
            // TableRelation = "Organization Structure List".Code where(Type = field("Deputation on"), Blocked = filter(false));
            // // ValidateTableRelation = false;
            // trigger OnValidate()
            // begin
            //     ValidateDeputationOn();
            //     // TestField("Deputation on");
            //     // case "Deputation on" of
            //     //     "Deputation on"::Branch:
            //     //         ValidateDeputationOn;
            //     //     "Deputation on"::Department:
            //     //         ValidateDeputationOn;
            //     //     "Deputation on"::Province:
            //     //         ValidateDeputationOn;
            //     //     "Deputation on"::"Extension Counter":
            //     //         ValidateDeputationOn;
            //     //     "Deputation on"::Unit:
            //     //         ValidateDeputationOn;
            //     // end;
            // end;
        }
        field(50092; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Organization Structure list"::Province), Blocked = filter(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Deputation on" = "Deputation on"::Province then
                    ValidateDeputationOn();
                // TestField("Deputation on");
                // if "Deputation on" = "Deputation on"::Province then begin
                //     Clear("Province Name");
                //     Clear("Global Dimension 1 Code");
                //     Clear("Extension Counter Code");
                //     Clear("Department Code");
                //     Clear("Unit Code");
                //     Clear("Extension Counter Name");
                //     Clear("Department Name");
                //     Clear("Unit Name");
                //     Clear("Branch Name");
                //     Clear("Posting Region");
                //     Clear("Inside/Outside Valley");
                //     // if ProvVar.Get("Province Code") then begin
                //     //     "Sol Id" := ProvVar."Sol ID";
                //     //     "Province Name" := ProvVar.Description;
                //     //     "Posting Region" := ProvVar."Posting Region";
                //     //     "Inside/Outisde Valley" := ProvVar."Inside/Outside Valley";
                //     // end;
                //     OrganizationStructureList.Reset();
                //     if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Department Code") then begin
                //         "Province Name" := OrganizationStructureList.Name;
                //         "Province Code" := OrganizationStructureList."Province Code";
                //         "Posting Region" := OrganizationStructureList."Region";
                //         "Inside/Outside Valley" := OrganizationStructureList."InsideOutside Valley";
                //     end else begin
                //         Clear("Department Name");
                //         Clear("Province Code");
                //         Clear("Province Name");
                //         Clear("Posting Region");
                //         Clear("Inside/Outside Valley");
                //     end;
                // end;
            end;
        }
        field(50002; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Organization Structure list"::Department), Blocked = filter(false));
            trigger OnValidate()
            begin
                ValidateDeputationOn();
                // TestField("Deputation on");
                // if "Deputation on" = "Deputation on"::Department then begin
                //     Clear("Province Code");
                //     Clear("Province Name");
                //     Clear("Global Dimension 1 Code");
                //     Clear("Extension Counter Code");
                //     Clear("Unit Code");
                //     Clear("Extension Counter Name");
                //     Clear("Department Name");
                //     Clear("Unit Name");
                //     Clear("Branch Name");
                //     Clear("Posting Region");
                //     Clear("Inside/Outside Valley"); //Min 10.12.2022
                //     if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Department Code") then begin
                //         "Department Name" := OrganizationStructureList.Name;
                //         "Province Code" := OrganizationStructureList."Province Code";
                //         "Province Name" := OrganizationStructureList."Province Name";
                //         "Posting Region" := OrganizationStructureList."Region";
                //         "Inside/Outside Valley" := OrganizationStructureList."InsideOutside Valley";
                //     end else begin
                //         Clear("Department Name");
                //         Clear("Province Code");
                //         Clear("Province Name");
                //         Clear("Posting Region");
                //         Clear("Inside/Outside Valley");
                //     end;
                //     // Depart.Get("Department Code");
                //     // "Department Name" := Depart.Name;
                //     // "Eco-System" := Depart."Eco-System"; //Min 10.12.2022
                //     // if ProvinceVar.Get(Depart."Province Code") then begin
                //     //     "Province Code" := ProvinceVar.Code;
                //     //     "Province Name" := ProvinceVar.Description;
                //     //     "Inside/Outisde Valley" := ProvinceVar."Inside/Outside Valley";
                //     //     "Posting Region" := ProvinceVar."Posting Region";
                //     // end;
                // end;
            end;
        }
        field(50133; "Department Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50048; "Province Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50058; "Unit Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Organization Structure List"::Department), Code = field("Department Code"), "Reporting Type" = filter("Organization Structure list"::unit));
            trigger OnValidate()
            begin
                if "Deputation on" = "Deputation on"::Unit then
                    ValidateDeputationOn
                else if "Deputation on" = "Deputation on"::Department then
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, "Unit Code") then
                        Validate("Unit Name", OrganizationStructureList.Code)
                    else
                        Error('Unit Code %1 is not Found On Organization Structure List', "Unit Code");
                // OrganizationStructureList.Reset();
                // if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, "unit Code") then begin
                //     "Department Name" := OrganizationStructureList.Name;
                //     "Province Code" := OrganizationStructureList."Province Code";
                //     "Province Name" := OrganizationStructureList."Province Name";
                //     "Posting Region" := OrganizationStructureList."Region";
                //     "Inside/Outside Valley" := OrganizationStructureList."InsideOutside Valley";
                // end;
            end;
        }
        field(50132; "Unit Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50097; "Extension Counter Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Organization Structure List"::Branch), Code = field("Global Dimension 1 Code"), "Reporting Type" = filter("Organization Structure list"::unit));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure list";
            begin
                if "Deputation on" = "Deputation on"::"Extension Counter" then
                    ValidateDeputationOn
                else if "Deputation on" = "Deputation on"::Branch then
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Extension Counter Code") then
                        Validate("Extension Counter Name", OrganizationStructureList.Code)
                    else
                        Error('Extension Counter Code %1 not Found On Organization Structure List', "Extension Counter Code");

                // if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Extension Counter Code") then begin
                //     "Department Name" := OrganizationStructureList.Name;
                //     "Province Code" := OrganizationStructureList."Province Code";
                //     "Province Name" := OrganizationStructureList."Province Name";
                //     "Posting Region" := OrganizationStructureList."Region";
                //     "Inside/Outside Valley" := OrganizationStructureList."InsideOutside Valley";
                // end;
            end;
        }
        field(50135; "Extension Counter Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50004; "Advance Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("G/L Entry".Amount where("Posting Date" = field("Date Filter"), "G/L Account No." = field("G/L Account Filter"), "Shortcut Dimension 3 Code" = field("No.")));
            Caption = 'Advance Amount';
        }
        field(50005; "G/L Account Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "G/L Account"."No.";
        }
        field(50006; "Employee Work Shift"; Code[10])
        {
            TableRelation = "Employee Work Shift";
            DataClassification = CustomerContent;
        }
        // field(50007; "Assigned User ID"; Code[50])
        // {
        //     TableRelation = "User Setup";
        //     DataClassification = CustomerContent;
        //     Caption = 'Assigned User ID';
        // }
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
                                                                                                                   "Attribute Sub Type" = filter("Attribute Sub Type"::CIT | "Attribute Sub Type"::"Employee Contribution" | "Attribute Sub Type"::"Employer Contribution" | "Attribute Sub Type"::RF | "Attribute Sub Type"::"Lump Sum Contribution"),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Document Type" = field("Document Type Filter")));
            Editable = false;
        }
        field(50010; "Total Donation Contribution"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                  "Attribute Type" = filter("Non-Payment"),
                                                                                                                  "Attribute Sub Type" = filter(Donation),
                                                                                                                  "Posting Date" = field("Date Filter"),
                                                                                                                  Reversed = const(false)));
            Editable = false;
        }
        field(50011; "Premium of Life Insurance"; Decimal)
        { DataClassification = CustomerContent; }
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
                if SalaryLevel.Get("Salary Level") then
                    "Salary Level Description" := SalaryLevel.Description
                else
                    "Salary Level Description" := '';
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
        field(50020; "Full Name (Nepali)"; Text[30])
        {
            Description = 'In Nepali';
        }
        field(50021; "Father's Name (Nepali)"; Text[30])
        {
            Description = 'In Nepali';
        }
        field(50022; "Mother's Name (Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50023; "GrandFather's Name (Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50024; "Promotion Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50025; "CIT No."; Code[20])
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
                if StrLen("PAN No.") <> 9 then //Min
                    Error(Text007);
            end;
        }
        field(50028; "Third Party Payroll Emp Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'not used';
        }
        field(50029; "Bank No."; Code[20])
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
            CalcFormula = sum("Employee Loan/Advance"."Remaining Amount" where("Employee Code" = field("No."),
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
        }
        field(50034; "Maintenance Advance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Attribute Sub Type" = filter(Advance),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Payroll Attribute Code" = const('MAINTAINENCE ADV')));
        }
        field(50035; "PF Contribution"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Attribute Sub Type"::"Employee Contribution"),
                                                                                                                   "Document Type" = field("Document Type Filter")));
        }
        field(50036; "CIT Deposit"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Attribute Sub Type"::CIT)));
        }
        field(50037; "PF Contribution (Office)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
                                                                                                                   "Posting Date" = field("Date Filter"),
                                                                                                                   Reversed = const(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Attribute Sub Type"::"Employer Contribution"),
                                                                                                                   "Document Type" = field("Document Type Filter")));
        }
        // field(50038; "Total PF"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
        //                                                                                                            "Posting Date" = field("Date Filter"),
        //                                                                                                            Reversed = const(false),
        //                                                                                                            "Payroll Attribute Code" = const('CIT- OFFICE CONT.-DE')));
        // }
        field(50039; "Advance for Expenses"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("G/L Entry".Amount where("Shortcut Dimension 4 Code" = field("No."),
                                                                                             "Posting Date" = field("Date Filter"),
                                                                                             "G/L Account No." = const('121082')));
        }
        // field(50040; "CIT Office Cont. Deduction"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = - sum("Detailed Employee Ledger Entry".Amount where("Employee No." = field("No."),
        //                                                                                                            "Posting Date" = field("Date Filter"),
        //                                                                                                            Reversed = const(false),
        //                                                                                                            "Payroll Attribute Code" = const('CIT- OFFICE CONT.-DE')));
        //     Editable = false;
        // }
        field(50041; "Document Type Filter"; Enum "Employee Document Type")
        {
            FieldClass = FlowFilter;
        }
        field(50042; Age; Integer)
        {
            DataClassification = CustomerContent;
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
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Clear("Citizenship Issue Place Code");
                Clear("Citizenship Issue Place");
            end;
        }
        field(50045; "Passport Number"; Code[10])
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
        }

        // field(50049; "Sub-Province"; Text[30])
        // {
        //     DataClassification = CustomerContent;
        //     Description = 'not used(used city instead)';
        // }
        // field(50050; Cluster; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     // TableRelation = if ("Sub Province Code" = const()) "Employee Hierarchy Master" where(Type = const(Cluster))
        //     // else
        //     // "Employee Hierarchy Master" where("Sub-Province" = field("Sub Province Code"),
        //     //                                                                                              "Type" = const(Cluster));
        //     trigger OnValidate()
        //     var
        //         ClusExtCounter: Record "Employee Hierarchy Master";
        //     begin
        //         //ValidateCluster;
        //         if not ClusExtCounter.Get(Cluster) then begin
        //             Clear("Global Dimension 1 Code");
        //             Clear("Extension Counter Code");
        //         end;
        //     end;
        // }
        field(50051; "Distance betn Res and Office"; Decimal)
        {
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
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Citizenship Issue Date");
                if EngNepDate.FindFirst then
                    "Citizenship Date(Nepali)" := EngNepDate."Nepali Date"
                else
                    "Citizenship Date(Nepali)" := '';
            end;


        }
        field(50057; Religion; Text[30])
        {
            DataClassification = CustomerContent;
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
                // IF FunctionalTitle.GET("Functional Title") THEN
                //     "Functional Title Desc" := FunctionalTitle.Description;}
            end;
        }
        field(50067; "Out-Station eligible"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateOutstationAllowance;
            end;
        }
        field(50068; "Inside/Outside Valley"; Enum "Outside/Inside Valley")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        // field(50069; Screener; Boolean)
        // {
        //     DataClassification = CustomerContent;
        //     Description = 'Loan';
        // }
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
            TableRelation = "Organization Structure List".Code where(Type = filter("Organization Structure list"::Department));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
            Description = 'KPI 1.00';
            trigger OnValidate()
            begin
                //HRMgt.GetEmployeeName("KPI Deputation Value", "Recommender Name");
            end;
        }
        // field(50072; "Approver Code"; Code[20])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;
        //     DataClassification = CustomerContent;

        //     trigger OnValidate()
        //     begin
        //         HRMgt.GetEmployeeName("Approver Code", "Approver Name");
        //     end;
        // }
        // field(50073; "Recommender Name"; Text[50])
        // { DataClassification = CustomerContent; }
        // field(50074; "Approver Name"; Text[50])
        // { DataClassification = CustomerContent; }
        field(50075; "Service Period"; Integer)
        { DataClassification = CustomerContent; }
        field(50076; "Converted To Emp. Date"; Date)
        { DataClassification = CustomerContent; }
        field(50077; "NAV Login ID"; Code[50])
        {
            TableRelation = "User Setup";
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
                    // VALIDATE("Company E-Mail", LOWERCASE(STRSUBSTNO('%1%2', COPYSTR("NAV Login ID", STRPOS("NAV Login ID", '\') + 1), '@nicasiabank.com')));
                end;
            end;
        }
        // field(50078; "Company Code"; Code[10])
        // {
        //     TableRelation = Department;
        //     DataClassification = CustomerContent;
        //     Caption = 'Company Code';
        // }
        field(50079; Salutation; Enum Salutation)
        {
            DataClassification = CustomerContent;
            Caption = 'Salutation';
        }
        field(50080; "Permanent District"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'Permanent District';
            trigger OnValidate()
            BEGIN
                IF (Rec."Permanent District" <> xRec."Permanent District") AND ("Permanent District" <> '') THEN
                    HRMgt.CheckDistrictName("Permanent District");
                "Address" := ReturnAddress("Permanent Province", "Permanent District", "Permanent VDC", "Ward No");
            END;

            trigger OnLookup()
            begin
                VALIDATE("Permanent District", HRMgt.LookupDistrict("Permanent Province", "Permanent District"));
            end;
        }
        field(50081; "Temporary District"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'Temporary District';
            trigger OnValidate()
            begin
                if (Rec."Temporary District" <> xRec."Temporary District") and ("Temporary District" <> '') then
                    HRMgt.CheckDistrictName("Temporary District");
                "Address 2" := ReturnAddress("Temporary Province", "Temporary District", "Temporary VDC", "Temporary Ward No");
            END;

            trigger OnLookup()
            begin
                Validate("Temporary District", HRMgt.LookupDistrict("Temporary Province", "Temporary District"));
            end;
        }
        field(50082; "Permanent Province"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'Permanent Provience address';
            trigger OnValidate()
            begin
                if (Rec."Permanent Province" <> xRec."Permanent Province") and ("Permanent Province" <> '') then begin
                    HRMgt.CheckProvience("Permanent Province");
                    Clear("KPI Deputation");
                    Clear("Permanent District");
                end;
                if "Permanent Province" = '' then begin
                    Clear("KPI Deputation");
                    Clear("Permanent District");
                end;
                Address := ReturnAddress("Permanent Province", "Permanent District", "Permanent VDC", "Ward No");
            end;

            trigger OnLookup()
            begin
                Validate("Permanent Province", HRMgt.LookupProvience("Permanent Province"));
            end;
        }
        field(50083; "Temporary Province"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'Temporary Provience address';
            trigger OnValidate()
            begin
                if (Rec."Temporary Province" <> xRec."Temporary Province") and ("Temporary Province" <> '') then begin
                    HRMgt.CheckProvience("Temporary Province");
                    Clear("Temporary Ward No");
                    Clear("Temporary District");
                end;
                if "Temporary Province" = '' then begin
                    Clear("Temporary Ward No");
                    Clear("Temporary District");
                end;
                "Address 2" := ReturnAddress("Temporary Province", "Temporary District", "Temporary VDC", "Temporary Ward No");
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
                //                                                 {IF (Rec."KPI Deputation Code" <> xRec."KPI Deputation Code") AND ("KPI Deputation Code" <> '') THEN BEGIN
                //     HRMgt.CheckSubProvience("KPI Deputation Code");
                //     CLEAR("Permanent District");
                // END;
                // IF "KPI Deputation Code" = '' THEN
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
            MaxValue = 32;
            trigger OnValidate()
            begin

                "Address 2" := ReturnAddress("Temporary Province", "Temporary District", "Temporary VDC", "Temporary Ward No");
            end;
        }
        field(50086; "Permanent VDC"; Text[30])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Address := ReturnAddress("Permanent Province", "Permanent District", "Permanent VDC", "Ward No");
            end;
        }
        field(50087; "Temporary VDC"; Text[30])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Address 2" := ReturnAddress("Temporary Province", "Temporary District", "Temporary VDC", "Temporary Ward No");
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
                                                                                                                   "Attribute Sub Type" = filter("Attribute Sub Type"::RF)));
        }
        field(50091; "Citizenship Issue Place Code"; Code[10])
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

        field(50093; "Ward No"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 1;
            MaxValue = 32;
            Description = 'Citizenship ward no';
            trigger OnValidate()
            begin
                Address := ReturnAddress("Permanent Province", "Permanent District", "Permanent VDC", "Ward No");
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
                if "Confirmation Date" < "Employment Date" then
                    Error('Confirmation date cannot be less than employment date');
            end;
        }

        // field(50098; "Reporting Line 1"; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     TableRelation = "Employee Hierarchy Master" where(Type = const("Reporting Line 1"));
        // }
        // field(50099; "Reporting Line 2"; Code[20])
        // {
        //     TableRelation = "Employee Hierarchy Master" where(Type = const("Reporting Line 2"));
        //     DataClassification = CustomerContent;
        // }
        // field(50100; Office; Code[20])
        // {
        //     TableRelation = "Employee Hierarchy Master" where(Type = const(Office));
        //     DataClassification = CustomerContent;
        // }
        // field(50101; "Eco-System"; Code[20])
        // {
        //     TableRelation = "Employee Hierarchy Master" where(Type = const("Eco-System"));
        //     DataClassification = CustomerContent;
        // }
        field(50102; "Lump Sum CIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Employee Ledger Entry".Amount WHERE("Employee No." = FIELD("No."),
                                                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                                                   "Reversed" = CONST(false),
                                                                                                                   "Attribute Type" = filter("Attribute Type"::Deduction),
                                                                                                                   "Attribute Sub Type" = filter("Attribute Sub Type"::"Lump Sum Contribution"),
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
        field(50104; "Secondary Mobile No."; Text[15])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            VAR
                TypeHelper: Codeunit "Type Helper";
            begin
                if not TypeHelper.IsPhoneNumber(Rec."Secondary Mobile No.") then
                    Error('Phone No Validation Error');

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
            CharAllowed = 'AZaz';
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
                if EngNepDate.FindFirst then
                    Validate("Insurance Expiry Date (B.S.)", EngNepDate."Nepali Date")
                else
                    Validate("Insurance Expiry Date (B.S.)", '');
            end;
        }
        field(50111; "Insurance Date (B.S.)"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50112; "Insurance Expiry Date (B.S.)"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
        }
        field(50113; "Premium Property Insurance"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Insurance';
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
        field(50122; "VDC/Municipality (Nepali)"; Text[20])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50123; "Employee No. (Nepali)"; Text[20])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50124; "Citizenship Date(Nepali)"; Text[10])
        {
            DataClassification = CustomerContent;
            Description = 'In nepali';
            Editable = false;
        }
        field(50125; "System Owner"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'System Access';
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

        field(50136; "Facebook Url"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50154; Saved; Boolean)
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
            DataClassification = CustomerContent;
        }
        field(50140; "Last Placement Date"; Date)
        {
            DataClassification = CustomerContent;
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
            TableRelation = Relative;
        }
        // field(50150; COPO; Boolean)
        // {
        //     DataClassification = CustomerContent;
        // }
        // field(50151; "Department Head"; Boolean)
        // {
        //     DataClassification = CustomerContent;
        // }
        // field(50152; "Chief Of Eco-System"; Boolean)
        // {
        //     DataClassification = CustomerContent;
        // }
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
        // field(50156; Task; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Employee Task";
        //     trigger OnValidate()
        //     var
        //         EmployeeTask: Record "Employee Task";
        //     begin
        //         if EmployeeTask.Get(Task) then
        //             Validate("Task Name", EmployeeTask."Task Name");
        //     end;
        // }
        // field(50157; "Task Name"; Text[100])
        // {
        //     DataClassification = ToBeClassified;
        // }

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
    }
    keys
    {
        key(key6; "First Name") { }
        key(key7; "Last Name") { }
        key(key8; "Full Name") { }
    }
    fieldgroups
    {
        addlast(DropDown; "No.", "Full Name")
        {
        }
    }

    trigger OnModify()
    begin
        Saved := false;
    end;

    trigger OnDelete()
    var

    begin
        Error('');

        //IME.SRT
        GLSetup.Get;
        DimensionValue.SetRange("Dimension Code", GLSetup."Employee Dimension");
        DimensionValue.SetRange(Code, "No.");
        if DimensionValue.FindFirst then begin
            DimensionValue.Blocked := true;
            DimensionValue.Modify(true);
        end;
    end;
    //IME.SRT
    trigger OnRename()
    begin
        Error('');
    end;

    var
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        DimName: Text;
        DefaultDimension: Record "Default Dimension";
        Text002: Label 'New Employee Name %1 is created successfully.';
        PayrollAttributeUsage: Record "Payroll Attributes Usage";
        PayrollEngine: Codeunit "Payroll Engine";
        PayrollGeneralSetup: Record "Payroll General Setup";
        PayrollAttribute: Record "Payroll Attributes";
        Text003: Label 'ENU=%1 is not a contract Employee.';
        EngNepDate: Record "English-Nepali Date";
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        LoanMgt: Codeunit "Loan Mgt.";
        OverTimeMgt: Codeunit "OverTime Mgt";
        ProvinceVar: Record "Province";
        Text004: Label '%1 is %2.';
        Text005: Label '%1 must be greater.';
        LeaveMgt: Codeunit "Leave Mgt.";
        OrganizationStructureList: Record "Organization Structure List";
        FunctionalTitle: Record "Functional Title";
        EmployeeRec: Record Employee;
        Text006: Label 'Bank Account No. %1 already used in Employee  No. %2.';
        Text007: Label 'PAN No. must be 9 digits.';
        NumericError: Label '%1 must be Numeric';
        Len: Integer;
        SpecialCharsErr: Label 'You cannot enter the special characters.';
        SpecialChars: Label '!|@|#|$|%|&|*|(|)|_|-|+|=| |?|/|\';
        Text010: Label 'Mobile No. %1 already used in Employee No. %2.';
        Text009: Label 'Mobile No. must be 15 digits.';

    local procedure CreateDimension()
    var
        DimValue: Record "Dimension Value";
    begin
        //IME19.00 Begin
        GLSetup.Get;
        GLSetup.TestField("Employee Dimension");
        DimName := FullName();
        DimValue.SetRange("Dimension Code", GLSetup."Employee Dimension");
        DimValue.SetRange(Code, "No.");
        if not DimValue.FindFirst then begin
            DimValue.Init;
            DimValue.Validate("Dimension Code", GLSetup."Employee Dimension");
            DimValue.Validate(Code, "No.");
            DimValue.Validate(Name, DimName);
            DimValue.Insert(true);
            Clear(DefaultDimension);
            DefaultDimension.Init;
            DefaultDimension.Validate("Table ID", Database::Employee);
            DefaultDimension.Validate("No.", "No.");
            DefaultDimension.Validate("Dimension Code", GLSetup."Employee Dimension");
            DefaultDimension.Validate("Dimension Value Code", "No.");
            DefaultDimension.Validate("Value Posting", DefaultDimension."Value Posting"::"Same Code");
            DefaultDimension.Insert(true);
        end else begin
            if DimValue.Name <> DimName then begin
                DimValue.Validate(Name, DimName);
                DimValue.Modify;
            end;
        end;
        //IME19.00 End
        // Bhuwan 8/16/2019
    end;

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

    local procedure ValidateOutstationAllowance();
    begin
        //   {Employee.GET("No.");
        //   PayrollAttributeSubgroup.RESET;
        //   PayrollAttributeSubgroup.SETRANGE("Auto-Validate",TRUE);
        //   IF PayrollAttributeSubgroup.FINDFIRST THEN
        //   Code:= PayrollAttributeSubgroup.Code;
        //   IF "Out-Station eligible" THEN BEGIN
        //     IF PayrollEngine.PayrollAttCheck(Code,"No.") THEN BEGIN
        //       IF PayrollAttributeUsage.GET(Code,"No.") THEN
        //         ERROR('Out Station Allowance Already present for this Employee.');
        //       IF PayrollAttributeSubgroup.FINDFIRST THEN BEGIN
        //         Code:= PayrollAttributeSubgroup.Code;
        //         PayrollAttributeUsage.INIT;
        //         PayrollAttributeUsage."Employee Code":=Employee."No.";
        //         PayrollAttributeUsage.VALIDATE(Code,PayrollAttributeSubgroup.Code);
        //         PayrollAttributeUsage.VALIDATE(Description,PayrollAttributeSubgroup.Description);
        //         PayrollAttributeUsage.INSERT;
        //       END;
        //     END;
        //   END;
        //    IF NOT "Out-Station eligible" THEN BEGIN
        //       PayrollAttributeUsage.GET(Code,"No.");
        //         PayrollAttributeUsage.DELETE;
        //    END;
        //    }
    end;

    local procedure OnValidateFunctionTitle();
    begin
        PayrollGeneralSetup.Get;

        //IF NOT ("Functional Title" IN [PayrollGeneralSetup."COPO Functional Title",PayrollGeneralSetup."COSPO Functioal Title"] ) THEN
        if PayrollAttributeUsage.Get(PayrollGeneralSetup."COPO/COSPO Allowance", "No.") then
            PayrollAttributeUsage.Delete;

        if PayrollGeneralSetup."BM Functional Title" = "Functional Title" then
            if PayrollAttributeUsage.Get(PayrollGeneralSetup."BM Accomendation", "No.") then
                exit;
        if PayrollEngine.PayrollAttCheck(PayrollGeneralSetup."BM Accomendation", "No.") then begin
            PayrollAttributeUsage.Init;
            PayrollAttributeUsage."Employee Code" := "No.";
            PayrollAttributeUsage.Validate(Code, PayrollGeneralSetup."BM Accomendation");
            PayrollAttribute.Get(PayrollGeneralSetup."BM Accomendation");
            PayrollAttributeUsage.Validate(Description, PayrollAttribute.Description);
            PayrollAttributeUsage.Insert;
        end;

        if "Functional Title" in [PayrollGeneralSetup."COPO Functional Title", PayrollGeneralSetup."COSPO Functioal Title"] then
            if PayrollEngine.PayrollAttCheck(PayrollGeneralSetup."COPO/COSPO Allowance", "No.") then begin
                PayrollAttributeUsage.Init;
                PayrollAttributeUsage."Employee Code" := "No.";
                PayrollAttributeUsage.Validate(Code, PayrollGeneralSetup."COPO/COSPO Allowance");
                PayrollAttribute.Get(PayrollGeneralSetup."COPO/COSPO Allowance");
                PayrollAttributeUsage.Validate(Description, PayrollAttribute.Description);
                PayrollAttributeUsage.Insert;
            end;
    end;

    PROCEDURE LeaveRequest();
    BEGIN
        LeaveMgt.OpenLeaveRequest("No.");
    END;

    PROCEDURE TravelRequest();
    var
        EmployeeAct: enum "Employee Activity Type";
    BEGIN
        TravelMgt.OpenTravelRequest("No.", FALSE, '', EmployeeAct::"Travel Request");
    END;


    procedure ChangeEmployeeJobType();
    begin
        if Confirm('Do you want to confirm employee %1 ?', false, "Full Name") then begin
        end;
    end;

    local procedure ValidateDeputationOn();
    var
        OrganizationStructureLine: Record "Organization Structure line";
    begin
        TestField("Deputation on");
        case "Deputation on" of
            "Deputation on"::Branch:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Branch Code") then begin
                    Validate("Deputation On Code", OrganizationStructureList.Code);
                    Validate("Branch Name", OrganizationStructureList.Name);
                    Validate("Province Code", OrganizationStructureList."Province Code");
                    Validate("Province Name", OrganizationStructureList."Province Name");
                    Validate("Posting Region", OrganizationStructureList."Region");
                    Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                end;
            "Deputation on"::Department:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Department Code") then begin
                    Validate("Deputation On Code", OrganizationStructureList.Code);
                    Validate("Department Name", OrganizationStructureList.Name);
                    Validate("Province Code", OrganizationStructureList."Province Code");
                    Validate("Province Name", OrganizationStructureList."Province Name");
                    Validate("Posting Region", OrganizationStructureList."Region");
                    Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                end;
            "Deputation on"::Province:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Province Code") then begin
                    Validate("Deputation On Code", OrganizationStructureList.Code);
                    Validate("Province Code", OrganizationStructureList."Province Code");
                    Validate("Province Name", OrganizationStructureList."Province Name");
                    Validate("Posting Region", OrganizationStructureList."Region");
                    Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                end;
            "Deputation on"::"Extension Counter":
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Extension Counter Code") then begin
                        Validate("Deputation On Code", OrganizationStructureList.Code);
                        Validate("Extension Counter Name", OrganizationStructureList.Name);
                        Validate("Province Code", OrganizationStructureList."Province Code");
                        Validate("Province Name", OrganizationStructureList."Province Name");
                        Validate("Posting Region", OrganizationStructureList."Region");
                        Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                    end;
                    OrganizationStructureLine.Reset();
                    OrganizationStructureLine.SetRange(Type, OrganizationStructureLine.Type::Branch);
                    OrganizationStructureLine.SetRange("Reporting Type", OrganizationStructureLine.Type::"Extension Counter");
                    OrganizationStructureLine.SetRange("Reporting Code", "Extension Counter Code");
                    if OrganizationStructureLine.FindFirst() then
                        Validate("Branch Code", OrganizationStructureLine.Code);

                end;
            "Deputation on"::Unit:
                begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::unit, "Unit Name") then begin
                        Validate("Deputation On Code", OrganizationStructureList.Code);
                        Validate("Unit Name", OrganizationStructureList.Name);
                        Validate("Province Code", OrganizationStructureList."Province Code");
                        Validate("Province Name", OrganizationStructureList."Province Name");
                        Validate("Posting Region", OrganizationStructureList."Region");
                        Validate("Inside/Outside Valley", OrganizationStructureList."InsideOutside Valley");
                    end;
                    OrganizationStructureLine.Reset();
                    OrganizationStructureLine.SetRange(Type, OrganizationStructureLine.Type::Department);
                    OrganizationStructureLine.SetRange("Reporting Type", OrganizationStructureLine.Type::Unit);
                    OrganizationStructureLine.SetRange("Reporting Code", "Unit Code");
                    if OrganizationStructureLine.FindFirst() then
                        Validate("Department Code", OrganizationStructureLine.Code);
                end;
        end;

        // if "Deputation on" = "Deputation on"::Branch then begin
        //     Clear("Province Code");
        //     Clear("Province Name");
        //     Clear("Extension Counter Code");
        //     Clear("Department Code");
        //     Clear("Unit Code");
        //     Clear("Extension Counter Name");
        //     Clear("Department Name");
        //     Clear("Unit Name");
        //     Clear("Branch Name");
        //     Clear("Posting Region");
        //     Clear("Inside/Outside Valley");
        //     OrganizationStructureList.Reset();
        //     if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Deputation On Code") then begin
        //         "Branch Name" := OrganizationStructureList.Name;
        //         "Province Code" := OrganizationStructureList."Province Code";
        //         "Province Name" := OrganizationStructureList."Province Name";
        //         "Posting Region" := OrganizationStructureList."Region";
        //         "Inside/Outside Valley" := OrganizationStructureList."InsideOutside Valley";
        //     end else begin
        //         Clear("Branch Name");
        //         Clear("Province Code");
        //         Clear("Province Name");
        //         Clear("Posting Region");
        //         Clear("Inside/Outside Valley");
        //     end;
        // end;
    end;

    // local procedure ValidateExtenCounter();
    // begin
    //     if "Deputation on" = "Deputation on"::"Extension Counter" then begin
    //         Clear("Province Code");
    //         Clear("Province Name");
    //         // Clear("Sub Province Name");
    //         // Clear("Sub Province Code");
    //         Clear("Global Dimension 1 Code");
    //         Clear("Department Code");
    //         Clear("Unit Code");
    //         Clear("Extension Counter Name");
    //         Clear("Department Name");
    //         Clear("Unit Name");
    //         Clear("Branch Name");
    //         Clear("Posting Region");
    //         Clear("Inside/Outside Valley");

    //         EmpHie.Reset;
    //         EmpHie.SetRange(Code, "Extension Counter Code");
    //         EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
    //         if EmpHie.FindFirst then begin
    //             "Global Dimension 1 Code" := EmpHie."Shortcut Dimension 1 Code";
    //             "Extension Counter Name" := EmpHie.Description;
    //             DimensionValue.Reset;
    //             DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
    //             DimensionValue.SetRange(Code, EmpHie."Shortcut Dimension 1 Code");
    //             if DimensionValue.FindFirst then begin
    //                 "Branch Name" := DimensionValue.Name;
    //                 "Sol Id" := DimensionValue.Code;
    //                 "Posting Region" := DimensionValue."Posting Region";
    //                 "Inside/Outside Valley" := DimensionValue."Inside/Outisde Valley";
    //                 if ProvinceVar.Get(DimensionValue.Province) then begin
    //                     "Province Code" := ProvinceVar.Code;
    //                     "Province Name" := ProvinceVar.Description;
    //                 end;
    //             end;
    //             ValidateShortcutDimCode(1, "Global Dimension 1 Code");
    //         end;
    //     end;
    // end;

    PROCEDURE TransferRequest();
    BEGIN
        TransferMgt.OpenTransferRequest("No.");
    END;

    PROCEDURE OTRequest();
    BEGIN
        OverTimeMgt.OpenOTForms("No.");
    END;

    PROCEDURE OutOfOffice();
    BEGIN
        TransferMgt.OpenOutofOfficeForms("No.");
    END;

    PROCEDURE BulkCash();
    BEGIN
        HRMgt.OpenBulkCash("No.");
    END;

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
        Clear("Posting Region");
        Clear("Inside/Outside Valley");
        Clear("Deputation On Code");
    end;

    local procedure ReturnAddress(Prov: Text; DistrictVara: Text; VDCVar: Text; WardNoVar: Integer) ReturnText: Text;
    begin
        Clear(ReturnText);
        ReturnText := Prov + ', ' + DistrictVara + ', ' + VDCVar + '-' + Format(WardNoVar);
    end;

    procedure RFRequest();
    var
        RF: Record "Retirement Fund" temporary;
    begin
        HRMgt.OpenRFRequest("No.", RF);
    end;
}
