table 50043 "Team Profile Header"
{
    DataClassification = ToBeClassified;
    Caption = 'Team Profile Header';

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(4; "Employee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Employee Code';
            TableRelation = Employee where(Status = const(Active));
            trigger OnValidate()
            var
                EmployeeRec: Record Employee;
            begin
                if EmployeeRec.Get("Employee Code") then
                    "Employee Name" := EmployeeRec.FullName()
                else
                    "Employee Name" := '';
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Employee Name';
            Editable = false;
        }
        field(6; "Approval Role"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Approval Role';
            TableRelation = "Approval Role";
        }
        field(7; "Block"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Block';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    var
        Employee: Record Employee;
}
