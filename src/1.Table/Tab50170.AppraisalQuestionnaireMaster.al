table 50170 "Appraisal Questionnaire Master"
{
    Caption = 'Appraisal Questionnaire Master';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Question"; Text[250])
        {
            Caption = 'Question';
            DataClassification = CustomerContent;
        }
        field(3; "Question Type"; Enum "Question Type")
        {
            Caption = 'Question Type';
            DataClassification = CustomerContent;
        }
        field(4; "Appraisal Template"; Code[50])
        {
            TableRelation = "Appraisal Setup".Code where(Type = filter("Appraisal Template"));
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}