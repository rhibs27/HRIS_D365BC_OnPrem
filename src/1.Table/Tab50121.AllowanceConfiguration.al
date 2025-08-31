table 50121 "Allowance Configuration"
{
    Caption = 'Allowance Configuration';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Payroll Attribute"; Code[20])
        {
            Caption = 'Payroll Attribute';
            TableRelation = "Payroll Attributes";
            trigger OnValidate()
            begin
                if PayrollAttributes.Get("Payroll Attribute") then
                    Description := PayrollAttributes.Description
                else
                    Description := '';
            end;
        }
        field(3; "Employment Type"; Enum "Employee Type")
        {
            Caption = 'Employment Type';
        }
        field(4; "Employee Work Shift"; Code[20])
        {
            Caption = 'Employee Work Shift';
            TableRelation = "Employee Work Shift";
        }
        field(5; "Salary Level"; Code[20])
        {
            Caption = 'Salary Level';
            TableRelation = "Salary Level";
        }
        field(6; "Province Code"; Code[20])
        {
            Caption = 'Province Code';
            TableRelation = "Organization Structure List".Code where(Type = const(Province));
        }
        field(7; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
        }
        field(8; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(10; Description; Text[50])
        {
            Editable = false;
        }
        field(11; "Approver Role"; Code[20])
        {
            TableRelation = "Approval Role";
        }
        field(12; "Min Service Yr. Eligibility"; Decimal)
        {

        }
        field(13; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(14; "Earning Cycle"; Enum "Encashment Period")
        {

        }
        field(15; "ATM Site"; Option)
        {
            OptionMembers = " ","On-Site","Off-Site";
        }
    }
    keys
    {
        key(PK; "Entry No.", "Payroll Attribute")
        {
            Clustered = true;
        }

    }
    trigger OnInsert()
    begin
        "Entry No." := GetNextEntryNo();
    end;

    var
        PayrollAttributes: Record "Payroll Attributes";

    local procedure GetNextEntryNo(): Integer
    var
        AllowanceConfig: Record "Allowance Configuration";
    begin
        AllowanceConfig.SetLoadFields();
        if AllowanceConfig.FindLast() then
            exit(AllowanceConfig."Entry No." + 1)
        else
            exit(1);
    end;
}
