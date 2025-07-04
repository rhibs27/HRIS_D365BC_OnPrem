table 50144 "Recruitment Cue"
{
    Caption = 'Recruitment Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Total Posted Vacancy"; Integer)
        {
            CalcFormula = count("Vacancy Header" where(posted = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Total Internal Vacancy"; Integer)
        {
            CalcFormula = count("Vacancy Header" where(Type = const(1)));
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
