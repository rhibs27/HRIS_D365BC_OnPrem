table 50176 "Reviewer Weightage Setup"
{
    Caption = 'Reviewer Weightage Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Appraisal Template"; Code[20])
        {
            Caption = 'Appraisal Template';
        }
        field(2; "Fiscal Year"; Code[20])
        {
            Caption = 'Fiscal Year';
        }
        field(3; "Reviewer Type"; Code[20])
        {
            Caption = 'Reviewer Type';
            TableRelation = "Reviewer Setup".Code;

        }
        field(4; Sequence; Integer)
        {
            Caption = 'Sequence';
        }
        field(5; Weightage; Decimal)
        {
            Caption = 'Weightage';
        }
        field(6; "Approver Role"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Approval Role";
        }
        field(7; "Deputation Type"; Enum "Deputation Type")
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Appraisal Template", "Fiscal Year", "Reviewer Type")
        {
            Clustered = true;
        }
    }
}
