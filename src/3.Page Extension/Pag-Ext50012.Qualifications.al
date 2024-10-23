pageextension 50012 Qualifications extends Qualifications
{
    layout
    {
        addafter(Code)
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type field.';
                trigger OnValidate()
                begin
                    CurrPage.Update;
                end;
            }
            field("Qualification Type"; Rec."Qualification Type")
            {
                ApplicationArea = All;
                Editable = QualificationTypeEditable;
                ToolTip = 'Specifies the value of the Qualification Type field.';
            }
            field(Rank; Rec.Rank)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rank field.';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        //>>condition for Qualification Type
        if Rec.Type = Rec.Type::Work then
            QualificationTypeEditable := false
        else
            QualificationTypeEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //>>getting filter and assigning it on new record
        TypeText := Rec.GetFilter(Rec.Type);
        case TypeText of
            Format(Rec.Type::Education):
                Rec.Type := Rec.Type::Education;

            Format(Rec.Type::Work):
                Rec.Type := Rec.Type::Work;
        end;

        QualText := Rec.GetFilter("Qualification Type");
        case QualText of
            Format(Rec."Qualification Type"::"+2"):
                Rec."Qualification Type" := Rec."Qualification Type"::"+2";

            Format(Rec."Qualification Type"::"Bachelor''s"):
                Rec."Qualification Type" := Rec."Qualification Type"::"Bachelor''s";

            Format(Rec."Qualification Type"::"Master''s"):
                Rec."Qualification Type" := Rec."Qualification Type"::"Master''s";

            Format(Rec."Qualification Type"::SLC):
                Rec."Qualification Type" := Rec."Qualification Type"::SLC;
        end;
    end;

    var
        QualificationTypeEditable: Boolean;
        TypeText: Text;
        QualText: Text;
}
