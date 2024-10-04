tableextension 50012 "Document Attachment Ext" extends "Document Attachment"
{
    fields
    {
        field(50000; "Qualification Doc. Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Education,Work;
            OptionCaption = ' ,Education,Work';
            trigger OnValidate()
            begin
                //>>clearing the related field on validation
                if not ("Qualification Doc. Type" = xRec."Qualification Doc. Type") then begin
                    Clear("Qualification Doc. No.");
                    Clear("Qualification Level");
                end;
            end;
        }
        field(50001; "Qualification Doc. No."; Code[20])
        {
            // TableRelation = Qualification WHERE("Type" = FIELD("Qualification Doc. Type"),"Qualification Type" = FIELD("Qualification Level")); todo
            DataClassification = ToBeClassified;
        }
        field(50002; "Qualification Level"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",SLC,"+2",Bachelor,Master;
            OptionCaption = ' ,SLC,+2,Bachelor,Master';
            trigger OnValidate()
            begin
                //>>clearing the related field on validation
                if not ("Qualification Level" = xRec."Qualification Level") then
                    Clear("Qualification Doc. No.");
            end;
        }
    }
}
