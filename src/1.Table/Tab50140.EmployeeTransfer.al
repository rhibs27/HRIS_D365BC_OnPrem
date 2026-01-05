table 50140 "Employee Transfer"
{
    Caption = 'Employee Transfer';
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
        field(2; Type; Enum "Employee Activity Type") { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate("From Branch", EmpVar."Branch Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Province Name", EmpVar."Province Name");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Unit Name", EmpVar."Unit Name");
                    Validate("Extension Counter Name", EmpVar."Extension Counter Name");
                    Validate("Deputation On", EmpVar."Deputation on");
                    Validate("Deputation on Code", EmpVar."Deputation On Code");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Salary Level Name", EmpVar."Salary Level Description");
                    Validate("Functional Title", EmpVar."Functional Title");
                    Validate("Functional Title Desc", EmpVar."Functional Title Desc");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Approver Role From", EmpVar."Approver Role");
                    ValidateTransfer();
                end else begin
                    Clear("Employee Name");
                    Validate("Shortcut Dimension 1 Code", '');
                    Validate(Department, '');
                    Validate("Salary Level Code", '');
                end;
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Posted; Boolean) { }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Start Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Start Date (BS)", EngNepDate.getNepaliDate("Start Date"));
                HRMgt.CheckEligibilityBeforeEmploymentDate("Start Date", "Employee No.");
                if "Start Date" <> xRec."Start Date" then begin
                    Clear("End Date");
                    Clear("End Date (BS)");
                    Validate("No. of Days", 0);
                end;
            end;
        }
        field(8; "End Date"; Date)
        {
            trigger OnValidate()
            var
                TravelMgt: Codeunit "Travel Mgt.";
            begin
                Validate("End Date (BS)", EngNepDate.getNepaliDate("End Date"));
                if "End Date" <> 0D then
                    Validate("No. of Days", TravelMgt.CalculateNoOfDaysTravel("Start Date", "End Date"))
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
                Validate("Fiscal Year", HrMgt.ReturnFiscalYear("Requested Date"));
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
        field(14; Remarks; Text[100]) { }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status") { }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
        }
        field(18; Department; Code[20])
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
        field(21; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(22; "Unit Name"; Text[50])
        {
            Editable = false;
        }
        field(23; "Extension Counter Name"; Text[50])
        {
            Editable = false;
        }
        field(24; "Employee Work Shift"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(26; "Province Name"; Text[50])
        {
            Editable = false;
        }
        field(27; "Functional Title Desc"; Text[100])
        {
            Editable = false;
        }
        field(28; "Extension Counter Code"; Code[20]) { }
        field(30; "Province Code"; Code[20]) { }
        field(31; "Unit Code"; Code[20]) { }
        field(32; "Compensatory Days"; Decimal) { }
        field(33; "Payroll No."; Code[20]) { }
        field(34; "Extension Name To"; Text[50]) { }
        field(35; "Functional Desc To"; Text[100])
        {
            Editable = false;
        }
        field(36; "Rejection Remarks"; Text[100]) { }
        field(37; "Approved Date"; Date) { }
        field(38; "Branch Name To"; Text[50])
        {
            Editable = false;
        }
        field(39; Cancelled; Boolean) { }
        // field(40; "Cancelled No."; Code[20])
        // {
        // }
        // field(41; "Cancelled Document No."; Code[20])
        // {
        //     Editable = false;
        // }
        field(42; "Department Name To"; text[50])
        {
            Editable = false;
        }
        field(43; "Province Name To"; Text[50])
        {
            Editable = false;
        }
        field(44; "Unit Name To"; Text[50])
        {
            Editable = false;
        }
        field(45; Handover; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(46; "Deputation on Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Deputation on Code To"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
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
        field(49; "Reason Description"; Text[50]) { }
        field(50; Description; Text[250]) { }
        field(51; "Screener Remarks"; Text[100]) { }
        field(52; "Transfer Type"; Enum "Transfer Type")
        {
            trigger OnValidate()
            begin
                if "Transfer Type" in ["Transfer Type"::"Intra Branch", "Transfer Type"::"Intra Department", "Transfer Type"::"Intra Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                    "Shortcut Dimension 1 Code (To)" := "Shortcut Dimension 1 Code";
                    "Department Code (To)" := Department;
                    "Province Code (To)" := "Province Code";
                    "Unit (To)" := "Unit Code";
                end;
                if "Transfer Type" in ["Transfer Type"::"Inter Branch", "Transfer Type"::"Inter Department", "Transfer Type"::"Inter Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                end;
            end;
        }
        field(53; "Shortcut Dimension 1 Code (To)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if "Shortcut Dimension 1 Code (To)" <> xRec."Shortcut Dimension 1 Code (To)" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, OrganizationStructureList.Code) then begin
                        "Province Code (To)" := OrganizationStructureList."Province Code";
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
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if "Deputation on (To)" = "Deputation on (To)"::Province then begin
                    "Department Code (To)" := '';
                    "Unit (To)" := '';
                    "Extension Counter (To)" := '';
                    Clear("Branch Name To");
                    Clear("To Branch");
                    ValidateDeputationOnTo()
                end else begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Province Code (To)") then
                        Validate("Province Name To", OrganizationStructureList.Name)
                    else
                        Clear("Province Name");
                end;
            end;
        }
        field(56; "Unit (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Department), Code = field("Department Code (To)"), "Reporting Type" = filter("Deputation Type"::Unit));
            trigger OnValidate()
            begin
                if "Unit (To)" <> xRec."Unit (To)" then begin
                    Clear("Unit Name To");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, "Unit (To)") then begin
                        "Extension Name To" := '';
                        "Unit Name To" := OrganizationStructureList.Name;
                        "Shortcut Dimension 1 Code (To)" := '';
                    end;
                end;
            end;
        }
        field(57; "Department Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            trigger OnValidate()
            begin
                if "Department Code (To)" <> xRec."Department Code (To)" then begin
                    "Unit (To)" := '';
                    "Unit Name To" := '';
                    "Shortcut Dimension 1 Code (To)" := '';
                    "Extension Counter (To)" := '';
                    Clear("Province Code (To)");
                    Clear("Province Name To");
                    Clear("Department Name To");
                    ValidateDeputationOnTo();
                end;
            end;
        }
        field(58; Takeover; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(59; "Approver Role From"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60; "Approver Role To"; Code[20])
        {
            TableRelation = "Approval Role";
            DataClassification = ToBeClassified;
        }
        field(62; "Extension Counter (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Organization Structure line"."Reporting Code" where(Type = filter("Deputation Type"::Branch), Code = field("To Branch"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if "Extension Counter (To)" <> xRec."Extension Counter (To)" then begin
                    Clear("Extension Name To");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Extension Counter (To)") then begin
                        "Extension Name To" := OrganizationStructureList.Name;
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Shortcut Dimension 1 Code (To)" := '';
                    end;
                end;
            end;
        }
        field(63; "Transfer Effective Date"; Date)
        {
            Description = 'Transfer';
            trigger OnValidate()
            begin
                if Type in [Type::"HR Transfer", Type::"Employee Transfer"] then begin
                    if "Transfer Effective Date" < Today then
                        Error(Text001, Today);
                end;
            end;
        }
        field(64; "Functional Title (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Functional Title";
            trigger OnValidate()
            begin
                if "Functional Title (To)" <> xRec."Functional Title (To)" then
                    Clear("Functional Desc To");
                if FunctionalTitle.Get(Rec."Functional Title (To)") then
                    "Functional Desc To" := FunctionalTitle.Description;
            end;
        }
        field(65; "Deputation On"; Enum "Deputation Type") { }
        field(66; "Deputation On (To)"; Enum "Deputation Type")
        {
            ValuesAllowed = Branch, Province, Department;
            trigger OnValidate()
            begin
                if "Deputation On (To)" <> xRec."Deputation On (To)" then begin
                    Clear("Shortcut Dimension 1 Code (To)");
                    Clear("Department Code (To)");
                    Clear("Department Name To");
                    Clear("Unit (To)");
                    Clear("Unit Name To");
                    Clear("Functional Title (To)");
                    Clear("Province Code (To)");
                    Clear("Extension Counter (To)");
                    Clear("Extension Name To");
                    Clear("Province Name To");
                    Clear("Functional Desc To");
                    Clear("Branch Name To");
                    Clear("To Branch");
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
        field(77; "Outgoing Branch Rep. Person"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            trigger OnValidate()
            begin
                if "Outgoing Branch Rep. Person" <> '' then begin
                    EmployeeRec.Get("Outgoing Branch Rep. Person");
                    "Outgoing Reporting Person Name" := EmployeeRec."Full Name";
                end else
                    Clear("Outgoing Reporting Person Name");
                if "Outgoing Branch Rep. Person" = "Employee No." then
                    Error('Cannot Select Yourself as Outgoing Reporting person');
            end;
        }
        field(79; "Acknowledged Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(81; "Outgoing Reporting Person Name"; Text[100])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(84; "Incoming Supervisior"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            trigger OnValidate()
            begin
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
        field(89; "Transfer Remarks"; Text[250])
        {
            Description = 'Transfer';
        }
        field(90; "Temporary Address"; Text[150]) { }
        field(91; "Temporary Province"; Text[50]) { }
        field(92; "Temporary District"; Text[50]) { }
        field(93; "Notify to"; Text[200])
        {
            Description = 'Transfer';
            TableRelation = Employee where(Status = filter("Employee Status"::Active));
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
            Editable = false;
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
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
        }
        field(199; "To Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            trigger OnValidate()
            begin
                Clear("Extension Counter (To)");
                Clear("Extension Name To");
                Clear("Branch Name To");
                Clear("Province Code (To)");
                Clear("Province Name To");
                ValidateDeputationOnTo();
            end;
        }
        field(200; "Requested Province"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            begin
                if "Requested Province" <> xRec."Requested Province" then begin
                    Clear("Requested Province Name");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Requested Province") then
                        Validate("Requested Province Name", OrganizationStructureList.Name)
                    else
                        Clear("Requested Province Name");
                end;
            end;
        }
        field(201; "Requested Province Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(202; "Salary Level Name"; Text[100])
        {
            Editable = false;
        }
        field(203; "Requested Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            trigger OnValidate()
            begin
                Clear("Requested Branch Name");
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Requested Branch") then
                    Validate("Requested Branch Name", OrganizationStructureList.Name)
                else
                    Clear("Requested Branch Name");
            end;
        }
        field(204; "Requested Branch Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(205; "Requested Province 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            begin
                if "Requested Province 2" <> xRec."Requested Province 2" then begin
                    Clear("Requested Province Name 2");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Requested Province 2") then
                        Validate("Requested Province Name 2", OrganizationStructureList.Name)
                    else
                        Clear("Requested Province Name 2");
                end;
            end;
        }
        field(206; "Requested Province Name 2"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(207; "Requested Branch 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            trigger OnValidate()
            begin
                Clear("Requested Branch Name 2");
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Requested Branch 2") then
                    Validate("Requested Branch Name 2", OrganizationStructureList.Name)
                else
                    Clear("Requested Branch Name 2");
            end;
        }
        field(208; "Requested Branch Name 2"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(209; "Requested Province 3"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Province), Blocked = filter(false));
            trigger OnValidate()
            begin
                if "Requested Province 3" <> xRec."Requested Province 3" then begin
                    Clear("Requested Province Name 3");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Requested Province 3") then
                        Validate("Requested Province Name 3", OrganizationStructureList.Name)
                    else
                        Clear("Requested Province Name 3");
                end;
            end;
        }
        field(210; "Requested Province Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(211; "Requested Branch 3"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Organization Structure List".Code WHERE(Type = filter("Deputation Type"::Branch), Blocked = filter(false));
            trigger OnValidate()
            begin
                Clear("Requested Branch Name 3");
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Requested Branch 3") then
                    Validate("Requested Branch Name 3", OrganizationStructureList.Name)
                else
                    Clear("Requested Branch Name 3");
            end;
        }
        field(212; "Requested Branch Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(300; "Incoming Supervisior 2"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            trigger OnValidate()
            begin
                if EmpVar.Get("Incoming Supervisior 2") then
                    Validate("Incoming Supervisior Name 2", EmpVar."Full Name")
                else
                    Clear("Incoming Supervisior Name 2");
            end;
        }
        field(301; "Incoming Supervisior Name 2"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(302; "Outgoing Branch Rep. Person 2"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee."No." where(status = const("Employee Status"::Active));
            trigger OnValidate()
            begin
                if "Outgoing Branch Rep. Person 2" <> '' then begin
                    EmployeeRec.Get("Outgoing Branch Rep. Person 2");
                    "Outgoing Rep. Person Name 2" := EmployeeRec."Full Name";
                end else
                    Clear("Outgoing Rep. Person Name 2");
                if "Outgoing Branch Rep. Person 2" = "Employee No." then
                    Error('Cannot Select Yourself as Outgoing Reporting person');
            end;
        }
        field(303; "Outgoing Rep. Person Name 2"; Text[100])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(304; "Departure Date"; Date)
        {
            Description = 'Transfer. It is checked while doing takeover process.';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Start Date") { }
    }
    trigger OnInsert()
    begin
        if (not GuiAllowed) and (type = Type::"Transfer Claim") then begin
            if "Employee No." = '' then
                if not HrMgt.IsSaaS() then
                    Validate("Employee No.", HRMgt.GetEmployeeNo());
        end;
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                HRMgt.InitNoSeriesNew(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of
                    //for transfer
                    Type::"Employee Transfer", Type::"HR Transfer", Type::"Transfer Claim":
                        begin
                            HRSetup.TestField("Transfer No.");
                            HRMgt.InitNoSeriesNew(HRSetup."Transfer No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            EmployeeTransfer.ReadIsolation(IsolationLevel::ReadCommitted);
                            EmployeeTransfer.SetLoadFields("No.");
                            while EmployeeTransfer.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                            if Type <> type::"HR Transfer" then
                                ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");
                        end;
                end;
            end;
        if (not GuiAllowed) and (type = Type::"Transfer Claim") then
            if EmployeeTransfer.Get("Transfer Request No") then begin
                EmployeeTransfer."Transfer Claim" := true;
                EmployeeTransfer.Modify();
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
                    IncomingDocument.SetRange("Table ID", DATABASE::"Employee Transfer");
                    IncomingDocument.SetRange("No.", "No.");
                    IncomingDocument.DeleteAll(true);
                    AttachmentMandatory.Reset;
                    AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::"Employee Transfer");
                    // AttachmentMandatory.SetRange("Transfer Category", "Transfer Category");
                    if AttachmentMandatory.FindFirst then
                        repeat
                            Clear(IncomingDocument);
                            IncomingDocument.Reset;
                            IncomingDocument.SetRange("Table ID", DATABASE::"Employee Transfer");
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
                                IncomingDocument."Table ID" := DATABASE::"Employee Transfer";
                                if Type = Type::"Employee Transfer" then
                                    IncomingDocument."Employee Activity Type" := IncomingDocument."Employee Activity Type"::"Employee Transfer"
                                else if Type = Type::"HR Transfer" then
                                    IncomingDocument."Employee Activity Type" := IncomingDocument."Employee Activity Type"::"HR Transfer";
                                IncomingDocument.Insert(true);
                            end;
                        until AttachmentMandatory.Next = 0;
                end;
            Type::"Transfer Claim":
                begin
                    if GuiAllowed then begin
                        IncomingDocument.Reset;
                        IncomingDocument.SetRange("No.", "No.");
                        IncomingDocument.DeleteAll(true);
                        AttachmentMandatory.Reset;
                        AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::"Transfer Claim");
                        if AttachmentMandatory.FindFirst then
                            repeat
                                Clear(IncomingDocument);
                                IncomingDocument.Reset;
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
                                    IncomingDocument."Table ID" := DATABASE::"Employee Transfer";
                                    IncomingDocument."Employee Activity Type" := IncomingDocument."Employee Activity Type"::"Transfer Claim";
                                    IncomingDocument.Insert(true);
                                end;
                            until AttachmentMandatory.Next = 0;
                    end;
                end;
        end;
    end;

    local procedure ValidateTransfer()
    begin
        if not (Type in [Type::"Employee Transfer", Type::"HR Transfer"]) then
            exit;
        if EmpVar.Get("Employee No.") then begin
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
        "Employee Tranfer".SetFilter("Approval Status", '%1', "Approval Status"::Pending);
        if "Employee Tranfer".FindFirst then
            Error('Transfer for employee %1 (%2) is still pending. Please check the transfer no. %3', "Employee Tranfer"."Employee Name", "Employee Tranfer"."Employee No.", "Employee Tranfer"."No.");
    end;

    local procedure ValidateDeputationOnTo();
    var
        OrganizationStructureLine: Record "Organization Structure line";
        OrganizationStructureList: Record "Organization Structure List";
    begin
        TestField("Deputation On (To)");
        case "Deputation on (To)" of
            "Deputation on"::Branch:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "TO Branch") then begin
                    Validate("Deputation On Code To", OrganizationStructureList.Code);
                    Validate("Branch Name To", OrganizationStructureList.Name);
                    OrganizationStructureLine.Reset();
                    OrganizationStructureLine.SetRange("Reporting Type", OrganizationStructureLine.Type::Branch);
                    OrganizationStructureLine.SetRange("Reporting Code", "TO Branch");
                    if OrganizationStructureLine.FindFirst() then
                        Validate("Province Code (To)", OrganizationStructureLine.Code);
                end;
            "Deputation on"::Department:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Department Code (To)") then begin
                    Validate("Deputation On Code To", OrganizationStructureList.Code);
                    Validate("Department Name To", OrganizationStructureList.Name);
                    OrganizationStructureLine.Reset();
                    OrganizationStructureLine.SetRange("Reporting Type", OrganizationStructureLine.Type::Department);
                    OrganizationStructureLine.SetRange("Reporting Code", "Department Code (To)");
                    if OrganizationStructureLine.FindFirst() then
                        Validate("Province Code (To)", OrganizationStructureLine.Code);
                end;
            "Deputation on"::Province:
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Province Code (to)") then begin
                    Validate("Deputation On Code To", OrganizationStructureList.Code);
                    Validate("Province Name To", OrganizationStructureList."Province Name");
                end;
        end;
    end;

    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        EmployeeTransfer: Record "Employee Transfer";
        TransferMgt: Codeunit "Transfer Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        "Employee Tranfer": Record "Employee Transfer";
        EmployeeRec: Record Employee;
        OrganizationStructureList: Record "Organization Structure List";
        Standardtext: Record "Standard Text";
        FunctionalTitle: Record "Functional Title";
        Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
}
