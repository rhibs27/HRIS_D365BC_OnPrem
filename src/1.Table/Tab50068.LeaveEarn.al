table 50068 "Leave Earn"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";

            trigger OnValidate()
            begin
                if LeaveTypeVar.Get("Leave Code") then
                    Validate("Leave Description", LeaveTypeVar.Description)
                else
                    Clear("Leave Description");
            end;
        }
        field(3; "Leave Description"; Text[50]) { }
        field(4; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then
                    Validate("Employee Full Name", EmpVar."Full Name")
                else
                    Clear("Employee Full Name");
            end;
        }
        field(5; "Employee Full Name"; Text[50])
        {
        }
        field(6; "Fiscal year"; Text[10])
        {
        }
        field(7; "Posted Date"; Date)
        {
        }
        field(8; "Balancing Days"; Decimal)
        {
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; Type; Enum "Leave Earn Type")
        {
        }
        field(11; "Leave Request No"; Code[20])
        {
            Editable = false;
        }
        field(12; Remarks; Text[50]) { }
        field(13; Closed; Boolean) { }
        field(14; "Overtime Request No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Overtime Date"; Date)
        {
            Caption = 'Overtime Date';
            DataClassification = ToBeClassified;
        }
        field(16; "Payroll Posted"; Boolean)
        {
            Caption = 'Payroll Posted';
            DataClassification = ToBeClassified;
        }
        field(17; "Payroll Document No"; Code[20])
        {
            Caption = 'Payroll Document No';
            DataClassification = ToBeClassified;
        }
        field(18; "Payroll Attribute"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(19; "Encashment Amount"; Decimal)
        {
            Caption = 'Encashment Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Encashment Amount" <> 0 then begin
                    TestField(Type, Type::Encashed);
                    TestField("Payroll Attribute");
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
    end;

    trigger OnInsert()
    begin
    end;

    var
        EmpVar: Record Employee;
        LeaveTypeVar: Record "Leave Type Setup";
        HRSetup: Record "Human Resources Setup";
        HrMgt: Codeunit "HR Mgt.";

    procedure PostLeaveEarn(TempLeaveEarn: Record "Leave Earn" temporary)
    var
        LeaveEarn: Record "Leave Earn";
        LeaveMgt: Codeunit "Leave Mgt.";
    begin
        LeaveEarn.Init;
        LeaveEarn.TransferFields(TempLeaveEarn);
        LeaveEarn."Entry No." := LeaveMgt.GetNextLeaveLedgerEntryNo();
        LeaveEarn."Fiscal year" := HrMgt.ReturnFiscalYear(Today);
        LeaveEarn."Posted Date" := Today;
        LeaveEarn.Type := LeaveEarn.Type::Earned;
        LeaveEarn.Insert(true);

        Message('Leave balance added successfully.');
    end;
}
