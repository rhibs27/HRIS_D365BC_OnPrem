table 50140 "Employee/HR Transfer"
{
    Caption = 'Employee/Hr Transfer';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    if Cancelled then begin
                        NoSeriesMgt.TestManual(HRSetup."Cancel Document No. Series");
                        "No. Series" := '';
                    end else begin
                        case Type of
                            //for transfer
                            Type::"Employee Transfer", Type::"HR Transfer", Type::"Transfer Claim":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Transfer No.");
                                    "No. Series" := '';
                                end;
                        end;
                    end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type")
        {
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Deputation On", EmpVar."Deputation on");
                    // Validate("Auth. Account No.", EmpVar."Bank Account No.");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    Validate("Sub Province Code", EmpVar."Sub Province Code");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    /*VALIDATE("Compensatory Days", EmpVar."Reporting Line 1");
                    VALIDATE("Reporting Line 2 Code", EmpVar."Reporting Line 2");*/
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate(Ecosystem, EmpVar."Eco-System");
                    Validate("Office Code", EmpVar.Office);

                    // if not (Type in [Type::"Employee Transfer", Type::"HR Transfer"]) then begin
                    //     Validate("Recommender Code", EmpVar."KPI Deputation Value");
                    //     Validate("Recommender Name", EmpVar."Recommender Name");
                    //     Validate("Approver Code", EmpVar."Approver Code");
                    //     Validate("Approver Name", EmpVar."Approver Name");
                    // end;
                    // "Bank Account No." := EmpVar."Bank Account No.";
                    // "Contact No." := EmpVar."Mobile Phone No.";

                    ValidateTransfer();
                end else begin
                    Clear("Employee Name");
                    Validate("Shortcut Dimension 1 Code", '');
                    Validate(Department, '');
                    // Validate("Auth. Account No.", '');
                    Validate("Salary Level Code", '');
                end;

            end;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                // if Type <> Type::Overtime then
                //     EmployeeRec.Get("Employee No.");
                if "Start Date" <> 0D then begin
                    if "Start Date" < EmployeeRec."Employment Date" then
                        Error('Cannot apply before your employment date');
                end;

                //<<check for leave

                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Start Date");
                if EngNepDate.FindFirst then
                    Validate("Start Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Start Date (BS)");
                if "Start Date" <> xRec."Start Date" then begin
                    Clear("End Date");
                    Clear("End Date (BS)");
                    Validate("No. of Days", 0);
                end;
                // //AT Travel Req Control
                // if Type = Type::"Travel Request" then begin
                //     "Employee Tranfer".Reset;
                //     "Employee Tranfer".SetRange("Employee No.", "Employee No.");
                //     "Employee Tranfer".SetRange(Type, "Employee Tranfer".Type::"Travel Request");
                //     "Employee Tranfer".SetFilter("No.", '<>%1', "No.");
                //     "Employee Tranfer".SetFilter("Approval Status", '<>%1', "Employee Tranfer"."Approval Status"::Rejected);
                //     "Employee Tranfer".SetRange("Start Date", "Start Date");
                //     if "Employee Tranfer".FindFirst then
                //         Error('Travel Request for Start Date = %1 already exists for %2', "Start Date", "Employee Name");
                // end;

            end;
        }
        field(8; "End Date"; Date)
        {

            trigger OnValidate()
            var
                TravelMgt: Codeunit "Travel Mgt.";
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "End Date");
                if EngNepDate.FindFirst then
                    Validate("End Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("End Date (BS)");
                if "End Date" <> 0D then
                    Validate("No. of Days", TravelMgt.CalculateNoOfDaysTravel("Start Date", "End Date", "Employee No."))
                else begin
                    Clear("End Date (BS)");
                    Clear("No. of Days");
                end;
            end;
        }
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;

        }
        field(10; "Requested Date"; Date)
        {

            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Requested Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year")
                else
                    Clear("Fiscal Year");
            end;
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(12; "Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(13; "End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[100])
        {

            trigger OnLookup()
            begin
                // PAGE.Run(PAGE::"Employee List");
            end;
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            trigger OnValidate()
            begin
                // if "Approval Status" = "Approval Status"::Approved then
                //     if Type = Type::Resignation then begin
                //         EmployeeRec.Get("Employee No.");
                //         // EmployeeRec.Validate("Resignation Date", "HR Proposed Date");
                //         // EmployeeRec.VALIDATE(Status,EmployeeRec.Status::Inactive);
                //         EmployeeRec.Modify;
                //     end;
                // if "Approval Status" = "Approval Status"::Screened then begin
                //     Validate("Screener Date", Today);
                //     Validate("Screener ID", HRMgt.GetEmployeeNo);
                // end;
                // if "Approval Status" = "Approval Status"::"Final Approved & Forwarded to Finance Department" then begin
                //     Validate("Final Approver Date", Today);
                //     Validate("Final Approver", HRMgt.GetEmployeeNo);
                // end;
            end;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                GLSetup.Get;
                if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
                    Validate("Branch Name", DimValue.Name)
                else
                    Validate("Branch Name", '');
            end;
        }
        field(18; Department; Code[20])
        {
            Editable = false;
            TableRelation = Department;

            trigger OnValidate()
            var
                DeptVar: Record Department;
            begin
                if DeptVar.Get(Department) then
                    Validate("Department Name", DeptVar.Name)
                else
                    Clear("Department Name");
            end;
        }
        field(19; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(21; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        // field(22; "Recommender Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Recommender Code", EmpVar."No.") = 0 then
        //                 Validate("Recommender Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Recommender Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Recommender.');
        //         HRMgt.GetEmployeeName("Recommender Code", "Recommender Name");
        //         if "Recommender Code" = '' then
        //             Validate("Approver Type", "Approver Type"::Direct)
        //         else
        //             Validate("Approver Type", "Approver Type"::"With Recommendation");
        //         //requirement not fixed
        //         if "Recommender Code" <> '' then begin
        //             if Type <> Type::Overtime then //Min 8.25.2022
        //                 if "Recommender Code" = "Approver Code" then
        //                     Error('Recommender and Approver cannot be same person.');
        //             EmployeeRec.Get("Recommender Code");
        //             if SalaryLevel.Get("Salary Level Code") then;
        //             if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //             if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                 Error('Salary level of recommender (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
        //         end;
        //     end;
        // }
        // field(23; "Approver Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Approver Code", EmpVar."No.") = 0 then
        //                 Validate("Approver Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Approver Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Approver.');
        //         //requirement not fixed
        //         HRMgt.GetEmployeeName("Approver Code", "Approver Name");
        //         if "Approver Code" <> '' then begin
        //             HRSetup.Get;
        //             if EmployeeRec.Get("Recommender Code") then;
        //             if Type = Type::Resignation then begin
        //                 if not (EmployeeRec."Functional Title" = HRSetup."HR Head Functional Title") then
        //                     if "Recommender Code" = "Approver Code" then
        //                         Error('Recommender and Approver cannot be same person.');
        //             end else
        //                 if Type <> Type::Overtime then //Min 8.25.2022
        //                     if "Recommender Code" = "Approver Code" then
        //                         Error('Recommender and Approver cannot be same person.');

        //             EmployeeRec.Get("Approver Code");
        //             HRSetup.Get;
        //             if EmployeeRec."Functional Title" <> HRSetup."HR Head Functional Title" then begin
        //                 if SalaryLevel.Get("Salary Level Code") then;
        //                 if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //                 if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                     Error('Salary level of approver (%1) must be greater than salary level of employee (%2).', EmployeeRec."Full Name", "Employee Name");
        //             end;
        //         end;
        //     end;
        // }
        field(24; "Employee Work Shift"; Code[10])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        // field(26; "Recommender Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(27; "Approver Name"; Text[50])
        // {
        //     Editable = false;
        // }
        field(28; "Extension Counter Code"; Code[20])
        {
            TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));
        }
        field(29; "Sub Province Code"; Code[20])
        {
            TableRelation = "Sub Province".Code;
        }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = Province;
        }
        field(31; "Unit Code"; Code[20])
        {
            TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST(Unit));
        }
        field(32; "Compensatory Days"; Decimal)
        {
        }
        field(33; "Payroll No."; Code[20])
        {
        }
        field(34; Ecosystem; Code[20])
        {
        }
        field(35; "Office Code"; Code[20])
        {
        }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
        // field(38; "Approver Type"; Enum "Approver Type")
        // {
        //     Editable = false;
        // }
        field(39; Cancelled; Boolean)
        {
        }
        // field(40; "Cancelled No."; Code[20])
        // {
        // }
        // field(41; "Cancelled Document No."; Code[20])
        // {
        //     Editable = false;
        // }
        // field(42; "Screener ID"; Code[20])
        // {
        //     Editable = false;

        //     trigger OnValidate()
        //     begin
        //         if EmployeeRec.Get("Screener ID") then
        //             Validate("Screener Name", EmployeeRec."Full Name")
        //         else
        //             Clear("Screener Name");
        //     end;
        // }
        // field(43; "Screener Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(44; "Screener Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(45; "Final Approver"; Code[20])
        // {
        //     Editable = false;
        //     TableRelation = Employee;

        //     trigger OnValidate()
        //     begin
        //         if EmployeeRec.Get("Final Approver") then
        //             Validate("Final Approver Name", EmployeeRec."Full Name")
        //         else
        //             Clear("Final Approver Name");
        //     end;
        // }
        // field(46; "Final Approver Name"; Text[50])
        // {
        //     Description = 'S';
        //     Editable = false;
        // }
        // field(47; "Final Approver Date"; Date)
        // {
        //     Editable = false;
        // }
        field(48; "Reason Code"; Code[20])
        {
            TableRelation = "Standard Text" WHERE("Employee Activity Type" = FIELD(Type));

            trigger OnValidate()
            begin
                if Standardtext.Get("Reason Code") then
                    Validate("Reason Description", Standardtext.Description)
                else
                    Clear("Reason Description");
            end;
        }
        field(49; "Reason Description"; Text[50])
        {
        }
        field(50; Description; Text[250])
        {
        }
        field(51; "Screener Remarks"; Text[100])
        {
        }
        field(52; "Transfer Type"; Enum "Transfer Type")
        {
            trigger OnValidate()
            begin
                if "Transfer Type" in ["Transfer Type"::"Intra Branch", "Transfer Type"::"Intra Department", "Transfer Type"::"Intra Provincial"] then begin //Min >>
                    "Deputation On (To)" := "Deputation On";
                    "Shortcut Dimension 1 Code (To)" := "Shortcut Dimension 1 Code";
                    "Sub Province Code (To)" := "Sub Province Code";
                    "Department Code (To)" := Department;
                    "Province Code (To)" := "Province Code";
                    "Unit (To)" := "Unit Code";
                    GetTransferName;
                end;
                if "Transfer Type" in ["Transfer Type"::"Inter Branch", "Transfer Type"::"Inter Department", "Transfer Type"::"Inter Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                    GetTransferName;
                end;
                if "Transfer Type" = "Transfer Type"::"Cross Transfer" then
                    "Deputation On (To)" := "Deputation On (To)"::" ";
                //Min >>
            end;
        }
        field(53; "Shortcut Dimension 1 Code (To)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Description = 'Transfer';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                if "Shortcut Dimension 1 Code (To)" <> xRec."Shortcut Dimension 1 Code (To)" then begin
                    GLSetup.Get;
                    if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code (To)") then begin
                        "Province Code (To)" := DimValue.Province;
                        "Sub Province Code (To)" := DimValue."Sub-Province";
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
            end;
        }
        field(54; "Sub Province Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Sub Province".Code;

            trigger OnValidate()
            begin
                if "Sub Province Code (To)" <> xRec."Sub Province Code (To)" then begin
                    SubProvinceVar.Reset;
                    SubProvinceVar.SetRange(Code, "Sub Province Code (To)");
                    if SubProvinceVar.FindFirst then begin
                        "Province Code (To)" := SubProvinceVar."Province Code";
                        "Shortcut Dimension 1 Code (To)" := '';
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
            end;
        }
        field(55; "Province Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Province;

            trigger OnValidate()
            begin
                if "Province Code (To)" <> xRec."Province Code (To)" then begin
                    if ProvinceVar.Get("Province Code (To)") then begin
                        "Sub Province Code (To)" := '';
                        "Shortcut Dimension 1 Code (To)" := '';
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
            end;
        }
        field(56; "Unit (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST(Unit));

            trigger OnValidate()
            begin
                if "Unit (To)" <> xRec."Unit (To)" then begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    EmpHie.SetRange(Code, "Unit (To)");
                    if EmpHie.FindFirst then
                        "Department Code (To)" := EmpHie."Department Code"
                    else
                        "Department Code (To)" := '';
                    if DepartVar.Get("Department Code (To)") then
                        "Province Code (To)" := DepartVar."Province Code"
                    else
                        "Province Code (To)" := '';
                    "Sub Province Code (To)" := '';
                    "Shortcut Dimension 1 Code (To)" := '';
                    "Extension Counter (To)" := '';
                end;
            end;
        }
        field(57; "Department Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Department;

            trigger OnValidate()
            begin
                if "Department Code (To)" <> xRec."Department Code (To)" then begin
                    if DepartVar.Get("Department Code (To)") then begin
                        "Province Code (To)" := DepartVar."Province Code";
                        "Sub Province Code (To)" := '';
                        "Unit (To)" := '';
                        "Shortcut Dimension 1 Code (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
            end;
        }
        field(58; "Reporting Line 1 (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST("Reporting Line 1"));
        }
        field(59; "Reporting Line 2 (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST("Reporting Line 2"));
        }
        field(60; "Eco-System (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST("Eco-System"));
        }
        field(61; "Office (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Employee Hierarchy Master" WHERE(Type = CONST(Office));
        }
        field(62; "Extension Counter (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));

            trigger OnValidate()
            begin
                if "Extension Counter (To)" <> xRec."Extension Counter (To)" then begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    EmpHie.SetRange(Code, "Extension Counter (To)");
                    if EmpHie.FindFirst then
                        "Shortcut Dimension 1 Code (To)" := EmpHie."Shortcut Dimension 1 Code"
                    else
                        "Shortcut Dimension 1 Code (To)" := '';
                    GLSetup.Get;
                    if DimValue.Get(GLSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code (To)") then;
                    "Province Code (To)" := DimValue.Province;
                    "Sub Province Code (To)" := DimValue."Sub-Province";
                    "Department Code (To)" := '';
                    "Unit (To)" := '';
                end;
            end;
        }
        field(63; "Transfer Effective Date"; Date)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if Type in [Type::"HR Transfer", Type::"Employee Transfer"] then begin //Min -- Control for not apply transfer eff. date less than today.
                    if "Transfer Effective Date" < Today then
                        Error(Text001, Today);
                end;
            end;
        }
        field(64; "Functional Title (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Functional Title";
        }
        field(65; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(66; "Deputation On (To)"; Enum "Deputation Type")
        {
            trigger OnValidate()
            begin
                if "Deputation On (To)" <> xRec."Deputation On (To)" then begin
                    Clear("Shortcut Dimension 1 Code (To)");
                    Clear("Department Code (To)");
                    Clear("Unit (To)");
                    Clear("Functional Title (To)");
                    Clear("Province Code (To)");
                    Clear("Sub Province Code (To)");
                    Clear("Extension Counter (To)");
                end;
            end;
        }
        field(67; "Relocation Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if GuiAllowed then
                    if "Relocation Allow." > xRec."Relocation Allow." then
                        Error('Invalid Amount.');
            end;
        }
        field(68; "Outstation/Discomfort Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if GuiAllowed then
                    if "Outstation/Discomfort Allow." > xRec."Outstation/Discomfort Allow." then
                        Error('Invalid Amount.');
            end;
        }
        field(69; "BM Accomodation Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if GuiAllowed then
                    if "BM Accomodation Allow." > xRec."BM Accomodation Allow." then
                        Error('Invalid Amount.');
            end;
        }
        field(70; "Remote Area Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if GuiAllowed then
                    if "Remote Area Allow." > xRec."Remote Area Allow." then
                        Error('Invalid Amount.');
            end;
        }
        field(71; "Officiating Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if GuiAllowed then
                    if "Officiating Allow." > xRec."Officiating Allow." then
                        Error('Invalid Amount.');
            end;
        }
        field(72; "Relocation Distance"; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                TransferMgt.CalculateAllowance(Rec);
            end;
        }
        field(73; "Outstation Distance"; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                TransferMgt.CalculateAllowance(Rec);
            end;
        }
        field(74; "BMAF Distance"; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                TransferMgt.CalculateAllowance(Rec);
            end;
        }
        // field(75; "Transfer Allowance Approval"; Enum "Transfer Allowance Approval")
        // {
        //     Description = 'Transfer';
        // }
        // field(76; "Transfer Claim Recommender"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;
        // }
        field(77; "Outgoing Branch Rep. Person"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Outgoing Branch Rep. Person" <> '' then begin //Min 12.13.2022
                    EmployeeRec.Get("Outgoing Branch Rep. Person");
                    if SalaryLevel.Get("Salary Level Code") then;
                    if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                    if SalaryLevel.Rank >= SalaryLevel1.Rank then
                        Error('Salary level of Outgoing Branch Person (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
                end;
            end;
        }
        // field(78; "Transfer Claim Reviewer"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = Employee;
        // }
        field(79; "Acknowledged Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        // field(80; "Transfer Claim Reviewer Name"; Text[30])
        // {
        //     CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Transfer Claim Reviewer")));
        //     Description = 'Transfer';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(81; "Outgoing Reporting Person Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Outgoing Branch Rep. Person")));
            Description = 'Transfer';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(82; Reviewer; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = Employee;

        //     trigger OnValidate()
        //     begin
        //         if EmpVar.Get(Reviewer) then
        //             Validate("Reviewer Name", EmpVar."Full Name")
        //         else
        //             Clear("Reviewer Name");
        //     end;
        // }
        // field(83; "Reviewer Name"; Text[50])
        // {
        //     Description = 'Transfer';
        //     Editable = false;
        // }
        field(84; "Incoming Supervisior"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Incoming Supervisior" <> '' then begin //Min 12.13.2022
                    EmployeeRec.Get("Incoming Supervisior");
                    if SalaryLevel.Get("Salary Level Code") then;
                    if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                    if SalaryLevel.Rank >= SalaryLevel1.Rank then
                        Error('Salary level of Incoming Supervisior (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
                end;
                if EmpVar.Get("Incoming Supervisior") then
                    Validate("Incoming Supervisior Name", EmpVar."Full Name")
                else
                    Clear("Incoming Supervisior Name");
            end;
        }
        field(85; "Incoming Supervisior Name"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        // field(86; "Reviewer Remarks"; Text[50])
        // {
        // }
        field(87; "Reason for Transfer"; Text[100])
        {
            Description = 'Transfer';
        }
        field(88; "Date of Joining Of Transfer"; Date)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                TestField("Transfer Effective Date");
                if "Date of Joining Of Transfer" < "Transfer Effective Date" then
                    Error('Date of joining of transfer %1 cannot be less than HR Proposed date %2', "Date of Joining Of Transfer", "Transfer Effective Date");
            end;
        }
        field(89; "Transfer Remarks"; Text[50])
        {
            Description = 'Transfer';
        }
        field(90; "Temporary Address"; Text[65])
        {
        }
        field(91; "Temporary Province"; Text[30])
        {
        }
        field(92; "Temporary District"; Text[30])
        {
        }
        field(93; "Notify to"; Text[200])
        {
            Description = 'Transfer';
            TableRelation = Employee where(Status = filter("Employee Status"::Active));

            // trigger OnLookup()
            // begin
            //     Validate("Notify to", HRMgt.ReturnSelectedEmployeeCode("Notify to"));
            // end;

            // trigger OnValidate()
            // begin
            //     if StrPos("Notify to", ',') <> 0 then
            //         Error('Please use ";" instead of ","');
            // end;
        }
        field(94; "Transfer Category"; Enum "Transfer Category")
        {
            Description = 'Transfer';
            trigger OnValidate()
            begin
                if Type in [Type::"Employee Transfer", Type::"HR Transfer"] then begin
                    if xRec."Transfer Category" <> "Transfer Category" then begin
                        Clear("Start Date");
                        Clear("End Date");
                        if "No." <> '' then
                            InsertAttachmentLines;
                    end;
                end;
            end;
        }
        field(95; "Curr. Placement Period(Month)"; Decimal)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(96; "Reason For Hold"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(97; "On Hold Date"; Date)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "On Hold Date" <> 0D then
                    Validate("Transfer Effective Date", "On Hold Date")
            end;
        }
        field(98; "Reason For Cancel"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(99; "Cancelled Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(100; Status; text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(101; "Transfer Propose Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Is Transfer Details Added"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Transfer Request No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(104; "Transfer Claim"; Boolean)
        {
            Editable = false;
        }

        field(198; "From Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        field(199; "To Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        // field(200; "Transf. Claim Recomm. Remarks"; Text[50])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(201; "Transf. Claim Reviewer Remarks"; Text[50])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(202; "Transf. Claim Approver Remarks"; Text[50])
        // {
        //     DataClassification = ToBeClassified;
        // }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Start Date")
        {
        }
    }
    trigger OnInsert()
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                NoSeriesMgt.InitSeries(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of

                    //change in employee
                    Type::"Changes in employee":
                        begin
                            HRSetup.TestField("Employee Change No. Series");
                            NoSeriesMgt.InitSeries(HRSetup."Employee Change No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;
                    //for transfer
                    Type::"Employee Transfer", Type::"HR Transfer", Type::"Transfer Claim":
                        begin
                            HRSetup.TestField("Transfer No.");
                            NoSeriesMgt.InitSeries(HRSetup."Transfer No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type);
                            //"Temporary Address" := HRMgt.GetEmployeeNo; //Min 7.14.2022
                            //"Temporary District" := HRMgt.GetEmpName; //Min 7.14.2022
                        end;
                end;
            end;
        InsertAttachmentLines;
    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
        ApprovalEntry: Record "Approval HRMS";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
        end;
    end;


    local procedure InsertAttachmentLines()
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        case Type of
            Type::"Employee Transfer", Type::"HR Transfer":
                begin
                    IncomingDocument.Reset;
                    IncomingDocument.SetRange("Table ID", DATABASE::"Employee/HR Transfer");
                    IncomingDocument.SetRange("No.", "No.");
                    IncomingDocument.DeleteAll(true);
                    AttachmentMandatory.Reset;
                    AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::Transfer);
                    AttachmentMandatory.SetRange("Transfer Category", "Transfer Category");
                    if AttachmentMandatory.FindFirst then
                        repeat
                            Clear(IncomingDocument);
                            IncomingDocument.Reset;
                            IncomingDocument.SetRange("Table ID", DATABASE::"Employee/HR Transfer");
                            IncomingDocument.SetRange("No.", "No.");
                            IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                            if not IncomingDocument.FindFirst then begin
                                IncomingDocument.Reset;
                                IncomingDocument.Init;
                                IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                                IncomingDocument.Description := Rec.TableName;
                                IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                                IncomingDocument."No." := "No.";
                                IncomingDocument."Employee Code" := "Employee No.";
                                IncomingDocument."Table ID" := DATABASE::"Employee/HR Transfer";
                                if Type = Type::"Employee Transfer" then
                                    IncomingDocument."Employee Activity Type" := IncomingDocument."Employee Activity Type"::"Employee Transfer"
                                else if Type = Type::"HR Transfer" then
                                    IncomingDocument."Employee Activity Type" := IncomingDocument."Employee Activity Type"::"HR Transfer";

                                IncomingDocument.Insert(true);
                            end;
                        until AttachmentMandatory.Next = 0;
                end;
        end;
    end;

    local procedure ValidateTransfer()
    begin
        if not (Type in [Type::"Employee Transfer", Type::"HR Transfer"]) then
            exit;

        if EmpVar.Get("Employee No.") then begin
            /* VALIDATE("Deputation On (To)",EmpVar."Deputation on");
             VALIDATE("Province Code (To)", EmpVar."Province Code");
             VALIDATE("Sub Province Code (To)", EmpVar."Sub Province Code");
             VALIDATE("Shortcut Dimension 1 Code (To)",EmpVar."Global Dimension 1 Code");
             VALIDATE("Department Code (To)",EmpVar."Department Code");
             VALIDATE("Unit (To)", EmpVar."Unit Code");
             VALIDATE("Reporting Line 1 (To)", EmpVar."Reporting Line 1");
             VALIDATE("Reporting Line 2 (To)", EmpVar."Reporting Line 2");
             VALIDATE("Eco-System (To)", EmpVar."Eco-System");
             VALIDATE("Extension Counter (To)",EmpVar."Extension Counter Code");
             VALIDATE("Office (To)", EmpVar.Office);
             VALIDATE("Functional Title (To)", EmpVar."Functional Title");*/
            EmpVar.TestField("Employment Date");
            if EmpVar."Last Placement Date" <> 0D then
                Validate("Curr. Placement Period(Month)", Round((Today - EmpVar."Last Placement Date") / 30, 0.01, '='))
            else
                Validate("Curr. Placement Period(Month)", Round((Today - EmpVar."Employment Date") / 30, 0.01, '='));
            CheckForTransfer;
        end;

    end;

    local procedure CheckForTransfer()
    begin
        "Employee Tranfer".Reset;
        "Employee Tranfer".SetRange("Employee No.", "Employee No.");
        "Employee Tranfer".SetRange(Type, "Employee Tranfer".Type::"HR Transfer");
        "Employee Tranfer".SetFilter("No.", '<>%1', "No.");
        // "Employee Tranfer".SetFilter("Approval Status", '<>%1&<>%2&<>%3', "Approval Status"::Acknowledged, "Approval Status"::Cancelled, "Approval Status"::Rejected);
        "Employee Tranfer".SetFilter("Approval Status", '%1', "Approval Status"::Pending);
        if "Employee Tranfer".FindFirst then
            Error('Transfer for employee %1 (%2) is still pending. Please check the transfer no. %3', "Employee Tranfer"."Employee Name", "Employee Tranfer"."Employee No.", "Employee Tranfer"."No.");
    end;

    local procedure GetTransferName()
    var
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DepartVar: Record Department;
        ProvinceVar: Record Province;
        SubProvinceVar: Record "Sub Province";
        EmpHie: Record "Employee Hierarchy Master";
    begin
        Clear(BranchName);
        Clear(BranchNameTo);
        Clear(DepartmentNameTo);
        Clear(DepartmentName);
        Clear(ProvinceName);
        Clear(ProvinceNameTo);
        Clear(SubProvinceName);
        Clear(SubProvinceNameTo);
        Clear(UnitNameTo);
        Clear(UnitName);
        Clear(ExtensionName);
        Clear(ExtensionNameTo);
        GLSetup.Get;
        if FunctionalTitle.Get("Functional Title") then
            FunctionalDescFrom := FunctionalTitle.Description;
        if FunctionalTitle.Get("Functional Title (To)") then
            FunctionalDescTo := FunctionalTitle.Description;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
            BranchName := DimValue.Name;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code (To)") then
            BranchNameTo := DimValue.Name;

        if DepartVar.Get(Department) then
            DepartmentName := DepartVar.Name;

        if DepartVar.Get("Department Code (To)") then
            DepartmentNameTo := DepartVar.Name;

        if ProvinceVar.Get("Province Code") then
            ProvinceName := ProvinceVar.Description;

        if ProvinceVar.Get("Province Code (To)") then
            ProvinceNameTo := ProvinceVar.Description;

        SubProvinceVar.Reset;
        SubProvinceVar.SetRange(Code, "Sub Province Code");
        if SubProvinceVar.FindFirst then
            SubProvinceName := SubProvinceVar.City;

        SubProvinceVar.Reset;
        SubProvinceVar.SetRange(Code, "Sub Province Code (To)");
        if SubProvinceVar.FindFirst then
            SubProvinceNameTo := SubProvinceVar.City;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::Unit);
        EmpHie.SetRange(Code, "Unit Code");
        if EmpHie.FindFirst then
            UnitName := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::Unit);
        EmpHie.SetRange(Code, "Unit (To)");
        if EmpHie.FindFirst then
            UnitNameTo := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        EmpHie.SetRange(Code, "Extension Counter Code");
        if EmpHie.FindFirst then
            ExtensionName := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        EmpHie.SetRange(Code, "Extension Counter (To)");
        if EmpHie.FindFirst then
            ExtensionNameTo := EmpHie.Description;
    end;

    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        // HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        // LeaveTypeVar: Record "Leave Type Setup";
        // WorkShift: Record "Employee Work Shift";
        SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        "Employee Tranfer": Record "Employee/HR Transfer";
        SalaryLevel1: Record "Salary Level";
        EmployeeRec: Record Employee;
        // INVALID: Label 'Invalid %1';
        // EmpRelative: Record "Employee Relative";
        // SystemAccessControl: Record "System Access Control";
        // AccessControlLine: Record "Access Control Request Line";
        ProvinceVar: Record Province;
        SubProvinceVar: Record "Sub Province";
        DepartVar: Record Department;
        EmpHie: Record "Employee Hierarchy Master";
        Standardtext: Record "Standard Text";
        BranchNameTo: Text;
        DepartmentNameTo: Text;
        ProvinceNameTo: Text;
        SubProvinceNameTo: Text;
        ExtensionNameTo: Text;
        UnitNameTo: Text;
        BranchName: Text;
        DepartmentName: Text;
        ProvinceName: Text;
        SubProvinceName: Text;
        ExtensionName: Text;
        UnitName: Text;
        FunctionalTitle: Record "Functional Title";
        FunctionalDescFrom: Text;
        FunctionalDescTo: Text;
        //EmpAttendanceActivity: Record "Employee Attendance & Activity";
        //LeaveError: Label 'You cannot apply leave in Present day %1.';
        // EmpActivityRec: Record "Employee Activity";
        Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
        //Text002: Label 'Compensatory leave has been restricted in HRMS.';
        //EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        //PayrollGenSetup: Record "Payroll General Setup";
        //SalaryLevelRec: Record "Salary Level";
        //SalaryGrade: Record "Salary Grade";
        // EncashmentPeriodSetup: Record "OT Encashment Setup";
        Error1: Label 'Cannot apply before your employment date.';
}
