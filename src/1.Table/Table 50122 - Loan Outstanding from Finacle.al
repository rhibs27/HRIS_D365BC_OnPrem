table 50122 "Loan Outstanding from Finacle"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then
                    Validate("Employee Name", EmpVar."Full Name")
                else
                    Clear("Employee Name");
            end;
        }
        field(2; "Employee Name"; Text[50]) { }
        field(3; "Scheme Type"; Text[30]) { }
        field(4; "Account ID"; Text[30]) { }
        field(5; "Outstanding Amount"; Decimal) { }
        field(6; "Loan Limit"; Decimal) { }
        field(7; EMI; Decimal) { }
        field(8; "Loan Type"; Option)
        {
            OptionCaption = ' ,,Personal Loan,Home Loan,Vehicle Loan,Home Loan Insurance Tieup';
            OptionMembers = " ",,"Personal Loan","Home Loan","Vehicle Loan","Home Loan Insurance Tieup";
        }
        field(9; "Scheme Code"; Text[10])
        {
            trigger OnValidate()
            begin
                case "Scheme Code" of
                    'HLST2':
                        Validate("Loan Type", "Loan Type"::"Home Loan Insurance Tieup");
                    'HLSTF':
                        Validate("Loan Type", "Loan Type"::"Home Loan");
                    'ODSTF':
                        Validate("Loan Type", "Loan Type"::"Personal Loan");
                    'VLST2', 'VLSTF':
                        Validate("Loan Type", "Loan Type"::"Vehicle Loan");
                end;
            end;
        }
        field(10; "Is Manual"; Boolean) { }
        field(11; "Line No."; Integer) { }
        field(12; "Last Modified Date"; Date) { }
    }

    keys
    {
        key(Key1; "Employee No.", "Line No.") { }
    }

    fieldgroups { }

    trigger OnModify()
    begin
        "Last Modified Date" := Today; //Min
    end;

    var
        EmpVar: Record Employee;
}
