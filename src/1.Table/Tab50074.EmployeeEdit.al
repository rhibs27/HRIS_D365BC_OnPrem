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
        field(3; "Employee Name"; Text[50])
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
        field(6; "Email (Personal)"; Text[50])
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
            trigger OnValidate()
            begin
            end;
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
        field(22; "Rejection Remarks"; Text[50])
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
        field(29; Designation; Text[30])
        { DataClassification = CustomerContent; }
        field(30; "Time Period"; Decimal)
        { DataClassification = CustomerContent; }
        field(31; Remuneration; Decimal)
        { DataClassification = CustomerContent; }
        field(32; "Contact Number"; Text[30])
        { DataClassification = CustomerContent; }
        field(33; Remarks; Text[50])
        { DataClassification = CustomerContent; }
        field(34; Rank; Integer)
        { DataClassification = CustomerContent; }
        field(35; "Qualification Type"; Enum "Qualification Type")
        {
            DataClassification = CustomerContent;
        }
        field(36; CGPA; Decimal)
        {
            DataClassification = CustomerContent;
            MaxValue = 4;
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
        field(65; "Relative Mail"; Text[30])
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
        field(100; "Status"; Text[20])
        {
            Editable = false;
        }
        field(101; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(102; "Deputation on"; Enum "Deputation Type")
        {
        }
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
        field(114; "Permanent Province"; Text[50]) { }
        field(115; "Permanent District"; Text[50]) { }
        field(116; "Permanent VDC"; Text[50]) { }
        field(117; "Permanent Locality"; Text[100]) { }
        field(118; "Permanent Ward No"; Integer) { }
        field(119; "Permanent Address"; Text[60]) { }
        field(120; "Temporary Province"; Text[30])
        {
        }
        field(121; "Temporary District"; Text[30])
        { }
        field(122; "Temporary VDC"; Text[50]) { }
        field(123; "Temporary Ward No"; Integer) { }
        field(124; "Temporary Locality"; Text[100]) { }
        field(125; "Temporary House"; Text[30]) { }
        field(126; "Temporary Address"; Text[60])
        {
        }
        field(1000; "Changed Field"; Text[1020])
        {
            Description = 'This field includes the name of fields that are updated from portal';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(PK2; "Employee No.")
        {
        }
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
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
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
    end;

    Procedure UpdateEmployeeEditLine(EmpEdit: Record "Employee Edit")
    var
        EmpEditLine: Record "Employee Edit Line";
    begin
        if not GuiAllowed then
            exit;
        EmpEditLine.SetRange("Document No.", EmpEdit."No.");
        if EmpEditLine.FindSet() then
            EmpEditLine.ModifyAll("Change in Emp Type", EmpEdit."Changes In Employee Type", false);
    end;
}
