table 50119 "Service Inactivity Ledger"
{
    Caption = 'Service Inactivity Ledger';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No") then begin
                    "Employee Name" := Employee."Full Name";
                end else begin
                    "Employee Name" := '';
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            trigger OnValidate()
            var
                DateValidataionError: Label 'Start Date must be less than or equal to End Date.';
            begin
                if ("Start Date" <> 0D) and ("End Date" <> 0D) then begin
                    if ("Start Date" > "End Date") then
                        Error(DateValidataionError);
                end;
            end;

        }
        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
            trigger OnValidate()
            var
                DateValidataionError: Label 'Start Date must be less than or equal to End Date.';
            begin
                if ("Start Date" <> 0D) and ("End Date" <> 0D) then begin
                    if ("Start Date" > "End Date") then
                        Error(DateValidataionError);
                end;
            end;
        }
        field(6; "No of days"; Integer)
        {
            Caption = 'No of days';
        }
        field(7; "Source Doc No"; Code[20])
        {
            Caption = 'Source Doc No';
        }
        field(8; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
