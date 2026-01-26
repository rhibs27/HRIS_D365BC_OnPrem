table 50103 "Overtime Line"
{
    Caption = 'Overtime Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
            Editable = false;
        }
        field(4; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            Editable = false;
            TableRelation = if ("Deputation Type" = filter("Branchwise/Extension Type"::Branch)) Employee."No." where("Branch Code" = field(Code))
            else if ("Deputation Type" = filter("Branchwise/Extension Type"::Branch)) Employee."No." where("Extension Counter Code" = field(Code));
            trigger OnValidate()
            begin

                if Employee.Get("Employee Code") then begin
                    "Employee Name" := Employee."Full Name";
                    Validate("Staff Type", Employee."Staff level");
                    Validate("Employee Work Shift", Employee."Employee Work Shift");
                    Validate("Deputation Type", Employee."Deputation on");
                    Validate(Code, Employee."Deputation On Code");
                end else
                    "Employee Name" := '';
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(6; "Overtime Date"; Date)
        {
            Caption = 'Overtime Date';
            Editable = false;
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
        field(9; "Overtime Date (BS)"; Text[20])
        {
            Caption = 'Overtime Date (BS)';
            Editable = false;
        }
        field(10; "Check In Time"; Time)
        {
            Caption = 'Check In Time';
            Editable = false;
        }
        field(11; "Check Out Time"; Time)
        {
            Caption = 'Check Out Time';
            Editable = false;
        }
        field(12; "Overtime Claim Type"; Enum "Overtime Claim Type")
        {
            Caption = 'Overtime Claim Type';
            Editable = false;
        }
        field(13; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            Editable = false;
        }
        field(14; "Staff Type"; Enum "Staff Type")
        {
            Caption = 'Staff Type';
            Editable = false;
        }
        field(15; "Time Duration"; Duration)
        {
            Caption = 'Time Duration';
            Editable = false;
        }
        field(16; "Actual OT hours"; Decimal)
        {
            Caption = 'Actual OT hours';
            trigger OnValidate()
            begin
                if "Actual OT hours" > "Total OT Hours" then
                    Error('Actual OT hours cannot be greater than Total OT Hours.');
            end;
        }
        field(18; "Morning OT Hours"; Decimal)
        {
            Caption = 'Morning OT Hours';
            Editable = false;
        }
        field(19; "Evening OT Hours"; Decimal)
        {
            Caption = 'Evening OT Hours';
            Editable = false;
        }
        field(20; "Total OT Hours"; Decimal)
        {
            Caption = 'Total OT Hours';
            Editable = false;
            trigger OnValidate()
            begin
                Validate("Actual OT hours", "Total OT Hours");
            end;
        }
        field(21; "OT Amount"; Decimal)
        {
            Caption = 'OT Amount';
            Editable = false;
        }
        field(22; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
        field(24; "Code"; Code[20])
        {
            Editable = false;
            Caption = 'Code';
            TableRelation = if ("Deputation Type" = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Branch), Blocked = filter(false))
            else if ("Deputation Type" = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure List".Code where(Type = Filter("Deputation Type"::"Extension Counter"), Blocked = filter(false));
            trigger OnValidate()
            begin
                Clear(Name);
                if "Deputation Type" = "Deputation Type"::Branch then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Code) then
                        Name := OrganizationStructureList.Name;
                end else if "Deputation Type" = "Deputation Type"::"Extension Counter" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Code) then
                        Name := OrganizationStructureList.Name;
                end;
            end;
        }
        field(25; Name; Text[100])
        {
            Editable = false;
        }
        field(26; "Deputation Type"; Enum "Deputation Type")
        {
            Editable = false;
        }
        field(27; "Day Type"; Enum "Day Type")
        {
            Editable = false;
        }
        field(28; "OverNight Shift"; Boolean)
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        OrganizationStructureList: Record "Organization Structure List";
        Employee: Record Employee;
}
