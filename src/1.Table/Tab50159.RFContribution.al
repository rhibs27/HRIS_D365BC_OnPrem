table 50159 "RF Contribution"
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
            var
                PayrollGeneralSetup: Record "Payroll General Setup";
            begin
                TestField("Employee No.");

                if Rec.Type <> xRec.Type then begin
                    "Attribute Code" := '';
                    "Pay Cycle Code" := '';
                    "Pay Cycle Term" := '';
                    "Pay Cycle Period" := 0;
                end;

                if Type <> Type::Manual then
                    exit;

                PayrollGeneralSetup.Get();
                "Pay Cycle Code" := PayrollGeneralSetup."Pay Cycle Code";
                "Pay Cycle Term" := PayrollGeneralSetup."Pay Cycle Term";
            end;
        }
        field(6; "Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes".Code where(Subtype = filter(CIT | RF));
            Caption = 'Attribute Code';
            trigger OnValidate()
            var
                RFContr: Record "RF Contribution";
            begin
                if Type = Type::Manual then
                    exit;

                RFContr.SetRange("Document No.", '');
                RFContr.SetRange("Employee No.", "Employee No.");
                RFContr.SetRange("Attribute Code", "Attribute Code");
                if RFContr.FindFirst() then
                    Error('RF Contribution record already exists for Employee %1 and Attribute %2', "Employee No.", "Attribute Code");
            end;
        }
        field(7; "Nepali Month"; Enum "Nepali Month")
        {
            Enabled = false;
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
        field(10; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";
        }
        field(11; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(12; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"), Posted = const(false));
        }
        field(301; "Access Token"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key1; "Access Token")
        {

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
