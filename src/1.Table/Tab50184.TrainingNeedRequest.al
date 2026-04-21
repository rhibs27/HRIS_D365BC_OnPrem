table 50184 "Training Need Request"
{
    Caption = 'Training Need Request';
    DataCaptionFields = "Entry No.", "Employee No.", "Training Name";
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
                    Validate("Deputation On", Employee."Deputation on");
                    Validate("Deputation Code", Employee."Deputation On Code");
                    Validate("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
                end else begin
                    Clear("Employee Name");
                    Clear("Deputation On");
                    Clear("Deputation Code");
                    Clear("Fiscal Year");
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Training Category"; Code[20])
        {
            Caption = 'Training Category';
            TableRelation = "Training Master".Code where("Master Type" = filter("Training Setup Type"::"Training Category"));
        }

        field(5; "Training Code"; Code[20])
        {
            Caption = 'Training Code';
            TableRelation = "Training Master".Code where("Master Type" = filter("Training Setup Type"::" "));
            trigger OnValidate()
            var
                TrainingMaster: Record "Training Master";
            begin
                if TrainingMaster.Get("Training Code") then
                    Validate("Training Name", TrainingMaster.Description)
                else
                    Clear("Training Name");
            end;
        }
        field(6; "Training Name"; Text[250])
        {
            Caption = 'Training Description / Topic';
            Editable = false;
        }
        field(7; "Deputation On"; Enum "Deputation Type")
        {
            Caption = 'Deputation On';
            Editable = false;
        }
        field(8; "Deputation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Organization Structure List".Code where(Type = field("Deputation On"));
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
        field(18; "Requested Date"; Date)
        {
            Caption = 'Requested Date';

            trigger OnValidate()
            begin
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Requested Date"));
            end;
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
