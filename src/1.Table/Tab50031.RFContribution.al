table 50031 "RF Contribution"
{
    Caption = 'RF Contribution';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
            // Caption = 'Employee No.';
            // trigger OnValidate()
            // var
            //     Employee: Record Employee;
            // begin
            //     // if Employee.Get("Employee No.") then
            // end;
        }
        field(4; "Employee Name"; Text[200])
        {
            Caption = 'Employee Name';
        }
        field(5; "Type"; enum "RF Contribution Type")
        {
            Caption = 'Type';
            trigger OnValidate()
            begin
                TestField("Employee No.");
            end;
        }
        field(6; "Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code where(Subtype = filter(CIT | RF));
            Caption = 'Attribute Code';
        }
        field(7; "Nepali Month "; Enum "Nepali Month")
        {
            Caption = 'Nepali Month ';
            trigger OnValidate()
            begin
                TestField(Type, Type::Manual);
            end;
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(9; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure SetEmployee()
    var
    RetirementFund: Record "Retirement Fund";
    begin
       if RetirementFund.Get("Document No.") then begin
           "Employee No." := RetirementFund."Employee No.";   
          "Employee Name" := RetirementFund."Employee Name";
          Type := RetirementFund.Type;
          end;
    end;
    
    trigger OnInsert()
    begin
        SetEmployee();
    end;
}

  

