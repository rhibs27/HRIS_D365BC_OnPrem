table 50169 "Resign Doc Approver Setup"
{
    Caption = 'Resign Doc Approver Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Approver Code"; Code[20])
        {
            Caption = 'Approver Code';
        }
        field(2; "Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Deputation Type';
        }
        field(3; "Deputation Code"; Code[20])
        {
            Caption = 'Deputation Code';
            TableRelation = "Organization Structure List".Code where(Type = field("Deputation Type"));
        }
        field(4; "Approver Role"; Code[20])
        {
            Caption = 'Approver Role';
            TableRelation = "Approval Role".Code;
        }
        field(5; "Functional Title"; Code[20])
        {
            Caption = 'Functional Title';
            TableRelation = "Functional Title";
        }
        field(6; "Approver Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Approver Deputation Type';
        }
        field(7; "Approver Deputation Code"; Code[20])
        {
            Caption = 'Approver Deputation Code';
            TableRelation = "Organization Structure List".Code where(Type = field("Approver Deputation Type"));
            trigger OnValidate()
            begin
                Clear("Same Deputation Approver");
            end;
        }
        field(8; "Same Deputation Approver"; Boolean)
        {
            Caption = 'Same Deputation Approver';
            trigger OnValidate()
            begin
                TestField("Approver Deputation Type", "Approver Deputation Type"::" ");
                TestField("Approver Deputation Code", '');
            end;

        }
        field(9; "Approver Sequence"; Integer)
        {
            Caption = 'Approver Sequence';
        }
        field(10; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
            TableRelation = Employee."No." where("Deputation on" = field("Approver Deputation Type"), "Deputation On Code" = field("Approver Deputation Code"), Status = filter("Employee Status"::Active));
        }
        field(11; "Emp Act Type"; Enum "Employee Activity Type")
        {
            Caption = 'Emp Act Type';
            ValuesAllowed = " ", "Resignation", "Training";
        }
    }
    keys
    {
        key(PK; "Approver Code")
        {
            Clustered = true;
        }
    }
}
