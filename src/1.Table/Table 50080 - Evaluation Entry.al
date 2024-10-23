table 50080 "Evaluation Entry"
{
    DataClassification = CustomerContent;
    // version HRM1.00

    fields
    {
        field(1; "Vacancy Code"; Code[20])
        {
            TableRelation = "Vacancy Header";
        }
        field(2; "No."; Code[20])
        {
            TableRelation = if (Type = filter(Interview | "Written Exam" | "Group Discussion")) Candidate."No."
            else
            Employee;

            trigger OnValidate()
            begin
                //IF Type IN [Type::"Group Discussion",Type::Interview,Type::"Written Exam"] THEN BEGIN
                Candidate.Reset;
                Candidate.SetRange("No.", "No.");
                Candidate.SetRange("Vacancy Code", "Vacancy Code");
                if Candidate.FindFirst then
                    Validate(Name, Candidate.FullName)
                else
                    Validate(Name, '');
                //END;
            end;
        }
        field(3; Type; Enum "Evaluation Entry Type")
        {

        }
        field(4; "Attribute Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Evaluation Attribute".Code;

            trigger OnValidate()
            begin
                EvaAttribute.Reset;
                EvaAttribute.SetRange(Code, "Attribute Code");
                if EvaAttribute.FindFirst then begin
                    Validate("Attribute Description", EvaAttribute.Description);
                    Validate("Is Remarks", EvaAttribute."Is Remarks");
                    Validate("Full Marks", EvaAttribute."Full Marks");
                    Validate("Is Remark Option", EvaAttribute."Is Remarks Options");
                end else begin
                    Validate("Attribute Description", '');
                    Validate("Is Remarks", false);
                    Validate("Is Remark Option", false);
                    Validate("Full Marks", 0);
                end;
            end;
        }
        field(5; "Attribute Description"; Text[250])
        {
            Editable = false;
        }
        field(6; "Interviewer Code"; Code[20])
        {
            TableRelation = if (Type = const(Interview)) Employee."No.";
        }
        field(7; "Interviewer Name"; Text[50])
        {
            TableRelation = if (Type = const(Interview)) "Rating Scale".Code where(Type = const(Interview))
            else if (Type = const(Probation)) "Rating Scale".Code where(Type = const(Probation))
            else if (Type = const("KPI (Common)")) "Rating Scale".Code where(Type = const("KPI (Common)"))
            else if (Type = const("KPI (Below AM)")) "Rating Scale".Code where(Type = const("KPI (Below AM)"))
            else if (Type = const("KPI (AM & Above)")) "Rating Scale".Code where(Type = const("KPI (AM & Above)"));
            ValidateTableRelation = false;
        }
        field(8; Marks; Decimal)
        {
            trigger OnValidate()
            begin
                if Marks > "Full Marks" then
                    Error('Marks %1 cannot be greater than full marks %2', Marks, "Full Marks");
            end;
        }
        field(9; "Job Title Code"; Code[20]) { }
        field(10; "Job Level Code"; Code[20]) { }
        field(11; "User ID"; Code[50]) { }
        field(12; "Modified Date"; Date) { }
        field(13; Posted; Boolean) { }
        field(14; Name; Text[50])
        {
            Editable = false;
        }
        field(15; Submitted; Boolean) { }
        field(16; Remarks; Text[250]) { }
        field(17; "Is Remarks"; Boolean) { }
        field(18; "Full Marks"; Decimal) { }
        field(19; "Is Remark Option"; Boolean) { }
    }

    keys
    {
        key(Key1; "No.", "Attribute Code", Type, "Interviewer Code") { }
    }

    fieldgroups { }

    trigger OnModify()
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        if Employee.FindFirst then
            if not Employee.Screener then
                TestField(Posted, false);
        "User ID" := UserId;
        "Modified Date" := Today;
    end;

    var
        EvaAttribute: Record "Evaluation Attribute";
        Candidate: Record Candidate;
        Employee: Record Employee;

    procedure PostDocument(var EvaluationEntry: Record "Evaluation Entry")
    var
        Posted: Label 'Document has been posted.';
        Nothing: Label 'Nothing to post.';
        WantToPost: Label 'Do you want to post the lines?';
    begin
        EvaluationEntry.SetRange(Posted, false);
        if EvaluationEntry.Count = 0 then begin
            Message(Nothing);
            exit;
        end;
        if not Confirm(WantToPost, false) then
            exit;

        EvaluationEntry.ModifyAll(Posted, true);
        Message(Posted);
    end;

    procedure ReOpenLines(var EvaluationEntry: Record "Evaluation Entry")
    var
        ReOpened: Label 'Lines has been reopened.';
        Nothing: Label 'Nothing to reopen.';
        WantToReopen: Label 'Do you want to reopen the lines?';
    begin
        EvaluationEntry.SetRange(Posted, true);
        if EvaluationEntry.Count = 0 then begin
            Message(Nothing);
            exit;
        end;
        if not Confirm(WantToReopen, false) then
            exit;
        EvaluationEntry.ModifyAll(Posted, false);
        Message(ReOpened);
    end;
}
