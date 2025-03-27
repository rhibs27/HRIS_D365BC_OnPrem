tableextension 50012 "Document Attachment Ext" extends "Document Attachment"
{
    fields
    {
        field(50000; "Attachment Document Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                //>>clearing the related field on validation
            end;
        }
        // field(50001; "Qualification Doc. No."; Code[20])
        // {
        //     TableRelation = Qualification WHERE("Type" = FIELD("Qualification Doc. Type"), "Qualification Type" = FIELD("Qualification Level"));
        //     DataClassification = ToBeClassified;
        // }
        // field(50002; "Qualification Level"; Enum "Qualification Type")
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     begin
        //         //>>clearing the related field on validation
        //         // if not ("Qualification Level" = xRec."Qualification Level") then
        //         //     Clear("Qualification Doc. No.");
        //     end;
        // }
    }
}
