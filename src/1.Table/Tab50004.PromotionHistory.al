table 50004 "Promotion History"
{
    DataClassification = CustomerContent;
    // version To Delete

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                    Validate("Previous Salary Level Code", Employee."Salary Level");
                    Validate("Previous Salary Grade", Employee."Salary Grade");
                    Validate("Employee Name", Employee."Full Name");
                    Validate("Previous Functional Title", Employee."Functional Title");
                end else begin
                    Validate("Previous Salary Level Code", '');
                    Validate("Previous Salary Grade", '');
                    Validate("Employee Name", '');
                    Validate("Previous Functional Title", '')
                end;
            end;
        }
        field(2; "Line No."; Integer) { }
        field(3; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Previous Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";

            trigger OnValidate()
            begin
                if SalaryLevel.Get("Previous Salary Level Code") then
                    Validate("Previous Salary Level Desc.", SalaryLevel.Description)
                else
                    Clear("Previous Salary Level Desc.");
            end;
        }
        field(5; "Previous Salary Grade"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Grade";

            trigger OnValidate()
            begin
                if SalaryGrade.Get("Previous Salary Grade") then
                    Validate("Previous Salary Grade Desc.", SalaryGrade.Description)
                else
                    Clear("Previous Salary Grade Desc.");
            end;
        }
        field(6; "Previous Salary Level Desc."; Text[50])
        {
            Editable = false;
        }
        field(7; "Previous Salary Grade Desc."; Text[50])
        {
            Editable = false;
        }
        field(8; "Promoted Salary Level Code"; Code[20])
        {
            TableRelation = "Salary Level";

            trigger OnValidate()
            begin
                if SalaryLevel.Get("Promoted Salary Level Code") then
                    Validate("Promoted Salary Level Desc.", SalaryLevel.Description)
                else
                    Clear("Promoted Salary Level Desc.");
            end;
        }
        field(9; "Promoted Salary Grade"; Code[20])
        {
            TableRelation = "Salary Grade";

            trigger OnValidate()
            begin
                if SalaryGrade.Get("Promoted Salary Grade") then
                    Validate("Promoted Salary Grade Desc.", SalaryGrade.Description)
                else
                    Clear("Promoted Salary Grade Desc.");
            end;
        }
        field(10; "Promoted Salary Level Desc."; Text[50])
        {
            Editable = false;
        }
        field(11; "Promoted Salary Grade Desc."; Text[50])
        {
            Editable = false;
        }
        field(12; "Promoted Date"; Date) { }
        field(13; "Created Date Time"; DateTime)
        {
            Editable = false;
        }
        field(14; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(15; "Previous Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";

            trigger OnValidate()
            begin
                if FunctionalTitle.Get("Previous Functional Title") then
                    Validate("Previous Functional Desc.", FunctionalTitle.Description)
                else
                    Clear("Previous Functional Desc.");
            end;
        }
        field(16; "Previous Functional Desc."; Text[100]) { }
        field(17; "Promoted Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";

            trigger OnValidate()
            begin
                if FunctionalTitle.Get("Promoted Functional Title") then
                    Validate("Promoted Functional Desc.", FunctionalTitle.Description)
                else
                    Clear("Promoted Functional Desc.");
            end;
        }
        field(18; "Promoted Functional Desc."; Text[100]) { }
        field(19; Remarks; Text[250]) { }
    }

    keys
    {
        key(Key1; "Employee No.", "Line No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Created Date Time" := CurrentDateTime;
        "Created By" := HRMgt.GetEmployeeNo;
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        Employee: Record Employee;
        FunctionalTitle: Record "Functional Title";
}
