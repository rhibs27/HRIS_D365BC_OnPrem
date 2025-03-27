table 50105 "Promotion Eligibilty Criteria"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level".Code;
        }
        field(2; "Appraisal Remarks"; Text[30])
        {
            TableRelation = "Rating Setup".Remarks where(Type = const(Appraisal));
        }
        field(3; "Services Experience"; Decimal)
        {
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Salary Level", "Appraisal Remarks") { }
    }

    fieldgroups { }
}
