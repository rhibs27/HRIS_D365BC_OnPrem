table 50112 "Grade Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                EmpRec.Get("Employee No.");
                Validate("Employee Name", EmpRec."Full Name");
            end;
        }
        field(3; "Employee Name"; Text[50]) { }
        field(5; Grade; Code[20])
        {
            TableRelation = "Salary Grade";
        }
        field(7; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(8; "Posting Date"; Date) { }
        field(10; "Total Grade Percentage"; Decimal)
        {
            Editable = false;
            Description = 'Default garde + appraisal grade';
        }
        field(11; "Default Grade Percentage"; Decimal)
        {
            trigger OnValidate()
            begin
                GetTotalGradepercentage();
            end;
        }
        field(12; "Appraisal Grade Percentage"; Decimal)
        {
            trigger OnValidate()
            begin
                GetTotalGradepercentage();
            end;
        }
        field(13; "Fiscal Year"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        GetEntryNo;
    end;

    var
        EmpRec: Record Employee;

    local procedure GetEntryNo()
    var
        GradeEntry: Record "Grade Entry";
    begin
        GradeEntry.Reset;
        GradeEntry.SetCurrentKey("Entry No.");
        if GradeEntry.FindLast then
            "Entry No." := GradeEntry."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    local procedure GetTotalGradepercentage()
    begin
        "Total Grade Percentage" := "Default Grade Percentage" + "Appraisal Grade Percentage";
    end;
}
