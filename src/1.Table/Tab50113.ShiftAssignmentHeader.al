table 50113 "Shift Assignment Header"
{
    Caption = 'Shift Assignment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
        }
        field(3; "Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Deputation Type';
        }
        field(4; "Deputation Code"; Code[20])
        {
            Caption = 'Deputation Code';
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if OrganizationStructureList.Get("Deputation Type", "Deputation Code") then
                    Validate("Deputation Name", OrganizationStructureList.Name);
            end;
        }
        field(5; "Deputation Name"; Text[100])
        {
            Caption = 'Deputation Name';
            Editable = false;
        }
        field(6; "From Date"; Date)
        {
            Caption = 'From Date';
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
            end;
        }
        field(7; "To Date"; Date)
        {
            Caption = 'To Date';
            trigger OnValidate()
            begin
                if "From date" > "To Date" then
                    Error('Invalid date.');
                if GuiAllowed then
                    CheckForExistingDate("No.");
            end;
        }
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(9; Return; Boolean)
        {
            Caption = 'Return';
        }
        field(10; "Fiscal Year"; Text[10])
        {
            Caption = 'Fiscal Year';
        }
        field(11; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            trigger OnValidate()
            begin
                Employee.Reset();
                If Employee.Get("Employee No.") then begin
                    Validate("Employee Name", Employee."Full Name");
                    Validate("Deputation Type", Employee."Deputation on");
                    Validate("Deputation Code", Employee."Deputation on Code");
                end;
            end;
        }
        field(12; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(13; "Rejection Remarks"; Text[100])
        {
            Caption = 'Rejection Remarks';
        }
        field(14; "Deputation Sub Type"; Enum "Deputation Type")
        {
            ValuesAllowed = " ", Unit, "Extension Counter", "Sub-Unit";
            trigger OnValidate()
            begin
                TestField("Deputation Type");
                if ("Deputation Type" = "Deputation Type"::Branch) and (("Deputation Sub Type" = "Deputation Sub Type"::Unit) or ("Deputation Sub Type" = "Deputation Sub Type"::"Sub-Unit")) then
                    Error('Deputation Sub Type cannot be Unit or Sub-Unit for Branch.');
                if ("Deputation Type" = "Deputation Type"::Department) and ("Deputation Sub Type" = "Deputation Sub Type"::"Extension Counter") then
                    Error('Deputation Sub Type cannot be Extension Counter for Department.');
                if "Deputation Sub Type" <> xRec."Deputation Sub Type" then begin
                    "Deputation Sub Type Code" := '';
                    "Deputation Sub Type Name" := '';
                    ShiftLine.Reset;
                    ShiftLine.SetRange("No.", "No.");
                    ShiftLine.DeleteAll(true);
                end;
            end;
        }
        field(15; "Deputation Sub Type Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Deputation Sub Type" = filter("Deputation Type"::unit)) "Organization Structure Line"."Reporting Code" where(Type = Filter("Deputation Type"::Department), Code = field("Deputation Code"), "Reporting Type" = filter("Deputation Type"::unit))
            else if ("Deputation Sub Type" = filter("Deputation Type"::"Extension Counter")) "Organization Structure Line"."Reporting Code" where(Type = Filter("Deputation Type"::"Branch"), Code = field("Deputation Code"), "Reporting Type" = filter("Deputation Type"::"Extension Counter"))
            else if ("Deputation Sub Type" = filter("Deputation Type"::"Sub-Unit")) "Organization Structure Line"."Reporting Code" where(Type = Filter("Deputation Type"::unit), Code = field("Deputation Code"), "Reporting Type" = filter("Deputation Type"::"Sub-Unit"));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if OrganizationStructureList.Get("Deputation Sub Type", "Deputation Sub Type Code") then
                    Validate("Deputation Sub Type Name", OrganizationStructureList.Name);
            end;
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;
        }
        field(17; "Deputation Sub Type Name"; Text[100])
        {
            Caption = 'Deputation Sub Type Name';
            Editable = false;
        }
        field(37; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
            Editable = false;
        }
        field(100; Status; Text[20])
        {
            Caption = 'Status';
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ShiftLine.Reset;
            ShiftLine.SetRange("No.", "No.");
            ShiftLine.DeleteAll(true);
            ApprovalHrms.Reset;
            ApprovalHrms.SetRange("Document No.", "No.");
            ApprovalHrms.DeleteAll(true);
        end;
    end;

    trigger OnInsert()
    begin
        "Type" := "Type"::"Shift Assignment";
        if not GuiAllowed then begin
            Validate("Employee No.", HrMgt.GetEmployeeNo());
            Validate("Approval Status", "Approval Status"::Open);
        end;
        // TestField(Code);
        // if not GuiAllowed then
        //     CheckForSameWeek;
        HRSetup.Get;
        if "No." = '' then
            case "Type" of
                //for Roster
                "Type"::"Shift Assignment":
                    begin
                        HRSetup.TestField("Shift Assignment Series");
                        NoSeriesMgt.InitSeries(HRSetup."Shift Assignment Series", xRec."No. Series", Today, "No.", "No. Series");
                        ApproverMgt.InsertApproval("Employee No.", "No.", "Type", "Approval Status");
                    end;
            end;
        if not GuiAllowed then
            if Type = Type::"Shift Assignment" then
                CheckForExistingDate("No.");
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalHRMS: Record "Approval HRMS";
        ShiftLine: Record "Shift Line";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";
        Employee: Record Employee;


    procedure CheckForExistingDate(No: Code[20])
    var
        ShiftAssignment: Record "Shift Assignment Header";
    begin
        ShiftAssignment.Reset;
        if GuiAllowed then
            ShiftAssignment.SetFilter("No.", '<>%1', No);
        ShiftAssignment.SetRange(Type, ShiftAssignment.Type::"Shift Assignment");
        ShiftAssignment.SetRange("Fiscal Year", "Fiscal Year");
        ShiftAssignment.SetRange("Deputation Code", "Deputation Code");
        if "Deputation Sub Type" in [ShiftAssignment."Deputation Sub Type"::"Extension Counter", ShiftAssignment."Deputation Sub Type"::Unit] then
            ShiftAssignment.SetRange("Deputation Sub Type Code", "Deputation Sub Type Code");
        ShiftAssignment.SetFilter("Approval Status", '<>%1&<>%2', ShiftAssignment."Approval Status"::Rejected, ShiftAssignment."Approval Status"::Canceled);
        if ShiftAssignment.Findset then
            repeat
                if ("From Date" <= ShiftAssignment."TO date") and ("To date" >= ShiftAssignment."From Date") then
                    Error('Shift Assignment for this period %1 and %2 is already been assigned in %3.', ShiftAssignment."From Date", ShiftAssignment."To Date", ShiftAssignment."No.");
            until ShiftAssignment.Next() = 0;
    end;

}
