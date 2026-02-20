table 50074 "Employee Edit"
{
    Caption = 'Employee Edit';
    DataClassification = ToBeClassified;
    //Field 1,2,16,37 100 are used in ApprovalMgt Codeunit as field Ref << Santosh 3.25.2025
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(HRSetup."Employee Change No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type")
        {
            Editable = false;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
            Editable = false;
            Description = 'Employee Details';
        }
        field(4; "Mobile No."; Text[30])
        {
            Caption = 'Mobile No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                // Check if the Phone No contains only digits
                if not TypeHelper.IsPhoneNumber("Mobile No.") then
                    Error('Phone number must only contain numeric characters.');
            end;
        }
        field(5; "Marital Status"; Enum "Marital Status")
        {
            Caption = 'Marital Status';
            DataClassification = CustomerContent;
        }
        field(6; "Email (Personal)"; Text[80])
        {
            Caption = 'Email (Personal)';
            DataClassification = CustomerContent;
        }
        // Offical Document Changes
        field(7; "Passport No."; Code[20])
        {
            Caption = 'Passport No.';
            Description = 'Official Document';
            DataClassification = CustomerContent;
        }
        field(8; "Differently Able"; Boolean)
        {
            Caption = 'Differently Able';
        }
        field(9; "Vehicle Type"; Enum "Vehicle Type")
        {
            Caption = 'Vehicle Type';
        }
        field(15; "Blood Group"; Enum "Blood Group")
        {
            Caption = 'Blood Group';
            DataClassification = CustomerContent;
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = false;
        }
        field(17; "Requested Date"; Date)
        {
            Editable = false;
        }
        field(18; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if Employee.get("Employee No.") then begin
                    Validate("Employee Name", Employee."Full Name");
                end;
            end;
        }
        field(19; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; "Changes In Employee Type"; Enum "Employee Edit Type")
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                case "Changes In Employee Type" of
                    "Changes In Employee Type"::Qualification:
                        begin
                            Validate("Emp Document Type", "Emp Document Type"::Education);
                        end;
                    "Changes In Employee Type"::"Work Experience":
                        begin
                            Validate("Emp Document Type", "Emp Document Type"::Work);
                        end;
                    "Changes In Employee Type"::Achievement:
                        begin
                            Validate("Emp Document Type", "Emp Document Type"::Achievement);
                        end
                end;
            end;
        }
        field(21; Attachment; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Rejection Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        //Employee Qualification and work experience << santosh 3.28.2025
        field(23; "Qualification Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
        }
        field(24; Description; Code[100])
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
        }
        field(25; "Institution/Company"; Code[100])
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
        }
        field(26; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Qualification';
            trigger OnValidate()
            begin
                if Percentage < 0 then
                    Error('Percentage cannot be negative');
                if Percentage > 100 then
                    Error('Percentage cannot be greater than 100');
            end;
        }
        field(27; Stream; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'example- Science, Management etc.';
        }
        field(28; Year; Text[4])
        {
            DataClassification = CustomerContent;
            Description = 'Date of Completion of particular study';
            CharAllowed = '09';
            trigger OnValidate()
            var
                Date: Integer;
            begin
                Evaluate(Date, year);
                if Date > Date2DMY(Today, 3) then
                    Error('Date is in Future');
            end;
        }
        field(29; Designation; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Time Period"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(31; Remuneration; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Contact Number"; Text[30])
        { DataClassification = CustomerContent; }
        field(33; Remarks; Text[250])
        { DataClassification = CustomerContent; }
        field(34; Rank; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(35; "Qualification Type"; Enum "Qualification Type")
        {
            DataClassification = CustomerContent;
        }
        field(36; CGPA; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(37; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(38; "Emp Document Type"; Enum "Emp. Document Type")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(39; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "CitizenShip No."; Code[50])
        {
            Caption = 'CitizenShip No.';
            Description = 'Official Document';
            DataClassification = CustomerContent;
        }
        field(42; "CitizenShip Issue Date"; Date)
        {
            Caption = 'CitizenShip Issue Date';
            Description = 'Official Document';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                If "CitizenShip Issue Date" > Today then
                    Error('CitizenShip Issue Date(AD) should not be a future.');
            end;
        }
        field(43; "NID No."; Code[20])
        {
            Caption = 'NID No.';
            Description = 'Official Document';
            DataClassification = CustomerContent;
        }
        field(44; "Driving License No."; Code[20])
        {
            Caption = 'Driving License No.';
            Description = 'Official Document';
            DataClassification = CustomerContent;
        }
        //Changes In relative
        field(45; "Relative Code"; Code[10])
        {
            Caption = 'Relative Code';
            Description = 'Employee Relative';
            DataClassification = CustomerContent;
            TableRelation = Relative;
        }
        field(46; "Full Name"; Code[30])
        {
            Caption = 'Full Name';
            Description = 'Employee Relative';
            DataClassification = CustomerContent;
        }
        field(47; "Relative Phone No."; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(48; "Employee Relative In Bank"; Enum "Employee/BOD Relation")
        {
            Description = 'Employee Relatives';
            Caption = 'Employee Relative In Bank';
            DataClassification = CustomerContent;
        }
        field(49; "Relative's Employee No."; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative Employee No.';
            DataClassification = CustomerContent;
        }
        field(50; "Relative CitizenShip No."; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative CitizenShip No.';
            DataClassification = CustomerContent;
        }
        field(51; "Relative District"; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative District';
            DataClassification = CustomerContent;
        }
        field(52; "Relative VDC/Municipality"; Code[20])
        {
            Description = 'Employee Relatives';
            Caption = 'Relative VDC/Municipality';
            DataClassification = CustomerContent;
        }
        field(53; "Ward No."; Integer)
        {
            Description = 'Employee Relatives';
            Caption = 'Relative Ward No.';
            MinValue = 1;
            MaxValue = 32;
            DataClassification = CustomerContent;
        }
        // Language Proficiency
        field(54; Language; Code[20])
        {
            Caption = 'Language';
            Description = 'Language Proficiency';
            TableRelation = Language;
            DataClassification = CustomerContent;
        }
        field(55; Reading; Integer)
        {
            Caption = 'Reading';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(56; Writing; Integer)
        {
            Caption = 'Writing';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(57; Speaking; Integer)
        {
            Caption = 'Speaking';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(58; Typing; Integer)
        {
            Caption = 'Typing';
            Description = 'Language Proficiency';
            DataClassification = CustomerContent;
        }
        field(59; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
            Description = 'Employee Relative';
            DataClassification = CustomerContent;
        }
        field(60; "Religion"; Enum Religion)
        {
            Caption = 'Religion';
            DataClassification = CustomerContent;
        }
        field(64; "Set Emergency Contact"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Relative Mail"; Text[80])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Relative Mail");
            end;
        }
        field(66; "Set Nominee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //vehicle info for employee
        field(69; "Vehicle No."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Vehicle Owner Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(71; "Ownership Start/End Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EngNep: Record "English-Nepali Date";
            begin
                if "Ownership Start/End Date" <> 0D then begin
                    if "Ownership Start/End Date" > WorkDate() then
                        Error('Ownership Start/End Date cannot be future date.');
                    "Ownership Start/End Date (B.S)" := EngNep.getNepaliDate("Ownership Start/End Date");
                end;
            end;
        }

        //employee marital info update
        field(72; "Spouse Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(73; "Spouse DOB"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(74; "Spouse citizenship No."; text[30])
        {
            DataClassification = CustomerContent;
        }
        field(75; "Spouse Citiz. Issued Place"; text[50])
        {
            trigger OnValidate()
            begin
                if (Rec."Spouse Citiz. Issued Place" <> xRec."Spouse Citiz. Issued Place") and ("Spouse Citiz. Issued Place" <> '') then
                    HRMgt.CheckDistrictName("Spouse Citiz. Issued Place");
            end;

            trigger OnLookup()
            begin
                Validate("Spouse Citiz. Issued Place", HRMgt.LookupAllDistrict());
            end;
        }
        field(76; "Attachment Code"; Code[20])
        {
            Caption = 'Attachment Code';
            Description = 'Attachment Code';
            TableRelation = "Attachment Setup"."Attachment Code";
        }
        field(77; "Citizenship Issued Place"; Text[50])
        {
            Caption = 'Citizenship Issued Place';
            Description = 'Official Document';
        }
        field(78; "Passport Validity Date"; Date)
        {
            Caption = 'Passport Validity Date';
            Description = 'Official Document';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                If "Passport Validity Date" > Today then
                    Error('Passport Validity Date(AD) should not be a future.');
            end;

        }
        field(79; "Claim Type"; Code[20])
        {
            TableRelation = "Payroll Attributes";
            Description = 'transportation claim attribute. It should be updated while selecting the vehicle type.';
            trigger OnValidate()
            var
                PayrollAttr: Record "Payroll Attributes";
            begin
                if PayrollAttr.Get("Claim Type") then begin
                    if not (PayrollAttr."Specific Attributes" in [PayrollAttr."Specific Attributes"::"Transportation Allowance", PayrollAttr."Specific Attributes"::Reimbursement]) then
                        Error('Claim Type must be of Transportation or Reimbursement type.');
                end;
            end;
        }
        field(80; "Ownership Start/End Date (B.S)"; code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EngNep: Record "English-Nepali Date";
            begin
                if EngNep.getEngDate("Ownership Start/End Date (B.S)") = 0D then
                    Error('Please enter the nepali date in YYYY/MM/DD format.');
                "Ownership Start/End Date" := EngNep.getEngDate("Ownership Start/End Date (B.S)");
            end;
        }
        field(81; "Fuel Type"; Enum "Fuel Type")
        {
            DataClassification = CustomerContent;
        }
        field(82; "Claimed Type Effective Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckIfAllowFutureClaimRequest("Claimed Type Effective Date");
            end;
        }
        field(83; "Claim Type Effective Month"; Enum "Nepali Month")
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                PgSetup: Record "Payroll General Setup";
                PayCyclePeriod: Record "Pay Cycle Period";
            begin
                if "Claim Type Effective Month" = "Claim Type Effective Month"::" " then
                    exit;
                PgSetup.Get();
                PgSetup.TestField("Payroll Fiscal Year Start Date");

                PayCyclePeriod.SetFilter("Start Date", '>=%1', PgSetup."Payroll Fiscal Year Start Date");
                PayCyclePeriod.SetRange("Nepali Month", "Claim Type Effective Month");
                PayCyclePeriod.FindFirst();

                Validate("Claimed Type Effective Date", PayCyclePeriod."Start Date");
            end;
        }
        field(100; "Status"; Text[20])
        {
            Editable = false;
        }
        field(101; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(102; "Deputation on"; Enum "Deputation Type") { }
        field(103; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Province), Blocked = filter(false));
        }
        field(104; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Branch), Blocked = filter(false));
        }
        field(105; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Department), Blocked = filter(false));
        }
        field(106; "Extension Counter Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Branch), Code = field("Branch Code"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"));
        }
        field(107; "Unit Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Department), Code = field("Department Code"), "Reporting Type" = filter("Deputation Type"::unit));
        }
        field(113; "Permanent House"; Text[30]) { }
        field(114; "Permanent Province"; Text[100]) { }
        field(115; "Permanent District"; Text[50]) { }
        field(116; "Permanent VDC"; Text[50]) { }
        field(117; "Permanent Locality"; Text[100]) { }
        field(118; "Permanent Ward No"; Integer) { }
        field(119; "Permanent Address"; Text[60]) { }
        field(120; "Temporary Province"; Text[30]) { }
        field(121; "Temporary District"; Text[30]) { }
        field(122; "Temporary VDC"; Text[50]) { }
        field(123; "Temporary Ward No"; Integer) { }
        field(124; "Temporary Locality"; Text[100]) { }
        field(125; "Temporary House"; Text[30]) { }
        field(126; "Temporary Address"; Text[60]) { }
        field(1000; "Changed Field"; Text[1020])
        {
            Description = 'This field includes the name of fields that are updated from portal';
        }
        field(127; "GPA Scales"; Decimal) { }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(PK2; "Employee No.") { }
    }
    Var
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        NoSeriesMgt: Codeunit "No. Series";
        ApproverMgt: Codeunit "Approver Mgt";
        HrMgt: Codeunit "HR Mgt.";

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
        ApprovalEntry: Record "Approval HRMS";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open, "Approval Status"::Created]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
        end;
    end;

    trigger OnInsert()
    var
        EmployeeEdit: Record "Employee Edit";
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;

        if "Employee No." = '' then
            if not HrMgt.IsSaaS() then
                Validate("Employee No.", HrMgt.GetEmployeeNo());

        Validate(Type, Type::"Employee Edit");

        if not GuiAllowed then
            Validate("Approval Status", "Approval Status"::Pending);
        HRSetup.Get;
        if "No." = '' then
            case Type of
                //change in employee
                Type::"Employee Edit":
                    begin
                        HRSetup.TestField("Employee Change No. Series");
                        HrMgt.InitNoSeriesNew(HRSetup."Employee Change No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        EmployeeEdit.ReadIsolation(IsolationLevel::ReadUncommitted);
                        EmployeeEdit.SetLoadFields("No.");
                        while EmployeeEdit.Get("No.") do
                            "No." := NoSeriesMgt.GetNextNo("No. Series");
                        ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");
                    end;
            end;

        CheckIfWithinAllowancePeriod();
        if not GuiAllowed then
            CheckForVehicleInfoUpdate(Rec);
    end;

    procedure CheckIfWithinAllowancePeriod()
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        if "Changes In Employee Type" <> "Changes In Employee Type"::"Vehicle Info Update" then
            exit;
        PayCyclePeriod.SetFilter("Start Date", '<=%1', "Requested Date");
        PayCyclePeriod.SetFilter("End Date", '>=%1', "Requested Date");
        PayCyclePeriod.FindFirst();
        if PayCyclePeriod."Allowance Start Date" <> 0D then
            if "Requested Date" <= PayCyclePeriod."Allowance Start Date" then
                if "Changes In Employee Type" = "Changes In Employee Type"::"Vehicle Info Update" then
                    Error('Vehicle update can not be requested until %1 for this month', PayCyclePeriod."Allowance Start Date");
        if PayCyclePeriod."Allowance End Date" <> 0D then
            if "Requested Date" >= PayCyclePeriod."Allowance End Date" then
                if "Changes In Employee Type" = "Changes In Employee Type"::"Vehicle Info Update" then
                    Error('Vehicle update can not be requested from %1 for this month', PayCyclePeriod."Allowance End Date");
    end;

    procedure InsertAttachment()
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        if not GuiAllowed then
            exit;
        if "No." = '' then
            exit;

        AttachmentSetup.SetRange(Mandatory, true);
        case "Changes In Employee Type" of
            "Changes In Employee Type"::Qualification:
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Education);
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
                end;
            "Changes In Employee Type"::"Work Experience",
            "Changes In Employee Type"::Achievement:
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Work Experience");
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
                end;
            "Changes In Employee Type"::"Vehicle Info Update":
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Profile");
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Vehicle Info Update");
                end;
            "Changes In Employee Type"::Details:
                begin
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Employee Profile");
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
                end;
        end;
        if AttachmentSetup.FindFirst() then begin
            IncomingDocument.Init();
            IncomingDocument."Employee Activity Type" := Type;
            IncomingDocument."Document No." := "No.";
            IncomingDocument."Attachment Code" := AttachmentSetup."Attachment Code";
            IncomingDocument."Employee Code" := "Employee No.";
            IncomingDocument.Insert(true);
        end;
    end;

    procedure CheckForVehicleInfoUpdate(EmployeeEdit: Record "Employee Edit")
    var
        EmployeeEdit2: Record "Employee Edit";
        AssignmentMemoHeader: Record "Assignment Memo Header";
    begin
        if "Changes In Employee Type" <> "Changes In Employee Type"::"Vehicle Info Update" then
            exit;

        if EmployeeEdit."Approval Status" <> EmployeeEdit."Approval Status"::Pending then
            exit;

        if not GuiAllowed and (EmployeeEdit."Approval Status" = EmployeeEdit."Approval Status"::Pending) then begin
            EmployeeEdit.TestField("Vehicle Type");
            EmployeeEdit.TestField("Claim Type");
            EmployeeEdit.TestField("Claimed Type Effective Date");

            if EmployeeEdit."Vehicle Type" in [EmployeeEdit."Vehicle Type"::" ", EmployeeEdit."Vehicle Type"::"No Vehicle"] then begin
                EmployeeEdit.TestField("Vehicle No.", '');
                EmployeeEdit.TestField("Vehicle Owner Name", '');
            end else begin
                EmployeeEdit.TestField("Vehicle No.");
                EmployeeEdit.TestField("Vehicle Owner Name");
                EmployeeEdit.TestField("Ownership Start/End Date");
                if EmployeeEdit."Vehicle Type" = EmployeeEdit."Vehicle Type"::"Four Wheeler" then
                    EmployeeEdit.TestField("Fuel Type");
            end;
        end;

        //do not allow multiple pending
        EmployeeEdit2.SetRange("Employee No.", EmployeeEdit."Employee No.");
        EmployeeEdit2.SetRange("Changes In Employee Type", EmployeeEdit."Changes In Employee Type");
        EmployeeEdit2.SetRange("Approval Status", EmployeeEdit2."Approval Status"::Pending);
        EmployeeEdit2.SetFilter("No.", '<>%1', EmployeeEdit."No.");
        if not EmployeeEdit2.IsEmpty() then
            Error('There is already a pending Vehicle Info Update request for this employee. Please resolve it before creating a new one.');

        //do not allow if reimbursement is pending
        AssignmentMemoHeader.SetRange("Employee No.", EmployeeEdit."Employee No.");
        AssignmentMemoHeader.SetRange("Activity Type", AssignmentMemoHeader."Activity Type"::"Request Allowance");
        AssignmentMemoHeader.SetRange("Payroll Attribute Code", EmployeeEdit."Claim Type");
        AssignmentMemoHeader.SetRange("Approval Status", AssignmentMemoHeader."Approval Status"::Pending);
        if not AssignmentMemoHeader.IsEmpty() then
            Error('There is a pending reimbursement request for this employee under the selected Claim Type. Please resolve it before creating a new Vehicle Info Update request.');
    end;

    procedure CheckIfAllowFutureClaimRequest(Pdate: Date)
    var
        PGSetup: Record "Payroll General Setup";
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        if Pdate = 0D then
            exit;

        if "Changes In Employee Type" <> "Changes In Employee Type"::"Vehicle Info Update" then
            exit;
        PayCyclePeriod.SetFilter("Start Date", '<=%1', WorkDate());
        PayCyclePeriod.SetFilter("End Date", '>=%1', WorkDate());
        PayCyclePeriod.FindFirst();

        PGSetup.Get();
        if ((not PGSetup."Allow Future Allowance Request") and
            (Pdate > PayCyclePeriod."End Date")) then begin
            if "Claim Type Effective Month" <> "Claim Type Effective Month"::" " then
                Error('Claim Type Effective Month cannot be future month')
            else
                Error('Claimed Type Effective Date cannot be a future date');
        end;
    end;
}
