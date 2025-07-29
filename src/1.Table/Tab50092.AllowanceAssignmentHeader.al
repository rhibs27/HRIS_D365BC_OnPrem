table 50092 "Allowance Assignment Header"
{
    DataCaptionFields = "No.", "Code", "From Date", "To date";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    case "Activity Type" of
                        //for Allowance Assignment Header
                        "Activity Type"::"Allowance Assignment":
                            begin
                                NoSeriesMgt.TestManual(HRSetup."Allowance Assignment Series");
                                "No. Series" := '';
                            end;
                    end;
            end;

        }
        field(2; "Activity Type"; Enum "Employee Activity Type")
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = if (Type = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Branch), Blocked = filter(false))
            else if (Type = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure Line"."Reporting Code" where(Type = Filter("Deputation Type"::"Branch"), Code = field("Branch Code"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"));

            trigger OnValidate()
            begin
                // CheckLineExist();
                GLsetup.Get;
                Clear(Name);
                if not GuiAllowed then
                    Employee.Get(HrMgt.GetEmployeeNo())
                else
                    Employee.Get("Employee No.");
                if Type = Type::Branch then begin
                    if Code <> '' then
                        TestField(Code, Employee."Branch Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::"Extension Counter" then begin
                    if Code <> '' then
                        // TestField(Code, Employee."Extension Counter Code");
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Code) then
                            Name := OrganizationStructureList.Name;
                end;
                //GetApprover();
                // CheckForSameWeek;
            end;
        }
        field(3; Name; Text[100])
        {
            Editable = false;
        }
        field(4; "From Date"; Date)
        {
            trigger OnValidate()
            var
                EngNepDate: Record "English-Nepali Date";
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "From Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year")
                else
                    Clear("Fiscal Year");
                if Rec."From Date" <> xRec."From Date" then
                    Clear("To date");
            end;
            // Editable = false;

        }
        field(5; "To date"; Date)
        {
            // Editable = false;

            trigger OnValidate()
            begin
                TestField("From Date");
                if "From Date" > "To date" then
                    Error('Invalid date.');
                if "To date" > "From Date" + 32 then
                    Error('Date range exceed');
                CheckForExistingDate();
            end;
        }
        field(6; "Type"; Enum "Branchwise/Extension Type")
        {
            trigger OnValidate()
            begin
                if Type <> xRec.Type then begin
                    Clear(Code);
                    Clear(Name);
                end;
            end;
        }
        field(7; "Created Date"; Date) { }
        field(8; "Created By"; Code[50]) { }
        field(9; "Last Modified Date"; Date) { }
        field(10; "Last Modified By"; Code[50]) { }

        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; Return; Boolean) { }
        field(15; "Allowance Type Filter"; Code[20])
        {
            TableRelation = "Branchwise/Extension Allowance"."Allowance Type" where(Code = field(Code),
                                                                                     Type = field(Type));
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Editable = true;
            trigger OnValidate()
            var
                AllowanceAssignmentLine: Record "Allowance Assignment Line";
            begin
                if "Approval Status" = "Approval Status"::Pending then begin
                    AllowanceAssignmentLine.Reset();
                    AllowanceAssignmentLine.SetRange("No.", "No.");
                    if not AllowanceAssignmentLine.FindFirst() then
                        Error('Allowance Assignment Line Not Found');
                end;

            end;
        }
        field(19; "Fiscal Year"; text[10])
        {
            trigger OnValidate()
            begin
            end;
        }
        field(20; "Change Approver Remarks"; Text[250]) { }
        field(21; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Only for Portal functionalities.';
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then begin
                    "Branch Code" := Employee."Branch Code";
                    "Employee Name" := Employee."Full Name";
                end;


            end;
        }
        field(22; "Branch Code"; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(24; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(100; "Status"; Text[20])
        {
        }
        field(23; "Rejection Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            AllowanceLine.Reset;
            AllowanceLine.SetRange("No.", "No.");
            AllowanceLine.DeleteAll(true);
            ApprovalHrms.Reset;
            ApprovalHrms.SetRange("Document No.", "No.");
            ApprovalHrms.DeleteAll(true);
        end;
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date" := Today;
        if not GuiAllowed then
            Validate("Employee No.", HrMgt.GetEmployeeNo());
        HRSetup.Get;
        if "No." = '' then
            case "Activity Type" of
                //for AllowanceAssignment
                "Activity Type"::"Allowance Assignment", "Activity Type"::"Allowance Assignment Claim":
                    begin
                        HRSetup.TestField("Allowance Assignment Series");
                        NoSeriesMgt.InitSeries(HRSetup."Allowance Assignment Series", xRec."No. Series", "Created Date", "No.", "No. Series");
                        ApproverMgt.InsertApproval("Employee No.", "No.", "Activity Type", "Approval Status");
                    end;
            end;
    end;

    var
        Employee: Record Employee;
        AllowanceLine: Record "Allowance Assignment Line";
        HrMgt: Codeunit "HR Mgt.";
        ApprovalHrms: Record "Approval HRMS";
        HRSetup: Record "Human Resources Setup";
        OrganizationStructureList: Record "Organization Structure List";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApproverMgt: Codeunit "Approver Mgt";
        // DimensionValue: Record "Dimension Value";
        GLsetup: Record "General Ledger Setup";
        AllowanceHeader: Record "Allowance Assignment Header";

    procedure CheckForExistingDate()
    begin
        AllowanceHeader.Reset;
        AllowanceHeader.SetFilter("No.", '<>%1', "No.");
        AllowanceHeader.SetRange("Fiscal Year", "Fiscal Year");
        if "Activity Type" = "Activity Type"::"Allowance Assignment" then begin
            AllowanceHeader.SetRange("Activity Type", AllowanceHeader."Activity Type"::"Allowance Assignment");
            AllowanceHeader.SetRange(Code, Code);
        end else if "Activity Type" = "Activity Type"::"Allowance Assignment Claim" then begin
            AllowanceHeader.SetRange("Activity Type", AllowanceHeader."Activity Type"::"Allowance Assignment Claim");
            AllowanceHeader.SetRange("Employee No.", "Employee No.")
        end;
        AllowanceHeader.SetFilter("Approval Status", '<>%1', AllowanceHeader."Approval Status"::Rejected);
        if AllowanceHeader.Findset then
            repeat
                if ("From Date" <= AllowanceHeader."To date") and ("To date" >= AllowanceHeader."From Date") then
                    Error('Allowance for this period month %1 and %2 is already been assigned in %3.', "From Date", "To date", AllowanceHeader."No.");
            until AllowanceHeader.Next() = 0;

    end;
}
