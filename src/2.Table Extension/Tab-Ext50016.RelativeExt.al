tableextension 50016 "Relative Ext" extends Relative
{
    fields
    {
        field(50000; "Relation (In Nepali)"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'In Nepali';
        }
        field(50001; "Male Corres. Relation (Nepali)"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'In Nepali';
        }
        field(50002; "FemaleCorres. Relation(Nepali)"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'In Nepali';
        }
        field(50003; "Relation"; Enum Relation)
        {
            DataClassification = ToBeClassified;
        }
    }
}
