table 50075 "FA Transfer Register"
{
    DataClassification = CustomerContent;
    // version NAVW16.00.01,FA1.0,Remit1.00

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "FA No."; Code[20]) { }
        field(3; Date; DateTime) { }
        field(4; "From Location Code"; Code[20]) { }
        field(5; "To Location Code"; Code[20]) { }
        field(6; Reason; Text[100]) { }
        field(7; Remarks; Text[100]) { }
        field(8; "From Responsible Emp"; Code[20]) { }
        field(9; "To Responsible Emp"; Code[20]) { }
        field(10; "User ID"; Code[50]) { }
        field(11; Description; Text[50])
        {
            CalcFormula = lookup("FA Location".Name where(Code = field("From Location Code")));
            FieldClass = FlowField;
        }
        field(12; "To Description"; Text[50])
        {
            CalcFormula = lookup("FA Location".Name where(Code = field("To Location Code")));
            FieldClass = FlowField;
        }
        field(13; "From Emp Description"; Text[30])
        {
            CalcFormula = lookup(Employee."Full Name" where("No." = field("From Responsible Emp")));
            FieldClass = FlowField;
        }
        field(14; "To Emp Description"; Text[30])
        {
            CalcFormula = lookup(Employee."Full Name" where("No." = field("To Responsible Emp")));
            FieldClass = FlowField;
        }
        field(15; "FA Description"; Text[30]) { }
        field(16; "FA Description2"; Text[30]) { }
    }

    keys
    {
        key(Key1; "No.", "FA No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

        "User ID" := UserId;
    end;
}
