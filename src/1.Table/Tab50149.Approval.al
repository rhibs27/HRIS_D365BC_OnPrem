table 50149 Approval
{
    Caption = 'Approval';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(2; "Document Type"; Enum "Employee Activity Type")
        {
            Caption = 'Document Type';
        }
        field(3; "Approver No"; Code[20])
        {
            Caption = 'Approver No';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.get("Approver No") then
                    Validate("Approver Name", Employee."Full Name");
            end;
        }
        field(4; "Approver Name"; Text[100])
        {
            Caption = 'Approver Name';
            Editable = false;
        }
        field(5; "Approval Status"; Enum "Employee Act. Approval Status")
        {
            Caption = 'Approval Status';
        }
        field(6; "Approval Sequence"; Integer)
        {
            Caption = 'Approval Sequence';
        }
        // field(7; "Entry No."; Integer)
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(7; "Line No"; Integer)
        // {
        //     Caption = 'Line No';
        //     Editable = false;
        // }
        field(8; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
    }

    keys
    {
        key(PK; "Document No.", "Approver No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        Approval: Record Approval;
    begin
        // Approval.Reset();
        // if Approval.FindLast() then
        //     "Entry No." := Approval."Entry No." + 1
        // else
        //     "Entry No." := 1;
    end;
}