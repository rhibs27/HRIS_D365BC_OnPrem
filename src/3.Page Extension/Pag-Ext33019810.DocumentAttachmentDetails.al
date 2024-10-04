pageextension 33019810 "Document Attachment Details" extends "Document Attachment Details"
{
    layout
    {
        addafter("Document Flow Sales")
        {
            field("Qualification Doc. Type"; Rec."Qualification Doc. Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qualification Doc. Type field.';
                trigger OnValidate()

                begin
                    CurrPage.Update;
                end;
            }
            field("Qualification Level"; Rec."Qualification Level")
            {
                ApplicationArea = All;
                Editable = QualificationLevelEditable;
                ToolTip = 'Specifies the value of the Qualification Level field.';
            }
            field("Qualification Doc. No."; Rec."Qualification Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qualification Doc. No. field.';
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean

    begin
        QualificationLevelEditable := true //Qualification Level Editable on condition
    end;

    trigger OnAfterGetRecord()

    begin
        //>>Qualification Level Editable on condition
        if Rec."Qualification Doc. Type" = Rec."Qualification Doc. Type"::Work then
            QualificationLevelEditable := false
        else
            QualificationLevelEditable := true;
    end;

    var
        QualificationLevelEditable: Boolean;
}
