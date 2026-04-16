table 50115 "Employee Feedback"
{
    Caption = 'Employee Feedback';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Training No."; Code[20]) { }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(3; Question; Text[250])
        {
            Editable = false;
        }
        field(4; "Answers Text"; Text[250]) { }
        field(5; "Question Code"; Code[20]) { }
        field(7; Type; Enum "Employee Question Type") { }
        field(8; "Sub Type"; Enum "Employee Question SubType") { }
        field(9; Answer; Enum "Employee FeedBack")
        {
            trigger OnValidate()
            begin
                case Answer of
                    Answer::"Poor":
                        Validate(Marks, 1);

                    Answer::Satisfactory:
                        Validate(Marks, 2);

                    Answer::Good:
                        Validate(Marks, 3);

                    Answer::"Very Good":
                        Validate(Marks, 4);

                    Answer::Excellent:
                        Validate(Marks, 5);

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
        field(16; "Trainer Name"; Text[100])
        {
        }
        field(17; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Training No.", "Question Code", "Employee No.", "Line No.") { }
    }

    fieldgroups { }

    trigger OnModify()
    begin
        if xRec.Posted then
            Error('Record is already submitted.');
    end;
}
