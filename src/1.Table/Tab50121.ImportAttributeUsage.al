table 50121 "Import Attribute Usage"
{
    Caption = 'Import Payroll Attribute Usage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then
                    Validate("Employee Name", Employee."Full Name");
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            TableRelation = "Payroll Attributes";
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(7; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(8; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        Rec.Validate("Entry No.", HRMgt.GetNextEntryNo(Database::"Import Attribute Usage"));
    end;

    trigger OnDelete()
    begin
        if Posted then
            Error('Cannot delete posted record');
    end;

    procedure PostAttributeUsage(ImportAttributes: Record "Import Attribute Usage")
    var
        PayrollAttributeUsage: Record "Payroll Attributes Usage";
    begin
        if PayrollAttributeUsage.Get(ImportAttributes."Attribute Code", ImportAttributes."Employee No.") then
            PayrollAttributeUsage.Delete();

        PayrollAttributeUsage.Init();
        PayrollAttributeUsage.Validate(Code, ImportAttributes."Attribute Code");
        PayrollAttributeUsage.Validate("Employee Code", ImportAttributes."Employee No.");
        PayrollAttributeUsage.Validate(Amount, ImportAttributes.Amount);
        PayrollAttributeUsage.Validate("Start Date", ImportAttributes."Start Date");
        PayrollAttributeUsage.Validate("End Date", ImportAttributes."End Date");
        PayrollAttributeUsage.Insert();

        ImportAttributes.Posted := true;
        ImportAttributes.Modify()
    end;
}
