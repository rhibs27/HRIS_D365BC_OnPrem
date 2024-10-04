table 33019913 "Employee Feedback Portal"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Feedback No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "Feedback No." <> '' then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Portal Feedback No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Feedback Text"; Text[250]) { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Attachment; Text[80]) { }
        field(6; "Posted Date"; Date) { }
        field(7; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Feedback No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Posted Date" := Today;

        if "Feedback No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Portal Feedback No.");
            NoSeriesMgt.InitSeries(HRSetup."Portal Feedback No.", xRec."No. Series", "Posted Date", "Feedback No.", "No. Series");
        end;

        EmpVar.Reset;
        EmpVar.SetRange("NAV Login ID", UserId);
        if EmpVar.FindFirst then begin
            Validate("Employee No.", EmpVar."No.");
            Validate("Employee Name", EmpVar."Full Name");
        end;
    end;

    var
        EmpVar: Record Employee;
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
