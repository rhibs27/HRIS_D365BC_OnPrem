table 50118 "Shift Line"
{
    Caption = 'Shift Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
            Editable = false;
        }
        field(3; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
        }
        field(4; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
            TableRelation = if ("Deputation Type" = filter("Deputation Type"::Branch)) Employee."No." where("Deputation On Code" = field("Deputation Code"))
            else if ("Deputation Type" = filter("Deputation Type"::Department)) Employee."No." where("Deputation On Code" = field("Deputation Code"))
            else if ("Deputation Type" = filter("Deputation Type"::Unit)) Employee."No." where("Unit Code" = field("Deputation Code"))
            else if ("Deputation Type" = filter("Deputation Type"::"Extension Counter")) Employee."No." where("Extension Counter Code" = field("Deputation Code"));
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.get("Employee No") then begin
                    Validate("Employee Name", Employee."Full Name");
                end;
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(6; "Roster Date"; Date)
        {
            Caption = 'Roster Date';
            trigger OnValidate()
            begin
                ValidateShiftDate();
            end;
        }
        field(7; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
            Editable = false;
        }
        field(8; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;
        }
        field(9; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift" where("Deputation Code" = field("Deputation Code"));
            trigger OnValidate()
            var
            begin
                TestField("Employee Work Shift");
            end;
        }
        field(10; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
        field(11; "Deputation Code"; Code[20])
        {
            Editable = false;
            Caption = 'Code';
            trigger OnValidate()
            begin
                Clear("Deputation Name");
                if OrganizationStructureList.Get("Deputation Type", "Deputation Code") then
                    "Deputation Name" := OrganizationStructureList.Name
            end;
        }
        field(12; "Deputation Name"; Text[100])
        {
            Editable = false;
        }
        field(13; "Deputation Type"; Enum "Deputation Type")
        {
            Editable = false;
        }
        field(14; "Substitute Type"; Enum "Allowance Substitute")
        {
            InitValue = '';
            Editable = false;
        }
        field(15; "Substitute of Line No."; Integer)
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.", "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Validate("Approval Status", "Approval Status"::Open);

    end;

    var
        OrganizationStructureList: Record "Organization Structure List";
        Employee: Record Employee;

        ShiftMgn: Codeunit "Shift Assignment Mgt";


    local procedure ValidateShiftDate()
    var
        ShiftLine: Record "Shift Line";
        ShiftAssignmentHeader: Record "Shift Assignment Header";
    begin
        if ("Employee No" = '') or ("Roster Date" = 0D) then
            exit;
        if not ShiftAssignmentHeader.Get("No.") then
            Error('Shift Assignment Header %1 does not exist', "No.");
        ShiftAssignmentHeader.TestField("From Date");
        ShiftAssignmentHeader.TestField("To Date");
        if ("Roster Date" < ShiftAssignmentHeader."From Date") or ("Roster Date" > ShiftAssignmentHeader."To Date") then
            Error('Roster Date %1 is not within the allowed period %2 to %3', "Roster Date", ShiftAssignmentHeader."From Date", ShiftAssignmentHeader."To Date");
        ShiftLine.Reset();
        ShiftLine.SetRange(Type, ShiftLine.Type::"Shift Assignment");
        ShiftLine.SetRange("No.", "No.");
        ShiftLine.SetRange("Employee No", "Employee No");
        ShiftLine.SetRange("Roster Date", "Roster Date");
        ShiftLine.SetFilter("Line No", '<>%1', "Line No");
        if ShiftLine.FindFirst() then
            Error('Employee %1 is already scheduled on %2 at Line No. %3', "Employee No", "Roster Date", ShiftLine."Line No");
    end;
}
