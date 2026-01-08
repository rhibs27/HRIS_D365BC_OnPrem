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
        field(2; "KRA Master"; Code[50])
        {
            TableRelation = "Appraisal KRA Master".Code where(Type = filter("KRA Master"));
        }
        field(3; "Question"; Text[250])
        {
            Caption = 'Question';
            DataClassification = CustomerContent;
        }
        field(4; "Question Type"; Enum "Question Type")
        {
            Caption = 'Question Type';
            DataClassification = CustomerContent;
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