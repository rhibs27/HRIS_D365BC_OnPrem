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
        }
        field(3; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
        }
        field(4; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(6; "Roster Date"; Date)
        {
            Caption = 'Roster Date';
        }
        field(7; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
        }
        field(8; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
        }
        field(9; "Employee Work Shift"; Code[10])
        {
            Caption = 'Employee Work Shift';
        }
        field(10; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
        field(11; "Code"; Code[20])
        {
            Editable = false;
            Caption = 'Code';
            TableRelation = if ("Deputation Type" = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Organization Structure list"::Branch), Blocked = filter(false))
            else if ("Deputation Type" = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure List".Code where(Type = Filter("Organization Structure list"::"Extension Counter"), Blocked = filter(false));
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
        field(12; Name; Text[100])
        {
            Editable = false;
        }
        field(13; "Deputation Type"; Enum "Deputation Type")
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
    var
        OrganizationStructureList: Record "Organization Structure List";
        Employee: Record Employee;
}
