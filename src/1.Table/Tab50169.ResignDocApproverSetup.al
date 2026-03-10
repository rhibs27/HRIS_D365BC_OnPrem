table 50169 "Resign Doc Approver Setup"
{
    Caption = 'Resign Doc Approver Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Approver Code"; Code[20])
        {
            Caption = 'Approver Code';
        }
        field(20; "Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Deputation Type';
        }
        field(21; "Deputation Sub Type"; Enum "Deputation Type")
        {
            Caption = 'Deputation Sub Type';
        }
        field(30; "Deputation Code"; Code[20])
        {
            Caption = 'Deputation Code';
            TableRelation = "Organization Structure List".Code where(Type = field("Deputation Type"), Blocked = const(false));
        }
        field(31; "Sub Deputation Code"; Code[20])
        {
            Caption = 'Sub Deputation Code';
            TableRelation = "Organization Structure List".Code where(Type = field("Deputation Type"), Code = field("Deputation Code"));
        }
        field(40; "Approver Role"; Code[20])
        {
            Caption = 'Approver Role';
            TableRelation = "Approval Role".Code;
            trigger OnValidate()
            begin
                if not "Same Deputation Approver" then begin
                    TestField("Approver Deputation Type");
                    TestField("Approver Deputation Code");
                end;
            end;
        }
        field(50; "Functional Title"; Code[20])
        {
            Caption = 'Functional Title';
            TableRelation = "Functional Title";
        }
        field(60; "Approver Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Approver Deputation Type';
        }
        field(61; "Approver Deputation Sub Type"; Enum "Deputation Type")
        {
            Caption = 'Approver Deputation Sub Type';
        }
        field(70; "Approver Deputation Code"; Code[20])
        {
            Caption = 'Approver Deputation Code';
            TableRelation = "Organization Structure List".Code where(Type = field("Approver Deputation Type"), Blocked = const(false));
            trigger OnValidate()
            begin
                Clear("Same Deputation Approver");
            end;
        }
        field(71; "Approver Sub Deputation Code"; Code[20])
        {
            Caption = 'Approver Sub Deputation Code';
            TableRelation = "Organization Structure Line".Code where(Type = field("Approver Deputation Type"), Code = field("Approver Deputation Code"));
            trigger OnValidate()
            begin
                Clear("Same Deputation Approver");
            end;
        }
        field(80; "Same Deputation Approver"; Boolean)
        {
            Caption = 'Same Deputation Approver';
            trigger OnValidate()
            begin
                TestField("Approver Deputation Type", "Approver Deputation Type"::" ");
                TestField("Approver Deputation Code", '');
            end;

        }
        field(90; "Approver Sequence"; Integer)
        {
            Caption = 'Approver Sequence';
        }
        field(100; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
            TableRelation = Employee."No." where(Status = filter("Employee Status"::Active));
            trigger OnValidate()
            begin
                TestField("Approver Role", '');
            end;
        }
        field(110; "Emp Act Type"; Enum "Employee Activity Type")
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
