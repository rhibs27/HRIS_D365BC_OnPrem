table 50005 "Employee Payroll Adjustment"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Payroll Document No."; Code[20]) { }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then
                    Validate("Employee Name", Employee."Full Name")
                else
                    Clear("Employee Name");
            end;
        }
        field(3; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Attribute Code"; Code[20])
        {
            TableRelation = "Payroll Attributes";

            trigger OnValidate()
            begin
                TestField("Employee No.");

                if PayrollAttributes.Get("Attribute Code") then
                    Validate("Attributes Description", PayrollAttributes.Description)
                else
                    Clear("Attributes Description");
            end;
        }
        field(5; "Attributes Description"; Text[50])
        {
            Editable = false;
        }
        field(6; Amount; Decimal) { }
    }

    keys
    {
        key(Key1; "Payroll Document No.", "Employee No.", "Attribute Code") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        TestField("Employee No.");
        if PayrollHeader.Get("Payroll Document No.") then
            if PayrollHeader."OverTime From" = 0D then
                TestField("Attribute Code");
    end;

    trigger OnDelete()
    begin
        UnmarkAssignmentLeaveEarn("Payroll Document No.", "Employee No.", "Attribute Code");
    end;

    var
        Employee: Record Employee;
        PayrollAttributes: Record "Payroll Attributes";
        PayrollHeader: Record "Payroll Header";

    local procedure UnmarkAssignmentLeaveEarn(PayrollDocNo: Code[20]; EmployeeCode: Code[20]; AttributeCode: Code[20])
    var
        LeaveEarn: Record "Leave Earn";
    begin
        LeaveEarn.SetRange("Employee No.", EmployeeCode);
        LeaveEarn.SetFilter("Payroll Document No", PayrollDocNo);
        LeaveEarn.SetRange("Payroll Attribute", AttributeCode);
        LeaveEarn.ModifyAll("Payroll Document No", '');
    end;


}
