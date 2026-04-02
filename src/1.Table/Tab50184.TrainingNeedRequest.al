table 50184 "Training Need Request"
{
    Caption = 'Training Need Request';
    DataCaptionFields = "Entry No.", "Employee No.", Description;
    LookupPageId = "Training Need List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee where(Status = const(Active));

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then begin
                    Validate("Employee Name", Employee."Full Name");
                    Validate("Department Code", Employee."Department Code");
                    Validate("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
                end else begin
                    Clear("Employee Name");
                    Clear("Department Code");
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Department Code"; Code[100])
        {
            Caption = 'Department Code';
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            Editable = false;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Training Description / Topic';
        }
        field(6; "Training Nature"; Enum "Training Nature")
        {
            Caption = 'Training Nature';
        }
        field(7; "Training Type"; Text[250])
        {
            Caption = 'Training Type';
        }
        field(8; "Requested Date"; Date)
        {
            Caption = 'Requested Date';

            trigger OnValidate()
            begin
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Requested Date"));
            end;
        }
        field(9; "Fiscal Year"; Text[10])
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(10; Justification; Text[2000])
        {
            Caption = 'Justification / Business Need';
        }
        field(11; Status; Enum "Approval Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(12; "Compiled By"; Code[20])
        {
            Caption = 'Compiled By';
            TableRelation = Employee where(Status = const(Active));
            Editable = false;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Compiled By") then
                    Validate("Compiled By Name", Employee."Full Name")
                else
                    Clear("Compiled By Name");
            end;
        }
        field(13; "Compiled By Name"; Text[100])
        {
            Caption = 'Compiled By Name';
            Editable = false;
        }
        field(14; "Compiled Date"; Date)
        {
            Caption = 'Compiled Date';
            Editable = false;
        }
        field(15; "HR Remarks"; Text[500])
        {
            Caption = 'HR Remarks';
        }
        field(16; "Linked Training No."; Code[20])
        {
            Caption = 'Linked Training No.';
            TableRelation = "Training Header";
        }
        field(17; Priority; Enum "Training Need Priority")
        {
            Caption = 'Priority';
        }
    }

    keys
    {
        key(Key1; "Entry No.") { Clustered = true; }
        key(Key2; "Employee No.", "Fiscal Year") { }
        key(Key3; Status, "Fiscal Year") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        Validate("Requested Date", Today);
        Validate("Employee No.", HRMgt.GetEmployeeNo());
        Validate("Entry No.", GetEntryNo())
    end;

    var
        HRMgt: Codeunit "HR Mgt.";

    procedure Compile(CompiledBy: Code[20])
    begin
        TestField(Status, Status::Pending);
        Validate(Status, Status::Approved);
        Validate("Compiled By", CompiledBy);
        Validate("Compiled Date", Today);
        Modify(true);
    end;

    procedure GetEntryNo(): Integer
    var
        TrainingNeedRequest: Record "Training Need Request";
    begin
        TrainingNeedRequest.Reset();
        if TrainingNeedRequest.FindLast() then
            exit(TrainingNeedRequest."Entry No." + 1)
        else
            exit(1);
    end;
}
