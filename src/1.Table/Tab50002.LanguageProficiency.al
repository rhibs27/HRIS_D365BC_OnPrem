table 50002 "Language Proficiency"
{
    Caption = 'Language Proficiency';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            Editable = false;
            TableRelation = Employee;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Language; Text[20])
        {
            Caption = 'Language';
            TableRelation = Language;
            trigger OnValidate()
            var
                LanguageProficiency: Record "Language Proficiency";
            begin
                If Language = '' then
                    Error('Language Cannot be blank');
                LanguageProficiency.Reset();
                LanguageProficiency.SetRange("Employee Code", "Employee Code");
                LanguageProficiency.SetRange(Language, Language);
                if LanguageProficiency.FindFirst() then
                    Error('You cannot Add Same Language Twice');
            end;
        }
        field(4; Speaking; Enum "Language Rating")
        {
            Caption = 'Speaking';
        }
        field(5; Reading; Enum "Language Rating")
        {
            Caption = 'Reading';
        }
        field(6; Writing; Enum "Language Rating")
        {
            Caption = 'Writing';
        }
        field(7; Typing; Enum "Language Rating")
        {
            Caption = 'Typing';
        }
        field(301; "Access Token"; code[50])
        {
            caption = 'Access Token';
            DataClassification = CustomerContent;

        }

    }
    keys
    {
        key(PK; "Employee Code", "Line No.")
        {
            Clustered = true;
        }
    }
}
