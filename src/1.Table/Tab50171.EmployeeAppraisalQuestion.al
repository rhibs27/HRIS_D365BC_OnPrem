table 50171 "Employee Appraisal Question"
{
    Caption = 'Employee Appraisal Questionnaire';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2; "Appraisal Code"; Code[20])
        {
            Caption = 'Appraisal Code';
            DataClassification = CustomerContent;
        }
        field(3; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            DataClassification = CustomerContent;
        }
        field(4; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(5; "Question"; Text[500])
        {
            Caption = 'Question';
            DataClassification = CustomerContent;
        }
        field(6; "Question Type"; Enum "Question Type")
        {
            Caption = 'Question Type';
            DataClassification = CustomerContent;
        }
        field(7; "Comment"; Text[500])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(8; "Yes/No"; Option)
        {
            Caption = 'Yes/No';
            DataClassification = CustomerContent;
            OptionMembers = " ",Yes,No;
            OptionCaption = ' ,Yes,No';
        }
        field(9; "Reviewer Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Reviewer Code"; Code[20])
        {
            Caption = 'Reviewer Code';
            Editable = false;
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Appraisal Code", "Employee Code", "Line No.")
        {
            Clustered = true;
        }
    }
}