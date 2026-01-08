table 50115 "Employee Feedback"
{
    Caption = 'Employee Feedback';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(3; Question; Text[250])
        {
            Editable = false;
        }
        field(4; "Answers Text"; Text[250]) { }
        field(5; "Line No."; Integer) { }
        field(6; "Question Code"; Code[20]) { }
        field(7; Type; Enum "Employee Question Type") { }
        field(8; "Sub Type"; Enum "Employee Question SubType") { }
        field(9; Answer; Enum "Employee FeedBack")
        {
            trigger OnValidate()
            begin
                case Answer of
                    Answer::"Strongly Agree":
                        Validate(Marks, 5);

                    Answer::Agree:
                        Validate(Marks, 4);

                    Answer::Netural:
                        Validate(Marks, 3);

                    Answer::Disagree:
                        Validate(Marks, 2);

                    Answer::"Strongly Disagree":
                        Validate(Marks, 1);

                    else
                        Validate(Marks, 0);
                end;
            end;
        }
        field(10; Marks; Decimal)
        {
            Editable = false;
        }
        field(11; "Answer II"; Text[100]) { }
        field(12; "Is Subjective"; Boolean) { }
        field(13; Posted; Boolean)
        {
            trigger OnValidate()
            begin
                if Posted then begin
                    "Posted By" := UserId;
                    "Posted Date" := Today;
                end;
            end;
        }
        field(14; "Posted By"; Text[50])
        {
            Editable = false;
        }
        field(15; "Posted Date"; Date)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code", "Line No.", "Employee No.") { }
    }

    fieldgroups { }

    trigger OnModify()
    begin
        if xRec.Posted then
            Error('Record is already submitted.');
    end;
}
