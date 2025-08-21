table 50079 Interviewer
{
    DataClassification = CustomerContent;
    // version HRM1.00
    fields
    {
        field(1; "Vacancy Code"; Code[20])
        {
            Enabled = true;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(2; Interviewer; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                /*
                Employee.Reset();
                Employee.SetRange("NAV Login ID", Interviewer);
                IF Employee.FindFirst() THEN
                  "Employee Code" := Employee."No."
                ELSE
                  "Employee Code" := '';
                */
                if Employee.Get(Interviewer) then begin
                    "Interviewer Fullname" := Employee."Full Name";
                    "Interviewer Email" := Employee."Company E-Mail";
                end else begin
                    Clear("Interviewer Fullname");
                    Clear("Interviewer Email Sent");
                end;
            end;
        }
        field(3; Sequence; Integer) { }
        field(4; "Interview Date"; Date) { }
        field(5; "Interview Time"; Time) { }
        field(6; "Candidate No."; Code[20]) { }
        field(7; "Interviewer Email Sent"; Boolean) { }
        field(8; "Interviewer Fullname"; Text[50]) { }
        field(9; "Interviewer Email"; Text[150]) { }
    }

    keys
    {
        key(Key1; "Vacancy Code", Interviewer) { }
        key(Key2; Sequence) { }
    }

    fieldgroups { }

    var
        Employee: Record Employee;

    procedure OnOpenEvaluationList()
    begin
        /*
        TestField("Candidate No.");

        EvalutionAttribute.Reset();
        EvalutionAttribute.SetRange("Attribute Type", EvalutionAttribute."Attribute Type"::Interview);
        IF EvalutionAttribute.FindFirst() THEN begin
          repeat
            EvaluationEntry.Reset();
            EvaluationEntry.SetRange("Vacancy Code", "Vacancy Code");
            EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
            EvaluationEntry.SetRange("No.", "Candidate No.");
            EvaluationEntry.SetRange("Attribute Code", EvalutionAttribute.Code);
            IF NOT EvaluationEntry.FindFirst() THEN begin
              EvaluationEntry.INIT;
              EvaluationEntry."No." := "Candidate No.";
              EvaluationEntry."Attribute Code"  := EvalutionAttribute.Code;
              EvaluationEntry."Attribute Description" := EvalutionAttribute.Description;
              EvaluationEntry.Type := EvaluationEntry.Type::Interview;
              EvaluationEntry."Attribute Description" := EvalutionAttribute.Description;
              EvaluationEntry."Vacancy Code" := "Vacancy Code";
              EvaluationEntry.INSERT;
           end;
          until EvalutionAttribute.NEXT = 0;
          COMMIT;
          EvaluationEntry.Reset();
          EvaluationEntry.SetRange(Type, EvaluationEntry.Type::Interview);
          EvaluationEntry.SetRange("No.", "Candidate No.");
          CLEAR(EvaluationPage);
          {
          EvaluationPage.SetInterviewerName("Vacancy Code", "Candidate No.");
          EvaluationPage.SETTABLEVIEW(EvaluationEntry);
          EvaluationPage.RUNMODAL;
          }
        end;
        */
    end;
}
